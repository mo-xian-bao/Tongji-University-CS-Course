`timescale 1ns / 1ps

module tb_top_board;
    reg clk;
    reg rst;
    reg [1:0] switch;
    integer i;
    integer seen_success;
    integer seen_timer_increment;
    reg [31:0] anscode_now;
    reg [31:0] anscode_base;

    localparam integer MAX_WAIT_CYCLES = 300000;
    localparam integer IRQ_OBS_CYCLES  = 50000;

    wire [7:0] seg;
    wire [7:0] an;

    top_board dut (
        .clk(clk),
        .rst(rst),
        .switch(switch),
        .seg(seg),
        .an(an)
    );

    // 100MHz equivalent simulation clock (10ns period)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    function integer is_known32;
        input [31:0] value;
        begin
            is_known32 = (^value !== 1'bx);
        end
    endfunction

    function integer is_fail_code;
        input [31:0] value;
        begin
            case (value)
                32'hFFFFFFFF,
                32'hFFFFFFFE,
                32'hFFFFFFFD,
                32'hFFFFFFFC,
                32'hFFFFFFFB,
                32'hFFFFFFFA,
                32'hFFFFFFF9,
                32'hFFFFFFF8,
                32'hFFFFFFF7,
                32'hFFFFFFF6: is_fail_code = 1;
                default: is_fail_code = 0;
            endcase
        end
    endfunction

    task report_fail;
        input [31:0] value;
        begin
            case (value)
                32'hFFFFFFFF: $display("TB_FAIL: func_test1 failed (error code -1)");
                32'hFFFFFFFE: $display("TB_FAIL: func_test2 failed (error code -2)");
                32'hFFFFFFFD: $display("TB_FAIL: func_test3 failed (error code -3)");
                32'hFFFFFFFC: $display("TB_FAIL: func_test4 failed (error code -4)");
                32'hFFFFFFFB: $display("TB_FAIL: func_test5 failed (error code -5)");
                32'hFFFFFFFA: $display("TB_FAIL: func_test6 failed (error code -6)");
                32'hFFFFFFF9: $display("TB_FAIL: func_test7 failed (error code -7)");
                32'hFFFFFFF8: $display("TB_FAIL: func_test8 failed (error code -8)");
                32'hFFFFFFF7: $display("TB_FAIL: func_test9 failed (error code -9)");
                32'hFFFFFFF6: $display("TB_FAIL: func_test10 failed (error code -10)");
                default:      $display("TB_FAIL: unexpected ANSCODE=%h", value);
            endcase
            release dut.clk_cpu;
            $fatal(1, "Test program reported failure");
        end
    endtask

    initial begin
        rst = 1'b1;
        switch = 2'b00; // switch[0]=0 run, switch[1]=0 show reg28
        seen_success = 0;
        seen_timer_increment = 0;
        anscode_now = 32'h00000000;
        anscode_base = 32'h00000000;

        // Important:
        // top_board uses Divider to generate 1Hz CPU clock, which is too slow for short simulation.
        // Force clk_cpu to use testbench fast clock only in simulation.
        force dut.clk_cpu = clk;

        #100;
        rst = 1'b0;

        // Wait for all test functions to finish.
        // Program behavior:
        // - any sub-test failure writes ANSCODE = -1..-10 then loops forever
        // - all tests pass writes ANSCODE = 1, then timer interrupt keeps updating it
        begin : wait_success
            for (i = 0; i < MAX_WAIT_CYCLES; i = i + 1) begin
                @(posedge clk);
                anscode_now = dut.cpu.dmem.mem[0];

                if (is_known32(anscode_now)) begin
                    if (is_fail_code(anscode_now)) begin
                        report_fail(anscode_now);
                    end

                    if ((anscode_now == 32'h00000001) ||
                        (anscode_now[31:16] == 16'h0001) ||
                        (anscode_now[15:0] == 16'h0001)) begin
                        seen_success = 1;
                        anscode_base = anscode_now;
                        $display("TB_INFO: success marker detected, ANSCODE=%h, PC=%h, cycle=%0d", anscode_now, dut.pc_value, i);
                        disable wait_success;
                    end
                end
            end
        end

        if (!seen_success) begin
            $display("TB_FAIL: timeout waiting success marker, ANSCODE=%h, PC=%h", dut.cpu.dmem.mem[0], dut.pc_value);
            release dut.clk_cpu;
            $fatal(1, "Timeout before program completion");
        end

        // Verify timer interrupt test: ANSCODE should continue to change after success marker.
        begin : wait_timer_increment
            for (i = 0; i < IRQ_OBS_CYCLES; i = i + 1) begin
                @(posedge clk);
                anscode_now = dut.cpu.dmem.mem[0];

                if (is_known32(anscode_now)) begin
                    if (is_fail_code(anscode_now)) begin
                        report_fail(anscode_now);
                    end

                    if (anscode_now != anscode_base) begin
                        seen_timer_increment = 1;
                        $display("TB_INFO: timer interrupt observed, ANSCODE changed %h -> %h", anscode_base, anscode_now);
                        disable wait_timer_increment;
                    end
                end
            end
        end

        if (!seen_timer_increment) begin
            $display("TB_FAIL: no ANSCODE update observed after success marker (timer interrupt may not work)");
            release dut.clk_cpu;
            $fatal(1, "Timer interrupt check failed");
        end

        $display("TB_PASS: all 11 test functions passed, final ANSCODE=%h, PC=%h", dut.cpu.dmem.mem[0], dut.pc_value);

        release dut.clk_cpu;
        $finish;
    end
endmodule
