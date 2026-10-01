module top_vga_move(
	input wire clk,//50M板载时钟
	input wire rst_n,
	output wire hsync,
	output wire vsync,
	output wire [7:0]rgb
	);
 
wire clk_25M;
 
//分频器生成52MHz时钟
gen_clk52 inst_gen_clk52(
    // Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_52M)    // OUT
);
 
//rgb输出模块例化
mxb_rgb  instial_rgb (
	.clk   (clk_25M),
	.rst_n (rst_n),
	.hsync (hsync),
	.vsync (vsync),
	.rgb   (rgb)
	);
 
endmodule