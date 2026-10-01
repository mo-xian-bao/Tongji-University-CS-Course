`include "defines.vh"

module id( 
    input wire                     rst, 
    input wire[`InstAddrBus]       pc_i, 
    input wire[`InstBus]           inst_i, 
    
    // 处于执行阶段的指令的一些信息，用于解决 load 相关
    input wire[`AluOpBus]		   ex_aluop_i,
    
    // 读取的 Regfile 的值 
    input wire[`RegBus]            reg1_data_i, 
    input wire[`RegBus]            reg2_data_i, 
    
    /* 解决先写后读 */
    // 处于执行阶段的指令的运算结果 
    input wire                ex_wreg_i, 
    input wire[`RegBus]       ex_wdata_i, 
    input wire[`RegAddrBus]   ex_wd_i, 
    
    // 处于访存阶段的指令的运算结果 
    input wire                mem_wreg_i, 
    input wire[`RegBus]       mem_wdata_i, 
    input wire[`RegAddrBus]   mem_wd_i, 
    
    // 如果上一条指令是转移指令，那么下一条指令进入译码阶段的时候，输入变量 
    // is_in_delayslot_i 为 true，表示是延迟槽指令，反之，为 false 
    input wire                     is_in_delayslot_i,
    
    output reg                     next_inst_in_delayslot_o, 
        
    output reg                     branch_flag_o,             // 是否发生转移
    output reg[`RegBus]            branch_target_address_o,   // 转移到的目标地址
    output reg[`RegBus]            link_addr_o,               // 转移指令要保存的返回地址
    output reg                     is_in_delayslot_o,         // 当前处于译码阶段的指令是否位于延迟槽 
    
    // 输出到 Regfile 的信息 
    output reg                     reg1_read_o, 
    output reg                     reg2_read_o,      
    output reg[`RegAddrBus]        reg1_addr_o, 
    output reg[`RegAddrBus]        reg2_addr_o,  
    
    // 送到执行阶段的信息 
    output reg[`AluOpBus]          aluop_o, 
    output reg[`AluSelBus]         alusel_o, 
    output reg[`RegBus]            reg1_o,        // 操作数的值
    output reg[`RegBus]            reg2_o, 
    output reg[`RegAddrBus]        wd_o,          // 要写入的目的寄存器地址
    output reg                     wreg_o,        // 是否有要写入的目的寄存器
    
    output wire[`RegBus]           inst_o,        // 用于存取指令
    
    output wire[31:0]              excepttype_o,            // 收集的异常信息 
    output wire[`RegBus]           current_inst_address_o,  // 译码阶段指令的地址 
    
    output wire                    stallreq	
); 

    reg excepttype_is_syscall;  // 是否是系统调用异常 syscall 
    reg excepttype_is_eret;     // 是否是异常返回指令 eret
    
//    reg excepttype_is_break;    // 是否是调试断点指令 break
    
    // 要读取的寄存器 1 是否与上一条指令存在 load 相关
    reg stallreq_for_reg1_loadrelate;
    
    // 要读取的寄存器 2 是否与上一条指令存在 load 相关
    reg stallreq_for_reg2_loadrelate;
    
    // 上一条指令是否是加载指令
    wire pre_inst_is_load;

    // 取得指令的指令码，功能码 
    // 对于 ori 指令只需通过判断第 26-31 bit 的值，即可判断是否是 ori 指令 
    wire[5:0] op  = inst_i[31:26]; 
    wire[4:0] op2 = inst_i[10:6]; 
    wire[5:0] op3 = inst_i[5:0]; 
    wire[4:0] op4 = inst_i[20:16]; 
    
    // 保存指令执行需要的立即数 
    reg[`RegBus] imm;  
    
    // 指示指令是否有效 
    reg instvalid; 
    
    assign stallreq = stallreq_for_reg1_loadrelate | stallreq_for_reg2_loadrelate;
    
    wire[`RegBus] pc_plus_8;           
    wire[`RegBus] pc_plus_4;           
 
    wire[`RegBus] imm_sll2_signedext; 
   
    assign pc_plus_8 = pc_i + 8;    // 保存当前译码阶段指令后面第 2 条指令的地址 
    assign pc_plus_4 = pc_i + 4;    // 保存当前译码阶段指令后面紧接着的指令的地址 
 
    // imm_sll2_signedext 对应分支指令中的 offset 左移两位，再符号扩展至 32 位的值 
    assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00 };
    
    assign inst_o = inst_i;         // inst_o 的值就是译码阶段的指令
    
    // 依据输入信号 ex_aluop_i 的值，判断上一条指令是否是加载指令， 
    // 如果是加载指令，那么置 pre_inst_is_load 为 1，反之置为 0
    assign pre_inst_is_load = ((ex_aluop_i == `EXE_LB_OP)  || 
                               (ex_aluop_i == `EXE_LBU_OP) || 
                               (ex_aluop_i == `EXE_LH_OP)  || 
                               (ex_aluop_i == `EXE_LHU_OP) || 
                               (ex_aluop_i == `EXE_LW_OP)  || 
                               (ex_aluop_i == `EXE_LWR_OP) || 
                               (ex_aluop_i == `EXE_LWL_OP) ||
                               (ex_aluop_i == `EXE_LL_OP)  || 
                               (ex_aluop_i == `EXE_SC_OP)) ? 1'b1 : 1'b0;

    // excepttype_o 的低 8 bit 留给外部中断，第 8 bit 表示是否是 syscall 指令引起的 
    // 系统调用异常，第 9 bit表示是否是无效指令引起的异常，第 12 bit 表示是否是 eret  
    // 指令，eret 指令可以认为是一种特殊的异常--返回异常
    
    // 新增：第 13 bit 表示 是否有断点异常 break
    assign excepttype_o = {19'b0, excepttype_is_eret, 2'b0, instvalid, excepttype_is_syscall, 8'b0};
   
    // 输入信号 pc_i 就是当前处于译码阶段的指令的地址 
    assign current_inst_address_o = pc_i;
    
/**************************************************************** 
***********             第一段：对指令进行译码             ********* 
*****************************************************************/ 
 
    always @ (*) begin  
        if (rst == `RstEnable) begin 
            aluop_o     <= `EXE_NOP_OP; 
            alusel_o    <= `EXE_RES_NOP; 
            wd_o        <= `NOPRegAddr; 
            wreg_o      <= `WriteDisable; 
            instvalid   <= `InstValid; 
            reg1_read_o <= 1'b0; 
            reg2_read_o <= 1'b0; 
            reg1_addr_o <= `NOPRegAddr; 
            reg2_addr_o <= `NOPRegAddr; 
            imm         <= 32'h0;    
            link_addr_o              <= `ZeroWord; 
            branch_target_address_o  <= `ZeroWord; 
            branch_flag_o            <= `NotBranch; 
            next_inst_in_delayslot_o <= `NotInDelaySlot;
        end 
        else begin 
            aluop_o     <= `EXE_NOP_OP; 
            alusel_o    <= `EXE_RES_NOP; 
            wd_o        <= inst_i[15:11]; 
            wreg_o      <= `WriteDisable; 
            instvalid   <= `InstInvalid;     
            reg1_read_o <= 1'b0; 
            reg2_read_o <= 1'b0; 
            reg1_addr_o <= inst_i[25:21];   // 默认通过 Regfile 读端口 1 读取的寄存器地址 
            reg2_addr_o <= inst_i[20:16];   // 默认通过 Regfile 读端口 2 读取的寄存器地址 
            imm <= `ZeroWord;  
            link_addr_o              <= `ZeroWord; 
            branch_target_address_o  <= `ZeroWord; 
            branch_flag_o            <= `NotBranch;  
            next_inst_in_delayslot_o <= `NotInDelaySlot;
            excepttype_is_syscall    <= `False_v;      // 默认没有系统调用异常 
            excepttype_is_eret       <= `False_v;      // 默认不是 eret 指令 
//            excepttype_is_break      <= `False_v;      // 默认不是 break 指令
            instvalid                <= `InstInvalid;  // 默认是无效指令
            
            case (op) 
                `EXE_SPECIAL_INST: begin          // 指令码是 SPECIAL 
                    case (op2) 
                        5'b00000: begin            
                            case (op3)                      // 依据功能码判断是哪种指令 
                                `EXE_OR: begin              // or 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_OR_OP; 
                                    alusel_o    <= `EXE_RES_LOGIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                 end   
                                 `EXE_AND: begin            // and 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_AND_OP; 
                                    alusel_o    <= `EXE_RES_LOGIC;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                 end 
                                `EXE_XOR: begin           // xor 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_XOR_OP; 
                                    alusel_o    <= `EXE_RES_LOGIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                end       
                                `EXE_NOR: begin          // nor 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_NOR_OP; 
                                    alusel_o    <= `EXE_RES_LOGIC; 
                                    reg1_read_o <= 1'b1;
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                end  
                                `EXE_SLLV:    begin       // sllv 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SLL_OP; 
                                    alusel_o    <= `EXE_RES_SHIFT; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                end  
                                `EXE_SRLV:    begin       // srlv 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SRL_OP; 
                                    alusel_o    <= `EXE_RES_SHIFT; 
                                    reg1_read_o <= 1'b1;  
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid;  
                                end 
                                `EXE_SRAV:     begin       // srav 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SRA_OP; 
                                    alusel_o    <= `EXE_RES_SHIFT; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_SYNC: begin          // sync 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_NOP_OP; 
                                    alusel_o    <= `EXE_RES_NOP; 
                                    reg1_read_o <= 1'b0; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_MFHI: begin             // mfhi 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_MFHI_OP; 
                                    alusel_o    <= `EXE_RES_MOVE;  
                                    reg1_read_o <= 1'b0; 
                                    reg2_read_o <= 1'b0; 
                                    instvalid   <= `InstValid;  
                                end
                                `EXE_MFLO: begin              // mflo 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_MFLO_OP; 
                                    alusel_o    <= `EXE_RES_MOVE;  
                                    reg1_read_o <= 1'b0; 
                                    reg2_read_o <= 1'b0; 
                                    instvalid   <= `InstValid;  
                                end
                                `EXE_MTHI: begin               // mthi 指令 
                                    wreg_o      <= `WriteDisable;  
                                    aluop_o     <= `EXE_MTHI_OP; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b0;  
                                    instvalid   <= `InstValid;  
                                end 
                                `EXE_MTLO: begin               // mtlo 指令 
                                    wreg_o      <= `WriteDisable;  
                                    aluop_o     <= `EXE_MTLO_OP; 
                                    reg1_read_o <= 1'b1;  
                                    reg2_read_o <= 1'b0;  
                                    instvalid   <= `InstValid;  
                                end
                                `EXE_MOVN: begin               // movn 指令 
                                    aluop_o     <= `EXE_MOVN_OP; 
                                    alusel_o    <= `EXE_RES_MOVE;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                    // reg2_o 的值就是地址为 rt 的通用寄存器的值 
                                    if(reg2_o != `ZeroWord) begin   
                                        wreg_o <= `WriteEnable; 
                                    end 
                                    else begin 
                                        wreg_o <= `WriteDisable; 
                                    end 
                                end
                                `EXE_MOVZ: begin               // movz指令 
                                    aluop_o     <= `EXE_MOVZ_OP; 
                                    alusel_o    <= `EXE_RES_MOVE;  
                                    reg1_read_o <= 1'b1;  
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                    // reg2_o 的值就是地址为 rt 的通用寄存器的值 
                                    if(reg2_o == `ZeroWord) begin 
                                        wreg_o <= `WriteEnable; 
                                    end 
                                    else begin 
                                        wreg_o <= `WriteDisable; 
                                    end 
                                end
                                `EXE_SLT: begin        // slt 指令 
                                     wreg_o      <= `WriteEnable; 
                                     aluop_o     <= `EXE_SLT_OP; 
                                     alusel_o    <= `EXE_RES_ARITHMETIC; 
                                     reg1_read_o <= 1'b1; 
                                     reg2_read_o <= 1'b1; 
                                     instvalid   <= `InstValid; 
                                end
                                `EXE_SLTU: begin       // sltu 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SLTU_OP; 
                                    alusel_o    <= `EXE_RES_ARITHMETIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_ADD: begin        // add 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_ADD_OP; 
                                    alusel_o    <= `EXE_RES_ARITHMETIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_ADDU: begin      // addu 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_ADDU_OP; 
                                    alusel_o    <= `EXE_RES_ARITHMETIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_SUB: begin       // sub 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SUB_OP; 
                                    alusel_o    <= `EXE_RES_ARITHMETIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_SUBU: begin     // subu 指令 
                                    wreg_o      <= `WriteEnable; 
                                    aluop_o     <= `EXE_SUBU_OP; 
                                    alusel_o    <= `EXE_RES_ARITHMETIC; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_MULT: begin     // mult 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_MULT_OP; 
                                    reg1_read_o <= 1'b1;
                                    reg2_read_o <= 1'b1;  
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_MULTU: begin    // multu 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_MULTU_OP; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1;  
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_DIV: begin      // div 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_DIV_OP; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1;  
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_DIVU: begin     // divu 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_DIVU_OP; 
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1;  
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_JR: begin              // jr 指令 
                                    wreg_o                   <= `WriteDisable; 
                                    aluop_o                  <= `EXE_JR_OP; 
                                    alusel_o                 <= `EXE_RES_JUMP_BRANCH;  
                                    reg1_read_o              <= 1'b1; 
                                    reg2_read_o              <= 1'b0; 
                                    link_addr_o              <= `ZeroWord; 
                                    branch_target_address_o  <= reg1_o; 
                                    branch_flag_o            <= `Branch; 
                                    next_inst_in_delayslot_o <= `InDelaySlot; 
                                    instvalid                <= `InstValid; 
                                end 
                                `EXE_JALR: begin           // jalr 指令 
                                    wreg_o                   <= `WriteEnable; 
                                    aluop_o                  <= `EXE_JALR_OP; 
                                    alusel_o                 <= `EXE_RES_JUMP_BRANCH;  
                                    reg1_read_o              <= 1'b1; 
                                    reg2_read_o              <= 1'b0; 
                                    wd_o                     <= inst_i[15:11]; 
                                    link_addr_o              <= pc_plus_8; 
                                    branch_target_address_o  <= reg1_o; 
                                    branch_flag_o            <= `Branch; 
                                    next_inst_in_delayslot_o <= `InDelaySlot; 
                                    instvalid                <= `InstValid; 
                                end
                                `EXE_TEQ: begin                  // teq 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TEQ_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_TGE: begin                  // tge 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TGE_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end   
                                `EXE_TGEU: begin                 // tgeu 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TGEU_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end  
                                `EXE_TLT: begin                  // tlt 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TLT_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_TLTU: begin                 // tltu 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TLTU_OP; 
                                    alusel_o    <= `EXE_RES_NOP;
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end
                                `EXE_TNE: begin                  // tne 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_TNE_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b1; 
                                    reg2_read_o <= 1'b1; 
                                    instvalid   <= `InstValid; 
                                end 
                                `EXE_SYSCALL: begin              // syscall 指令 
                                    wreg_o      <= `WriteDisable; 
                                    aluop_o     <= `EXE_SYSCALL_OP; 
                                    alusel_o    <= `EXE_RES_NOP;  
                                    reg1_read_o <= 1'b0; 
                                    reg2_read_o <= 1'b0; 
                                    instvalid   <= `InstValid;  
                                    excepttype_is_syscall<= `True_v; 
                                end
//                                `EXE_BREAK: begin               // break 指令
//                                    wreg_o      <= `WriteDisable;
//                                    aluop_o     <= `EXE_BREAK_OP;
//                                    alusel_o    <= `EXE_RES_NOP;
//                                    reg1_read_o <= 1'b0;
//                                    reg2_read_o <= 1'b0;
//                                    instvalid   <= `InstValid;
//                                    excepttype_is_break <= `True_v;
//                                end
                                default: begin 
                                end 
                            endcase 
                        end 
                        default: begin 
                        end 
                    endcase 
                end  
                `EXE_ORI: begin                // ori 指令 
                    // 需要将结果写入目的寄存器，所以 wreg_o 为 WriteEnable 
                    wreg_o      <= `WriteEnable; 
                    // 运算的子类型
                    aluop_o     <= `EXE_OR_OP; 
                    // 运算类型
                    alusel_o    <= `EXE_RES_LOGIC;  
                    // 需要通过 Regfile 的读端口 1 读取寄存器 
                    reg1_read_o <= 1'b1; 
                    // 不需要通过 Regfile 的读端口 2 读取寄存器 
                    reg2_read_o <= 1'b0; 
                    // 指令执行需要的立即数 
                    imm         <= {16'h0, inst_i[15:0]}; 
                    // 指令执行要写的目的寄存器地址 
                    wd_o        <= inst_i[20:16]; 
                    // 是有效指令
                    instvalid   <= `InstValid; 
                end 
                `EXE_ANDI: begin              // andi 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_AND_OP; 
                    alusel_o    <= `EXE_RES_LOGIC; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    imm         <= {16'h0, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid;  
                end 
                `EXE_XORI: begin              // xori 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_XOR_OP; 
                    alusel_o    <= `EXE_RES_LOGIC; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    imm         <= {16'h0, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid;  
                end 
                `EXE_LUI: begin              // lui 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_OR_OP; 
                    alusel_o    <= `EXE_RES_LOGIC;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    imm         <= {inst_i[15:0], 16'h0}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid;  
                end 
                `EXE_PREF: begin             // pref 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_NOP_OP; 
                    alusel_o    <= `EXE_RES_NOP;  
                    reg1_read_o <= 1'b0; 
                    reg2_read_o <= 1'b0; 
                    instvalid   <= `InstValid; 
                end 
                `EXE_SLTI: begin             // slti 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SLT_OP; 
                    alusel_o    <= `EXE_RES_ARITHMETIC;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b0; 
                    imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid; 
                    end 
                `EXE_SLTIU: begin           // sltiu 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SLTU_OP; 
                    alusel_o    <= `EXE_RES_ARITHMETIC;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid; 
                end
                `EXE_ADDI: begin           // addi 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_ADDI_OP; 
                    alusel_o    <= `EXE_RES_ARITHMETIC;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0;
                    imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end
                `EXE_ADDIU: begin            // addiu 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_ADDIU_OP; 
                    alusel_o    <= `EXE_RES_ARITHMETIC;  
                    reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; 
                    imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                    wd_o        <= inst_i[20:16]; 
                    instvalid   <= `InstValid; 
                end
                `EXE_J: begin                 // j 指令 
                    wreg_o                   <= `WriteDisable; 
                    aluop_o                  <= `EXE_J_OP; 
                    alusel_o                 <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o              <= 1'b0;  
                    reg2_read_o              <= 1'b0; 
                    link_addr_o              <= `ZeroWord; 
                    branch_flag_o            <= `Branch; 
                    next_inst_in_delayslot_o <= `InDelaySlot; 
                    instvalid                <= `InstValid; 
                    branch_target_address_o  <= {pc_plus_4[31:28], inst_i[25:0], 2'b00}; 
                end 
                `EXE_JAL: begin               // jal 指令 
                    wreg_o                   <= `WriteEnable; 
                    aluop_o                  <= `EXE_JAL_OP; 
                    alusel_o                 <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o              <= 1'b0; 
                    reg2_read_o              <= 1'b0; 
                    wd_o                     <= 5'b11111; 
                    link_addr_o              <= pc_plus_8 ; 
                    branch_flag_o            <= `Branch; 
                    next_inst_in_delayslot_o <= `InDelaySlot;  
                    instvalid                <= `InstValid; 
                    branch_target_address_o  <= 
                    {pc_plus_4[31:28], inst_i[25:0], 2'b00}; 
                end 
                `EXE_BEQ: begin               // beq指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_BEQ_OP; 
                    alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1; 
                    instvalid   <= `InstValid; 
                    if(reg1_o == reg2_o) begin 
                        branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                        branch_flag_o            <= `Branch; 
                        next_inst_in_delayslot_o <= `InDelaySlot; 
                    end 
                end
                `EXE_BGTZ: begin              // bgtz 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_BGTZ_OP; 
                    alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b0; 
                    instvalid   <= `InstValid;  
                    if((reg1_o[31] == 1'b0) && (reg1_o != `ZeroWord)) begin 
                        branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                        branch_flag_o            <= `Branch; 
                        next_inst_in_delayslot_o <= `InDelaySlot; 
                    end 
                end
                `EXE_BLEZ:       begin        // blez 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_BLEZ_OP; 
                    alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b0; 
                    instvalid   <= `InstValid; 
                    if((reg1_o[31] == 1'b1) || (reg1_o == `ZeroWord)) begin 
                        branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                        branch_flag_o            <= `Branch; 
                        next_inst_in_delayslot_o <= `InDelaySlot; 
                    end 
                end
                `EXE_BNE: begin               // bne 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_BNE_OP; 
                    alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1; 
                    instvalid   <= `InstValid; 
                    if(reg1_o != reg2_o) begin 
                        branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                        branch_flag_o            <= `Branch; 
                        next_inst_in_delayslot_o <= `InDelaySlot; 
                    end 
                end
                `EXE_LB: begin           // lb 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LB_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b0; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end
                `EXE_LBU: begin          // lbu 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LBU_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0;
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end
                `EXE_LH:   begin            // lh 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LH_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end 
                `EXE_LHU: begin          // lhu 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LHU_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end 
                `EXE_LW: begin            // lw 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LW_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b0; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end 
                `EXE_LWL: begin           // lwl 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LWL_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1; 
                    // 只是部分地修改目的寄存器，所以还需要读出目的寄存器，
                    // 与 lwl 指令加载得到的结果进行组合，最终写入目的寄存器
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end
                `EXE_LWR: begin          // lwr 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LWR_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b1; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid; 
                end
                `EXE_LL: begin          // ll 指令
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_LL_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b0; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid;
                end
                `EXE_SB: begin         // sb 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_SB_OP; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1;  
                    instvalid   <= `InstValid; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                end 
                `EXE_SH: begin        // sh 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_SH_OP; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1;  
                    instvalid   <= `InstValid; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                end 
                `EXE_SW: begin        // sw 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_SW_OP; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1;  
                    instvalid   <= `InstValid; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                end 
                `EXE_SWL: begin         // swl 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_SWL_OP; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1;  
                    instvalid   <= `InstValid; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                end 
                `EXE_SWR: begin         // swr 指令 
                    wreg_o      <= `WriteDisable; 
                    aluop_o     <= `EXE_SWR_OP; 
                    reg1_read_o <= 1'b1; 
                    reg2_read_o <= 1'b1;  
                    instvalid   <= `InstValid; 
                    alusel_o    <= `EXE_RES_LOAD_STORE; 
                end
                `EXE_SC:   begin        // sc 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SC_OP; 
                    alusel_o    <= `EXE_RES_LOAD_STORE;  
                    reg1_read_o <= 1'b1;  
                    reg2_read_o <= 1'b1; 
                    wd_o        <= inst_i[20:16];  
                    instvalid   <= `InstValid;  
                    alusel_o    <= `EXE_RES_LOAD_STORE; 
                end
                `EXE_REGIMM_INST:  begin 
                    case (op4) 
                        `EXE_BGEZ: begin     // bgez 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_BGEZ_OP; 
                            alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b0; 
                            instvalid   <= `InstValid; 
                            if(reg1_o[31] == 1'b0) begin 
                                branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                                branch_flag_o            <= `Branch; 
                                next_inst_in_delayslot_o <= `InDelaySlot;  
                            end 
                        end 
                        `EXE_BGEZAL: begin   // bgezal 指令 
                            wreg_o      <= `WriteEnable;  
                            aluop_o     <= `EXE_BGEZAL_OP; 
                            alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            link_addr_o <= pc_plus_8;  
                            wd_o        <= 5'b11111; 
                            instvalid   <= `InstValid; 
                            if(reg1_o[31] == 1'b0) begin 
                                branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                                branch_flag_o            <= `Branch; 
                                next_inst_in_delayslot_o <= `InDelaySlot; 
                            end 
                        end 
                        `EXE_BLTZ: begin     // bltz 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_BLTZ_OP; 
                            alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            instvalid   <= `InstValid; 
                            if(reg1_o[31] == 1'b1) begin 
                                branch_target_address_o  <= pc_plus_4 + imm_sll2_signedext; 
                                branch_flag_o            <= `Branch; 
                                next_inst_in_delayslot_o <= `InDelaySlot; 
                            end 
                        end
                        `EXE_BLTZAL: begin   // bltzal 指令 
                            wreg_o      <= `WriteEnable; 
                            aluop_o     <= `EXE_BLTZAL_OP; 
                            alusel_o    <= `EXE_RES_JUMP_BRANCH;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            link_addr_o <= pc_plus_8; 
                            wd_o        <= 5'b11111;  
                            instvalid   <= `InstValid; 
                            if(reg1_o[31] == 1'b1) begin 
                                branch_target_address_o <= pc_plus_4 + imm_sll2_signedext; 
                                branch_flag_o <= `Branch; 
                                next_inst_in_delayslot_o <= `InDelaySlot; 
                            end 
                        end 
                        `EXE_TEQI: begin               // teqi 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_TEQI_OP; 
                            alusel_o    <= `EXE_RES_NOP;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                            instvalid   <= `InstValid; 
                        end
                        `EXE_TGEI: begin               // tgei 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_TGEI_OP; 
                            alusel_o    <= `EXE_RES_NOP;  
                            reg1_read_o <= 1'b1;  
                            reg2_read_o <= 1'b0;
                            imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                            instvalid   <= `InstValid; 
                        end
                        `EXE_TGEIU:  begin              // tgeiu指令 
                        wreg_o      <= `WriteDisable; 
                        aluop_o     <= `EXE_TGEIU_OP; 
                        alusel_o    <= `EXE_RES_NOP;  
                        reg1_read_o <= 1'b1; 
                        reg2_read_o <= 1'b0; 
                        imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                        instvalid   <= `InstValid; 
                        end 
                        `EXE_TLTI: begin                // tlti 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_TLTI_OP; 
                            alusel_o    <= `EXE_RES_NOP;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                            instvalid   <= `InstValid; 
                        end 
                        `EXE_TLTIU: begin               // tltiu 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_TLTIU_OP; 
                            alusel_o    <= `EXE_RES_NOP;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                            instvalid   <= `InstValid; 
                        end 
                        `EXE_TNEI: begin               // tnei 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_TNEI_OP; 
                            alusel_o    <= `EXE_RES_NOP;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
                            instvalid   <= `InstValid;  
                        end
                        default: begin 
                        end 
                    endcase
                end
                `EXE_SPECIAL2_INST:  begin    // op 等于 SPECIAL2 
                    case ( op3 ) 
                        `EXE_CLZ: begin                         // clz 指令 
                            wreg_o      <= `WriteEnable;  
                            aluop_o     <= `EXE_CLZ_OP; 
                            alusel_o    <= `EXE_RES_ARITHMETIC;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            instvalid   <= `InstValid;  
                        end 
                        `EXE_CLO: begin                          // clo 指令 
                            wreg_o      <= `WriteEnable; 
                            aluop_o     <= `EXE_CLO_OP; 
                            alusel_o    <= `EXE_RES_ARITHMETIC;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b0; 
                            instvalid   <= `InstValid; 
                        end 
                        `EXE_MUL: begin                          // mul 指令 
                            wreg_o      <= `WriteEnable; 
                            aluop_o     <= `EXE_MUL_OP; 
                            alusel_o    <= `EXE_RES_MUL;  
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b1; 
                            instvalid   <= `InstValid; 
                        end 
                        `EXE_MADD:  begin         // madd 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_MADD_OP; 
                            alusel_o    <= `EXE_RES_MUL;  // 不过由于没有要写的通用寄存器，所以此处 alusel_o 的值并没有作用，也可以设置为 EXE_RES_NOP
                            reg1_read_o <= 1'b1; 
                            reg2_read_o <= 1'b1; 
                            instvalid   <= `InstValid; 
                        end
                        `EXE_MADDU:  begin         // maddu 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_MADDU_OP; 
                            alusel_o    <= `EXE_RES_MUL;
                            reg1_read_o <= 1'b1;  
                            reg2_read_o <= 1'b1; 
                            instvalid   <= `InstValid; 
                        end
                        `EXE_MSUB:  begin         // msub 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_MSUB_OP; 
                            alusel_o    <= `EXE_RES_MUL;  
                            reg1_read_o <= 1'b1;  
                            reg2_read_o <= 1'b1; 
                            instvalid   <= `InstValid; 
                        end
                        `EXE_MSUBU:  begin         // msubu 指令 
                            wreg_o      <= `WriteDisable; 
                            aluop_o     <= `EXE_MSUBU_OP; 
                            alusel_o    <= `EXE_RES_MUL;  
                            reg1_read_o <= 1'b1;  
                            reg2_read_o <= 1'b1; 
                            instvalid   <= `InstValid;  
                        end
                        default: begin 
                        end 
                    endcase      //EXE_SPECIAL_INST2 case 
                end
                default: begin 
                end 
            endcase    //case op 
           
            if (inst_i[31:21] == 11'b00000000000) begin 
                if (op3 == `EXE_SLL) begin          // sll 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SLL_OP; 
                    alusel_o    <= `EXE_RES_SHIFT;  
                    reg1_read_o <= 1'b0; 
                    reg2_read_o <= 1'b1; 
                    imm[4:0]    <= inst_i[10:6]; 
                    wd_o        <= inst_i[15:11]; 
                    instvalid   <= `InstValid;  
                end 
                else if ( op3 == `EXE_SRL ) begin   // srl 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SRL_OP; 
                    alusel_o    <= `EXE_RES_SHIFT;  
                    reg1_read_o <= 1'b0; 
                    reg2_read_o <= 1'b1; 
                    imm[4:0]    <= inst_i[10:6]; 
                    wd_o        <= inst_i[15:11]; 
                    instvalid   <= `InstValid;  
                end 
                else if ( op3 == `EXE_SRA ) begin   // sra 指令 
                    wreg_o      <= `WriteEnable; 
                    aluop_o     <= `EXE_SRA_OP; 
                    alusel_o    <= `EXE_RES_SHIFT;  
                    reg1_read_o <= 1'b0; 
                    reg2_read_o <= 1'b1; 
                    imm[4:0]    <= inst_i[10:6]; 
                    wd_o        <= inst_i[15:11]; 
                    instvalid   <= `InstValid;  
                end 
            end  
            
            if(inst_i[31:21] == 11'b01000000000 && inst_i[10:0] == 11'b00000000000)             // 是 mfc0 指令 
            begin 
                aluop_o     <= `EXE_MFC0_OP; 
                alusel_o    <= `EXE_RES_MOVE; 
                wd_o        <= inst_i[20:16]; 
                wreg_o      <= `WriteEnable; 
                instvalid   <= `InstValid;  
                reg1_read_o <= 1'b0; 
                reg2_read_o <= 1'b0; 
            end 
            else if(inst_i[31:21] == 11'b01000000100 && inst_i[10:0] == 11'b00000000000)        // 是 mtc0 指令 
            begin 
                aluop_o     <= `EXE_MTC0_OP; 
                alusel_o    <= `EXE_RES_NOP; 
                wreg_o      <= `WriteDisable; 
                instvalid   <= `InstValid;  
                reg1_read_o <= 1'b1; 
                reg1_addr_o <= inst_i[20:16]; 
                reg2_read_o <= 1'b0; 
            end
            
            if(inst_i == `EXE_ERET) begin           // eret 指令 
                wreg_o      <= `WriteDisable;  
                aluop_o     <= `EXE_ERET_OP; 
                alusel_o    <= `EXE_RES_NOP;  
                reg1_read_o <= 1'b0; 
                reg2_read_o <= 1'b0; 
                instvalid   <= `InstValid;  
                excepttype_is_eret<= `True_v; 
            end
       end       //if 
  end         //always
 
/**************************************************************** 
***********         第二段：确定进行运算的源操作数1        ********* 
*****************************************************************/ 
    
always @ (*) begin 
    stallreq_for_reg1_loadrelate <= `NoStop;
    if(rst == `RstEnable) begin 
        reg1_o <= `ZeroWord; 
    end 
    else if(pre_inst_is_load == 1'b1 && ex_wd_i == reg1_addr_o && reg1_read_o == 1'b1) begin
		stallreq_for_reg1_loadrelate <= `Stop;							
    end
    else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin 
        reg1_o <= ex_wdata_i;  
    end 
    //1．如果 Regfile 模块读端口 1 要读取的寄存器就是执行阶段要写的目的寄存器， 
    //   那么直接把执行阶段的结果 ex_wdata_i 作为 reg1_o 的值; 
    else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin 
        reg1_o <= mem_wdata_i;     
    end
    //2．如果 Regfile 模块读端口 1 要读取的寄存器就是访存阶段要写的目的寄存器， 
    //   那么直接把访存阶段的结果 mem_wdata_i 作为 reg1_o 的值;
    else if(reg1_read_o == 1'b1) begin 
        reg1_o <= reg1_data_i;     // Regfile 读端口 1 的输出值 
    end 
    else if(reg1_read_o == 1'b0) begin 
        reg1_o <= imm;             // 立即数 
    end 
    else begin 
        reg1_o <= `ZeroWord; 
    end 
end 

/**************************************************************** 
***********         第三段：确定进行运算的源操作数2        ********* 
*****************************************************************/ 

always @ (*) begin 
    stallreq_for_reg2_loadrelate <= `NoStop;
    if(rst == `RstEnable) begin 
        reg2_o <= `ZeroWord; 
    end 
    else if(pre_inst_is_load == 1'b1 && ex_wd_i == reg2_addr_o && reg2_read_o == 1'b1) begin
		stallreq_for_reg2_loadrelate <= `Stop;			
	end
    else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin 
        reg2_o <= ex_wdata_i;  
    end 
    //1．如果 Regfile 模块读端口 2 要读取的寄存器就是执行阶段要写的目的寄存器， 
    //   那么直接把执行阶段的结果 ex_wdata_i 作为 reg2_o 的值; 
    else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin 
        reg2_o <= mem_wdata_i;    
    end
    //2．如果 Regfile 模块读端口 2 要读取的寄存器就是访存阶段要写的目的寄存器， 
    //   那么直接把访存阶段的结果 mem_wdata_i 作为 reg2_o 的值;
    else if(reg2_read_o == 1'b1) begin 
        reg2_o <= reg2_data_i;    // Regfile 读端口 2 的输出值 
    end 
    else if(reg2_read_o == 1'b0) begin 
        reg2_o <= imm;            // 立即数 
    end 
    else begin 
        reg2_o <= `ZeroWord; 
    end 
end 

// 输出变量 is_in_delayslot_o 表示当前译码阶段指令是否是延迟槽指令 
always @ (*) begin 
    if(rst == `RstEnable) begin 
        is_in_delayslot_o <= `NotInDelaySlot; 
    end else begin 
    // 直接等于 is_in_delayslot_i 
        is_in_delayslot_o <= is_in_delayslot_i;  
    end 
end

endmodule