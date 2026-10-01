module move_sheep
// ????
#(
    parameter H_CNT_BIT_WIDTH = 10'd11,    // ???????
    parameter V_CNT_BIT_WIDTH = 10'd11,    // ???????

    parameter H_SYNC = 10'd136,            // ????????
    parameter H_BACK = 10'd160,            // ????
    parameter H_ACTIVE = 11'd1024,         // ????????
    parameter H_FRONT = 10'd24,            // ????
    parameter H_TOTAL = 11'd1344,          // ??????

    parameter V_SYNC = 10'd6,              // ????????
    parameter V_BACK = 10'd29,             // ????
    parameter V_ACTIVE = 10'd768,          // ????????
    parameter V_FRONT = 10'd3,             // ????
    parameter V_TOTAL = 10'd806,           // ??????

    parameter PLAYER_SIZE = 20,            // ??????
    parameter PLAYER_SPEED = 5,            // ??????

    parameter BORDER_MARGIN = 80,          // ????
    parameter BORDER_WIDTH = 2             // ?????
)
(
    input wire clk,                        // ????
    input wire reset_n,                    // ???????
    input wire key_up,                     // ??????
    input wire key_down,                   // ??????
    input wire key_left,                   // ??????
    input wire key_right,                  // ??????
    input wire game_over,                  // ??????
    input wire frame_flag,                 // ?????
    output wire [10:0] player_x_out,       // ??X????
    output wire [10:0] player_y_out        // ??Y????
);

// ???????
reg [H_CNT_BIT_WIDTH-1:0] player_x;
reg [V_CNT_BIT_WIDTH-1:0] player_y;

// ??????
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        player_x <= H_ACTIVE/2;            // ????????
        player_y <= V_ACTIVE/2;
    end
    else if (!game_over && frame_flag) begin
        // ???????????
        if (key_up && player_y > BORDER_MARGIN + PLAYER_SPEED)
            player_y <= player_y - PLAYER_SPEED;
        else if (key_down && player_y < V_ACTIVE - BORDER_MARGIN - PLAYER_SIZE - PLAYER_SPEED)
            player_y <= player_y + PLAYER_SPEED;
            
        // ???????????
        if (key_left && player_x > BORDER_MARGIN + PLAYER_SPEED)
            player_x <= player_x - PLAYER_SPEED;
        else if (key_right && player_x < H_ACTIVE - BORDER_MARGIN - PLAYER_SIZE - PLAYER_SPEED)
            player_x <= player_x + PLAYER_SPEED;
    end
end

// ??????
assign player_x_out = player_x;
assign player_y_out = player_y;

endmodule