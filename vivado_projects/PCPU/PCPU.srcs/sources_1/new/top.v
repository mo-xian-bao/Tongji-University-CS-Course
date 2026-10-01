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

module top(
    input clk,              // 100MHz系统时钟
    input rst,              // 复位按钮
    output halt,            // 停机指示灯
    output [7:0] seg,       // 七段数码管段选
    output [7:0] an         // 七段数码管位选
);

    // 内部信号
    wire clk_cpu;           // CPU时钟（分频后的慢时钟）
    wire [31:0] instr_value; // CPU的当前指令码
    
    // 分频器：100MHz -> 10Hz (更慢的速度，便于观察)
    // 如果需要更慢，可以修改Divider模块的分频比
    Divider divider_cpu(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_cpu)
    );
    
    // PCPU实例（使用分频后的慢时钟）
    PCPU cpu(
        .clk(clk_cpu),      // 使用分频后的慢时钟
        .rst(rst),
        .halt(halt),
        .instr_out(instr_value) // 输出指令码供显示
    );
    
    // 七段数码管驱动（使用快时钟进行扫描，避免闪烁）
    seg7x16 seg7_display(
        .clk(clk),          // 使用100MHz快时钟进行扫描
        .reset(rst),
        .cs(clk_cpu),          // 始终使能
        .i_data(instr_value), // 显示CPU的当前指令码
        .o_seg(seg),
        .o_sel(an)
    );

endmodule
