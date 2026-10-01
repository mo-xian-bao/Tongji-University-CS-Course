`timescale 1ns / 1ps

// 摔鸡蛋测试 - Drop Eggs Test
module PCPU_tb_drop_eggs();

    reg clk;
    reg rst;
    wire halt;
    integer i;
    integer cycle_count;
    
    // 实例化CPU
    PCPU uut (
        .clk(clk),
        .rst(rst),
        .halt(halt)
    );
    
    // 时钟生成 - 10ns周期
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 周期计数器
    initial begin
        cycle_count = 0;
        forever begin
            @(posedge clk);
            if (!rst && !halt) cycle_count = cycle_count + 1;
        end
    end
    
    // 测试流程
    initial begin
        $display("============================================================");
        $display("  PCPU Egg Drop Problem Test");
        $display("============================================================");
        $display("Program: drop_eggs.asm");
        $display("Binary Search Algorithm: Finding threshold floor");
        $display("Parameters: 100 floors, secret threshold = 37");
        $display("============================================================\n");
        
        // 复位
        rst = 1;
        #20;
        rst = 0;
        $display("[%0t ns] CPU started", $time);
        
        // 等待halt信号
        wait(halt == 1);
        $display("[%0t ns] CPU halted after %0d cycles", $time, cycle_count);
        
        // 等待流水线完成
        repeat(10) @(posedge clk);
        
        // 输出结果
        $display("\n============================================================");
        $display("  Memory Contents (First 16 words)");
        $display("============================================================");
        $display("Addr | Decimal Value | Hex Value  | Description");
        $display("-----|---------------|------------|---------------------------");
        
        // Output memory mapping
        $display(" [0] | %13d | 0x%08h | SECRET_THRESHOLD (37)", uut.dmem.mem[0], uut.dmem.mem[0]);
        $display(" [1] | %13d | 0x%08h | TOTAL_FLOORS (100)", uut.dmem.mem[1], uut.dmem.mem[1]);
        $display(" [2] | %13d | 0x%08h | low", uut.dmem.mem[2], uut.dmem.mem[2]);
        $display(" [3] | %13d | 0x%08h | high", uut.dmem.mem[3], uut.dmem.mem[3]);
        $display(" [4] | %13d | 0x%08h | current_floor", uut.dmem.mem[4], uut.dmem.mem[4]);
        $display(" [5] | %13d | 0x%08h | m_up (move up count)", uut.dmem.mem[5], uut.dmem.mem[5]);
        $display(" [6] | %13d | 0x%08h | n_down (move down count)", uut.dmem.mem[6], uut.dmem.mem[6]);
        $display(" [7] | %13d | 0x%08h | h_broken (broken eggs)", uut.dmem.mem[7], uut.dmem.mem[7]);
        $display(" [8] | %13d | 0x%08h | last_drop_broken", uut.dmem.mem[8], uut.dmem.mem[8]);
        $display(" [9] | %13d | 0x%08h | [OUT] Threshold found", uut.dmem.mem[9], uut.dmem.mem[9]);
        $display("[10] | %13d | 0x%08h | [OUT] Cost1 (f1)", uut.dmem.mem[10], uut.dmem.mem[10]);
        $display("[11] | %13d | 0x%08h | [OUT] Cost2 (f2)", uut.dmem.mem[11], uut.dmem.mem[11]);
        
        for (i = 12; i < 16; i = i + 1) begin
            $display("[%2d] | %13d | 0x%08h | (unused)", i, uut.dmem.mem[i], uut.dmem.mem[i]);
        end
        
        // Detailed results
        $display("\n============================================================");
        $display("  Test Results Summary");
        $display("============================================================");
        $display("Input Parameters:");
        $display("  SECRET_THRESHOLD (durability) = %d", uut.dmem.mem[0]);
        $display("  TOTAL_FLOORS (total floors)   = %d", uut.dmem.mem[1]);
        
        $display("\nAlgorithm Statistics:");
        $display("  Move up count (m_up)      = %d", uut.dmem.mem[5]);
        $display("  Move down count (n_down)  = %d", uut.dmem.mem[6]);
        $display("  Broken eggs (h_broken)    = %d", uut.dmem.mem[7]);
        $display("  Last drop status          = %d (%s)", 
                 uut.dmem.mem[8], 
                 uut.dmem.mem[8] == 1 ? "Broken" : (uut.dmem.mem[8] == 0 ? "Survived" : "Not tested"));
        
        $display("\nFinal Results:");
        $display("  Threshold found           = %d", uut.dmem.mem[9]);
        $display("  Cost1 (m*2+n*1+h*4)       = %d", uut.dmem.mem[10]);
        $display("  Cost2 (m*4+n*1+h*2)       = %d", uut.dmem.mem[11]);
        
        // Comparison with C program expected results
        $display("\n============================================================");
        $display("  Comparison with C Program Expected Results");
        $display("============================================================");
        $display("Item             | CPU Result | C Expected | Status");
        $display("-----------------|------------|------------|--------");
        $display("Move up count    | %10d | %10d | %s", 
                 uut.dmem.mem[5], 68, 
                 (uut.dmem.mem[5] == 68) ? "PASS" : "FAIL");
        $display("Move down count  | %10d | %10d | %s", 
                 uut.dmem.mem[6], 31, 
                 (uut.dmem.mem[6] == 31) ? "PASS" : "FAIL");
        $display("Broken eggs      | %10d | %10d | %s", 
                 uut.dmem.mem[7], 2, 
                 (uut.dmem.mem[7] == 2) ? "PASS" : "FAIL");
        $display("Threshold found  | %10d | %10d | %s", 
                 uut.dmem.mem[9], 37, 
                 (uut.dmem.mem[9] == 37) ? "PASS" : "FAIL");
        $display("Cost1 (f1)       | %10d | %10d | %s", 
                 uut.dmem.mem[10], 175, 
                 (uut.dmem.mem[10] == 175) ? "PASS" : "FAIL");
        $display("Cost2 (f2)       | %10d | %10d | %s", 
                 uut.dmem.mem[11], 307, 
                 (uut.dmem.mem[11] == 307) ? "PASS" : "FAIL");
        
        // Verification result
        $display("\n============================================================");
        $display("  Overall Verification");
        $display("============================================================");
        if (uut.dmem.mem[5] == 68 &&
            uut.dmem.mem[6] == 31 &&
            uut.dmem.mem[7] == 2 &&
            uut.dmem.mem[9] == 37 &&
            uut.dmem.mem[10] == 175 &&
            uut.dmem.mem[11] == 307) begin
            $display("*** PASS: All tests passed! ***");
            $display("CPU results match C program perfectly!");
        end else begin
            $display("*** FAIL: Some tests failed! ***");
            $display("Please check assembly code logic or CPU implementation.");
        end
        $display("============================================================\n");
        
        #100;
        $finish;
    end
    
    // 超时保护 - 500000ns (摔鸡蛋程序可能需要更多周期)
    initial begin
        #500000;
        $display("\n============================================================");
        $display("ERROR: Simulation timeout at %0t ns!", $time);
        $display("Binary search may have infinite loop or CPU stalled.");
        $display("============================================================");
        $finish;
    end

endmodule
