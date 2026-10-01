`timescale 1ns / 1ps

module tb_forward_unit;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    reg [31:0] ID_rs_data;
    reg [31:0] ID_rt_data;
    reg [4:0] ID_EX_rs;
    reg [4:0] ID_EX_rt;
    reg [31:0] ID_EX_rs_data;
    reg [31:0] ID_EX_rt_data;
    reg [4:0] EX_MEM_write_reg;
    reg EX_MEM_reg_write;
    reg EX_MEM_mem_read;
    reg [31:0] EX_MEM_alu_result;
    reg [4:0] MEM_WB_write_reg;
    reg MEM_WB_reg_write;
    reg [31:0] WB_write_data;

    wire [31:0] ID_rs_data_fwd;
    wire [31:0] ID_rt_data_fwd;
    wire [31:0] EX_rs_data_fwd;
    wire [31:0] EX_rt_data_fwd;

    integer errors;

    ForwardUnit dut (
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rs_data(ID_rs_data),
        .ID_rt_data(ID_rt_data),
        .ID_EX_rs(ID_EX_rs),
        .ID_EX_rt(ID_EX_rt),
        .ID_EX_rs_data(ID_EX_rs_data),
        .ID_EX_rt_data(ID_EX_rt_data),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .EX_MEM_reg_write(EX_MEM_reg_write),
        .EX_MEM_mem_read(EX_MEM_mem_read),
        .EX_MEM_alu_result(EX_MEM_alu_result),
        .MEM_WB_write_reg(MEM_WB_write_reg),
        .MEM_WB_reg_write(MEM_WB_reg_write),
        .WB_write_data(WB_write_data),
        .ID_rs_data_fwd(ID_rs_data_fwd),
        .ID_rt_data_fwd(ID_rt_data_fwd),
        .EX_rs_data_fwd(EX_rs_data_fwd),
        .EX_rt_data_fwd(EX_rt_data_fwd)
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

    task reset_inputs;
        begin
            ID_rs = 5'd1;
            ID_rt = 5'd2;
            ID_rs_data = 32'h11111111;
            ID_rt_data = 32'h22222222;
            ID_EX_rs = 5'd3;
            ID_EX_rt = 5'd4;
            ID_EX_rs_data = 32'h33333333;
            ID_EX_rt_data = 32'h44444444;
            EX_MEM_write_reg = 5'd0;
            EX_MEM_reg_write = 1'b0;
            EX_MEM_mem_read = 1'b0;
            EX_MEM_alu_result = 32'haaaaaaaa;
            MEM_WB_write_reg = 5'd0;
            MEM_WB_reg_write = 1'b0;
            WB_write_data = 32'hbbbbbbbb;
            #1;
        end
    endtask

    initial begin
        errors = 0;

        reset_inputs();
        expect32(ID_rs_data_fwd, 32'h11111111, "ID rs no forward");
        expect32(ID_rt_data_fwd, 32'h22222222, "ID rt no forward");
        expect32(EX_rs_data_fwd, 32'h33333333, "EX rs no forward");
        expect32(EX_rt_data_fwd, 32'h44444444, "EX rt no forward");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_write_reg = 5'd1;
        #1;
        expect32(ID_rs_data_fwd, 32'haaaaaaaa, "ID rs EX_MEM forward");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_write_reg = 5'd2;
        #1;
        expect32(ID_rt_data_fwd, 32'haaaaaaaa, "ID rt EX_MEM forward");

        reset_inputs();
        MEM_WB_reg_write = 1'b1;
        MEM_WB_write_reg = 5'd1;
        #1;
        expect32(ID_rs_data_fwd, 32'hbbbbbbbb, "ID rs MEM_WB forward");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_mem_read = 1'b1;
        EX_MEM_write_reg = 5'd1;
        MEM_WB_reg_write = 1'b1;
        MEM_WB_write_reg = 5'd1;
        #1;
        expect32(ID_rs_data_fwd, 32'hbbbbbbbb, "ID rs load does not forward from EX_MEM");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_write_reg = 5'd3;
        #1;
        expect32(EX_rs_data_fwd, 32'haaaaaaaa, "EX rs EX_MEM forward");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_write_reg = 5'd4;
        #1;
        expect32(EX_rt_data_fwd, 32'haaaaaaaa, "EX rt EX_MEM forward");

        reset_inputs();
        MEM_WB_reg_write = 1'b1;
        MEM_WB_write_reg = 5'd3;
        #1;
        expect32(EX_rs_data_fwd, 32'hbbbbbbbb, "EX rs MEM_WB forward");

        reset_inputs();
        EX_MEM_reg_write = 1'b1;
        EX_MEM_mem_read = 1'b1;
        EX_MEM_write_reg = 5'd4;
        MEM_WB_reg_write = 1'b1;
        MEM_WB_write_reg = 5'd4;
        #1;
        expect32(EX_rt_data_fwd, 32'hbbbbbbbb, "EX rt load does not forward from EX_MEM");

        if (errors == 0) begin
            $display("tb_forward_unit: PASS");
        end else begin
            $display("tb_forward_unit: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule