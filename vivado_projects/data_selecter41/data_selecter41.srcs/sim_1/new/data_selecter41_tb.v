`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/23 16:10:22
// Design Name: 
// Module Name: data_selecter41_tb
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


module selector41_tb();
    reg [3:0] iC0;
    reg [3:0] iC1;
    reg [3:0] iC2;
    reg [3:0] iC3;
    reg iS0;
    reg iS1;
    wire oZ;
    
    selector41 uut(.iC0(iC0), .iC1(iC1), .iC2(iC2), .iC3(iC3), .iS1(iS1), .iS0(iS0), .oZ(oZ)); //สตภýปฏ
    
    initial
    begin
        iC0 = 4'b0001;
        iC1 = 4'b0010;
        iC2 = 4'b0100;
        iC3 = 4'b1000;  
    end
    
    always
    begin
        iS1 = 0;
        iS0 = 0;
        #40; 
        iS1 = 1;
        iS0 = 1;
        #40; 
        iS1 = 0;
        iS0 = 1;
        #40; 
        iS1 = 1;
        iS0 = 0;
        #40;
    end    
                 
endmodule
