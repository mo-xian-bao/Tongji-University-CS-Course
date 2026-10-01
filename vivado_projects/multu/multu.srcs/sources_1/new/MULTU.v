`timescale 1ns / 1ps

module MULTU(
    input clk, 
    input reset, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [63:0] z 
);
    reg [63:0] product_next;
    integer i;
    
    always @(*) begin
        product_next = 64'b0;
        
        for (i = 0; i < 32; i = i + 1) begin
            if (b[i]) begin
                product_next = product_next + ({32'b0, a} << i);
            end
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            z <= 64'b0;
        end else begin
            z <= product_next;
        end
    end

endmodule
