module mxb_music
(
    input wire clk,
    input wire collision,  //碰撞时播放音�?
    output reg musicdata,
    output wire music_sd
);

assign music_sd = collision;  //音乐输出使能

parameter mem_size = 171500;
reg [17:0] addr;  // 音乐数据地址
wire [15:0] value;  // 音乐数据,16�?
wire clk2048kHz;  // 2048kHz时钟

clk2MHz inst_clk2MHz (
    .clk_in(clk),
    .clk_out(clk2048kHz)
);

blk_mem_music inst_blk_mem_music (
    .clka(clk2048kHz),
    .addra(addr),
    .douta(value)
);

reg [7:0] counter; // 计数�?

always @(posedge clk2048kHz) begin
    counter <= counter + 1;
    musicdata <= (counter < value) ? 1 : 0;

    if (counter == 255) begin
        addr <= addr + 1;
        if (addr == mem_size) begin
            addr <= 0;
        end
    end
end

endmodule
