`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 16:38:39
// Design Name: 
// Module Name: display7
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


module display7(
input [3:0] iData,//四位输入 D3~D0
output reg [6:0] oData //七位译码输出 g~a
);
always @(iData)
    begin
    if(iData == 4'b0000)
        oData = 7'b1000000;
    if(iData == 4'b0001)
        oData = 7'b1111001;
    if(iData == 4'b0010)
        oData = 7'b0100100;
    if(iData == 4'b0011)
        oData = 7'b0110000;
    if(iData == 4'b0100)
        oData = 7'b0011001;
    if(iData == 4'b0101)
        oData = 7'b0010010;
    if(iData == 4'b0110)
        oData = 7'b0000010;
    if(iData == 4'b0111)
        oData = 7'b1111000;
    if(iData == 4'b1000)
        oData = 7'b0000000;
    if(iData == 4'b1001)
        oData = 7'b0010000;
    end
endmodule
