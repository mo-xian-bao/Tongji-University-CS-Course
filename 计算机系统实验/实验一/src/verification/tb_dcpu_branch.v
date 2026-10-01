`timescale 1ns / 1ps

module tb_dcpu_branch;
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
        #520;

        expect32(dut.regfile.regs[4], 32'd0, "reg4 skipped by beq");
        expect32(dut.regfile.regs[5], 32'd0, "reg5 skipped by bne");
        expect32(dut.regfile.regs[6], 32'd0, "reg6 skipped by bgez");
        expect32(dut.regfile.regs[7], 32'd0, "reg7 skipped by bgtz");
        expect32(dut.regfile.regs[8], 32'd0, "reg8 skipped by blez");
        expect32(dut.regfile.regs[9], 32'd0, "reg9 skipped by bltz");
        expect32(dut.regfile.regs[10], 32'd123, "reg10 final marker");

        if (errors == 0) begin
            $display("tb_dcpu_branch: PASS");
        end else begin
            $display("tb_dcpu_branch: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule