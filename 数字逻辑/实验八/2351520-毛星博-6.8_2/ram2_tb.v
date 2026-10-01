`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 16:43:41
// Design Name: 
// Module Name: ram2_tb
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


module ram2_tb();
    reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    wire [31:0] data;
    reg [31:0] data_in;
    
    ram2 uut(clk, ena, wena, addr, data);
    
    initial begin
            clk = 1;
            ena = 1;
            wena = 0;
            addr = 0;
            data_in = 32'hffff_ffff;
        end
    
    always
            #20 clk = ~clk;
            
    assign data = wena ? data_in : 32'hzzzz_zzzz;
    
    initial begin
            #30 wena = 1;
                addr = 1; data_in = 32'hab10_4588;
            #5  wena = 0;
            #5  wena = 1;
            #10 wena = 0;
            #20 wena = 0;
                addr = 8; data_in = 32'h0000_0010;
            #40 addr = 30;
            #40 wena = 0;
                addr = 1;
            #40 addr = 7;
                wena = 1;
            #40 wena = 0;
                addr = 7; data_in = 32'h7896_1255;
            #40 wena = 1;
                ena = 0; 
            #40 ena = 1;
                wena = 0;           
        end
endmodule
