module PC(
    input clk,
    input rst,
    input pc_in, // PC 输入信号，控制 PC 的更新
    input [31:0] next_pc, // 下一个 PC 值，连接mux5_out
    output [31:0] pc_data // 输出当前 PC 值
);

reg [31:0] pc_reg; // 内部寄存器，用于存储当前 PC 值
assign pc_data = pc_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_reg <= 32'h0040_0000; // 复位时将 PC 设置为 0x0040_0000
    end 
    else if (pc_in) begin
        pc_reg <= next_pc; // 更新 PC 值为下一个 PC 值
    end
end

endmodule