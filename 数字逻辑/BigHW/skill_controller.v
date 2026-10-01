module skill_controller #(
    parameter CLK_FREQ = 65_000_000,         // 系统时钟频率（65MHz）
    parameter SKILL_IMMUNE_TIME = CLK_FREQ * 3,  // 技能免疫持续时间（3秒）
    parameter INITIAL_SKILL_COUNT = 2'd3     // 初始技能次数
)(
    input wire clk,                          // 系统时钟
    input wire reset_n,                      // 低电平复位信号
    input wire skill_trigger,                // 技能触发输入
    input wire game_over,                    // 游戏结束信号
    
    output reg [1:0] skill_count,            // 剩余技能次数
    output reg skill_immune,                 // 技能免疫状态
    output wire [6:0] skill_segments         // 七段数码管显示信号
);

// 技能计时器
reg [31:0] skill_timer;

// 7段数码管显示逻辑
function [6:0] get_segments;
    input [3:0] digit;
    begin
        case(digit)
            4'd0: get_segments = 7'b1110111;  // 0
            4'd1: get_segments = 7'b0010010;  // 1
            4'd2: get_segments = 7'b1011101;  // 2
            4'd3: get_segments = 7'b1011011;  // 3
            default: get_segments = 7'b0000000;
        endcase
    end
endfunction

// 技能控制逻辑
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        skill_count <= INITIAL_SKILL_COUNT;
        skill_timer <= 0;
        skill_immune <= 0;
    end
    else if (!game_over) begin
        // 技能计时器逻辑
        if (skill_timer > 0) begin
            skill_timer <= skill_timer - 1;
            skill_immune <= 1;
        end
        else begin
            skill_immune <= 0;
        end

        // 技能触发逻辑
        if (skill_trigger && skill_count > 0 && !skill_immune) begin
            skill_count <= skill_count - 1;
            skill_timer <= SKILL_IMMUNE_TIME;
            skill_immune <= 1;
        end
    end
end

// 输出7段数码管显示信号
assign skill_segments = get_segments(skill_count);

endmodule 