module mxb_vga_driver
//参数定义
#(
    parameter H_CNT_BIT_WIDTH = 10'd11,
    parameter V_CNT_BIT_WIDTH = 10'd11,

    parameter H_SYNC = 10'd136,
    parameter H_TOTAL = 11'd1344,

    parameter V_SYNC = 10'd6,
    parameter V_TOTAL = 10'd806,

    parameter HSYNC_POL = 1'b1,  // HSYNC极性，1为正极性
    parameter VSYNC_POL = 1'b1   // VSYNC极性，1为正极性
)
//端口定义
(
    input wire clk,
    input wire reset_n,

    output reg hsync,
    output reg vsync,
    output reg [H_CNT_BIT_WIDTH-1:0] h_cnt,
    output reg [V_CNT_BIT_WIDTH-1:0] v_cnt
);

//行扫描计数器
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n || h_cnt == H_TOTAL-1)
        h_cnt <= 0;
    else
        h_cnt <= h_cnt + 1;
end

//行同步信号
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n)
        hsync <= ~HSYNC_POL;
    else if(h_cnt == H_SYNC-1)
        hsync <= HSYNC_POL;
    else if(h_cnt == H_TOTAL-1)
        hsync <= ~HSYNC_POL;
end

//场扫描计数器
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n)
        v_cnt <= 0;
    else if(h_cnt == H_TOTAL-1 && v_cnt == V_TOTAL-1)  //一帧结束
        v_cnt <= 0;
    else if(h_cnt == H_TOTAL-1)
        v_cnt <= v_cnt + 1;
end

//场同步信号
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n)
        vsync <= ~VSYNC_POL;
    else if(h_cnt == H_TOTAL-1 && v_cnt == V_SYNC-1)
        vsync <= VSYNC_POL;
    else if(h_cnt == H_TOTAL-1 && v_cnt == V_TOTAL-1)
        vsync <= ~VSYNC_POL;
end

endmodule
