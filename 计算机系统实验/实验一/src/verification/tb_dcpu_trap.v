`timescale 1ns / 1ps

module tb_dcpu_trap;
    reg clk;
    reg rst;
    reg ena;
    reg intr;

    wire [31:0] PC_out;
    wire [31:0] instr_out;
    wire [31:0] reg28;

    integer errors;

    DCPU dut (
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .intr(intr),
        .PC_out(PC_out),
        .instr_out(instr_out),
        .reg28(reg28)
    );

    always #5 clk = ~clk;

    task expect32;
        input [31:0] actual;
        input [31:0] expected;
        input [255:0] name;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s expected 0x%08h got 0x%08h", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        ena = 1'b1;
        intr = 1'b0;
        errors = 0;

        #20 rst = 1'b0;
        #220;

        expect32(reg28, 32'd13, "exception handler wrote reg28");
        expect32(dut.regfile.regs[1], 32'd1, "post-handler instruction");
        expect32(dut.cp0.cp0_regs[14], 32'h00400004, "epc");
        expect32({27'b0, dut.cp0.cp0_regs[13][6:2]}, 32'd13, "cause code");

        if (errors == 0) begin
            $display("tb_dcpu_trap: PASS");
        end else begin
            $display("tb_dcpu_trap: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule