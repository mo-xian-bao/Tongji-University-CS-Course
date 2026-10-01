`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 16:12:05
// Design Name: 
// Module Name: barrelshifter32_tb
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


module barrelshifter32_tb();
    reg [31:0] a;
    reg [4:0] b;
    reg [1:0] aluc;
    wire [31:0] c;
    
    barrelshifter32 uut(.a(a), .b(b), .aluc(aluc), .c(c));
    
    initial
    begin
        // À„ ı”““∆ 1Œª
            a = 32'b11010101_01010101_01011101_01010101;
            b = 5'b00001;
            aluc = 2'b00;
        // ¬ﬂº≠”““∆ 2Œª
            #40
            a = 32'b11010101_01010101_01011101_01010101;        
            b = 5'b00010;
            aluc = 2'b10;
        // À„ ı◊Û“∆ 3Œª   
            #40
            a = 32'b11010101_01010101_01011101_01010101;
            b = 5'b00011;
            aluc = 2'b01;
        // ¬ﬂº≠◊Û“∆ 4Œª
            #40
            a = 32'b11010101_01010101_01011101_01010101;
            b = 5'b00100;
            aluc = 2'b11;                     
        // À„ ı◊Û“∆ 8Œª
            #40
            a = 32'b11010101_01010101_01011101_01010101;
            b = 5'b01000;
            aluc = 2'b01;
        // ¬ﬂº≠◊Û“∆ 16Œª
            #40
            a = 32'b11010101_01010101_01011101_01010101;
            b = 5'b10000;
            aluc = 2'b11;
    end
endmodule
