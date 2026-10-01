module mxb_rgb
//参数定义
#(
    parameter H_CNT_BIT_WIDTH = 10'd11,
    parameter V_CNT_BIT_WIDTH = 10'd11,

    parameter H_SYNC = 10'd136,
    parameter H_BACK = 10'd160,
    parameter H_ACTIVE = 11'd1024,
    parameter H_FRONT = 10'd24,
    parameter H_TOTAL = 11'd1344,

    parameter V_SYNC = 10'd6,
    parameter V_BACK = 10'd29,
    parameter V_ACTIVE = 10'd768,
    parameter V_FRONT = 10'd3,
    parameter V_TOTAL = 10'd806,

    //方块的长和宽
    parameter LENGTH = 150,
    parameter WIDTH  = 150,
    parameter SPEED_INCREMENT = 1,   // 每次碰撞后的速度增量

    // 添加小人的参数
    parameter PLAYER_SIZE = 20,    // 小人大小
    parameter PLAYER_SPEED = 5,     // 小人移动速度

    parameter BORDER_MARGIN = 80,     // 边界距离
    parameter BORDER_WIDTH = 2,        // 边界线宽度

    parameter CLK_FREQ = 65_000_000,         // 时钟频率65MHz
    parameter IMMUNE_SECONDS = 5,             // 需要的免疫秒数
    parameter IMMUNE_TIME = CLK_FREQ * IMMUNE_SECONDS,  // 计算所需的时钟周期数

    // Add new parameters for timer display
    parameter TIMER_X = 50,         // Timer display X position
    parameter TIMER_Y = 50,         // Timer display Y position
    parameter DIGIT_WIDTH = 15,     // Width of each digit
    parameter DIGIT_HEIGHT = 20,    // Height of each digit
    parameter DIGIT_SPACING = 5,     // Space between digits

    parameter SEG_WIDTH = 15,     // Width of each segment
    parameter SEG_HEIGHT = 20,   // Height of each segment

    // 添加技能显示位置参数
    parameter SKILL_DISPLAY_X = H_ACTIVE - 100,  // 技能显示位置X
    parameter SKILL_DISPLAY_Y = V_ACTIVE - 50   // 技能显示位置Y
)

//端口定义
(
    input wire clk,
    input wire reset_n,
    // input wire key_up,
    // input wire key_down,
    // input wire key_left,
    // input wire key_right,

    output wire hsync,
    output wire vsync,
    output reg [3:0] R,
    output reg [3:0] G,
    output reg [3:0] B,
    input wire [3:0] display_mode,  // 从游戏控制器接收显示模式
    input wire game_over,           // 从游戏控制器接收游戏状态
    input wire game_win,           // 添加游戏胜利输入端口
    
    input wire [10:0] player_x,     // 从移动模块接收羊的位置
    input wire [10:0] player_y,     // 从移动模块接收羊的位置
    
    // 添加位置输出端口，用于碰撞检测
    // output wire [H_CNT_BIT_WIDTH-1:0] player_x_out,
    // output wire [V_CNT_BIT_WIDTH-1:0] player_y_out,

    output wire [H_CNT_BIT_WIDTH-1:0] block_x_out,
    output wire [V_CNT_BIT_WIDTH-1:0] block_y_out,
    input wire [7:0] block_speed,      // 从游戏控制器接收当前速度
    output wire hit_boundary_out,      // 添加边界碰撞输出信号
    output wire is_immune_out,          // 添加免疫状态输出信号

    // 添加技能显示相关的输入端口
    input wire [6:0] skill_segments,         // 7段数码管显示信号
    input wire skill_immune,                 // 添加技能免疫状态输入

    // 计时器显示
    input wire [15:0] timer_value,

    // 在模块端口定义中添加
    output wire frame_flag_out
);

reg frame_flag;             		//帧结束标志
reg [H_CNT_BIT_WIDTH-1 : 0] x;      //位置变量x
reg turn_flag_x;            		//位置变量x翻转标志
reg [V_CNT_BIT_WIDTH-1 : 0] y;      //位置变量y
reg turn_flag_y;            		//位置变量y翻转标志

// 添加小人位置寄存器
// reg [H_CNT_BIT_WIDTH-1:0] player_x;
// reg [V_CNT_BIT_WIDTH-1:0] player_y;

