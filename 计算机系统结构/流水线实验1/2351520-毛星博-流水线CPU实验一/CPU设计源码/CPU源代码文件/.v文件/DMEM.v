`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/09 21:19:06
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk, // 时钟信号
    input ena, // 使能信号
    input we, // 写使能信号
    input re, // 读使能信号
    input [4:0] addr, // 数据地址（字地址，0-31）
    input [31:0] data_in, // 数据输入
    output [31:0] data_out // 数据输出
);

reg [31:0] mem [31:0]; // 32个32位数据

assign data_out = (ena && re && !we) ? mem[addr] : 32'bz; // 读取数据,如果ena为1,re为1,we为0,则读取数据,否则输出高阻态

always @(posedge clk) begin
    if (ena && we && !re) begin //如果ena为1,we为1,re为0,则写入数据
        mem[addr] <= data_in;
    end
end

endmodule
