`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 15:41:08
// Design Name: 
// Module Name: Asynchronous_D_FF_tb
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


module Asynchronous_D_FF_tb();
    reg CLK, D, RST_n;
    wire Q1, Q2;
    
    Asynchronous_D_FF uul(CLK,D,RST_n, Q1,Q2);
    
    initial
        CLK=0;
    always
        #40 CLK=~CLK;
        
    initial
    begin
        D=1;
        RST_n=1;
        #60
        
        RST_n=0;
        #10
        
        D=0;
        RST_n=1;
        #60;
        
        D=0;
        RST_n=0;
    end

endmodule
