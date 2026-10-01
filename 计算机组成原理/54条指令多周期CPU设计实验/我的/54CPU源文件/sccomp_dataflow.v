module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst, // 指令输出
    output [31:0] pc    // PC值输出
);

    // 内部信号连接CU和datapath
    wire [31:0] Instr;
    wire [31:0] ACC;
    wire [31:0] PC;  
    wire [31:0] InstOut; // 新增：直接来自IMEM的指令输出
    wire ZF, SF;
    wire [31:0] CP0_status;
    wire MDU_busy;
    
    // 控制信号从CU到datapath
    wire PC_in, IR_in, ACC_in;
    wire [3:0] ALUc;
    wire [1:0] MDUc;
    wire DM_r, DM_w;
    wire [2:0] byte_out_c;
    wire [3:0] byte_in_ena;
    wire HI_w, LO_w;
    wire M1, M2, M3, M6, M7;
    wire [2:0] M4, M5;
    wire mfc0, mtc0, eret, exception;
    wire [4:0] cause;
    wire MDR_in, EXT_c, Reg_in;
    wire RsReg_in, RtReg_in;
    wire MDU_start;
    wire Latch_PC4_in_M4;
    
    // 实例化控制单元CU
    CU cu_inst(
        .clk(clk_in),
        .rst(reset),
        .Instr(Instr),
        .ACC(ACC),
        .ZF(ZF),
        .SF(SF),
        .CP0_status(CP0_status),
        .MDU_busy(MDU_busy),
        
        // 控制信号输出
        .PC_in(PC_in),
        .IR_in(IR_in),
        .ACC_in(ACC_in),
        .ALUc(ALUc),
        .MDUc(MDUc),
        .DM_r(DM_r),
        .DM_w(DM_w),
        .byte_out_c(byte_out_c),
        .byte_in_ena(byte_in_ena),
        .HI_w(HI_w),
        .LO_w(LO_w),
        .M1(M1),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .M6(M6),
        .M7(M7),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .cause(cause),
        .MDR_in(MDR_in),
        .EXT_c(EXT_c),
        .Reg_in(Reg_in),
        .RsReg_in(RsReg_in),
        .RtReg_in(RtReg_in),
        .MDU_start(MDU_start), 
        .Latch_PC4_in_M4(Latch_PC4_in_M4)
    );
    
    // 实例化数据通路datapath
    datapath sccpu(
        .clk(clk_in),
        .rst(reset),
        
        // 控制信号输入
        .PC_in(PC_in),
        .IR_in(IR_in),
        .ACC_in(ACC_in),
        .ALUc(ALUc),
        .MDUc(MDUc),
        .DM_r(DM_r),
        .DM_w(DM_w),
        .byte_out_c(byte_out_c),
        .byte_in_ena(byte_in_ena),
        .HI_w(HI_w),
        .LO_w(LO_w),
        .M1(M1),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .M6(M6),
        .M7(M7),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .cause(cause),
        .MDR_in(MDR_in),
        .EXT_c(EXT_c),
        .Reg_in(Reg_in),
        .RsReg_in(RsReg_in),
        .RtReg_in(RtReg_in),
        .MDU_start(MDU_start),
        .Latch_PC4_in_M4(Latch_PC4_in_M4),
        
        // 状态信号输出
        .Instr(Instr),
        .ACC(ACC),
        .ZF(ZF),
        .SF(SF),
        .CP0_status(CP0_status),
        .MDU_busy(MDU_busy),
        .PC(PC),  // 输出当前PC值
        .InstOut(InstOut)  // 新增：直接来自IMEM的指令输出
    );
    
    // 输出信号连接
    assign inst = InstOut;  // 将直接来自IMEM的指令信号连接到输出
    assign pc = PC;  // 将PC值连接到输出

endmodule
