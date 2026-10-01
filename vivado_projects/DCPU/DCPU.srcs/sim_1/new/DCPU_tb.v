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
    wire mem_w;
    wire [31:0] mem_addr;
    wire [31:0] mem_data;
    
    // 待测模块实例化 (实例化 DCPU)
    DCPU uut(
        .clk(clk),
        .rst(rst),
        .intr(intr),
        .PC_out(PC_out),
        .instr_out(instr_out),
        .mem_w(mem_w),
        .mem_addr(mem_addr),
        .mem_data(mem_data)
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
        
        // 1. 复位
        rst = 1;
        intr = 0;
        #20;
        rst = 0;
        $display("Time=%0t | [Test] Reset released, CPU started.", $time);
        
        // 2. 让 CPU 正常运行一段时间 (例如 2000ns)
        #2000;
        
        // 3. 模拟外部中断触发 (拉高 intr)
        $display("Time=%0t | [Test] Asserting Interrupt Signal (intr = 1)", $time);
        intr = 1;
        
        // 4. 保持中断信号一段时间 (例如 200ns，确保 CPU 能响应)
        #2000; 
        
        // 5. 撤销外部中断
        intr = 0;
        $display("Time=%0t | [Test] De-asserting Interrupt Signal (intr = 0)", $time);

        // 6. 继续运行，观察 CPU 是否从中断返回
        // 等待 200,000ns (200us) 后结束仿真
        #200000;
        
        // 仿真超时
        $display("Simulation Timeout.");
        $display("Final PC = %h", PC_out);
        $finish;
    end
    
    // 监控程序执行
    always @(posedge clk) begin
        if (!rst) begin
            // 监控内存写入
            if (mem_w) begin
                $display("Time=%0t | Write Memory: Addr=%h, Data=%h (%d)", $time, mem_addr, mem_data, mem_data);
            end

            // [新增] 监控是否跳转到了异常入口地址 (0x00400004)
            if (PC_out == 32'h00400004) begin
                $display("Time=%0t | [CPU Status] Entered Exception Handler at 0x00400004", $time);
            end

            // 检测死循环指令 (beq $0, $0, -1 -> 1000ffff) 以结束仿真
            if (instr_out == 32'h1000ffff) begin
                $display("Detected Infinite Loop (End of Program). Stopping simulation.");
                $finish;
            end
        end
    end

    // ============================================================
    // 调试探针：监控 CP0 和 中断状态
    // ============================================================
    always @(posedge clk) begin
        // 当 intr 为高，或者检测到异常发生信号时打印
        if (intr || uut.exc_occur) begin
             $display("DEBUG: Time=%0t | intr=%b | IE=%b | irq_req=%b | exc_occur=%b | PC=%h | Status=%h | Cause(Reg)=%h", 
                      $time, 
                      intr,
                      uut.cp0.cp0_regs[12][0], // Status[0] = IE
                      uut.cp0.irq_req,         // CP0 输出的中断请求
                      uut.exc_occur,           // DCPU 内部的异常触发信号
                      PC_out, 
                      uut.cp0.cp0_regs[12],    // Status 寄存器全值
                      uut.cp0.cp0_regs[13]);   // Cause 寄存器全值
        end
    end

endmodule
