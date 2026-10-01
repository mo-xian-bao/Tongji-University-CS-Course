`timescale 1ns / 1ps

module tb_controller_decode;
    reg [31:0] instr;

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [15:0] imm;
    wire [25:0] addr;
    wire [31:0] imm_sign_ext;
    wire [31:0] imm_zero_ext;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire alu_src;
    wire [1:0] reg_dst;
    wire [3:0] alu_op;
    wire [4:0] write_reg;
    wire sign_ext;
    wire is_branch;
    wire is_jump;
    wire is_jr;
    wire is_link;
    wire [2:0] branch_type;
    wire is_shift;
    wire is_shift_v;
    wire is_movn;
    wire is_movz;
    wire is_mdu_op;
    wire [2:0] mdu_op;
    wire is_mfhi;
    wire is_mflo;
    wire is_mthi;
    wire is_mtlo;
    wire is_mfc0;
    wire is_mtc0;
    wire is_eret;
    wire is_syscall;
    wire is_break;
    wire is_teq;
    wire is_trap;
    wire [2:0] trap_op;

    integer errors;

    Controller dut (
        .instr(instr),
        .opcode(opcode),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .imm(imm),
        .addr(addr),
        .imm_sign_ext(imm_sign_ext),
        .imm_zero_ext(imm_zero_ext),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .alu_op(alu_op),
        .write_reg(write_reg),
        .sign_ext(sign_ext),
        .is_branch(is_branch),
        .is_jump(is_jump),
        .is_jr(is_jr),
        .is_link(is_link),
        .branch_type(branch_type),
        .is_shift(is_shift),
        .is_shift_v(is_shift_v),
        .is_movn(is_movn),
        .is_movz(is_movz),
        .is_mdu_op(is_mdu_op),
        .mdu_op(mdu_op),
        .is_mfhi(is_mfhi),
        .is_mflo(is_mflo),
        .is_mthi(is_mthi),
        .is_mtlo(is_mtlo),
        .is_mfc0(is_mfc0),
        .is_mtc0(is_mtc0),
        .is_eret(is_eret),
        .is_syscall(is_syscall),
        .is_break(is_break),
        .is_teq(is_teq),
        .is_trap(is_trap),
        .trap_op(trap_op)
    );

    task expect_bit;
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

    task expect_vec3;
        input [2:0] actual;
        input [2:0] expected;
        input [255:0] name;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s expected %0d got %0d", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    task expect_vec4;
        input [3:0] actual;
        input [3:0] expected;
        input [255:0] name;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s expected 0x%0h got 0x%0h", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    task check_noop;
        input [31:0] code;
        input [255:0] name;
        begin
            instr = code;
            #1;
            expect_bit(reg_write, 1'b0, {name, " reg_write"});
            expect_bit(mem_read, 1'b0, {name, " mem_read"});
            expect_bit(mem_write, 1'b0, {name, " mem_write"});
            expect_bit(is_branch, 1'b0, {name, " is_branch"});
            expect_bit(is_jump, 1'b0, {name, " is_jump"});
            expect_bit(is_trap, 1'b0, {name, " is_trap"});
            expect_bit(is_shift, 1'b0, {name, " is_shift"});
        end
    endtask

    initial begin
        errors = 0;

        check_noop(32'h00000000, "nop");
        check_noop(32'h00000040, "ssnop");
        check_noop(32'h0000000f, "sync");
        check_noop(32'hcc000000, "pref");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110000};
        #1;
        expect_bit(is_trap, 1'b1, "tge is_trap");
        expect_vec3(trap_op, 3'b100, "tge trap_op");
        expect_vec4(alu_op, 4'b1011, "tge alu_op");
        expect_bit(reg_write, 1'b0, "tge reg_write");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110001};
        #1;
        expect_bit(is_trap, 1'b1, "tgeu is_trap");
        expect_vec3(trap_op, 3'b101, "tgeu trap_op");
        expect_vec4(alu_op, 4'b1010, "tgeu alu_op");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110010};
        #1;
        expect_vec3(trap_op, 3'b010, "tlt trap_op");
        expect_vec4(alu_op, 4'b1011, "tlt alu_op");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110011};
        #1;
        expect_vec3(trap_op, 3'b011, "tltu trap_op");
        expect_vec4(alu_op, 4'b1010, "tltu alu_op");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110100};
        #1;
        expect_bit(is_teq, 1'b1, "teq is_teq");
        expect_vec3(trap_op, 3'b000, "teq trap_op");
        expect_vec4(alu_op, 4'b0011, "teq alu_op");

        instr = {6'b000000, 5'd1, 5'd2, 5'd0, 5'd0, 6'b110110};
        #1;
        expect_vec3(trap_op, 3'b001, "tne trap_op");
        expect_vec4(alu_op, 4'b0011, "tne alu_op");

        instr = {6'b000001, 5'd1, 5'b01100, 16'hff80};
        #1;
        expect_bit(is_trap, 1'b1, "teqi is_trap");
        expect_bit(alu_src, 1'b1, "teqi alu_src");
        expect_bit(sign_ext, 1'b1, "teqi sign_ext");
        expect_vec3(trap_op, 3'b000, "teqi trap_op");
        expect_vec4(alu_op, 4'b0011, "teqi alu_op");

        instr = {6'b000001, 5'd1, 5'b01000, 16'h0001};
        #1;
        expect_vec3(trap_op, 3'b100, "tgei trap_op");
        expect_vec4(alu_op, 4'b1011, "tgei alu_op");

        instr = {6'b000001, 5'd1, 5'b01001, 16'h0001};
        #1;
        expect_vec3(trap_op, 3'b101, "tgeiu trap_op");
        expect_vec4(alu_op, 4'b1010, "tgeiu alu_op");

        instr = {6'b000001, 5'd1, 5'b01010, 16'h0001};
        #1;
        expect_vec3(trap_op, 3'b010, "tlti trap_op");
        expect_vec4(alu_op, 4'b1011, "tlti alu_op");

        instr = {6'b000001, 5'd1, 5'b01011, 16'h0001};
        #1;
        expect_vec3(trap_op, 3'b011, "tltiu trap_op");
        expect_vec4(alu_op, 4'b1010, "tltiu alu_op");

        instr = {6'b000001, 5'd1, 5'b01110, 16'h0001};
        #1;
        expect_vec3(trap_op, 3'b001, "tnei trap_op");
        expect_vec4(alu_op, 4'b0011, "tnei alu_op");

        if (errors == 0) begin
            $display("tb_controller_decode: PASS");
        end else begin
            $display("tb_controller_decode: FAIL (%0d errors)", errors);
        end

        $finish;
    end
endmodule