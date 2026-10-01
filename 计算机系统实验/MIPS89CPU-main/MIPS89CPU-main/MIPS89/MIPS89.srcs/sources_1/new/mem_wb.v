`include "defines.vh"

module mem_wb( 
    input wire              clk, 
    input wire              rst, 
    
    // 访存阶段的结果 
    input wire[`RegAddrBus] mem_wd, 
    input wire              mem_wreg, 
    input wire[`RegBus]     mem_wdata, 
    input wire[`RegBus]     mem_hi, 
    input wire[`RegBus]     mem_lo, 
    input wire              mem_whilo, 
    
    input wire[5:0]         stall,       // 来自控制模块的信息
    
    input wire              flush,       // 流水线清除信号
    
    input wire              mem_LLbit_we,     // 访存阶段的指令是否要写 LLbit 寄存器
    input wire              mem_LLbit_value,  // 访存阶段的指令要写入 LLbit 寄存器的值
    
    input wire              mem_cp0_reg_we, 
    input wire[4:0]         mem_cp0_reg_write_addr, 
    input wire[`RegBus]     mem_cp0_reg_data,
    
    // 送到回写阶段的信息 
    output reg[`RegAddrBus] wb_wd, 
    output reg              wb_wreg, 
    output reg[`RegBus]     wb_wdata,
    output reg[`RegBus]     wb_hi, 
    output reg[`RegBus]     wb_lo, 
    output reg              wb_whilo,
    
    output reg              wb_LLbit_we,       // 回写阶段的指令是否要写 LLbit 寄存器
    output reg              wb_LLbit_value,    // 回写阶段的指令要写入 LLbit 寄存器的值
    
    output reg              wb_cp0_reg_we, 
    output reg[4:0]         wb_cp0_reg_write_addr, 
    output reg[`RegBus]     wb_cp0_reg_data
); 
 
always @ (posedge clk) begin 
    if(rst == `RstEnable) begin 
        wb_wd    <= `NOPRegAddr; 
        wb_wreg  <= `WriteDisable; 
        wb_wdata <= `ZeroWord;
        wb_hi    <= `ZeroWord; 
        wb_lo    <= `ZeroWord; 
        wb_whilo <= `WriteDisable;
        wb_LLbit_we    <= 1'b0; 
        wb_LLbit_value <= 1'b0;
        wb_cp0_reg_we         <= `WriteDisable; 
        wb_cp0_reg_write_addr <= 5'b00000; 
        wb_cp0_reg_data       <= `ZeroWord;
    end 
    else if(flush == 1'b1) begin
        wb_wd                 <= `NOPRegAddr; 
        wb_wreg               <= `WriteDisable; 
        wb_wdata              <= `ZeroWord;
        wb_hi                 <= `ZeroWord; 
        wb_lo                 <= `ZeroWord; 
        wb_whilo              <= `WriteDisable; 
        wb_LLbit_we           <= 1'b0; 
        wb_LLbit_value        <= 1'b0;        
        wb_cp0_reg_we         <= `WriteDisable; 
        wb_cp0_reg_write_addr <= 5'b00000; 
        wb_cp0_reg_data       <= `ZeroWord;
    end
    else if(stall[4] == `Stop && stall[5] == `NoStop) begin
        wb_wd    <= `NOPRegAddr; 
        wb_wreg  <= `WriteDisable; 
        wb_wdata <= `ZeroWord;
        wb_hi    <= `ZeroWord; 
        wb_lo    <= `ZeroWord; 
        wb_whilo <= `WriteDisable;
        wb_LLbit_we    <= 1'b0; 
        wb_LLbit_value <= 1'b0;
        wb_cp0_reg_we         <= `WriteDisable; 
        wb_cp0_reg_write_addr <= 5'b00000; 
        wb_cp0_reg_data       <= `ZeroWord;
    end
    else if (stall[4] ==`NoStop) begin 
        wb_wd    <= mem_wd; 
        wb_wreg  <= mem_wreg; 
        wb_wdata <= mem_wdata;
        wb_hi    <= mem_hi; 
        wb_lo    <= mem_lo; 
        wb_whilo <= mem_whilo;
        wb_LLbit_we    <= mem_LLbit_we; 
        wb_LLbit_value <= mem_LLbit_value;
        // 在访存阶段没有暂停时，将对 CP0 中寄存器的写信息传递到回写阶段 
        wb_cp0_reg_we         <= mem_cp0_reg_we; 
        wb_cp0_reg_write_addr <= mem_cp0_reg_write_addr; 
        wb_cp0_reg_data       <= mem_cp0_reg_data;
    end     
end       
endmodule 