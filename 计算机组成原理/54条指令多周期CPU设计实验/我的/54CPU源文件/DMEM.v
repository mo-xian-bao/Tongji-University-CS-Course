module DMEM_with_LDP(
    input clk,
    input rst,
    input MemRead,
    input MemWrite,
    input [3:0] byte_in_ena,
    input [31:0] addr,
    input [31:0] data_in,
    input [2:0]  byte_out_c,
    output reg [31:0] data_out
);
    // 定义操作码
    localparam [2:0] LW_OP  = 3'b000; //全字读
    localparam [2:0] LB_OP  = 3'b001; //字节读（带符号扩展）
    localparam [2:0] LBU_OP = 3'b010; //字节读（无符号扩展）
    localparam [2:0] LH_OP  = 3'b011; //半字读（带符号扩展）
    localparam [2:0] LHU_OP = 3'b100; //半字读（无符号扩展）

    // 内部存储阵列
    reg [31:0] mem [2047:0]; 
    
    // -- 写 --
    always @(posedge clk) begin
        if (MemWrite) begin
            if (byte_in_ena[0]) mem[addr[12:2]][7:0]   <= data_in[7:0];
            if (byte_in_ena[1]) mem[addr[12:2]][15:8]  <= data_in[15:8];
            if (byte_in_ena[2]) mem[addr[12:2]][23:16] <= data_in[23:16];
            if (byte_in_ena[3]) mem[addr[12:2]][31:24] <= data_in[31:24];
        end
    end
   // -- 读 --
    wire [31:0] raw_mem_data = mem[addr[12:2]]; //从内存阵列中读取原始的32位字

    always @(*) begin
        if (!MemRead) begin
            data_out = 32'h00000000; // 如果不读，输出0
        end 
        else begin
            case (byte_out_c)
                LW_OP: data_out = raw_mem_data;
                LB_OP: begin
                    case (addr[1:0])
                        2'b00: data_out = {{24{raw_mem_data[7]}}, raw_mem_data[7:0]};
                        2'b01: data_out = {{24{raw_mem_data[15]}}, raw_mem_data[15:8]};
                        2'b10: data_out = {{24{raw_mem_data[23]}}, raw_mem_data[23:16]};
                        2'b11: data_out = {{24{raw_mem_data[31]}}, raw_mem_data[31:24]};
                        default: data_out = 32'h00000000;
                    endcase
                end
                LBU_OP: begin
                    case (addr[1:0])
                        2'b00: data_out = {24'b0, raw_mem_data[7:0]};
                        2'b01: data_out = {24'b0, raw_mem_data[15:8]};
                        2'b10: data_out = {24'b0, raw_mem_data[23:16]};
                        2'b11: data_out = {24'b0, raw_mem_data[31:24]};
                        default: data_out = 32'h00000000;
                    endcase
                end
                LH_OP: begin
                    case (addr[1])
                        1'b0: data_out = {{16{raw_mem_data[15]}}, raw_mem_data[15:0]};
                        1'b1: data_out = {{16{raw_mem_data[31]}}, raw_mem_data[31:16]};
                        default: data_out = 32'h00000000;
                    endcase
                end
                LHU_OP: begin
                    case (addr[1])
                        1'b0: data_out = {16'b0, raw_mem_data[15:0]};
                        1'b1: data_out = {16'b0, raw_mem_data[31:16]};
                        default: data_out = 32'h00000000;
                    endcase
                end
                default: data_out = raw_mem_data; // 默认按lw处理或输出X
            endcase
        end
    end

endmodule