wire [H_CNT_BIT_WIDTH-1 : 0] h_cnt;
wire [V_CNT_BIT_WIDTH-1 : 0] v_cnt;
//实例化VGA驱动
mxb_vga_driver inst_a_vga_driver (
    .clk       (clk),
    .reset_n   (reset_n),
    .hsync     (hsync),
    .vsync     (vsync),
    .h_cnt     (h_cnt),
    .v_cnt     (v_cnt)
);

//// ???算相对坐标，用于 ROM 寻址
//wire [15:0] addr;  // 16 位地址

//// 计算相对位置（在移动方块内的坐标）
//wire [10:0] rel_v;  // 相对垂直坐标
//wire [10:0] rel_h;  // 相对水平坐标

//assign rel_v = v_cnt - (V_SYNC + V_BACK + y);  // 计算相对垂直坐标
//assign rel_h = h_cnt - (H_SYNC + H_BACK + x);  // 计算相对水平坐标

//wire [15:0]Addr_znr = 300*rel_v + rel_h;

////实例化图像ROM
//wire [11:0] rom_data;
//// 实例化像 ROM，使用 16 位地址
//blk_mem_zrn inst_image_rom (
//    .clka(clk),
//    .addra(Addr_zrn),
//    .douta(rom_data)
//);

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

// 简化的移动方块初始化和移动逻辑
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        x <= H_ACTIVE/2;  // 从中间位置开始
        y <= V_ACTIVE/2;
        turn_flag_x <= 0; // 初始向右移动
        turn_flag_y <= 0; // 初始向下移动
    end
    else if (frame_flag) begin
        // x方向移动逻辑
        if (x >= H_ACTIVE - LENGTH - block_speed && !turn_flag_x) begin
            turn_flag_x <= 1;
            x <= x;
        end
        else if (x <= block_speed && turn_flag_x) begin
            turn_flag_x <= 0;
            x <= x;
        end
        else if (!turn_flag_x) begin
            x <= x + block_speed;
        end
        else begin
            x <= x - block_speed;
        end

        // y方向移动逻辑
        if (y >= V_ACTIVE - WIDTH - block_speed && !turn_flag_y) begin
            turn_flag_y <= 1;
            y <= y;
        end
        else if (y <= block_speed && turn_flag_y) begin
            turn_flag_y <= 0;
            y <= y;
        end
        else if (!turn_flag_y) begin
            y <= y + block_speed;
        end
        else begin
            y <= y - block_speed;
        end
    end
end

// 小人移动控制
// always @(posedge clk or negedge reset_n) begin
//     if (!reset_n) begin
//         player_x <= H_ACTIVE/2;
//         player_y <= V_ACTIVE/2;
//     end
//     else if (!game_over && frame_flag) begin
//         // 上下移动，限制在边界内
//         if (key_up && player_y > BORDER_MARGIN + PLAYER_SPEED)
//             player_y <= player_y - PLAYER_SPEED;
//         else if (key_down && player_y < V_ACTIVE - BORDER_MARGIN - PLAYER_SIZE - PLAYER_SPEED)
//             player_y <= player_y + PLAYER_SPEED;
            
//         // 左右移动，限制在边界内
//         if (key_left && player_x > BORDER_MARGIN + PLAYER_SPEED)
//             player_x <= player_x - PLAYER_SPEED;
//         else if (key_right && player_x < H_ACTIVE - BORDER_MARGIN - PLAYER_SIZE - PLAYER_SPEED)
//             player_x <= player_x + PLAYER_SPEED;
//     end
// end

// 在模块中添加碰撞边界检测信号
reg hit_boundary;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        hit_boundary <= 0;
    end
    else begin
        // 检测是否碰到边界，使用范围检测
        if (frame_flag && (
            (x >= H_ACTIVE - LENGTH - block_speed && !turn_flag_x) || 
            (x <= block_speed && turn_flag_x) ||
            (y >= V_ACTIVE - WIDTH - block_speed && !turn_flag_y) || 
            (y <= block_speed && turn_flag_y)
        )) begin
            hit_boundary <= 1;
        end
        else begin
            hit_boundary <= 0;
        end
    end
end

