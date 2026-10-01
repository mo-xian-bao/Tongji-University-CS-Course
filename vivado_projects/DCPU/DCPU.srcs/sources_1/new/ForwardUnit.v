`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ForwardUnit
// Description: 数据前推单元 - 负责所有数据前推逻辑和MUX选择
//              1. ID阶段前推 - 用于提前分支判断
//              2. EX阶段前推 - 用于ALU运算
//////////////////////////////////////////////////////////////////////////////////

module ForwardUnit(
    // ==================== ID阶段信号 ====================
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [31:0] ID_rs_data,         // 寄存器文件读出的rs
    input [31:0] ID_rt_data,         // 寄存器文件读出的rt
    
    // ==================== EX阶段信号 ====================
    input [4:0] ID_EX_rs,
    input [4:0] ID_EX_rt,
    input [31:0] ID_EX_rs_data,      // 流水线寄存器中的rs
    input [31:0] ID_EX_rt_data,      // 流水线寄存器中的rt
    
    // ==================== EX/MEM阶段信号 ====================
    input [4:0] EX_MEM_write_reg,
    input EX_MEM_reg_write,
    input EX_MEM_mem_read,
    input [31:0] EX_MEM_alu_result,  // EX/MEM阶段ALU结果
    
    // ==================== MEM/WB阶段信号 ====================
    input [4:0] MEM_WB_write_reg,
    input MEM_WB_reg_write,
    input [31:0] WB_write_data,      // WB阶段写回数据
    
    // ==================== ID阶段前推输出（用于分支判断） ====================
    output [31:0] ID_rs_data_fwd,
    output [31:0] ID_rt_data_fwd,
    
    // ==================== EX阶段前推输出（用于ALU运算） ====================
    output [31:0] EX_rs_data_fwd,
    output [31:0] EX_rt_data_fwd
);

    // ==================== ID阶段前推控制 ====================
    wire [1:0] ID_forward_a, ID_forward_b;
    
    // ID阶段 rs 前推控制
    assign ID_forward_a = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && 
                           (EX_MEM_write_reg == ID_rs) && !EX_MEM_mem_read) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b0) && 
                           (MEM_WB_write_reg == ID_rs)) ? 2'b01 : 2'b00;
    
    // ID阶段 rt 前推控制
    assign ID_forward_b = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && 
                           (EX_MEM_write_reg == ID_rt) && !EX_MEM_mem_read) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b0) && 
                           (MEM_WB_write_reg == ID_rt)) ? 2'b01 : 2'b00;
    
    // ID阶段前推MUX
    assign ID_rs_data_fwd = (ID_forward_a == 2'b10) ? EX_MEM_alu_result :
                            (ID_forward_a == 2'b01) ? WB_write_data :
                            ID_rs_data;
    
    assign ID_rt_data_fwd = (ID_forward_b == 2'b10) ? EX_MEM_alu_result :
                            (ID_forward_b == 2'b01) ? WB_write_data :
                            ID_rt_data;
    
    // ==================== EX阶段前推控制 ====================
    wire [1:0] EX_forward_a, EX_forward_b;
    
    // EX阶段 rs 前推控制
    assign EX_forward_a = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && 
                           (EX_MEM_write_reg == ID_EX_rs)) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b0) && 
                           (MEM_WB_write_reg == ID_EX_rs)) ? 2'b01 : 2'b00;
    
    // EX阶段 rt 前推控制
    assign EX_forward_b = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && 
                           (EX_MEM_write_reg == ID_EX_rt)) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b0) && 
                           (MEM_WB_write_reg == ID_EX_rt)) ? 2'b01 : 2'b00;
    
    // EX阶段前推MUX
    assign EX_rs_data_fwd = (EX_forward_a == 2'b10) ? EX_MEM_alu_result :
                            (EX_forward_a == 2'b01) ? WB_write_data :
                            ID_EX_rs_data;
    
    assign EX_rt_data_fwd = (EX_forward_b == 2'b10) ? EX_MEM_alu_result :
                            (EX_forward_b == 2'b01) ? WB_write_data :
                            ID_EX_rt_data;

endmodule
