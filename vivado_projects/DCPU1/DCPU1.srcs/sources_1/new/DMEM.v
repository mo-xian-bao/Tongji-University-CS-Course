`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: DMEM
// Description: 数据存储器 - 支持字节/半字/字访问
//              1024字节存储空间
//////////////////////////////////////////////////////////////////////////////////

module DMEM(
    input clk,
    input [31:0] addr,          // 字节地址
    input [31:0] data_in,       // 写入数据
    input we,                   // 写使能
    input re,                   // 读使能
    input [2:0] mem_op,         // 访存类型: 000=LW, 001=LB, 010=LBU, 011=LH, 100=LHU, 101=SW, 110=SB, 111=SH
    output reg [31:0] data_out  // 读出数据
);

    // 存储器: 1024字节 = 256个字
    reg [31:0] mem [0:255];
    
    // 地址解析
    wire [7:0] word_addr = addr[9:2];   // 字地址
    wire [1:0] byte_off  = addr[1:0];   // 字节偏移
    
    // 读取的原始字
    wire [31:0] mem_word = mem[word_addr];
    
    // 异步读取 - 根据访存类型处理
    always @(*) begin
        if (re) begin
            case (mem_op)
                3'b000: data_out = mem_word;  // LW
                3'b001: begin  // LB (符号扩展)
                    case (byte_off)
                        2'b00: data_out = {{24{mem_word[7]}},  mem_word[7:0]};
                        2'b01: data_out = {{24{mem_word[15]}}, mem_word[15:8]};
                        2'b10: data_out = {{24{mem_word[23]}}, mem_word[23:16]};
                        2'b11: data_out = {{24{mem_word[31]}}, mem_word[31:24]};
                    endcase
                end
                3'b010: begin  // LBU (零扩展)
                    case (byte_off)
                        2'b00: data_out = {24'b0, mem_word[7:0]};
                        2'b01: data_out = {24'b0, mem_word[15:8]};
                        2'b10: data_out = {24'b0, mem_word[23:16]};
                        2'b11: data_out = {24'b0, mem_word[31:24]};
                    endcase
                end
                3'b011: begin  // LH (符号扩展)
                    case (byte_off[1])
                        1'b0: data_out = {{16{mem_word[15]}}, mem_word[15:0]};
                        1'b1: data_out = {{16{mem_word[31]}}, mem_word[31:16]};
                    endcase
                end
                3'b100: begin  // LHU (零扩展)
                    case (byte_off[1])
                        1'b0: data_out = {16'b0, mem_word[15:0]};
                        1'b1: data_out = {16'b0, mem_word[31:16]};
                    endcase
                end
                default: data_out = mem_word;
            endcase
        end else begin
            data_out = 32'b0;
        end
    end
    
    // 同步写入
    always @(posedge clk) begin
        if (we) begin
            case (mem_op)
                3'b101: mem[word_addr] <= data_in;  // SW
                3'b110: begin  // SB
                    case (byte_off)
                        2'b00: mem[word_addr][7:0]   <= data_in[7:0];
                        2'b01: mem[word_addr][15:8]  <= data_in[7:0];
                        2'b10: mem[word_addr][23:16] <= data_in[7:0];
                        2'b11: mem[word_addr][31:24] <= data_in[7:0];
                    endcase
                end
                3'b111: begin  // SH
                    case (byte_off[1])
                        1'b0: mem[word_addr][15:0]  <= data_in[15:0];
                        1'b1: mem[word_addr][31:16] <= data_in[15:0];
                    endcase
                end
                default: mem[word_addr] <= data_in;
            endcase
        end
    end
    
    // 初始化
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
    end

endmodule
