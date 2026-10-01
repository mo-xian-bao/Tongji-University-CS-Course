`timescale 1ns / 1ps
module CPO_tb;

    // 信号声明
    reg          clk;
    reg          rst;
    reg          mfc0;
    reg          mtc0;
    reg          eret;
    reg          exception;
    reg [4:0]    cause;
    reg          intr;
    reg [31:0]   pc;
    reg [4:0]    Rd;
    reg [31:0]   wdata;

    wire [31:0]  rdata;
    wire [31:0]  status;
    wire         timer_int;
    wire [31:0]  exc_addr;
    
    // 实例化被测模块
    CPO dut (
        .clk(clk),
        .rst(rst),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .cause(cause),
        .intr(intr),
        .pc(pc),
        .Rd(Rd),
        .wdata(wdata),
        .rdata(rdata),
        .status(status),
        .timer_int(timer_int),
        .exc_addr(exc_addr)
    );

    // 时钟生成
    initial begin
        clk = 0;
    end
    always #5 clk = ~clk;

    // 测试序列
    initial begin
        // 初始化和复位
        // rst为高电平期间，所有输出和内部寄存器应被复位为0。
        rst = 1; 
        mfc0 = 0; mtc0 = 0; eret = 0; exception = 0;
        cause = 5'd0; intr = 0; pc = 32'h0; Rd = 5'd0; wdata = 32'h0;
        
        #20; 
        rst = 0;
        #10;

        // 测试 mtc0 (写) 和 mfc0 (读)
        // 向 Status 寄存器写入 0x1 (开中断)
        // 下一个时钟上升沿后，status 信号应变为 32'h1。
        mtc0 = 1;
        Rd = 12; // Status 寄存器地址
        wdata = 32'h0000_0001;
        @(posedge clk);
        mtc0 = 0;
        #5;
        
        // 读 Status 寄存器 (mfc0)
        // mfc0为高电平期间，rdata 信号的值应等于 status 的值 (32'h1)。
        mfc0 = 1;
        Rd = 12;
        #10;
        mfc0 = 0;
        #10;
        
        // 测试异常处理 (syscall)
        // 下一个时钟上升沿后，epc_reg 变为 PC 值，
        // cause_reg 的 ExcCode 字段变为 8，status 信号变为 32'h20。
        exception = 1;
        cause = 5'd8; // Syscall 的异常码
        pc = 32'h0040_0020;
        @(posedge clk);
        exception = 0;
        pc = 32'h0;
        #10;
        
        // 测试异常返回 (eret)
        // 在波形图上观察：下一个时钟上升沿后，status 信号恢复为 32'h1。
        eret = 1;
        @(posedge clk);
        eret = 0;
        #10;
        
        // 测试异常屏蔽
        // 设置 Status 寄存器，使能中断(IE=1)，同时屏蔽 syscall (Mask=1)
        // 下一个时钟上升沿后，status 信号变为 32'h101。
        mtc0 = 1;
        Rd = 12; // Status 寄存器
        wdata = 32'h0000_0101; // bit8=1 (屏蔽syscall), bit0=1 (开中断)
        @(posedge clk);
        mtc0 = 0;
        #10;
        
        // 再次尝试触发 syscall 异常
        // 下一个时钟上升沿后，epc_reg, dut.cause_reg, status 信号均不发生变化
        exception = 1;
        cause = 5'd8;
        pc = 32'h0040_0088;
        @(posedge clk);
        exception = 0;
        #10;

        #50;
    end

endmodule