`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 20:05:31
// Design Name: 
// Module Name: ram
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


module ram(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    input [31:0] data_in,
    output reg [31:0]  data_out
    );
     reg [31:0] ram [31:0];
    always @(posedge clk or negedge ena)
        begin 
            if(ena)
            begin
                if(wena)  
                    ram[addr] <= data_in;   //wena:1, input data
                else data_out <= ram[addr];  //wena:0, output data
            end
            else 
                data_out <= 32'bz;           //ena:0 reset RAM to z
        end
endmodule
