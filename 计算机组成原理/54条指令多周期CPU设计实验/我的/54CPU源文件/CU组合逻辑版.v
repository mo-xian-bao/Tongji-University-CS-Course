module CU(
    input clk,
    input rst,

    input [31:0] Instr, // 输入指令
    input [31:0] ACC, // 输入ACC寄存器值
    input ZF, // 零标志
    input SF, // 符号标志
    input [31:0] CP0_status, // CP0状态寄存器值
    input MDU_busy, // MDU忙信号

    // 控制信号输出
    output PC_in,           // PC写使能
    output IR_in,           // 指令寄存器写使能
    output ACC_in,          // ACC寄存器写使能
    output [3:0] ALUc,      // ALU控制信号
    output [1:0] MDUc,      // MDU控制信号
    output DM_r,            // 数据存储器读使能
    output DM_w,            // 数据存储器写使能
    output [2:0] byte_out_c, // 字节输出控制信号
    output [3:0] byte_in_ena, // 字节输入使能信号
    output HI_w,            // HI寄存器写使能
    output LO_w,            // LO寄存器写使能
    output M1,              // 多路选择器M1控制信号
    output M2,              // 多路选择器M2控制信号
    output M3,              // 多路选择器M3控制信号
    output [2:0] M4,        // 多路选择器M4控制信号
    output [2:0] M5,        // 多路选择器M5控制信号
    output M6,              // 多路选择器M6控制信号
    output M7,              // 多路选择器M7控制信号
    output mfc0,            // CP0读控制信号
    output mtc0,            // CP0写控制信号
    output eret,            // 异常返回信号
    output exception,       // 异常信号
    output [4:0] cause,     // 异常原因码
    output MDR_in,          // MDR寄存器写使能
    output EXT_c,           // 扩展控制信号
    output Reg_in,          // 寄存器堆写使能
    output RsReg_in,        // Rs寄存器写使能
    output RtReg_in,        // Rt寄存器写使能
    output MDU_start,       // MDU启动信号
    output Latch_PC4_in_M4  // PC4寄存器写使能(MUX4)
);

    // 指令字段解析
    wire [5:0] op = Instr[31:26];      // 操作码
    wire [4:0] rs = Instr[25:21];      // 源寄存器1
    wire [4:0] rt = Instr[20:16];      // 源寄存器2
    wire [4:0] rd = Instr[15:11];      // 目标寄存器
    wire [4:0] shamt = Instr[10:6];    // 移位量
    wire [5:0] func = Instr[5:0];      // 功能码
    wire [15:0] imm = Instr[15:0];     // 立即数
    wire [25:0] addr = Instr[25:0];    // 跳转地址
    
    // 状态定义
    localparam S_IF          = 5'd0;  // 00000: 取指
    localparam S_ID          = 5'd1;  // 00001: 译码
    localparam S_EX_ALU      = 5'd2;  // 00010: ALU执行
    localparam S_WB_ALU      = 5'd3;  // 00011: ALU结果写回
    localparam S_EX_ADDR     = 5'd4;  // 00100: 计算访存地址
    localparam S_MEM_READ    = 5'd5;  // 00101: 读数据存储器
    localparam S_MEM_WRITE   = 5'd6;  // 00110: 写数据存储器
    localparam S_WB_LOAD     = 5'd7;  // 00111: 加载指令写回
    localparam S_EX_BRANCH   = 5'd8;  // 01000: 执行分支
    localparam S_EX_JUMP     = 5'd9;  // 01001: 执行跳转
    localparam S_MDU_START   = 5'd10; // 01010: 启动MDU
    localparam S_MDU_WAIT    = 5'd11; // 01011: 等待MDU
    localparam S_MDU_DONE    = 5'd12; // 01100: MDU结果写入HI/LO
    localparam S_WB_FROM_HILO = 5'd13; // 01101: 从HI/LO写回RegFile
    localparam S_EX_TO_HILO   = 5'd14; // 01110: 写入HI/LO寄存器
    localparam S_EXCEPTION    = 5'd15; // 01111: 异常处理
    localparam S_EX_TO_CP0    = 5'd16; // 10000: 写入CP0
    localparam S_WB_FROM_CP0  = 5'd17; // 10001: 从CP0写回RegFile
    localparam S_EX_ERET      = 5'd18; // 10010: 执行eret
    
    // 状态寄存器
    reg [4:0] state;
    reg [4:0] next_state;

    // 状态机逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IF;
        end else begin
            state <= next_state;
        end
    end

    // 状态转移逻辑
    always @(*) begin
        case (state)
            S_IF: next_state = S_ID;
            S_ID: begin
                case (op)
                    6'b000000: begin // R型指令
                        case (func)
                            6'b011000, 6'b011001, 6'b011010, 6'b011011: next_state = S_MDU_START;
                            6'b010000, 6'b010010: next_state = S_WB_FROM_HILO;
                            6'b010001, 6'b010011: next_state = S_EX_TO_HILO;
                            6'b001001, 6'b001000: next_state = S_EX_JUMP;
                            6'b001100, 6'b001101, 6'b110100: next_state = S_EXCEPTION;
                            default: next_state = S_EX_ALU;
                        endcase
                    end
                    6'b011100: next_state = (func == 6'b100000) ? S_EX_ALU : S_IF;
                    6'b001000, 6'b001001, 6'b001100, 6'b001101, 6'b001010, 6'b001011, 6'b001111, 6'b001110: next_state = S_EX_ALU;
                    6'b100000, 6'b100001, 6'b100011, 6'b100100, 6'b100101, 6'b101000, 6'b101001, 6'b101011: next_state = S_EX_ADDR;
                    6'b000010, 6'b000011: next_state = S_EX_JUMP;
                    6'b000100, 6'b000101, 6'b000001: next_state = S_EX_BRANCH;
                    6'b010000: begin
                        case (rs)
                            5'b00000: next_state = S_WB_FROM_CP0;
                            5'b00100: next_state = S_EX_TO_CP0;
                            default: next_state = (func == 6'b011000) ? S_EX_ERET : S_IF;
                        endcase
                    end
                    default: next_state = S_IF;
                endcase
            end
            S_EX_ALU: next_state = S_WB_ALU;
            S_WB_ALU: next_state = S_IF;
            S_EX_ADDR: next_state = (op[5:3] == 3'b100) ? S_MEM_READ : S_MEM_WRITE;
            S_MEM_READ: next_state = S_WB_LOAD;
            S_MEM_WRITE: next_state = S_IF;
            S_WB_LOAD: next_state = S_IF;
            S_EX_BRANCH: next_state = S_IF;
            S_EX_JUMP: next_state = S_IF;
            S_MDU_START: next_state = S_MDU_WAIT;
            S_MDU_WAIT: next_state = MDU_busy ? S_MDU_WAIT : S_MDU_DONE;
            S_MDU_DONE: next_state = S_IF;
            S_WB_FROM_HILO: next_state = S_IF;
            S_EX_TO_HILO: next_state = S_IF;
            S_EXCEPTION: next_state = S_IF;
            S_EX_TO_CP0: next_state = S_IF;
            S_WB_FROM_CP0: next_state = S_IF;
            S_EX_ERET: next_state = S_IF;
            default: next_state = S_IF;
        endcase
    end

    // 组合逻辑控制信号生成
    // PC_in: PC写使能
    assign PC_in = (state == S_WB_ALU) || (state == S_MEM_WRITE) || (state == S_WB_LOAD) || 
                   (state == S_EX_JUMP) || (state == S_EX_BRANCH) || (state == S_MDU_DONE) || 
                   (state == S_WB_FROM_HILO) || (state == S_EX_TO_HILO) || (state == S_WB_FROM_CP0) || 
                   (state == S_EX_TO_CP0) || (state == S_EX_ERET) || (state == S_EXCEPTION);

    // IR_in: 指令寄存器写使能
    assign IR_in = (state == S_IF);

    // ACC_in: ACC寄存器写使能
    assign ACC_in = (state == S_EX_ALU) || (state == S_EX_ADDR);

    // RsReg_in: Rs寄存器写使能
    assign RsReg_in = (state == S_ID);

    // RtReg_in: Rt寄存器写使能
    assign RtReg_in = (state == S_ID);

    // DM_r: 数据存储器读使能
    assign DM_r = (state == S_MEM_READ);

    // DM_w: 数据存储器写使能
    assign DM_w = (state == S_MEM_WRITE);

    // MDR_in: MDR寄存器写使能
    assign MDR_in = (state == S_MEM_READ);

    // Reg_in: 寄存器堆写使能
    assign Reg_in = (state == S_WB_ALU) || (state == S_WB_LOAD) || (state == S_WB_FROM_HILO) || 
                    (state == S_WB_FROM_CP0) || (state == S_EX_JUMP && (op == 6'b000011 || 
                    (op == 6'b000000 && func == 6'b001001)));

    // HI_w: HI寄存器写使能
    assign HI_w = (state == S_MDU_DONE) || (state == S_EX_TO_HILO && op == 6'b000000 && func == 6'b010001);

    // LO_w: LO寄存器写使能
    assign LO_w = (state == S_MDU_DONE) || (state == S_EX_TO_HILO && op == 6'b000000 && func == 6'b010011);

    // MDU_start: MDU启动信号
    assign MDU_start = (state == S_MDU_START);

    // mfc0: CP0读控制信号
    assign mfc0 = (state == S_ID && op == 6'b010000 && rs == 5'b00000) || 
                  (state == S_WB_FROM_CP0);

    // mtc0: CP0写控制信号
    assign mtc0 = (state == S_EX_TO_CP0);

    // eret: 异常返回信号
    assign eret = (state == S_EX_ERET);

    // exception: 异常信号
    assign exception = (state == S_EXCEPTION);

    // Latch_PC4_in_M4: PC4寄存器写使能
    assign Latch_PC4_in_M4 = (state == S_ID && (op == 6'b000011 || 
                             (op == 6'b000000 && func == 6'b001001)));

    // M1: 多路选择器M1控制信号
    assign M1 = (state == S_EX_ALU && op == 6'b000000 && 
                (func == 6'b000000 || func == 6'b000010 || func == 6'b000011));

    // M2: 多路选择器M2控制信号
    assign M2 = (state == S_WB_ALU && op != 6'b000000 && op != 6'b011100) || 
                (state == S_WB_LOAD) || (state == S_WB_FROM_CP0);

    // M3: 多路选择器M3控制信号
    assign M3 = (state == S_EX_ALU && op != 6'b000000 && op != 6'b011100) || 
                (state == S_EX_ADDR);

    // EXT_c: 扩展控制信号
    assign EXT_c = (state == S_EX_ALU && (op == 6'b001000 || op == 6'b001001 || 
                   op == 6'b001010 || op == 6'b001011)) || (state == S_EX_ADDR);

    // M6: 多路选择器M6控制信号
    assign M6 = (state == S_MDU_DONE) || (state == S_EX_TO_HILO && op == 6'b000000 && func == 6'b010001);

    // M7: 多路选择器M7控制信号
    assign M7 = (state == S_MDU_DONE) || (state == S_EX_TO_HILO && op == 6'b000000 && func == 6'b010011);

    // M4: 多路选择器M4控制信号 (3位)
    assign M4 = (state == S_WB_FROM_CP0) ? 3'b000 :  // CP0数据到寄存器
                (state == S_WB_FROM_HILO && op == 6'b000000 && func == 6'b010000) ? 3'b001 :  // HI到寄存器
                (state == S_WB_FROM_HILO && op == 6'b000000 && func == 6'b010010) ? 3'b010 :  // LO到寄存器
                (state == S_EX_JUMP && (op == 6'b000011 || (op == 6'b000000 && func == 6'b001001))) ? 3'b011 :  // PC+4到寄存器
                (state == S_WB_LOAD) ? 3'b100 :  // MDR到寄存器
                (state == S_WB_ALU) ? 3'b101 :   // ACC到寄存器
                3'b010;  // 默认值

    // M5: 多路选择器M5控制信号 (3位)
    assign M5 = (state == S_EX_JUMP && op == 6'b000000 && (func == 6'b001000 || func == 6'b001001)) ? 3'b000 :  // Rs寄存器值
                (state == S_EX_BRANCH && ((op == 6'b000100 && ZF) || (op == 6'b000101 && !ZF) || 
                 (op == 6'b000001 && rt == 5'b00001 && !SF))) ? 3'b001 :  // 分支跳转
                (state == S_EX_ERET || state == S_EXCEPTION) ? 3'b011 :  // 异常地址
                (state == S_EX_JUMP && (op == 6'b000010 || op == 6'b000011)) ? 3'b100 :  // 跳转地址
                3'b010;  // PC+4

    // ALUc: ALU控制信号 (4位)
    assign ALUc = (state == S_EX_ALU && op == 6'b000000 && func == 6'b100000) ? 4'b0010 :  // add
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100001) ? 4'b0000 :  // addu
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100010) ? 4'b0011 :  // sub
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100011) ? 4'b0001 :  // subu
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100100) ? 4'b0100 :  // and
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100101) ? 4'b0101 :  // or
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100110) ? 4'b0110 :  // xor
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b100111) ? 4'b0111 :  // nor
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b101010) ? 4'b1011 :  // slt
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b101011) ? 4'b1010 :  // sltu
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000000) ? 4'b1110 :  // sll
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000010) ? 4'b1101 :  // srl
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000011) ? 4'b1100 :  // sra
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000100) ? 4'b1110 :  // sllv
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000110) ? 4'b1101 :  // srlv
                  (state == S_EX_ALU && op == 6'b000000 && func == 6'b000111) ? 4'b1100 :  // srav
                  (state == S_EX_ALU && op == 6'b001000) ? 4'b0010 :  // addi
                  (state == S_EX_ALU && op == 6'b001001) ? 4'b0000 :  // addiu
                  (state == S_EX_ALU && op == 6'b001100) ? 4'b0100 :  // andi
                  (state == S_EX_ALU && op == 6'b001101) ? 4'b0101 :  // ori
                  (state == S_EX_ALU && op == 6'b001110) ? 4'b0110 :  // xori
                  (state == S_EX_ALU && op == 6'b001010) ? 4'b1011 :  // slti
                  (state == S_EX_ALU && op == 6'b001011) ? 4'b1010 :  // sltiu
                  (state == S_EX_ALU && op == 6'b001111) ? 4'b1000 :  // lui
                  (state == S_EX_ALU && op == 6'b011100 && func == 6'b100000) ? 4'b1111 :  // clz
                  (state == S_EX_ADDR) ? 4'b0000 :  // addu for address calculation
                  (state == S_EX_BRANCH && (op == 6'b000100 || op == 6'b000101)) ? 4'b0011 :  // sub for branch
                  (state == S_EX_BRANCH && op == 6'b000001) ? 4'b1001 :  // bgez
                  4'b0000;  // 默认值

    // MDUc: MDU控制信号 (2位)
    assign MDUc = (state == S_MDU_START && op == 6'b000000 && func == 6'b011000) ? 2'b00 :  // mult
                  (state == S_MDU_START && op == 6'b000000 && func == 6'b011001) ? 2'b01 :  // multu
                  (state == S_MDU_START && op == 6'b000000 && func == 6'b011010) ? 2'b10 :  // div
                  (state == S_MDU_START && op == 6'b000000 && func == 6'b011011) ? 2'b11 :  // divu
                  (state == S_MDU_WAIT && op == 6'b000000 && func == 6'b011000) ? 2'b00 :  // mult
                  (state == S_MDU_WAIT && op == 6'b000000 && func == 6'b011001) ? 2'b01 :  // multu
                  (state == S_MDU_WAIT && op == 6'b000000 && func == 6'b011010) ? 2'b10 :  // div
                  (state == S_MDU_WAIT && op == 6'b000000 && func == 6'b011011) ? 2'b11 :  // divu
                  2'b00;  // 默认值

    // byte_out_c: 字节输出控制信号 (3位)
    assign byte_out_c = (state == S_MEM_READ && op == 6'b100000) ? 3'b001 :  // lb
                        (state == S_MEM_READ && op == 6'b100100) ? 3'b010 :  // lbu
                        (state == S_MEM_READ && op == 6'b100001) ? 3'b011 :  // lh
                        (state == S_MEM_READ && op == 6'b100101) ? 3'b100 :  // lhu
                        (state == S_MEM_READ && op == 6'b100011) ? 3'b000 :  // lw
                        3'b000;  // 默认值

    // byte_in_ena: 字节输入使能信号 (4位)
    assign byte_in_ena = (state == S_MEM_WRITE && op == 6'b101011) ? 4'b1111 :  // sw
                         (state == S_MEM_WRITE && op == 6'b101001) ? 4'b0011 :  // sh
                         (state == S_MEM_WRITE && op == 6'b101000) ? 4'b0001 :  // sb
                         4'b0000;  // 默认值

    // cause: 异常原因码 (5位)
    assign cause = (state == S_EXCEPTION && op == 6'b000000 && func == 6'b001100) ? 5'b01000 :  // syscall
                   (state == S_EXCEPTION && op == 6'b000000 && func == 6'b001101) ? 5'b01001 :  // break
                   (state == S_EXCEPTION && op == 6'b000000 && func == 6'b110100) ? 5'b01101 :  // teq
                   5'b00000;  // 默认值

endmodule