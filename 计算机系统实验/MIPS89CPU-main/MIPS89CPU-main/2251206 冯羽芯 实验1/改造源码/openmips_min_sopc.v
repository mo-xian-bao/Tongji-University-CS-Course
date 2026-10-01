`include "defines.vh"

module openmips_min_sopc(
    input wire    clk, 
    input wire    rst,
    output [7:0]  O_Seg,
    output [7:0]  O_Sel
);

    // 连接指令存储器 
    wire[`InstAddrBus]  inst_addr; 
    wire[`InstBus]      inst; 
    wire                rom_ce; 
    
    wire                mem_we_i;
    wire[`RegBus]       mem_addr_i;
    wire[`RegBus]       mem_data_i;
    wire[`RegBus]       mem_data_o;
    wire[3:0]           mem_sel_i;  
    wire                mem_ce_i;
    
    wire[5:0]           int; 
    wire                timer_int;
    
    wire[`DataBus]      Seg7_In;           // 显示在数码管里面的内容
    
    assign int = {5'b00000, timer_int};    // 时钟中断输出作为一个中断输入
    
    reg clk_100;
//    reg cnt;
    initial clk_100 = 0;
    integer cnt = 0;
    
    // 分频器：clk n 个周期 clk_100 才一个周期
    always @(posedge clk) begin
        if (cnt < 100) begin
            cnt = cnt + 1;
        end
        else begin
            cnt = 0;
            clk_100 = ~clk_100;
        end
    end
    
    // 例化处理器 OpenMIPS 
    openmips openmips0( 
        .clk(clk_100),   
        .rst(rst), 
        .rom_addr_o(inst_addr), 
        .rom_data_i(inst), 
        .rom_ce_o(rom_ce),
        
        .int_i(int),                // 中断输入
        
        .ram_we_o(mem_we_i),
		.ram_addr_o(mem_addr_i),
		.ram_sel_o(mem_sel_i),
		.ram_data_o(mem_data_i),
		.ram_data_i(mem_data_o),
		.ram_ce_o(mem_ce_i),
		
		.timer_int_o(timer_int)     // 时钟中断输出
    ); 
    
    // 例化指令存储器 ROM 
    inst_rom inst_rom0( 
        .ce(rom_ce), 
        .addr(inst_addr),  
        .inst(inst) 
    ); 
    
    data_ram data_ram0(
		.clk(clk_100),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.sel(mem_sel_i),
		.data_i(mem_data_i),
		.data_o(mem_data_o),
		.ce(mem_ce_i),
		.seg7x16_data(Seg7_In)
	);
	
	Seg7x16 seg7x16_uut(
	    .Clk(clk),
	    .Reset(rst),
	    .Cs(1'b1),
	    .I_Data(Seg7_In),
	    .O_Seg(O_Seg),
	    .O_Sel(O_Sel)
	);

endmodule
