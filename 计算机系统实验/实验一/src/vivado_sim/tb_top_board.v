`timescale 1ns / 1ps

module tb_top_board;
    reg clk;
    reg rst;
    reg [1:0] switch;
    localparam integer SIM_CYCLES = 300000;

    wire [7:0] seg;
    wire [7:0] an;

    top_board dut (
        .clk(clk),
        .rst(rst),
        .switch(switch),
        .seg(seg),
        .an(an)
    );

    // Core waveform taps: display word and mapped DMEM cell (0x10010000).
    wire [31:0] wave_display_word   = dut.display_data;
    wire [31:0] wave_dmem_10010000  = dut.cpu.dmem.anscode_dbg;

    // 100MHz equivalent simulation clock (10ns period)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        switch = 2'b00; // switch[0]=0 run

        // Use fast TB clock for CPU in simulation.
        force dut.clk_cpu = clk;

        #100;
        rst = 1'b0;

        repeat (SIM_CYCLES) @(posedge clk);
        $display("TB_DONE: waveform capture complete, ANSCODE=%h, display=%h, PC=%h", dut.cpu.dmem.anscode_dbg, dut.display_data, dut.pc_value);

        release dut.clk_cpu;
        $finish;
    end
endmodule
