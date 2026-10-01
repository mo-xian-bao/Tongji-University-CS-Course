
module rgb_out
//参数定义
#(
	//分辨率640*480@60Hz 
	parameter H_CNT_BIT_WIDTH   =   10'd10  ,   //行扫描计数器位宽
			  H_SYNC    		=   10'd96  ,   //行同步
	          H_BACK    		=   10'd40  ,   //行时序后沿
	          H_LEFT    		=   10'd8   ,   //行时序左边框
	          H_VALID   		=   10'd640 ,   //行有效数据
	          H_RIGHT   		=   10'd8   ,   //行时序右边框
	          H_FRONT   		=   10'd8   ,   //行时序前沿
	          H_TOTAL   		=   10'd800 ,   //行扫描周期
 
	          V_CNT_BIT_WIDTH   =   10'd10  ,   //场扫描计数器位宽
	  		  V_SYNC   			=   10'd2   ,   //场同步
	          V_BACK   			=   10'd25  ,   //场时序后沿
	          V_TOP    			=   10'd8   ,   //场时序上边框
	          V_VALID  			=   10'd480 ,   //场有效数据
	          V_BOTTOM 			=   10'd8   ,   //场时序下边框
	          V_FRONT  			=   10'd2   ,   //场时序前沿
	          V_TOTAL  			=   10'd525 )   //场扫描周期
(
	input wire clk,  //分辨率640*480@60Hz对应于25MHz的时钟
	input wire rst_n,
	output wire hsync,
	output wire vsync,
	output reg [7:0]rgb
	);
//方块的长和宽
parameter LENGTH = 200;
parameter WIDTH  = 200;
 
reg frame_flag;             		//帧结束标志 
reg [H_CNT_BIT_WIDTH-1 : 0] x;      //位置变量x,这里位宽和hsync_cnt计数器一致，是绝对满足要求的
reg turn_flag_x;            		//位置变量x翻转标志
 
 
reg [V_CNT_BIT_WIDTH-1 : 0] y;      //位置变量y,这里位宽和vsync_cnt计数器一致，是绝对满足要求的
reg turn_flag_y;            		//位置变量y翻转标志
 
 
wire [H_CNT_BIT_WIDTH-1 : 0] hsync_cnt;
wire [V_CNT_BIT_WIDTH-1 : 0] vsync_cnt;
//例化驱动程序
vga_driver  inst_a_vga_driver (
		.clk       (clk),
		.rst_n     (rst_n),
		.hsync     (hsync),
		.vsync     (vsync),
		.hsync_cnt (hsync_cnt),
		.vsync_cnt (vsync_cnt)
	);
 
 
//帧结束标志
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		frame_flag <= 1'b0;
	end
	else if ((hsync_cnt == H_TOTAL - 2) && (vsync_cnt == V_TOTAL - 1)) begin
		frame_flag <= 1'b1;
	end
	else begin
		frame_flag <= 1'b0;
	end
end
 
//变量y
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		y <= 'd0;
	end
	else if ((turn_flag_y == 1'b0 && frame_flag == 1'b1 && (y == V_VALID - WIDTH - 1)) || (turn_flag_y == 1'b1 && frame_flag == 1'b1 && (y == 'd0)))begin
		y <= y;
	end
	else if (turn_flag_y == 1'b0 && frame_flag == 1'b1) begin
		y <= y + 1'b1;
	end
	else if (turn_flag_y == 1'b1 && frame_flag == 1'b1) begin
		y <= y - 1'b1;
	end
 
end
 
//位置变量y翻转标志
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		turn_flag_y <= 1'b0;
	end
	else if ((y == V_VALID - WIDTH - 1) && frame_flag == 1'b1 && turn_flag_y == 1'b0) begin
		turn_flag_y <= 1'b1;
	end
	else if (y == 'd0 && frame_flag == 1'b1 && turn_flag_y == 1'b1) begin
		turn_flag_y <= 1'b0;
	end
end
 
 
 
//变量x
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		x <= 'd0;
	end
	else if((turn_flag_x == 1'b0 && frame_flag == 1'b1 && x == (H_VALID - LENGTH - 1'b1)) || (turn_flag_x == 1'b1 && frame_flag == 1'b1 && x == 'd0)) begin
		x <= x;
	end
	else if (turn_flag_x == 1'b0 && frame_flag == 1'b1) begin
		x <= x + 1'b1;
	end
	else if (turn_flag_x == 1'b1 && frame_flag == 1'b1) begin
		x <= x - 1'b1;
	end
end
 
//位置变量x翻转标志
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		turn_flag_x <= 1'b0;
	end
	else if (turn_flag_x == 1'b0 && frame_flag == 1'b1 && x == H_VALID - LENGTH - 1'b1) begin
		turn_flag_x <= 1'b1;
	end
	else if (turn_flag_x == 1'b1 && frame_flag == 1'b1 && x == 'd0) begin
		turn_flag_x <= 1'b0;
	end
end
//rgb输出
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		rgb <= 8'b000_000_00;
	end
	//白色方块
	else if((hsync_cnt>= H_SYNC + H_BACK + H_LEFT + x) && (hsync_cnt <= H_SYNC + H_BACK + H_LEFT + x + 200) &&(vsync_cnt>= V_SYNC + V_BACK + V_TOP + y) && (vsync_cnt <= V_SYNC + V_BACK + V_TOP + y + 200)) begin
		rgb <= 'b111_111_11;//白色
	end
	//横彩条
	else if ((hsync_cnt>= H_SYNC + H_BACK + H_LEFT) && (hsync_cnt <= H_TOTAL - H_FRONT - H_RIGHT - 1'b1) && (vsync_cnt>= V_SYNC + V_BACK + V_TOP) && vsync_cnt <= V_SYNC + V_BACK + V_TOP + 159) begin
		rgb <= 'b111_000_00;//红色
	end
	else if ((hsync_cnt>= H_SYNC + H_BACK + H_LEFT) && (hsync_cnt <= H_TOTAL - H_FRONT - H_RIGHT - 1'b1) && vsync_cnt>= V_SYNC + V_BACK + V_TOP + 160 && vsync_cnt <= V_SYNC + V_BACK + V_TOP + 160 + 159)begin
		rgb <= 'b000_111_00;//绿色
	end
	else if ((hsync_cnt>= H_SYNC + H_BACK + H_LEFT) && (hsync_cnt <= H_TOTAL - H_FRONT - H_RIGHT - 1'b1) && vsync_cnt>= V_SYNC + V_BACK + V_TOP + 160 + 160 && vsync_cnt <= V_SYNC + V_BACK + V_TOP + 160 + 160 + 159)begin
		rgb <= 'b000_000_11;//蓝色
	end
	else begin//其它区域
        rgb <= 'b000_000_00;//不显示
    end
end
 
 
endmodule