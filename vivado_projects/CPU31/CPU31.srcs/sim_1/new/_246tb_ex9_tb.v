`timescale 1ns / 1ps

module _246tb_ex9_tb;

	// Inputs
	reg clk_in;
	reg reset;

	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	sccomp_dataflow uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.inst(inst),
		.pc(pc)
	);

	
	
initial begin
		
		// Initialize Inputs
		clk_in = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#50;
        reset = 0;		
		// Add stimulus here
		
		//#100;
		//$fclose(file_output);
	end
   
	always begin		
	#50;	
	clk_in = ~clk_in;
	end
endmodule

