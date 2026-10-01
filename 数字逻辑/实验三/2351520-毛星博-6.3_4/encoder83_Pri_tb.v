`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 17:29:09
// Design Name: 
// Module Name: encoder83_Pri_tb
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


module encoder83_Pri_tb();
reg [7:0] iData;
reg iEI;
wire [2:0] oData;
wire oEO;

encoder83_Pri uut(.iData(iData),.iEI(iEI),.oData(oData),.oEO(oEO));

initial
begin
        iEI=0;
    #40
        iEI=1;
        iData = 8'b1111_1111;
    #40 iData = 8'b1111_1110;
    #40 iData = 8'b1111_1100;                      
    #40 iData = 8'b1111_1000;
    #40 iData = 8'b1111_0000;
    #40 iData = 8'b1110_0000;
    #40 iData = 8'b1100_0000;
    #40 iData = 8'b1000_0000;
    #40 iData = 8'b0000_0000; 
end
endmodule
