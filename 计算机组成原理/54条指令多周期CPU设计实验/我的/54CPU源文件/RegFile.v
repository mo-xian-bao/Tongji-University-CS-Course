module RegFile(
    input clk,
    input rst,
    input we, // 写使能信号
    input [4:0] Rdc,    
    input [4:0] Rsc,    
    input [4:0] Rtc,    
    input [31:0] Rd,     
    output [31:0] Rs,   
    output [31:0] Rt    
);

    // 内部32个32位寄存器阵列
    reg [31:0] array_reg [31:0];
    
    // 声明循环变量
    integer i;

    // -- 异步读 --
    assign Rs = (Rsc == 5'b0) ? 32'h00000000 : array_reg[Rsc];
    assign Rt = (Rtc == 5'b0) ? 32'h00000000 : array_reg[Rtc];

    // -- 同步写 --
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                array_reg[i] <= 32'h0;
            end
        end 
        // 写入
        else if (we && (Rdc != 5'b0)) begin
            // 当写使能有效，且目标地址不为0时，在时钟沿写入数据
            array_reg[Rdc] <= Rd;
        end
    end

endmodule