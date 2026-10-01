`timescale 1ns / 1ps

module tb_cp0_exception;
    reg clk;
    reg rst;
    reg mfc0;
    reg mtc0;
    reg eret;
    reg exception;
    reg [4:0] cause;
    reg intr;
    reg [31:0] pc;
    reg [4:0] Rd;
    reg [31:0] wdata;

    wire [31:0] rdata;
    wire [31:0] status;
    wire timer_int;
    wire [31:0] exc_addr;

    integer errors;

    CPO dut (
        .clk(clk),
        .rst(rst),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .cause(cause),
        .intr(intr),
        .pc(pc),
        .Rd(Rd),
        .wdata(wdata),
        .rdata(rdata),
        .status(status),
        .timer_int(timer_int),
        .exc_addr(exc_addr)
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

    task expect5;
        input [4:0] actual;
        input [4:0] expected;
        input [255:0] name;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s expected %0d got %0d", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        mfc0 = 1'b0;
        mtc0 = 1'b0;
        eret = 1'b0;
        exception = 1'b0;
        cause = 5'b0;
        intr = 1'b0;
        pc = 32'b0;
        Rd = 5'b0;
        wdata = 32'b0;
        errors = 0;

        #12;
        rst = 1'b0;
        #1;
        expect32(status, 32'h00000001, "reset status");
        expect32(exc_addr, 32'h00400004, "default exc_addr");

        pc = 32'h00400020;
        cause = 5'd13;
        exception = 1'b1;
        @(posedge clk);
        #1;
        exception = 1'b0;
        expect32(status, 32'h00000020, "trap status shifted");
        expect32(dut.cp0_regs[14], 32'h00400024, "trap epc");
        expect5(dut.cp0_regs[13][6:2], 5'd13, "trap cause");

        eret = 1'b1;
        #1;
        expect32(exc_addr, 32'h00400024, "eret exc_addr");
        @(posedge clk);
        #1;
        eret = 1'b0;
        expect32(status, 32'h00000001, "eret restores status");

        Rd = 5'd12;
        wdata = 32'h00000401;
        mtc0 = 1'b1;
        @(posedge clk);
        #1;
        mtc0 = 1'b0;
        mfc0 = 1'b1;
        #1;
        expect32(rdata, 32'h00000401, "mfc0 reads status");
        mfc0 = 1'b0;

        pc = 32'h00400040;
        cause = 5'd13;
        exception = 1'b1;
        @(posedge clk);
        #1;
        exception = 1'b0;
        expect32(status, 32'h00000401, "masked trap keeps status");
        expect32(dut.cp0_regs[14], 32'h00400024, "masked trap keeps epc");
        expect5(dut.cp0_regs[13][6:2], 5'd13, "masked trap keeps prior cause");

        if (errors == 0) begin
            $display("tb_cp0_exception: PASS");
        end else begin
            $display("tb_cp0_exception: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule