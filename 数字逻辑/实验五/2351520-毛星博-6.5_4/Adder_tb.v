`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 16:46:57
// Design Name: 
// Module Name: Adder_tb
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


module Adder_tb();
    reg [7:0] iData_a;
    reg [7:0] iData_b;
    reg iC;
    wire [7:0] oData;
    wire oData_C;
    
    Adder uut(.iData_a(iData_a), .iData_b(iData_b), .iC(iC), .oData(oData), .oData_C(oData_C));
    
    initial
    begin
        iData_a = 8'b0000_0000;
        iData_b = 8'b0000_0001;
        iC = 0;
        
        # 40
        iData_a = 8'b0000_0001;
        iData_b = 8'b0000_0001;
        iC = 0;
        
        # 40
        iData_a = 8'b0000_0001;
        iData_b = 8'b0000_0000;
        iC = 1;

        # 40
        iData_a = 8'b0100_0101;
        iData_b = 8'b1010_0110;
        iC = 1;        
        
        # 40
        iData_a = 8'b1110_1101;
        iData_b = 8'b1011_0110;
        iC = 0;           
        
        # 40
        iData_a = 8'b0100_1101;
        iData_b = 8'b1111_0010;
        iC = 1;   
    end
endmodule
