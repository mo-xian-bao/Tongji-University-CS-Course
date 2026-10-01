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

       //（1）当 stall[1] 为 Stop，stall[2] 为 NoStop 时，表示取指阶段暂停， 
       //     而译码阶段继续，所以使用空指令作为下一个周期进入译码阶段的指令 
       //（2）当 stall[1] 为 NoStop 时，取指阶段继续，取得的指令进入译码阶段 
       //（3）其余情况下，保持译码阶段的寄存器 id_pc、id_inst 不变 

always @ (posedge clk) begin 
    if (rst == `RstEnable) begin 
        id_pc   <= `ZeroWord;     // 复位的时候 pc 为 0 
        id_inst <= `ZeroWord;     // 复位的时候指令也为 0，实际就是空指令 
    end 
    else if (flush == 1'b1) begin
        // flush 为 1 表示异常发生，要清除流水线， 
        // 所以复位 id_pc、id_inst 寄存器的值
        id_pc   <= `ZeroWord;
        id_inst <= `ZeroWord;
    end
    else if(stall[1] == `Stop && stall[2] == `NoStop) begin
        id_pc   <= `ZeroWord;
        id_inst <= `ZeroWord;
    end
    else if(stall[1] == `NoStop) begin 
        id_pc   <= if_pc;          // 其余时刻向下传递取指阶段的值 
        id_inst <= if_inst; 
    end 
end 
endmodule 