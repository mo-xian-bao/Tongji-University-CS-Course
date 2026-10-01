`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/15
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 顶层模块，实例化PCPU、分频器和七段数码管
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_board(
    input clk,              // 100MHz系统时钟
    input rst,              // 复位按钮
    input [1:0] switch,     // 开关: switch[0]用于暂停(1=暂停), switch[1]用于切换显示
    output [7:0] seg,       // 七段数码管段选
    output [7:0] an         // 七段数码管位选
);

    // 内部信号
    wire clk_cpu;           // CPU时钟（分频后的慢时钟）
    wire [31:0] instr_value; // CPU的当前指令码
    wire [31:0] pc_value;    // PC值
    wire [31:0] reg28_value; // 28号寄存器值
    
    // switch[0]为1时暂停(ena=0)，为0时运行(ena=1)
    wire ena = ~switch[0];   
    
    // 分频器：100MHz -> 1Hz (便于观察)
    Divider divider_cpu(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_cpu)
    );
    
    // DCPU实例
    DCPU cpu(
        .clk(clk_cpu),      // 使用分频后的慢时钟
        .rst(rst),
        .ena(ena),          // 暂停控制信号
        .intr(1'b0),        // 外部中断未使用
        .PC_out(pc_value),
        .instr_out(instr_value),
        .reg28(reg28_value) // 输出28号寄存器值用于显示
    );
    
    // 显示数据选择
    // switch[1]=0: 显示reg28 (运算值)
    // switch[1]=1: 显示PC
    wire [31:0] display_data = switch[1] ? pc_value : reg28_value;

    // 七段数码管驱动（使用快时钟进行扫描，避免闪烁）
    seg7x16 seg7_display(
        .clk(clk),          // 使用100MHz快时钟进行扫描
        .reset(rst),
        .cs(1'b1),          // 始终使能
        .i_data(display_data), 
        .o_seg(seg),
        .o_sel(an)
    );

endmodule
