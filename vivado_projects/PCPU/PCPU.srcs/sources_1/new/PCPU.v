`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/09 21:19:06
// Design Name: 
// Module Name: PCPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 5-stage Pipelined CPU with 16 instructions
// 
// Dependencies: IMEM, DMEM, ALU, RegFile, Hazard_Unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PCPU(
    input clk,              // 时钟
    input rst,              // 复位
    output reg halt,        // 停机
    output [31:0] instr_out // 指令码输出（供显示）
);

    // ==================== 指令操作码定义 ====================
    parameter OP_NOP   = 6'b000000;  // 空操作
    parameter OP_HALT  = 6'b000001;  // 停机
    parameter OP_ADD   = 6'b000010;  // rd = rs + rt (有符号加法)
    parameter OP_SUB   = 6'b000011;  // rd = rs - rt (有符号减法)
    parameter OP_AND   = 6'b000100;  // rd = rs & rt
    parameter OP_OR    = 6'b000101;  // rd = rs | rt
    parameter OP_XOR   = 6'b000110;  // rd = rs ^ rt
    parameter OP_SLL   = 6'b000111;  // rd = rt << shamt
    parameter OP_SRL   = 6'b001000;  // rd = rt >> shamt (逻辑右移)
    parameter OP_SRA   = 6'b001001;  // rd = rt >> shamt (算术右移)
    parameter OP_CMP   = 6'b001010;  // 比较 rs 和 rt，设置标志位
    parameter OP_LOAD  = 6'b001011;  // rd = MEM[rs + imm]
    parameter OP_STORE = 6'b001100;  // MEM[rs + imm] = rt
    parameter OP_ADDI  = 6'b001101;  // rd = rs + imm (符号扩展)
    parameter OP_BZ    = 6'b001110;  // if(Zero) PC = PC + 4 + (imm << 2)
    parameter OP_BN    = 6'b001111;  // if(Neg) PC = PC + 4 + (imm << 2)
    parameter OP_JMP   = 6'b010000;  // PC = {PC[31:28], addr, 2'b00}
    
    // ALU控制信号定义
    parameter ALU_ADD  = 4'b0010;
    parameter ALU_SUB  = 4'b0011;
    parameter ALU_AND  = 4'b0100;
    parameter ALU_OR   = 4'b0101;
    parameter ALU_XOR  = 4'b0110;
    parameter ALU_SLL  = 4'b1110;
    parameter ALU_SRL  = 4'b1101;
    parameter ALU_SRA  = 4'b1100;
    
    // ==================== IF阶段信号 ====================
    reg [31:0] PC;                  // 程序计数器
    wire [31:0] PC_plus_4;          // PC + 4
    wire [31:0] PC_next;            // 下一个PC值
    wire [31:0] IF_instr;           // 取出的指令
    
    // ==================== IF/ID流水线寄存器 ====================
    reg [31:0] IF_ID_PC;            // PC值
    reg [31:0] IF_ID_instr;         // 指令
    
    // ==================== ID阶段信号 ====================
    wire [5:0] ID_opcode;           // 操作码
    wire [4:0] ID_rs;               // 源寄存器1
    wire [4:0] ID_rt;               // 源寄存器2
    wire [4:0] ID_rd;               // 目标寄存器
    wire [4:0] ID_shamt;            // 移位量
    wire [15:0] ID_imm;             // 立即数
    wire [25:0] ID_addr;            // 跳转地址
    wire [31:0] ID_imm_ext;         // 符号扩展后的立即数
    wire [31:0] ID_rs_data;         // 源寄存器1数据
    wire [31:0] ID_rt_data;         // 源寄存器2数据
    wire [31:0] ID_rs_data_fwd;     // 转发后的rs数据
    wire [31:0] ID_rt_data_fwd;     // 转发后的rt数据
    
    // 控制信号
    wire ID_reg_write;              // 寄存器写使能
    wire ID_mem_read;               // 内存读使能
    wire ID_mem_write;              // 内存写使能
    wire ID_alu_src;                // ALU源选择 (0: rt_data, 1: imm)
    wire ID_reg_dst;                // 寄存器目标选择 (0: rt, 1: rd)
    wire ID_branch;                 // 分支指令
    wire ID_jump;                   // 跳转指令
    wire [3:0] ID_alu_op;           // ALU操作码
    wire [4:0] ID_write_reg;        // 写入的目标寄存器
    
    // ==================== ID/EX流水线寄存器 ====================
    reg [31:0] ID_EX_PC;
    reg [31:0] ID_EX_rs_data;
    reg [31:0] ID_EX_rt_data;
    reg [31:0] ID_EX_imm_ext;
    reg [4:0] ID_EX_rs;
    reg [4:0] ID_EX_rt;
    reg [4:0] ID_EX_rd;
    reg [4:0] ID_EX_shamt;
    reg [5:0] ID_EX_opcode;
    
    // 控制信号
    reg ID_EX_reg_write;
    reg ID_EX_mem_read;
    reg ID_EX_mem_write;
    reg ID_EX_alu_src;
    reg ID_EX_reg_dst;
    reg [3:0] ID_EX_alu_op;
    reg [4:0] ID_EX_write_reg;
    
    // ==================== EX阶段信号 ====================
    wire [31:0] EX_alu_input_a;     // ALU输入A
    wire [31:0] EX_alu_input_b;     // ALU输入B
    wire [31:0] EX_alu_result;      // ALU结果
    wire EX_zero;                   // 零标志
    wire EX_carry;                  // 进位标志
    wire EX_negative;               // 负数标志
    wire EX_overflow;               // 溢出标志
    wire [4:0] EX_write_reg;        // 写入的目标寄存器
    
    // ==================== EX/MEM流水线寄存器 ====================
    reg [31:0] EX_MEM_alu_result;
    reg [31:0] EX_MEM_rt_data;
    reg [4:0] EX_MEM_write_reg;
    reg EX_MEM_zero;
    reg EX_MEM_negative;
    
    // 控制信号
    reg EX_MEM_reg_write;
    reg EX_MEM_mem_read;
    reg EX_MEM_mem_write;
    
    // ==================== MEM阶段信号 ====================
    wire [31:0] MEM_read_data;      // 从内存读取的数据
    
    // ==================== MEM/WB流水线寄存器 ====================
    reg [31:0] MEM_WB_alu_result;
    reg [31:0] MEM_WB_mem_data;
    reg [4:0] MEM_WB_write_reg;
    
    // 控制信号
    reg MEM_WB_reg_write;
    reg MEM_WB_mem_read;
    
    // ==================== WB阶段信号 ====================
    wire [31:0] WB_write_data;      // 写回数据
    
    // ==================== 冒险检测与转发信号 ====================
    wire stall;                     // 流水线暂停信号
    wire [1:0] forward_a;           // 转发控制A
    wire [1:0] forward_b;           // 转发控制B
    wire flush_IF_ID;               // 清空IF/ID
    wire flush_ID_EX;               // 清空ID/EX
    wire branch_taken;              // 分支跳转
    wire [31:0] branch_target;      // 分支目标地址
    wire [31:0] jump_target;        // 跳转目标地址
    
    // ==================== 模块实例化 ====================
    
    // 指令存储器
    IMEM imem(
        .PC(PC),
        .Instr(IF_instr)
    );
    
    // 寄存器文件
    RegFile regfile(
        .clk(clk),
        .rst(rst),
        .ena(1'b1),
        .we(MEM_WB_reg_write),
        .Rdc(MEM_WB_write_reg),
        .Rsc(ID_rs),
        .Rtc(ID_rt),
        .Rd(WB_write_data),
        .Rs(ID_rs_data),
        .Rt(ID_rt_data)
    );
    
    // ALU
    ALU alu(
        .a(EX_alu_input_a),
        .b(EX_alu_input_b),
        .aluc(ID_EX_alu_op),
        .r(EX_alu_result),
        .zero(EX_zero),
        .carry(EX_carry),
        .negative(EX_negative),
        .overflow(EX_overflow)
    );
    
    // 数据存储器
    DMEM dmem(
        .clk(clk),
        .ena(EX_MEM_mem_read || EX_MEM_mem_write),
        .we(EX_MEM_mem_write),
        .re(EX_MEM_mem_read),
        .addr(EX_MEM_alu_result[6:2]),
        .data_in(EX_MEM_rt_data),
        .data_out(MEM_read_data)
    );
    
    // 冒险检测单元
    Hazard_Unit hazard_unit(
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_branch(ID_branch),
        .ID_EX_rt(ID_EX_rt),
        .ID_EX_mem_read(ID_EX_mem_read),
        .ID_EX_write_reg(ID_EX_write_reg),
        .ID_EX_reg_write(ID_EX_reg_write),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .EX_MEM_reg_write(EX_MEM_reg_write),
        .MEM_WB_write_reg(MEM_WB_write_reg),
        .MEM_WB_reg_write(MEM_WB_reg_write),
        .branch_taken(branch_taken),
        .jump(ID_jump),
        .stall(stall),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .flush_IF_ID(flush_IF_ID),
        .flush_ID_EX(flush_ID_EX)
    );
    
    // ==================== IF阶段逻辑 ====================
    assign PC_plus_4 = PC + 4;
    
    // PC选择逻辑：跳转 > 分支 > PC+4
    assign PC_next = ID_jump ? jump_target :
                     branch_taken ? branch_target :
                     PC_plus_4;
    
    // PC更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'h00400000;  // 初始PC地址
        end else if (!stall && !halt) begin
            PC <= PC_next;
        end
    end
    
    // IF/ID流水线寄存器更新
    always @(posedge clk or posedge rst) begin
        if (rst || flush_IF_ID) begin
            IF_ID_PC <= 32'h00400000;
            IF_ID_instr <= 32'h00000000;  // NOP
        end else if (!stall) begin
            IF_ID_PC <= PC;
            IF_ID_instr <= IF_instr;
        end
    end
    
    // ==================== ID阶段逻辑 ====================
    // 指令译码
    assign ID_opcode = IF_ID_instr[31:26];
    assign ID_rs = IF_ID_instr[25:21];
    assign ID_rt = IF_ID_instr[20:16];
    assign ID_rd = IF_ID_instr[15:11];
    assign ID_shamt = IF_ID_instr[10:6];
    assign ID_imm = IF_ID_instr[15:0];
    assign ID_addr = IF_ID_instr[25:0];
    
    // 立即数符号扩展
    assign ID_imm_ext = {{16{ID_imm[15]}}, ID_imm};
    
    // 控制信号生成
    assign ID_reg_write = (ID_opcode == OP_ADD || ID_opcode == OP_SUB || 
                           ID_opcode == OP_AND || ID_opcode == OP_OR || 
                           ID_opcode == OP_XOR || ID_opcode == OP_SLL || 
                           ID_opcode == OP_SRL || ID_opcode == OP_SRA || 
                           ID_opcode == OP_ADDI || ID_opcode == OP_LOAD); // 寄存器写使能
    
    assign ID_mem_read = (ID_opcode == OP_LOAD); // 内存读使能
    assign ID_mem_write = (ID_opcode == OP_STORE); // 内存写使能
    assign ID_alu_src = (ID_opcode == OP_ADDI || ID_opcode == OP_LOAD || ID_opcode == OP_STORE); // ALU源选择 (0: rt_data, 1: imm)
    assign ID_reg_dst = (ID_opcode == OP_ADD || ID_opcode == OP_SUB || 
                         ID_opcode == OP_AND || ID_opcode == OP_OR || 
                         ID_opcode == OP_XOR || ID_opcode == OP_SLL || 
                         ID_opcode == OP_SRL || ID_opcode == OP_SRA); // 寄存器目标选择 (0: rt, 1: rd)
    assign ID_branch = (ID_opcode == OP_BZ || ID_opcode == OP_BN); // 分支指令
    assign ID_jump = (ID_opcode == OP_JMP); // 跳转指令
    
    // 写寄存器选择
    assign ID_write_reg = ID_reg_dst ? ID_rd : ID_rt; // 写入的目标寄存器
    
    // ALU操作码生成
    function [3:0] get_alu_op;
        input [5:0] opcode;
        begin
            case(opcode)
                OP_ADD, OP_ADDI, OP_LOAD, OP_STORE: get_alu_op = ALU_ADD;
                OP_SUB, OP_CMP: get_alu_op = ALU_SUB;
                OP_AND: get_alu_op = ALU_AND;
                OP_OR:  get_alu_op = ALU_OR;
                OP_XOR: get_alu_op = ALU_XOR;
                OP_SLL: get_alu_op = ALU_SLL;
                OP_SRL: get_alu_op = ALU_SRL;
                OP_SRA: get_alu_op = ALU_SRA;
                default: get_alu_op = ALU_ADD;
            endcase
        end
    endfunction
    
    assign ID_alu_op = get_alu_op(ID_opcode);
    
    // 数据转发到ID阶段（用于分支判断）
    assign ID_rs_data_fwd = (forward_a == 2'b10) ? EX_MEM_alu_result :
                            (forward_a == 2'b01) ? WB_write_data :
                            ID_rs_data;
    
    assign ID_rt_data_fwd = (forward_b == 2'b10) ? EX_MEM_alu_result :
                            (forward_b == 2'b01) ? WB_write_data :
                            ID_rt_data;
    
    // 分支判断
    assign branch_taken = !stall && (
                          (ID_opcode == OP_BZ && (ID_rs_data_fwd == ID_rt_data_fwd)) ||
                          (ID_opcode == OP_BN && ($signed(ID_rs_data_fwd) < $signed(ID_rt_data_fwd)))
                          );
    
    assign branch_target = IF_ID_PC + 4 + (ID_imm_ext << 2);
    assign jump_target = {IF_ID_PC[31:28], ID_addr, 2'b00};
    
    // HALT信号处理
    always @(posedge clk or posedge rst) begin
        if (rst)
            halt <= 1'b0;
        else if (ID_opcode == OP_HALT)
            halt <= 1'b1;
    end
    
    // ID/EX流水线寄存器更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时清零
            ID_EX_PC <= 32'h00400000;
            ID_EX_rs_data <= 32'h00000000;
            ID_EX_rt_data <= 32'h00000000;
            ID_EX_imm_ext <= 32'h00000000;
            ID_EX_rs <= 5'b00000;
            ID_EX_rt <= 5'b00000;
            ID_EX_rd <= 5'b00000;
            ID_EX_shamt <= 5'b00000;
            ID_EX_opcode <= OP_NOP;
            ID_EX_reg_write <= 1'b0;
            ID_EX_mem_read <= 1'b0;
            ID_EX_mem_write <= 1'b0;
            ID_EX_alu_src <= 1'b0;
            ID_EX_reg_dst <= 1'b0;
            ID_EX_alu_op <= 4'b0000;
            ID_EX_write_reg <= 5'b00000;
        end else if (flush_ID_EX) begin
            // flush或stall时清零控制信号
            ID_EX_opcode <= OP_NOP;
            ID_EX_reg_write <= 1'b0;
            ID_EX_mem_read <= 1'b0;
            ID_EX_mem_write <= 1'b0;
            ID_EX_write_reg <= 5'b00000;
        end else begin
            // 正常更新
            ID_EX_PC <= IF_ID_PC;
            ID_EX_rs_data <= ID_rs_data;
            ID_EX_rt_data <= ID_rt_data;
            ID_EX_imm_ext <= ID_imm_ext;
            ID_EX_rs <= ID_rs;
            ID_EX_rt <= ID_rt;
            ID_EX_rd <= ID_rd;
            ID_EX_shamt <= ID_shamt;
            ID_EX_opcode <= ID_opcode;
            ID_EX_reg_write <= ID_reg_write;
            ID_EX_mem_read <= ID_mem_read;
            ID_EX_mem_write <= ID_mem_write;
            ID_EX_alu_src <= ID_alu_src;
            ID_EX_reg_dst <= ID_reg_dst;
            ID_EX_alu_op <= ID_alu_op;
            ID_EX_write_reg <= ID_write_reg;
        end
    end
    
    // ==================== EX阶段逻辑 ====================
    // EX阶段数据forward选择（基于EX阶段的寄存器号）
    wire [1:0] EX_forward_a;
    wire [1:0] EX_forward_b;
    wire [31:0] EX_forward_a_data;
    wire [31:0] EX_forward_b_data;
    
    // EX阶段forward检测（使用ID_EX阶段的寄存器号）
    assign EX_forward_a = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b00000) && (EX_MEM_write_reg == ID_EX_rs)) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b00000) && (MEM_WB_write_reg == ID_EX_rs)) ? 2'b01 :
                          2'b00;
    
    assign EX_forward_b = (EX_MEM_reg_write && (EX_MEM_write_reg != 5'b00000) && (EX_MEM_write_reg == ID_EX_rt)) ? 2'b10 :
                          (MEM_WB_reg_write && (MEM_WB_write_reg != 5'b00000) && (MEM_WB_write_reg == ID_EX_rt)) ? 2'b01 :
                          2'b00;
    
    assign EX_forward_a_data = (EX_forward_a == 2'b10) ? EX_MEM_alu_result :
                               (EX_forward_a == 2'b01) ? WB_write_data :
                               ID_EX_rs_data;
    
    assign EX_forward_b_data = (EX_forward_b == 2'b10) ? EX_MEM_alu_result :
                               (EX_forward_b == 2'b01) ? WB_write_data :
                               ID_EX_rt_data;
    
    // ALU输入选择
    assign EX_alu_input_a = (ID_EX_opcode == OP_SLL || ID_EX_opcode == OP_SRL || ID_EX_opcode == OP_SRA) ? 
                            {27'b0, ID_EX_shamt} : EX_forward_a_data;
    
    assign EX_alu_input_b = ID_EX_alu_src ? ID_EX_imm_ext : EX_forward_b_data;
    
    assign EX_write_reg = ID_EX_write_reg;
    
    // EX/MEM流水线寄存器更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_MEM_alu_result <= 32'h00000000;
            EX_MEM_rt_data <= 32'h00000000;
            EX_MEM_write_reg <= 5'b00000;
            EX_MEM_zero <= 1'b0;
            EX_MEM_negative <= 1'b0;
            EX_MEM_reg_write <= 1'b0;
            EX_MEM_mem_read <= 1'b0;
            EX_MEM_mem_write <= 1'b0;
        end else begin
            EX_MEM_alu_result <= EX_alu_result;
            EX_MEM_rt_data <= EX_forward_b_data;
            EX_MEM_write_reg <= EX_write_reg;
            EX_MEM_zero <= EX_zero;
            EX_MEM_negative <= EX_negative;  
            EX_MEM_reg_write <= ID_EX_reg_write;
            EX_MEM_mem_read <= ID_EX_mem_read;
            EX_MEM_mem_write <= ID_EX_mem_write;
        end
    end
    
    // ==================== MEM阶段逻辑 ====================
    // 数据存储器访问在DMEM模块中完成
    
    // MEM/WB流水线寄存器更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB_alu_result <= 32'h00000000;
            MEM_WB_mem_data <= 32'h00000000;
            MEM_WB_write_reg <= 5'b00000;
            MEM_WB_reg_write <= 1'b0;
            MEM_WB_mem_read <= 1'b0;
        end else begin
            MEM_WB_alu_result <= EX_MEM_alu_result;
            MEM_WB_mem_data <= MEM_read_data;
            MEM_WB_write_reg <= EX_MEM_write_reg;
            MEM_WB_reg_write <= EX_MEM_reg_write;
            MEM_WB_mem_read <= EX_MEM_mem_read;
        end
    end
    
    // ==================== WB阶段逻辑 ====================
    // 写回数据选择：内存数据或ALU结果
    assign WB_write_data = MEM_WB_mem_read ? MEM_WB_mem_data : MEM_WB_alu_result;
    
    // ==================== 指令码输出 ====================
    // 输出当前取出的指令码供顶层模块显示
    assign instr_out = IF_instr;
    
endmodule
