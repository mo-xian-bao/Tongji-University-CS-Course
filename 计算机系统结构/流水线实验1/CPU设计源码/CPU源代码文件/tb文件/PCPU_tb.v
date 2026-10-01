`timescale 1ns / 1ps

// 摔鸡蛋测试 - Drop Eggs Test
module PCPU_tb_drop_eggs();

    reg clk;
    reg rst;
    wire halt;
    integer i;
    integer cycle_count;
    integer instr_count;        // 动态指令计数器
    reg [31:0] prev_pc;         // 上一个PC值
    
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
    
    // 动态指令计数器（统计IF阶段取出的非NOP指令）
    // 这是最准确的方法：每当IF阶段取出一条有效指令就计数
    initial begin
        instr_count = 0;
        prev_pc = 32'h00400000;
        @(negedge rst);  // 等待复位结束
        forever begin
            @(posedge clk);
            if (!halt && !uut.stall && !uut.flush_IF_ID) begin
                // 统计IF阶段取出的指令（排除NOP）
                if (uut.IF_instr != 32'h00000000) begin
                    instr_count = instr_count + 1;
                    //$display("[Cycle %0d] Instr #%0d: PC=0x%08h, Opcode=0x%02h", 
                    //         cycle_count, instr_count, uut.PC, uut.IF_instr[31:26]);
                end
            end
        end
    end
    
    // 测试流程
    initial begin
        $display("============================================================");
        $display("  PCPU Egg Drop Problem Test");
        $display("============================================================");
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
        $display("         Dynamic instruction count: %0d", instr_count);
        $display("         Throughput (TP) = %0d / %0d = %.3f", instr_count, cycle_count, real'(instr_count)/real'(cycle_count));
        $display("         CPI (Cycles Per Instruction) = %0d / %0d = %.3f", cycle_count, instr_count, real'(cycle_count)/real'(instr_count));
        
        // 等待流水线完成
        repeat(10) @(posedge clk);
        
        // 输出结果
        $display("\n============================================================");
        $display("  Register File Contents (Results)");
        $display("============================================================");
        $display("Reg  | Decimal Value | Hex Value  | Description");
        $display("-----|---------------|------------|---------------------------");
        
        // Output register results
        $display("$s0  | %13d | 0x%08h | SECRET_THRESHOLD", uut.regfile.array_reg[16], uut.regfile.array_reg[16]);
        $display("$s1  | %13d | 0x%08h | TOTAL_FLOORS", uut.regfile.array_reg[17], uut.regfile.array_reg[17]);
        $display("$s2  | %13d | 0x%08h | low", uut.regfile.array_reg[18], uut.regfile.array_reg[18]);
        $display("$s3  | %13d | 0x%08h | [OUT] Threshold found", uut.regfile.array_reg[19], uut.regfile.array_reg[19]);
        $display("$s4  | %13d | 0x%08h | current_floor", uut.regfile.array_reg[20], uut.regfile.array_reg[20]);
        $display("$s5  | %13d | 0x%08h | [OUT] m_up", uut.regfile.array_reg[21], uut.regfile.array_reg[21]);
        $display("$s6  | %13d | 0x%08h | [OUT] n_down", uut.regfile.array_reg[22], uut.regfile.array_reg[22]);
        $display("$s7  | %13d | 0x%08h | [OUT] h_broken", uut.regfile.array_reg[23], uut.regfile.array_reg[23]);
        $display("$t8  | %13d | 0x%08h | [OUT] last_drop_broken", uut.regfile.array_reg[24], uut.regfile.array_reg[24]);
        $display("$t9  | %13d | 0x%08h | [OUT] Cost1 (f1)", uut.regfile.array_reg[25], uut.regfile.array_reg[25]);
        $display("$t0  | %13d | 0x%08h | [OUT] Cost2 (f2)", uut.regfile.array_reg[8], uut.regfile.array_reg[8]);
        
        $display("============================================================\n");
        
        $finish;
    end
    
endmodule
