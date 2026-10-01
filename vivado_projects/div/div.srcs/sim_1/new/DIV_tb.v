`timescale 1ns / 1ps

module DIV_tb;
    // 定义信号
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg start;
    reg clock;
    reg reset;
    wire [31:0] q;
    wire [31:0] r;
    wire busy;

    // 实例化被测试模块
    DIV uut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .clock(clock),
        .reset(reset),
        .q(q),
        .r(r),
        .busy(busy)
    );

    // 生成时钟信号
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // 测试用例
    initial begin
        // 初始化信号
        reset = 1;
        start = 0;
        dividend = 0;
        divisor = 0;
        #10;
        reset = 0;
        #10;

        // 测试用例1：正数除以正数 (50 / 3 = 16 ... 2)
        dividend = 32'd50;
        divisor = 32'd3;
        start = 1;
        #10;
        start = 0;
        wait(!busy);
        #10;

        // 测试用例2：正数除以负数 (50 / -3 = -16 ... 2)
        dividend = 32'd50;
        divisor = -32'd3;
        start = 1;
        #10;
        start = 0;
        wait(!busy);
        #10;

        // 测试用例3：负数除以正数 (-50 / 3 = -16 ... -2)
        dividend = -32'd50;
        divisor = 32'd3;
        start = 1;
        #10;
        start = 0;
        wait(!busy);
        #10;

        // 测试用例4：负数除以负数 (-50 / -3 = 16 ... -2)
        dividend = -32'd50;
        divisor = -32'd3;
        start = 1;
        #10;
        start = 0;
        wait(!busy);
        #10;

        // 测试用例5：除数为1的情况
        dividend = 32'd100;
        divisor = 32'd1;
        start = 1;
        #10;
        start = 0;
        wait(!busy);
        #10;

    end

endmodule
