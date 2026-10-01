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
    input intr_sw,          // 中断开关
    output halt,            // 停机指示灯
    output [7:0] seg,       // 七段数码管段选
    output [7:0] an         // 七段数码管位选
);

    // 内部信号
    wire clk_cpu;           // CPU时钟（分频后的慢时钟）
    wire [31:0] instr_value; // CPU的当前指令码
    wire mem_w;
    wire [31:0] mem_addr;
    wire [31:0] mem_data;
    reg [31:0] display_value; // 要显示的值

    // 分频器：100MHz -> 10Hz (更慢的速度，便于观察)
    // 如果需要更慢，可以修改Divider模块的分频比
    Divider divider_cpu(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_cpu)
    );
    
    // DCPU实例（使用分频后的慢时钟）
    DCPU cpu(
        .clk(clk_cpu),      // 使用分频后的慢时钟
        .rst(rst),
        .intr(intr_sw),     // 连接中断开关
        .PC_out(),
        .instr_out(instr_value), // 输出指令码供显示
        .mem_w(mem_w),
        .mem_addr(mem_addr),
        .mem_data(mem_data)
    );

    // 捕获要显示的值
    // 只要CPU执行了sw指令（即计算出abcd数组的某个值，就显示）
    always @(posedge clk_cpu or posedge rst) begin
        if (rst) begin
            display_value <= 32'b0;
        end else if (mem_w) begin
            display_value <= mem_data;
        end
    end
    
    // 七段数码管驱动（使用快时钟进行扫描，避免闪烁）
    seg7x16 seg7_display(
        .clk(clk),          // 使用100MHz快时钟进行扫描
        .reset(rst),
        .cs(clk_cpu),          
        .i_data(display_value), // 显示捕获的值
        .o_seg(seg),
        .o_sel(an)
    );

endmodule
