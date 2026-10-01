`include "defines.vh"

module ctrl( 
    input wire          rst, 
    input wire          stallreq_from_id,   // 来自译码阶段的暂停请求 
    input wire          stallreq_from_ex,   // 来自执行阶段的暂停请求 
    input wire          stallreq_from_if,   // 来自取指阶段的暂停请求
    input wire          stallreq_from_mem,  // 来自访存阶段的暂停请求
    
    // 来自 MEM
    input wire[31:0]    excepttype_i,
    input wire[`RegBus] cp0_epc_i,
    
    output reg[`RegBus] new_pc,             // 异常处理入口地址 
    output reg          flush,              // 是否清除流水线 
    
    output reg[5:0]     stall             
);

always @ (*) begin 
    if(rst == `RstEnable) begin 
        stall  <= 6'b000000; 
        flush  <= 1'b0; 
        new_pc <= `ZeroWord;
    end 
    else if(excepttype_i != `ZeroWord) begin  // 不为 0，表示发生异常
        flush  <= 1'b1; 
        stall  <= 6'b000000;
        case (excepttype_i)
            32'h00000001: begin              // 中断 
                new_pc <= 32'h00000020; 
            end
            32'h00000008: begin              // 系统调用异常 syscall 
                new_pc <= 32'h00400004;      // 中断例程地址 （MARS）
            end
            32'h0000000a: begin              // 无效指令异常 
                new_pc <= 32'h00400004; 
            end 
            32'h0000000d: begin              // 自陷异常 
                new_pc <= 32'h00400004; 
            end 
            32'h0000000c: begin              // 溢出异常 
                new_pc <= 32'h00400004; 
            end 
            32'h0000000e: begin              // 异常返回指令 eret 
                new_pc <= cp0_epc_i; 
            end 
            32'h00000009: begin              // 断点异常指令 break
                new_pc <= 32'h00400004;      // 自定义
            end
            default: begin 
            end
        endcase
    end
    else if(stallreq_from_mem == `Stop) begin
        stall <= 6'b011111;
        flush <= 1'b0;
    end
    else if(stallreq_from_ex == `Stop) begin 
        stall <= 6'b001111; 
        flush <= 1'b0;
    end 
    else if(stallreq_from_id == `Stop) begin 
        stall <= 6'b000111; 
        flush <= 1'b0;
    end 
    else if(stallreq_from_if == `Stop) begin
        stall <= 6'b000111;  // 译码阶段也暂停，保持了转移指令与延迟槽指令在流水线中的相对位置，从而能够正确识别出延迟槽指令
        flush <= 1'b0;       // 否则，填充的空指令被误认为是延迟槽指令
    end
    else begin 
        stall  <= 6'b000000; 
        flush  <= 1'b0;
        new_pc <= `ZeroWord;
    end 
end

// stall[0] 表示取指地址 PC 是否保持不变，为 1 表示保持不变。 
// stall[1] 表示流水线取指阶段是否暂停，为 1 表示暂停。 
// stall[2] 表示流水线译码阶段是否暂停，为 1 表示暂停。 
// stall[3] 表示流水线执行阶段是否暂停，为 1 表示暂停。 
// stall[4] 表示流水线访存阶段是否暂停，为 1 表示暂停。 
// stall[5] 表示流水线回写阶段是否暂停，为 1 表示暂停。

endmodule