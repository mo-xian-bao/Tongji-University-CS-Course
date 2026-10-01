`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 16:02:16
// Design Name: 
// Module Name: DataCompare8
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


module DataCompare8(
input [7:0] iData_a, //输入数据 a
input [7:0] iData_b, //输入数据 b
output [2:0] oData //结果输出
);
wire [2:0] tmp;
DataCompare4 uut(.iData_a(iData_a[3:0]), .iData_b(iData_b[3:0]), .iData(3'b001), .oData(tmp));

reg [2:0] iData;
always @*
    iData=tmp;
DataCompare4 uul(.iData_a(iData_a[7:4]), .iData_b(iData_b[7:4]), .iData(iData), .oData(oData));

endmodule
