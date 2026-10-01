`include "defines.vh"

module pc_reg( 
    input  wire              clk, 
    input  wire              rst, 
    input  wire[5:0]         stall, // 来自控制模块 ctrl
    
    // 来自译码阶段 ID 模块的信息 
    input wire               branch_flag_i, 
    input wire[`RegBus]      branch_target_address_i,
    
    input wire               flush,   // 流水线清除信号
    input wire[`RegBus]      new_pc,  // 异常处理例程入口地址
    
    output reg[`InstAddrBus] pc, 
    output reg               ce   // 指令存储器使能信号
);

always @ (posedge clk) begin 
    if (rst == `RstEnable) begin 
        ce <= `ChipDisable;       // 复位的时候指令存储器禁用 
    end 
    else begin
        ce <= `ChipEnable;        // 复位结束后，指令存储器使能 
    end 
end 

always @ (posedge clk) begin 
    if (ce == `ChipDisable) begin 
        pc <= 32'h30000000;       // 指令存储器禁用的时候，PC 为 0 
    end 
    else begin
        if (flush == 1'b1) begin
            // 输入信号 flush 为 1 表示异常发生，将从 CTRL 模块给出的异常处理 
            // 例程入口地址 new_pc 处取指执行 
            pc <= new_pc;
        end
        else if (stall[0] == `NoStop) begin
            if (branch_flag_i == `Branch) begin 
                pc <= branch_target_address_i; 
            end
            else begin
                pc <= pc + 4'h4;
            end
        end
    end
end 

endmodule 