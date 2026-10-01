`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: IMEM
// Description: 指令存储器（IP核版本）
//              使用Vivado分布式存储器IP核 dist_mem_gen_0
//////////////////////////////////////////////////////////////////////////////////

module IMEM(
    input [31:0] PC,
    output [31:0] Instr
);

wire [10:0] PC_addr;  // 11位指令码地址
assign PC_addr = PC[12:2] - 32'h00400000;  // 计算PC地址映射

// 实例化IP核，输入指令码地址返回对应的指令
dist_mem_gen_0 Instr_mem(
    .a(PC_addr),
    .spo(Instr)
);

endmodule
