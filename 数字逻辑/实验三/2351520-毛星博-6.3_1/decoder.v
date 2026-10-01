`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 15:40:10
// Design Name: 
// Module Name: decoder
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


module decoder(
input [2:0] iData, //三位输入 D2,D1,D0
input [1:0] iEna, //使能信号 G1,G2
output reg [7:0] oData //八位译码输出??7~??0,低电平有效
);
always @(iData,iEna)
    begin
        oData=8'b1111_1111;
        if(iEna[1]==1 && iEna[0]==0)
            oData[iData[0]+2*iData[1]+4*iData[2]]=1'b0;
    end
endmodule
