module PC(
    input clk, // 时钟信号
    input rst, // 复位信号
    input ena, // 使能信号
    input [31:0] data_in, // 数据输入
    output [31:0] data_out // 数据输出
);

reg [31:0] pc;

always @(posedge clk or posedge rst) begin // 时钟下降沿或复位上升沿
    if (rst)
        pc <= 32'h00400000;      // 异步复位
    else if (ena)
        pc <= data_in;           // 时钟使能
end

assign data_out = (ena) ? pc : 32'bz;

endmodule