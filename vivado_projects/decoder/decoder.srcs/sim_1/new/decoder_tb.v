`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 15:40:30
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb();
    reg [2:0] iData;
    reg [1:0] iEna;
    wire [7:0] oData;
    
    decoder uut(.iData(iData), .iEna(iEna), .oData(oData));
    
    initial
    begin
        iEna=2'b11;
        iData=3'b000;
        #50
        iEna=2'b01;
        iData=3'b000;
        #50
        iEna=2'b00;
        iData=3'b000;
        #50
        iEna=2'b10;
        iData=3'b000;
        #50
        iEna=2'b10;
        iData=3'b001;
        #50
        iEna=2'b10;
        iData=3'b010;
        #50
        iEna=2'b10;
        iData=3'b011;
        #50
        iEna=2'b10;
        iData=3'b100; 
        #50
        iEna=2'b10;
        iData=3'b101;    
        #50
        iEna=2'b10;
        iData=3'b110;    
        #50
        iEna=2'b10;
        iData=3'b111;    
    end
endmodule
