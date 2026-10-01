`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/11 10:05:45
// Design Name: 
// Module Name: PCPU_tb
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


module PCPU_tb();

    // 时钟和复位信号
    reg clk;
    reg rst;
    
    // 实例化 PCPU
    PCPU uut (
        .clk(clk),
        .rst(rst)
    );
    
    // 时钟生成：周期 10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 测试流程
    initial begin
        // 复位
        rst = 1;
        #20;
        rst = 0;
    end

endmodule
