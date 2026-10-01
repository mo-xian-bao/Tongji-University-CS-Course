module clk2MHz(
    input wire clk_in,      // 100MHz输入时钟
    output reg clk_out      // 2MHz输出时钟
);

reg [6:0] counter; // 计数器，7位可以计数到127

always @(posedge clk_in) begin
    if (counter == 49) begin // 计数到49，产生一个2MHz的时钟周期
        counter <= 0;
        clk_out <= ~clk_out; // 翻转输出时钟
    end
    else begin
        counter <= counter + 1;
    end
end

endmodule