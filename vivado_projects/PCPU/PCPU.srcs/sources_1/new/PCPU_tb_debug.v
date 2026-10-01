`timescale 1ns / 1ps

module PCPU_tb_debug();

    reg clk;
    reg rst;
    wire halt;
    integer cycle_count;
    reg [31:0] prev_s5, prev_s6, prev_s7;
    
    // 实例化CPU
    PCPU uut (
        .clk(clk),
        .rst(rst),
        .halt(halt)
    );
    
    // 时钟生成
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
    
    // 监控寄存器变化
    initial begin
        prev_s5 = 0;
        prev_s6 = 0;
        prev_s7 = 0;
    end
    
    always @(posedge clk) begin
        if (!rst && !halt) begin
            // 检测 $s5 变化
            if (uut.regfile.array_reg[21] !== prev_s5) begin
                $display("[Cycle %0d] $s5 changed: %d -> %d (PC=%h)", 
                         cycle_count, $signed(prev_s5), $signed(uut.regfile.array_reg[21]), uut.PC);
                $display("  WB stage: write_reg=%d, write_data=%d, reg_write=%b",
                         uut.MEM_WB_write_reg, $signed(uut.WB_write_data), uut.MEM_WB_reg_write);
                prev_s5 = uut.regfile.array_reg[21];
            end
            
            // 检测 $s6 变化
            if (uut.regfile.array_reg[22] !== prev_s6) begin
                $display("[Cycle %0d] $s6 changed: %d -> %d (PC=%h)", 
                         cycle_count, $signed(prev_s6), $signed(uut.regfile.array_reg[22]), uut.PC);
                $display("  WB stage: write_reg=%d, write_data=%d, reg_write=%b",
                         uut.MEM_WB_write_reg, $signed(uut.WB_write_data), uut.MEM_WB_reg_write);
                prev_s6 = uut.regfile.array_reg[22];
            end
            
            // 检测 $s7 变化
            if (uut.regfile.array_reg[23] !== prev_s7) begin
                $display("[Cycle %0d] $s7 changed: %d -> %d (PC=%h)", 
                         cycle_count, $signed(prev_s7), $signed(uut.regfile.array_reg[23]), uut.PC);
                $display("  WB stage: write_reg=%d, write_data=%d, reg_write=%b",
                         uut.MEM_WB_write_reg, $signed(uut.WB_write_data), uut.MEM_WB_reg_write);
                prev_s7 = uut.regfile.array_reg[23];
            end
            
            // 追踪ADD指令到达WB阶段
            if (uut.MEM_WB_reg_write && 
                (uut.MEM_WB_write_reg == 21 || uut.MEM_WB_write_reg == 22)) begin
                $display("[Cycle %0d] WB: Writing to $s%0d (reg %d) with value %d",
                         cycle_count, 
                         (uut.MEM_WB_write_reg == 21) ? 5 : 6,
                         uut.MEM_WB_write_reg,
                         $signed(uut.WB_write_data));
            end
            
            // 追踪ID阶段的ADD指令（所有ADD，不只是写$s5/$s6的）
            if (uut.ID_opcode == 6'h02) begin  // ADD opcode
                if (uut.ID_write_reg == 21 || uut.ID_write_reg == 22) begin
                    $display("[Cycle %0d] ID: ADD detected, target=$s%0d (reg %d), rs=%d, rt=%d",
                             cycle_count,
                             (uut.ID_write_reg == 21) ? 5 : 6,
                             uut.ID_write_reg,
                             uut.ID_rs, uut.ID_rt);
                    $display("  Rs_data=%d, Rt_data=%d, stall=%b, flush=%b",
                             $signed(uut.ID_rs_data), $signed(uut.ID_rt_data), 
                             uut.stall, uut.flush_ID_EX);
                end
            end
            
            // 追踪SRA指令（目标是$t0）
            if (uut.ID_opcode == 6'h09 && uut.ID_write_reg == 8) begin  // SRA to $t0
                $display("[Cycle %0d] ID: SRA rd=$t0(8), rt=reg[%0d], shamt=%d | Instr=0x%h",
                         cycle_count, uut.ID_rt, uut.ID_shamt, uut.IF_ID_instr);
                $display("  rt_data=%d, shamt=%d, expected_result=%d",
                         $signed(uut.ID_rt_data), uut.ID_shamt, 
                         $signed(uut.ID_rt_data) >>> uut.ID_shamt);
            end
            
            // 追踪$t0的变化
            if (uut.MEM_WB_reg_write && uut.MEM_WB_write_reg == 8) begin
                $display("[Cycle %0d] WB: Writing to $t0 (reg 8) with value %d (0x%h)",
                         cycle_count, $signed(uut.WB_write_data), uut.WB_write_data);
            end
            
            // 追踪所有分支指令（无论是否跳转）
            if (uut.ID_opcode == 6'h0E || uut.ID_opcode == 6'h0F) begin  // BZ or BN
                $display("[Cycle %0d] BRANCH: %s rs($%0d)=%d, rt($%0d)=%d, taken=%b, PC=%h",
                         cycle_count,
                         (uut.ID_opcode == 6'h0E) ? "BZ" : "BN",
                         uut.ID_rs, $signed(uut.ID_rs_data_fwd),
                         uut.ID_rt, $signed(uut.ID_rt_data_fwd),
                         uut.branch_taken,
                         uut.PC);
                $display("  Hazard: stall=%b, ID_EX_wr=%b/reg=%d, EX_MEM_wr=%b/reg=%d",
                         uut.stall,
                         uut.ID_EX_reg_write, uut.ID_EX_write_reg,
                         uut.EX_MEM_reg_write, uut.EX_MEM_write_reg);
                if (uut.branch_taken) begin
                    $display("  -> JUMP to %h", uut.branch_target);
                end else begin
                    $display("  -> CONTINUE (not taken)");
                end
            end
        end
    end
    
    // 测试流程
    initial begin
        $display("============================================================");
        $display("  Simple Debug - Tracking ADD to $s5/$s6");
        $display("============================================================\n");
        
        rst = 1;
        #20;
        rst = 0;
        $display("CPU started\n");
        
        wait(halt == 1);
        $display("\nCPU halted after %0d cycles", cycle_count);
        
        repeat(10) @(posedge clk);
        
        $display("\n============================================================");
        $display("  Final Register Values");
        $display("============================================================");
        $display("$s5(21) = %d (expected: final m_up value)", $signed(uut.regfile.array_reg[21]));
        $display("$s6(22) = %d (expected: final n_down value)", $signed(uut.regfile.array_reg[22]));
        $display("$s7(23) = %d (expected: final h_broken value)", $signed(uut.regfile.array_reg[23]));
        
        $display("\nMemory Values:");
        $display("MEM[5] = %d (m_up, expected 68)", $signed(uut.dmem.mem[5]));
        $display("MEM[6] = %d (n_down, expected 31)", $signed(uut.dmem.mem[6]));
        $display("MEM[7] = %d (h_broken, expected 2)", $signed(uut.dmem.mem[7]));
        
        $display("\n============================================================");
        if (uut.dmem.mem[5] == 68 && uut.dmem.mem[6] == 31) begin
            $display("*** PASS: m_up and n_down are correct! ***");
        end else begin
            $display("*** FAIL: m_up=%d (expect 68), n_down=%d (expect 31) ***",
                     $signed(uut.dmem.mem[5]), $signed(uut.dmem.mem[6]));
        end
        $display("============================================================\n");
        
        #100;
        $finish;
    end
    
    // 超时保护
    initial begin
        #500000;
        $display("\nERROR: Timeout!");
        $finish;
    end

endmodule
