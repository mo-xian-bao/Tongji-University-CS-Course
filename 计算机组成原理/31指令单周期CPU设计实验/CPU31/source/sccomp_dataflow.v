// 顶层模块，连接CPU和IMEM、DMEM
module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst, // 指令输出
    output [31:0] pc    // PC值输出
);

// 内部连线声明
wire [31:0] cpu_imem_addr;    // CPU到IMEM的地址
wire [31:0] imem_cpu_instr;   // IMEM到CPU的指令
wire [31:0] cpu_dmem_addr;    // CPU到DMEM的地址
wire [31:0] dmem_addr; 
assign dmem_addr = cpu_dmem_addr - 32'h10010000; // 数据存储器地址偏移
wire [31:0] cpu_dmem_data_in; // CPU到DMEM的写数据
wire [31:0] dmem_cpu_data_out;// DMEM到CPU的读数据
wire cpu_dmem_ena;            // CPU到DMEM的使能信号
wire cpu_dmem_we;             // CPU到DMEM的写使能信号
wire cpu_dmem_re;             // CPU到DMEM的读使能信号

//CPU实例化
CPU sccpu(
    .clk(clk_in),
    .rst(reset),
    .ena(1'b1), // 默认使能
    // IMEM连接
    .instruction(imem_cpu_instr),
    .im_addr(cpu_imem_addr),
    // DMEM连接
    .dm_data_out(dmem_cpu_data_out),
    .dm_addr(cpu_dmem_addr),
    .dm_data_in(cpu_dmem_data_in),
    .dm_ena(cpu_dmem_ena),
    .dm_we(cpu_dmem_we),
    .dm_re(cpu_dmem_re)
);

//IMEM实例化
IMEM imem_inst(
    .PC(cpu_imem_addr),        // 程序计数器
    .Instr(imem_cpu_instr)     // 指令输出
);

//DMEM实例化
DMEM dmem_inst(
    .clk(clk_in),
    .ena(cpu_dmem_ena),        // 数据存储器使能
    .we(cpu_dmem_we),          // 写使能
    .re(cpu_dmem_re),          // 读使能
    .addr(dmem_addr[12:2]), // 11位地址，用于寻址
    .data_in(cpu_dmem_data_in), // 数据输入
    .data_out(dmem_cpu_data_out) // 数据输出
);

// 连接输出信号到顶层接口
assign pc = cpu_imem_addr;     // PC值输出
assign inst = imem_cpu_instr;  // 指令输出

endmodule


