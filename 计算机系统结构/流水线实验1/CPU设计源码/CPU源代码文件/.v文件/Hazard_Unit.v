`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/09 21:19:06
// Design Name: 
// Module Name: Hazard_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 冒险检测单元
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////

module Hazard_Unit(
    // ID阶段寄存器
    input [4:0] ID_rs,           // ID阶段源寄存器1
    input [4:0] ID_rt,           // ID阶段源寄存器2
    input ID_branch,             // ID阶段是否为分支指令(BZ/BN)
    
    // ID/EX阶段信号
    input [4:0] ID_EX_rt,
    input ID_EX_mem_read,        // ID/EX阶段内存读信号
    input [4:0] ID_EX_write_reg, // ID/EX阶段写寄存器
    input ID_EX_reg_write,       // ID/EX阶段寄存器写使能
    
    // EX/MEM阶段信号
    input [4:0] EX_MEM_write_reg, // EX/MEM阶段写寄存器
    input EX_MEM_reg_write,       // EX/MEM阶段寄存器写使能
    
    // MEM/WB阶段信号
    input [4:0] MEM_WB_write_reg, // MEM/WB阶段写寄存器
    input MEM_WB_reg_write,       // MEM/WB阶段寄存器写使能
    
    // 控制冒险信号
    input branch_taken,          // 分支跳转信号
    input jump,                  // 无条件跳转信号
    
    // 输出控制信号
    output reg stall,            // 流水线暂停信号
    output reg [1:0] forward_a,  // 转发控制A (00:无转发, 01:从WB转发, 10:从MEM转发)
    output reg [1:0] forward_b,  // 转发控制B (00:无转发, 01:从WB转发, 10:从MEM转发)
    output reg flush_IF_ID,      // 清空IF/ID流水线寄存器
    output reg flush_ID_EX       // 清空ID/EX流水线寄存器
);

    // ==================== Load-Use冒险检测 ====================
    wire load_use_hazard;
    assign load_use_hazard = ID_EX_mem_read && 
                             ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt)) &&
                             (ID_EX_write_reg != 5'b00000); //regfile已经保证0号寄存器不写入，不需要考虑0号寄存器
    
    // ==================== 分支冒险检测 ====================
    // 分支指令需要等待前面的指令写回，检查ID/EX和EX/MEM两个阶段
    wire branch_stall;
    assign branch_stall = ID_branch && (
                          (ID_EX_reg_write && (ID_EX_write_reg != 5'b00000) &&
                           ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt))) ||
                          (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b00000) &&
                           ((EX_MEM_write_reg == ID_rs) || (EX_MEM_write_reg == ID_rt)))
                          );
    
    // ==================== 数据转发控制 (ID 阶段) ====================
    always @(*) begin
        // Forward A
        if (EX_MEM_reg_write && 
            (EX_MEM_write_reg != 5'b00000) && 
            (EX_MEM_write_reg == ID_rs)) begin
            forward_a = 2'b10;
        end
        else if (MEM_WB_reg_write && 
                 (MEM_WB_write_reg != 5'b00000) && 
                 (MEM_WB_write_reg == ID_rs)) begin
            forward_a = 2'b01;
        end
        else begin
            forward_a = 2'b00;
        end
    end
    
    always @(*) begin
        // Forward B
        if (EX_MEM_reg_write && 
            (EX_MEM_write_reg != 5'b00000) && 
            (EX_MEM_write_reg == ID_rt)) begin
            forward_b = 2'b10;
        end
        else if (MEM_WB_reg_write && 
                 (MEM_WB_write_reg != 5'b00000) && 
                 (MEM_WB_write_reg == ID_rt)) begin
            forward_b = 2'b01;
        end
        else begin
            forward_b = 2'b00;
        end
    end
    
    // ==================== 流水线暂停控制 (Stall) ====================
    always @(*) begin
        if (load_use_hazard || branch_stall) begin
            stall = 1'b1;
        end
        else begin
            stall = 1'b0;
        end
    end
    
    // ==================== 流水线清空控制 (Flush) ====================
    // flush_IF_ID: 只在跳转时清空IF/ID
    // flush_ID_EX: 跳转时清空 + stall时插入bubble
    always @(*) begin
        if (branch_taken || jump) begin
            // 跳转：清空IF/ID和ID/EX
            flush_IF_ID = 1'b1;
            flush_ID_EX = 1'b1;
        end
        else if (load_use_hazard || branch_stall) begin
            // Stall：IF/ID保持不变，但ID/EX插入NOP
            flush_IF_ID = 1'b0;
            flush_ID_EX = 1'b1; 
        end
        else begin
            flush_IF_ID = 1'b0;
            flush_ID_EX = 1'b0;
        end
    end
    
endmodule