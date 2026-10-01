module wishbone_bus_if(
    input  wire        clk,    
    input  wire        rst, 
    
    // 来自 ctrl 模块 
    input  wire[5:0]              stall_i, 
    input  wire                   flush_i,     // 处理异常，需要清空流水线
    
    // CPU 侧的接口 
    input  wire                   cpu_ce_i,    // 来自处理器的访问请求信号
    input  wire[`RegBus]          cpu_data_i,  // 来自处理器的数据
    input  wire[`RegBus]          cpu_addr_i, 
    input  wire                   cpu_we_i, 
    input  wire[3:0]              cpu_sel_i, 
    output reg[`RegBus]           cpu_data_o,  // 输出到处理器的数据 
    
    // Wishbone 侧的接口 
    input  wire[`RegBus]          wishbone_data_i,  // Wishbone 总线输入的数据
    input  wire                   wishbone_ack_i, 
    output reg[`RegBus]           wishbone_addr_o, 
    output reg[`RegBus]           wishbone_data_o, 
    output reg                    wishbone_we_o, 
    output reg[3:0]               wishbone_sel_o, 
    output reg                    wishbone_stb_o,   // Wishbone 总线选通信号 
    output reg                    wishbone_cyc_o,   // Wishbone 总线周期信号 
    
    output reg                    stallreq  
);

    reg[1:0]     wishbone_state;   // 保存 Wishbone 总线接口模块的状态 
    reg[`RegBus] rd_buf;           // 寄存通过 Wishbone 总线访问到的数据 

/**************************************************************** 
***********          第一段：控制状态转化的时序电路         ********* 
*****************************************************************/ 

always @ (posedge clk) begin 
    if(rst == `RstEnable) begin 
        wishbone_state  <= `WB_IDLE;         // 进入 WB_IDLE 状态 
        wishbone_addr_o <= `ZeroWord; 
        wishbone_data_o <= `ZeroWord; 
        wishbone_we_o   <= `WriteDisable; 
        wishbone_sel_o  <= 4'b0000; 
        wishbone_stb_o  <= 1'b0;
        wishbone_cyc_o  <= 1'b0; 
        rd_buf          <= `ZeroWord; 
    end 
    else begin 
        case (wishbone_state) 
            `WB_IDLE: begin              // WB_IDLE 状态 
                if((cpu_ce_i == 1'b1) && (flush_i == `False_v)) begin 
                    wishbone_stb_o  <= 1'b1; 
                    wishbone_cyc_o  <= 1'b1; 
                    wishbone_addr_o <= cpu_addr_i; 
                    wishbone_data_o <= cpu_data_i; 
                    wishbone_we_o   <= cpu_we_i; 
                    wishbone_sel_o  <= cpu_sel_i; 
                    wishbone_state  <= `WB_BUSY;    // 进入 WB_BUSY 状态 
                    rd_buf          <= `ZeroWord; 
                end 
            end 
            `WB_BUSY: begin              // WB_BUSY 状态 
                if(wishbone_ack_i == 1'b1) begin    // 收到 Wishbone 总线的响应
                    wishbone_stb_o  <= 1'b0; 
                    wishbone_cyc_o  <= 1'b0; 
                    wishbone_addr_o <= `ZeroWord; 
                    wishbone_data_o <= `ZeroWord; 
                    wishbone_we_o   <= `WriteDisable; 
                    wishbone_sel_o  <= 4'b0000; 
                    wishbone_state  <= `WB_IDLE;     // 进入 WB_IDLE 状态 
                    if(cpu_we_i == `WriteDisable) begin  // 表示读操作
                        rd_buf <= wishbone_data_i;       // 将读到的数据保存到变量 rd_buf 中
                    end 
                    if(stall_i != 6'b000000) begin   // 流水线有部分暂停了
                    // 进入 WB_WAIT_FOR_STALL 状态 
                        wishbone_state <= `WB_WAIT_FOR_STALL; 
                    end      
                end 
                else if(flush_i == `True_v) begin    // 在还没有收到 Wishbone 总线的响应时，发生了异常
                    wishbone_stb_o  <= 1'b0; 
                    wishbone_cyc_o  <= 1'b0; 
                    wishbone_addr_o <= `ZeroWord; 
                    wishbone_data_o <= `ZeroWord; 
                    wishbone_we_o   <= `WriteDisable; 
                    wishbone_sel_o  <=  4'b0000; 
                    wishbone_state  <= `WB_IDLE;     // 进入 WB_IDLE 状态 
                    rd_buf          <= `ZeroWord; 
                end 
            end 
            `WB_WAIT_FOR_STALL:  begin    // WB_WAIT_FOR_STALL 状态 
                if(stall_i == 6'b000000) begin   // 流水线暂停结束
                    wishbone_state <= `WB_IDLE;   // 进入 WB_IDLE 状态 
                end 
            end 
            default: begin 
            end  
        endcase 
    end    // if 
end      // always

/**************************************************************** 
***********      第二段：给处理器接口信号赋值的组合电路      ********* 
*****************************************************************/ 
always @ (*) begin 
    if(rst == `RstEnable) begin 
        stallreq   <= `NoStop; 
        cpu_data_o <= `ZeroWord; 
    end 
    else begin 
        stallreq   <= `NoStop; 
        case (wishbone_state) 
            `WB_IDLE: begin         // WB_IDLE 状态 
                if((cpu_ce_i == 1'b1) && (flush_i == `False_v)) begin  // 处理器要访问总线，且没有处于流水线清除过程中
                    stallreq   <= `Stop;      // 暂停流水线以等待此次 Wishbone 总线访问结束
                    cpu_data_o <= `ZeroWord; 
                end 
            end 
            `WB_BUSY: begin         // WB_BUSY 状态 
                if(wishbone_ack_i == 1'b1) begin  // 收到 Wishbone 总线的响应
                    stallreq <= `NoStop;          // 流水线可以继续
                    if(wishbone_we_o == `WriteDisable) begin  // 读操作
                        cpu_data_o <= wishbone_data_i;  // 将 Wishbone 总线读到的数据传递给处理器
                    end 
                    else begin 
                        cpu_data_o <= `ZeroWord; 
                    end 
                end 
                else begin                        // 没有收到 Wishbone 总线的响应
                    stallreq   <= `Stop; 
                    cpu_data_o <= `ZeroWord;      // 此次访问还没有结束，流水线要保持暂停
                end 
            end 
            `WB_WAIT_FOR_STALL: begin  // WB_WAIT_FOR_STALL 状态 
                stallreq   <= `NoStop;            // Wishbone 总线访问已经结束
                cpu_data_o <= rd_buf; 
            end 
            default: begin 
            end  
        endcase 
    end 
end

endmodule
