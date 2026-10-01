module MDU(
    input           clk,
    input           rst,
    input           start,     // 启动信号
    input  [31:0]   A,         // 操作数A
    input  [31:0]   B,         // 操作数B
    input  [31:0]   HI_in,
    input  [31:0]   LO_in,
    input  [2:0]    MDUc,      // 控制信号
    output reg [31:0]   HI,        // 高32位结果 / 余数
    output reg [31:0]   LO,        // 低32位结果 / 商
    output          busy       // 忙信号
);

    // --- 定义操作码 ---
    localparam MDU_MULT  = 3'b000; // 有符号乘法
    localparam MDU_MULTU = 3'b001; // 无符号乘法
    localparam MDU_DIV   = 3'b010; // 有符号除法
    localparam MDU_DIVU  = 3'b011; // 无符号除法
    localparam MDU_MADD  = 3'b100; // 有符号乘加
    localparam MDU_MADDU = 3'b101; // 无符号乘加
    localparam MDU_MSUB  = 3'b110; // 有符号乘减
    localparam MDU_MSUBU = 3'b111; // 无符号乘减

    // 单周期乘除法器，永远不忙
    assign busy = 1'b0;

    // --- 独立计算各结果 ---
    // 将计算逻辑拆分，避免综合器混淆 DSP 资源
    wire [63:0] mult_res_s = $signed(A) * $signed(B); // 有符号乘法结果
    wire [63:0] mult_res_u = A * B;                   // 无符号乘法结果
    wire [63:0] hilo_value = {HI_in, LO_in};
    wire [63:0] madd_res_s = hilo_value + mult_res_s;
    wire [63:0] madd_res_u = hilo_value + mult_res_u;
    wire [63:0] msub_res_s = hilo_value - mult_res_s;
    wire [63:0] msub_res_u = hilo_value - mult_res_u;
    
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
                MDU_MADD: begin
                    HI = madd_res_s[63:32];
                    LO = madd_res_s[31:0];
                end
                MDU_MADDU: begin
                    HI = madd_res_u[63:32];
                    LO = madd_res_u[31:0];
                end
                MDU_MSUB: begin
                    HI = msub_res_s[63:32];
                    LO = msub_res_s[31:0];
                end
                MDU_MSUBU: begin
                    HI = msub_res_u[63:32];
                    LO = msub_res_u[31:0];
                end
                default: begin
                    HI = 32'b0;
                    LO = 32'b0;
                end
            endcase
        end
    end

endmodule