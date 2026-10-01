// 顶层模块，连接CPU和IMEM、DMEM
module sccomp_dataflow(
    input clk_in,       //时钟信号
    input reset,        //复位信号
    output [7:0]  o_seg,//输出内容
    output [7:0]  o_sel //片选信号
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
wire clk_out;                 // 分频后的时钟信号

//CPU实例化
CPU sccpu(
    .clk(clk_out), // 使用分频后的时钟
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

//七段数码管
seg7x16 seg7x16_inst(
    .clk(clk_out), // <--- 使用分频后的时钟
    .reset(reset),
    .cs(1'b1),
    .i_data(imem_cpu_instr), 
    .o_seg(o_seg),
    .o_sel(o_sel)
    );

// 分频器
Divider divider_inst(
    .clk(clk_in),
    .rst(reset),
    .clk_out(clk_out)
);


endmodule


