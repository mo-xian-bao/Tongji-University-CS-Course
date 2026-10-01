`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 23:09:23
// Design Name: 
// Module Name: Regfiles
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Regfiles(
input clk, //寄存器组时钟信号，下降沿写入数据
input rst, //异步复位信号，高电平时全部寄存器置零
input we, //寄存器读写有效信号，高电平时允许寄存器写入数据，低电平时允许寄存器读出数据
input [4:0] raddr1, //所需读取的寄存器的地址
input [4:0] raddr2, //所需读取的寄存器的地址
input [4:0] waddr, //写寄存器的地址
input [31:0] wdata, //写寄存器数据，数据在 clk 下降沿时被写入
output reg [31:0] rdata1, //raddr1 所对应寄存器的输出数据
output reg [31:0] rdata2 //raddr2 所对应寄存器的输出数据
);

reg [31:0] regfile [0:31]; //寄存器组，共 32 个寄存器，每个寄存器 32 位
integer i;

always @(negedge clk,posedge rst) 
begin
    if (rst) //异步复位信号为高电平时，全部寄存器置零
        for (i = 0; i < 32; i = i + 1)
            regfile[i] = 32'b0;
    else if (we) //寄存器读写有效信号为高电平时，允许寄存器写入数据
        regfile[waddr] <= wdata; //写寄存器数据，数据在 clk 下降沿时被写入
end

always @(*) 
begin
        rdata1 <= we ? 32'bz: regfile[raddr1]; //raddr1 所对应寄存器的输出数据
        rdata2 <= we ? 32'bz: regfile[raddr2]; //raddr2 所对应寄存器的输出数据=
end

endmodule