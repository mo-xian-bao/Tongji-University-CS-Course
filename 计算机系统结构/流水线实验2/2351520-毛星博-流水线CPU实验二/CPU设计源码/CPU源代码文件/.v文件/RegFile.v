`timescale 1ns / 1ps

module RegFile(
    input clk,              // 时钟信号
    input rst,              // 复位信号
    input ena,              // 使能信号
    input we,               // 写使能信�?
    input [4:0] Rdc,        // 写目标寄存器
    input [4:0] Rsc,        // 源寄存器1
    input [4:0] Rtc,        // 源寄存器2
    input [31:0] Rd,        // 写入数据
    output [31:0] Rs,       // 源寄存器1数据
    output [31:0] Rt,       // 源寄存器2数据
    output [31:0] reg28     // 28号寄存器数据(gp)，用于调试显�?
);

reg [31:0] regs [31:0];     // 32�?32位寄存器
integer i;

// 异步读取
assign Rs = (ena) ? regs[Rsc] : 32'b0;
assign Rt = (ena) ? regs[Rtc] : 32'b0;
assign reg28 = regs[28];

    // 同步写入
    // ͬ��д��
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��λʱ�������мĴ���
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'h00000000;
            end
        end
        else begin
            // д�루$0�Ĵ�������д�룩
            if (ena && we && Rdc != 5'b00000) begin
                regs[Rdc] <= Rd;
            end
        end
    end

endmodule
