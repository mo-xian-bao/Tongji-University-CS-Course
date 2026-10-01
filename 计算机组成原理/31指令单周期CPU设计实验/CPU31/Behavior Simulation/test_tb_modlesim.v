`timescale 1ns / 1ps
`include "../CPU.v"
`include "../CU.v"
`include "../RegFile.v"
`include "../ALU.v"
`include "../PC.v"
`include "../DMEM.v"
`include "../IMEM.v"
`include "../sccomp_dataflow.v"
module test_tb;

reg clk;            //时钟信号
reg rst;            //复位信号
wire [31:0] inst;   //要执行的指令
wire [31:0] pc;     //下一条指令的地址

reg [15:0] cnt;     //计数器,已经执行的指令数
integer file_open;  //文件句柄

// 初始化
initial begin
    clk = 0;
    rst = 1;
    #100 rst = 0;
    cnt = 0;
end

// 时钟信号
always #50 clk = ~clk;

// 实例化sccomp_dataflow模块
sccomp_dataflow top_inst(
    .clk_in(clk),
    .reset(rst),
    .inst(inst),
    .pc(pc)
);

endmodule