`timescale 1ns / 1ps

module MULT(
    input clk, 
    input reset, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [63:0] z 
); 

    reg [31:0] a_reg, b_reg;
    reg [63:0] z_reg;
    integer i;
    reg flag;

    always@(*) begin
      flag = a[31] ^ b[31];
      if(a[31] == 1) begin
        a_reg = ~a + 1;
      end else begin
        a_reg = a;
      end
      if(b[31] == 1) begin
        b_reg = ~b + 1;
      end else begin
        b_reg = b;
      end
    end

    always@(*) begin
        z_reg = 64'b0;
        for(i = 0; i < 32; i = i + 1) begin
            if(b_reg[i]) begin
                z_reg = z_reg + (a_reg << i);
            end
        end
        
        if(flag) begin
            z_reg = ~z_reg + 1;
        end
    end

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            z <= 64'b0;
        end else begin
            z <= z_reg;
        end
    end

endmodule
