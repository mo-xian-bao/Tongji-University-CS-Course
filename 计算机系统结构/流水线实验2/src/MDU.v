module MDU(
    input           clk,
    input           rst,
    input           start,     // 启动信号
    input  [31:0]   A,         // 操作数A
    input  [31:0]   B,         // 操作数B
    input  [1:0]    MDUc,      // 控制信号
    output reg [31:0]   HI,        // 高32位结果 / 余数
    output reg [31:0]   LO,        // 低32位结果 / 商
    output reg          busy       // 忙信号
);

    // --- 定义操作码 (与您定义的保持一致) ---
    localparam MDU_MULT  = 2'b00; // 有符号乘法
    localparam MDU_MULTU = 2'b01; // 无符号乘法
    localparam MDU_DIV   = 2'b10; // 有符号除法
    localparam MDU_DIVU  = 2'b11; // 无符号除法

    // --- 定义内部状态机 ---
    localparam S_IDLE = 2'b00;  // 空闲状态
    localparam S_CALC = 2'b01;  // 计算/等待状态
    localparam S_DONE = 2'b10;  // 完成状态

    reg [1:0]  state;       // FSM当前状态
    reg [5:0]  calc_delay;  // 用于模拟耗时的计数器
    reg [63:0] result;      // 内部64位寄存器，用于暂存计算结果

    // --- 状态机与数据处理逻辑 ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            busy  <= 1'b0;
            HI    <= 32'h0;
            LO    <= 32'h0;
            calc_delay <= 6'h0;
            result <= 64'h0;
        end 
        else begin
            case (state)
                // --- 空闲状态 ---
                S_IDLE: begin
                    if (start) begin
                        busy  <= 1'b1;     // 拉高busy信号
                        state <= S_CALC;  // 进入计算状态
                        
                        // 根据操作码，立即计算结果并存入内部result寄存器
                        case (MDUc)
                            MDU_MULT: begin
                                result     <= $signed(A) * $signed(B);
                                calc_delay <= 6'd5; // 模拟乘法需要5个周期
                            end
                            MDU_MULTU: begin
                                result     <= A * B;
                                calc_delay <= 6'd5;
                            end
                            MDU_DIV: begin
                                // 将余数和商拼接成64位存入result
                                result     <= {$signed(A) % $signed(B), $signed(A) / $signed(B)};
                                calc_delay <= 6'd10; // 模拟除法需要10个周期
                            end
                            MDU_DIVU: begin
                                result     <= {A % B, A / B};
                                calc_delay <= 6'd10;
                            end
                        endcase
                    end
                end

                // --- 计算/等待状态 ---
                S_CALC: begin
                    if (calc_delay > 0) begin
                        calc_delay <= calc_delay - 1; // 计数器递减，模拟等待
                    end else begin
                        HI    <= result[63:32]; // 延迟结束，将暂存结果送到输出端口
                        LO    <= result[31:0];
                        state <= S_DONE;     // 进入完成状态
                    end
                end
                
                // --- 完成状态 ---
                S_DONE: begin
                    busy  <= 1'b0;     // 拉低busy信号，通知CPU计算已完成
                    state <= S_IDLE;  // 一个周期后自动返回IDLE，准备下一次任务
                end

                default: begin
                    state <= S_IDLE;
                    busy  <= 1'b0;
                end
            endcase
        end
    end

endmodule