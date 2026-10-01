`timescale 1ns / 1ps

module tb_hazard_unit;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    reg [31:0] ID_rs_data_fwd;
    reg [31:0] ID_rt_data_fwd;
    reg ID_is_branch;
    reg [2:0] ID_branch_type;
    reg ID_is_mdu_op;
    reg ID_is_mfhi;
    reg ID_is_mflo;
    reg [4:0] ID_EX_write_reg;
    reg ID_EX_reg_write;
    reg ID_EX_mem_read;
    reg ID_EX_is_mdu_op;
    reg [4:0] EX_MEM_write_reg;
    reg EX_MEM_reg_write;
    reg EX_MEM_mem_read;
    reg MDU_busy;

    wire stall;
    wire branch_taken;

    integer errors;

    HazardUnit dut (
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rs_data_fwd(ID_rs_data_fwd),
        .ID_rt_data_fwd(ID_rt_data_fwd),
        .ID_is_branch(ID_is_branch),
        .ID_branch_type(ID_branch_type),
        .ID_is_mdu_op(ID_is_mdu_op),
        .ID_is_mfhi(ID_is_mfhi),
        .ID_is_mflo(ID_is_mflo),
        .ID_EX_write_reg(ID_EX_write_reg),
        .ID_EX_reg_write(ID_EX_reg_write),
        .ID_EX_mem_read(ID_EX_mem_read),
        .ID_EX_is_mdu_op(ID_EX_is_mdu_op),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .EX_MEM_reg_write(EX_MEM_reg_write),
        .EX_MEM_mem_read(EX_MEM_mem_read),
        .MDU_busy(MDU_busy),
        .stall(stall),
        .branch_taken(branch_taken)
    );

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

    task reset_inputs;
        begin
            ID_rs = 5'd1;
            ID_rt = 5'd2;
            ID_rs_data_fwd = 32'd0;
            ID_rt_data_fwd = 32'd0;
            ID_is_branch = 1'b0;
            ID_branch_type = 3'b111;
            ID_is_mdu_op = 1'b0;
            ID_is_mfhi = 1'b0;
            ID_is_mflo = 1'b0;
            ID_EX_write_reg = 5'd0;
            ID_EX_reg_write = 1'b0;
            ID_EX_mem_read = 1'b0;
            ID_EX_is_mdu_op = 1'b0;
            EX_MEM_write_reg = 5'd0;
            EX_MEM_reg_write = 1'b0;
            EX_MEM_mem_read = 1'b0;
            MDU_busy = 1'b0;
            #1;
        end
    endtask

    initial begin
        errors = 0;

        reset_inputs();
        expect1(stall, 1'b0, "no hazard stall");
        expect1(branch_taken, 1'b0, "no branch taken");

        reset_inputs();
        ID_EX_mem_read = 1'b1;
        ID_EX_write_reg = 5'd1;
        #1;
        expect1(stall, 1'b1, "load use stall on rs");

        reset_inputs();
        ID_EX_mem_read = 1'b1;
        ID_EX_write_reg = 5'd2;
        #1;
        expect1(stall, 1'b1, "load use stall on rt");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b000;
        ID_EX_reg_write = 1'b1;
        ID_EX_write_reg = 5'd1;
        #1;
        expect1(stall, 1'b1, "branch hazard from ID_EX");
        expect1(branch_taken, 1'b0, "stalled branch not taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b001;
        EX_MEM_reg_write = 1'b1;
        EX_MEM_mem_read = 1'b1;
        EX_MEM_write_reg = 5'd2;
        #1;
        expect1(stall, 1'b1, "branch hazard from EX_MEM load");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b000;
        ID_rs_data_fwd = 32'd5;
        ID_rt_data_fwd = 32'd5;
        #1;
        expect1(branch_taken, 1'b1, "beq taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b001;
        ID_rs_data_fwd = 32'd5;
        ID_rt_data_fwd = 32'd6;
        #1;
        expect1(branch_taken, 1'b1, "bne taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b010;
        ID_rs_data_fwd = 32'h00000001;
        #1;
        expect1(branch_taken, 1'b1, "bgez taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b011;
        ID_rs_data_fwd = 32'h00000001;
        #1;
        expect1(branch_taken, 1'b1, "bgtz taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b100;
        ID_rs_data_fwd = 32'hffffffff;
        #1;
        expect1(branch_taken, 1'b1, "blez taken negative");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b100;
        ID_rs_data_fwd = 32'h00000000;
        #1;
        expect1(branch_taken, 1'b1, "blez taken zero");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b101;
        ID_rs_data_fwd = 32'hffffffff;
        #1;
        expect1(branch_taken, 1'b1, "bltz taken");

        reset_inputs();
        ID_is_branch = 1'b1;
        ID_branch_type = 3'b011;
        ID_rs_data_fwd = 32'h00000000;
        #1;
        expect1(branch_taken, 1'b0, "bgtz not taken on zero");

        if (errors == 0) begin
            $display("tb_hazard_unit: PASS");
        end else begin
            $display("tb_hazard_unit: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule