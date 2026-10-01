module MUX4(
    input clk,
    input rst,

    // --- 数据输入端口 ---
    input [31:0] A, // 来自 CP0 的 rdata
    input [31:0] B, // 来自 HI 寄存器
    input [31:0] C, // 来自 LO 寄存器
    input [31:0] PC_Value_for_Latch, // 来自实时PC值 (PC+4)
    input [31:0] E, // 来自 LDP (加载数据)
    input [31:0] F, // 来自 ACC (ALU结果)

    // --- 控制信号 ---
    input Latch_PC_in_M4, // 新增：内部PC寄存器的写使能
    input [2:0] M4_sel,      // Mux选择信号

    // --- 输出端口 ---
    output reg [31:0] M4_out // Mux的输出 (命名为M4_out以示区分)
);

    // --- 内部寄存器，专门用于锁存jal/jalr的返回地址 ---
    reg [31:0] pc_reg;

    // --- 时序逻辑：只负责更新内部的pc_reg ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 32'h0;
        end else if (Latch_PC_in_M4) begin
            // 在jal/jalr指令的ID阶段，锁存当时的PC值(即PC+4)
            pc_reg <= PC_Value_for_Latch; 
        end
    end

    // --- 组合逻辑：负责根据M4_sel选择正确的输出 ---
    always @(*) begin
        case (M4_sel)
            3'b000: M4_out = A; // 来自 CP0
            3'b001: M4_out = B; // 来自 HI
            3'b010: M4_out = C; // 来自 LO
            3'b011: M4_out = pc_reg; 
            3'b100: M4_out = E; // 来自 LDP
            3'b101: M4_out = F; // 来自 ACC
            default: M4_out = 32'hxxxxxxxx; // 默认输出不定值，便于调试
        endcase
    end

endmodule

module MUX5(
    input [31:0] A, // 来自 Rs_Reg (用于jr/jalr)
    input [31:0] B, // 来自 分支地址计算单元
    input [31:0] C, // 来自 PC+4 加法器
    input [31:0] D, // 来自 CP0 的 exc_addr/epc_out
    input [31:0] E, // 来自 J-Type 跳转地址计算单元

    input [2:0] M5_sel, // 选择信号

    output reg [31:0] M5_out // Mux的输出
);

    // --- 组合逻辑：根据M5_sel选择正确的输出 ---
    always @(*) begin
        case (M5_sel)
            3'b000: M5_out = A; // jr/jalr
            3'b001: M5_out = B; // 分支
            3'b010: M5_out = C; // PC+4
            3'b011: M5_out = D; // 异常 或 eret
            3'b100: M5_out = E; // j/jal
            default: M5_out = C; // 默认选择PC+4，防止意外跳转
        endcase
    end

endmodule