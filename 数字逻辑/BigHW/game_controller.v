module game_controller 
#(
    parameter H_CNT_BIT_WIDTH = 10'd11,    // 水平计数器位宽
    parameter V_CNT_BIT_WIDTH = 10'd11,    // 垂直计数器位宽
    
    parameter LENGTH = 150,                 // 移动方块长度
    parameter WIDTH = 150,                  // 移动方块宽度
    parameter PLAYER_SIZE = 20,            // 玩家角色大小
    parameter BASE_SPEED = 1,              // 移动方块基础速度
    parameter SPEED_INCREMENT = 1,         // 速度增量
    parameter MAX_SPEED = 15,              // 最大速度限制
    parameter SKILL_IMMUNE_TIME = 65_000_000 * 3,  // 技能免疫持续时间（3秒）
    parameter WIN_TIME = 30                // 游戏通关时间（30秒）
)
(
    input wire clk,                        // 系统时钟
    input wire reset_n,                    // 低电平复位信号
    
    // 位置信号
    input wire [H_CNT_BIT_WIDTH-1:0] player_x,    // 玩家X坐标
    input wire [V_CNT_BIT_WIDTH-1:0] player_y,    // 玩家Y坐标
    input wire [H_CNT_BIT_WIDTH-1:0] block_x,     // 方块X坐标
    input wire [V_CNT_BIT_WIDTH-1:0] block_y,     // 方块Y坐标
    input wire hit_boundary,               // 方块碰到边界信号
    input wire is_immune,                  // 开局免疫状态
    input wire skill_immune,               // 技能免疫状态
    
    // 输出信号
    output reg game_over,                  // 游戏结束信号
    output reg [3:0] display_mode,         // 显示模式控制
    output reg [7:0] block_speed,          // 方块移动速度
    output reg [15:0] game_timer,          // 游戏计时器
    output reg game_win                    // 游戏胜利信号
);

// 碰撞检测信号
wire collision;
assign collision = (player_x + PLAYER_SIZE > block_x) && 
                  (player_x < block_x + LENGTH) && 
                  (player_y + PLAYER_SIZE > block_y) && 
                  (player_y < block_y + WIDTH);

reg hit_boundary_reg;                      // 边界碰撞寄存器
reg [31:0] skill_timer;                    // 技能计时器
reg [25:0] timer_counter;                  // 游戏时间计数器

// 主状态控制逻辑
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        timer_counter <= 0;
        game_timer <= 0;
        game_over <= 0;
        display_mode <= 4'd0;
        block_speed <= BASE_SPEED;
        hit_boundary_reg <= 0;
        skill_timer <= 0;
        game_win <= 0;
    end
    else if (!game_over && !game_win) begin
        if (timer_counter >= 65_000_000 - 1) begin  
            timer_counter <= 0;
            game_timer <= game_timer + 1;
            
            if (game_timer >= WIN_TIME - 1) begin
                game_win <= 1;
                display_mode <= 4'd2;
            end
        end
        else begin
            timer_counter <= timer_counter + 1;
        end
        
        hit_boundary_reg <= hit_boundary;
        
        if (skill_timer > 0) begin
            skill_timer <= skill_timer - 1;
        end

        if (collision && !is_immune && !skill_immune) begin
            game_over <= 1;
            display_mode <= 4'd1;
        end

        if (hit_boundary && !hit_boundary_reg) begin
            if (block_speed < MAX_SPEED) begin
                block_speed <= block_speed + SPEED_INCREMENT;
            end
        end
    end
end

endmodule 