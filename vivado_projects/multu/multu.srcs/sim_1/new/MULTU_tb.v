`timescale 1ns / 1ps

module MULTU_tb();
    reg clk;
    reg reset;
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] z;
    
    MULTU uut(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .z(z)
    );
    
    initial begin
        clk = 0;
        reset = 0;
        a = 0;
        b = 0;
    end
    always #10 clk = ~clk;
    
    initial begin
        reset = 1;
        #20;
        reset = 0;
        
        a = 5;
        b = 7;
        #50;
        
        a = 65535;
        b = 4097;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'hFFFFFFFF;
        b = 2;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 0;
        b = 12345;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h00010000;
        b = 32'h00000100;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h12345678;
        b = 32'h00000009;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'h00001234;
        b = 32'h00001234;
        reset = 1;
        #10;
        reset = 0;
        #50;
        
        a = 32'hABCDEF01;
        b = 32'h00000001;
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
        
        a = 32'h55555555;
        b = 32'hAAAAAAAA;
        reset = 1;
        #10;
        reset = 0;
        #50;
    end
    
endmodule 