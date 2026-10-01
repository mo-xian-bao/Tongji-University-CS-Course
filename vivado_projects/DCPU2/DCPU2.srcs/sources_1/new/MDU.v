module MDU(
    input           clk,
    input           rst,
    input           start,     // 启动信号
    input  [31:0]   A,         // 操作数A
    input  [31:0]   B,         // 操作数B
    input  [1:0]    MDUc,      // 控制信号
    output reg [31:0]   HI,        // 高32位结果 / 余数
    output reg [31:0]   LO,        // 低32位结果 / 商
    output          busy       // 忙信号
);

    // --- 定义操作码 ---
    localparam MDU_MULT  = 2'b00; // 有符号乘法
    localparam MDU_MULTU = 2'b01; // 无符号乘法
    localparam MDU_DIV   = 2'b10; // 有符号除法
    localparam MDU_DIVU  = 2'b11; // 无符号除法

    // 单周期乘除法器，永远不忙
    assign busy = 1'b0;

    // --- 独立计算各结果 ---
    // 将计算逻辑拆分，避免综合器混淆 DSP 资源
    wire [63:0] mult_res_s = $signed(A) * $signed(B); // 有符号乘法结果
    wire [63:0] mult_res_u = A * B;                   // 无符号乘法结果
    
    wire [31:0] div_res_s = $signed(A) / $signed(B);  // 有符号除法商
    wire [31:0] rem_res_s = $signed(A) % $signed(B);  // 有符号除法余数
    
    wire [31:0] div_res_u = A / B;                    // 无符号除法商
    wire [31:0] rem_res_u = A % B;                    // 无符号除法余数

    // --- 结果选择逻辑 ---
    always @(*) begin
        if (!start) begin
            HI = 32'b0;
            LO = 32'b0;
        end else begin
            case (MDUc)
                MDU_MULT: begin
                    HI = mult_res_s[63:32];
                    LO = mult_res_s[31:0];
                end
                MDU_MULTU: begin
                    HI = mult_res_u[63:32];
                    LO = mult_res_u[31:0];
                end
                MDU_DIV: begin
                    HI = rem_res_s;
                    LO = div_res_s;
                end
                MDU_DIVU: begin
                    HI = rem_res_u;
                    LO = div_res_u;
                end
                default: begin
                    HI = 32'b0;
                    LO = 32'b0;
                end
            endcase
        end
    end

endmodule