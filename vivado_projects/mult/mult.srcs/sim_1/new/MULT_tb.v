`timescale 1ns / 1ps

module MULT_tb();
    reg clk;
    reg reset;
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] z;
    
    MULT uut(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .z(z)
    );
    
    initial begin
        clk = 0;
    end
    always #10 clk = ~clk;
    
    initial begin
        reset = 1;
        a = 0;
        b = 0;
        #20;
        reset = 0;
        
        a = 5;
        b = 7;
        #50;
        
        a = 5;
        b = -7;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = -5;
        b = 7;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = -5;
        b = -7;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 0;
        b = -12345;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h7FFFFFFF;
        b = 32'h00000002;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h80000000;
        b = 32'h00000001;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h80000000;
        b = 32'hFFFFFFFF;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h7FFFFFFF;
        b = 32'h7FFFFFFF;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h80000000;
        b = 32'h80000000;
        reset = 1;
        #10;
        reset = 0;
        #50;
    end
    
endmodule
