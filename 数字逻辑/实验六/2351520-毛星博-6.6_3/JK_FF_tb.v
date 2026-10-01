`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 15:43:03
// Design Name: 
// Module Name: JK_FF_tb
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


module JK_FF_tb();
    reg CLK, J, K, RST_n;
    wire Q1,Q2;
    
    JK_FF uut(CLK, J, K, RST_n, Q1, Q2);
    
    initial
        CLK=0;
    always
        #10 CLK=~CLK;
    
    initial begin
            RST_n = 1; J = 1;K = 0;
            #40 J = 1; K = 1;
            #40 J = 0; K = 0;
            #40 J = 0; K = 1;
            #40 J = 1; K = 0;
            
            #35 RST_n = 0; J = 1; K = 0;
            #40 J = 1; K = 1;
            #40 J = 0; K = 0;
            #40 J = 0; K = 1;
    end
endmodule
