`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: RegFile
// Description: 寄存器文件
//              32个32位通用寄存器
//              $0寄存器恒为0
//              支持同时读取两个寄存器，写入一个寄存器
//////////////////////////////////////////////////////////////////////////////////

module RegFile(
    input clk,              // 时钟信号
    input rst,              // 复位信号
    input ena,              // 使能信号
    input we,               // 写使能信号
    input [4:0] Rdc,        // 写目标寄存器
    input [4:0] Rsc,        // 源寄存器1
    input [4:0] Rtc,        // 源寄存器2
    input [31:0] Rd,        // 写入数据
    output [31:0] Rs,       // 源寄存器1数据
    output [31:0] Rt        // 源寄存器2数据
);

reg [31:0] regs [31:0];     // 32个32位寄存器
integer i;

// 异步读取
assign Rs = (ena) ? regs[Rsc] : 32'b0;
assign Rt = (ena) ? regs[Rtc] : 32'b0;

// 同步写入
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 复位时清零所有寄存器
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] <= 32'h00000000;
        end
    end
    else begin
        // 写入（$0寄存器不能写入）
        if (ena && we && Rdc != 5'b00000) begin
            regs[Rdc] <= Rd;
        end
    end
end

endmodule
