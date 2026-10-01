`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 15:37:47
// Design Name: 
// Module Name: Counter8
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


module Counter8(
input CLK, //时钟信号，上升沿有效
input rst_n, //异步复位信号，低电平有效
output reg [2:0] oQ, //二进制计数器输出
output [6:0] oDisplay //七段数字显示管输出
);

wire [2:0] temp_oQ;
wire [2:0] temp_oQn;
wire iQ1,iQ2;

JK_FF FF0(CLK,1,1,rst_n,temp_oQ[0],temp_oQn[0]);
assign iQ1=temp_oQ[0];

JK_FF FF1(CLK,iQ1,iQ1,rst_n,temp_oQ[1],temp_oQn[1]);
and(iQ2,temp_oQ[0],temp_oQ[1]);

JK_FF FF2(CLK,iQ2,iQ2,rst_n,temp_oQ[2],temp_oQn[2]);

reg [3:0] display_oQ;
always @* 
    begin
    oQ = temp_oQ;
    display_oQ[3]=0;
    display_oQ[2:0]=oQ;
    end

wire [6:0] temp_display;
display7 display7(display_oQ,temp_display);
assign oDisplay = temp_display;

endmodule
