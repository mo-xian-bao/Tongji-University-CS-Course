module CPU(
    input clk, //时钟信号
    input rst, //复位信号
    input ena, //使能信号
    //和IMEM交互
    input [31:0] instruction, //指令
    output [31:0] im_addr, //指令地址
    //和DMEM交互
    input [31:0] dm_data_out, //数据输出
    output [31:0] dm_addr, //数据地址
    output [31:0] dm_data_in, //数据输入
    output dm_ena, //数据存储器使能
    output dm_we, //数据存储器写使能
    output dm_re //数据存储器读使能
);

// MUX outputs - Declared early to avoid undefined variable errors
wire [31:0] mux1_out;
wire [31:0] mux2_out;
wire [31:0] mux3_out;
wire [31:0] mux4_out;
wire [31:0] mux5_out;
wire [31:0] mux6_out;
wire [31:0] mux7_out;
wire [31:0] mux8_out;
wire [31:0] mux9_out;
wire [4:0] mux10_out;

//PC所需信号
wire [31:0] pc_addr_in;
assign pc_addr_in = mux1_out;
wire [31:0] pc_addr_out;

//ALU所需信号
wire [31:0] alu_input_a;
assign alu_input_a = mux3_out;
wire [31:0] alu_input_b;
assign alu_input_b = mux5_out;
wire [31:0] alu_result;
wire alu_zero_flag;
wire alu_carry_flag;
wire alu_negative_flag;
wire alu_overflow_flag;

//CU所需信号
wire [8:0] mux_control;
wire [1:0] mux10_control;
wire [3:0] alu_control;
wire ext1_control;
wire rf_write_enable;
wire dm_write_enable;
wire dm_read_enable;

//RF所需信号
wire [4:0] rf_write_address; //写入地址,R型指令写入Rd,I型指令写入Rt
assign rf_write_address = mux10_out;
wire [31:0] rf_rd; //读取数据
assign rf_rd = mux7_out;
wire [31:0] rf_rs; 
wire [31:0] rf_rt;

//MUX1
wire [31:0] cat_out = {pc_addr_out[31:28], instruction[25:0], 2'b00};
assign mux1_out = mux_control[0] ? cat_out : mux4_out;

//MUX2
assign mux2_out = mux_control[1] ? mux9_out : dm_data_out;

//MUX3
wire [31:0] ext5_out = {27'b0, instruction[10:6]};
assign mux3_out = mux_control[2] ? ext5_out : rf_rs;

//MUX4
assign mux4_out = mux_control[3] ? mux6_out : rf_rs;

//MUX5
assign mux5_out = mux_control[4] ? mux8_out : rf_rt;

//MUX6
wire [31:0] npc_out = pc_addr_out + 4;
wire [31:0] ext18_signed_out = {{14{instruction[15]}}, instruction[15:0], 2'b00};
assign mux6_out = mux_control[5] ? npc_out : npc_out + ext18_signed_out;

//MUX7
assign mux7_out = mux_control[6] ? pc_addr_out + 4 : mux2_out;

//MUX8
wire [31:0] ext16_signed_out = {{16{instruction[15]}}, instruction[15:0]};
wire [31:0] ext16_out = {16'b0, instruction[15:0]};
assign mux8_out = mux_control[7] ? ext16_signed_out : ext16_out;

//MUX9
wire [31:0] ext1_out = ext1_control ? {31'b0, alu_negative_flag} : {31'b0, alu_carry_flag};
assign mux9_out = mux_control[8] ? alu_result : ext1_out;

//MUX10
reg [4:0] mux10_out_reg;
always@(*) begin
    case(mux10_control)
        2'b00: mux10_out_reg = instruction[15:11];
        2'b01: mux10_out_reg = instruction[20:16];
        2'b10: mux10_out_reg = 5'b11111;
        default: mux10_out_reg = instruction[15:11];
    endcase
end
assign mux10_out = mux10_out_reg;

//实例化PC
PC CPU_PC(
    .clk(clk),
    .rst(rst),
    .ena(ena),
    .data_in(pc_addr_in),
    .data_out(pc_addr_out)
);
//实例化ALU
ALU CPU_ALU(
    .a(alu_input_a),
    .b(alu_input_b),
    .aluc(alu_control),
    .r(alu_result),
    .zero(alu_zero_flag),
    .carry(alu_carry_flag),
    .negative(alu_negative_flag),
    .overflow(alu_overflow_flag)
);
//实例化CU
CU CPU_CU(
    .inst(instruction),
    .ZF(alu_zero_flag),
    .muxc(mux_control),
    .mux10c(mux10_control),
    .aluc(alu_control),
    .EXT1_C(ext1_control),
    .RF_W(rf_write_enable),
    .DM_W(dm_write_enable),
    .DM_R(dm_read_enable)
);
//实例化RF
RegFile cpu_ref(
    .clk(clk),
    .rst(rst),
    .ena(ena),
    .we(rf_write_enable),
    .Rsc(instruction[25:21]), 
    .Rtc(instruction[20:16]),
    .Rdc(rf_write_address), 
    .Rd(rf_rd),
    .Rs(rf_rs),
    .Rt(rf_rt)
);

//IMEM和DMEM在顶层文件sccomp_dataflow.v中实例化，和CPU连接
assign im_addr = pc_addr_out;              // 指令地址连接到PC
assign dm_addr = alu_result;               // 数据地址连接到ALU结果
assign dm_data_in = rf_rt;                 // 数据输入连接到rt寄存器值
assign dm_ena = dm_write_enable | dm_read_enable;  // 数据存储器使能
assign dm_we = dm_write_enable;            // 写使能直接连接
assign dm_re = dm_read_enable;             // 读使能直接连接

endmodule

