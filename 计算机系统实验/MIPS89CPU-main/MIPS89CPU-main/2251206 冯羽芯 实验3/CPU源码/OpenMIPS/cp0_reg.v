`include "defines.vh"

module cp0_reg(
       input wire                   clk, 
       input wire                   rst, 
       
       input wire                   we_i,          // 是否要写 CP0 中的寄存器 
       input wire[4:0]              waddr_i,       // 要写的 CP0 中寄存器的地址
       input wire[4:0]              raddr_i,       // 要读取的 CP0 中寄存器的地址
       input wire[`RegBus]          data_i,        // 要写入 CP0 中寄存器的数据
        
       input wire[5:0]              int_i,         // 6 个外部硬件中断输入
        
       input wire[31:0]             excepttype_i, 
       input wire[`RegBus]          current_inst_addr_i, 
       input wire                   is_in_delayslot_i, 
        
       output reg[`RegBus]          data_o,        // 读出的 CP0 中某个寄存器的值
       output reg[`RegBus]          count_o,       // Count 寄存器的值
       output reg[`RegBus]          compare_o,     // Compare 寄存器的值 
       output reg[`RegBus]          status_o,      // Status 寄存器的值
       output reg[`RegBus]          cause_o,       // Cause 寄存器的值
       output reg[`RegBus]          epc_o,         // EPC 寄存器的值
       output reg[`RegBus]          config_o,      // Config 寄存器的值
       output reg[`RegBus]          prid_o,        // PRId 寄存器的值
        
       output reg                   timer_int_o    // 是否有定时中断发生
    );
    
/**************************************************************** 
***********         第一段：对CP0中寄存器的写操作         ********* 
*****************************************************************/

always @ (posedge clk) begin 
    if(rst == `RstEnable) begin 
        // Count 寄存器的初始值，为 0
        count_o   <= `ZeroWord; 
        
        // Compare 寄存器的初始值，为 0 
        compare_o <= `ZeroWord; 
        
        // Status 寄存器的初始值，其中 CU 字段为 4'b0001，表示协处理器 CP0 存在 
        status_o  <= 32'b00010000000000000000000000000000; 
        
        // Cause 寄存器的初始值 
        cause_o   <= `ZeroWord; 
        
        // EPC 寄存器的初始值 
        epc_o     <= `ZeroWord; 
        
        // Config 寄存器的初始值，其中 BE 字段为 1，表示工作在大端模式（MSB） 
        config_o  <= 32'b00000000000000001000000000000000; 
        
        // PRId 寄存器的初始值，其中制作者是 L，对应的是 0x48（自行定义的） 
        // 类型是 0x1，表示是基本类型，版本号是 1.0 
        prid_o    <= 32'b00000000010011000000000100000010; 
        
        timer_int_o <= `InterruptNotAssert; 
 
    end
    else begin 
 
        count_o <= count_o + 1 ;   // Count 寄存器的值在每个时钟周期加 1 
        cause_o[15:10] <= int_i;   // Cause的第 10～15 bit 保存外部中断声明 
        
        // 当 Compare 寄存器不为 0，且 Count 寄存器的值等于 Compare 寄存器的值时， 
        // 将输出信号 timer_int_o 置为 1，表示时钟中断发生 
        if(compare_o != `ZeroWord && count_o == compare_o) begin 
            timer_int_o <= `InterruptAssert; 
        end 
 
        if(we_i == `WriteEnable) begin 
            case (waddr_i)  
                `CP0_REG_COUNT:  begin            // 写 Count 寄存器 
                    count_o     <= data_i;      
                end 
                `CP0_REG_COMPARE: begin           // 写 Compare 寄存器 
                    compare_o   <= data_i; 
                    timer_int_o <= `InterruptNotAssert; 
                end 
                `CP0_REG_STATUS:        begin     // 写 Status 寄存器 
                    status_o    <= data_i;
                end 
                `CP0_REG_EPC:        begin        // 写 EPC 寄存器 
                    epc_o       <= data_i; 
                end 
                `CP0_REG_CAUSE:        begin      // 写 Cause 寄存器 
                    // Cause 寄存器只有 IP[1:0]、IV、WP 字段是可写的 
                    cause_o[9:8] <= data_i[9:8]; 
                    cause_o[23]  <= data_i[23]; 
                    cause_o[22]  <= data_i[22]; 
                end 
            endcase 
        end
        case (excepttype_i) 
            32'h00000001: begin      // 外部中断 
                if(is_in_delayslot_i == `InDelaySlot ) begin 
                    epc_o       <= current_inst_addr_i - 4; 
                    cause_o[31] <= 1'b1;        // Cause 寄存器的 BD 字段 
                end 
                else begin 
                    epc_o       <= current_inst_addr_i; 
                    cause_o[31] <= 1'b0; 
                end 
                status_o[1]     <= 1'b1;         // Status 寄存器的 EXL 字段，关中断
                cause_o[6:2]    <= 5'b00000;     // Cause 寄存器的 ExcCode 字段 
            end
            32'h00000008: begin     // 系统调用异常 syscall 
                if(status_o[1] == 1'b0) begin 
                    if(is_in_delayslot_i == `InDelaySlot ) begin 
                        epc_o       <= current_inst_addr_i - 4; 
                        cause_o[31] <= 1'b1; 
                    end 
                    else begin 
                        epc_o       <= current_inst_addr_i; 
                        cause_o[31] <= 1'b0; 
                    end 
                end 
                status_o[1]  <= 1'b1; 
                cause_o[6:2] <= 5'b01000; 
            end
            32'h0000000a: begin     // 无效指令异常 
                if(status_o[1] == 1'b0) begin 
                    if(is_in_delayslot_i == `InDelaySlot ) begin 
                        epc_o       <= current_inst_addr_i - 4; 
                        cause_o[31] <= 1'b1; 
                    end 
                    else begin 
                        epc_o       <= current_inst_addr_i; 
                        cause_o[31] <= 1'b0; 
                    end 
                end 
                status_o[1]  <= 1'b1; 
                cause_o[6:2] <= 5'b01010; 
            end
            32'h0000000d: begin     // 自陷异常 
                if(status_o[1] == 1'b0) begin 
                    if(is_in_delayslot_i == `InDelaySlot ) begin 
                        epc_o       <= current_inst_addr_i - 4; 
                        cause_o[31] <= 1'b1; 
                    end 
                    else begin 
                        epc_o       <= current_inst_addr_i; 
                        cause_o[31] <= 1'b0; 
                    end 
                end 
                status_o[1]  <= 1'b1; 
                cause_o[6:2] <= 5'b01101; 
            end
            32'h0000000c: begin     // 溢出异常 
                if(status_o[1] == 1'b0) begin 
                    if(is_in_delayslot_i == `InDelaySlot ) begin 
                        epc_o       <= current_inst_addr_i - 4; 
                        cause_o[31] <= 1'b1; 
                    end 
                    else begin 
                        epc_o       <= current_inst_addr_i; 
                        cause_o[31] <= 1'b0; 
                    end 
                end 
                status_o[1]  <= 1'b1; 
                cause_o[6:2] <= 5'b01100; 
            end
            32'h0000000e: begin           // 异常返回指令 eret 
                status_o[1] <= 1'b0;      // 表示中断允许
            end
//            32'h00000009: begin           // 断点异常指令 break
//                if(status_o[1] == 1'b0) begin 
//                    if(is_in_delayslot_i == `InDelaySlot ) begin 
//                        epc_o       <= current_inst_addr_i - 4 ; 
//                        cause_o[31] <= 1'b1; 
//                    end 
//                    else begin 
//                        epc_o       <= current_inst_addr_i; 
//                        cause_o[31] <= 1'b0; 
//                    end 
//                end 
//                status_o[1]  <= 1'b1; 
//                cause_o[6:2] <= 5'b01001; 
//            end
        endcase
    end 
end

/**************************************************************** 
***********         第二段：对CP0中寄存器的读操作         ********* 
*****************************************************************/

always @ (*) begin 
    if(rst == `RstEnable) begin 
        data_o <= `ZeroWord; 
    end 
    else begin 
        case (raddr_i)  
            `CP0_REG_COUNT: begin      // 读 Count 寄存器 
                data_o <= count_o; 
            end 
            `CP0_REG_COMPARE: begin    // 读 Compare 寄存器 
                data_o <= compare_o; 
            end 
            `CP0_REG_STATUS: begin     // 读 Status 寄存器 
                data_o <= status_o; 
            end 
            `CP0_REG_CAUSE: begin      // 读 Cause 寄存器 
                data_o <= cause_o; 
            end 
            `CP0_REG_EPC: begin        // 读 EPC 寄存器 
                data_o <= epc_o; 
            end 
            `CP0_REG_PRId: begin       // 读 PRId 寄存器 
                data_o <= prid_o; 
            end 
            `CP0_REG_CONFIG: begin     // 读 Config 寄存器 
                data_o <= config_o; 
            end
            default: begin 
            end 
        endcase 
    end 
end 



endmodule
