`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 20:24:26
// Design Name: 
// Module Name: pcreg_tb
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


module pcreg_tb();
    reg clk;
    reg rst;
    reg ena;
    reg [31:0] data_in;
    wire [31:0] data_out;
    
    pcreg uut(clk, rst, ena, data_in, data_out);
    
    initial begin
        clk=0;
        rst=0;
        ena=1;
        data_in=32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
    
    always
        #20 clk=~clk;
        
    initial begin
        #40 data_in=32'b0000_0000_1111_1111_0000_0000_0000_0000;
        #40 data_in=32'b1111_1111_0000_1111_0000_0000_1111_1111;
        
        #40 ena=0;
        #40 data_in=32'b0000_0000_1111_1111_0000_0000_0000_0000;
        #40 ena=1;
        
        #10 rst=1;
        #40 data_in=32'b1111_1111_0000_1111_0000_0000_1111_1111;
        
        #40 rst=0;
    end
    
endmodule
