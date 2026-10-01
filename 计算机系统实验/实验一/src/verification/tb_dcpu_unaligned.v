`timescale 1ns / 1ps

module tb_dcpu_unaligned;
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

        expect32(dut.regfile.regs[2], 32'h223344dd, "lwl result");
        expect32(dut.regfile.regs[3], 32'haa112233, "lwr result");
        expect32(dut.regfile.regs[4], 32'h00112233, "swl then lw result");
        expect32(dut.regfile.regs[5], 32'h22334400, "swr then lw result");

        if (errors == 0) begin
            $display("tb_dcpu_unaligned: PASS");
        end else begin
            $display("tb_dcpu_unaligned: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule