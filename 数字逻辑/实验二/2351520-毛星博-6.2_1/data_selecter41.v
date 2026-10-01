`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/23 16:10:06
// Design Name: 
// Module Name: data_selecter41
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


module selector41(
    input [3:0] iC0, //四位输入信号 c0
    input [3:0] iC1, //四位输入信号 c1
    input [3:0] iC2, //四位输入信号 c2
    input [3:0] iC3, //四位输入信号 c3
    input iS1, //选择信号 s1
    input iS0, //选择信号 s0
    output [3:0] oZ //四位输出信号 z
    );
   assign oZ = (iS1 == 0 && iS0 == 0) ? iC0 : ((iS1 == 0 && iS0 == 1) ? iC1 : ((iS1 == 1 && iS0 == 0) ? iC2 : iC3));
endmodule
