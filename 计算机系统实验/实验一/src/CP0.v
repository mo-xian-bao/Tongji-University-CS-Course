module CPO(
    input           clk,
    input           rst,
    // 与 CPU 指令交互的接口
    input           mfc0,        // CPU 指令 Mfc0 (读 CP0)
    input           mtc0,        // CPU 指令 Mtc0 (写 CP0)
    input           eret,        // CPU 指令 ERET (异常返回)
    // 异常处理相关接口
    input           exception,   // 来自CPU的异常请求信号
    input  [4:0]    cause,       // 来自CPU的异常类型码 (ExcCode)
    input           intr,        // 外部中断请求 (本次代码未处理)
    // 数据与地址总线
    input  [31:0]   pc,          // 当前指令的地址
    input  [4:0]    Rd,          // 指定CP0寄存器的地址
    input  [31:0]   wdata,       // 从通用寄存器写入CP0的数据
    // 输出信号
    output [31:0]   rdata,       // 从CP0读出到通用寄存器的数据
    output [31:0]   status,      // 输出Status寄存器的当前值
    output          timer_int,   // 定时器中断信号
    output [31:0]   exc_addr     // 异常入口地址
);

    integer i;
    reg [31:0] cp0_regs [31:0]; // 32*32位的寄存器堆
    reg timer_pending;
   
    wire [31:0] status_reg = cp0_regs[12]; // 12号寄存器: 状态控制
    wire [31:0] cause_reg  = cp0_regs[13]; // 13号寄存器: 保存异常原因
    wire [31:0] epc_reg    = cp0_regs[14]; // 14号寄存器: 保存异常返回地址

    assign status = cp0_regs[12];
    assign exc_addr = eret ? cp0_regs[14] : 32'h0040_0004;
    assign rdata = mfc0 ? cp0_regs[Rd] : 32'b0;
    assign timer_int = timer_pending && cp0_regs[12][0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，清空所有寄存器
            for (i = 0; i < 32; i = i + 1) begin
                cp0_regs[i] <= 32'h0;
            end
            // 复位时启用中断
            cp0_regs[12][0] <= 1'b1; // 设置Status寄存器的中断使能位
            timer_pending <= 1'b0;
            // 优先级：exception > mtc0 > eret
        end 
        else if (exception && cp0_regs[12][0]) begin  // 检查是否有异常请求且全局使能打开
            cp0_regs[14] <= pc;                 // EPC保存异常指令地址，由异常程序自行EPC+4
            cp0_regs[13][6:2] <= cause;         // Cause.ExcCode
            cp0_regs[12] <= cp0_regs[12] << 5;  // 进入EXL态
            if (cause == 5'd0) begin
                timer_pending <= 1'b0;          // 已响应定时中断
            end
        end else if (mtc0) begin
            // 当 mtc0 指令有效时，根据 Rd 指定的地址写入数据
            cp0_regs[Rd] <= wdata;
            if (Rd == 5'd11) begin
                timer_pending <= 1'b0;          // 写 Compare 视作确认中断
            end
        end else if (eret) begin
            cp0_regs[12] <= cp0_regs[12] >> 5; //右移5位以恢复进入异常前的Status状态
        end else begin
            // Count寄存器自增，Compare命中后置位定时中断挂起
            cp0_regs[9] <= cp0_regs[9] + 32'd1;
            if ((cp0_regs[11] != 32'b0) && ((cp0_regs[9] + 32'd1) == cp0_regs[11])) begin
                timer_pending <= 1'b1;
            end
        end
    end

endmodule