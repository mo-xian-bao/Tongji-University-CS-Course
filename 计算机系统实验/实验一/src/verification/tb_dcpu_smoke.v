`timescale 1ns / 1ps

module tb_dcpu_smoke;
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

        #20;
        rst = 1'b0;

        #220;

        expect32(dut.regfile.regs[1], 32'd5, "reg1");
        expect32(dut.regfile.regs[2], 32'd7, "reg2");
        expect32(dut.regfile.regs[3], 32'd12, "reg3");
        expect32(reg28, 32'd28, "reg28");

        if (errors == 0) begin
            $display("tb_dcpu_smoke: PASS");
        end else begin
            $display("tb_dcpu_smoke: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule