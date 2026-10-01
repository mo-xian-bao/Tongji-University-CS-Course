module top_vga_move
(
    input wire clk,                        // 系统时钟（100MHz）
    input wire rst_n,                      // 低电平复位信号
    input wire key_up,                     // 向上移动按键
    input wire key_down,                   // 向下移动按键
    input wire key_left,                   // 向左移动按键
    input wire key_right,                  // 向右移动按键
    input wire skill_key,                  // 技能触发按键
    output wire hsync,                     // VGA水平同步信号
    output wire vsync,                     // VGA垂直同步信号
    output wire [3:0] R,                   // VGA红色分量
    output wire [3:0] G,                   // VGA绿色分量
    output wire [3:0] B,                   // VGA蓝色分量
    output wire game_over,                 // 游戏结束信号
    output wire game_win,                  // 游戏胜利信号
    output wire audio_out,                 // 音频输出
    output wire audio_sd                   // 音频使能
);

// 内部信号声明
wire clk_65M;                             // 65MHz VGA时钟
wire locked;                              // PLL锁定信号
wire frame_flag;                          // 帧同步标志
wire [3:0] display_mode;                  // 显示模式控制
wire [10:0] player_x, player_y;           // 玩家位置
wire [10:0] block_x, block_y;             // 方块位置
wire [7:0] block_speed;                   // 方块移动速度
wire hit_boundary;                        // 边界碰撞信号
wire is_immune;                          // 免疫状态
wire [15:0] game_timer;                   // 游戏计时器
wire [6:0] skill_segments;                // 技能剩余次数显示
wire skill_immune;                        // 技能免疫状态
wire game_win_internal;                   // 内部游戏胜利信号

//实例化"羊"移动模块
move_sheep move_sheep(
    .clk(clk_65M),
    .reset_n(rst_n & locked),
    .key_up(key_up),
    .key_down(key_down),
    .key_left(key_left),
    .key_right(key_right),
    .game_over(game_over),
    .frame_flag(frame_flag),
    .player_x_out(player_x),
    .player_y_out(player_y)
);

// 实例化Clocking Wizard模块
clk_wiz_0 inst_clk_wiz (
    .clk_in1(clk),
    .reset(~rst_n),
    .clk_out1(clk_65M),
    .locked(locked)
);

// 实例化音乐模块
mxb_music inst_music (
    .clk(clk),
    .collision(game_over),  // 连接碰撞信号
    .musicdata(audio_out),
    .music_sd(audio_sd)
);

// 游戏控制器实例化
game_controller inst_game_controller (
    .clk(clk_65M),
    .reset_n(rst_n & locked),
    .player_x(player_x),
    .player_y(player_y),
    .block_x(block_x),
    .block_y(block_y),
    .game_over(game_over),
    .display_mode(display_mode),
    .block_speed(block_speed),
    .hit_boundary(hit_boundary),
    .is_immune(is_immune),
    .skill_immune(skill_immune),
    .game_timer(game_timer),
    .game_win(game_win_internal)
);

// 实例化技能控制器
skill_controller inst_skill_controller (
    .clk(clk_65M),
    .reset_n(rst_n & locked),
    .skill_trigger(skill_key),
    .game_over(game_over),
    .skill_count(skill_count),
    .skill_immune(skill_immune),
    .skill_segments(skill_segments)
);

// rgb输出模块例化
mxb_rgb instial_rgb (
    .clk(clk_65M),
    .reset_n(rst_n & locked),
    .display_mode(display_mode),
    .game_over(game_over),
    .game_win(game_win_internal),   // 添加游戏胜利信号连接
    .player_x(player_x),
    .player_y(player_y),
    .hsync(hsync),
    .vsync(vsync),
    .R(R),
    .G(G),
    .B(B),
    .block_x_out(block_x),
    .block_y_out(block_y),
    .block_speed(block_speed),
    .hit_boundary_out(hit_boundary),
    .is_immune_out(is_immune),
    .skill_segments(skill_segments),
    .skill_immune(skill_immune),
    .timer_value(game_timer),
    .frame_flag_out(frame_flag)
);

// 连接游戏胜利输出信号
assign game_win = game_win_internal;

endmodule