// 在信号定义部分添加
reg [31:0] immune_counter;  // 使用32位计数器，确保能容纳大数值
reg is_immune;             // 免疫状态标志

// 添加免疫状态控制
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        immune_counter <= IMMUNE_TIME;
        is_immune <= 1'b1;
    end
    else if (immune_counter > 0) begin
        immune_counter <= immune_counter - 1;
        is_immune <= 1'b1;
    end
    else begin
        is_immune <= 1'b0;
    end
end

// 添加7段数码管显示逻辑函数
function [6:0] get_segments;
    input [3:0] digit;
    begin
        case(digit)
            4'd0: get_segments = 7'b1110111;  // 0
            4'd1: get_segments = 7'b0010010;  // 1
            4'd2: get_segments = 7'b1011101;  // 2
            4'd3: get_segments = 7'b1011011;  // 3
            4'd4: get_segments = 7'b0111010;  // 4
            4'd5: get_segments = 7'b1101011;  // 5
            4'd6: get_segments = 7'b1101111;  // 6
            4'd7: get_segments = 7'b1010010;  // 7
            4'd8: get_segments = 7'b1111111;  // 8
            4'd9: get_segments = 7'b1111011;  // 9
            default: get_segments = 7'b0000000;
        endcase
    end
endfunction

// 在get_segments函数后添加
// BCD转换函数
function [15:0] decimal_to_bcd;
    input [13:0] decimal;
    reg [15:0] bcd;
    integer i;
    begin
        bcd = 0;
        for (i = 0; i < 14; i = i + 1) begin
            if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
            if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
            if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
            if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
            bcd = {bcd[14:0], decimal[13-i]};
        end
        decimal_to_bcd = bcd;
    end
endfunction

// 在模块顶部添加wire声明
wire [15:0] bcd_time;
wire [3:0] digit_pos;
wire [3:0] current_digit;
wire [6:0] digit_segments;
reg [10:0] rel_x;  // 添加相对位置寄存器
reg [10:0] rel_y;  // 添加相对位置寄存器

// 计算segments和BCD时间
assign bcd_time = decimal_to_bcd(timer_value[13:0]);
assign digit_pos = (h_cnt - (H_SYNC + H_BACK + TIMER_X)) / (DIGIT_WIDTH + DIGIT_SPACING);
assign current_digit = (digit_pos == 0) ? bcd_time[15:12] :
                      (digit_pos == 1) ? bcd_time[11:8] :
                      (digit_pos == 2) ? bcd_time[7:4] :
                                       bcd_time[3:0];
assign digit_segments = get_segments(current_digit);

