`include "defines.vh"

module data_ram( 
       input  wire                   clk, 
       input  wire                   ce,        // 数据存储器使能信号
       input  wire                   we,        // 是否是写操作，为 1 表示是写操作
       input  wire[`DataAddrBus]     addr,      // 要访问的地址
       input  wire[3:0]              sel,       // 字节选择信号
       input  wire[`DataBus]         data_i,    // 要写入的数据
       output reg [`DataBus]         data_o,    // 读出的数据
       output [`DataBus]             seg7x16_data  // 输入给七段数码管的数据
);

       // 定义四个字节数组 
       reg[`ByteWidth]  data_mem0[0:`DataMemNum - 1]; 
       reg[`ByteWidth]  data_mem1[0:`DataMemNum - 1];
       reg[`ByteWidth]  data_mem2[0:`DataMemNum - 1]; 
       reg[`ByteWidth]  data_mem3[0:`DataMemNum - 1]; 
       
       // mem3 表示模 4 余 0 的地址
       // mem2 表示模 4 余 1 的地址
       // mem1 表示模 4 余 2 的地址
       // mem0 表示模 4 余 3 的地址
       
       assign seg7x16_data = {data_mem3[0], data_mem2[0], data_mem1[0], data_mem0[0]};
       
       // 写操作 
        always @ (posedge clk) begin 
            if (ce == `ChipDisable) begin 
            // data_o <= ZeroWord; 
            end 
            else if(we == `WriteEnable) begin 
                if (sel[3] == 1'b1) begin // 这不是数组！！！！！！！这是左边第一位！！！！ 3.2.1.0
                    data_mem3[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000] <= data_i[31:24]; // 除以 4 // 低地址
                end 
                if (sel[2] == 1'b1) begin 
                    data_mem2[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000] <= data_i[23:16]; 
                end 
                if (sel[1] == 1'b1) begin 
                    data_mem1[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000] <= data_i[15:8]; 
                end 
                if (sel[0] == 1'b1) begin 
                    data_mem0[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000] <= data_i[7:0]; 
                end            
            end 
        end 
        
        // 读操作 读出 0 1 2 3 地址的内容
        always @ (*) begin 
            if (ce == `ChipDisable) begin 
                data_o <= `ZeroWord; 
            end 
            else if(we == `WriteDisable) begin // 低 → 高 0 1 2 3
                data_o <= {data_mem3[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000], 
                           data_mem2[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000], 
                           data_mem1[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000], 
                           data_mem0[addr[`DataMemNumLog2 + 1:2] - 17'b0_0100_0000_0000_0000]}; 
                           // - 17'b0_0100_0000_0000_0000 是因为 MARS 数据段是从 0x10010000 开始的
                           // 17'b0_0100_0000_0000_0000 是 17'b1_0000_0000_0000_0000（0x10000） 右移两位（除以4）得到的
                           // 相当于是 19 位地址除以 4 得到 17 位地址（寄存器地址），最多是 19 位地址
                           // 所以 MARS 中的 32 位地址（32'b0001_0000_0000_0001_0000_0000_0000_0000）没有全部用上
                           // 只用了 17'b1_0000_0000_0000_0000（0x10000）
            end 
            else begin 
                data_o <= `ZeroWord; 
            end 
        end

endmodule
