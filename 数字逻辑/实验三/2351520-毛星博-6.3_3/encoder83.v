`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 17:06:17
// Design Name: 
// Module Name: encoder83
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


module encoder83(
input [7:0] iData, //八位输入 D7~D0,高电平有效
output reg [2:0] oData //三位编码输出 Y2~Y0
);
always @(iData)
    begin
       if (iData == 8'b1000_0000)
           oData = 3'b111;
       else if (iData == 8'b0100_0000)
           oData = 3'b110;
       else if (iData == 8'b0010_0000)
           oData = 3'b101;
       else if (iData == 8'b0001_0000)
           oData = 3'b100;
       else if (iData == 8'b0000_1000)
           oData = 3'b011;
       else if (iData == 8'b0000_0100)
           oData = 3'b010;
       else if (iData == 8'b0000_0010)
           oData = 3'b001; 
       else
           oData = 3'b000;  
    end
endmodule
