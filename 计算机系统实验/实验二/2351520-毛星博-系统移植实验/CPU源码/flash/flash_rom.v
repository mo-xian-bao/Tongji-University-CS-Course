`timescale 1ns / 1ps

// main two part: 1.spi flash control 2. wb main bus
module flash_rom(
    // Wishbone 总线接口
    input wire wb_clk_i,        // Wishbone 时钟
    input wire wb_rst_i,        // Wishbone 复位
    input wire wb_cyc_i,        // Wishbone 总线周期有效
    input wire wb_stb_i,        // Wishbone 选通信号
    input wire wb_we_i,         // Wishbone 写使能
    input wire [3:0] wb_sel_i,  // Wishbone 字节选择
    input wire [23:0] wb_adr_i, // Wishbone 地址
    input wire [31:0] wb_dat_i, // Wishbone 写数据
    output reg [31:0] wb_dat_o, // Wishbone 读数据
    output reg        wb_ack_o, // Wishbone 应答

    input wire flash_continue, // Flash 继续操作信号

    // SPI Flash 接口
    output reg cs_n,   // 片选信号，低有效
    input  sdi,        // SPI 数据输入（从 Flash 到 FPGA）
    output reg sdo,    // SPI 数据输出（从 FPGA 到 Flash）
    output reg wp_n,   // 写保护，低有效
    output reg hld_n   // 保持信号，低有效
    );


// 状态机状态定义
parameter IDLE       = 5'b00000;
parameter START      = 5'b00010;
parameter INST_OUT   = 5'b00011;
parameter ADDR1_OUT  = 5'b00100;
parameter ADDR2_OUT  = 5'b00101;
parameter ADDR3_OUT  = 5'b00110;
parameter WRITE_DATA = 5'b00111;
parameter READ_DATA  = 5'b01000;
parameter READ_DATA1 = 5'b01001;
parameter READ_DATA2 = 5'b01010;
parameter READ_DATA3 = 5'b01011;
parameter READ_DATA4 = 5'b01100;
parameter READ_DATA5 = 5'b01101;
parameter WAITING    = 5'b10000;
parameter ENDING     = 5'b10001;


// 初始化计数器
(* dont_touch = "true" *)reg[4:0] init_count;

// SPI 控制相关寄存器
(* dont_touch = "true" *)reg         sck;        // SPI 时钟
(* dont_touch = "true" *)reg  [4:0]  state;      // 当前状态
reg  [4:0]  next_state;                         // 下一个状态

(* dont_touch = "true" *)reg  [7:0]   instruction;   // SPI 指令
(* dont_touch = "true" *)reg  [7:0]   datain_shift;  // SPI 输入移位寄存器
(* dont_touch = "true" *)reg  [7:0]   datain;        // SPI 输入数据
(* dont_touch = "true" *)reg  [7:0]   dataout;       // SPI 输出数据
(* dont_touch = "true" *)reg          sck_en;        // SPI 时钟使能
(* dont_touch = "true" *)reg  [2:0]   sck_en_d;      // SPI 时钟使能延迟
(* dont_touch = "true" *)reg [10:0]   read_count;    // 读计数器
reg  [2:0]  cs_n_d;                                 // 片选信号延迟

reg         temp;                                   // 临时变量
(* dont_touch = "true" *)reg  [3:0]  sdo_count;     // SPI 输出计数
reg  [15:0] page_count;                             // 页计数
reg  [7:0]  wait_count;                             // 等待计数
(* dont_touch = "true" *)reg  [23:0] addr;          // 24 位地址
reg         wrh_rdl;                                // 写/读标志，1 为写，0 为读
reg         addr_req;                               // 地址请求标志
reg  [15:0] wr_cnt;                                 // 写字节数
reg  [15:0] rd_cnt;                                 // 读字节数
(* dont_touch = "true" *)reg [31:0] read_data;      // 读出的数据


// 状态机：Wishbone 接口与 SPI Flash控制
always @ (posedge wb_clk_i or posedge wb_rst_i) begin
    if(wb_rst_i) begin
        // 异步复位：所有关键寄存器初始化
        state      <= IDLE;        // 状态机回到 IDLE 空闲状态
        read_count <= 11'd0;       // 读计数清零
        wb_ack_o   <= 1'b0;        // Wishbone 应答信号清零
        init_count <= 5'd2;        // 初始化计数器
    end
    else if(wb_cyc_i & wb_stb_i) begin
        // Wishbone 总线有效时，状态机切换到下一个状态
        state <= next_state;
        // 如果当前处于 ENDING 状态且还未应答
        if(state == ENDING && !wb_ack_o) begin
            if(init_count > 5'd0) begin
                // 延迟一段时间后回到 IDLE，防止总线冲突
                init_count <= init_count - 5'd1;
                state      <= IDLE;
            end
            else 
                wb_ack_o   <= 1'b1; // 最终给出应答信号
        end
    end
    else begin
        // Wishbone 无效时，状态机回到 IDLE，应答信号清零
        state    <= IDLE;
        wb_ack_o <= 1'b0;
    end
end

// SPI 控制信号默认值设置
always @ (posedge wb_clk_i) begin
    // 每个时钟周期都将写保护和保持信号拉高（不使能）
    wp_n  <= 1'b1;
    hld_n <= 1'b1;
end


// 状态机主流程及各状态下寄存器赋值
always @ (posedge wb_clk_i or posedge wb_rst_i) begin
	if(wb_rst_i) begin
		// 异步复位：所有 SPI 相关寄存器初始化
        next_state  <= IDLE;      // 下一个状态为 IDLE
        sck_en      <= 1'b0;      // SPI 时钟禁止
        cs_n_d[0]   <= 1'b1;      // 片选拉高（不选中）
        dataout     <= 8'd0;      // SPI 输出数据清零
        sdo_count   <= 4'd0;      // SPI 输出计数清零
        sdo         <= 1'b0;      // SPI 输出数据线清零
        datain      <= 8'd0;      // SPI 输入数据清零
        addr        <=24'd0;      // 地址清零
        datain_shift<=8'd0;       // 输入移位寄存器清零
        temp        <= 1'b0;      // 临时变量清零
        page_count  <= 16'd0;     // 页计数清零
        wait_count  <= 8'd0;      // 等待计数清零
        read_data   <=32'd0;      // 读数据寄存器清零
        
	end
	else begin
		case(state)
		// 空闲状态，等待 flash_continue 信号拉高后进入 START
		IDLE: 
		begin
            wait_count <= 8'd0; // 等待计数清零
            if(flash_continue==1'd1)
                next_state<=START; // 检测到 flash_continue 信号，准备启动 SPI
            // 否则保持在 IDLE
        end
		
		START:
		// 启动状态，准备 SPI 通信，拉低 CS，加载地址
		begin
            addr       <= wb_adr_i;      // 保存 Wishbone 传入的 24 位地址
            sck_en     <= 1'b1;      // 使能 SPI 时钟
            cs_n_d[0]  <= 1'b0;  // 拉低片选，选中 Flash
            next_state <= INST_OUT; // 进入指令发送状态
            read_count <= read_count + 11'd1; // 读计数 +1
        end

		// 指令发送状态，将 8 位 SPI 指令逐位移出
        INST_OUT:
        begin
            // sdo_count == 1 时，加载指令到移位寄存器
            if(sdo_count == 4'd1) begin
                {sdo, dataout[6:0]} <= instruction;
            end
            // 其余奇数周期，移位输出
            else if(sdo_count[0]) begin
                {sdo, dataout[6:0]} <= {dataout[6:0], 1'b0};
            end

            // 发送满 16 个时钟（8 位数据 +8 个空时钟），结束
            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                sdo_count  <= 4'd0;
                // 判断是否需要发地址，还是直接进入数据阶段
                next_state <= (addr_req) ?  ADDR1_OUT : ((wrh_rdl) ? ((wr_cnt==16'd0) ? ENDING : WRITE_DATA) : ((rd_cnt==16'd0) ? ENDING : READ_DATA1));
            end
        end

		// 发送地址高 8 位
        ADDR1_OUT:
        begin
            if(sdo_count == 4'd1) begin
                {sdo, dataout[6:0]} <= addr[23:16];
            end
            else if(sdo_count[0]) begin
                {sdo, dataout[6:0]} <= {dataout[6:0],1'b0};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                sdo_count  <= 4'd0;
                next_state <= ADDR2_OUT; // 进入中 8 位地址发送
            end
        end

		// 发送地址中 8 位
        ADDR2_OUT:
        begin
            if(sdo_count == 4'd1) begin
                {sdo, dataout[6:0]} <= addr[15:8];
            end
            else if(sdo_count[0]) begin
                {sdo, dataout[6:0]} <= {dataout[6:0], 1'b0};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                sdo_count  <= 4'd0;
                next_state <= ADDR3_OUT; // 进入低 8 位地址发送
            end
        end

		// 发送地址低 8 位
        ADDR3_OUT:
        begin
            if(sdo_count == 4'd1) begin
                {sdo, dataout[6:0]} <= addr[7:0];
            end
            else if(sdo_count[0]) begin
                {sdo, dataout[6:0]} <= {dataout[6:0], 1'b0};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                sdo_count  <= 4'd0;
                // 判断是写还是读
                next_state <= (wrh_rdl) ? ((wr_cnt==16'd0) ? ENDING : WRITE_DATA) : ((rd_cnt==16'd0) ? ENDING : READ_DATA1);
                page_count <= 16'd0; // 页计数清零
            end
        end

		// 写数据状态（本例为测试数据 0x5A）
        WRITE_DATA:
        begin
            if(sdo_count == 4'd1) begin
                {sdo, dataout[6:0]} <= 8'h5A;
            end
            else if(sdo_count[0]) begin
                {sdo, dataout[6:0]} <= {dataout[6:0], 1'b0};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                // 判断是否写完所有数据
                next_state <= (page_count < (wr_cnt - 16'd1)) ? WRITE_DATA : ENDING;
            end
        end

		// 读数据第 1 字节（虚拟字节），移位接收
        READ_DATA1:
        begin
            // 偶数周期移位接收 sdi
            if(~sdo_count[0]) begin
                datain_shift <= {datain_shift[6:0], sdi};
            end
            // sdo_count == 1 时，锁存第 1 字节
            if(sdo_count == 4'd1) begin
                datain <= {datain_shift, sdi};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                next_state <= READ_DATA2; // 进入第 2 字节接收
            end
        end

        READ_DATA2: // 只有最新的 2 个比特是来自当前正在传输的 SPI 字节流的，其余 6 个比特是“陈旧”的
        begin
            if(~sdo_count[0]) begin
                datain_shift <= {datain_shift[6:0], sdi};
            end
            if(sdo_count == 4'd1) begin
                read_data[31:24] <= {datain_shift, sdi};
                datain<= {datain_shift, sdi};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                next_state <= READ_DATA3; // 进入第 3 字节接收
            end
        end

		// 读数据第 3 字节，存入 read_data[23:16]
        READ_DATA3:
        begin
            if(~sdo_count[0]) begin
                datain_shift <= {datain_shift[6:0],sdi};
            end
            if(sdo_count == 4'd1) begin
                read_data[23:16] <= {datain_shift, sdi};
                datain<= {datain_shift, sdi};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                next_state <=READ_DATA4; // 进入第 4 字节接收
            end
        end

		// 读数据第 4 字节，存入 read_data[15:8]
        READ_DATA4:
        begin
            if(~sdo_count[0]) begin
                datain_shift <= {datain_shift[6:0],sdi};
            end
            if(sdo_count == 4'd1) begin
                read_data[15:8] <= {datain_shift, sdi};
                datain<= {datain_shift, sdi};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                next_state <=READ_DATA5; // 进入第 5 字节接收
            end
        end

		// 读数据第 5 字节，存入 read_data[7:0]
        READ_DATA5:
        begin
            if(~sdo_count[0]) begin
                datain_shift <= {datain_shift[6:0],sdi};
            end
            if(sdo_count == 4'd1) begin
                read_data[7:0] <= {datain_shift, sdi};
                datain<= {datain_shift, sdi};
            end

            if(sdo_count != 4'd15) begin
                sdo_count <= sdo_count + 4'd1;
            end
            else begin
                page_count <= page_count + 16'd1;
                sdo_count  <= 4'd0;
                next_state <=WAITING; // 数据接收完毕，进入等待
            end
        end

		// 等待状态，关闭 SCK 和 CS，准备结束
        WAITING:
        begin
            sck_en <= 1'b0;      // 禁止 SPI 时钟
            cs_n_d[0] <= 1'b1;   // 拉高片选，释放 Flash
            sdo_count <= 4'd0;   // 输出计数清零
            next_state<=ENDING;  // 进入结束状态
        end

		// 结束状态，等待 Wishbone 应答
        ENDING:
        begin
            // 空，等待外部 always 块处理应答信号
        end
		endcase
	end
end

// SCK 生成器，产生 SPI 时钟信号
always @ (posedge wb_clk_i) begin
    // sck_en_d 是 sck_en 的打拍延迟，用于同步和边沿检测
    sck_en_d <= {sck_en_d[1:0], sck_en};
end

always @ (posedge wb_clk_i or posedge wb_rst_i) begin
    if(wb_rst_i) begin
        sck <= 1'b0; // 复位时 SPI 时钟拉低
    end
    // sck_en_d[2] & sck_en 为真时，翻转 sck，实现 SPI 时钟
    else if(sck_en_d[2] & sck_en) begin
        sck <= ~sck;
    end
    else begin
        sck <= 1'b0; // 其他情况保持低电平
    end
end

// 片选信号延迟处理，保证 SPI 时序稳定
always @ (posedge wb_clk_i or posedge wb_rst_i) begin
    if(wb_rst_i) begin
        {cs_n, cs_n_d[2:1]} <= 3'h7; // 复位时片选拉高（不选中）
    end
    else begin
        {cs_n, cs_n_d[2:1]} <= cs_n_d; // 片选信号移位，延迟输出
    end
end

// STARTUPE2 原语，用于将用户时钟（sck）输出到 SPI Flash 的 SCK 引脚
STARTUPE2
#(
.PROG_USR("FALSE"),
.SIM_CCLK_FREQ(10.0)
)
STARTUPE2_inst
(
  .CFGCLK     (),           // 未用
  .CFGMCLK    (),           // 未用
  .EOS        (),           // 未用
  .PREQ       (),           // 未用
  .CLK        (1'b0),       // 未用
  .GSR        (1'b0),       // 未用
  .GTS        (1'b0),       // 未用
  .KEYCLEARB  (1'b0),       // 未用
  .PACK       (1'b0),       // 未用
  .USRCCLKO   (sck),        // 用户 SPI 时钟输出
  .USRCCLKTS  (1'b0),       // 0 使能 CCLK 输出
  .USRDONEO   (1'b1),       // 1
  .USRDONETS  (1'b1)        // 1
);

// 指令与操作参数设置（本例为固定读指令）
always @ (posedge wb_clk_i) begin
    instruction <= 8'h03;    // 读指令（0x03）
    wrh_rdl     <= 1'b0;     // 读操作
    addr_req    <= 1'b1;     // 需要发送地址
    wr_cnt      <= 16'd0;    // 写字节数为0
    rd_cnt      <= 16'd4;    // 读4字节
end

// Wishbone 读数据输出
always @ (posedge wb_clk_i) begin
    wb_dat_o <= read_data;   // 将读取到的数据输出到 Wishbone 总线
end
 
endmodule