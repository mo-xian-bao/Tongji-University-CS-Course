`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 15:39:11
// Design Name: 
// Module Name: Asynchronous_D_FF
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


module Asynchronous_D_FF(
input CLK, //时钟信号，上升沿有效
input D, //输入信号 D
input RST_n, //复位信号，低电平有效
output reg Q1, //输出信号 Q
output reg Q2//输出信号??
);

always @ (posedge CLK or negedge RST_n)
begin
    if (!RST_n || !D)
        begin
            Q1 <= 0;
            Q2 <= 1; 
        end
    else
        begin
            Q1 <= 1;
            Q2 <= 0;
        end
end
endmodule
