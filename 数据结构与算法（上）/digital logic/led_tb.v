`timescale 1ns/1ps
module led_tb();
reg [2:0]sw;
wire led1;
led uut(sw,led1);
initial
begin
#100;
sw = 3'b000; #100;
sw = 3'b001; #100;
sw = 3'b010; #100;
sw = 3'b011; #100;
sw = 3'b100; #100;
sw = 3'b101; #100;
sw = 3'b110; #100;
sw = 3'b111; #100;
end
endmodule
