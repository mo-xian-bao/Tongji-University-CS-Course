`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top
// Description: 仿真用顶层模块 - 支持MIPS 54条指令
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,              // 时钟
    input rst,              // 复位
    input intr,             // 外部中断
    output [31:0] PC_out,   // PC输出
    output [31:0] instr_out // 指令输出
);

    // CPU实例
    DCPU cpu(
        .clk(clk),
        .rst(rst),
        .intr(intr),
        .PC_out(PC_out),
        .instr_out(instr_out)
    );

endmodule
