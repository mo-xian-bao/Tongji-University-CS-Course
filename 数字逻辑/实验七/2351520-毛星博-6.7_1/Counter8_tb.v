`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 15:37:58
// Design Name: 
// Module Name: Counter8_tb
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


module Counter8_tb();
    reg CLK, rst_n;
    wire [2:0] oQ;
    wire [6:0] oDisplay;
   
    Counter8 uut(CLK, rst_n, oQ, oDisplay);
    
    initial begin
        rst_n = 0;
        CLK = 0;
        #10 rst_n = 1;
        #200 rst_n = 0;
    end
    
    always
        #5 CLK=~CLK;
    
endmodule
