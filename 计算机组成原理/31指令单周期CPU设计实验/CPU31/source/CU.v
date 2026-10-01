//控制器（内置译码器）
module CU(
    input [31:0] inst, // 指令
    input ZF, // 零标志位,MUX6要用
    output [8:0] muxc, // 多路选择器控制
    output [1:0] mux10c, // 多路选择器控制RF的写入地址：00-Rdc, 01-Rtc, 10-$ra
    output [3:0] aluc, // ALU操作码
    output EXT1_C, // 扩展1控制
    output RF_W, // 寄存器写使能
    output DM_W, // 数据存储器写使能
    output DM_R // 数据存储器读使能
);

// Opcode 参数定义
localparam R_TYPE_OP = 6'b000000; // R型指令操作码
localparam ADDI_OP   = 6'b001000; // ADDI 指令操作码
localparam ADDIU_OP  = 6'b001001; // ADDIU 指令操作码
localparam ANDI_OP   = 6'b001100; // ANDI 指令操作码
localparam ORI_OP    = 6'b001101; // ORI 指令操作码
localparam XORI_OP   = 6'b001110; // XORI 指令操作码
localparam LW_OP     = 6'b100011; // LW 指令操作码
localparam SW_OP     = 6'b101011; // SW 指令操作码
localparam BEQ_OP    = 6'b000100; // BEQ 指令操作码
localparam BNE_OP    = 6'b000101; // BNE 指令操作码
localparam SLTI_OP   = 6'b001010; // SLTI 指令操作码
localparam SLTIU_OP  = 6'b001011; // SLTIU 指令操作码
localparam LUI_OP    = 6'b001111; // LUI 指令操作码
localparam J_OP      = 6'b000010; // J 指令操作码
localparam JAL_OP    = 6'b000011; // JAL 指令操作码

// R型指令功能码参数定义
localparam ADD_FUNC  = 6'b100000; // ADD 功能码
localparam ADDU_FUNC = 6'b100001; // ADDU 功能码
localparam SUB_FUNC  = 6'b100010; // SUB 功能码
localparam SUBU_FUNC = 6'b100011; // SUBU 功能码
localparam AND_FUNC  = 6'b100100; // AND 功能码
localparam OR_FUNC   = 6'b100101; // OR 功能码
localparam XOR_FUNC  = 6'b100110; // XOR 功能码
localparam NOR_FUNC  = 6'b100111; // NOR 功能码
localparam SLT_FUNC  = 6'b101010; // SLT 功能码
localparam SLTU_FUNC = 6'b101011; // SLTU 功能码
localparam SLL_FUNC  = 6'b000000; // SLL 功能码
localparam SRL_FUNC  = 6'b000010; // SRL 功能码
localparam SRA_FUNC  = 6'b000011; // SRA 功能码
localparam SLLV_FUNC = 6'b000100; // SLLV 功能码
localparam SRLV_FUNC = 6'b000110; // SRLV 功能码
localparam SRAV_FUNC = 6'b000111; // SRAV 功能码
localparam JR_FUNC   = 6'b001000; // JR 功能码

// ALUC
localparam ALU_ADDU = 4'b0000; // 无符号加
localparam ALU_SUBU = 4'b0001; // 无符号减
localparam ALU_ADD  = 4'b0010; // 有符号加
localparam ALU_SUB  = 4'b0011; // 有符号减
localparam ALU_AND  = 4'b0100; // 逻辑与
localparam ALU_OR   = 4'b0101; // 逻辑或
localparam ALU_XOR  = 4'b0110; // 逻辑异或
localparam ALU_NOR  = 4'b0111; // 逻辑或非
localparam ALU_LUI  = 4'b1000; // LUI：立即数加载到高位
localparam ALU_SLTU = 4'b1010; // 无符号小于则置位
localparam ALU_SLT  = 4'b1011; // 有符号小于则置位
localparam ALU_SRA  = 4'b1100; // 算术右移
localparam ALU_SRL  = 4'b1101; // 逻辑右移
localparam ALU_SLL  = 4'b1110; // 逻辑左移

reg RF_W_reg, DM_W_reg, DM_R_reg;
reg [3:0] aluc_reg;
reg [8:0] muxc_reg;
reg [1:0] mux10c_reg; // 2位的MUX10控制寄存器
reg EXT1_C_reg;

