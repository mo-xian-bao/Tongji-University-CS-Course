module mxb_rgb
//参数定义
#(
    parameter H_CNT_BIT_WIDTH = 10'd11,
    parameter V_CNT_BIT_WIDTH = 10'd11,

    parameter H_SYNC = 10'd96,
    parameter H_TOTAL = 10'd1120,

    parameter V_SYNC = 10'd2,
    parameter V_TOTAL = 10'd770,
)
//端口定义
(
    input wire clk,
    input wire reset_n,

    output reg hsync,
    output reg vsync,
    output reg [7:0] rgb,
);

//方块的长和宽
parameter LENGTH = 200;
parameter WIDTH  = 200;

reg frame_flag;             		//帧结束标志
reg [H_CNT_BIT_WIDTH-1 : 0] x;      //位置变量x
reg turn_flag_x;            		//位置变量x翻转标志
reg [V_CNT_BIT_WIDTH-1 : 0] y;      //位置变量y
reg turn_flag_y;            		//位置变量y翻转标志

wire [H_CNT_BIT_WIDTH-1 : 0] h_cnt;
wire [V_CNT_BIT_WIDTH-1 : 0] v_cnt;
//实例化VGA驱动
mxb_vga_driver  inst_a_vga_driver (
        .clk       (clk),
        .reset_n   (reset_n),
        .hsync     (hsync),
        .vsync     (vsync),
        .h_cnt     (h_cnt),
        .v_cnt     (v_cnt)
    );

//帧结束标志
always @(posedge clk or negedge reset_n) 
begin
    if (!reset_n) begin
        frame_flag <= 0;
    end
    else if ((h_cnt == H_TOTAL - 2) && (v_cnt == V_TOTAL - 1)) begin  //提前一个周期结束
        frame_flag <= 1;
    end
    else begin
        frame_flag <= 0;
    end
end

//变量y代表方块的纵坐标
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        y <= 0;
    end
    else if ((turn_flag_y == 0 && frame_flag == 1 && (y == V_TOTAL - WIDTH - 1)) || (turn_flag_y == 1 && frame_flag == 1 && (y == 0))) begin
        y <= y;
    end
    else if (turn_flag_y == 0 && frame_flag == 1) begin
        y <= y + 1;
    end
    else if (turn_flag_y == 1 && frame_flag == 1) begin
        y <= y - 1;
    end
end

//y翻转标志
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        turn_flag_y <= 0;
    end
    else if (frame_flag == 1 && (y == V_TOTAL - WIDTH - 1)) begin
        turn_flag_y <= 1;
    end
    else if (frame_flag == 1 && (y == 0)) begin
        turn_flag_y <= 0;
    end
end

//变量x代表方块的横坐标
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        x <= 0;
    end
    else if ((turn_flag_x == 0 && frame_flag == 1 && (x == H_TOTAL - LENGTH - 1)) || (turn_flag_x == 1 && frame_flag == 1 && (x == 0))) begin
        x <= x;
    end
    else if (turn_flag_x == 0 && frame_flag == 1) begin
        x <= x + 1;
    end
    else if (turn_flag_x == 1 && frame_flag == 1) begin
        x <= x - 1;
    end
end

//x翻转标志
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        turn_flag_x <= 0;
    end
    else if (frame_flag == 1 && (x == H_TOTAL - LENGTH - 1)) begin
        turn_flag_x <= 1;
    end
    else if (frame_flag == 1 && (x == 0)) begin
        turn_flag_x <= 0;
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