// RGB 输出逻辑
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        R <= 4'b0000;
        G <= 4'b0000;
        B <= 4'b0000;
    end
    else if ((h_cnt >= H_SYNC + H_BACK) && 
             (h_cnt < H_SYNC + H_BACK + H_ACTIVE) && 
             (v_cnt >= V_SYNC + V_BACK) && 
             (v_cnt < V_SYNC + V_BACK + V_ACTIVE)) begin
        case(display_mode)
            4'd0: begin  // 正常游戏模式
                // 显示边界线（黄色矩形）
                if ((h_cnt >= (H_SYNC + H_BACK + BORDER_MARGIN) && 
                     h_cnt < (H_SYNC + H_BACK + H_ACTIVE - BORDER_MARGIN) &&
                     ((v_cnt >= (V_SYNC + V_BACK + BORDER_MARGIN) && 
                       v_cnt < (V_SYNC + V_BACK + BORDER_MARGIN + BORDER_WIDTH)) ||
                      (v_cnt >= (V_SYNC + V_BACK + V_ACTIVE - BORDER_MARGIN - BORDER_WIDTH) && 
                       v_cnt < (V_SYNC + V_BACK + V_ACTIVE - BORDER_MARGIN)))) ||
                    (v_cnt >= (V_SYNC + V_BACK + BORDER_MARGIN) && 
                     v_cnt < (V_SYNC + V_BACK + V_ACTIVE - BORDER_MARGIN) &&
                     ((h_cnt >= (H_SYNC + H_BACK + BORDER_MARGIN) && 
                       h_cnt < (H_SYNC + H_BACK + BORDER_MARGIN + BORDER_WIDTH)) ||
                      (h_cnt >= (H_SYNC + H_BACK + H_ACTIVE - BORDER_MARGIN - BORDER_WIDTH) && 
                       h_cnt < (H_SYNC + H_BACK + H_ACTIVE - BORDER_MARGIN))))) begin
                    R <= 4'b1111;
                    G <= 4'b1111;
                    B <= 4'b0000;
                end
                // 在移动方块区域内
                else if ((h_cnt >= (H_SYNC + H_BACK + x)) && 
                        (h_cnt < (H_SYNC + H_BACK + x + LENGTH)) && 
                        (v_cnt >= (V_SYNC + V_BACK + y)) && 
                        (v_cnt < (V_SYNC + V_BACK + y + WIDTH))) begin
                    R <= 1111;  // 高 4 位为红色
                    G <= 0000;   // 中间 4 位为绿色
                    B <= 0000;   // 低 4 位为蓝色
                end
                // 在小人区域内
                else if ((h_cnt >= (H_SYNC + H_BACK + player_x)) && 
                         (h_cnt < (H_SYNC + H_BACK + player_x + PLAYER_SIZE)) && 
                         (v_cnt >= (V_SYNC + V_BACK + player_y)) && 
                         (v_cnt < (V_SYNC + V_BACK + player_y + PLAYER_SIZE))) begin
                    if (is_immune) begin
                        // 开局免疫状态下闪烁效果（蓝绿色交替）
                        if (immune_counter[25]) begin
                            R <= 4'b0000;
                            G <= 4'b1111;
                            B <= 4'b1111;
                        end else begin
                            R <= 4'b0000;
                            G <= 4'b0000;
                            B <= 4'b1111;
                        end
                    end
                    else if (skill_immune) begin
                        // 技能免疫状态下闪烁效果（紫色交替）
                        if (h_cnt[4]) begin  // 使用不同的计数器来产生不同的闪烁效果
                            R <= 4'b1111;
                            G <= 4'b1111;
                            B <= 4'b0000;
                        end else begin
                            R <= 4'b1111;
                            G <= 4'b0000;
                            B <= 4'b1111;
                        end
                    end
                    else begin
                        // 正常状态下显示绿色
                        R <= 4'b0000;
                        G <= 4'b1111;
                        B <= 4'b0000;
                    end
                end
                // 显示时间
                else if ((h_cnt >= (H_SYNC + H_BACK + TIMER_X)) && 
                         (h_cnt < (H_SYNC + H_BACK + TIMER_X + DIGIT_WIDTH * 4 + DIGIT_SPACING * 3)) &&
                         (v_cnt >= (V_SYNC + V_BACK + TIMER_Y)) &&
                         (v_cnt < (V_SYNC + V_BACK + TIMER_Y + DIGIT_HEIGHT))) begin
                    
                    rel_x = (h_cnt - (H_SYNC + H_BACK + TIMER_X)) % (DIGIT_WIDTH + DIGIT_SPACING);
                    rel_y = v_cnt - (V_SYNC + V_BACK + TIMER_Y);
                    
                    if (digit_pos < 4) begin
                        if ((digit_segments[6] && rel_y < 2 && rel_x >= 2 && rel_x < DIGIT_WIDTH-2) ||                    // 顶段
                            (digit_segments[5] && rel_y >= 2 && rel_y < DIGIT_HEIGHT/2-1 && rel_x < 2) ||                 // 左上段
                            (digit_segments[4] && rel_y >= 2 && rel_y < DIGIT_HEIGHT/2-1 && rel_x >= DIGIT_WIDTH-2) ||    // 右上段
                            (digit_segments[3] && rel_y >= DIGIT_HEIGHT/2-1 && rel_y < DIGIT_HEIGHT/2+1 && 
                             rel_x >= 2 && rel_x < DIGIT_WIDTH-2) ||                                                      // 中段
                            (digit_segments[2] && rel_y >= DIGIT_HEIGHT/2+1 && rel_y < DIGIT_HEIGHT-2 && rel_x < 2) ||    // 左下段
                            (digit_segments[1] && rel_y >= DIGIT_HEIGHT/2+1 && rel_y < DIGIT_HEIGHT-2 && 
                             rel_x >= DIGIT_WIDTH-2) ||                                                                   // 右下段
                            (digit_segments[0] && rel_y >= DIGIT_HEIGHT-2 && rel_x >= 2 && rel_x < DIGIT_WIDTH-2)) begin  // 底段
                            R <= 4'b1111;
                            G <= 4'b1111;
                            B <= 4'b1111;
                        end else begin
                            R <= 4'b0000;
                            G <= 4'b0000;
                            B <= 4'b0000;
                        end
                    end else begin
                        R <= 4'b0000;
                        G <= 4'b0000;
                        B <= 4'b0000;
                    end
                end
                // 显示技能剩余次数
                else if ((h_cnt >= (H_SYNC + H_BACK + SKILL_DISPLAY_X)) && 
                         (h_cnt < (H_SYNC + H_BACK + SKILL_DISPLAY_X + SEG_WIDTH)) && 
                         (v_cnt >= (V_SYNC + V_BACK + SKILL_DISPLAY_Y)) && 
                         (v_cnt < (V_SYNC + V_BACK + SKILL_DISPLAY_Y + SEG_HEIGHT))) begin
                    
                    // 计算相对位置
                    rel_x = h_cnt - (H_SYNC + H_BACK + SKILL_DISPLAY_X);
                    rel_y = v_cnt - (V_SYNC + V_BACK + SKILL_DISPLAY_Y);
                    
                    // 显示数字段
                    if ((skill_segments[6] && rel_y < 2 && rel_x >= 2 && rel_x < SEG_WIDTH-2) ||                    // 顶段
                        (skill_segments[5] && rel_y >= 2 && rel_y < SEG_HEIGHT/2-1 && rel_x < 2) ||                 // 左上段
                        (skill_segments[4] && rel_y >= 2 && rel_y < SEG_HEIGHT/2-1 && rel_x >= SEG_WIDTH-2) ||    // 右上段
                        (skill_segments[3] && rel_y >= SEG_HEIGHT/2-1 && rel_y < SEG_HEIGHT/2+1 && 
                         rel_x >= 2 && rel_x < SEG_WIDTH-2) ||                                                    // 中段
                        (skill_segments[2] && rel_y >= SEG_HEIGHT/2+1 && rel_y < SEG_HEIGHT-2 && rel_x < 2) ||    // 左下段
                        (skill_segments[1] && rel_y >= SEG_HEIGHT/2+1 && rel_y < SEG_HEIGHT-2 && 
                         rel_x >= SEG_WIDTH-2) ||                                                                 // 右下段
                        (skill_segments[0] && rel_y >= SEG_HEIGHT-2 && rel_x >= 2 && rel_x < SEG_WIDTH-2)) begin // 底段
                        R <= 4'b1111;
                        G <= 4'b1111;
                        B <= 4'b0000;
                    end
                    else begin
                        R <= 4'b0000;
                        G <= 4'b0000;
                        B <= 4'b0000;
                    end
                end
                // 其他区域
                else begin
                    R <= 4'b0000;
                    G <= 4'b0000;
                    B <= 4'b0000;
                end
            end
            4'd1: begin  // 游戏结束红条纹
                R <= v_cnt[4] ? 4'b1111 : 4'b0000;
                G <= 4'b0000;
                B <= 4'b0000;
            end
            4'd2: begin  // 游戏胜利全绿色
                R <= 4'b0000;
                G <= 4'b1111;
                B <= 4'b0000;
            end
            default: begin
                R <= 4'b0000;
                G <= 4'b0000;
                B <= 4'b0000;
            end
        endcase
    end
    else begin
        R <= 4'b0000;
        G <= 4'b0000;
        B <= 4'b0000;
    end
end

assign player_x_out = player_x;
assign player_y_out = player_y;
assign block_x_out = x;
assign block_y_out = y;

// 添加输出端口用于传递边界碰撞信号
assign hit_boundary_out = hit_boundary;

// 在模块末尾添加is_immune输出连接
assign is_immune_out = is_immune;

// 在模块末尾添加技能显示位置信号的连接
// assign skill_display_x_out = SKILL_DISPLAY_X;
// assign skill_display_y_out = SKILL_DISPLAY_Y;

// 在模块内部连接
assign frame_flag_out = frame_flag;

endmodule
