module DMEM(
    input clk,
    input [31:0] addr,   // 访存地址
    input [31:0] data_in,   // 写入数据
    input we,               // 写使能
    input re,               // 读使能
    input [2:0] mem_op, // 访存类型: 000=LW, 001=LB, 010=LBU, 011=LH, 100=LHU, 101=SW, 110=SB, 111=SH
    output reg [31:0] data_out // 读出数据
);
    reg [31:0] mem [0:255];
    wire [7:0] word_addr = addr[9:2];
    wire [1:0] byte_off  = addr[1:0];

    // 读逻辑
    wire [31:0] mem_word = mem[word_addr];
    always @(*) begin
        if (re) begin
            case (mem_op)
                3'b000: data_out = mem_word; // LW
                3'b001: begin // LB
                    case (byte_off)
                        2'b00: data_out = {{24{mem_word[7]}},  mem_word[7:0]};
                        2'b01: data_out = {{24{mem_word[15]}}, mem_word[15:8]};
                        2'b10: data_out = {{24{mem_word[23]}}, mem_word[23:16]};
                        2'b11: data_out = {{24{mem_word[31]}}, mem_word[31:24]};
                    endcase
                end
                // ... 其他读逻辑保持原样 ...
                default: data_out = mem_word;
            endcase
        end else begin
            data_out = 32'b0;
        end
    end

    // 写逻辑
    always @(posedge clk) begin
        if (we) begin
            if (mem_op == 3'b101) begin // SW
                mem[word_addr] <= data_in;
            end
            else if (mem_op == 3'b110) begin // SB
                if (byte_off == 2'b00) mem[word_addr][7:0]   <= data_in[7:0];
                if (byte_off == 2'b01) mem[word_addr][15:8]  <= data_in[7:0];
                if (byte_off == 2'b10) mem[word_addr][23:16] <= data_in[7:0];
                if (byte_off == 2'b11) mem[word_addr][31:24] <= data_in[7:0];
            end
            else if (mem_op == 3'b111) begin // SH
                if (byte_off[1] == 1'b0) mem[word_addr][15:0]  <= data_in[15:0];
                if (byte_off[1] == 1'b1) mem[word_addr][31:16] <= data_in[15:0];
            end
        end
    end
endmodule