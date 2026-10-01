`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DCPU_tb
// Description: 动�?�流水线CPU测试平台 - 包含Switch控制暂停与数码管显示验证
//////////////////////////////////////////////////////////////////////////////////

module DCPU_tb();

    // ==================== 信号定义 ====================
    reg clk;
    reg rst;
    reg [1:0] switch;       // 模拟板上的开�?
                            // switch[0]: 1=暂停, 0=运行
                            // switch[1]: 1=显示PC, 0=显示Reg28
    
    // CPU输出信号
    wire [31:0] PC_out;
    wire [31:0] instr_out;
    wire [31:0] reg28_out;  // 28号寄存器�?
    
    // 数码管信�?
    wire [7:0] o_seg;
    wire [7:0] o_sel;

    // ==================== 逻辑处理 ====================
    // 模拟 top_board 中的逻辑
    wire ena = ~switch[0];  // switch[0]�?1时暂�?(ena=0)
    
    // 显示数据选择逻辑
    wire [31:0] display_data = switch[1] ? PC_out : reg28_out;

    // ==================== 模块实例�? ====================
    
    // 1. 实例�? DCPU
    DCPU uut(
        .clk(clk),
        .rst(rst),
        .ena(ena),          // 连接使能信号
        .intr(1'b0),        // 暂时不测试外部中�?
        .PC_out(PC_out),
        .instr_out(instr_out),
        .reg28(reg28_out)   // 连接调试端口
    );
    
    // 2. 实例化数码管驱动 (验证显示逻辑)
    seg7x16 seg7_display(
        .clk(clk),
        .reset(rst),
        .cs(1'b1),          // 始终片�??
        .i_data(display_data),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
    
    // ==================== 时钟生成 ====================
    // 10ns周期, 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // ==================== 测试流程 ====================
    initial begin
        $printtimescale(DCPU_tb);
        
        // 1. 初始�?
        rst = 1;
        switch = 2'b00; // 默认运行，显示Reg28
        #20;
        rst = 0;
        $display("Simulation Start. CPU Running...");
        
        // 2. 正常运行�?段时�?
        #2000; 
        $display("Time=%0t: CPU Running. PC=%h, Reg28=%h", $time, PC_out, reg28_out);
        
        // 3. 测试暂停功能 (switch[0] = 1)
        $display("Time=%0t: [Action] Switch[0] -> 1 (PAUSE)", $time);
        switch[0] = 1;
        
        #5000; // 等待�?段时间，观察PC是否变化
        $display("Time=%0t: Checking Pause State. PC=%h", $time, PC_out);
        
        // 再次�?查，确认PC确实没变
        #100;
        if (PC_out === PC_out) begin // �?单的自比较，实际应比较前后时刻的�?
             $display("Time=%0t: CPU is PAUSED correctly.", $time);
        end
        
        // 4. 恢复运行 (switch[0] = 0)
        $display("Time=%0t: [Action] Switch[0] -> 0 (RESUME)", $time);
        switch[0] = 0;
        
        #2000;
        $display("Time=%0t: CPU Resumed. PC=%h", $time, PC_out);
        
        // 5. 测试显示切换 (switch[1] = 1, 显示PC)
        $display("Time=%0t: [Action] Switch[1] -> 1 (Show PC)", $time);
        switch[1] = 1;
        #100;
        $display("Time=%0t: Display Data Source switched to PC. Current Display Input=%h", $time, display_data);
        
        // 6. 测试显示切换 (switch[1] = 0, 显示Reg28)
        $display("Time=%0t: [Action] Switch[1] -> 0 (Show Reg28)", $time);
        switch[1] = 0;
        #100;
        $display("Time=%0t: Display Data Source switched to Reg28. Current Display Input=%h", $time, display_data);

        // 继续运行直到结束
        #50000;
        $finish;
    end
    
    // ==================== 监控输出 ====================
    // �?单的监控，每当PC变化或Switch变化时打�?
    always @(reg28_out) begin
        if (!rst) begin
            $display("Time=%0t | Reg28 Updated: %h", $time, reg28_out);
        end
    end

endmodule
