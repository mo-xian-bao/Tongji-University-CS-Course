`timescale 1ns / 1ps

module Controller(
    // ==================== 输入信号 ====================
    input [31:0] instr,              // 32位指令
    
    // ==================== 指令译码输出 ====================
    output [5:0]  opcode,            // 操作码
    output [5:0]  funct,             // 功能码(R型)
    output [4:0]  rs,                // 源寄存器1
    output [4:0]  rt,                // 源寄存器2
    output [4:0]  rd,                // 目的寄存器(R型)
    output [4:0]  shamt,             // 移位量
    output [15:0] imm,               // 立即数
    output [25:0] addr,              // 跳转地址
    output [31:0] imm_sign_ext,      // 立即数符号扩展
    output [31:0] imm_zero_ext,      // 立即数零扩展
    
    // ==================== 控制信号输出 ====================
    output reg_write,                // 寄存器堆写使能
    output mem_read,                 // 存储器读使能
    output mem_write,                // 存储器写使能
    output mem_to_reg,               // 写回数据来源(0:ALU, 1:MEM)
    output alu_src,                  // ALU源操作数选择(0:rt, 1:imm)
    output [1:0] reg_dst,            // 写回寄存器选择(00:rt, 01:rd, 10:$31, 11:$ra)
    output [3:0] alu_op,             // ALU操作码
    output [4:0] write_reg,          // 写回寄存器号
    output sign_ext,                 // 符号扩展控制(0:零扩展, 1:符号扩展)
    
    // ==================== 分支/跳转信号 ====================
    output is_branch,                // 分支指令
    output is_jump,                  // J/JAL指令
    output is_jr,                    // JR/JALR指令
    output is_link,                  // 链接指令(JAL/JALR)
    output [2:0] branch_type,        // 分支类型
    
    // ==================== 其他控制信号 ====================
    output is_shift,                 // 移位指令(使用shamt)
    output is_shift_v,               // 变量移位(使用rs)
    output is_movn,                  // MOVN指令
    output is_movz,                  // MOVZ指令
    output is_mdu_op,                // 乘除法指令
    output [2:0] mdu_op,             // 乘除法操作码
    output is_mfhi,                  // MFHI指令
    output is_mflo,                  // MFLO指令
    output is_mthi,                  // MTHI指令
    output is_mtlo,                  // MTLO指令
    output is_mfc0,                  // MFC0指令
    output is_mtc0,                  // MTC0指令
    output is_eret,                  // ERET指令
    output is_syscall,               // SYSCALL指令
    output is_break,                 // BREAK指令
    output is_teq,                   // TEQ指令
    output is_trap,                  // Trap类异常指令
    output [2:0] trap_op             // Trap比较类型
);

    // ==================== MIPS指令操作码定义 ====================
    // R型指令 (op = 000000)
    parameter OP_RTYPE  = 6'b000000;
    // I型指令
    parameter OP_ADDI   = 6'b001000;
    parameter OP_ADDIU  = 6'b001001;
    parameter OP_ANDI   = 6'b001100;
    parameter OP_ORI    = 6'b001101;
    parameter OP_XORI   = 6'b001110;
    parameter OP_SLTI   = 6'b001010;
    parameter OP_SLTIU  = 6'b001011;
    parameter OP_LUI    = 6'b001111;
    parameter OP_PREF   = 6'b110011;
    // 分支指令
    parameter OP_BEQ    = 6'b000100;
    parameter OP_BNE    = 6'b000101;
    parameter OP_BLEZ   = 6'b000110;
    parameter OP_BGTZ   = 6'b000111;
    parameter OP_BGEZ   = 6'b000001;  // REGIMM类分支，rt区分具体指令
    // 跳转指令
    parameter OP_J      = 6'b000010;
    parameter OP_JAL    = 6'b000011;
    // 访存指令
    parameter OP_LW     = 6'b100011;
    parameter OP_LWL    = 6'b100010;
    parameter OP_LWR    = 6'b100110;
    parameter OP_LL     = 6'b110000;
    parameter OP_LH     = 6'b100001;
    parameter OP_LHU    = 6'b100101;
    parameter OP_LB     = 6'b100000;
    parameter OP_LBU    = 6'b100100;
    parameter OP_SW     = 6'b101011;
    parameter OP_SWL    = 6'b101010;
    parameter OP_SWR    = 6'b101110;
    parameter OP_SC     = 6'b111000;
    parameter OP_SH     = 6'b101001;
    parameter OP_SB     = 6'b101000;
    // 协处理器指令
    parameter OP_COP0   = 6'b010000;
    // 特殊指令
    parameter OP_SPECIAL2 = 6'b011100;  // CLZ指令
    
    // ==================== R型指令功能码定义 ====================
    parameter FUNC_ADD    = 6'b100000;
    parameter FUNC_ADDU   = 6'b100001;
    parameter FUNC_SUB    = 6'b100010;
    parameter FUNC_SUBU   = 6'b100011;
    parameter FUNC_AND    = 6'b100100;
    parameter FUNC_OR     = 6'b100101;
    parameter FUNC_XOR    = 6'b100110;
    parameter FUNC_NOR    = 6'b100111;
    parameter FUNC_SLT    = 6'b101010;
    parameter FUNC_SLTU   = 6'b101011;
    parameter FUNC_SLL    = 6'b000000;
    parameter FUNC_SRL    = 6'b000010;
    parameter FUNC_SRA    = 6'b000011;
    parameter FUNC_SLLV   = 6'b000100;
    parameter FUNC_SRLV   = 6'b000110;
    parameter FUNC_SRAV   = 6'b000111;
    parameter FUNC_JR     = 6'b001000;
    parameter FUNC_JALR   = 6'b001001;
    parameter FUNC_MOVZ   = 6'b001010;
    parameter FUNC_MOVN   = 6'b001011;
    parameter FUNC_MULT   = 6'b011000;
    parameter FUNC_MULTU  = 6'b011001;
    parameter FUNC_DIV    = 6'b011010;
    parameter FUNC_DIVU   = 6'b011011;
    parameter FUNC_MFHI   = 6'b010000;
    parameter FUNC_MFLO   = 6'b010010;
    parameter FUNC_MTHI   = 6'b010001;
    parameter FUNC_MTLO   = 6'b010011;
    parameter FUNC_SYSCALL = 6'b001100;
    parameter FUNC_BREAK  = 6'b001101;
    parameter FUNC_SYNC   = 6'b001111;
    parameter FUNC_TGE    = 6'b110000;
    parameter FUNC_TGEU   = 6'b110001;
    parameter FUNC_TLT    = 6'b110010;
    parameter FUNC_TLTU   = 6'b110011;
    parameter FUNC_TEQ    = 6'b110100;
    parameter FUNC_TNE    = 6'b110110;
    parameter FUNC_MADD   = 6'b000000;
    parameter FUNC_MADDU  = 6'b000001;
    parameter FUNC_MUL    = 6'b000010;
    parameter FUNC_MSUB   = 6'b000100;
    parameter FUNC_MSUBU  = 6'b000101;
    parameter FUNC_CLZ    = 6'b100000;  // op=SPECIAL2
    parameter FUNC_CLO    = 6'b100001;  // op=SPECIAL2
    parameter FUNC_ERET   = 6'b011000;
    
    // ALU操作码定义
    parameter ALU_ADD   = 4'b0010;
    parameter ALU_ADDU  = 4'b0000;
    parameter ALU_SUB   = 4'b0011;
    parameter ALU_SUBU  = 4'b0001;
    parameter ALU_AND   = 4'b0100;
    parameter ALU_OR    = 4'b0101;
    parameter ALU_XOR   = 4'b0110;
    parameter ALU_NOR   = 4'b0111;
    parameter ALU_SLT   = 4'b1011;
    parameter ALU_SLTU  = 4'b1010;
    parameter ALU_SLL   = 4'b1110;
    parameter ALU_SRL   = 4'b1101;
    parameter ALU_SRA   = 4'b1100;
    parameter ALU_LUI   = 4'b1000;
    parameter ALU_CLZ   = 4'b1111;
    parameter ALU_CLO   = 4'b1001;

    // 分支类型定义
    parameter BR_BEQ  = 3'b000;
    parameter BR_BNE  = 3'b001;
    parameter BR_BGEZ = 3'b010;
    parameter BR_BGTZ = 3'b011;
    parameter BR_BLEZ = 3'b100;
    parameter BR_BLTZ = 3'b101;
    parameter BR_NONE = 3'b111;

    parameter TRAP_EQ   = 3'b000;
    parameter TRAP_NE   = 3'b001;
    parameter TRAP_LT   = 3'b010;
    parameter TRAP_LTU  = 3'b011;
    parameter TRAP_GE   = 3'b100;
    parameter TRAP_GEU  = 3'b101;
    parameter TRAP_NONE = 3'b111;

    parameter RT_BLTZ   = 5'b00000;
    parameter RT_BGEZ   = 5'b00001;
    parameter RT_TGEI   = 5'b01000;
    parameter RT_TGEIU  = 5'b01001;
    parameter RT_TLTI   = 5'b01010;
    parameter RT_TLTIU  = 5'b01011;
    parameter RT_TEQI   = 5'b01100;
    parameter RT_TNEI   = 5'b01110;
    parameter RT_BLTZAL = 5'b10000;
    parameter RT_BGEZAL = 5'b10001;

    // ==================== 指令字段译码 ====================
    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign shamt  = instr[10:6];
    assign funct  = instr[5:0];
    assign imm    = instr[15:0];
    assign addr   = instr[25:0];
    assign imm_sign_ext = {{16{imm[15]}}, imm};
    assign imm_zero_ext = {16'b0, imm};

    // ==================== 指令类型判断 ====================
    wire is_rtype = (opcode == OP_RTYPE);
    wire is_load  = (opcode == OP_LW) || (opcode == OP_LWL) || (opcode == OP_LWR) ||
                    (opcode == OP_LL) || (opcode == OP_LH) || (opcode == OP_LHU) ||
                    (opcode == OP_LB) || (opcode == OP_LBU);
    wire is_store = (opcode == OP_SW) || (opcode == OP_SWL) || (opcode == OP_SWR) ||
                    (opcode == OP_SH) || (opcode == OP_SB);
    
    // R型指令译码
    wire r_add   = is_rtype && (funct == FUNC_ADD);
    wire r_addu  = is_rtype && (funct == FUNC_ADDU);
    wire r_sub   = is_rtype && (funct == FUNC_SUB);
    wire r_subu  = is_rtype && (funct == FUNC_SUBU);
    wire r_and   = is_rtype && (funct == FUNC_AND);
    wire r_or    = is_rtype && (funct == FUNC_OR);
    wire r_xor   = is_rtype && (funct == FUNC_XOR);
    wire r_nor   = is_rtype && (funct == FUNC_NOR);
    wire r_slt   = is_rtype && (funct == FUNC_SLT);
    wire r_sltu  = is_rtype && (funct == FUNC_SLTU);
    wire r_sll   = is_rtype && (funct == FUNC_SLL);
    wire r_srl   = is_rtype && (funct == FUNC_SRL);
    wire r_sra   = is_rtype && (funct == FUNC_SRA);
    wire r_sllv  = is_rtype && (funct == FUNC_SLLV);
    wire r_srlv  = is_rtype && (funct == FUNC_SRLV);
    wire r_srav  = is_rtype && (funct == FUNC_SRAV);
    wire r_jr    = is_rtype && (funct == FUNC_JR);
    wire r_jalr  = is_rtype && (funct == FUNC_JALR);
    wire r_movz  = is_rtype && (funct == FUNC_MOVZ);
    wire r_movn  = is_rtype && (funct == FUNC_MOVN);
    wire r_mult  = is_rtype && (funct == FUNC_MULT);
    wire r_multu = is_rtype && (funct == FUNC_MULTU);
    wire r_div   = is_rtype && (funct == FUNC_DIV);
    wire r_divu  = is_rtype && (funct == FUNC_DIVU);
    wire r_mfhi  = is_rtype && (funct == FUNC_MFHI);
    wire r_mflo  = is_rtype && (funct == FUNC_MFLO);
    wire r_mthi  = is_rtype && (funct == FUNC_MTHI);
    wire r_mtlo  = is_rtype && (funct == FUNC_MTLO);
    wire r_syscall = is_rtype && (funct == FUNC_SYSCALL);
    wire r_break = is_rtype && (funct == FUNC_BREAK);
    wire r_sync  = is_rtype && (funct == FUNC_SYNC) && (rs == 5'b0) && (rt == 5'b0) && (rd == 5'b0) && (shamt == 5'b0);
    wire r_tge   = is_rtype && (funct == FUNC_TGE);
    wire r_tgeu  = is_rtype && (funct == FUNC_TGEU);
    wire r_tlt   = is_rtype && (funct == FUNC_TLT);
    wire r_tltu  = is_rtype && (funct == FUNC_TLTU);
    wire r_teq   = is_rtype && (funct == FUNC_TEQ);
    wire r_tne   = is_rtype && (funct == FUNC_TNE);
    
    // I型指令译码
    wire i_addi  = (opcode == OP_ADDI);
    wire i_addiu = (opcode == OP_ADDIU);
    wire i_andi  = (opcode == OP_ANDI);
    wire i_ori   = (opcode == OP_ORI);
    wire i_xori  = (opcode == OP_XORI);
    wire i_slti  = (opcode == OP_SLTI);
    wire i_sltiu = (opcode == OP_SLTIU);
    wire i_lui   = (opcode == OP_LUI);
    wire i_ll    = (opcode == OP_LL);
    wire i_lwl   = (opcode == OP_LWL);
    wire i_lwr   = (opcode == OP_LWR);
    wire i_sc    = (opcode == OP_SC);
    wire i_pref  = (opcode == OP_PREF);
    wire i_swl   = (opcode == OP_SWL);
    wire i_swr   = (opcode == OP_SWR);
    wire i_beq   = (opcode == OP_BEQ);
    wire i_bne   = (opcode == OP_BNE);
    wire i_b     = (opcode == OP_BEQ) && (rs == 5'b00000) && (rt == 5'b00000);
    wire i_blez  = (opcode == OP_BLEZ) && (rt == 5'b00000);
    wire i_bgtz  = (opcode == OP_BGTZ) && (rt == 5'b00000);
    wire i_bltz   = (opcode == OP_BGEZ) && (rt == RT_BLTZ);
    wire i_bgez   = (opcode == OP_BGEZ) && (rt == RT_BGEZ);
    wire i_tgei   = (opcode == OP_BGEZ) && (rt == RT_TGEI);
    wire i_tgeiu  = (opcode == OP_BGEZ) && (rt == RT_TGEIU);
    wire i_tlti   = (opcode == OP_BGEZ) && (rt == RT_TLTI);
    wire i_tltiu  = (opcode == OP_BGEZ) && (rt == RT_TLTIU);
    wire i_teqi   = (opcode == OP_BGEZ) && (rt == RT_TEQI);
    wire i_tnei   = (opcode == OP_BGEZ) && (rt == RT_TNEI);
    wire i_bltzal = (opcode == OP_BGEZ) && (rt == RT_BLTZAL);
    wire i_bgezal = (opcode == OP_BGEZ) && (rt == RT_BGEZAL);
    wire i_bal    = (opcode == OP_BGEZ) && (rs == 5'b00000) && (rt == RT_BGEZAL);
    wire i_nop    = (instr == 32'b0);
    wire i_ssnop  = (opcode == OP_RTYPE) && (rs == 5'b0) && (rt == 5'b0) && (rd == 5'b0) &&
                    (funct == FUNC_SLL) && (shamt == 5'b00001);
    wire is_noop_instr = i_nop | i_ssnop | r_sync | i_pref;
    
    // J型指令译码
    wire j_j     = (opcode == OP_J);
    wire j_jal   = (opcode == OP_JAL);
    
    // CP0指令
    wire cop0_mfc0 = (opcode == OP_COP0) && (rs == 5'b00000);
    wire cop0_mtc0 = (opcode == OP_COP0) && (rs == 5'b00100);
    wire cop0_eret = (opcode == OP_COP0) && (funct == FUNC_ERET);
    
    // SPECIAL2指令
    wire s2_madd  = (opcode == OP_SPECIAL2) && (funct == FUNC_MADD);
    wire s2_maddu = (opcode == OP_SPECIAL2) && (funct == FUNC_MADDU);
    wire s2_mul   = (opcode == OP_SPECIAL2) && (funct == FUNC_MUL);
    wire s2_msub  = (opcode == OP_SPECIAL2) && (funct == FUNC_MSUB);
    wire s2_msubu = (opcode == OP_SPECIAL2) && (funct == FUNC_MSUBU);
    wire s2_clz   = (opcode == OP_SPECIAL2) && (funct == FUNC_CLZ);
    wire s2_clo   = (opcode == OP_SPECIAL2) && (funct == FUNC_CLO);

    // ==================== 控制信号生成 ====================
    
    // 寄存器堆写使能
    assign reg_write = (r_add | r_addu | r_sub | r_subu | r_and | r_or | r_xor | r_nor |
                       r_slt | r_sltu | r_sll | r_srl | r_sra | r_sllv | r_srlv | r_srav |
                       r_movn | r_movz |
                       r_mfhi | r_mflo | r_jalr |
                       i_addi | i_addiu | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_lui |
                       is_load | i_sc | j_jal | i_bltzal | i_bgezal | i_bal | cop0_mfc0 | s2_mul | s2_clz | s2_clo) && !is_noop_instr;
    
    // 存储器读写
    assign mem_read  = is_load;
    assign mem_write = is_store | i_sc;
    assign mem_to_reg = is_load | i_sc;
    
    // ALU源操作数
    assign alu_src = i_addi | i_addiu | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_lui |
                     is_load | is_store | i_sc | i_teqi | i_tgei | i_tgeiu | i_tlti | i_tltiu | i_tnei;
    
    // 写回寄存器选择: 00=rt, 01=rd, 10=$31
    assign reg_dst = (j_jal | i_bltzal | i_bgezal | i_bal) ? 2'b10 :
                     (is_rtype | s2_mul | s2_clz | s2_clo) ? 2'b01 : 2'b00;
    
    // 写回寄存器
    assign write_reg = (reg_dst == 2'b10) ? 5'd31 :
                       (reg_dst == 2'b01) ? rd : rt;
    
    // 符号扩展
    assign sign_ext = i_addi | i_addiu | i_slti | i_sltiu | is_load | is_store | i_sc | is_branch |
                      i_teqi | i_tgei | i_tgeiu | i_tlti | i_tltiu | i_tnei;
    
    // 分支/跳转
    assign is_branch = i_beq | i_b | i_bne | i_blez | i_bgtz | i_bltz | i_bgez | i_bltzal | i_bgezal | i_bal;
    assign is_jump   = j_j | j_jal;
    assign is_jr     = r_jr | r_jalr;
    assign is_link   = j_jal | r_jalr | i_bltzal | i_bgezal | i_bal;
    
    assign branch_type = (i_beq | i_b) ? BR_BEQ  :
                         i_bne  ? BR_BNE  :
                         (i_bgez | i_bgezal | i_bal) ? BR_BGEZ :
                         i_bgtz ? BR_BGTZ :
                         i_blez ? BR_BLEZ :
                         (i_bltz | i_bltzal) ? BR_BLTZ : BR_NONE;
    
    // 移位指令
    assign is_shift   = (r_sll | r_srl | r_sra) && !i_nop && !i_ssnop;
    assign is_shift_v = r_sllv | r_srlv | r_srav;
    assign is_movn    = r_movn;
    assign is_movz    = r_movz;
    
    // 乘除法
    assign is_mdu_op = r_mult | r_multu | r_div | r_divu | s2_madd | s2_maddu | s2_msub | s2_msubu;
    assign mdu_op    = r_mult   ? 3'b000 :
                       r_multu  ? 3'b001 :
                       r_div    ? 3'b010 :
                       r_divu   ? 3'b011 :
                       s2_madd  ? 3'b100 :
                       s2_maddu ? 3'b101 :
                       s2_msub  ? 3'b110 : 3'b111;
    
    // HI/LO寄存器操作
    assign is_mfhi = r_mfhi;
    assign is_mflo = r_mflo;
    assign is_mthi = r_mthi;
    assign is_mtlo = r_mtlo;
    
    // CP0指令
    assign is_mfc0 = cop0_mfc0;
    assign is_mtc0 = cop0_mtc0;
    assign is_eret = cop0_eret;
    
    // 异常指令
    assign is_syscall = r_syscall;
    assign is_break   = r_break;
    assign is_teq     = r_teq;
    assign is_trap    = r_tge | r_tgeu | r_tlt | r_tltu | r_teq | r_tne |
                        i_teqi | i_tgei | i_tgeiu | i_tlti | i_tltiu | i_tnei;
    assign trap_op    = (r_teq | i_teqi)   ? TRAP_EQ  :
                        (r_tne | i_tnei)   ? TRAP_NE  :
                        (r_tlt | i_tlti)   ? TRAP_LT  :
                        (r_tltu | i_tltiu) ? TRAP_LTU :
                        (r_tge | i_tgei)   ? TRAP_GE  :
                        (r_tgeu | i_tgeiu) ? TRAP_GEU : TRAP_NONE;

    // ==================== ALU操作码生成 ====================
    reg [3:0] alu_op_reg;
    
    always @(*) begin
        if (is_noop_instr) begin
            alu_op_reg = ALU_ADDU;
        end else if (r_tge || i_tgei) begin
            alu_op_reg = ALU_SLT;
        end else if (r_tgeu || i_tgeiu) begin
            alu_op_reg = ALU_SLTU;
        end else if (r_tlt || i_tlti) begin
            alu_op_reg = ALU_SLT;
        end else if (r_tltu || i_tltiu) begin
            alu_op_reg = ALU_SLTU;
        end else if (r_teq || i_teqi || r_tne || i_tnei) begin
            alu_op_reg = ALU_SUB;
        end else casez ({opcode, funct})
            // R型指令
            {OP_RTYPE, FUNC_ADD}:   alu_op_reg = ALU_ADD;
            {OP_RTYPE, FUNC_ADDU}:  alu_op_reg = ALU_ADDU;
            {OP_RTYPE, FUNC_SUB}:   alu_op_reg = ALU_SUB;
            {OP_RTYPE, FUNC_SUBU}:  alu_op_reg = ALU_SUBU;
            {OP_RTYPE, FUNC_AND}:   alu_op_reg = ALU_AND;
            {OP_RTYPE, FUNC_OR}:    alu_op_reg = ALU_OR;
            {OP_RTYPE, FUNC_XOR}:   alu_op_reg = ALU_XOR;
            {OP_RTYPE, FUNC_NOR}:   alu_op_reg = ALU_NOR;
            {OP_RTYPE, FUNC_SLT}:   alu_op_reg = ALU_SLT;
            {OP_RTYPE, FUNC_SLTU}:  alu_op_reg = ALU_SLTU;
            {OP_RTYPE, FUNC_SLL}:   alu_op_reg = ALU_SLL;
            {OP_RTYPE, FUNC_SRL}:   alu_op_reg = ALU_SRL;
            {OP_RTYPE, FUNC_SRA}:   alu_op_reg = ALU_SRA;
            {OP_RTYPE, FUNC_SLLV}:  alu_op_reg = ALU_SLL;
            {OP_RTYPE, FUNC_SRLV}:  alu_op_reg = ALU_SRL;
            {OP_RTYPE, FUNC_SRAV}:  alu_op_reg = ALU_SRA;
            {OP_RTYPE, FUNC_TEQ}:   alu_op_reg = ALU_SUB;
            {OP_SPECIAL2, FUNC_CLO}: alu_op_reg = ALU_CLO;
            // I型ALU指令
            {OP_ADDI, 6'b??????}:   alu_op_reg = ALU_ADD;
            {OP_ADDIU, 6'b??????}:  alu_op_reg = ALU_ADDU;
            {OP_ANDI, 6'b??????}:   alu_op_reg = ALU_AND;
            {OP_ORI, 6'b??????}:    alu_op_reg = ALU_OR;
            {OP_XORI, 6'b??????}:   alu_op_reg = ALU_XOR;
            {OP_SLTI, 6'b??????}:   alu_op_reg = ALU_SLT;
            {OP_SLTIU, 6'b??????}:  alu_op_reg = ALU_SLTU;
            {OP_LUI, 6'b??????}:    alu_op_reg = ALU_LUI;
            // 访存指令
            {OP_LW, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_LWL, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_LWR, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_LL, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_LH, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_LHU, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_LB, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_LBU, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_SW, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_SWL, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_SWR, 6'b??????}:    alu_op_reg = ALU_ADDU;
            {OP_SC, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_SH, 6'b??????}:     alu_op_reg = ALU_ADDU;
            {OP_SB, 6'b??????}:     alu_op_reg = ALU_ADDU;
            // 分支指令
            {OP_BEQ, 6'b??????}:    alu_op_reg = ALU_SUB;
            {OP_BNE, 6'b??????}:    alu_op_reg = ALU_SUB;
            // SPECIAL2
            {OP_SPECIAL2, FUNC_CLZ}: alu_op_reg = ALU_CLZ;
            default:                 
                alu_op_reg = ALU_ADDU;
        endcase
    end
    
    assign alu_op = alu_op_reg;

endmodule
