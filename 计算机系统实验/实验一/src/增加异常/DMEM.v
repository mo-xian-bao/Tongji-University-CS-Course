module DMEM(
    input clk,
    input [31:0] addr,
    input [31:0] data_in,
    input [31:0] rt_old,
    input we,
    input re,
    input [3:0] mem_op,
    output reg [31:0] data_out
);
    reg [31:0] mem [0:255];
    wire [7:0] word_addr = addr[9:2];
    wire [1:0] byte_off  = addr[1:0];

    // ¶ÁÂß¼­
    wire [31:0] mem_word = mem[word_addr];
    always @(*) begin
        if (re) begin
            case (mem_op)
                4'b0000: data_out = mem_word; // LW/LL
                4'b0001: begin // LB
                    case (byte_off)
                        2'b00: data_out = {{24{mem_word[31]}}, mem_word[31:24]};
                        2'b01: data_out = {{24{mem_word[23]}}, mem_word[23:16]};
                        2'b10: data_out = {{24{mem_word[15]}}, mem_word[15:8]};
                        2'b11: data_out = {{24{mem_word[7]}},  mem_word[7:0]};
                    endcase
                end
                4'b0010: begin // LBU
                    case (byte_off)
                        2'b00: data_out = {24'b0, mem_word[31:24]};
                        2'b01: data_out = {24'b0, mem_word[23:16]};
                        2'b10: data_out = {24'b0, mem_word[15:8]};
                        2'b11: data_out = {24'b0, mem_word[7:0]};
                    endcase
                end
                4'b0011: begin // LH
                    case (byte_off[1])
                        1'b0: data_out = {{16{mem_word[31]}}, mem_word[31:16]};
                        1'b1: data_out = {{16{mem_word[15]}}, mem_word[15:0]};
                    endcase
                end
                4'b0100: begin // LHU
                    case (byte_off[1])
                        1'b0: data_out = {16'b0, mem_word[31:16]};
                        1'b1: data_out = {16'b0, mem_word[15:0]};
                    endcase
                end
                4'b0101: begin // LWL (big-endian)
                    case (byte_off)
                        2'b00: data_out = mem_word;
                        2'b01: data_out = {mem_word[23:0], rt_old[7:0]};
                        2'b10: data_out = {mem_word[15:0], rt_old[15:0]};
                        2'b11: data_out = {mem_word[7:0],  rt_old[23:0]};
                    endcase
                end
                4'b0110: begin // LWR (big-endian)
                    case (byte_off)
                        2'b00: data_out = {rt_old[31:8],  mem_word[31:24]};
                        2'b01: data_out = {rt_old[31:16], mem_word[31:16]};
                        2'b10: data_out = {rt_old[31:24], mem_word[31:8]};
                        2'b11: data_out = mem_word;
                    endcase
                end
                default: data_out = mem_word;
            endcase
        end else begin
            data_out = 32'b0;
        end
    end

    // Ð´Âß¼­
    always @(posedge clk) begin
        if (we) begin
            if (mem_op == 4'b1000) begin // SW/SC
                mem[word_addr] <= data_in;
            end
            else if (mem_op == 4'b1001) begin // SB
                if (byte_off == 2'b00) mem[word_addr][31:24] <= data_in[7:0];
                if (byte_off == 2'b01) mem[word_addr][23:16] <= data_in[7:0];
                if (byte_off == 2'b10) mem[word_addr][15:8]  <= data_in[7:0];
                if (byte_off == 2'b11) mem[word_addr][7:0]   <= data_in[7:0];
            end
            else if (mem_op == 4'b1010) begin // SH
                if (byte_off[1] == 1'b0) mem[word_addr][31:16] <= data_in[15:0];
                if (byte_off[1] == 1'b1) mem[word_addr][15:0]  <= data_in[15:0];
            end
            else if (mem_op == 4'b1011) begin // SWL (big-endian)
                case (byte_off)
                    2'b00: mem[word_addr]       <= data_in;
                    2'b01: mem[word_addr][23:0] <= data_in[31:8];
                    2'b10: mem[word_addr][15:0] <= data_in[31:16];
                    2'b11: mem[word_addr][7:0]  <= data_in[31:24];
                endcase
            end
            else if (mem_op == 4'b1100) begin // SWR (big-endian)
                case (byte_off)
                    2'b00: mem[word_addr][31:24] <= data_in[7:0];
                    2'b01: mem[word_addr][31:16] <= data_in[15:0];
                    2'b10: mem[word_addr][31:8]  <= data_in[23:0];
                    2'b11: mem[word_addr]        <= data_in;
                endcase
            end
        end
    end
endmodule