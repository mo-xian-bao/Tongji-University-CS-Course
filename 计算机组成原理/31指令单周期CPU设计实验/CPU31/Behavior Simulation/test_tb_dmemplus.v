`timescale 1ns / 1ps
module test_tb;

reg clk;            //时钟信号
reg rst;            //复位信号
wire [31:0] inst;   //要执行的指令
wire [31:0] pc;     //下一条指令的地址

reg [15:0] cnt;     //计数器,已经执行的指令数
integer file_open;  //文件句柄
integer dm_i;       // 用于遍历 dmem 内存索引

// 初始化
initial begin
    clk = 0;
    rst = 1;
    #50 rst = 0;
    cnt = 0;
    // 创建新文件（清空原有内容）
    file_open = $fopen("D:\\desktop\\Mars4_5 导出十六进制文件及结果比对说明\\output.txt", "w");
    $fclose(file_open);
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

// 停止仿真
always @(posedge clk) begin
    if (cnt >= 200) begin
        $finish;
    end
end

always @(negedge clk) begin
    cnt = cnt + 1;
    file_open = $fopen("D:\\desktop\\Mars4_5 导出十六进制文件及结果比对说明\\output.txt", "a+");
    
    // 按照MARS格式输出
    $fdisplay(file_open, "pc: %08h", top_inst.pc);
    $fdisplay(file_open, "instr: %08h", top_inst.inst);
    $fdisplay(file_open, "regfile0: %08h", top_inst.cpu_inst.CPU_RF.regs[0]);
    $fdisplay(file_open, "regfile1: %08h", top_inst.cpu_inst.CPU_RF.regs[1]);
    $fdisplay(file_open, "regfile2: %08h", top_inst.cpu_inst.CPU_RF.regs[2]);
    $fdisplay(file_open, "regfile3: %08h", top_inst.cpu_inst.CPU_RF.regs[3]); 
    $fdisplay(file_open, "regfile4: %08h", top_inst.cpu_inst.CPU_RF.regs[4]);
    $fdisplay(file_open, "regfile5: %08h", top_inst.cpu_inst.CPU_RF.regs[5]);
    $fdisplay(file_open, "regfile6: %08h", top_inst.cpu_inst.CPU_RF.regs[6]);
    $fdisplay(file_open, "regfile7: %08h", top_inst.cpu_inst.CPU_RF.regs[7]);
    $fdisplay(file_open, "regfile8: %08h", top_inst.cpu_inst.CPU_RF.regs[8]);
    $fdisplay(file_open, "regfile9: %08h", top_inst.cpu_inst.CPU_RF.regs[9]);
    $fdisplay(file_open, "regfile10: %08h", top_inst.cpu_inst.CPU_RF.regs[10]);
    $fdisplay(file_open, "regfile11: %08h", top_inst.cpu_inst.CPU_RF.regs[11]);
    $fdisplay(file_open, "regfile12: %08h", top_inst.cpu_inst.CPU_RF.regs[12]);
    $fdisplay(file_open, "regfile13: %08h", top_inst.cpu_inst.CPU_RF.regs[13]);
    $fdisplay(file_open, "regfile14: %08h", top_inst.cpu_inst.CPU_RF.regs[14]);
    $fdisplay(file_open, "regfile15: %08h", top_inst.cpu_inst.CPU_RF.regs[15]);
    $fdisplay(file_open, "regfile16: %08h", top_inst.cpu_inst.CPU_RF.regs[16]);
    $fdisplay(file_open, "regfile17: %08h", top_inst.cpu_inst.CPU_RF.regs[17]);
    $fdisplay(file_open, "regfile18: %08h", top_inst.cpu_inst.CPU_RF.regs[18]);
    $fdisplay(file_open, "regfile19: %08h", top_inst.cpu_inst.CPU_RF.regs[19]);
    $fdisplay(file_open, "regfile20: %08h", top_inst.cpu_inst.CPU_RF.regs[20]);
    $fdisplay(file_open, "regfile21: %08h", top_inst.cpu_inst.CPU_RF.regs[21]);
    $fdisplay(file_open, "regfile22: %08h", top_inst.cpu_inst.CPU_RF.regs[22]);
    $fdisplay(file_open, "regfile23: %08h", top_inst.cpu_inst.CPU_RF.regs[23]);
    $fdisplay(file_open, "regfile24: %08h", top_inst.cpu_inst.CPU_RF.regs[24]);
    $fdisplay(file_open, "regfile25: %08h", top_inst.cpu_inst.CPU_RF.regs[25]);
    $fdisplay(file_open, "regfile26: %08h", top_inst.cpu_inst.CPU_RF.regs[26]);
    $fdisplay(file_open, "regfile27: %08h", top_inst.cpu_inst.CPU_RF.regs[27]);
    $fdisplay(file_open, "regfile28: %08h", top_inst.cpu_inst.CPU_RF.regs[28]);
    $fdisplay(file_open, "regfile29: %08h", top_inst.cpu_inst.CPU_RF.regs[29]);
    $fdisplay(file_open, "regfile30: %08h", top_inst.cpu_inst.CPU_RF.regs[30]);
    $fdisplay(file_open, "regfile31: %08h", top_inst.cpu_inst.CPU_RF.regs[31]);
    
    // 输出数据存储器内容
    for (dm_i = 0; dm_i < 32; dm_i = dm_i + 1) begin
        $fdisplay(file_open, "dmem[%0d]: %08h", dm_i, top_inst.dmem_inst.mem[dm_i]);
    end
    
    $fclose(file_open);
end

endmodule