always @(*) begin
    // 控制信号的默认赋值
    RF_W_reg = 1'b0;
    DM_W_reg = 1'b0;
    DM_R_reg = 1'b0;
    aluc_reg = ALU_ADDU;
    muxc_reg = 9'b000000000;
    mux10c_reg = 2'b00; // 默认选择Rdc (rd字段)
    EXT1_C_reg = 1'b0;

    case (inst[31:26]) // 指令的操作码 op 字段
        R_TYPE_OP: begin
            RF_W_reg = 1'b1; // 大多数R型指令会写回寄存器堆
            //(ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR, SLLV, SRLV, SRAV)
            muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0}; 
            mux10c_reg = 2'b00; // R型指令写入Rdc (rd字段)
            case (inst[5:0]) // 指令的功能码 func 字段
                ADD_FUNC:  aluc_reg = ALU_ADD;
                ADDU_FUNC: aluc_reg = ALU_ADDU;
                SUB_FUNC:  aluc_reg = ALU_SUB;
                SUBU_FUNC: aluc_reg = ALU_SUBU;
                AND_FUNC:  aluc_reg = ALU_AND;
                OR_FUNC:   aluc_reg = ALU_OR;
                XOR_FUNC:  aluc_reg = ALU_XOR;
                NOR_FUNC:  aluc_reg = ALU_NOR;
                SLT_FUNC:  begin
                    aluc_reg = ALU_SLT;
                    muxc_reg = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0}; 
                    EXT1_C_reg = 1'b1;
                    // mux10c_reg保持为2'b00 (Rdc)
                end
                SLTU_FUNC: begin
                    aluc_reg = ALU_SLTU;
                    muxc_reg = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0}; 
                    // mux10c_reg保持为2'b00 (Rdc)
                end
                SLL_FUNC:  begin
                    aluc_reg = ALU_SLL;
                    muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0};
                    // mux10c_reg保持为2'b00 (Rdc)
                end
                SRL_FUNC:  begin
                    aluc_reg = ALU_SRL;
                    muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0}; 
                    // mux10c_reg保持为2'b00 (Rdc)
                end
                SRA_FUNC:  begin
                    aluc_reg = ALU_SRA;
                    muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0}; 
                    // mux10c_reg保持为2'b00 (Rdc)
                end
                SLLV_FUNC: aluc_reg = ALU_SLL;
                SRLV_FUNC: aluc_reg = ALU_SRL;
                SRAV_FUNC: aluc_reg = ALU_SRA;
                JR_FUNC:   begin
                    RF_W_reg = 1'b0; // JR 指令不写回寄存器堆
                    aluc_reg = ALU_ADDU; //用不到ALU
                    muxc_reg = 9'b000000000; // MUX1=0, MUX4=0
                    // mux10c_reg不重要，因为JR不写寄存器
                end
                default: begin // 对于有效的R型指令，不应到达此处
                    RF_W_reg = 1'b0;
                    aluc_reg = ALU_ADDU; // 默认
                end
            endcase
        end
        ADDI_OP: begin
            aluc_reg = ALU_ADD;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        ADDIU_OP: begin
            aluc_reg = ALU_ADDU;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        ANDI_OP: begin
            aluc_reg = ALU_AND;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        ORI_OP: begin
            aluc_reg = ALU_OR;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        XORI_OP: begin
            aluc_reg = ALU_XOR;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        LW_OP: begin
            aluc_reg = ALU_ADD; 
            RF_W_reg = 1'b1;
            DM_R_reg = 1'b1;
            muxc_reg = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        SW_OP: begin
            aluc_reg = ALU_ADD; 
            DM_W_reg = 1'b1;
            muxc_reg = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0};
            // mux10c_reg不重要，因为SW不写寄存器
        end
        BEQ_OP: begin
            aluc_reg = ALU_SUB; 
            muxc_reg = {1'b0, 1'b0, 1'b0, !ZF, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
            // mux10c_reg不重要，因为BEQ不写寄存器
        end
        BNE_OP: begin
            aluc_reg = ALU_SUB; 
            muxc_reg = {1'b0, 1'b0, 1'b0, ZF, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
            // mux10c_reg不重要，因为BNE不写寄存器
        end
        SLTI_OP: begin
            aluc_reg = ALU_SLT;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
            EXT1_C_reg = 1'b1;
        end
        SLTIU_OP: begin
            aluc_reg = ALU_SLTU;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        LUI_OP: begin
            aluc_reg = ALU_LUI;
            RF_W_reg = 1'b1;
            muxc_reg = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0};
            mux10c_reg = 2'b01; // I型指令写入Rtc (rt字段)
        end
        J_OP: begin
            aluc_reg = ALU_ADDU; // 用不到ALU
            muxc_reg = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
            // mux10c_reg不重要，因为J不写寄存器
        end
        JAL_OP: begin
            RF_W_reg = 1'b1;   
            aluc_reg = ALU_ADD; 
            muxc_reg = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
            mux10c_reg = 2'b10; // JAL指令写入$ra (寄存器31)
        end
        default: begin // 未知操作码的默认处理
            RF_W_reg = 1'b0;
            DM_W_reg = 1'b0;
            DM_R_reg = 1'b0;
            aluc_reg = ALU_ADDU;
            muxc_reg = 9'b000000000;
            mux10c_reg = 2'b00; // 默认值
        end
    endcase
end

assign RF_W = RF_W_reg;
assign DM_W = DM_W_reg;
assign DM_R = DM_R_reg;
assign muxc = muxc_reg;
assign mux10c = mux10c_reg; // 输出MUX10控制信号
assign aluc = aluc_reg;
assign EXT1_C = EXT1_C_reg;

endmodule

