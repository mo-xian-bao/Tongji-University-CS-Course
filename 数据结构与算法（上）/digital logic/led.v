module led(input [2:0]sw, output led);

assign led = sw[2] & sw[1] & sw[0];

endmodule
