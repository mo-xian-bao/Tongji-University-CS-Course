`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 16:11:49
// Design Name: 
// Module Name: barrelshifter32
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


module barrelshifter32(
input [31:0] a, //32 位原始输入数据
input [4:0] b, //5 位输入信号，控制移位的位数
input [1:0] aluc, //2 位输入信号，控制移位的方式
output reg [31:0] c //32 位移位后的输出数据
);
integer i;
always @ *
    begin
        c = a;
        if (aluc[0] == 0) 
        begin
            if (aluc[1] == 1)
            begin
                c = c >>> b;
            end
            else if (aluc[1] == 0)
            begin
                if (c[31] == 1)
                begin
                    c = c >> b;
                    for (i = 0; i < b; i = i + 1)
                        c[31 - i] = 1;
                end
                else
                    c = c >> b;
            end
        end
        else if (aluc[0] == 1)
        begin 
            c = c <<< b;
        end
    end
endmodule
