`timescale 1ns / 1ps

module DIVU_tb;
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
    DIVU uut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .clock(clock),
        .reset(reset),
        .q(q),
        .r(r),
        .busy(busy)
    );
    
    // 时钟生成
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // 测试激励
    initial begin
        // 初始化信号
        dividend = 0;
        divisor = 0;
        start = 0;
        reset = 1;
        
        // 等待100ns后开始测试
        #100;
        reset = 0;
        
        // 测试用例1：基本除法运算 (20/3)
        dividend = 32'd20;
        divisor = 32'd3;
        start = 1;
        #10 start = 0;
        wait(!busy);
        if(q === 32'd6 && r === 32'd2) begin
            // Test Case 1 Passed
        end else begin
            // Test Case 1 Failed
        end
        #20;
        
        // 测试用例2：除数为1
        dividend = 32'd100;
        divisor = 32'd1;
        start = 1;
        #10 start = 0;
        wait(!busy);
        if(q === 32'd100 && r === 32'd0) begin
            // Test Case 2 Passed
        end else begin
            // Test Case 2 Failed
        end
        #20;
        
        // 测试用例3：被除数为0
        dividend = 32'd0;
        divisor = 32'd5;
        start = 1;
        #10 start = 0;
        wait(!busy);
        if(q === 32'd0 && r === 32'd0) begin
            // Test Case 3 Passed
        end else begin
            // Test Case 3 Failed
        end
        #20;
        
        // 测试用例4：大数除法
        dividend = 32'hFFFFFFFF;
        divisor = 32'h0000FFFF;
        start = 1;
        #10 start = 0;
        wait(!busy);
        if(q === 32'h00010001 && r === 32'h00000000) begin
            // Test Case 4 Passed
        end else begin
            // Test Case 4 Failed
        end
        #20;
        
        // 测试复位功能
        dividend = 32'd100;
        divisor = 32'd2;
        start = 1;
        #10;
        reset = 1;
        #10;
        if(q === 32'd0 && r === 32'd0) begin
            // Reset Test Passed
        end else begin
            // Reset Test Failed
        end
            
        // 结束仿真
        #100 $finish;
    end
    
    // 监控busy信号变化
    always @(busy) begin
        if(busy) begin
            // Division Started
        end else begin
            // Division Completed
        end
    end

endmodule
