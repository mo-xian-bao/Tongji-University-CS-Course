`timescale 1ns / 1ps
module transmission8_tb();
   reg [7:0] iData = 8'b00000000;
   wire [7:0] oData;
   reg A, B, C;
   
   transmission8 uul(.iData(iData), .A(A), .B(B), .C(C), .oData(oData));
   
   initial
   begin
       A = 0;
       B = 0;
       C = 0;
       
       #40
       A = 0;
       B = 0;
       C = 1;
       
       #40
       A = 0;
       B = 1;
       C = 0;
       
       #40
       A = 0;
       B = 1;
       C = 1;
       
       #40
       A = 1;
       B = 0;
       C = 0;
       
       #40
       A = 1;
       B = 0;
       C = 1;
       
       #40
       A = 1;
       B = 1;
       C = 0;
       
       #40
       A = 1;
       B = 1;
       C = 1;
   end
   
endmodule
