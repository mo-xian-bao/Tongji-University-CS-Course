`timescale 1ns / 1ps

module tb_alu_trap_compare;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] aluc;

    wire [31:0] r;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;

    integer errors;

    ALU dut (
        .a(a),
        .b(b),
        .aluc(aluc),
        .r(r),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );

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

    task expect1;
        input actual;
        input expected;
        input [255:0] name;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s expected %0d got %0d", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    task run_case;
        input [31:0] case_a;
        input [31:0] case_b;
        input [3:0] case_aluc;
        input [31:0] expected_r;
        input expected_zero;
        input [255:0] name;
        begin
            a = case_a;
            b = case_b;
            aluc = case_aluc;
            #1;
            expect32(r, expected_r, {name, " r"});
            expect1(zero, expected_zero, {name, " zero"});
        end
    endtask

    initial begin
        errors = 0;

        run_case(32'd7, 32'd7, 4'b0011, 32'd0, 1'b1, "sub equal");
        run_case(32'd7, 32'd3, 4'b0011, 32'd4, 1'b0, "sub notequal");

        run_case(32'hffffffff, 32'd1, 4'b1011, 32'd1, 1'b0, "slt signed true");
        run_case(32'd5, 32'hffffffff, 4'b1011, 32'd0, 1'b0, "slt signed false");
        run_case(32'd9, 32'd9, 4'b1011, 32'd0, 1'b1, "slt signed equal");

        run_case(32'd1, 32'd2, 4'b1010, 32'd1, 1'b0, "sltu true");
        run_case(32'hffffffff, 32'd1, 4'b1010, 32'd0, 1'b0, "sltu false");
        run_case(32'd9, 32'd9, 4'b1010, 32'd0, 1'b1, "sltu equal");

        if (errors == 0) begin
            $display("tb_alu_trap_compare: PASS");
        end else begin
            $display("tb_alu_trap_compare: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule