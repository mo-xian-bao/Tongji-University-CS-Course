// 将16位立即数进行符号扩展或零扩展到32位
module Extender(
    input  [15:0] data_in,      // 16位立即数输入, 来自IR[15:0]
    input         extc,         // 扩展方式控制信号 (0=零扩展, 1=符号扩展)
    output [31:0] data_out      // 32位扩展后的数据输出
    );

    assign data_out = extc ? {{16{data_in[15]}}, data_in} : {16'h0000, data_in};

endmodule