`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/09 21:19:06
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input [31:0] PC,
    output [31:0] Instr
);

wire [10:0] PC_addr; // 11位指令码地址
assign PC_addr = PC[12:2] - 32'h00400000; // 计算PC地址,有一个映射关系

// 实例化IP核，输入指令码地址返回对应的指令
dist_mem_gen_0 Instr_mem(
    .a(PC_addr),
    .spo(Instr)
);

endmodule
