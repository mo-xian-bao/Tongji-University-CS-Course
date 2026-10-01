`timescale 1ns / 1ps

module tb_dmem_ops;
    reg clk;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg [31:0] rt_old;
    reg we;
    reg re;
    reg [3:0] mem_op;
    wire [31:0] data_out;

    integer errors;

    DMEM dut (
        .clk(clk),
        .addr(addr),
        .data_in(data_in),
        .rt_old(rt_old),
        .we(we),
        .re(re),
        .mem_op(mem_op),
        .data_out(data_out)
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

    task do_read;
        input [31:0] read_addr;
        input [3:0] read_op;
        input [31:0] old_rt;
        input [31:0] expected;
        input [255:0] name;
        begin
            addr = read_addr;
            mem_op = read_op;
            rt_old = old_rt;
            re = 1'b1;
            we = 1'b0;
            #1;
            expect32(data_out, expected, name);
            re = 1'b0;
        end
    endtask

    task do_write;
        input [31:0] write_addr;
        input [3:0] write_op;
        input [31:0] write_data;
        input [31:0] expected_word;
        input [255:0] name;
        begin
            addr = write_addr;
            mem_op = write_op;
            data_in = write_data;
            we = 1'b1;
            re = 1'b0;
            @(posedge clk);
            #1;
            expect32(dut.mem[write_addr[9:2]], expected_word, name);
            we = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        addr = 32'b0;
        data_in = 32'b0;
        rt_old = 32'b0;
        we = 1'b0;
        re = 1'b0;
        mem_op = 4'b0;
        errors = 0;

        dut.mem[0] = 32'h80ff7f01;
        do_read(32'h00000000, 4'b0001, 32'b0, 32'hffffff80, "lb off0");
        do_read(32'h00000001, 4'b0001, 32'b0, 32'hffffffff, "lb off1");
        do_read(32'h00000002, 4'b0001, 32'b0, 32'h0000007f, "lb off2");
        do_read(32'h00000003, 4'b0001, 32'b0, 32'h00000001, "lb off3");

        dut.mem[1] = 32'h11223344;
        do_read(32'h00000004, 4'b0101, 32'haabbccdd, 32'h11223344, "lwl off0");
        do_read(32'h00000005, 4'b0101, 32'haabbccdd, 32'h223344dd, "lwl off1");
        do_read(32'h00000006, 4'b0101, 32'haabbccdd, 32'h3344ccdd, "lwl off2");
        do_read(32'h00000007, 4'b0101, 32'haabbccdd, 32'h44bbccdd, "lwl off3");

        do_read(32'h00000004, 4'b0110, 32'haabbccdd, 32'haabbcc11, "lwr off0");
        do_read(32'h00000005, 4'b0110, 32'haabbccdd, 32'haabb1122, "lwr off1");
        do_read(32'h00000006, 4'b0110, 32'haabbccdd, 32'haa112233, "lwr off2");
        do_read(32'h00000007, 4'b0110, 32'haabbccdd, 32'h11223344, "lwr off3");

        dut.mem[2] = 32'hdeadbeef;
        do_write(32'h00000008, 4'b1011, 32'h11223344, 32'h11223344, "swl off0");
        dut.mem[2] = 32'hdeadbeef;
        do_write(32'h00000009, 4'b1011, 32'h11223344, 32'hde112233, "swl off1");
        dut.mem[2] = 32'hdeadbeef;
        do_write(32'h0000000a, 4'b1011, 32'h11223344, 32'hdead1122, "swl off2");
        dut.mem[2] = 32'hdeadbeef;
        do_write(32'h0000000b, 4'b1011, 32'h11223344, 32'hdeadbe11, "swl off3");

        dut.mem[3] = 32'hdeadbeef;
        do_write(32'h0000000c, 4'b1100, 32'h11223344, 32'h44adbeef, "swr off0");
        dut.mem[3] = 32'hdeadbeef;
        do_write(32'h0000000d, 4'b1100, 32'h11223344, 32'h3344beef, "swr off1");
        dut.mem[3] = 32'hdeadbeef;
        do_write(32'h0000000e, 4'b1100, 32'h11223344, 32'h223344ef, "swr off2");
        dut.mem[3] = 32'hdeadbeef;
        do_write(32'h0000000f, 4'b1100, 32'h11223344, 32'h11223344, "swr off3");

        if (errors == 0) begin
            $display("tb_dmem_ops: PASS");
        end else begin
            $display("tb_dmem_ops: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule