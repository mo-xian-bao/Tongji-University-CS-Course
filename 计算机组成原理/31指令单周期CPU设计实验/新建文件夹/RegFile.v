module RegFile(
    input clk, // 时钟信号
    input rst, // 复位信号
    input ena, // 使能信号
    input we, // 写使能信号
    input [4:0] Rdc, // 目标寄存器
    input [4:0] Rsc, // 源寄存器1
    input [4:0] Rtc, // 源寄存器2
    input [31:0] Rd, // 数据输入
    output [31:0] Rs, // 源寄存器1数据输出
    output [31:0] Rt // 源寄存器2数据输出
);

reg [31:0] array_reg [31:0]; // 32个32位寄存器
integer i;

//异步读取
assign Rs = (ena) ? array_reg[Rsc] : 32'bz;
assign Rt = (ena) ? array_reg[Rtc] : 32'bz;
//assign regs_debug = regs;

//同步写入
always @(posedge clk or posedge rst) begin // 时钟上升沿或复位上升沿
    if (ena && rst) begin // 复位
        array_reg[0] <= 32'h00000000;
        array_reg[1] <= 32'h00000000;
        array_reg[2] <= 32'h00000000;
        array_reg[3] <= 32'h00000000;
        array_reg[4] <= 32'h00000000;
        array_reg[5] <= 32'h00000000;
        array_reg[6] <= 32'h00000000;
        array_reg[7] <= 32'h00000000;
        array_reg[8] <= 32'h00000000;
        array_reg[9] <= 32'h00000000;
        array_reg[10] <= 32'h00000000;
        array_reg[11] <= 32'h00000000;
        array_reg[12] <= 32'h00000000;
        array_reg[13] <= 32'h00000000;
        array_reg[14] <= 32'h00000000;
        array_reg[15] <= 32'h00000000;
        array_reg[16] <= 32'h00000000;
        array_reg[17] <= 32'h00000000;
        array_reg[18] <= 32'h00000000;
        array_reg[19] <= 32'h00000000;
        array_reg[20] <= 32'h00000000;
        array_reg[21] <= 32'h00000000;
        array_reg[22] <= 32'h00000000;
        array_reg[23] <= 32'h00000000;
        array_reg[24] <= 32'h00000000;
        array_reg[25] <= 32'h00000000;
        array_reg[26] <= 32'h00000000;
        array_reg[27] <= 32'h00000000;
        array_reg[28] <= 32'h00000000;
        array_reg[29] <= 32'h00000000;
        array_reg[30] <= 32'h00000000;
        array_reg[31] <= 32'h00000000;
    end
    else begin 
        if (ena && we && Rdc != 0) // 写入（0号寄存器不能写入）
            array_reg[Rdc] <= Rd;
    end
end

endmodule