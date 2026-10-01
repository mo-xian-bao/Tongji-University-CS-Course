`timescale 1ns / 1ps

module top_board(
    input clk,              // 100MHz系统时钟
    input rst,              // 复位按钮
    input [1:0] switch,     // 开关: switch[0]用于暂停(1=暂停), switch[1]当前未使用
    output [7:0] seg,       // 七段数码管段选
    output [7:0] an         // 七段数码管位选
);

    // 内部信号
    wire clk_cpu;           // CPU时钟（分频后的慢时钟）
    wire [31:0] instr_value; // CPU的当前指令码
    wire [31:0] pc_value;    // PC值
    wire [31:0] reg28_value; // 28号寄存器值
    wire [31:0] anscode_value; // DMEM[0]，对应ANSCODE显示单元
    
    // switch[0]为1时暂停(ena=0)，为0时运行(ena=1)
    wire ena = ~switch[0];   
    
    // 分频器：100MHz -> ~1kHz (下板调试时可更快看到结果变化)
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
        .reg28(reg28_value), // 输出28号寄存器值用于调试
        .anscode_out(anscode_value)
    );
    
    // 按实验要求，数码管显示0x10010000对应单元（ANSCODE）。
    wire [31:0] display_data = anscode_value;

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
