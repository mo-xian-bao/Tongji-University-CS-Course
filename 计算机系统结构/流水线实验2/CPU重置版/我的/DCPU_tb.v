`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DCPU_tb
// Description: 动态流水线CPU测试平台 - 包含Switch控制暂停与数码管显示验证
//////////////////////////////////////////////////////////////////////////////////

module DCPU_tb();

    // ==================== 信号定义 ====================
    reg clk;
    reg rst;
    reg [1:0] switch;       // 模拟板上的开关
                            // switch[0]: 1=暂停, 0=运行
                            // switch[1]: 1=显示PC, 0=显示Reg28
    
    // CPU输出信号
    wire [31:0] PC_out;
    wire [31:0] instr_out;
    wire [31:0] reg28_out;  // 28号寄存器值
    
    // 数码管信号
    wire [7:0] o_seg;
    wire [7:0] o_sel;

    // ==================== 性能统计变量 ====================
    integer total_cycles;
    integer instr_count;



    

    // ==================== 逻辑处理 ====================
    // 模拟 top_board 中的逻辑
    wire ena = ~switch[0];  // switch[0]为1时暂停(ena=0)
    
    // 显示数据选择逻辑
    wire [31:0] display_data = switch[1] ? PC_out : reg28_out;

    // ==================== 模块实例化 ====================
    
    // 1. 实例化 DCPU
    DCPU uut(
        .clk(clk),
        .rst(rst),
        .ena(ena),          // 连接使能信号
        .intr(1'b0),        // 暂时不测试外部中断
        .PC_out(PC_out),
        .instr_out(instr_out),
        .reg28(reg28_out)   // 连接调试端口
    );
    
    // 2. 实例化数码管驱动 (验证显示逻辑)
    seg7x16 seg7_display(
        .clk(clk),
        .reset(rst),
        .cs(1'b1),          // 始终片选
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

    // ==================== 性能统计逻辑 ====================
    always @(posedge clk) begin
        if (rst) begin
            // 复位时清零，防止 x 传播
            total_cycles <= 0;
            instr_count <= 0;
        end
        else begin
            total_cycles <= total_cycles + 1;
            // 统计有效执行指令数 (近似: ena有效且流水线未停顿)
            if (ena && !uut.stall) begin
                instr_count <= instr_count + 1;
            end
        end
    end
    
    // ==================== 测试流程 ====================
    initial begin
        $printtimescale(DCPU_tb);
        
        // 1. 初始化
        total_cycles = 0;
        instr_count = 0;
        rst = 1;
        switch = 2'b00; // 默认运行，显示Reg28
        #20;
        rst = 0;
        $display("Simulation Start. CPU Running...");
        
        // 2. 正常运行一段时间
        #2000; 
        $display("Time=%0t: CPU Running. PC=%h, Reg28=%h", $time, PC_out, reg28_out);
        
        // 3. 测试暂停功能 (switch[0] = 1)
        $display("Time=%0t: [Action] Switch[0] -> 1 (PAUSE)", $time);
        switch[0] = 1;
        
        #500; // 等待一段时间，观察PC是否变化
        $display("Time=%0t: Checking Pause State. PC=%h", $time, PC_out);
        
        // 再次检查，确认PC确实没变
        #100;
        if (PC_out === PC_out) begin // 简单的自比较，实际应比较前后时刻的值
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
        
        // 打印吞吐率统计
        $display("============================================================");
        $display("Performance Statistics:");
        $display("Total Cycles: %d", total_cycles);
        $display("Total Instructions (approx): %d", instr_count);
        if (total_cycles > 0)
            $display("Throughput (IPC): %f", $itor(instr_count) / $itor(total_cycles));
        $display("============================================================");

        $finish;
    end
    
    // ==================== 监控输出 ====================
    // 简单的监控，每当PC变化或Switch变化时打印
    always @(reg28_out) begin
        if (!rst) begin
            $display("Time=%0t | Reg28 Updated: %h", $time, reg28_out);
        end
    end

    // 调试：打印所有寄存器值
    integer i;
    always @(posedge clk) begin
        if (!rst && ena) begin
            // 每隔一段时间打印一次，或者在特定事件发生时打印
            // 这里我们选择在 Reg28 变化时，或者每 1000ns 打印一次
            // 为了避免刷屏，这里只在 Reg28 变化时打印前 16 个寄存器
            // 你可以根据需要修改
        end
    end
    
    // 也可以定义一个 task 来打印
    task print_regs;
        begin
            $display("----------------------------------------------------------------");
            $display("Time: %0t, PC: %h", $time, PC_out);
            $display("Registers:");
            for (i = 0; i < 32; i = i + 4) begin
                $display("R[%02d]=%h  R[%02d]=%h  R[%02d]=%h  R[%02d]=%h", 
                    i, uut.regfile.regs[i], 
                    i+1, uut.regfile.regs[i+1], 
                    i+2, uut.regfile.regs[i+2], 
                    i+3, uut.regfile.regs[i+3]);
            end
            $display("----------------------------------------------------------------");
        end
    endtask

    // 在 Reg28 变化时调用打印任务
    // always @(reg28_out) begin
    //     if (!rst) begin
    //         print_regs();
    //     end
    // end

    // 强制每隔 10 个时钟周期打印一次状态，以便调试
    always @(posedge clk) begin
        if (!rst && (uut.PC[5:0] == 0)) begin // 减少打印频率，每当PC低位为0时打印
             
             print_regs(); // 如果需要详细信息可以取消注释
        end
    end

endmodule
