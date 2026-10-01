module top(
    input   clk_in,         //时钟输入
    input   reset,          //复位信号
    output  [7:0]   o_seg,
    output  [7:0]   o_sel
    );
  
    wire  [31:0] inst;
    wire  [31:0] pc;    
    wire  clk_5hz; 

    Divider divider_inst(
        .clk(clk_in), 
        .rst(reset),
        .clk_out(clk_1hz)
    ); 


    sccomp_dataflow sd(
        .clk_in(clk_1hz),         
        .reset(reset),         
        .inst(inst),
        .pc(pc)
    );
    
   seg7x16 print(
         .clk(clk_in),
         .reset(reset),
         .cs(clk_1hz),
         .i_data(inst),
         .o_seg(o_seg),
         .o_sel(o_sel)
    );
    
endmodule
