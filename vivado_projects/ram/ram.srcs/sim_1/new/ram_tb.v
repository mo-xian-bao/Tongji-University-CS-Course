`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 15:33:32
// Design Name: 
// Module Name: ram_tb
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


module ram_tb();
    reg clk, ena, wena;
    reg [4:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    
    ram uut(clk,ena,wena,addr,data_in,data_out);
    
    initial begin
        clk = 1;
        ena = 1;
        wena = 0;
        addr = 0;
        data_in = 32'hffff_ffff;
    end
    
    always
        #20 clk = ~clk;

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
