`include "defines.vh"

module if_id( 
    input wire                   clk,
    input wire                   rst, 
    
    // 来自取指阶段的信号，其中宏定义 InstBus 表示指令宽度，为 32 
    input wire[`InstAddrBus]     if_pc, 
    input wire[`InstBus]         if_inst, 
    
    input wire[5:0]              stall,
    
    input wire                   flush,

    // 对应译码阶段的信号 
    output reg[`InstAddrBus]     id_pc, 
    output reg[`InstBus]         id_inst   
); 

wire insert_bubble;
wire if_stage_can_advance;

assign insert_bubble        = (flush == 1'b1) || ((stall[1] == `Stop) && (stall[2] == `NoStop));
assign if_stage_can_advance = (stall[1] == `NoStop);

       //（1）异常清空流水线，或 IF 停止而 ID 继续时，向 ID 级注入空操作 
       //（2）IF 级可以继续推进时，把当前取值结果送入 ID 级 
       //（3）其余情况下，保持 id_pc、id_inst 不变 

always @ (posedge clk) begin 
    if (rst == `RstEnable) begin 
        id_pc   <= `ZeroWord;     // 复位的时候 pc 为 0 
        id_inst <= `ZeroWord;     // 复位的时候指令也为 0，实际就是空指令 
    end 
    else if (insert_bubble) begin
        // 注入一条空操作，既可用于异常清空，也可用于暂停时补气泡
        id_pc   <= `ZeroWord;
        id_inst <= `ZeroWord;
    end
    else if(if_stage_can_advance) begin 
        id_pc   <= if_pc;          // 其余时刻向下传递取指阶段的值 
        id_inst <= if_inst; 
    end 
end 
endmodule 
