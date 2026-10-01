`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DCPU_tb
// Description: 单周期/流水线CPU测试平台 - 顶层测试
//////////////////////////////////////////////////////////////////////////////////

module DCPU_tb();

    // 信号定义
    reg clk;
    reg rst;
    reg intr;
    wire [31:0] PC_out;
    wire [31:0] instr_out;
    
    // 待测模块实例化 (实例化 DCPU)
    DCPU uut(
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
    
    // 测试激励
    initial begin
        // 打印时间单位
        $printtimescale(DCPU_tb);
        
        // 复位信号
        rst = 1;
        intr = 0;
        #20;
        rst = 0;
        
        // 运行足够长的时间
        // 等待 200,000ns (200us) 后结束仿真
        #200000;
        
        // 仿真超时
        $display("Simulation Timeout.");
        $display("Final PC = %h", PC_out);
        $finish;
    end
    
    // 监控程序执行，检测死循环结束标志
    // 注意：这里使用的是 IF 阶段的指令。如果是流水线，可能需要 ID_EX_PC 等信号
    always @(posedge clk) begin
        if (!rst) begin
            $display("Time=%0t | PC=%h | Instr=%h", $time, PC_out, instr_out);
            
            // 检测死循环指令 (beq $0, $0, -1 -> 1000ffff) 以结束仿真
            if (instr_out == 32'h1000ffff) begin
                $display("Detected Infinite Loop (End of Program). Stopping simulation.");
                $finish;
            end
        end
    end

endmodule
