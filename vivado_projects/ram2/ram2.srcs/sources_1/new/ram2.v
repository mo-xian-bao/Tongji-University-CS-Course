`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/11/18 16:43:31
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
    reg [31:0] ram [0:31];
    reg [31:0] temp;
    integer i;
        
        initial begin
            for (i = 0; i < 16; i = i + 1) begin
                ram[i] = 32'h0000_0000;
            end
            for (i = 16; i < 32; i = i + 1) begin
                ram[i] = 32'h1111_1111;
            end
        end
        
    always @(posedge clk) begin
        if (ena && wena) begin
            ram[addr] <= data; // 写操作
        end
    end

    always @(negedge wena) begin
        if (ena && !wena) begin
            temp <= ram[addr]; // 读操作
        end
    end
    
    assign data = (ena && !wena) ? temp : 32'bz; // 在读操作时输出数据，否则高阻态

endmodule
