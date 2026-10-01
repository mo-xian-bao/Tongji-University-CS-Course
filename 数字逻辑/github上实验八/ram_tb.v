`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 20:06:46
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
    reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    
    ram
    RAM(
        .clk(clk),
        .ena(ena),
        .wena(wena),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    //clk
    initial
    begin
        clk = 0;
        #1 clk = 1;
    end
    always #2 clk = ~clk;
    
    initial 
    begin
        ena = 0;
        #20 ena = 1;        
       
        wena = 1;
        addr = 5'b0000;
        data_in = 32'b1;
        #5
        addr = 5'b0001;
        data_in = 32'b0011;
        
        #5
        addr = 5'b0011;
        data_in = 32'b0101;
        
        #5
        addr = 5'b1001;
        data_in = 32'b1111;
        
         #5
        addr = 5'b1110;
        data_in = 32'b0110;
        
        #5
        addr = 5'b0101;
        data_in = 32'b0100;
       
        
        #20 
        wena = 0;
        addr = 5'b0001;
        #50
        addr = 5'b0000;
        #50
        addr = 5'b1001;
        #50
        addr = 5'b0011;
        #50
        addr = 5'b0101;
        #50
        addr = 5'b1110;
        
        
    end
    
endmodule
