module IMEM(
    input [31:0] PC,
    output [31:0] Instr
);

wire [10:0] PC_addr; // 11位指令码地址
assign PC_addr = (PC - 32'h00400000) >> 2; // 先减去基地址，再右移2位得到字地址

// 实例化IP核，输入指令码地址返回对应的指令
dist_mem_gen_0 Instr_mem(
    .a(PC_addr),
    .spo(Instr)
);

endmodule