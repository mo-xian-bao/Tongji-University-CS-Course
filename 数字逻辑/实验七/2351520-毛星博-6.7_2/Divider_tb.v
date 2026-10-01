`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 15:38:58
// Design Name: 
// Module Name: Divider_tb
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


module Divider_tb();
    reg I_CLK;
    reg rst;
    wire O_CLK;
    
    Divider uut(I_CLK,rst,O_CLK);
    
    initial begin
        I_CLK=1;
        rst = 0;
        #300 rst=1;
    end
    
    always
        #5 I_CLK=~I_CLK;
endmodule
