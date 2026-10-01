`timescale 1ns / 1ps

module DIV(
    input [31:0] dividend,
    input [31:0] divisor,
    input start,
    input clock,
    input reset,
    output [31:0] q,
    output [31:0] r,
    output reg busy
);

    wire ready;
    reg [5:0] count;
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg busy2, r_sign;
    reg q_sign;
    reg dividend_sign;

    assign ready = ~busy & busy2;

    wire [32:0] sub_add = r_sign ? 
                          ({reg_r, reg_q[31]} + {1'b0, reg_b}) : 
                          ({reg_r, reg_q[31]} - {1'b0, reg_b});

    wire need_restore = r_sign;
    wire [31:0] restored_r = need_restore ?
        reg_r + reg_b :
        reg_r;

    assign r = dividend_sign ? -restored_r : restored_r;
    assign q = q_sign ? -reg_q : reg_q;

    always @(posedge clock or posedge reset) begin
        if (reset == 1) begin
            count <= 6'b0;
            busy <= 0;
            busy2 <= 0;
        end else begin
            busy2 <= busy;
            if (start) begin
                dividend_sign <= dividend[31];
                q_sign <= dividend[31] ^ divisor[31];
                reg_r <= 32'b0;
                r_sign <= 0;
                reg_q <= dividend[31] ? -dividend : dividend;
                reg_b <= divisor[31] ? -divisor : divisor;
                count <= 6'b0;
                busy <= 1'b1;
            end else if (busy) begin
                reg_r <= sub_add[31:0];
                r_sign <= sub_add[32];
                reg_q <= {reg_q[30:0], ~sub_add[32]};
                count <= count + 6'b1;
                if (count == 6'h1F)
                    busy <= 0;
            end
        end
    end

endmodule
