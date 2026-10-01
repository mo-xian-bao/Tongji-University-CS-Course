module top_vga_move(
	input wire clk,//50M板载时钟
	input wire rst_n,
	output wire hsync,
	output wire vsync,
	output wire [7:0]rgb
	);
 
wire clk_25M;
 
//例化锁相环产生的25MHz时钟	
gen_clk25 inst_gen_clk25(
	// Clock in ports
	.CLK_IN1(clk),      // IN
	// Clock out ports
	.CLK_OUT1(clk_25M));    // OUT
 
//rgb输出模块例化
rgb_out  inst_rgb_out (
	.clk   (clk_25M),
	.rst_n (rst_n),
	.hsync (hsync),
	.vsync (vsync),
	.rgb   (rgb)
	);
 
endmodule