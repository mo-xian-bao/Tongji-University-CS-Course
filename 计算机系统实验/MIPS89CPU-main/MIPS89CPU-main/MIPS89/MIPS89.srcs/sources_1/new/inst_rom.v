`include "defines.vh"

module inst_rom( 
    input  wire               ce, 
    input  wire[`InstAddrBus] addr, 
    output reg [`InstBus]     inst 
); 
    // 定义一个数组，大小是 InstMemNum，元素宽度是 InstBus 
    reg[`InstBus]  inst_mem[0 : `InstMemNum -1 ]; 
    
    // 使用文件 inst_rom.data 初始化指令存储器 
    initial $readmemh ( "D:/TJU/ComputerSystem/MIPS89/inst_rom.data", inst_mem ); 
 
// 当复位信号无效时，依据输入的地址，给出指令存储器 ROM 中对应的元素 
always @ (*) begin 
    if (ce == `ChipDisable) begin 
        inst <= `ZeroWord; 
    end 
    else begin 
        inst <= inst_mem[addr[`InstMemNumLog2 + 1 : 2]]; 
        // 有关为什么可以不改 PC 的首址为 0x00400000？
        // 因为地址这里只取了最多到第 18 位，那个 “4” 根本没用
        // 所以改不改都没有影响
    end 
end 
 
endmodule