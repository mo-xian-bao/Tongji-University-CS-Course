`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 23:31:23
// Design Name: 
// Module Name: Regfiles
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module decoder5to32(
   input ena,
   input [4:0] iData,
   output [31:0] oData
    );
    assign oData[0] = ~iData[4] & ~iData[3] & ~iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[1] = ~iData[4] & ~iData[3] & ~iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[2] = ~iData[4] & ~iData[3] & ~iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[3] = ~iData[4] & ~iData[3] & ~iData[2] & iData[1] & iData[0] & ena;
    assign oData[4] = ~iData[4] & ~iData[3] & iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[5] = ~iData[4] & ~iData[3] & iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[6] = ~iData[4] & ~iData[3] & iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[7] = ~iData[4] & ~iData[3] & iData[2] & iData[1] & iData[0] & ena;
    assign oData[8] = ~iData[4] & iData[3] & ~iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[9] = ~iData[4] & iData[3] & ~iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[10] = ~iData[4] & iData[3] & ~iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[11] = ~iData[4] & iData[3] & ~iData[2] & iData[1] & iData[0] & ena;
    assign oData[12] = ~iData[4] & iData[3] & iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[13] = ~iData[4] & iData[3] & iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[14] = ~iData[4] & iData[3] & iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[15] = ~iData[4] & iData[3] & iData[2] & iData[1] & iData[0] & ena;
    assign oData[16] = iData[4] & ~iData[3] & ~iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[17] = iData[4] & ~iData[3] & ~iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[18] = iData[4] & ~iData[3] & ~iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[19] = iData[4] & ~iData[3] & ~iData[2] & iData[1] & iData[0] & ena;
    assign oData[20] = iData[4] & ~iData[3] & iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[21] = iData[4] & ~iData[3] & iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[22] = iData[4] & ~iData[3] & iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[23] = iData[4] & ~iData[3] & iData[2] & iData[1] & iData[0] & ena;
    assign oData[24] = iData[4] & iData[3] & ~iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[25] = iData[4] & iData[3] & ~iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[26] = iData[4] & iData[3] & ~iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[27] = iData[4] & iData[3] & ~iData[2] & iData[1] & iData[0] & ena;
    assign oData[28] = iData[4] & iData[3] & iData[2] & ~iData[1] & ~iData[0] & ena;
    assign oData[29] = iData[4] & iData[3] & iData[2] & ~iData[1] & iData[0] & ena;
    assign oData[30] = iData[4] & iData[3] & iData[2] & iData[1] & ~iData[0] & ena;
    assign oData[31] = iData[4] & iData[3] & iData[2] & iData[1] & iData[0] & ena;
endmodule


module selector32to1(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [31:0] iC4,
    input [31:0] iC5,
    input [31:0] iC6,
    input [31:0] iC7,
    input [31:0] iC8,
    input [31:0] iC9,
    input [31:0] iC10,
    input [31:0] iC11,
    input [31:0] iC12,
    input [31:0] iC13,
    input [31:0] iC14,
    input [31:0] iC15,
    input [31:0] iC16,
    input [31:0] iC17,
    input [31:0] iC18,
    input [31:0] iC19,
    input [31:0] iC20,
    input [31:0] iC21,
    input [31:0] iC22,
    input [31:0] iC23,
    input [31:0] iC24,
    input [31:0] iC25,
    input [31:0] iC26,
    input [31:0] iC27,
    input [31:0] iC28,
    input [31:0] iC29,
    input [31:0] iC30,
    input [31:0] iC31,
    input [4:0] option,
    input ena,
    output reg [31:0] oZ
    );
    always @(*)
    begin
    if(ena)
    begin
        if (option == 0) oZ = iC0;
        else if (option == 1) oZ = iC1;
        else if (option == 2) oZ = iC2;
        else if (option == 3) oZ = iC3;
        else if (option == 4) oZ = iC4;
        else if (option == 5) oZ = iC5;
        else if (option == 6) oZ = iC6;
        else if (option == 7) oZ = iC7;
        else if (option == 8) oZ = iC8;
        else if (option == 9) oZ = iC9;
        else if (option == 10) oZ = iC10;
        else if (option == 11) oZ = iC11;
        else if (option == 12) oZ = iC12;
        else if (option == 13) oZ = iC13;
        else if (option == 14) oZ = iC14;
        else if (option == 15) oZ = iC15;
        else if (option == 16) oZ = iC16;
        else if (option == 17) oZ = iC17;
        else if (option == 18) oZ = iC18;
        else if (option == 19) oZ = iC19;
        else if (option == 20) oZ = iC20;
        else if (option == 21) oZ = iC21;
        else if (option == 22) oZ = iC22;
        else if (option == 23) oZ = iC23;
        else if (option == 24) oZ = iC24;
        else if (option == 25) oZ = iC25;
        else if (option == 26) oZ = iC26;
        else if (option == 27) oZ = iC27;
        else if (option == 28) oZ = iC28;
        else if (option == 29) oZ = iC29;
        else if (option == 30) oZ = iC30;
        else if (option == 31) oZ = iC31;
       end
    end

endmodule


module ADFF(
    input clk,
    input d,
    input rst,
    input ena,
    output reg Q1
);
    always @(negedge clk or posedge rst)
    begin
        if (rst)
        begin
            Q1 = 0;
        end

        else
        begin
            if (ena)
            begin
                Q1 = d;
            end
        end
    end
endmodule




module pcreg(
    input clk,
    input rst,
    input ena,
    input [31:0] data_in,
    output [31:0] data_out
    );
        ADFF p0(.clk(clk), .d(data_in[0]), .rst(rst), .ena(ena), .Q1(data_out[0]));
        ADFF p1(.clk(clk), .d(data_in[1]), .rst(rst), .ena(ena), .Q1(data_out[1]));
        ADFF p2(.clk(clk), .d(data_in[2]), .rst(rst), .ena(ena), .Q1(data_out[2]));
        ADFF p3(.clk(clk), .d(data_in[3]), .rst(rst), .ena(ena), .Q1(data_out[3]));
        ADFF p4(.clk(clk), .d(data_in[4]), .rst(rst), .ena(ena), .Q1(data_out[4]));
        ADFF p5(.clk(clk), .d(data_in[5]), .rst(rst), .ena(ena), .Q1(data_out[5]));
        ADFF p6(.clk(clk), .d(data_in[6]), .rst(rst), .ena(ena), .Q1(data_out[6]));
        ADFF p7(.clk(clk), .d(data_in[7]), .rst(rst), .ena(ena), .Q1(data_out[7]));
        ADFF p8(.clk(clk), .d(data_in[8]), .rst(rst), .ena(ena), .Q1(data_out[8]));
        ADFF p9(.clk(clk), .d(data_in[9]), .rst(rst), .ena(ena), .Q1(data_out[9]));
        ADFF p10(.clk(clk), .d(data_in[10]), .rst(rst), .ena(ena), .Q1(data_out[10]));
        ADFF p11(.clk(clk), .d(data_in[11]), .rst(rst), .ena(ena), .Q1(data_out[11]));
        ADFF p12(.clk(clk), .d(data_in[12]), .rst(rst), .ena(ena), .Q1(data_out[12]));
        ADFF p13(.clk(clk), .d(data_in[13]), .rst(rst), .ena(ena), .Q1(data_out[13]));
        ADFF p14(.clk(clk), .d(data_in[14]), .rst(rst), .ena(ena), .Q1(data_out[14]));
        ADFF p15(.clk(clk), .d(data_in[15]), .rst(rst), .ena(ena), .Q1(data_out[15]));
        ADFF p16(.clk(clk), .d(data_in[16]), .rst(rst), .ena(ena), .Q1(data_out[16]));
        ADFF p17(.clk(clk), .d(data_in[17]), .rst(rst), .ena(ena), .Q1(data_out[17]));
        ADFF p18(.clk(clk), .d(data_in[18]), .rst(rst), .ena(ena), .Q1(data_out[18]));
        ADFF p19(.clk(clk), .d(data_in[19]), .rst(rst), .ena(ena), .Q1(data_out[19]));
        ADFF p20(.clk(clk), .d(data_in[20]), .rst(rst), .ena(ena), .Q1(data_out[20]));
        ADFF p21(.clk(clk), .d(data_in[21]), .rst(rst), .ena(ena), .Q1(data_out[21]));
        ADFF p22(.clk(clk), .d(data_in[22]), .rst(rst), .ena(ena), .Q1(data_out[22]));
        ADFF p23(.clk(clk), .d(data_in[23]), .rst(rst), .ena(ena), .Q1(data_out[23]));
        ADFF p24(.clk(clk), .d(data_in[24]), .rst(rst), .ena(ena), .Q1(data_out[24]));
        ADFF p25(.clk(clk), .d(data_in[25]), .rst(rst), .ena(ena), .Q1(data_out[25]));
        ADFF p26(.clk(clk), .d(data_in[26]), .rst(rst), .ena(ena), .Q1(data_out[26]));
        ADFF p27(.clk(clk), .d(data_in[27]), .rst(rst), .ena(ena), .Q1(data_out[27]));
        ADFF p28(.clk(clk), .d(data_in[28]), .rst(rst), .ena(ena), .Q1(data_out[28]));
        ADFF p29(.clk(clk), .d(data_in[29]), .rst(rst), .ena(ena), .Q1(data_out[29]));
        ADFF p30(.clk(clk), .d(data_in[30]), .rst(rst), .ena(ena), .Q1(data_out[30]));
        ADFF p31(.clk(clk), .d(data_in[31]), .rst(rst), .ena(ena), .Q1(data_out[31]));
    
    
endmodule


/*
module pcreg(
    input clk,
    input rst,
    input ena,
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    always @(negedge clk or posedge rst)
    begin
    if(ena)
         data_out = (rst ?  32'b0 : data_in);
     end
endmodule
*/



module Regfiles(
    input clk,
    input rst,
    input we,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
    );
    
    wire [31:0] ram [31:0];
    wire [31:0] coding;
    
   decoder5to32 d(we,waddr,coding);
   pcreg p0(clk,rst,coding[0],wdata,ram[0]);
   pcreg p1(clk,rst,coding[1],wdata,ram[1]);
   pcreg p2(clk,rst,coding[2],wdata,ram[2]);
   pcreg p3(clk,rst,coding[3],wdata,ram[3]);
   pcreg p4(clk,rst,coding[4],wdata,ram[4]);
   pcreg p5(clk,rst,coding[5],wdata,ram[5]);
   pcreg p6(clk,rst,coding[6],wdata,ram[6]);
   pcreg p7(clk,rst,coding[7],wdata,ram[7]);
   pcreg p8(clk,rst,coding[8],wdata,ram[8]);
   pcreg p9(clk,rst,coding[9],wdata,ram[9]);
   pcreg p10(clk,rst,coding[10],wdata,ram[10]);
   pcreg p11(clk,rst,coding[11],wdata,ram[11]);
   pcreg p12(clk,rst,coding[12],wdata,ram[12]);
   pcreg p13(clk,rst,coding[13],wdata,ram[13]);
   pcreg p14(clk,rst,coding[14],wdata,ram[14]);
   pcreg p15(clk,rst,coding[15],wdata,ram[15]);
   pcreg p16(clk,rst,coding[16],wdata,ram[16]);
   pcreg p17(clk,rst,coding[17],wdata,ram[17]);
   pcreg p18(clk,rst,coding[18],wdata,ram[18]);
   pcreg p19(clk,rst,coding[19],wdata,ram[19]);
   pcreg p20(clk,rst,coding[20],wdata,ram[20]);
   pcreg p21(clk,rst,coding[21],wdata,ram[21]);
   pcreg p22(clk,rst,coding[22],wdata,ram[22]);
   pcreg p23(clk,rst,coding[23],wdata,ram[23]);
   pcreg p24(clk,rst,coding[24],wdata,ram[24]);
   pcreg p25(clk,rst,coding[25],wdata,ram[25]);
   pcreg p26(clk,rst,coding[26],wdata,ram[26]);
   pcreg p27(clk,rst,coding[27],wdata,ram[27]);
   pcreg p28(clk,rst,coding[28],wdata,ram[28]);
   pcreg p29(clk,rst,coding[29],wdata,ram[29]);
   pcreg p30(clk,rst,coding[30],wdata,ram[30]);
   pcreg p31(clk,rst,coding[31],wdata,ram[31]);
    
    selector32to1 s1(ram[0],ram[1],ram[2],ram[3],ram[4],ram[5],ram[6],ram[7],ram[8],ram[9],ram[10],ram[11],ram[12],ram[13],ram[14],ram[15],ram[16],ram[17],ram[18],ram[19],ram[20],ram[21],ram[22],ram[23],ram[24],ram[25],ram[26],ram[27],ram[28],ram[29],ram[30],ram[31],raddr1,~we,rdata1);
    selector32to1 s2(ram[0],ram[1],ram[2],ram[3],ram[4],ram[5],ram[6],ram[7],ram[8],ram[9],ram[10],ram[11],ram[12],ram[13],ram[14],ram[15],ram[16],ram[17],ram[18],ram[19],ram[20],ram[21],ram[22],ram[23],ram[24],ram[25],ram[26],ram[27],ram[28],ram[29],ram[30],ram[31],raddr2,~we,rdata2);
    
    
    
endmodule
