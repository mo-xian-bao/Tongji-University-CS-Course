`timescale 1ns / 1ps

module CPO(
    input           clk,
    input           rst,
    // 与 CPU 指令交互的接口
    input           mfc0,        // CPU 指令 Mfc0 (读 CP0)
    input           mtc0,        // CPU 指令 Mtc0 (写 CP0)
    input           eret,        // CPU 指令 ERET (异常返回)
    // 异常处理相关接口
    input           exception,   // 来自CPU的内部异常请求信号 (Syscall, Break, TEQ)
    input  [4:0]    cause,       // 来自CPU的异常类型码 (ExcCode)
    input           intr,        // 外部中断请求
    input           exc_ack,     // 【新增】CPU确认响应异常/中断
    // 数据与地址总线
    input  [31:0]   pc,          // 当前指令的地址 (MEM阶段)
    input  [4:0]    Rd,          // 指定CP0寄存器的地址
    input  [31:0]   wdata,       // 从通用寄存器写入CP0的数据
    // 输出信号
    output [31:0]   rdata,       // 从CP0读出到通用寄存器的数据
    output [31:0]   status,      // 输出Status寄存器的当前值
    output reg      timer_int,   // 定时器中断信号
    output [31:0]   exc_addr,    // 异常入口地址
    output          irq_req      // 中断请求信号，告诉CPU跳转
);

    integer i;
    reg [31:0] cp0_regs [31:0]; // 32*32位的寄存器堆
    reg masked;                 // 是否被屏蔽
   
    wire [31:0] status_reg = cp0_regs[12]; // 12号寄存器: 状态控制
    wire [31:0] cause_reg  = cp0_regs[13]; // 13号寄存器: 保存异常原因
    wire [31:0] epc_reg    = cp0_regs[14]; // 14号寄存器: 保存异常返回地址

    assign status = cp0_regs[12];
    assign exc_addr = eret ? cp0_regs[14] : 32'h0040_0004; // 异常入口
    
    // 读取 Cause (寄存器13) 时，第10位实时反映 intr 引脚状态
    wire [31:0] cause_read_val = {cp0_regs[13][31:11], intr, cp0_regs[13][9:0]};
    assign rdata = mfc0 ? (Rd == 5'd13 ? cause_read_val : cp0_regs[Rd]) : 32'b0;

    // 中断请求逻辑
    assign irq_req = intr & cp0_regs[12][0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，清空所有寄存器
            for (i = 0; i < 32; i = i + 1) begin
                cp0_regs[i] <= 32'h0;
            end
            // 复位时启用中断 (IE=1)
            cp0_regs[12][0] <= 1'b1; 
            timer_int <= 1'b0;
        end 
        else begin
            // 优先级: 内部异常 > 外部中断 > MTC0 > ERET
            
            // 1. 处理内部异常 (Syscall, Break, TEQ)
            // 【修改】只有当 CPU 确认响应 (exc_ack=1) 时才更新状态
            if (exception && cp0_regs[12][0] && exc_ack) begin
            // if (exception && cp0_regs[12][0]) begin
                masked = 1'b0;
                case (cause)
                    5'd8:  masked = cp0_regs[12][8];  // syscall
                    5'd9:  masked = cp0_regs[12][9];  // break
                    5'd13: masked = cp0_regs[12][10]; // teq
                    default: masked = 1'b1;
                endcase

                if (!masked) begin
                    cp0_regs[14] <= pc + 32'd4; // EPC = PC + 4 (返回下一条指令)
                    cp0_regs[13][6:2] <= cause; // 设置 Cause
                    cp0_regs[12] <= cp0_regs[12] << 5; // 关中断 (模拟压栈)
                end
            end
            // 2. 处理外部中断
            // 【修改】只有当 CPU 确认响应 (exc_ack=1) 时才更新状态
            else if (irq_req && exc_ack) begin
            // else if (irq_req) begin
                // 外部中断发生
                // EPC = PC + 4。
                cp0_regs[14] <= pc + 32'd4; 
                
                cp0_regs[13][6:2] <= 5'd0; // ExcCode = 0 (Int)
                cp0_regs[12] <= cp0_regs[12] << 5; // 关中断
            end
            // 3. 写 CP0 指令
            else if (mtc0) begin
                cp0_regs[Rd] <= wdata;
            end 
            // 4. 异常返回
            else if (eret) begin
                cp0_regs[12] <= cp0_regs[12] >> 5; // 恢复中断状态
            end
        end
    end

endmodule