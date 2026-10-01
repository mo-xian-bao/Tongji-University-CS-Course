`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: HazardUnit
// Description: 冒险检测单元 - 负责所有冒险检测和分支判断
//              1. Load-Use冒险检测
//              2. MDU冒险检测
//              3. 分支数据冒险检测
//              4. 提前分支判断（ID阶段）
//////////////////////////////////////////////////////////////////////////////////

module HazardUnit(
    // ==================== ID阶段信号 ====================
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [31:0] ID_rs_data_fwd,     // 前推后的rs数据
    input [31:0] ID_rt_data_fwd,     // 前推后的rt数据
    input ID_is_branch,
    input [2:0] ID_branch_type,      // 分支类型
    input ID_is_mdu_op,              // 是否为MDU操作
    input ID_is_mfhi,
    input ID_is_mflo,
    
    // ==================== ID/EX阶段信号 ====================
    input [4:0] ID_EX_write_reg,
    input ID_EX_reg_write,
    input ID_EX_mem_read,
    input ID_EX_is_mdu_op,           // EX阶段是否为MDU操作（用于检测mult刚启动）
    
    // ==================== EX/MEM阶段信号 ====================
    input [4:0] EX_MEM_write_reg,
    input EX_MEM_reg_write,
    input EX_MEM_mem_read,
    
    // ==================== MDU信号 ====================
    input MDU_busy,
    
    // ==================== 输出信号 ====================
    output stall,
    output branch_taken
);

    // ==================== Load-Use冒险检测 ====================
    wire load_use_hazard = ID_EX_mem_read && (ID_EX_write_reg != 5'b0) &&
                           ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt));
    
    // ==================== MDU冒险检测 ====================
    // 修复：不仅检测 MDU_busy，还要检测 EX 阶段正在启动 MDU 指令的情况
    // 因为 MDU_busy 要到下一个周期才会变高
    wire mdu_real_busy = MDU_busy || ID_EX_is_mdu_op;
    wire mdu_hazard = mdu_real_busy && (ID_is_mdu_op || ID_is_mfhi || ID_is_mflo);
    
    // ==================== 分支数据冒险检测 ====================
    wire branch_hazard = ID_is_branch && (
        // ID/EX阶段有写寄存器的指令
        (ID_EX_reg_write && (ID_EX_write_reg != 5'b0) &&
         ((ID_EX_write_reg == ID_rs) || (ID_EX_write_reg == ID_rt))) ||
        // EX/MEM阶段有LOAD指令
        (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b0) && EX_MEM_mem_read &&
         ((EX_MEM_write_reg == ID_rs) || (EX_MEM_write_reg == ID_rt)))
    );
    
    // ==================== Stall信号 ====================
    assign stall = load_use_hazard || mdu_hazard || branch_hazard;
    
    // ==================== 分支判断 ====================
    wire br_eq  = (ID_rs_data_fwd == ID_rt_data_fwd);
    wire br_gez = !ID_rs_data_fwd[31];                          // rs >= 0
    wire br_gtz = !ID_rs_data_fwd[31] && (ID_rs_data_fwd != 0); // rs > 0
    wire br_lez = ID_rs_data_fwd[31] || (ID_rs_data_fwd == 0);  // rs <= 0
    wire br_ltz = ID_rs_data_fwd[31];                           // rs < 0
    
    assign branch_taken = !stall && ID_is_branch && (
        (ID_branch_type == 3'b000 && br_eq)  ||  // BEQ
        (ID_branch_type == 3'b001 && !br_eq) ||  // BNE
        (ID_branch_type == 3'b010 && br_gez) ||  // BGEZ/BGEZAL
        (ID_branch_type == 3'b011 && br_gtz) ||  // BGTZ
        (ID_branch_type == 3'b100 && br_lez) ||  // BLEZ
        (ID_branch_type == 3'b101 && br_ltz)     // BLTZ/BLTZAL
    );

endmodule
