`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DCPU
// Description: 5级流水线CPU - 支持MIPS 54条指令
//              - 数据前推(Forwarding)处理数据冒险
//              - 延迟槽(Delay Slot)处理控制冒险
//              - 精确异常处理CP0协处理器
//
// 流水线级: IF -> ID -> EX -> MEM -> WB
//////////////////////////////////////////////////////////////////////////////////

module DCPU(
    input clk,
    input rst,
    input ena,                      // CPU使能信号 (1: 运行, 0: 暂停)
    input intr,                     // 外部中断
    output [31:0] PC_out,
    output [31:0] instr_out,
    output [31:0] reg28             // 调试用：28号寄存器值
);

    // ==================== 参数定义 ====================
    parameter OP_RTYPE = 6'b000000;
    parameter FUNC_SLL = 6'b000000;
    parameter FUNC_SRL = 6'b000010;
    parameter FUNC_SRA = 6'b000011;

    // ====================================================================================
    //                                 IF 取指 (Instruction Fetch)
    // ====================================================================================
    reg [31:0] PC;                  // 程序计数器
    wire [31:0] PC_plus_4;          // PC + 4
    wire [31:0] PC_next;            // 下一跳PC值
    wire [31:0] IF_instr;           // 取出的指令
    
    // PC + 4
    assign PC_plus_4 = PC + 4;
    
    // 指令存储器
    IMEM imem(
        .PC(PC),
        .Instr(IF_instr)
    );
    
    // ====================================================================================
    //                              IF/ID 流水线寄存器
    // ====================================================================================
    reg [31:0] IF_ID_PC;            // PC值
    reg [31:0] IF_ID_instr;         // 指令

    // ====================================================================================
    //                                 ID 译码 (Instruction Decode)
    // ====================================================================================
    // 指令字段
    wire [5:0]  ID_opcode, ID_funct;
    wire [4:0]  ID_rs, ID_rt, ID_rd, ID_shamt;
    wire [15:0] ID_imm;
    wire [25:0] ID_addr;
    wire [31:0] ID_imm_sign_ext, ID_imm_zero_ext;
    
    // 控制信号
    wire ID_reg_write, ID_mem_read, ID_mem_write, ID_mem_to_reg;
    wire ID_alu_src, ID_sign_ext;
    wire [1:0] ID_reg_dst;
    wire [3:0] ID_alu_op;
    wire [4:0] ID_write_reg;
    wire ID_is_branch, ID_is_jump, ID_is_jr, ID_is_link;
    wire [2:0] ID_branch_type;
    wire ID_is_shift, ID_is_shift_v;
    wire ID_is_mdu_op, ID_is_mfhi, ID_is_mflo, ID_is_mthi, ID_is_mtlo;
    wire [1:0] ID_mdu_op;
    wire ID_is_mfc0, ID_is_mtc0, ID_is_eret;
    wire ID_is_syscall, ID_is_break, ID_is_teq;
    
    // 寄存器读出数据
    wire [31:0] ID_rs_data, ID_rt_data;
    wire [31:0] ID_rs_data_fwd, ID_rt_data_fwd;
    
    // ==================== 控制器实例 ====================
    Controller controller(
        .instr(IF_ID_instr),
        .opcode(ID_opcode),
        .funct(ID_funct),
        .rs(ID_rs),
        .rt(ID_rt),
        .rd(ID_rd),
        .shamt(ID_shamt),
        .imm(ID_imm),
        .addr(ID_addr),
        .imm_sign_ext(ID_imm_sign_ext),
        .imm_zero_ext(ID_imm_zero_ext),
        .reg_write(ID_reg_write),
        .mem_read(ID_mem_read),
        .mem_write(ID_mem_write),
        .mem_to_reg(ID_mem_to_reg),
        .alu_src(ID_alu_src),
        .reg_dst(ID_reg_dst),
        .alu_op(ID_alu_op),
        .write_reg(ID_write_reg),
        .sign_ext(ID_sign_ext),
        .is_branch(ID_is_branch),
        .is_jump(ID_is_jump),
        .is_jr(ID_is_jr),
        .is_link(ID_is_link),
        .branch_type(ID_branch_type),
        .is_shift(ID_is_shift),
        .is_shift_v(ID_is_shift_v),
        .is_mdu_op(ID_is_mdu_op),
        .mdu_op(ID_mdu_op),
        .is_mfhi(ID_is_mfhi),
        .is_mflo(ID_is_mflo),
        .is_mthi(ID_is_mthi),
        .is_mtlo(ID_is_mtlo),
        .is_mfc0(ID_is_mfc0),
        .is_mtc0(ID_is_mtc0),
        .is_eret(ID_is_eret),
        .is_syscall(ID_is_syscall),
        .is_break(ID_is_break),
        .is_teq(ID_is_teq)
    );
    
    // 符号扩展
    wire [31:0] ID_imm_ext = ID_sign_ext ? ID_imm_sign_ext : ID_imm_zero_ext;
    
    // 分支/跳转目标计算
    wire [31:0] branch_target;
    wire [31:0] jump_target;
    assign branch_target = IF_ID_PC + 4 + (ID_imm_ext << 2);
    assign jump_target   = {IF_ID_PC[31:28], ID_addr, 2'b00};

    // ====================================================================================
    //                              ID/EX 流水线寄存器
    // ====================================================================================
    reg [31:0] ID_EX_PC;
    reg [31:0] ID_EX_rs_data, ID_EX_rt_data;
    reg [31:0] ID_EX_imm_ext;
    reg [4:0]  ID_EX_rs, ID_EX_rt, ID_EX_rd;
    reg [4:0]  ID_EX_shamt;
    reg [5:0]  ID_EX_opcode, ID_EX_funct;
    reg        ID_EX_reg_write, ID_EX_mem_read, ID_EX_mem_write, ID_EX_mem_to_reg;
    reg        ID_EX_alu_src;
    reg [3:0]  ID_EX_alu_op;
    reg [4:0]  ID_EX_write_reg;
    reg        ID_EX_is_shift, ID_EX_is_shift_v;
    reg        ID_EX_is_mdu_op, ID_EX_is_mfhi, ID_EX_is_mflo, ID_EX_is_mthi, ID_EX_is_mtlo;
    reg [1:0]  ID_EX_mdu_op;
    reg        ID_EX_is_link;
    reg        ID_EX_is_mfc0, ID_EX_is_mtc0, ID_EX_is_eret;
    reg        ID_EX_is_syscall, ID_EX_is_break, ID_EX_is_teq;

    // ====================================================================================
    //                              HI/LO 寄存器
    // ====================================================================================
    reg [31:0] HI_reg, LO_reg;
    wire [31:0] MDU_HI, MDU_LO;
    wire MDU_busy;

    // ====================================================================================
    //                                 EX 执行 (Execution)
    // ====================================================================================
    wire [31:0] EX_alu_input_a, EX_alu_input_b;
    wire [31:0] EX_alu_result;
    wire EX_zero, EX_carry, EX_negative, EX_overflow;
    wire [31:0] EX_rs_data_fwd, EX_rt_data_fwd;
    
    // ALU输入选择
    wire EX_is_shift_instr = (ID_EX_opcode == OP_RTYPE) && 
                             ((ID_EX_funct == FUNC_SLL) || (ID_EX_funct == FUNC_SRL) || (ID_EX_funct == FUNC_SRA));
    
    assign EX_alu_input_a = ID_EX_is_shift ? {27'b0, ID_EX_shamt} :
                            ID_EX_is_shift_v ? EX_rs_data_fwd[4:0] :
                            EX_rs_data_fwd;
    assign EX_alu_input_b = ID_EX_alu_src ? ID_EX_imm_ext : EX_rt_data_fwd;
    
    // ALU实例
    ALU alu(
        .a(EX_alu_input_a),
        .b(ID_EX_is_shift_v ? EX_rt_data_fwd : EX_alu_input_b),
        .aluc(ID_EX_alu_op),
        .r(EX_alu_result),
        .zero(EX_zero),
        .carry(EX_carry),
        .negative(EX_negative),
        .overflow(EX_overflow)
    );
    
    // MDU实例
    MDU mdu(
        .clk(clk),
        .rst(rst),
        .start(ID_EX_is_mdu_op && !MDU_busy),
        .A(EX_rs_data_fwd),
        .B(EX_rt_data_fwd),
        .MDUc(ID_EX_mdu_op),
        .HI(MDU_HI),
        .LO(MDU_LO),
        .busy(MDU_busy)
    );
    
    // HI/LO寄存器写入逻辑
    // 单周期MDU：在EX阶段结束时直接写入结果
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            HI_reg <= 32'b0;
            LO_reg <= 32'b0;
        end else if (ID_EX_is_mdu_op) begin
            HI_reg <= MDU_HI;
            LO_reg <= MDU_LO;
        end else if (ID_EX_is_mthi) begin
            HI_reg <= EX_rs_data_fwd;
        end else if (ID_EX_is_mtlo) begin
            LO_reg <= EX_rs_data_fwd;
        end
    end
    
    // EX阶段结果选择
    wire [31:0] EX_result = ID_EX_is_mfhi ? HI_reg :
                            ID_EX_is_mflo ? LO_reg :
                            ID_EX_is_link ? (ID_EX_PC + 8) :
                            EX_alu_result;

    // ====================================================================================
    //                              EX/MEM 流水线寄存器
    // ====================================================================================
    reg [31:0] EX_MEM_alu_result;
    reg [31:0] EX_MEM_rt_data;
    reg [31:0] EX_MEM_PC;
    reg [4:0]  EX_MEM_write_reg;
    reg [4:0]  EX_MEM_rd;
    reg        EX_MEM_reg_write;
    reg        EX_MEM_mem_read, EX_MEM_mem_write, EX_MEM_mem_to_reg;
    reg [5:0]  EX_MEM_opcode;
    reg        EX_MEM_is_mfc0, EX_MEM_is_mtc0, EX_MEM_is_eret;
    reg        EX_MEM_is_syscall, EX_MEM_is_break, EX_MEM_is_teq;

    // ====================================================================================
    //                                 MEM 访存 (Memory Access)
    // ====================================================================================
    wire [31:0] MEM_read_data;
    
    // 内存操作类型
    wire [2:0] mem_op;
    assign mem_op = (EX_MEM_opcode == 6'b100011) ? 3'b000 :  // LW
                    (EX_MEM_opcode == 6'b100000) ? 3'b001 :  // LB
                    (EX_MEM_opcode == 6'b100100) ? 3'b010 :  // LBU
                    (EX_MEM_opcode == 6'b100001) ? 3'b011 :  // LH
                    (EX_MEM_opcode == 6'b100101) ? 3'b100 :  // LHU
                    (EX_MEM_opcode == 6'b101011) ? 3'b101 :  // SW
                    (EX_MEM_opcode == 6'b101000) ? 3'b110 :  // SB
                    (EX_MEM_opcode == 6'b101001) ? 3'b111 :  // SH
                    3'b000;
    
    // 数据存储器
    DMEM dmem(
        .clk(clk),
        .addr(EX_MEM_alu_result),
        .data_in(EX_MEM_rt_data),
        .we(EX_MEM_mem_write && ena),
        .re(EX_MEM_mem_read),
        .mem_op(mem_op),
        .data_out(MEM_read_data)
    );
    
    // ====================================================================================
    //                              CP0 协处理器
    // ====================================================================================
    wire [31:0] CP0_rdata, CP0_status, CP0_exc_addr;
    wire CP0_exception = EX_MEM_is_syscall | EX_MEM_is_break | 
                         (EX_MEM_is_teq && (EX_MEM_alu_result == 0));
    wire [4:0] CP0_cause = EX_MEM_is_syscall ? 5'd8 :
                           EX_MEM_is_break   ? 5'd9 :
                           EX_MEM_is_teq     ? 5'd13 : 5'd0;
    
    CPO cp0(
        .clk(clk),
        .rst(rst),
        .mfc0(EX_MEM_is_mfc0),
        .mtc0(EX_MEM_is_mtc0 && ena),
        .eret(EX_MEM_is_eret && ena),
        .exception(CP0_exception && ena),
        .cause(CP0_cause),
        .intr(intr),
        .pc(EX_MEM_PC),
        .Rd(EX_MEM_rd),
        .wdata(EX_MEM_rt_data),
        .rdata(CP0_rdata),
        .status(CP0_status),
        .timer_int(),
        .exc_addr(CP0_exc_addr)
    );

    // ====================================================================================
    //                              MEM/WB 流水线寄存器
    // ====================================================================================
    reg [31:0] MEM_WB_alu_result;
    reg [31:0] MEM_WB_mem_data;
    reg [31:0] MEM_WB_cp0_data;
    reg [4:0]  MEM_WB_write_reg;
    reg        MEM_WB_reg_write;
    reg        MEM_WB_mem_to_reg;
    reg        MEM_WB_is_mfc0;

    // ====================================================================================
    //                                 WB 写回 (Write Back)
    // ====================================================================================
    wire [31:0] WB_write_data;
    assign WB_write_data = MEM_WB_is_mfc0   ? MEM_WB_cp0_data :
                           MEM_WB_mem_to_reg ? MEM_WB_mem_data : 
                           MEM_WB_alu_result;
    
    // 寄存器堆
    RegFile regfile(
        .clk(clk),
        .rst(rst),
        .ena(1'b1),
        .we(MEM_WB_reg_write && ena),
        .Rdc(MEM_WB_write_reg),
        .Rsc(ID_rs),
        .Rtc(ID_rt),
        .Rd(WB_write_data),
        .Rs(ID_rs_data),
        .Rt(ID_rt_data),
        .reg28(reg28)
    );

    // ====================================================================================
    //                              数据前推单元 (ForwardUnit)
    // ====================================================================================
    ForwardUnit forward_unit(
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rs_data(ID_rs_data),
        .ID_rt_data(ID_rt_data),
        .ID_EX_rs(ID_EX_rs),
        .ID_EX_rt(ID_EX_rt),
        .ID_EX_rs_data(ID_EX_rs_data),
        .ID_EX_rt_data(ID_EX_rt_data),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .EX_MEM_reg_write(EX_MEM_reg_write),
        .EX_MEM_mem_read(EX_MEM_mem_read),
        .EX_MEM_alu_result(EX_MEM_alu_result),
        .MEM_WB_write_reg(MEM_WB_write_reg),
        .MEM_WB_reg_write(MEM_WB_reg_write),
        .WB_write_data(WB_write_data),
        .ID_rs_data_fwd(ID_rs_data_fwd),
        .ID_rt_data_fwd(ID_rt_data_fwd),
        .EX_rs_data_fwd(EX_rs_data_fwd),
        .EX_rt_data_fwd(EX_rt_data_fwd)
    );

    // ====================================================================================
    //                              冒险检测单元 (HazardUnit)
    // ====================================================================================
    wire stall;
    wire branch_taken;
    
    HazardUnit hazard_unit(
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rs_data_fwd(ID_rs_data_fwd),
        .ID_rt_data_fwd(ID_rt_data_fwd),
        .ID_is_branch(ID_is_branch),
        .ID_branch_type(ID_branch_type),
        .ID_is_mdu_op(ID_is_mdu_op),
        .ID_is_mfhi(ID_is_mfhi),
        .ID_is_mflo(ID_is_mflo),
        .ID_EX_write_reg(ID_EX_write_reg),
        .ID_EX_reg_write(ID_EX_reg_write),
        .ID_EX_mem_read(ID_EX_mem_read),
        .ID_EX_is_mdu_op(ID_EX_is_mdu_op),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .EX_MEM_reg_write(EX_MEM_reg_write),
        .EX_MEM_mem_read(EX_MEM_mem_read),
        .MDU_busy(MDU_busy),
        .stall(stall),
        .branch_taken(branch_taken)
    );

    // ====================================================================================
    //                              PC更新逻辑
    // ====================================================================================
    // 下一跳PC选择优先级：异常 > eret > jr > jump > branch > PC+4
    // PC异常处理向量地址 exception > eret > jr > jump > branch > PC+4
    wire exc_occur = CP0_exception && !stall;
    wire eret_occur = EX_MEM_is_eret && !stall;
    
    assign PC_next = exc_occur    ? 32'h00400004 :
                     eret_occur   ? CP0_exc_addr :
                     ID_is_jr     ? ID_rs_data_fwd :
                     ID_is_jump   ? jump_target :
                     branch_taken ? branch_target :
                     PC_plus_4;
    
    // PC寄存器更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'h00400000;
        end 
        else if (ena && !stall) begin
            PC <= PC_next;
        end
        // stall或!ena时PC保持不变
    end

    // ====================================================================================
    //                              IF/ID 流水线寄存器更新
    // ====================================================================================
    // 如果stall则保持不变，如果有flush信号(如分支预测失败)则清空
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_PC    <= 32'h00400000;
            IF_ID_instr <= 32'h00000000;  // NOP
        end 
        else if (ena && !stall) begin
            IF_ID_PC    <= PC;
            IF_ID_instr <= IF_instr;
        end
        // stall或!ena保持不变
    end

    // ====================================================================================
    //                              ID/EX 流水线寄存器更新
    // ====================================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_EX_PC        <= 32'h00400000;
            ID_EX_rs_data   <= 32'b0;
            ID_EX_rt_data   <= 32'b0;
            ID_EX_imm_ext   <= 32'b0;
            ID_EX_rs        <= 5'b0;
            ID_EX_rt        <= 5'b0;
            ID_EX_rd        <= 5'b0;
            ID_EX_shamt     <= 5'b0;
            ID_EX_opcode    <= 6'b0;
            ID_EX_funct     <= 6'b0;
            ID_EX_reg_write <= 1'b0;
            ID_EX_mem_read  <= 1'b0;
            ID_EX_mem_write <= 1'b0;
            ID_EX_mem_to_reg <= 1'b0;
            ID_EX_alu_src   <= 1'b0;
            ID_EX_alu_op    <= 4'b0;
            ID_EX_write_reg <= 5'b0;
            ID_EX_is_shift  <= 1'b0;
            ID_EX_is_shift_v <= 1'b0;
            ID_EX_is_mdu_op <= 1'b0;
            ID_EX_mdu_op    <= 2'b0;
            ID_EX_is_mfhi   <= 1'b0;
            ID_EX_is_mflo   <= 1'b0;
            ID_EX_is_mthi   <= 1'b0;
            ID_EX_is_mtlo   <= 1'b0;
            ID_EX_is_link   <= 1'b0;
            ID_EX_is_mfc0   <= 1'b0;
            ID_EX_is_mtc0   <= 1'b0;
            ID_EX_is_eret   <= 1'b0;
            ID_EX_is_syscall <= 1'b0;
            ID_EX_is_break  <= 1'b0;
            ID_EX_is_teq    <= 1'b0;
        end 
        else if (ena && (stall || exc_occur)) begin
            // Stall或异常发生时插入气泡(NOP)
            ID_EX_reg_write <= 1'b0;
            ID_EX_mem_read  <= 1'b0;
            ID_EX_mem_write <= 1'b0;
            ID_EX_write_reg <= 5'b0;
            ID_EX_is_mdu_op <= 1'b0;
            ID_EX_is_mfc0   <= 1'b0;
            ID_EX_is_mtc0   <= 1'b0;
            ID_EX_is_eret   <= 1'b0;
            ID_EX_is_syscall <= 1'b0;
            ID_EX_is_break  <= 1'b0;
            ID_EX_is_teq    <= 1'b0;
        end 
        else if (ena) begin
            ID_EX_PC        <= IF_ID_PC;
            ID_EX_rs_data   <= ID_rs_data_fwd;
            ID_EX_rt_data   <= ID_rt_data_fwd;
            ID_EX_imm_ext   <= ID_imm_ext;
            ID_EX_rs        <= ID_rs;
            ID_EX_rt        <= ID_rt;
            ID_EX_rd        <= ID_rd;
            ID_EX_shamt     <= ID_shamt;
            ID_EX_opcode    <= ID_opcode;
            ID_EX_funct     <= ID_funct;
            ID_EX_reg_write <= ID_reg_write;
            ID_EX_mem_read  <= ID_mem_read;
            ID_EX_mem_write <= ID_mem_write;
            ID_EX_mem_to_reg <= ID_mem_to_reg;
            ID_EX_alu_src   <= ID_alu_src;
            ID_EX_alu_op    <= ID_alu_op;
            ID_EX_write_reg <= ID_write_reg;
            ID_EX_is_shift  <= ID_is_shift;
            ID_EX_is_shift_v <= ID_is_shift_v;
            ID_EX_is_mdu_op <= ID_is_mdu_op;
            ID_EX_mdu_op    <= ID_mdu_op;
            ID_EX_is_mfhi   <= ID_is_mfhi;
            ID_EX_is_mflo   <= ID_is_mflo;
            ID_EX_is_mthi   <= ID_is_mthi;
            ID_EX_is_mtlo   <= ID_is_mtlo;
            ID_EX_is_link   <= ID_is_link;
            ID_EX_is_mfc0   <= ID_is_mfc0;
            ID_EX_is_mtc0   <= ID_is_mtc0;
            ID_EX_is_eret   <= ID_is_eret;
            ID_EX_is_syscall <= ID_is_syscall;
            ID_EX_is_break  <= ID_is_break;
            ID_EX_is_teq    <= ID_is_teq;
        end
    end

    // ====================================================================================
    //                              EX/MEM 流水线寄存器更新
    // ====================================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_MEM_alu_result <= 32'b0;
            EX_MEM_rt_data    <= 32'b0;
            EX_MEM_PC         <= 32'b0;
            EX_MEM_write_reg  <= 5'b0;
            EX_MEM_rd         <= 5'b0;
            EX_MEM_reg_write  <= 1'b0;
            EX_MEM_mem_read   <= 1'b0;
            EX_MEM_mem_write  <= 1'b0;
            EX_MEM_mem_to_reg <= 1'b0;
            EX_MEM_opcode     <= 6'b0;
            EX_MEM_is_mfc0    <= 1'b0;
            EX_MEM_is_mtc0    <= 1'b0;
            EX_MEM_is_eret    <= 1'b0;
            EX_MEM_is_syscall <= 1'b0;
            EX_MEM_is_break   <= 1'b0;
            EX_MEM_is_teq     <= 1'b0;
        end 
        else if (ena) begin
            EX_MEM_alu_result <= EX_result;
            EX_MEM_rt_data    <= EX_rt_data_fwd;
            EX_MEM_PC         <= ID_EX_PC;
            EX_MEM_write_reg  <= ID_EX_write_reg;
            EX_MEM_rd         <= ID_EX_rd;
            EX_MEM_reg_write  <= ID_EX_reg_write;
            EX_MEM_mem_read   <= ID_EX_mem_read;
            EX_MEM_mem_write  <= ID_EX_mem_write;
            EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
            EX_MEM_opcode     <= ID_EX_opcode;
            EX_MEM_is_mfc0    <= ID_EX_is_mfc0;
            EX_MEM_is_mtc0    <= ID_EX_is_mtc0;
            EX_MEM_is_eret    <= ID_EX_is_eret;
            EX_MEM_is_syscall <= ID_EX_is_syscall;
            EX_MEM_is_break   <= ID_EX_is_break;
            EX_MEM_is_teq     <= ID_EX_is_teq;
        end
    end

    // ====================================================================================
    //                              MEM/WB 流水线寄存器更新
    // ====================================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB_alu_result <= 32'b0;
            MEM_WB_mem_data   <= 32'b0;
            MEM_WB_cp0_data   <= 32'b0;
            MEM_WB_write_reg  <= 5'b0;
            MEM_WB_reg_write  <= 1'b0;
            MEM_WB_mem_to_reg <= 1'b0;
            MEM_WB_is_mfc0    <= 1'b0;
        end 
        else if (ena) begin
            MEM_WB_alu_result <= EX_MEM_alu_result;
            MEM_WB_mem_data   <= MEM_read_data;
            MEM_WB_cp0_data   <= CP0_rdata;
            MEM_WB_write_reg  <= EX_MEM_write_reg;
            MEM_WB_reg_write  <= EX_MEM_reg_write;
            MEM_WB_mem_to_reg <= EX_MEM_mem_to_reg;
            MEM_WB_is_mfc0    <= EX_MEM_is_mfc0;
        end
    end

    // ====================================================================================
    //                              输出赋值
    // ====================================================================================
    assign PC_out    = PC;
    assign instr_out = IF_instr;

endmodule
