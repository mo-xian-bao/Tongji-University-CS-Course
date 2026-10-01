`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 15:38:43
// Design Name: 
// Module Name: Divider
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


module Divider (
input I_CLK, //输入时钟信号，上升沿有效
input rst, //同步复位信号，高电平有效
output reg O_CLK //输出时钟
);
    parameter count = 10;
    integer n = 1;
    initial O_CLK = 0;

    always @(posedge I_CLK) begin
        if(rst)
            O_CLK <= 0;
        else begin
            if(n < count)
                n <= n + 1;
            else begin
                n <= 1;
                O_CLK=~O_CLK;
            end
        end
    end

endmodule
