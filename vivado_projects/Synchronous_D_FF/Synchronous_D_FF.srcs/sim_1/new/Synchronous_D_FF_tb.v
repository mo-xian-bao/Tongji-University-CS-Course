`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 15:35:09
// Design Name: 
// Module Name: Synchronous_D_FF_tb
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


module Synchronous_D_FF_tb();
    reg CLK, D, RST_n;
    wire Q1, Q2;
    
    Synchronous_D_FF uut(.CLK(CLK), .D(D), .RST_n(RST_n), .Q1(Q1), .Q2(Q2));
    
   initial
        CLK = 0;
    always 
        #10 CLK = ~CLK;
        
    initial
    begin
        D=1;
        RST_n=0;
        #50
        D=1;
        RST_n=1;
        #50
        D=0;
        RST_n=0;
        #50
        D=0;
        RST_n=1;
    end
    
endmodule
