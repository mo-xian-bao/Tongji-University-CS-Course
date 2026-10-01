`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DCPU_tb
// Description: 动态流水线CPU测试平台
//////////////////////////////////////////////////////////////////////////////////

module DCPU_tb();

    // 测试信号
    reg clk;
    reg rst;
    reg intr;
    wire [31:0] PC_out;
    wire [31:0] instr_out;
    
    // 实例化被测模块
    top uut(
        .clk(clk),
        .rst(rst),
        .intr(intr),
        .PC_out(PC_out),
        .instr_out(instr_out)
    );
    
    // 时钟生成 (10ns周期, 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 测试过程
    initial begin
        // 初始化
        rst = 1;
        intr = 0;
        #20;
        rst = 0;
        
        // 等待程序执行完成或超时
        #2000;
        
        // 结束仿真
        $display("Simulation finished.");
        $display("Final PC = %h", PC_out);
        $finish;
    end
    
    // 监控输出
    initial begin
        $monitor("Time=%0t PC=%h Instr=%h", $time, PC_out, instr_out);
    end

endmodule
