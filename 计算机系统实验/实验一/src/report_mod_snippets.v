`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File: report_mod_snippets.v
// Purpose: Copy-ready snippets for report writing
// Note: This file is documentation-only and will not affect design logic.
//////////////////////////////////////////////////////////////////////////////////

module report_mod_snippets;
    // Intentionally empty.
endmodule


===============================================================================
1) Controller.v - 新增指令译码与控制信号
===============================================================================
// SPECIAL2 指令译码
wire s2_madd  = (opcode == OP_SPECIAL2) && (funct == FUNC_MADD);
wire s2_maddu = (opcode == OP_SPECIAL2) && (funct == FUNC_MADDU);
wire s2_mul   = (opcode == OP_SPECIAL2) && (funct == FUNC_MUL);
wire s2_msub  = (opcode == OP_SPECIAL2) && (funct == FUNC_MSUB);
wire s2_msubu = (opcode == OP_SPECIAL2) && (funct == FUNC_MSUBU);
wire s2_clz   = (opcode == OP_SPECIAL2) && (funct == FUNC_CLZ);
wire s2_clo   = (opcode == OP_SPECIAL2) && (funct == FUNC_CLO);

// CP0 指令译码
wire cop0_mfc0 = (opcode == OP_COP0) && (rs == 5'b00000);
wire cop0_mtc0 = (opcode == OP_COP0) && (rs == 5'b00100);
wire cop0_eret = (opcode == OP_COP0) && (funct == FUNC_ERET);

// 写使能、访存与ALU源
assign reg_write = (r_add | r_addu | r_sub | r_subu | r_and | r_or | r_xor | r_nor |
                   r_slt | r_sltu | r_sll | r_srl | r_sra | r_sllv | r_srlv | r_srav |
                   r_movn | r_movz | r_mfhi | r_mflo | r_jalr |
                   i_addi | i_addiu | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_lui |
                   is_load | i_sc | j_jal | i_bltzal | i_bgezal | i_bal |
                   cop0_mfc0 | s2_mul | s2_clz | s2_clo) && !is_noop_instr;

assign mem_to_reg = is_load | i_sc;
assign alu_src    = i_addi | i_addiu | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_lui |
                    is_load | is_store | i_sc | i_teqi | i_tgei | i_tgeiu | i_tlti | i_tltiu | i_tnei;

// 乘除法与异常控制输出
assign is_mdu_op = r_mult | r_multu | r_div | r_divu | s2_madd | s2_maddu | s2_msub | s2_msubu;
assign is_mfc0   = cop0_mfc0;
assign is_mtc0   = cop0_mtc0;
assign is_eret   = cop0_eret;
assign is_trap   = r_tge | r_tgeu | r_tlt | r_tltu | r_teq | r_tne |
                   i_teqi | i_tgei | i_tgeiu | i_tlti | i_tltiu | i_tnei;


/*
===============================================================================
2) DCPU.v - PC更新优先级(IF)
===============================================================================
wire exc_occur  = CP0_exception && !stall;
wire eret_occur = EX_MEM_is_eret && !stall;

assign PC_next = exc_occur    ? 32'h00400004 :
                 eret_occur   ? CP0_exc_addr :
                 ID_is_jr     ? ID_rs_data_fwd :
                 ID_is_jump   ? jump_target :
                 branch_taken ? branch_target :
                 PC_plus_4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PC <= 32'h00400000;
    end else if (ena && !stall) begin
        PC <= PC_next;
    end
end
*/

/*
===============================================================================
3) DCPU.v - EX结果选择 + movn/movz条件写回
===============================================================================
wire EX_is_mul = (ID_EX_opcode == OP_SPECIAL2) && (ID_EX_funct == FUNC_MUL);
wire [63:0] EX_mul_res = $signed(EX_rs_data_fwd) * $signed(EX_rt_data_fwd);

wire [31:0] EX_result = ID_EX_is_mfhi ? HI_reg :
                        ID_EX_is_mflo ? LO_reg :
                        (ID_EX_is_movn || ID_EX_is_movz) ? EX_rs_data_fwd :
                        EX_is_mul ? EX_mul_res[31:0] :
                        ID_EX_is_link ? (ID_EX_PC + 8) :
                        EX_alu_result;

EX_MEM_reg_write <= ID_EX_reg_write &&
                    (!ID_EX_is_movn || (EX_rt_data_fwd != 32'b0)) &&
                    (!ID_EX_is_movz || (EX_rt_data_fwd == 32'b0));
*/

/*
===============================================================================
4) DCPU.v - MEM访存操作编码 + LL/SC返回
===============================================================================
wire EX_MEM_is_ll  = (EX_MEM_opcode == OP_LL);
wire EX_MEM_is_lwl = (EX_MEM_opcode == OP_LWL);
wire EX_MEM_is_lwr = (EX_MEM_opcode == OP_LWR);
wire EX_MEM_is_sc  = (EX_MEM_opcode == OP_SC);
wire EX_MEM_is_swl = (EX_MEM_opcode == OP_SWL);
wire EX_MEM_is_swr = (EX_MEM_opcode == OP_SWR);

wire [3:0] mem_op;
assign mem_op = (EX_MEM_opcode == 6'b100011) ? 4'b0000 :
                ((EX_MEM_opcode == 6'b100000) || EX_MEM_is_ll) ? 4'b0001 :
                (EX_MEM_opcode == 6'b100100) ? 4'b0010 :
                (EX_MEM_opcode == 6'b100001) ? 4'b0011 :
                (EX_MEM_opcode == 6'b100101) ? 4'b0100 :
                EX_MEM_is_lwl ? 4'b0101 :
                EX_MEM_is_lwr ? 4'b0110 :
                ((EX_MEM_opcode == 6'b101011) || EX_MEM_is_sc) ? 4'b1000 :
                (EX_MEM_opcode == 6'b101000) ? 4'b1001 :
                (EX_MEM_opcode == 6'b101001) ? 4'b1010 :
                EX_MEM_is_swl ? 4'b1011 :
                EX_MEM_is_swr ? 4'b1100 : 4'b0000;

wire [31:0] MEM_access_data = EX_MEM_is_sc ? {31'b0, LLbit} : MEM_read_data;
*/

/*
===============================================================================
5) CP0.v - 异常/定时中断核心逻辑
===============================================================================
assign exc_addr  = eret ? cp0_regs[14] : 32'h0040_0004;
assign timer_int = timer_pending && cp0_regs[12][0];

else if (exception && cp0_regs[12][0]) begin
    cp0_regs[14] <= pc;
    cp0_regs[13][6:2] <= cause;
    cp0_regs[12] <= cp0_regs[12] << 5;
    if (cause == 5'd0) timer_pending <= 1'b0;
end else if (mtc0) begin
    cp0_regs[Rd] <= wdata;
    if (Rd == 5'd11) timer_pending <= 1'b0;
end else if (eret) begin
    cp0_regs[12] <= cp0_regs[12] >> 5;
end else begin
    cp0_regs[9] <= cp0_regs[9] + 32'd1;
    if ((cp0_regs[11] != 32'b0) && ((cp0_regs[9] + 32'd1) == cp0_regs[11])) begin
        timer_pending <= 1'b1;
    end
end
*/

/*
===============================================================================
6) DMEM.v - 大端字节存储 + ANSCODE导出
===============================================================================
(* ram_style = "distributed" *) reg [7:0] mem_b3 [0:255];
(* ram_style = "distributed" *) reg [7:0] mem_b2 [0:255];
(* ram_style = "distributed" *) reg [7:0] mem_b1 [0:255];
(* ram_style = "distributed" *) reg [7:0] mem_b0 [0:255];

wire [31:0] mem_word = {mem_b3[word_addr], mem_b2[word_addr], mem_b1[word_addr], mem_b0[word_addr]};
assign anscode_dbg   = {mem_b3[8'd0], mem_b2[8'd0], mem_b1[8'd0], mem_b0[8'd0]};
*/

/*
===============================================================================
7) ForwardUnit.v / HazardUnit.v - mfc0冒险修复
===============================================================================
assign EX_forward_a = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) &&
                       (EX_MEM_write_reg == ID_EX_rs) && !EX_MEM_mem_read && !EX_MEM_is_mfc0) ? 2'b10 :
                      (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b0) &&
                       (MEM_WB_write_reg == ID_EX_rs)) ? 2'b01 : 2'b00;

wire load_use_hazard = (ID_EX_mem_read || ID_EX_is_mfc0) && (ID_EX_write_reg != 5'b0) &&
                       ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt));

wire branch_hazard = ID_is_branch && (
    (ID_EX_reg_write && (ID_EX_write_reg != 5'b0) &&
     ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt))) ||
    (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && (EX_MEM_mem_read || EX_MEM_is_mfc0) &&
     ((EX_MEM_write_reg == ID_rs) || (EX_MEM_write_reg == ID_rt))));
*/

/*
===============================================================================
8) top_borad.v - 数码管显示ANSCODE
===============================================================================
wire [31:0] anscode_value;

DCPU cpu(
    .clk(clk_cpu),
    .rst(rst),
    .ena(ena),
    .intr(1'b0),
    .PC_out(pc_value),
    .instr_out(instr_value),
    .reg28(reg28_value),
    .anscode_out(anscode_value)
);

wire [31:0] display_data = anscode_value;
*/
