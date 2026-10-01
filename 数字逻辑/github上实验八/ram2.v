`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 21:45:21
// Design Name: 
// Module Name: ram2
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


module ram2(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    inout [31:0] data       
    );
    
    reg [31:0] ram [31:0];
    reg [31:0] temp;            //inout type cannot be assigned in procedural process, register needed
    
    always  @(posedge clk or negedge ena)
    begin 
        if(ena)
        begin
            if(wena) ram[addr] <= data;
            else temp <= ram[addr];
        end
        else temp <= 32'bz;
    end
     
    assign data = temp;
endmodule
