module gen_clk52(
    input wire CLK_IN1,  // 输入时钟
    output wire CLK_OUT1 // 输出时钟
);

reg [31:0] counter = 0;
reg clk_div = 0;

always @(posedge CLK_IN1) begin
    if (counter == 24) begin // 50MHz / 25 = 2MHz, 2MHz * 26 = 52MHz
        counter <= 0;
        clk_div <= ~clk_div;
    end else begin
        counter <= counter + 1;
    end
end

assign CLK_OUT1 = clk_div;

endmodule
