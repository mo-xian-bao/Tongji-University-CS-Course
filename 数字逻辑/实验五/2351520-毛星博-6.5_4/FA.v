`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 16:28:59
// Design Name: 
// Module Name: FA
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

module FA(
 input iA, //1 位二进制加数
 input iB, //1 位二进制被加数
 input iC, //低位的进位信号
 output oS, //1 位和数
 output oC //向高位的进位信号
);
wire A1,A2, B1,B2;
wire o1, o2, o3; // 中间变量
assign A1=iA;
assign A2=iA;
assign B1=iB;
assign B2=iB;

xor(o1,A1,B1);
and(o2,A2,B2);
and(o3,o1,iC);
or(oC,o2,o3);
xor(oS,o1,iC);

endmodule
