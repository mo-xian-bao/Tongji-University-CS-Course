`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/30 17:10:09
// Design Name: 
// Module Name: transmission8
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


module transmission8(
    input [7:0] iData, //输入信号 D7~D0
    input A,B,C, //选择信号 S2~S0
    output [7:0] oData //输出信号 f0~f7 
    );
    
    assign oData[0] = (A==0&&B==0&&C==0) ? iData[0] : 1;
    assign oData[1] = (A==0&&B==0&&C==1) ? iData[1] : 1;
    assign oData[2] = (A==0&&B==1&&C==0) ? iData[2] : 1;
    assign oData[3] = (A==0&&B==1&&C==1) ? iData[3] : 1;
    assign oData[4] = (A==1&&B==0&&C==0) ? iData[4] : 1;
    assign oData[5] = (A==1&&B==0&&C==1) ? iData[5] : 1;
    assign oData[6] = (A==1&&B==1&&C==0) ? iData[6] : 1;
    assign oData[7] = (A==1&&B==1&&C==1) ? iData[7] : 1;
        
endmodule
