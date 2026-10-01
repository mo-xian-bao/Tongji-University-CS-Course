`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 15:34:44
// Design Name: 
// Module Name: DataCompare4
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


module DataCompare4(
input [3:0] iData_a, //输入数据 a
input [3:0] iData_b, //输入数据 b
input [2:0] iData, //级联输入a>b、a<b、a=b
output reg [2:0] oData //结果输出 A>B、A<B、A=B
);
always @*
begin
    if(iData_a==iData_b)
        oData=iData;
    else if(iData_a>iData_b)
        oData=3'b100;
    else if(iData_a<iData_b)
        oData=3'b010;
    else
        ;
end
endmodule
