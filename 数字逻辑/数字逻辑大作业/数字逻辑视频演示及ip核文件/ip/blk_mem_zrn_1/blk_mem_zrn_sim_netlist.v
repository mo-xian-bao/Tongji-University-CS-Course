// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Tue Dec 17 19:54:46 2024
// Host        : LAPTOP-V0AHCU9H running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/vivado_projects/VGA_1/VGA_1.srcs/sources_1/ip/blk_mem_zrn_1/blk_mem_zrn_sim_netlist.v
// Design      : blk_mem_zrn
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_zrn,blk_mem_gen_v8_3_3,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_3_3,Vivado 2016.2" *) 
(* NotValidForBitStream *)
module blk_mem_zrn
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [16:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [11:0]douta;

  wire [16:0]addra;
  wire clka;
  wire [11:0]douta;
  wire ena;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [11:0]NLW_U0_doutb_UNCONNECTED;
  wire [16:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [16:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "17" *) 
  (* C_ADDRB_WIDTH = "17" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "3" *) 
  (* C_COUNT_36K_BRAM = "29" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     8.178452 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_zrn.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_zrn.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "90000" *) 
  (* C_READ_DEPTH_B = "90000" *) 
  (* C_READ_WIDTH_A = "12" *) 
  (* C_READ_WIDTH_B = "12" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "90000" *) 
  (* C_WRITE_DEPTH_B = "90000" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "12" *) 
  (* C_WRITE_WIDTH_B = "12" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  blk_mem_zrn_blk_mem_gen_v8_3_3 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[11:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[16:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[16:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[11:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule

(* ORIG_REF_NAME = "bindec" *) 
module blk_mem_zrn_bindec
   (ena_array,
    ram_ena,
    addra,
    ena);
  output [19:0]ena_array;
  output ram_ena;
  input [4:0]addra;
  input ena;

  wire [4:0]addra;
  wire ena;
  wire [19:0]ena_array;
  wire ram_ena;

  LUT6 #(
    .INIT(64'h0000000000000100)) 
    ENOUT
       (.I0(addra[0]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(ena),
        .I4(addra[3]),
        .I5(addra[2]),
        .O(ena_array[0]));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    ENOUT_inferred__0
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(ena),
        .I3(addra[0]),
        .I4(addra[3]),
        .I5(addra[2]),
        .O(ena_array[1]));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    ENOUT_inferred__1
       (.I0(addra[0]),
        .I1(addra[4]),
        .I2(ena),
        .I3(addra[1]),
        .I4(addra[3]),
        .I5(addra[2]),
        .O(ena_array[2]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    ENOUT_inferred__10
       (.I0(addra[2]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[0]),
        .I4(ena),
        .I5(addra[3]),
        .O(ena_array[10]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__11
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(addra[2]),
        .I3(addra[3]),
        .I4(addra[0]),
        .I5(ena),
        .O(ena_array[11]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    ENOUT_inferred__12
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(addra[3]),
        .I3(addra[0]),
        .I4(ena),
        .I5(addra[2]),
        .O(ena_array[12]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    ENOUT_inferred__13
       (.I0(addra[0]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[3]),
        .I4(ena),
        .I5(addra[2]),
        .O(ena_array[13]));
  LUT6 #(
    .INIT(64'h2000000000000000)) 
    ENOUT_inferred__14
       (.I0(ena),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[0]),
        .I4(addra[3]),
        .I5(addra[2]),
        .O(ena_array[14]));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    ENOUT_inferred__15
       (.I0(addra[0]),
        .I1(addra[1]),
        .I2(addra[4]),
        .I3(ena),
        .I4(addra[3]),
        .I5(addra[2]),
        .O(ena_array[15]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__16
       (.I0(addra[1]),
        .I1(addra[2]),
        .I2(ena),
        .I3(addra[0]),
        .I4(addra[3]),
        .I5(addra[4]),
        .O(ena_array[16]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__17
       (.I0(addra[0]),
        .I1(addra[2]),
        .I2(addra[1]),
        .I3(ena),
        .I4(addra[3]),
        .I5(addra[4]),
        .O(ena_array[17]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    ENOUT_inferred__18
       (.I0(addra[2]),
        .I1(addra[3]),
        .I2(addra[1]),
        .I3(addra[0]),
        .I4(addra[4]),
        .I5(ena),
        .O(ena_array[18]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__19
       (.I0(addra[0]),
        .I1(addra[1]),
        .I2(addra[2]),
        .I3(ena),
        .I4(addra[3]),
        .I5(addra[4]),
        .O(ena_array[19]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__2
       (.I0(addra[2]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[0]),
        .I4(addra[3]),
        .I5(ena),
        .O(ena_array[3]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    ENOUT_inferred__20
       (.I0(addra[1]),
        .I1(addra[3]),
        .I2(ena),
        .I3(addra[0]),
        .I4(addra[4]),
        .I5(addra[2]),
        .O(ram_ena));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    ENOUT_inferred__3
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(ena),
        .I3(addra[2]),
        .I4(addra[3]),
        .I5(addra[0]),
        .O(ena_array[4]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__4
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(addra[2]),
        .I3(addra[0]),
        .I4(addra[3]),
        .I5(ena),
        .O(ena_array[5]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__5
       (.I0(addra[0]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[2]),
        .I4(addra[3]),
        .I5(ena),
        .O(ena_array[6]));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    ENOUT_inferred__7
       (.I0(addra[1]),
        .I1(addra[4]),
        .I2(ena),
        .I3(addra[3]),
        .I4(addra[0]),
        .I5(addra[2]),
        .O(ena_array[7]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__8
       (.I0(addra[2]),
        .I1(addra[4]),
        .I2(addra[3]),
        .I3(addra[0]),
        .I4(addra[1]),
        .I5(ena),
        .O(ena_array[8]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    ENOUT_inferred__9
       (.I0(addra[2]),
        .I1(addra[4]),
        .I2(addra[1]),
        .I3(addra[3]),
        .I4(addra[0]),
        .I5(ena),
        .O(ena_array[9]));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module blk_mem_zrn_blk_mem_gen_generic_cstr
   (douta,
    addra,
    ena,
    clka);
  output [11:0]douta;
  input [16:0]addra;
  input ena;
  input clka;

  wire [16:0]addra;
  wire clka;
  wire [11:0]douta;
  wire ena;
  wire [20:0]ena_array;
  wire [8:0]p_11_out;
  wire [8:0]p_15_out;
  wire [8:0]p_19_out;
  wire [8:0]p_23_out;
  wire [8:0]p_27_out;
  wire [8:0]p_31_out;
  wire [8:0]p_35_out;
  wire [8:0]p_39_out;
  wire [8:0]p_3_out;
  wire [8:0]p_43_out;
  wire [8:0]p_47_out;
  wire [8:0]p_51_out;
  wire [8:0]p_55_out;
  wire [8:0]p_59_out;
  wire [8:0]p_63_out;
  wire [8:0]p_67_out;
  wire [8:0]p_71_out;
  wire [8:0]p_75_out;
  wire [8:0]p_79_out;
  wire [8:0]p_7_out;
  wire [8:0]p_83_out;
  wire [8:0]p_87_out;
  wire ram_douta;
  wire ram_ena__0;
  wire ram_ena_inferred__1_n_0;
  wire ram_ena_n_0;
  wire \ramloop[1].ram.r_n_0 ;
  wire \ramloop[2].ram.r_n_0 ;
  wire \ramloop[2].ram.r_n_1 ;
  wire \ramloop[3].ram.r_n_0 ;
  wire \ramloop[4].ram.r_n_0 ;
  wire \ramloop[4].ram.r_n_1 ;
  wire \ramloop[5].ram.r_n_0 ;
  wire \ramloop[6].ram.r_n_0 ;

  blk_mem_zrn_bindec \bindec_a.bindec_inst_a 
       (.addra(addra[16:12]),
        .ena(ena),
        .ena_array({ena_array[20:8],ena_array[6:0]}),
        .ram_ena(ram_ena__0));
  blk_mem_zrn_blk_mem_gen_mux \has_mux_a.A 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T (\ramloop[3].ram.r_n_0 ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_0 (\ramloop[5].ram.r_n_0 ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ({\ramloop[2].ram.r_n_0 ,\ramloop[2].ram.r_n_1 }),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 (\ramloop[4].ram.r_n_0 ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram (\ramloop[6].ram.r_n_0 ),
        .DOADO(\ramloop[1].ram.r_n_0 ),
        .DOUTA(ram_douta),
        .addra(addra[16:12]),
        .clka(clka),
        .douta(douta),
        .ena(ena),
        .p_11_out(p_11_out),
        .p_15_out(p_15_out),
        .p_19_out(p_19_out),
        .p_23_out(p_23_out),
        .p_27_out(p_27_out),
        .p_31_out(p_31_out),
        .p_35_out(p_35_out),
        .p_39_out(p_39_out),
        .p_3_out(p_3_out),
        .p_43_out(p_43_out),
        .p_47_out(p_47_out),
        .p_51_out(p_51_out),
        .p_55_out(p_55_out),
        .p_59_out(p_59_out),
        .p_63_out(p_63_out),
        .p_67_out(p_67_out),
        .p_71_out(p_71_out),
        .p_75_out(p_75_out),
        .p_79_out(p_79_out),
        .p_7_out(p_7_out),
        .p_83_out(p_83_out),
        .p_87_out(p_87_out));
  LUT2 #(
    .INIT(4'h4)) 
    ram_ena
       (.I0(addra[16]),
        .I1(ena),
        .O(ram_ena_n_0));
  LUT3 #(
    .INIT(8'h08)) 
    ram_ena_inferred__1
       (.I0(addra[16]),
        .I1(ena),
        .I2(addra[15]),
        .O(ram_ena_inferred__1_n_0));
  blk_mem_zrn_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.DOUTA(ram_douta),
        .ENA(ram_ena_n_0),
        .addra(addra[15:0]),
        .clka(clka),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized9 \ramloop[10].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[3]),
        .p_75_out(p_75_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized10 \ramloop[11].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[4]),
        .p_71_out(p_71_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized11 \ramloop[12].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[5]),
        .p_67_out(p_67_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized12 \ramloop[13].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[6]),
        .p_63_out(p_63_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized13 \ramloop[14].ram.r 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .p_59_out(p_59_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized14 \ramloop[15].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[8]),
        .p_55_out(p_55_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized15 \ramloop[16].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[9]),
        .p_51_out(p_51_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized16 \ramloop[17].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[10]),
        .p_47_out(p_47_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized17 \ramloop[18].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[11]),
        .p_43_out(p_43_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized18 \ramloop[19].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[12]),
        .p_39_out(p_39_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized0 \ramloop[1].ram.r 
       (.DOADO(\ramloop[1].ram.r_n_0 ),
        .addra(addra[13:0]),
        .\addra[16] (\ramloop[4].ram.r_n_1 ),
        .clka(clka),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized19 \ramloop[20].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[13]),
        .p_35_out(p_35_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized20 \ramloop[21].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[14]),
        .p_31_out(p_31_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized21 \ramloop[22].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[15]),
        .p_27_out(p_27_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized22 \ramloop[23].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[16]),
        .p_23_out(p_23_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized23 \ramloop[24].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[17]),
        .p_19_out(p_19_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized24 \ramloop[25].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[18]),
        .p_15_out(p_15_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized25 \ramloop[26].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[19]),
        .p_11_out(p_11_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized26 \ramloop[27].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[20]),
        .p_7_out(p_7_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized27 \ramloop[28].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .p_3_out(p_3_out),
        .ram_ena(ram_ena__0));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized1 \ramloop[2].ram.r 
       (.addra(addra),
        .clka(clka),
        .\douta[1] ({\ramloop[2].ram.r_n_0 ,\ramloop[2].ram.r_n_1 }),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized2 \ramloop[3].ram.r 
       (.DOUTA(\ramloop[3].ram.r_n_0 ),
        .ENA(ram_ena_n_0),
        .addra(addra[15:0]),
        .clka(clka),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized3 \ramloop[4].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram (\ramloop[4].ram.r_n_1 ),
        .addra(addra),
        .clka(clka),
        .\douta[1] (\ramloop[4].ram.r_n_0 ),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized4 \ramloop[5].ram.r 
       (.DOUTA(\ramloop[5].ram.r_n_0 ),
        .ENA(ram_ena_n_0),
        .addra(addra[15:0]),
        .clka(clka),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized5 \ramloop[6].ram.r 
       (.addra(addra[14:0]),
        .\addra[15] (ram_ena_inferred__1_n_0),
        .clka(clka),
        .\douta[2] (\ramloop[6].ram.r_n_0 ),
        .ena(ena));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized6 \ramloop[7].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[0]),
        .p_87_out(p_87_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized7 \ramloop[8].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[1]),
        .p_83_out(p_83_out));
  blk_mem_zrn_blk_mem_gen_prim_width__parameterized8 \ramloop[9].ram.r 
       (.addra(addra[11:0]),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array[2]),
        .p_79_out(p_79_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_mux" *) 
module blk_mem_zrn_blk_mem_gen_mux
   (douta,
    DOADO,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ,
    p_7_out,
    p_3_out,
    ena,
    addra,
    clka,
    DOUTA,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_0 ,
    p_75_out,
    p_79_out,
    p_83_out,
    p_87_out,
    p_59_out,
    p_63_out,
    p_67_out,
    p_71_out,
    p_43_out,
    p_47_out,
    p_51_out,
    p_55_out,
    p_27_out,
    p_31_out,
    p_35_out,
    p_39_out,
    p_11_out,
    p_15_out,
    p_19_out,
    p_23_out);
  output [11:0]douta;
  input [0:0]DOADO;
  input [1:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ;
  input [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ;
  input [8:0]p_7_out;
  input [8:0]p_3_out;
  input ena;
  input [4:0]addra;
  input clka;
  input [0:0]DOUTA;
  input [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T ;
  input [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  input [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_0 ;
  input [8:0]p_75_out;
  input [8:0]p_79_out;
  input [8:0]p_83_out;
  input [8:0]p_87_out;
  input [8:0]p_59_out;
  input [8:0]p_63_out;
  input [8:0]p_67_out;
  input [8:0]p_71_out;
  input [8:0]p_43_out;
  input [8:0]p_47_out;
  input [8:0]p_51_out;
  input [8:0]p_55_out;
  input [8:0]p_27_out;
  input [8:0]p_31_out;
  input [8:0]p_35_out;
  input [8:0]p_39_out;
  input [8:0]p_11_out;
  input [8:0]p_15_out;
  input [8:0]p_19_out;
  input [8:0]p_23_out;

  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_0 ;
  wire [1:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [0:0]DOADO;
  wire [0:0]DOUTA;
  wire [4:0]addra;
  wire clka;
  wire [11:0]douta;
  wire \douta[0]_INST_0_i_1_n_0 ;
  wire \douta[10]_INST_0_i_1_n_0 ;
  wire \douta[10]_INST_0_i_2_n_0 ;
  wire \douta[10]_INST_0_i_3_n_0 ;
  wire \douta[10]_INST_0_i_4_n_0 ;
  wire \douta[10]_INST_0_i_5_n_0 ;
  wire \douta[10]_INST_0_i_6_n_0 ;
  wire \douta[10]_INST_0_i_7_n_0 ;
  wire \douta[10]_INST_0_i_8_n_0 ;
  wire \douta[10]_INST_0_i_9_n_0 ;
  wire \douta[11]_INST_0_i_1_n_0 ;
  wire \douta[11]_INST_0_i_2_n_0 ;
  wire \douta[11]_INST_0_i_3_n_0 ;
  wire \douta[11]_INST_0_i_4_n_0 ;
  wire \douta[11]_INST_0_i_5_n_0 ;
  wire \douta[11]_INST_0_i_6_n_0 ;
  wire \douta[11]_INST_0_i_7_n_0 ;
  wire \douta[11]_INST_0_i_8_n_0 ;
  wire \douta[11]_INST_0_i_9_n_0 ;
  wire \douta[1]_INST_0_i_1_n_0 ;
  wire \douta[3]_INST_0_i_1_n_0 ;
  wire \douta[3]_INST_0_i_2_n_0 ;
  wire \douta[3]_INST_0_i_3_n_0 ;
  wire \douta[3]_INST_0_i_4_n_0 ;
  wire \douta[3]_INST_0_i_5_n_0 ;
  wire \douta[3]_INST_0_i_6_n_0 ;
  wire \douta[3]_INST_0_i_7_n_0 ;
  wire \douta[3]_INST_0_i_8_n_0 ;
  wire \douta[3]_INST_0_i_9_n_0 ;
  wire \douta[4]_INST_0_i_1_n_0 ;
  wire \douta[4]_INST_0_i_2_n_0 ;
  wire \douta[4]_INST_0_i_3_n_0 ;
  wire \douta[4]_INST_0_i_4_n_0 ;
  wire \douta[4]_INST_0_i_5_n_0 ;
  wire \douta[4]_INST_0_i_6_n_0 ;
  wire \douta[4]_INST_0_i_7_n_0 ;
  wire \douta[4]_INST_0_i_8_n_0 ;
  wire \douta[4]_INST_0_i_9_n_0 ;
  wire \douta[5]_INST_0_i_1_n_0 ;
  wire \douta[5]_INST_0_i_2_n_0 ;
  wire \douta[5]_INST_0_i_3_n_0 ;
  wire \douta[5]_INST_0_i_4_n_0 ;
  wire \douta[5]_INST_0_i_5_n_0 ;
  wire \douta[5]_INST_0_i_6_n_0 ;
  wire \douta[5]_INST_0_i_7_n_0 ;
  wire \douta[5]_INST_0_i_8_n_0 ;
  wire \douta[5]_INST_0_i_9_n_0 ;
  wire \douta[6]_INST_0_i_1_n_0 ;
  wire \douta[6]_INST_0_i_2_n_0 ;
  wire \douta[6]_INST_0_i_3_n_0 ;
  wire \douta[6]_INST_0_i_4_n_0 ;
  wire \douta[6]_INST_0_i_5_n_0 ;
  wire \douta[6]_INST_0_i_6_n_0 ;
  wire \douta[6]_INST_0_i_7_n_0 ;
  wire \douta[6]_INST_0_i_8_n_0 ;
  wire \douta[6]_INST_0_i_9_n_0 ;
  wire \douta[7]_INST_0_i_1_n_0 ;
  wire \douta[7]_INST_0_i_2_n_0 ;
  wire \douta[7]_INST_0_i_3_n_0 ;
  wire \douta[7]_INST_0_i_4_n_0 ;
  wire \douta[7]_INST_0_i_5_n_0 ;
  wire \douta[7]_INST_0_i_6_n_0 ;
  wire \douta[7]_INST_0_i_7_n_0 ;
  wire \douta[7]_INST_0_i_8_n_0 ;
  wire \douta[7]_INST_0_i_9_n_0 ;
  wire \douta[8]_INST_0_i_1_n_0 ;
  wire \douta[8]_INST_0_i_2_n_0 ;
  wire \douta[8]_INST_0_i_3_n_0 ;
  wire \douta[8]_INST_0_i_4_n_0 ;
  wire \douta[8]_INST_0_i_5_n_0 ;
  wire \douta[8]_INST_0_i_6_n_0 ;
  wire \douta[8]_INST_0_i_7_n_0 ;
  wire \douta[8]_INST_0_i_8_n_0 ;
  wire \douta[8]_INST_0_i_9_n_0 ;
  wire \douta[9]_INST_0_i_1_n_0 ;
  wire \douta[9]_INST_0_i_2_n_0 ;
  wire \douta[9]_INST_0_i_3_n_0 ;
  wire \douta[9]_INST_0_i_4_n_0 ;
  wire \douta[9]_INST_0_i_5_n_0 ;
  wire \douta[9]_INST_0_i_6_n_0 ;
  wire \douta[9]_INST_0_i_7_n_0 ;
  wire \douta[9]_INST_0_i_8_n_0 ;
  wire \douta[9]_INST_0_i_9_n_0 ;
  wire ena;
  wire [8:0]p_11_out;
  wire [8:0]p_15_out;
  wire [8:0]p_19_out;
  wire [8:0]p_23_out;
  wire [8:0]p_27_out;
  wire [8:0]p_31_out;
  wire [8:0]p_35_out;
  wire [8:0]p_39_out;
  wire [8:0]p_3_out;
  wire [8:0]p_43_out;
  wire [8:0]p_47_out;
  wire [8:0]p_51_out;
  wire [8:0]p_55_out;
  wire [8:0]p_59_out;
  wire [8:0]p_63_out;
  wire [8:0]p_67_out;
  wire [8:0]p_71_out;
  wire [8:0]p_75_out;
  wire [8:0]p_79_out;
  wire [8:0]p_7_out;
  wire [8:0]p_83_out;
  wire [8:0]p_87_out;
  wire [4:0]sel_pipe;
  wire [4:0]sel_pipe_d1;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[0]_INST_0 
       (.I0(\douta[0]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(DOUTA),
        .O(douta[0]));
  LUT5 #(
    .INIT(32'h00002E22)) 
    \douta[0]_INST_0_i_1 
       (.I0(DOADO),
        .I1(sel_pipe_d1[2]),
        .I2(sel_pipe_d1[1]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram [0]),
        .I4(sel_pipe_d1[3]),
        .O(\douta[0]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[10]_INST_0 
       (.I0(\douta[10]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[10]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[10]_INST_0_i_3_n_0 ),
        .O(douta[10]));
  MUXF7 \douta[10]_INST_0_i_1 
       (.I0(\douta[10]_INST_0_i_4_n_0 ),
        .I1(\douta[10]_INST_0_i_5_n_0 ),
        .O(\douta[10]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[10]_INST_0_i_2 
       (.I0(\douta[10]_INST_0_i_6_n_0 ),
        .I1(\douta[10]_INST_0_i_7_n_0 ),
        .O(\douta[10]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[10]_INST_0_i_3 
       (.I0(\douta[10]_INST_0_i_8_n_0 ),
        .I1(\douta[10]_INST_0_i_9_n_0 ),
        .O(\douta[10]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[10]_INST_0_i_4 
       (.I0(p_11_out[7]),
        .I1(p_15_out[7]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[7]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[7]),
        .O(\douta[10]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[10]_INST_0_i_5 
       (.I0(p_7_out[7]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[7]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[10]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[10]_INST_0_i_6 
       (.I0(p_43_out[7]),
        .I1(p_47_out[7]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[7]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[7]),
        .O(\douta[10]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[10]_INST_0_i_7 
       (.I0(p_27_out[7]),
        .I1(p_31_out[7]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[7]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[7]),
        .O(\douta[10]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[10]_INST_0_i_8 
       (.I0(p_75_out[7]),
        .I1(p_79_out[7]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[7]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[7]),
        .O(\douta[10]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[10]_INST_0_i_9 
       (.I0(p_59_out[7]),
        .I1(p_63_out[7]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[7]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[7]),
        .O(\douta[10]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[11]_INST_0 
       (.I0(\douta[11]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[11]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[11]_INST_0_i_3_n_0 ),
        .O(douta[11]));
  MUXF7 \douta[11]_INST_0_i_1 
       (.I0(\douta[11]_INST_0_i_4_n_0 ),
        .I1(\douta[11]_INST_0_i_5_n_0 ),
        .O(\douta[11]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[11]_INST_0_i_2 
       (.I0(\douta[11]_INST_0_i_6_n_0 ),
        .I1(\douta[11]_INST_0_i_7_n_0 ),
        .O(\douta[11]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[11]_INST_0_i_3 
       (.I0(\douta[11]_INST_0_i_8_n_0 ),
        .I1(\douta[11]_INST_0_i_9_n_0 ),
        .O(\douta[11]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[11]_INST_0_i_4 
       (.I0(p_11_out[8]),
        .I1(p_15_out[8]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[8]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[8]),
        .O(\douta[11]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[11]_INST_0_i_5 
       (.I0(p_7_out[8]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[8]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[11]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[11]_INST_0_i_6 
       (.I0(p_43_out[8]),
        .I1(p_47_out[8]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[8]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[8]),
        .O(\douta[11]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[11]_INST_0_i_7 
       (.I0(p_27_out[8]),
        .I1(p_31_out[8]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[8]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[8]),
        .O(\douta[11]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[11]_INST_0_i_8 
       (.I0(p_75_out[8]),
        .I1(p_79_out[8]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[8]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[8]),
        .O(\douta[11]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[11]_INST_0_i_9 
       (.I0(p_59_out[8]),
        .I1(p_63_out[8]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[8]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[8]),
        .O(\douta[11]_INST_0_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[1]_INST_0 
       (.I0(\douta[1]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T ),
        .O(douta[1]));
  LUT5 #(
    .INIT(32'h00002E22)) 
    \douta[1]_INST_0_i_1 
       (.I0(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ),
        .I1(sel_pipe_d1[2]),
        .I2(sel_pipe_d1[1]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram [1]),
        .I4(sel_pipe_d1[3]),
        .O(\douta[1]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F20)) 
    \douta[2]_INST_0 
       (.I0(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .I1(sel_pipe_d1[3]),
        .I2(sel_pipe_d1[4]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_0 ),
        .O(douta[2]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[3]_INST_0 
       (.I0(\douta[3]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[3]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[3]_INST_0_i_3_n_0 ),
        .O(douta[3]));
  MUXF7 \douta[3]_INST_0_i_1 
       (.I0(\douta[3]_INST_0_i_4_n_0 ),
        .I1(\douta[3]_INST_0_i_5_n_0 ),
        .O(\douta[3]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[3]_INST_0_i_2 
       (.I0(\douta[3]_INST_0_i_6_n_0 ),
        .I1(\douta[3]_INST_0_i_7_n_0 ),
        .O(\douta[3]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[3]_INST_0_i_3 
       (.I0(\douta[3]_INST_0_i_8_n_0 ),
        .I1(\douta[3]_INST_0_i_9_n_0 ),
        .O(\douta[3]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[3]_INST_0_i_4 
       (.I0(p_11_out[0]),
        .I1(p_15_out[0]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[0]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[0]),
        .O(\douta[3]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[3]_INST_0_i_5 
       (.I0(p_7_out[0]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[0]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[3]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[3]_INST_0_i_6 
       (.I0(p_43_out[0]),
        .I1(p_47_out[0]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[0]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[0]),
        .O(\douta[3]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[3]_INST_0_i_7 
       (.I0(p_27_out[0]),
        .I1(p_31_out[0]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[0]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[0]),
        .O(\douta[3]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[3]_INST_0_i_8 
       (.I0(p_75_out[0]),
        .I1(p_79_out[0]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[0]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[0]),
        .O(\douta[3]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[3]_INST_0_i_9 
       (.I0(p_59_out[0]),
        .I1(p_63_out[0]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[0]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[0]),
        .O(\douta[3]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[4]_INST_0 
       (.I0(\douta[4]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[4]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[4]_INST_0_i_3_n_0 ),
        .O(douta[4]));
  MUXF7 \douta[4]_INST_0_i_1 
       (.I0(\douta[4]_INST_0_i_4_n_0 ),
        .I1(\douta[4]_INST_0_i_5_n_0 ),
        .O(\douta[4]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[4]_INST_0_i_2 
       (.I0(\douta[4]_INST_0_i_6_n_0 ),
        .I1(\douta[4]_INST_0_i_7_n_0 ),
        .O(\douta[4]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[4]_INST_0_i_3 
       (.I0(\douta[4]_INST_0_i_8_n_0 ),
        .I1(\douta[4]_INST_0_i_9_n_0 ),
        .O(\douta[4]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[4]_INST_0_i_4 
       (.I0(p_11_out[1]),
        .I1(p_15_out[1]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[1]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[1]),
        .O(\douta[4]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[4]_INST_0_i_5 
       (.I0(p_7_out[1]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[1]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[4]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[4]_INST_0_i_6 
       (.I0(p_43_out[1]),
        .I1(p_47_out[1]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[1]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[1]),
        .O(\douta[4]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[4]_INST_0_i_7 
       (.I0(p_27_out[1]),
        .I1(p_31_out[1]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[1]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[1]),
        .O(\douta[4]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[4]_INST_0_i_8 
       (.I0(p_75_out[1]),
        .I1(p_79_out[1]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[1]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[1]),
        .O(\douta[4]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[4]_INST_0_i_9 
       (.I0(p_59_out[1]),
        .I1(p_63_out[1]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[1]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[1]),
        .O(\douta[4]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[5]_INST_0 
       (.I0(\douta[5]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[5]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[5]_INST_0_i_3_n_0 ),
        .O(douta[5]));
  MUXF7 \douta[5]_INST_0_i_1 
       (.I0(\douta[5]_INST_0_i_4_n_0 ),
        .I1(\douta[5]_INST_0_i_5_n_0 ),
        .O(\douta[5]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[5]_INST_0_i_2 
       (.I0(\douta[5]_INST_0_i_6_n_0 ),
        .I1(\douta[5]_INST_0_i_7_n_0 ),
        .O(\douta[5]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[5]_INST_0_i_3 
       (.I0(\douta[5]_INST_0_i_8_n_0 ),
        .I1(\douta[5]_INST_0_i_9_n_0 ),
        .O(\douta[5]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[5]_INST_0_i_4 
       (.I0(p_11_out[2]),
        .I1(p_15_out[2]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[2]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[2]),
        .O(\douta[5]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[5]_INST_0_i_5 
       (.I0(p_7_out[2]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[2]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[5]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[5]_INST_0_i_6 
       (.I0(p_43_out[2]),
        .I1(p_47_out[2]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[2]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[2]),
        .O(\douta[5]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[5]_INST_0_i_7 
       (.I0(p_27_out[2]),
        .I1(p_31_out[2]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[2]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[2]),
        .O(\douta[5]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[5]_INST_0_i_8 
       (.I0(p_75_out[2]),
        .I1(p_79_out[2]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[2]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[2]),
        .O(\douta[5]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[5]_INST_0_i_9 
       (.I0(p_59_out[2]),
        .I1(p_63_out[2]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[2]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[2]),
        .O(\douta[5]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[6]_INST_0 
       (.I0(\douta[6]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[6]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[6]_INST_0_i_3_n_0 ),
        .O(douta[6]));
  MUXF7 \douta[6]_INST_0_i_1 
       (.I0(\douta[6]_INST_0_i_4_n_0 ),
        .I1(\douta[6]_INST_0_i_5_n_0 ),
        .O(\douta[6]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[6]_INST_0_i_2 
       (.I0(\douta[6]_INST_0_i_6_n_0 ),
        .I1(\douta[6]_INST_0_i_7_n_0 ),
        .O(\douta[6]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[6]_INST_0_i_3 
       (.I0(\douta[6]_INST_0_i_8_n_0 ),
        .I1(\douta[6]_INST_0_i_9_n_0 ),
        .O(\douta[6]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[6]_INST_0_i_4 
       (.I0(p_11_out[3]),
        .I1(p_15_out[3]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[3]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[3]),
        .O(\douta[6]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[6]_INST_0_i_5 
       (.I0(p_7_out[3]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[3]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[6]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[6]_INST_0_i_6 
       (.I0(p_43_out[3]),
        .I1(p_47_out[3]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[3]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[3]),
        .O(\douta[6]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[6]_INST_0_i_7 
       (.I0(p_27_out[3]),
        .I1(p_31_out[3]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[3]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[3]),
        .O(\douta[6]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[6]_INST_0_i_8 
       (.I0(p_75_out[3]),
        .I1(p_79_out[3]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[3]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[3]),
        .O(\douta[6]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[6]_INST_0_i_9 
       (.I0(p_59_out[3]),
        .I1(p_63_out[3]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[3]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[3]),
        .O(\douta[6]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[7]_INST_0 
       (.I0(\douta[7]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[7]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[7]_INST_0_i_3_n_0 ),
        .O(douta[7]));
  MUXF7 \douta[7]_INST_0_i_1 
       (.I0(\douta[7]_INST_0_i_4_n_0 ),
        .I1(\douta[7]_INST_0_i_5_n_0 ),
        .O(\douta[7]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[7]_INST_0_i_2 
       (.I0(\douta[7]_INST_0_i_6_n_0 ),
        .I1(\douta[7]_INST_0_i_7_n_0 ),
        .O(\douta[7]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[7]_INST_0_i_3 
       (.I0(\douta[7]_INST_0_i_8_n_0 ),
        .I1(\douta[7]_INST_0_i_9_n_0 ),
        .O(\douta[7]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[7]_INST_0_i_4 
       (.I0(p_11_out[4]),
        .I1(p_15_out[4]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[4]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[4]),
        .O(\douta[7]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[7]_INST_0_i_5 
       (.I0(p_7_out[4]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[4]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[7]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[7]_INST_0_i_6 
       (.I0(p_43_out[4]),
        .I1(p_47_out[4]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[4]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[4]),
        .O(\douta[7]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[7]_INST_0_i_7 
       (.I0(p_27_out[4]),
        .I1(p_31_out[4]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[4]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[4]),
        .O(\douta[7]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[7]_INST_0_i_8 
       (.I0(p_75_out[4]),
        .I1(p_79_out[4]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[4]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[4]),
        .O(\douta[7]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[7]_INST_0_i_9 
       (.I0(p_59_out[4]),
        .I1(p_63_out[4]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[4]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[4]),
        .O(\douta[7]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[8]_INST_0 
       (.I0(\douta[8]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[8]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[8]_INST_0_i_3_n_0 ),
        .O(douta[8]));
  MUXF7 \douta[8]_INST_0_i_1 
       (.I0(\douta[8]_INST_0_i_4_n_0 ),
        .I1(\douta[8]_INST_0_i_5_n_0 ),
        .O(\douta[8]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[8]_INST_0_i_2 
       (.I0(\douta[8]_INST_0_i_6_n_0 ),
        .I1(\douta[8]_INST_0_i_7_n_0 ),
        .O(\douta[8]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[8]_INST_0_i_3 
       (.I0(\douta[8]_INST_0_i_8_n_0 ),
        .I1(\douta[8]_INST_0_i_9_n_0 ),
        .O(\douta[8]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[8]_INST_0_i_4 
       (.I0(p_11_out[5]),
        .I1(p_15_out[5]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[5]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[5]),
        .O(\douta[8]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[8]_INST_0_i_5 
       (.I0(p_7_out[5]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[5]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[8]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[8]_INST_0_i_6 
       (.I0(p_43_out[5]),
        .I1(p_47_out[5]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[5]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[5]),
        .O(\douta[8]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[8]_INST_0_i_7 
       (.I0(p_27_out[5]),
        .I1(p_31_out[5]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[5]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[5]),
        .O(\douta[8]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[8]_INST_0_i_8 
       (.I0(p_75_out[5]),
        .I1(p_79_out[5]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[5]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[5]),
        .O(\douta[8]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[8]_INST_0_i_9 
       (.I0(p_59_out[5]),
        .I1(p_63_out[5]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[5]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[5]),
        .O(\douta[8]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \douta[9]_INST_0 
       (.I0(\douta[9]_INST_0_i_1_n_0 ),
        .I1(sel_pipe_d1[4]),
        .I2(\douta[9]_INST_0_i_2_n_0 ),
        .I3(sel_pipe_d1[3]),
        .I4(\douta[9]_INST_0_i_3_n_0 ),
        .O(douta[9]));
  MUXF7 \douta[9]_INST_0_i_1 
       (.I0(\douta[9]_INST_0_i_4_n_0 ),
        .I1(\douta[9]_INST_0_i_5_n_0 ),
        .O(\douta[9]_INST_0_i_1_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[9]_INST_0_i_2 
       (.I0(\douta[9]_INST_0_i_6_n_0 ),
        .I1(\douta[9]_INST_0_i_7_n_0 ),
        .O(\douta[9]_INST_0_i_2_n_0 ),
        .S(sel_pipe_d1[2]));
  MUXF7 \douta[9]_INST_0_i_3 
       (.I0(\douta[9]_INST_0_i_8_n_0 ),
        .I1(\douta[9]_INST_0_i_9_n_0 ),
        .O(\douta[9]_INST_0_i_3_n_0 ),
        .S(sel_pipe_d1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[9]_INST_0_i_4 
       (.I0(p_11_out[6]),
        .I1(p_15_out[6]),
        .I2(sel_pipe_d1[1]),
        .I3(p_19_out[6]),
        .I4(sel_pipe_d1[0]),
        .I5(p_23_out[6]),
        .O(\douta[9]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \douta[9]_INST_0_i_5 
       (.I0(p_7_out[6]),
        .I1(sel_pipe_d1[0]),
        .I2(p_3_out[6]),
        .I3(sel_pipe_d1[1]),
        .O(\douta[9]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[9]_INST_0_i_6 
       (.I0(p_43_out[6]),
        .I1(p_47_out[6]),
        .I2(sel_pipe_d1[1]),
        .I3(p_51_out[6]),
        .I4(sel_pipe_d1[0]),
        .I5(p_55_out[6]),
        .O(\douta[9]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[9]_INST_0_i_7 
       (.I0(p_27_out[6]),
        .I1(p_31_out[6]),
        .I2(sel_pipe_d1[1]),
        .I3(p_35_out[6]),
        .I4(sel_pipe_d1[0]),
        .I5(p_39_out[6]),
        .O(\douta[9]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[9]_INST_0_i_8 
       (.I0(p_75_out[6]),
        .I1(p_79_out[6]),
        .I2(sel_pipe_d1[1]),
        .I3(p_83_out[6]),
        .I4(sel_pipe_d1[0]),
        .I5(p_87_out[6]),
        .O(\douta[9]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \douta[9]_INST_0_i_9 
       (.I0(p_59_out[6]),
        .I1(p_63_out[6]),
        .I2(sel_pipe_d1[1]),
        .I3(p_67_out[6]),
        .I4(sel_pipe_d1[0]),
        .I5(p_71_out[6]),
        .O(\douta[9]_INST_0_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_norm_sel2.has_mem_regs.WITHOUT_ECC_PIPE.ce_pri.sel_pipe_d1_reg[0] 
       (.C(clka),
        .CE(ena),
        .D(sel_pipe[0]),
        .Q(sel_pipe_d1[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_norm_sel2.has_mem_regs.WITHOUT_ECC_PIPE.ce_pri.sel_pipe_d1_reg[1] 
       (.C(clka),
        .CE(ena),
        .D(sel_pipe[1]),
        .Q(sel_pipe_d1[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_norm_sel2.has_mem_regs.WITHOUT_ECC_PIPE.ce_pri.sel_pipe_d1_reg[2] 
       (.C(clka),
        .CE(ena),
        .D(sel_pipe[2]),
        .Q(sel_pipe_d1[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_norm_sel2.has_mem_regs.WITHOUT_ECC_PIPE.ce_pri.sel_pipe_d1_reg[3] 
       (.C(clka),
        .CE(ena),
        .D(sel_pipe[3]),
        .Q(sel_pipe_d1[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_norm_sel2.has_mem_regs.WITHOUT_ECC_PIPE.ce_pri.sel_pipe_d1_reg[4] 
       (.C(clka),
        .CE(ena),
        .D(sel_pipe[4]),
        .Q(sel_pipe_d1[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[0] 
       (.C(clka),
        .CE(ena),
        .D(addra[0]),
        .Q(sel_pipe[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[1] 
       (.C(clka),
        .CE(ena),
        .D(addra[1]),
        .Q(sel_pipe[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[2] 
       (.C(clka),
        .CE(ena),
        .D(addra[2]),
        .Q(sel_pipe[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[3] 
       (.C(clka),
        .CE(ena),
        .D(addra[3]),
        .Q(sel_pipe[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[4] 
       (.C(clka),
        .CE(ena),
        .D(addra[4]),
        .Q(sel_pipe[4]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init \prim_init.ram 
       (.DOUTA(DOUTA),
        .ENA(ENA),
        .addra(addra),
        .clka(clka),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized0
   (DOADO,
    clka,
    \addra[16] ,
    ena,
    addra);
  output [0:0]DOADO;
  input clka;
  input \addra[16] ;
  input ena;
  input [13:0]addra;

  wire [0:0]DOADO;
  wire [13:0]addra;
  wire \addra[16] ;
  wire clka;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized0 \prim_init.ram 
       (.DOADO(DOADO),
        .addra(addra),
        .\addra[16] (\addra[16] ),
        .clka(clka),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized1
   (\douta[1] ,
    clka,
    ena,
    addra);
  output [1:0]\douta[1] ;
  input clka;
  input ena;
  input [16:0]addra;

  wire [16:0]addra;
  wire clka;
  wire [1:0]\douta[1] ;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized1 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .\douta[1] (\douta[1] ),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized10
   (p_71_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_71_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_71_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized10 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_71_out(p_71_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized11
   (p_67_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_67_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_67_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized11 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_67_out(p_67_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized12
   (p_63_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_63_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_63_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized12 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_63_out(p_63_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized13
   (p_59_out,
    clka,
    ena,
    addra);
  output [8:0]p_59_out;
  input clka;
  input ena;
  input [16:0]addra;

  wire [16:0]addra;
  wire clka;
  wire ena;
  wire [8:0]p_59_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized13 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .p_59_out(p_59_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized14
   (p_55_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_55_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_55_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized14 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_55_out(p_55_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized15
   (p_51_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_51_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_51_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized15 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_51_out(p_51_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized16
   (p_47_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_47_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_47_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized16 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_47_out(p_47_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized17
   (p_43_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_43_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_43_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized17 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_43_out(p_43_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized18
   (p_39_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_39_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_39_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized18 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_39_out(p_39_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized19
   (p_35_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_35_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_35_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized19 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_35_out(p_35_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized2
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized2 \prim_init.ram 
       (.DOUTA(DOUTA),
        .ENA(ENA),
        .addra(addra),
        .clka(clka),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized20
   (p_31_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_31_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_31_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized20 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_31_out(p_31_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized21
   (p_27_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_27_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_27_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized21 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_27_out(p_27_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized22
   (p_23_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_23_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_23_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized22 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_23_out(p_23_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized23
   (p_19_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_19_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_19_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized23 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_19_out(p_19_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized24
   (p_15_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_15_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_15_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized24 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_15_out(p_15_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized25
   (p_11_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_11_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_11_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized25 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_11_out(p_11_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized26
   (p_7_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_7_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_7_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized26 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_7_out(p_7_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized27
   (p_3_out,
    clka,
    ram_ena,
    ena,
    addra);
  output [8:0]p_3_out;
  input clka;
  input ram_ena;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [8:0]p_3_out;
  wire ram_ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized27 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .p_3_out(p_3_out),
        .ram_ena(ram_ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized3
   (\douta[1] ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ,
    clka,
    ena,
    addra);
  output [0:0]\douta[1] ;
  output \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ;
  input clka;
  input ena;
  input [16:0]addra;

  wire \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ;
  wire [16:0]addra;
  wire clka;
  wire [0:0]\douta[1] ;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized3 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram ),
        .addra(addra),
        .clka(clka),
        .\douta[1] (\douta[1] ),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized4
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized4 \prim_init.ram 
       (.DOUTA(DOUTA),
        .ENA(ENA),
        .addra(addra),
        .clka(clka),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized5
   (\douta[2] ,
    clka,
    \addra[15] ,
    ena,
    addra);
  output [0:0]\douta[2] ;
  input clka;
  input \addra[15] ;
  input ena;
  input [14:0]addra;

  wire [14:0]addra;
  wire \addra[15] ;
  wire clka;
  wire [0:0]\douta[2] ;
  wire ena;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized5 \prim_init.ram 
       (.addra(addra),
        .\addra[15] (\addra[15] ),
        .clka(clka),
        .\douta[2] (\douta[2] ),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized6
   (p_87_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_87_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_87_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized6 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_87_out(p_87_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized7
   (p_83_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_83_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_83_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized7 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_83_out(p_83_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized8
   (p_79_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_79_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_79_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized8 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_79_out(p_79_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_zrn_blk_mem_gen_prim_width__parameterized9
   (p_75_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_75_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_75_out;

  blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized9 \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .ena(ena),
        .ena_array(ena_array),
        .p_75_out(p_75_out));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire CASCADEINA;
  wire CASCADEINB;
  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ;
  wire [31:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hC026FD14707FA61E0769F1FE30007FFFE67000000001C7F819FF9DC000000000),
    .INIT_01(256'hF0070F3F1BFCE00007FFFE7F800000001E7E01FFDC7E0800000000280083C7C7),
    .INIT_02(256'hC608600FFFF7FC00000000C3E01EF8A2A0000000000E00080E7E7004B7D120FF),
    .INIT_03(256'hFFFC000000000FE001D31D00000000008000C0E6FE1BB59A1809FC388B700067),
    .INIT_04(256'h00FE383E08A00000000089800E0FEFE0208A598F9E30106D20307FF002001FFF),
    .INIT_05(256'h80000000005800F0FEF9DCF6C1B9FEE5427DE487081F8000001FFEFFE0000000),
    .INIT_06(256'h808F1FC91BC4E370FFF06C2E7358FC73FF000030DFEFFF00000003FFF1CBE608),
    .INIT_07(256'hBFA7BFFFD985F229C83F2E040002C01E7FFE0000001FF81E02210A0000000015),
    .INIT_08(256'h203FFF7DD3800000380087F7F8000000FFFDF001314000000000680BE1FF3988),
    .INIT_09(256'h00000000807FFF8600001FFF87001C8D0000000006065F1EFB14DFEC79FF7801),
    .INIT_0A(256'hFFFDF00001BFF03E0088D8000000013425F1E7F2D3FC479FE3007C8787CFCFA0),
    .INIT_0B(256'hFFC3E00801000000001741FF1E5F6E5FBE7FFE20079878101CF2600000001C07),
    .INIT_0C(256'h20000001F07FE1E1CCDDC7F7FFE800E3870001C47F10003FC00027F9FFC0000F),
    .INIT_0D(256'h7E1A095E9D7C3FFF880EF867003C4FC6803FFE030747DFFE00007FFF3B008072),
    .INIT_0E(256'h07CFF8C30201F80331FC78431F020031BFFFF00007FFFFBC00BA100000001C87),
    .INIT_0F(256'hFF8001C0FF00008073E04BFFFF80003F67FBF80B70800000015A7DC3AC9B3627),
    .INIT_10(256'hF0000FFFC63F9FF80001EE0FFFC8D99A00000017A69C80C3B6C490F9FF9C2000),
    .INIT_11(256'hF9DFC01E00F83FFC43E8F0000000682BC04CFE99838E1FEFE1107FFC000F8FE7),
    .INIT_12(256'hF7FFFD5743C0000032129BB4CD5FA34BC1FEFFC33FFE0F0003FF860061FC3F83),
    .INIT_13(256'h0000026F0EF8BD9A845753DFFFFBC3FFC00E1E11B980000D9F080418FFF1FFFF),
    .INIT_14(256'h6A43A84B3983FFF03C7FF801FFFE7C000087338080008FFFFE07E77FFFE5F910),
    .INIT_15(256'hCFFE03CFFF1FFFFFCF078003FA76060008FFFFE0003FFFFEDFEF00000066F3BC),
    .INIT_16(256'hFFE7E3E1F0006FCF7F386E0CFFFE0003DFFFF7FF28000006BBDC8E22799E93BF),
    .INIT_17(256'h1CFFC6F8C3F607FFF03818FFF94FFCC000004A1820F0073BD166FDFEC07FFFE3),
    .INIT_18(256'hF87FFE078007FFFDFF4400000501721FC2B43E3DFFFBE6FF3EFCFFF87CFC8040),
    .INIT_19(256'h3FFFBF7E000000DA8F21F0E7C3BCDE3FF87FF7EFFFFF807C01FC03FFFCE0A703),
    .INIT_1A(256'h000BFCE01F0D8037A7E7FF03FFFFFFFFFE07C0FE00CF7F37F97E3260FFF01202),
    .INIT_1B(256'h4996BCFC3E617FFFFFFFFFE01E3E0070F4351F277A7303FFF80073FFFBF2F400),
    .INIT_1C(256'h3FFFFFFFBFFE00E18C060F98DD82C06C0C0F7FE0FF3FFFD7EE20023FB9A701F5),
    .INIT_1D(256'h019CF1D04964EEAFF34835B203FC07F1FFFC6ED81001FA33781FD2A9DB8FC1BC),
    .INIT_1E(256'h7AC0E20933A0383FE0361FFFE87E61000F86C4C7F15BC2609C1B07FFFFFFFFFF),
    .INIT_1F(256'h28003F0000FFFE33A200000DCB1C7F530A8801FFF0FFFFFFFFFF603987007E6B),
    .INIT_20(256'hFFF33CF000005CF877D74B7D7CFFFF1FFF8FFFFFFE0000800FC190E86D3EC033),
    .INIT_21(256'h05CB9739B7763BCFFFFBFFF9FFFFFFC043DFC1BC1C8200AFF211DB4000F80007),
    .INIT_22(256'h38E7FFFFFFFFFFFDFFF83FFFCE11C7382609FF10C62A000FE0003FFF3FF98000),
    .INIT_23(256'hDFFCFFFFEFFF18C63CA7CC6E7FF1F21A90007E0001FFFBFDC0401F6939D18595),
    .INIT_24(256'hE1C18014FF3EFFF9CFF1D68000F0000FFFD5E4C001FE370C9A4CE8A0FFFFDFCF),
    .INIT_25(256'h787FFE2F9934000F10007FFDDDF84018E63168C5367027FFFDF9F9FF07FF0FE7),
    .INIT_26(256'hA0007F8047FFFFDEE6023D73378ED04618797BFFFFFFF80FFF7C7838F8025C7C),
    .INIT_27(256'hFFFDB440139323702C48B90F933FFFFFFF80FFF77F801980CD8F38061FD57445),
    .INIT_28(256'hA03001CF001FF923FFFFFFF81FFFEFF807FF8DC38400C4F837A09D1001F8003F),
    .INIT_29(256'hB714F3E3FF8303FFF8FF803FFC98638C1CCFC13C27E90067F001FFFF93B4319B),
    .INIT_2A(256'h007FFC3FF821F79906F7E18FFC84D5EE40031F800FFFFD340180AC01015F14B6),
    .INIT_2B(256'hF8F270E67F10FFF9BECFE60438F800FFFFD1D80105001839FEFE4FF83EFC1FF0),
    .INIT_2C(256'h1BFF15D9DFB041CFE00FFFFDEA80006C4700DED3A9BE8DFDC1FC001FFF8FFFC0),
    .INIT_2D(256'hDC00FF007FFFDED10066C6F01DA3D355F49FFC3F0003FFFBFC7E1E184E0C67B1),
    .INIT_2E(256'hFDEED004507F11DB2092DC99FF7E80007FFFFFE7E3C30DE1C601113FF23714B5),
    .INIT_2F(256'hF11588026F9BFFE380000FFFFFFFFC70633E1C700007FC0094495FC031F807FF),
    .INIT_30(256'h3FFC780001FFFFFFFE0F1CEFE1C7C0007F8091CEC1FC039FBC7FFFFE440184AF),
    .INIT_31(256'hFFFFFFC1F38DFE3C3C001CFC0957FEAFE019FFE3FFFEFF03186AFF7C858386E0),
    .INIT_32(256'h99E3838003C1C01B9FA57F00CFFE3FFF6FEE300CB3FE5B5208D81FFF9F80003F),
    .INIT_33(256'h04005FFF0BF80E7FC3FFF6FE430E4B3FE0A66B0813FFF9F8000FFFFFFFF80678),
    .INIT_34(256'h80707C3FFFEFEB00E2F3FE2A5BA4A1BFFFFF0001FFFFFFFF400F90187879C03E),
    .INIT_35(256'hDEC81F327FE43C878BFDFFFFE0001FFFFFFFE401EA0267C3FF03F00002EFEA5F),
    .INIT_36(256'h330F3CF546FFF8000FFFFFFFFE00EC44C67C1DF03F8600DF7294601307C3FFFE),
    .INIT_37(256'hFF0003FFE7FFFEC01F18580FE1DFC1FC70007BB4E300907C7FFFF9F4858FE7FE),
    .INIT_38(256'h7FE003E70F81FE1FFF07C1000BBBCE100880E7FFFF9D7040FA7FE23C864F8CFF),
    .INIT_39(256'h1FE1FFFC7E00007DFA71800E067FFDFCF040059FFE639560FFFFFF80003FFEFF),
    .INIT_3A(256'h0007CF978800E067FFDFE774044ABFEE7D5607F9FFE0000FFFFFFFF8007FE0F8),
    .INIT_3B(256'h0F03CFFDFFF9A0E4A4FFC814507FDFFE0000FFE7FFFF000C140F03FE1FFFC7E1),
    .INIT_3C(256'hEE008F27FBE92507FCFFC0000FF87F9FF800B783E07FE0FFFE78000066F7FFC0),
    .INIT_3D(256'hC329FFFFF80007F807F3FF80B071FC07FC03FFFF80000517FFFC007038FFFFFF),
    .INIT_3E(256'h00FF007C7FE01C0C7F80FFC03FEFF80000713E7DA0070187FFFFFE800073F188),
    .INIT_3F(256'h030CBEF00FFC03FE77C0000013E3D20078107FFFFFF0007EB8DE71DB7FFFFD00),
    .INIT_40(256'hC03FF81C0000080E3E20078107FFFFE72008CBF8D3FFBFFFFFD00007E03F8FF8),
    .INIT_41(256'h0360E7E300381B3FFFFFA901B171CBABF5FFFFFF0001FE0FE0FF046FC5FE007F),
    .INIT_42(256'h80FBFFFFF8101B4BF4597E0EFEEE70003FE7FC1FE009B1FC8003F403FF81C000),
    .INIT_43(256'h83D638E74BE77FFFE60007FFFF87F801B85D80023E00FFF9FC00003A077E3C41),
    .INIT_44(256'hFFF9FE40007FFFF0FF00271BF00067E01FFFFFC00000FC77F1E41C2FBFFFFFF5),
    .INIT_45(256'hFFFC1FE00523400007FC01FFE3FE000005C7BB8E41C27FFFFFFF583E9810AA34),
    .INIT_46(256'h6E000E3F801FFE1FE0000026799CDC3C67FFDFFCFBE13502425EBE1E1E70000F),
    .INIT_47(256'hFF80FE000002679DD783E47FFDFFFE9E03D9FFCFC9BDFFFE0000FFFFE3FC03D6),
    .INIT_48(256'h1278CF7C3E06DFFFFFA0E0D50125D3153F3FC0800FFFF87F8068FBE001E3F001),
    .INIT_49(256'h6CFFFFFA060E041FEEC163F3F00000FFFF1FF81F9AF0003FFF003FFC1FF00000),
    .INIT_4A(256'hD1DE6DA2507FFF00001FFFF1FF021F500003FFE007FFE7FF00000133C8E3C1E2),
    .INIT_4B(256'hFFE001FFFFFF1FF001FA00001BFC00FFFC7FF000000ABEAE1F0F34CFFFFFA060),
    .INIT_4C(256'h63FE0C23480011BFC00FFF9FFE0000008BE641E09144FFFFFFE6017DE6335437),
    .INIT_4D(256'h803FF800FFF9EF800000067E231E0D044FFFFFFAE0B1ABC91C43CDEE001FFF1E),
    .INIT_4E(256'hE7F800000025E230F0C244FFFFFFFE011F3C2CED1C7CE000FFF0C0FFE18149C1),
    .INIT_4F(256'h5E230F64905FFFFFF170F7588AD2F1E4DC001FFE0C0FF1606A18039FFF801FFF),
    .INIT_50(256'hFFFFFF630F051F02AB1E7DC000FFF3C1FF8607218000FFF003FFFEFF00000002),
    .INIT_51(256'h82099107E7DC0003FBF01DFCF817F00000FE00FFFFFFF000700022E5197E691F),
    .INIT_52(256'h00007F3C1FDF1F87FF81807FE07FFFFFFC000F00026F0193E651FFFFFFF6207F),
    .INIT_53(256'hE7F0DFF87C3FF807FFFFFF8001F00037782C9F653FFFFFFF5A033CD04E90FC7E),
    .INIT_54(256'hFC003FFFFEF0001F000747C26CE012FFFFFFDAA0EC8442C3FF8C8C001FE7C1FD),
    .INIT_55(256'h0001F00070BC320E132CFFFFFF973342CC19F3F9C80001F8703FDEFF198E0FFF),
    .INIT_56(256'hD1A061723FFFFFFF73740C61FF3F1DB0003F8F0FFFCEC300C0FFFF8003FFFFC0),
    .INIT_57(256'hFFFFEF10C044D74FC3F30007F0E1FFFCCC247C0FFFF0200FFFE000000F9E0F9B),
    .INIT_58(256'h03EDFC7F9C007F1C1F1380C20FE0FFDE0300FFC0000001FFE0F9BF9D061523FF),
    .INIT_59(256'h0FF3C078383861FF0FF041200F000000001FFFBF9FE9D062303FFFFFFEC0C263),
    .INIT_5A(256'h9C7FC1FC003FF800000F00019FF9F95E3D03770BFFFFFFD00C193CE09F87FC00),
    .INIT_5B(256'hFF81807FF80019FF0F95E3C83FA4CFFFFFFD207F300383F07EE001F800000F83),
    .INIT_5C(256'h0FFFE0FC2F3C83FE54FFFFFFD20212384BBC07C6003F000601F873C7F03F8003),
    .INIT_5D(256'hE43FC5AFFFFFFC300C2E12D7C1F80007F0003C3F87787F0FF80039001FDFFFF0),
    .INIT_5E(256'hFFCA014B994C9E1F8000FE0003E7F0E5CFE0FF80038007FFFFFF87FFFC1FDAF0),
    .INIT_5F(256'hDDE3F8000FE000007F0E1C780FFC000003FFFFEFFFFFF1FFFDF71643FE9AFFFF),
    .INIT_60(256'h00000FF0C3C700FFFFC041FFFF003DFFFF0FFF9779725FCD8FFFFEFD0012F810),
    .INIT_61(256'hE01FFFFFFFFFE000000FFFF07FF9779325FD59BFFFE7D6011FD03BBC3F8001F8),
    .INIT_62(256'h00FFFE0000F7039F905CB24FD311FFFC7C2020F933EBC7F0001E000000FF1871),
    .INIT_63(256'h30018104CD16FF30DFFFC7C00714539DCCFF0007E000000BF18C3801FF803800),
    .INIT_64(256'hE7E3ADFFFE3C315B4C33F4FFF0007E0000001F1183801FF00479E180003E0000),
    .INIT_65(256'hCE11EDC24A9FFF00078000007FF37C7F01FF0FF81FFFFF81FE01000000104ED1),
    .INIT_66(256'hFFE00070000007FE279FF078E7007E003FFFCFFC00000001846E1B7E394FFFE3),
    .INIT_67(256'h007FE273FF0E2102181F8000FF21F800061FFA40ED1BE152FFFE3CC93104E0F9),
    .INIT_68(256'h06CFFB1FFF7F00180FC000F1FF7E1EC9BF15AEEFE7C882AF8F3FFFFE00060000),
    .INIT_69(256'hFFC4FE1CE00FFFC4E0EE9BF8BFEEFF7C0C07E94BBFFFE00060000007F8673FF0),
    .INIT_6A(256'hFFE3804109BF868E6FF7C7C3A330317FFC000C00000DFF84603F00A7FFE3FE1F),
    .INIT_6B(256'hFC74C3FF7C7D34B692B7FFC004000000FFF8CE01FFF73F81FFC077FFF7F1FF00),
    .INIT_6C(256'hD2EB190FE7FC00E000000FFF09C03FF9E0003FF00003FF018FF03FF0E11FEF83),
    .INIT_6D(256'h800E00000073F0B807FE60C7C7F800001FFE1C1F87E0383FEF07FFC3FC1FF7C5),
    .INIT_6E(256'h3F3B007F183CFC6F0000007BF8C1FFFE0783E4FFFF072E49FF7C4621B1E07C3F),
    .INIT_6F(256'hFF00F9000003FF8E1FFF00F9F00FFFE01B359FF7C400B8960703F801E0000000),
    .INIT_70(256'h3FF8F8FFF0383E004F3000F54BFF7D4008E358EDFF003E00000003E73000060F),
    .INIT_71(256'h87C0003F6002483FF7D406522505BFF007E0000003FC770C0041FF3C0CF80000),
    .INIT_72(256'h028DFF7D40A24278F1FF00780000007FC6E40018FF0FE707F00003FFC3CFEE07),
    .INIT_73(256'h5C208ADF600F00000083FC5EC0023F07010E0F00003FFE1CFFE0F1F800104700),
    .INIT_74(256'hE000001C3F8DE4004FE7C63E073180003FF18FFF0C3E00038070002ADFF7C22E),
    .INIT_75(256'hBC000DF9F9C29C9DFFC183FF19FFF1C3E000100F0001BDFF7CA66341800DE400),
    .INIT_76(256'h01D4C1FE7C7FE33F3F1C7E00000000001DDFF3CA0EDC12007E401E00000381F0),
    .INIT_77(256'hFC6781E18FF00000000009FDFF3CB175206027FF01C00000303F158007303830),
    .INIT_78(256'h00001F80008FDFF3C907600FFE7FD0180000000FE0C000C0070603E09B9BFFC7),
    .INIT_79(256'h65FFBCB0E300FCCFEC8100000000FE2800081FE0F03E03661FFCFFCE601E19FF),
    .INIT_7A(256'h1F85FE780000000003C510333FF81F80F01990FFFFF8CE00E18FFF003FFFC008),
    .INIT_7B(256'h000E003CEFF34E0F83FE0FEF8DC7FFFF99C00718FFE007FFFFE0075FFAC37C10),
    .INIT_7C(256'h05E7F803F03FF85E3FFF833C3C798FFF00FFFFFFFC347F8E320601F9FFCF1800),
    .INIT_7D(256'h040DC3FFF866028398FFFC0FFFC7FFE347FDEB02463FFDD8F1800001800308FF),
    .INIT_7E(256'hC000398FFFFFFFE07FFF14FFDEB004CFFFF99C1800006003715FF0FC7FC00F00),
    .INIT_7F(256'hFFC6023E395FFFCB8EFDFFFE1381000004001F09FF1F0FF8FC7E3FF9CC1FFF8E),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("LOWER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(CASCADEINA),
        .CASCADEOUTB(CASCADEINB),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED [31:0]),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hFBFCF9FDDFFFE8F00000000001F21FF3807F1F81CCF068C03FF1C87C03987FFF),
    .INIT_01(256'hFDBE00003000001E57DF000007E1B11ECF5F03FF3987FC0CC7FFFFFC038041DD),
    .INIT_02(256'h0003CCF0F0400FFFCBC79E55303FE733FFF06E7FFFFFB03E000F1F9FD4911FFF),
    .INIT_03(256'h19F18EEABD6D7A07FC6663FF0667FFFF82F8200071F8FD092EFFFFCFE0000200),
    .INIT_04(256'hA8D07FC667F9F8667FFFFBAFC700031F0FC678AFFFF1FE00000060003DAF1E08),
    .INIT_05(256'h038643FFFDA940F00031E0F85CEAFFFC3FC000000C000399F9E083F80783AB00),
    .INIT_06(256'hB7FF80211F1F828DEFCFD3FC0000000000315FDE103981E0AE4FC3EEFFF864FC),
    .INIT_07(256'hFBBA82FCFB7F8000000000071BFDFA0780F19F7FFFF613FF06CC001C363FF800),
    .INIT_08(256'hFF000000000FE27FDFE0781C37673F9C019FF86CC0E1E163FF8087C63803E1F1),
    .INIT_09(256'hFE5FC1F0078380C7FFFE4004A046D87E0F133FF84388E6000E3FBF9BC5EFCFFC),
    .INIT_0A(256'h7840FFFEFDC44F00CD87F079B3FF390E8BDE00E3FFFC2F94FDF61FE000000000),
    .INIT_0B(256'h3C7819987F87C99FF2030C36601FAFFE52A7C7FF19FC000000000FE6F81F0078),
    .INIT_0C(256'h3EC9FFD13B43530BFAC7EDEFE1FFF7AFC000000001FC7F01F0378F3C0E7FFFD6),
    .INIT_0D(256'h9D083DEC3FCBEE1FFEFC60000000003FD1F01F0770F7A3A23CFF3BC7823987FC),
    .INIT_0E(256'hF74BFF4F9B2000000007F9FF80F8721FE61C6FFFE29EE0C798FFC3ED9F774FFE),
    .INIT_0F(256'h0C0000001F97F80F806381BF97FCFC31F072F1CE1C1E53FC01FFF9AB40FDFFFC),
    .INIT_10(256'h1E00FF073003F83FDFC10B1EFC1CE1E0ED3F80F9FFE48607DFFF8B7203F8FF00),
    .INIT_11(256'h800377F810390903C61E0ED3F8783E3FCF303C7FF888B83F1FF001FF000001F9),
    .INIT_12(256'hFF00FC70E0ED9F8FFFFF3E5903E7FFDB3F33F1FE00058E00001FA9E00FFC3300),
    .INIT_13(256'h4CF5FBFFEC73C03E7FFDF3DF3FFFE008F678000FF39E00FFF3B000031FFF9381),
    .INIT_14(256'h8C81FFFFCCF487FFF80015070003FF39F7001F8F1E07FF9C01FE07C03FC7060E),
    .INIT_15(256'h0F7FFF80198070007FF11FF8000FFF300C1FC61C3CA887FE307066E03FFFFF9B),
    .INIT_16(256'hC733FFFE50FFC00007F99F22E19C06021FFFE303062377FFFFD0DE7C0C3FFECF),
    .INIT_17(256'hFC0063C022F0025B879F27FFFE30386319DCE07D05F340CBFFEFD866FFFC018F),
    .INIT_18(256'hC6C0678F9FFFFFE313861867F80FD02FB40EFFFEF996EDFFE009F477FFFFE587),
    .INIT_19(256'h7CFF191C70FCD980DD22F980E6FCEE099807FE00940FFFFFFE9C7FC00FF03E58),
    .INIT_1A(256'h93F27391CFD80E2FFEB851C2DFE001E1FF1FFFC9E3F807F007293C0DFFF81580),
    .INIT_1B(256'hC0E2FFE949439DFE001E1FFFFFFC9F1FE0FC0016D3FF3FFFF4E40381E398C707),
    .INIT_1C(256'h3BFFF000F1FFFEDF89F1FE0F8000EE9DDFFFFE80F0181E39E43000814E33F8FC),
    .INIT_1D(256'hFF99E09F1FE0F8000E14D81FFF2AFFF001C79E638029A8024300C40E5FFE94D6),
    .INIT_1E(256'h0FC0007E57FFC7F49EFF801C79F63806D73E3E61E041E5FFE8BE6B37F601070F),
    .INIT_1F(256'hFFF6A707F800871343C07D3EF81E1F061E7F7EA5A420FE4010787FF19E09F8FF),
    .INIT_20(256'h00F3141C0F76C7F01FFC61E7F7EE64C01DF00107C3FF9FC19FCFF0FC0000396F),
    .INIT_21(256'h2A0F80007C1E5F7EE7481F3F80197E0FFFF811FC3F1FC00000190FE3BD81FFC0),
    .INIT_22(256'hA1FFEB1603F7F801DFE07FFF800FC0F1FC001FFF9F0387001FFC000F214180F8),
    .INIT_23(256'hFF831DF603FFFE007E070FE007FFC7FFE0000601C001F2561C0FC390FFFC0181),
    .INIT_24(256'hFFE217F1F0FF00FFE000001F80F00E003F1661E3F8248E7FF0001F1FFBA2E033),
    .INIT_25(256'hF00FC000000FF07F80E007F1660FFF8D97C3FF8003F1FFB336622FBC00FF007F),
    .INIT_26(256'hFE0FF01E407F1660FFF865CE01FC00651FFB372C32F94007F001FFFE20FF1F0F),
    .INIT_27(256'hF1660FFFC31A1807E0FCB2E3F25E1A3FE4023F821FFFE00C30307F01FC007187),
    .INIT_28(256'hD9187F1FED2E3F28A401FE4020F87FFFFF00038387F01FC007FFFDE1FE01EF8F),
    .INIT_29(256'hE5F29A039BEC003FC3FFFFD90038187F00FC00FFFFFC1F80FDFE7F1670FFFC18),
    .INIT_2A(256'hE00FF00FFFBC3807C183FC0FC01FFC1F80F81FCFE7F16707FFE1C6608E01F772),
    .INIT_2B(256'hE3C01E181FE07E01F187E03FC3F87E3F96707FFE1C21B6030E562FCF2624772F),
    .INIT_2C(256'h03F03F9FF007FC3F83E1F96701FFE0C1CA38301AC2FCB66D4373F601FE00FFF1),
    .INIT_2D(256'hFF07F83E1F96700FFE040A501E7E1E1F906E92AFFF603FE01FFF3C1C01E1C1FF),
    .INIT_2E(256'h16001FF01052807C38F4F804DC2AEFF41FFCE3FFF381EC0F1E0FF01F81FFF800),
    .INIT_2F(256'hB401FF8447804DC8EDFFDB3FD33FFEFA17C0F8E0FF01F80F9E001FC07F87E1F8),
    .INIT_30(256'h04F19EDFFFDEDADBFF8FE07C0F8607F00F80200003FC07C07C0FC960007F0000),
    .INIT_31(256'hEFE6FFF07E83E0FC707F00FC000000FFE07060007E660007F00015A003F80878),
    .INIT_32(256'h3FCFC707F80FFC0000FFFC1E000003E6C0003F00C0BD203FC08785CD990FFFFC),
    .INIT_33(256'h7FF000FFFFC7C000000E6C0007F00E0DE80FFF08791C11103CFFEEFF97FE07E4),
    .INIT_34(256'hF007FFE02847C0FF80602F41FFF08791C31080CFF79F7EBFE0FE43FCFC307FC0),
    .INIT_35(256'h7E3FF8000349FE3F987B5EB3088FFE19F3CBFD0FC43FCFC30FFE07FFFC1FFFFF),
    .INIT_36(256'hE731398795C8F18D77F0FF03FF31FC43FCFE30FFE03FFFFFFFEFFE0FFFFF0298),
    .INIT_37(256'hA58CC33F9F907FE01FC43FE7E183FE03FFFFFFFDFF8780FFF81687FFFFC00013),
    .INIT_38(256'h07FF00FC89FE3F181FF00FFFFFFF9FF9C61FFFC348FFFFFE0001BB031BD8796F),
    .INIT_39(256'hE1F0C0FF007FC00001FE2773FFFE1B3FFF81F000199C39FCA394BB91AF37FDD8),
    .INIT_3A(256'hF00000060D1B73FFF0C3F3F8038000CE738FCA3958BF1C7E7F9FF67FC00FF99F),
    .INIT_3B(256'hAC0FFFC0F81FBE1F000363B8FEA3854331C7E7F8E767FC19FFB8FE1F0E0FF801),
    .INIT_3C(256'hFA99FE003371FFEA38D67B3DFEAFFE30FFD23FF901E1F8607F8000000000072F),
    .INIT_3D(256'h8FFE638D07D36FE04FE10FF817FF901E1FC703FE000000003F8D1500FFFFFF01),
    .INIT_3E(256'h3EFF887F61FF00FFFF03E1FC781FE00000FFFFE731A01FFFFFC00F6ECFFF01BF),
    .INIT_3F(256'hF019F7F03E0FC7C1FF80000FFFF88C0601FF0F800064B27FF80DFCF3C679D0FB),
    .INIT_40(256'hFE3C0FFFFFFFFFFC37835E3FC00000035993FF806E6F1C679D1B73EF1DCF961F),
    .INIT_41(256'hFFFC0E434FE7E03000001A8C9FF82332F8C679C0777EE0D5F96FFE01BE7F03E0),
    .INIT_42(256'hF01F8007C19C741FFA13F1DCE79C8D37154EDF94FC6057EFF81E07E3807FFFFF),
    .INIT_43(256'h41607FFFBF0EE6F9E07DD4EDB0FF8FC0123CFF80307E7803FFFFFF98019CF2FF),
    .INIT_44(256'hFE6FBA576D4EC3ABF01C0213CFF81F0FC3C001FFFFF000F30F0FFC7F9FFFFFCD),
    .INIT_45(256'hEC387F0FC00138FFC1F0FC1E00004020007CE1D07E0C000F000EF80B027FFBF8),
    .INIT_46(256'h1387FC0F0FE1F000000001FF387F200F3FFE020027E8DC03FF8F9FE6FB1BF714),
    .INIT_47(256'h0F800000003F860FF3BE78007FFFFD3886F8003838FEFFB13F79CEC183B67980),
    .INIT_48(256'h0781FF40E7FFE0380069C823E00083C7E9FBC0739CE9193B600000387FC070FF),
    .INIT_49(256'hFFF0000333019F00007E0C9FFC0F0C6C999B1080000387FC0F05F03FFFFFFFFE),
    .INIT_4A(256'h0CFFF80FE009FF90ACC2D9DDB18C8000387FC0F01F01FFFFFFF8C3C13FD9C3FF),
    .INIT_4B(256'h9FF926CC0F9FCF18DC380383FC0F03F80FFE078001F00FFCF7FE07CFE3FE0CB0),
    .INIT_4C(256'hF8C18D7B803C1FC0703FF0000000F77803F9C1DF399C3FFFF0177061FFC0FE00),
    .INIT_4D(256'h71FC0781FF80003FFFFE0FFF9C800402C1FFFFC09F8700FF8FF019FF92FCC066),
    .INIT_4E(256'h003FFFFF007FE00213E0121FFF8886FE1E0FF8FFC79FFA2CEE026F8C586B8007),
    .INIT_4F(256'hFC00387E3D80FFFEF64FF0700FFFFC79FF834EAE1D3C605EBCC0000FC07E1FF8),
    .INIT_50(256'h03FFB1B1FFE1E007DC7F9FFC240AC1818E0B6FC78000FC07E1FFFFFFFFFF800F),
    .INIT_51(256'h8FC00007F1FF8270A0701860B27C00000F807E1FFFFFFCFC0003FF0061FFFFFE),
    .INIT_52(256'hF8A30A0403632B93D80000F807E0FFFE00800001FFE0FF0FE7E1F01FF4F9BFFF),
    .INIT_53(256'h28B2C1DE000F807E0070000000003FFC1FFA3E000F80FF9F9FFFFC7F00003F1F),
    .INIT_54(256'hF807E0000000000003FEC3FFA018007807F798CFFFE1FFFF83F3FF9A80A4507E),
    .INIT_55(256'h0000003F807FCF01C007007F000FFFFF07FFFF1FFFF34A0C0723620D4CA1F000),
    .INIT_56(256'hFC78000FC0003C01FFFFF807FFFC7FFF35A1EB497660949E0FC027807E000000),
    .INIT_57(256'h03C07FFFFFE03C1FC3FFF9391EB45B660874C0FE007807E001F1F3601C03F03F),
    .INIT_58(256'h01C0FE15FFF319C735B4609BE007F007807E003FFFFF43C3FE03FFB7FC00FE00),
    .INIT_59(256'h2B9D673C620BD9203FF83807E001FFFFFFE07FE01FFB7FC001B0083FFFFFFFF8),
    .INIT_5A(256'h1A1601FF83807F007FFFFFFFFFFC01FFAFFE00000001FFFFFFFF800007E01FFF),
    .INIT_5B(256'h07F07FFFFFFFFFFF801FF4BFFE0000001FFFFFF3FC00001F01FF7F4CB7AA47A0),
    .INIT_5C(256'hFFFFF001FF51FFFC000003FFFFFF0FFC0000F01FE7F84A3B27CA01C9E10FF038),
    .INIT_5D(256'hDFFFF000007FFFFFF87FE0000781FEE614AB0D7E802F0E78FF01803F8FFFFFFF),
    .INIT_5E(256'hFFFFFF87FE0000787FEE7C40E0CF980BEC7F8FE01803FDFFFFFFFFFFFC001FEA),
    .INIT_5F(256'h00078FFED52E06121C0CA74FFFFF00803FDFFFFFFFFFFF8001FE401FFF80001F),
    .INIT_60(256'hE002B004E1F4FFFFF9C003FFFFFFE3FFFFF8001FD9403FFC0003FFFFFFFC3FE0),
    .INIT_61(256'hBE07FFFC003FFFFF000FFFC70000FB3A03FFFE00DFFF9FFFE1FE000078FFE572),
    .INIT_62(256'hFFFFE0003FFCC0003F877003FFF83FFFE1FFFF0FF800078BFE501F002E806E70),
    .INIT_63(256'hFC0003F6E4000FFFFFFFF0FEFFF8FFC000793FECEF3E00FE4745DDE07FFF8E03),
    .INIT_64(256'h807FFFFFFC0FC7FF87FE0007D7FECEF3F00FC471466F00FFF0E03FFFFE0001FF),
    .INIT_65(256'hF87FFC7FE0007CFFC7631F809DA3F48B7CEFFF0E01FFFFE00007FFC0003E1F6B),
    .INIT_66(256'h07CFFE713C781F061ECD39FEFFF1E01FFFFE00001FF80007EBFF8007FFFFFF80),
    .INIT_67(256'h81F1E4F5EEDFC1FF1FC1FFFFE00000FF00007EBFF83FFFFFFFFC0007FFC3FFC0),
    .INIT_68(256'h3EFFE1BC1FFFFE000007C00007D8E18FFFFFFFFFC0037FFC1FFE007D7FCBF3C7),
    .INIT_69(256'hFFE000003C00007C83E79F0FFFFFFE2037FFE1FFE00797FD83FCFC06F70E1F90),
    .INIT_6A(256'h0007DF3C80001FFFFFFF82BFFF1FFE00387FD688FF200F33E094A1FFF031C1FF),
    .INIT_6B(256'h000FFFFFFE0BFFF1FFF0019FFD6A8FE380F00D8EB9C370061C1FFFFF00000180),
    .INIT_6C(256'hBF1F8FFE001EFFD3B0FE1C0700D37F04000641C0FFFFF000001C000035C78000),
    .INIT_6D(256'hEFFADE1FE1807A3CF0E43801FC0C03FFFF000783C000017C0600000000003FE0),
    .INIT_6E(256'h03FFDE8F41FFFF80E03FFFF801FFF80000007FFC07FFE00000FFABF0F8FFE001),
    .INIT_6F(256'hFF000603FFFFF03FFF80600FFFFFFFFFFFF80003FD9F0FCFFE081DFF29E1F20E),
    .INIT_70(256'hFF87FFF80603FFFFFFFFFFFFE00003E1F03CFFE083FFF25E0F00703FDB0E360F),
    .INIT_71(256'hFFFFFFFFFFFFFF300001FF000FFF1C39FE3CCDF40781FC47FB90000000301FFF),
    .INIT_72(256'hFFF7F0000FF004FFF1C7BFC3DBDD8F080FC81F578000000301FFFFFCFFFF80E0),
    .INIT_73(256'h00FFFE1C7FFC3D79D8F0F034803507000000380FFFFFFFFFFC0F7FC3FFFFFFFF),
    .INIT_74(256'hC01788876F805803D330000001887FFFFFFFFFC1FE1FFFFFFFFFFFFFFFE0003F),
    .INIT_75(256'h35800E538000001803FFFFFFFFFC1F80FFFFFFFFFFFFFFFF8001000FFFC0C77F),
    .INIT_76(256'h0000801FFFFFFFFF81F01FFF83FFFFFFFFFFFF8F8000FFFC0C73FF3EDA887E18),
    .INIT_77(256'hFFFFF81F01F9F70017DFFFEFFFFDFF87C7FFC0C7BFF79C7CC7E001B918FA3000),
    .INIT_78(256'h1E4C000387E016F9D87FFC67F8087FFF0DF55C78130587C7A38000000C01FFFF),
    .INIT_79(256'hF0000907FFC4FF80867FE87F5687CD3C660E7A3C400000C01FFFFF7FFF80701F),
    .INIT_7A(256'hFFF80876FE83C1207CF3C1E07FA0CE000006007FFFF7FFFC0783F46841E1C338),
    .INIT_7B(256'h3B7237CE3E0603FB0CE000006003FFFE7FFFC0183766BA2197EC30CF8A103F7C),
    .INIT_7C(256'h3F9FB8EE000003003FFFFFFFFE38C23F0BDDE6FB7DF70F1201E60FFF008EEFC4),
    .INIT_7D(256'h003001FFFFFFFFE3C632D8BEBFA80B31AF6DE01E60FFF008CFFDE36F60FC63F0),
    .INIT_7E(256'hFFFF7C130CF7E3C900640489D001FC0FFF011FFFDCF7F44FE37F81BCFFCF9FE0),
    .INIT_7F(256'h7E40F00480509683FFC1FFF0119DFC259F25FF07FC01FA7FB9FE0003001FFE07),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("UPPER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(CASCADEINA),
        .CASCADEINB(CASCADEINB),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED [31:1],DOUTA}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized0
   (DOADO,
    clka,
    \addra[16] ,
    ena,
    addra);
  output [0:0]DOADO;
  input clka;
  input \addra[16] ;
  input ena;
  input [13:0]addra;

  wire [0:0]DOADO;
  wire [13:0]addra;
  wire \addra[16] ;
  wire clka;
  wire ena;
  wire [15:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED ;
  wire [15:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB18E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0F683EC01FFF019BFFAA1FF578707FE01F85F8FFF8003001FF7E3FFFFFC0E0C7),
    .INIT_01(256'hE019FFCBFA795BC397FF02F84F87FFC0032007E3F1FFFFFF000F77FC07003807),
    .INIT_02(256'h15BE3DFF9C67843C3FFE001E007FFF0FFFFFF0037F7FC07007C06077E3C403FF),
    .INIT_03(256'h3FFF87FE6000E0023FFFFFFFFFC073F7FF0700780607EE1F803FFC0793FE3D12),
    .INIT_04(256'h0C0061FF9FFFFFFE03B0BE76780380207E03F803FF803AFFE379030CF3EFFDCE),
    .INIT_05(256'hFFFFE01068C368C0380607CC70003FF80327FC33F9FD4F26FFDFE7FFFC7FFF00),
    .INIT_06(256'h9FAFE5C0E07D4C030FFF8037FFC3B9DF92F27FFDFFFFFDE3FFF80060000FF8FF),
    .INIT_07(256'h89C0F9FFF0007FF83909EF2F07FFEFFFFF8F1FFFC0078001FF8FFFFFFF801CFB),
    .INIT_08(256'h04FF848C1EE2E0BF7FFFE1F8FE7FFF003E004FFFFFCFFFFE018C06177F8F9E1D),
    .INIT_09(256'h3219FFFE1F0FFFF81FF007E0063FFFFFFFFFFE000D880F051E1E65B81FFFC000),
    .INIT_0A(256'hCFEEE0FF00710061F0FFFFFFFFC38001F01FDFFE999E03FFF800007FF84A78F6),
    .INIT_0B(256'hB8FC0F07FFFFFFFE7800000000FBE318807FFFC0000FFF0083CF2321CFFFA0F0),
    .INIT_0C(256'hFFFFF8F7E0E21600000008067FFC0000DFF01D9BF630DC7FF8079CFFFF803C67),
    .INIT_0D(256'h0400FFFFE001E1FFC0000BFE098FBF630D8FFFC03FFFFFCC0000FF8F03807FFF),
    .INIT_0E(256'h380FFC00013FF89C73EC1C01B9FFF1FFFFFEFF0FD3FF00F80CFFFFF0FF4CC30E),
    .INIT_0F(256'hFF89CE3FC3C50FFFF80FFFF8DFC0C1C0C00033FFF0FFC2E4FF8DFFC00001FC00),
    .INIT_10(256'hC0FFFF00FEFF0DFDF800004004E7F80FFE075FFE5FFE0000000007003FC00029),
    .INIT_11(256'hF83FC85FB820E0FCFF00FFE02FFEFEFFF600000001E001FE00021FF919E7F43E),
    .INIT_12(256'h8E0E1FF807E1C03F80E5FFF0000000FC001FF0005BFF17DEF843FD0FDFE00FC5),
    .INIT_13(256'h0015F0025FFF8000003F0001FE00047FF1447A0483D0BCFE033C4FEFFE5DFFFF),
    .INIT_14(256'hF000000780001FE00037FE31B1F088BD99CFC079C7F3FFEDCE27FE4191FFC07E),
    .INIT_15(256'h01DE00067FE2510C18AFA106FFFFFC7F3E03FFC47FE00FF8FF03F800E70037FF),
    .INIT_16(256'h6C31FF8E5A117FFF63CFFFE41FF1E0FF83FF8FF01E003F9C030FFF000000F000),
    .INIT_17(256'h3FFFE03DFFFE02F1330FFC01FCFF01C0047C70007E0000001E00001C00012FFE),
    .INIT_18(256'hE72FEE6CFFE007E7F00C01F7E3C0C700000003C00003C0002CFFEEBF1E186081),
    .INIT_19(256'h001E7F000009381C0EE000003FF803C07C00010FFFCB38000600E3FFFF87FFFF),
    .INIT_1A(256'hD080E1FF200007FF007F87800041BFFF75A2F1801F3FFFE7FB7DF3BCF80C03FF),
    .INIT_1B(256'h07FFE01FF877000A01FFEFD3F81801F37FC64FB7FFFCE0430073F80001E20000),
    .INIT_1C(256'h0000901FFCD10FF0C7FF37FD7CF9F3FF66007C03BFC0001E200073C6039FFE00),
    .INIT_1D(256'h12FF367FF3FFFF9F1F1FF4E003B81FFC0001E3000A5E300CFFFFFFFFFC03FF80),
    .INIT_1E(256'hFFE7F1B9BF720140E1FFC0000F3000B93880F3FFFFFFFF803E1C00000219FFE4),
    .INIT_1F(256'h700647FFDE0000F3000003E4273FFFFFFFC0019BC00000C1DFFEC4CFF367F73F),
    .INIT_20(256'h00038080F00330F81FFFFFF8401B4C0000181BFFC5866003F273FFFF7713F3FF),
    .INIT_21(256'h1D8F83FFFFFF8C00ABC00000973FEE65B9763F773FFFF8FDFFFCC400843DEDF0),
    .INIT_22(256'hC000098408003073FFFB9BFB63F031FFF7B7CFFFDEB00CE5CF6F800038001800),
    .INIT_23(256'h0E073FFFB640B7FF0F9FFF7E35FF77FFF0CF19B3FC00038007E000660781FFFF),
    .INIT_24(256'h73FFFDFFFFE7C37FF77A5F041F0F09E0003C00783C01C1F60FFFF80000D5C080),
    .INIT_25(256'h34BAFF71B9A006F0F95FC003E00E07C003FED000FE00000A4408014073FFFA38),
    .INIT_26(256'h80A7005CFC003E01B87E0001E28003C0000104000018033FFFA5411FFFFFFFF6),
    .INIT_27(256'h01F00807FF00066C00000000144600030033EFFDF201CFFFFFFF3E4DA7F77ADB),
    .INIT_28(256'h001F600000000744EC0050023FFFC8A278FFFFFFDF83DACF7F34FC04606667E0),
    .INIT_29(256'h00F409C00A0023FFFC932403FFFFFDF81FACCFD3BFF960037E3E001F80F07FF8),
    .INIT_2A(256'h023FFF4994103FDFFFFF9DFBDCF9BB969A201FF3F801F80907FF987C01E00000),
    .INIT_2B(256'h03FDFFFFFF8F3FFF9ABA41A330F78FC01FC0F87FFFCFC01FFC0001FE80580146),
    .INIT_2C(256'hA79FFFADF7030F0FFCFC00FE13C3FFFFF8EC7FF003FFE00700186067FDF0121C),
    .INIT_2D(256'h30C0FFFFE003F13E1FFFFE1FF3FFFFFEFDA1F002E0067FDF055303A5FFFFFFEC),
    .INIT_2E(256'h1F90F03FFC01FCFFFFFFEFC23F6076006FFDF3F1FB7A0FFFFFFEC7F1FFFFFDF0),
    .INIT_2F(256'h0001FFFFFFF963BC0C6001FFDFBF08C7A8FFFFFFFC7C63FFFE5E618407FFFF80),
    .INIT_30(256'hA8338580001FFFF847017BCFFFFF9FE64C3FFF056F58407FFFFE00FD4380FFC0),
    .INIT_31(256'hFFFD04FF57BE7DFFFFF26663FFF7D3A58C07FFEFF003C71C07F820004FFFFFFE),
    .INIT_32(256'h260DE20E36323FFF061A58F037FF7F000EC8703F0000037FFFFF2C0252200001),
    .INIT_33(256'h31FFE5D7C6DF033FFFFE00F361C1F0E001A7FFFFFB006B7502003FFF816DE57A),
    .INIT_34(256'hF03BFFFFF0071BCF87FF801EA7FFFE401D3EA06003FFF51BF15FD660DFC6F7F1),
    .INIT_35(256'h3E423E3FF000F47FFFD803B59C00003FFF9B9E22FD668FFE63FF1B9FF9017E6F),
    .INIT_36(256'h04A7FFFA007242010003FFF68867DFFFF8FFF03F38FDFF8A7E66F903BDFC7FC0),
    .INIT_37(256'h4E5001C07FFFA88BB2FF9FA7FF39F183DF3FE9E32F80379FE7FFC1F39871E000),
    .INIT_38(256'hC48FB7CFF9F4FF23EF0E36FFFD28DD78027FFFFFFE0FCDE18C000184FFDF900E),
    .INIT_39(256'hCFF3FCF1E225FFBA44C7E037FFFFFFF003238E00FFF837FFF5018DEAC0080FFF),
    .INIT_3A(256'h5FFBEC4CBF037FFFFFFF80198C187FFF727FFEB079BD4C0000F7FC9379EFFF8F),
    .INIT_3B(256'h3FFFFFFFFC01C670FFFFFF937FD70617A8C0003E7FF97F956FFB7AFD9F8F3E2D),
    .INIT_3C(256'h0F31C3FFFFFDBFF2FFC6F91C0187E7FD9FE355FFD7AFCFA060F27DFFE60CCBB0),
    .INIT_3D(256'hE2833FF99F20C01E7E7FF9CA0D5FFD7DF8F0060FE24FE65EE29F01FFFFFFFFF8),
    .INIT_3E(256'h0001F3C7FB98E472FFE3FF83F8E7DF5BFE55A6C5F01FFFFFC7FFC038E79FFFFF),
    .INIT_3F(256'hE64CA7FF38383F9E7CFA27E69A2DC201FFFFFC3FFE00E38C3FFFFE0FF8FF23EC),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED [15:1],DOADO}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED [15:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED [1:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED [1:0]),
        .ENARDEN(\addra[16] ),
        .ENBWREN(1'b0),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized1
   (\douta[1] ,
    clka,
    ena,
    addra);
  output [1:0]\douta[1] ;
  input clka;
  input ena;
  input [16:0]addra;

  wire \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_i_1_n_0 ;
  wire [16:0]addra;
  wire clka;
  wire [1:0]\douta[1] ;
  wire ena;
  wire [15:2]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED ;
  wire [15:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB18E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hAABFC056AF01555555555AAAAAAAA555503A5553801400000155014005556969),
    .INIT_01(256'h4155014154055555059CE5555769270003B294000055555555555005555556AA),
    .INIT_02(256'hAAAA55555540E5500E401500000154014005556D5956EB155671955555A9AAA5),
    .INIT_03(256'h5558B9EB300EAE540000555555555550055555556AAABFFC056AFC05555556AA),
    .INIT_04(256'h40000150015001556EA95A3C55512C955555A9AAA55555015554005555555BE9),
    .INIT_05(256'h5555554000155555555956AFFF0155AAF000055A56565A5555540F9550380000),
    .INIT_06(256'hDCAA5587955955A6F9A55555505550001555555AF9555768BA303AAE94500015),
    .INIT_07(256'hABEFF00055AFC00155555555540003E95000E0000000000150015001555BAA6A),
    .INIT_08(256'h41541550001455556AAA5557BB7F30FAAEA40000155555555555555555555556),
    .INIT_09(256'h5550000F950003900000000005500040055557AA56D45AAAA395555556A9A9A9),
    .INIT_0A(256'h9BA67C44FAAE940000155555555555555555555555AAABFFFC015ABFFFC00005),
    .INIT_0B(256'h0005500000055557AA55D916EAAD95555956AAA5BA915516500010555555AA5A),
    .INIT_0C(256'h555555555555555555555AAAAFFFC0055AAAFF000155003FFA50000E40000000),
    .INIT_0D(256'h16EAA865555945AEA5BBD155559410005555556A5AABBBBC80FAAE9000000555),
    .INIT_0E(256'hAAABFFFF00056AAFFFC0003FFEA500000904000000000550000015555AA5558E),
    .INIT_0F(256'h55555414005555556A596BB8FC943AAD90010005555555555555555555555555),
    .INIT_10(256'hFFA95000003400000000000554000005551AAA55CF5AFAAA691565416EA96A91),
    .INIT_11(256'hB8ECA93ABE900100055555555555555555555555556AABFFFFFC00555AAFFFFF),
    .INIT_12(256'h0554001501555AAA558B8BF95A591565516EB9559155555415001555556A555B),
    .INIT_13(256'h555555555555555555555AAABEFFFC0000056AAAAAAA55000000D00000000000),
    .INIT_14(256'hF39A5A55A5556FBE655555555555405555555A9558BB98A9F9CE950040055555),
    .INIT_15(256'hAAAAAAAFFFFF005555555540000003400000000000055401550015565B557BDB),
    .INIT_16(256'h5555A5016956A55A9558CCDBA4FACA5541540155555555555555555555555556),
    .INIT_17(256'h0000F039000000000000055000014015565B9566A6BCEA6A55A5505AC3A95555),
    .INIT_18(256'hA7A4EAC955415501555555555555555555555555556AAAAAABFFFFF000000000),
    .INIT_19(256'h4000005015566B955165BC3A5A5555555AB3FE55555505A901A956A5AAA96DFE),
    .INIT_1A(256'h555555555555555555555AAAAAAABFFFFFFFC03C0003FFFFE400000000000005),
    .INIT_1B(256'h7A5555555556AFFFEA9554016905A55565A5AA6DAAA454DAF555405541555555),
    .INIT_1C(256'hAAAAAAABFFFFFFFFFFFFFFFFCE500000000000000540000050155A569551606C),
    .INIT_1D(256'h0069169155AAA56EADE51754DAF5555015415555555555555555555555555556),
    .INIT_1E(256'hFFF9000000000000000540000050155A555561A56C0E55555A9596AFABFAAA54),
    .INIT_1F(256'h579AF556501540555555555555555555555555555556AAAAAAFFFFFFFFFFFFFF),
    .INIT_20(256'h000000155AE5556CAD6C025555565595AFEAB3EA5541695A9555AAA56BE9F5DB),
    .INIT_21(256'h55555555555555555555556AAAAAAEAFFFFFFFFFFFFFA5000000000000000540),
    .INIT_22(256'h5559555555AF2AAFE955556956955A56EAA7FDA59864AAFA5655554015555555),
    .INIT_23(256'h56AAAAAAABFFFFFFFFFFFA400400000000000005400000001556E9557C6D6002),
    .INIT_24(256'h695695AA56BEAABD959C64EBFA95555000155555555555555555555555555555),
    .INIT_25(256'h000000000000000005400100001556A95570291C53555A555555AC2A96A95555),
    .INIT_26(256'hEBEA9555400015555555555555555555555555555555AAAAAAAAFFFFAFFFFE94),
    .INIT_27(256'h000015555A9575590B53555A955555AC3A95AA50556556AAA555BE5E6D559C24),
    .INIT_28(256'h5555555555555555555555556AAAAAAFFABFFFE9400000000000000000054001),
    .INIT_29(256'h5A955955AC3A9556A469555A9AA555BE5E5C54AC743F9A95A940000555555555),
    .INIT_2A(256'h5556AAAAAAAAAAA940000000000000000000054001000015555AA5764A570FA9),
    .INIT_2B(256'h5A56AAAABA5552A9ADB43F9BAAA9400000555555555555555555555555555555),
    .INIT_2C(256'h000000000000005550054001455695BE625697C4AA5A956E556B0FE555BD5A55),
    .INIT_2D(256'h9BFABA540400555555555555555555555555555555555555AAAAAAA954000000),
    .INIT_2E(256'h01455795BE6691A584AA56A56C956AC0E5556AAA5569556AABAA55525AFDF4FF),
    .INIT_2F(256'h555555555555555555555555555AAA5554000000000000000000000155500550),
    .INIT_30(256'hA56F956AFCE5555AAAA9A555A6AAAA55624515E3F3AABAFAA505005555555555),
    .INIT_31(256'h555555555000000000000000000000000155500150014556956AA2E1A383AA56),
    .INIT_32(256'h6AA6AAAF96B24F6A93B2AAAFFAF9154015555555555555555555555555555555),
    .INIT_33(256'h000000000000555000540155569555ADC45233AA555A5B969AFFE555556AAAA5),
    .INIT_34(256'hAC2AF90540155555555555555555555555555555555555555540000000000000),
    .INIT_35(256'h5555A55A988203886A556F9AA556FFFAA55556A969556AF95F9ABE9F1A8EB2BE),
    .INIT_36(256'h5555555555555555555555555555400000000000000000000000000540001401),
    .INIT_37(256'hAAA955BC3A955545AFAA956BE55A96BE9FB6D9B2BFAC3AA90550155555555555),
    .INIT_38(256'h5555550000000000000000000000000005400004005555A55AAB7740B469555B),
    .INIT_39(256'h6A950A96BD90ADEE83F0FC4AA941541555555555555555555555555555555555),
    .INIT_3A(256'h000000050001400005005555A55AAB3494E295555BFEAE696C0E955555ABFA55),
    .INIT_3B(256'h9EBA405415555555555555555555555555555555555555540000000000000000),
    .INIT_3C(256'h555556BA30E4ECA55556FEAEAA5B039569555AFE956A454A92BD50FDA3D3FD01),
    .INIT_3D(256'h5555555555555555555555555400000000000000000000000540000000054055),
    .INIT_3E(256'hAAAA96C095A95556FA9555565A96FD4001140EAD41A2BF905405555AA5555555),
    .INIT_3F(256'h00000000000000000000000000000000000000000000000000000000A95556F3),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram 
       (.ADDRARDADDR({addra[12:0],1'b0}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED [15:2],\douta[1] }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED [15:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED [1:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED [1:0]),
        .ENARDEN(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_i_1_n_0 ),
        .ENBWREN(1'b0),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
  LUT5 #(
    .INIT(32'h00002000)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_i_1 
       (.I0(addra[16]),
        .I1(addra[15]),
        .I2(ena),
        .I3(addra[14]),
        .I4(addra[13]),
        .O(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_i_1_n_0 ));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized10
   (p_71_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_71_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_71_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hFFFFFFFFFFFFFFFFFFC0000000000000000FFFFF700000000000000000000000),
    .INITP_01(256'hFFFFFFFC0000000000000000FFFFFE0000000000000000000000003FFFFFFFFF),
    .INITP_02(256'h0000000000000FFFFFC0000000000000000000000007FFFFFFFFFFFFFFFFFFFF),
    .INITP_03(256'h00FFFFF8000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFC000),
    .INITP_04(256'h000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000),
    .INITP_05(256'h0000000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFE0000000000000000FFFFF8000),
    .INITP_06(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFF000000000000000),
    .INITP_07(256'hFFFFFFFFFFFFFFFFF8000000000000000F0FFE000000000000000000000000FF),
    .INITP_08(256'hFFFFFF8000000000000000FFFF8000000000000000000000001FFFFFFFFFFFFF),
    .INITP_09(256'h00000000000FFFF7800000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0A(256'hFFE3F80000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000),
    .INITP_0B(256'h00000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000000000000000),
    .INITP_0C(256'h000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE000000000000000FFE7F000000),
    .INITP_0D(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFE000000000000000FFFFF00000000000000000),
    .INITP_0E(256'hFFFFFFFFFFFFFFFF000000000000000FFFFF00000000000000000000007FFFFF),
    .INITP_0F(256'hFFFFF000000000000000FFFFE00000000000000000000003FFFFFFFFFFFFFFFF),
    .INIT_00(256'h2222222020202020202020202022222220202020222242424242646464848486),
    .INIT_01(256'h0020202222222222222020202000000000000000000000000000000020202222),
    .INIT_02(256'hF1113311EF666644446688AA8888AA6666442222000202000000002222222000),
    .INIT_03(256'h6B8D8F91B1B1B18F8F8F8F9179575557775599BB997799999999797979775533),
    .INIT_04(256'h2220202020202242424242424242424242422222222222220022222222222446),
    .INIT_05(256'h6E4C4C4E4E4E4C0A0A0AE8C6C6A6A6A6A6A686A4A6C6C8C8C6A6848486846442),
    .INIT_06(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9D792709090906E4E4E4C4C4E6E),
    .INIT_07(256'hF9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFDFBFDFDFDFDFDFDFDFBFBFBF9F9),
    .INIT_08(256'h4E4C4C4C6EB2D5D2D2D4D4D4D4D4D4D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_09(256'h22222020202020202242424242646464848486A6A6A6A6A6C6E80A2C2C2C2C4C),
    .INIT_0A(256'h2000000000000000000000000000000020222222222222202020202020202222),
    .INIT_0B(256'h8A88662244444422222200002200202222220000002022222222202020202020),
    .INIT_0C(256'h773535355777BBBDBB999999999B9B7979797757353311CECC6644444488AAAA),
    .INIT_0D(256'h424242424242222222222222222020222242444668AD8D8FB1B1B18F8F8F9191),
    .INIT_0E(256'hC6A6A6A6A6A68684A6A6C6C8C8A6848686848462422222222020204242424242),
    .INIT_0F(256'hF9F9F9F9F9F9F9F7B592929090706E4E4E4C4E6E6E4C4C4E6E4E4E2C0A0AE8C8),
    .INIT_10(256'hFBFBFBFBFBFBFBFBFBFDFDFDFDFDFDFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_11(256'hD4F5F5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBF9F9FBFB),
    .INIT_12(256'h626464848486A6A6A6A6A6C6E80A2C4E4E4C4C4C4C4C4C6EB2B2D2B2B2D4D5F5),
    .INIT_13(256'h0000002022222222222220202020202020202222222020002020202242424242),
    .INIT_14(256'h2022222222220000002022424222202020202020200000000000000000000000),
    .INIT_15(256'h777999799B9977571111EF8846222222448A8A88AAAA44224444222222220000),
    .INIT_16(256'h2220000020222244688D6D8FB1B1B18F8F9191B17957353557799BBBBB999977),
    .INIT_17(256'hC8A6A68686868664424222222020202242424242424242424242222222222222),
    .INIT_18(256'h90706E4E4E4C4C4E6E4E4C4E6E4E4E2C0A0AE8E8C8C6A6A6A6A68484A4A6A6C8),
    .INIT_19(256'hFBFBFBFBFBFBF9F9F9F9F9F9F9F9FBFBF9F9F9F9F9F9F9F9F9F9F9F9D7B59290),
    .INIT_1A(256'hF7F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_1B(256'h0A2C4C4E4E4C4C4C4C6E90B2B2B2B2B2D4F5F5F5F5F5F5F5F5F5F5F7F7F7F7F7),
    .INIT_1C(256'h20202020202020202020200020222242424242626464848486A6A6A6A6A6C6C8),
    .INIT_1D(256'h2222202020202020000000000000000000000000000022222222222222222020),
    .INIT_1E(256'h6644222246AAAA888A8844444422222200000022222222222200000020224222),
    .INIT_1F(256'h91B1B18F8F91B1B1795757355779799BBB999999797757333555555513F1CC88),
    .INIT_20(256'h20202022424242424222224242422222422222222200000000222244688D6D8F),
    .INIT_21(256'h6E4E4E4E2C0A0AE8C8C6A6A6A6A68484A4A6A6C8C8A6A6A68486868464424242),
    .INIT_22(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9D7B2929090704E6E4C4C4E6E6E4C4E),
    .INIT_23(256'hF9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9),
    .INIT_24(256'hD4D2D2D4F5F7F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9),
    .INIT_25(256'h222242424242626464848486A6A6A6A6A6C6E80A2C4E6E6E4C4C4C6E6E90B2D4),
    .INIT_26(256'h0000000000000000002222222222222220202022222020202020202020202020),
    .INIT_27(256'h2222002200002222222222200000000022222220202020202020200000000000),
    .INIT_28(256'h5557577999777777775757335777775711EFCCAA8822224468AA8A8868462422),
    .INIT_29(256'h42422222424222222020000000000024688B6D8F8F91B18F8F91B1B179795755),
    .INIT_2A(256'hA6A6A684A4A6A6C8C8C8A6A484A6A68464424242202020222242424242222242),
    .INIT_2B(256'hF9F9F9F9F9F7B5B29290706E6E4E4C4C4E6E6E6E6E6E4E4E2C0A0AEAE8C8C6A6),
    .INIT_2C(256'hFBFBFBFDFDFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_2D(256'hF7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFB),
    .INIT_2E(256'hA6A6C6C6C8EA2C4E6E6E6E4C4C4C6E90B2D4D5D5D5F5F5F7F7F7F5F5F5F5F7F7),
    .INIT_2F(256'h222222202020222222222020202020202020202222424242426264648484A6A6),
    .INIT_30(256'h0000000022222220002020200020000000000000000000000000000020222222),
    .INIT_31(256'h9B997733EFCFCCAA662222668AAA888866222222222222422222222222000000),
    .INIT_32(256'h00202022468B6D8F8F8F8F8F8F919191799B7935333313355755555757577977),
    .INIT_33(256'h84A6A88464646442222020202042424222222022424222222222222220202000),
    .INIT_34(256'h6E4E4C4C4E70706E4E70704E4C2C0A0AEAE8C6C6C6A6A68484A6A6C6C8C8A684),
    .INIT_35(256'hFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9D7B5B3929090),
    .INIT_36(256'hF9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFBFB),
    .INIT_37(256'h4C6E90B2D2D4D4D5F7F7F7F7F7F7F7F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F9),
    .INIT_38(256'h2020202020202222424242426464648486A6A6A4A6C6E8E80A4E7090906E6E4C),
    .INIT_39(256'h0000000000000000000000000000202020222222222222222020222222222020),
    .INIT_3A(256'hAA88886644442222224264666664442200000000000020202022222222222000),
    .INIT_3B(256'h8F91919179797733EFEFCDEF3577577979799999995511ACAACCAA6622004488),
    .INIT_3C(256'h204242422222202222422222222222222220202000002022468D8D8F8F8F8F8F),
    .INIT_3D(256'h4E2C2C0A0AE8C8C6C6A6A68484A6A6C6C8C8A6A684A6C8846464646422202020),
    .INIT_3E(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F7D5B5B292706E4E4C4C4C6E6E4E4E6E706E),
    .INIT_3F(256'hFBFBFBFBFBFBFBFBFBFDFDFDFDFDFDFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9),
    .INIT_40(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFB),
    .INIT_41(256'h6464848686A684A6C6E8EA0A4E7090906E6E6E6E8EB2D2D4D4D4D4F5F5F7F7F7),
    .INIT_42(256'h0000202020222222222222222020222222222020202020202020224242424242),
    .INIT_43(256'h4442222200000000000020202020222020000000000000000000000000000000),
    .INIT_44(256'h575757577777775533F1CCCFEFCCA8440022668AAACCAA444444222244668866),
    .INIT_45(256'h222222222222202000002222468D8F8F8F8F8F8F919191917977573511331133),
    .INIT_46(256'hA4A6A6A6C8C8C6A684A6C8846464646442202020202242422222202222422222),
    .INIT_47(256'hF9F9F9D7B5B392706E4E4C4C4E6E6E6E4E4C70704E2C2C0A0AEAC8C8C6A6A6A6),
    .INIT_48(256'hFDFDFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_49(256'hF7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFD),
    .INIT_4A(256'h6E70706E4E6C6E90B2D4D4D4D5D5D5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_4B(256'h202222222222222020202020202222424242426464848686A6A6A6C8E8E8EA2C),
    .INIT_4C(256'h2020202000000000000000000000000000000000002020202020222222222222),
    .INIT_4D(256'h11CC882220446668AACC66442242222244666644442222000000220000002222),
    .INIT_4E(256'h448D8F6D6D8F8F8F9191919179775755335555555735133333131311F1111111),
    .INIT_4F(256'h8464646442202020202222222222202222422222222222222222222000002222),
    .INIT_50(256'h4E4E6E6E4E4C70704E2C2C0A0A0AE8C8C8C6A6A6A6A6A6A6C6C8C8A6A6A6C886),
    .INIT_51(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7D5B3B290706E4E4E),
    .INIT_52(256'hF9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFDFBFBFBFBFBFBFBFBFBFBF9),
    .INIT_53(256'hD5F5F5F5F5F5D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_54(256'h2222224242424464648486A6A6A6C8EA0A0A0A4E6E6E6E4E6E6E90D2D5D5D5D5),
    .INIT_55(256'h0000000000000000202020202020202222222220222222222222222020202020),
    .INIT_56(256'h2222222244442222442222000002220000002222202020000000000000000000),
    .INIT_57(256'h7757575533553535353313F1F1F111133355551311CC662022664668AACC4444),
    .INIT_58(256'h2222202222222222222222222222222000002222448B8D6D6D8FAFB191919191),
    .INIT_59(256'h0A0AEAC8C8C6A6A6A6A4A4A6A6C8C8A6A6A6A6A6846484846222200020222222),
    .INIT_5A(256'hF9F9F9F9F9F9F9F9F9F9F9F9D5B5B2B3906E4E4E4E4E4E6E4E4C6E706E4C2C2A),
    .INIT_5B(256'hFDFBFBFBFBFDFDFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_5C(256'hF7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFD),
    .INIT_5D(256'hA6A6EA0A0A0A2C4E4E4E4C4C6EB0D2F5F5D5D5D5F5F5F5F5F5D5D5F5F5F7F7F7),
    .INIT_5E(256'h20202020202020202220202020222220202020222222224242426464848486A6),
    .INIT_5F(256'h0000000000202220202020000000000000000000000000000000202020202020),
    .INIT_60(256'hF111357777997933EFAA440022666688AC8A4444422222224422222244220000),
    .INIT_61(256'h2222222220002222246A8D6D6D8FAFB1B19191915755553313353513133513F1),
    .INIT_62(256'hA6C8CAA8A6A6A6C8848484846442200022202222222220222222222222222222),
    .INIT_63(256'hD7B5B5D592704E4C4C4C4E6E6E4E6E70704E2C2C0A0A0AE8E8C8C6A6A6A4A4A6),
    .INIT_64(256'hFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_65(256'hF9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFB),
    .INIT_66(256'h90D4F5F7F4D5D5D5F5F5F5F5D5D5D5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_67(256'h20202020202020222222424242646464848486A6C6E80A0A0A2C4E2C4C4C4C6E),
    .INIT_68(256'h0000000000000000000000000020202022222220202020202020202020202020),
    .INIT_69(256'h226888AAAA462444222222444422222222000000000000000022002020202000),
    .INIT_6A(256'h8F8F8FAFB19191913555353311355535135533133357799999797733CC662220),
    .INIT_6B(256'h8442202022002022222022222222422222222222222222222220222224486D8F),
    .INIT_6C(256'h70704E70906E4C4C2A0A0AE8E8C8C6A6A6A6A4A6A6C8EAC8A6A6A6C884848484),
    .INIT_6D(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9D7D5D5B3904E4C4C4C4E6E),
    .INIT_6E(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9),
    .INIT_6F(256'hD4D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFB),
    .INIT_70(256'h646464648486A6C8E80A0C0A2A2C2C0A2C4E6E90B2D5F5F4D4D4D5D5D5D5D5D4),
    .INIT_71(256'h0000002222222220202020202020202020202020202020202020222222224242),
    .INIT_72(256'h4444222222020000000000202200000020200000000000000000000000000000),
    .INIT_73(256'h55555535353313335799997999995713AA4422224488ACAC8844442222002244),
    .INIT_74(256'h2222422222222222222222222222222224466D8F8F8F8D8FB191919157575535),
    .INIT_75(256'hE8C8C8C6A6A6A6A6A6A8EAC8A6A6A6C8A6848486844220202200202222222222),
    .INIT_76(256'hF9F9F9F9F9F9F9F9F9F7D7B5B5906E4C4C4C4E6E70704C7090704E4C2C0A0A0A),
    .INIT_77(256'hFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_78(256'hF7F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_79(256'h2A2A0A2C4C6EB2D5D5F5F5F4F4F5F5F5F5F5D5F5F5F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_7A(256'h20202020202020202020202020222222222242426464646484A6C8EAEAEA0A0A),
    .INIT_7B(256'h2200002020200000000000000000000000000000202020222222222020202020),
    .INIT_7C(256'h999957EF884222424468AAAA6622664422224466444444220002000000002222),
    .INIT_7D(256'h2222222222466B8FB18F8F8F8F91919177797777997977351335575779999B99),
    .INIT_7E(256'hA8A6A6C8A6848486864220202220202222202222222222222222222222222222),
    .INIT_7F(256'hD5B2704E4C4C4C6E70906E7070706E4C2C2C0A2CEAE8C8C6A6A6A68686A6EACA),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_71_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_71_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized11
   (p_67_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_67_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_67_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h000000000FFFFE00000000000000000000003FFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_01(256'hFFE00000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF800000),
    .INITP_02(256'h000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000000000FF),
    .INITP_03(256'h000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000FFFFC00000000),
    .INITP_04(256'hFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000FFFFC0000000000000000000),
    .INITP_05(256'hFFFFFFFFFFFFFFE00000000000000FFFF80000000000000000000000FFFFFFFF),
    .INITP_06(256'hFFFF00400000000000FFFF80000000000000000000001FFFFFFFFFFFFFFFFFFF),
    .INITP_07(256'h0000000FFFF80000000000000000000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_08(256'h00000000000000000000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0040000),
    .INITP_09(256'h000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80600000000000FFFF),
    .INITP_0A(256'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80600000000000FFFF00000000000),
    .INITP_0B(256'hFFFFFFFFFFFFFFFFFFFFFFFF80200000000000FFFF0000000000000000000000),
    .INITP_0C(256'hFFFFFFFFFFFFF80000000000000FFFF0000000000000000000000FFFFFFFFFFF),
    .INITP_0D(256'hFF80000000000000FFFE0000000000000000000000FFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0E(256'h00000FFFE0000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0F(256'h00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000),
    .INIT_00(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7D5),
    .INIT_01(256'hF9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_02(256'hF4F5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9),
    .INIT_03(256'h222222222242424464648486A6C8C8EAEAEA0A2C2A2A2A4C6E90B2D5D5F5F5F4),
    .INIT_04(256'h0000000000000000202020202222222020202020202020202020202020202020),
    .INIT_05(256'h4422442222444444444422000000000000002222220000202020000000000000),
    .INIT_06(256'h8F919191779999799B9B57131357797979999979777735CC6642224244688A88),
    .INIT_07(256'h20222022222022222222222222222222202222222222222222446A8FB1918F8F),
    .INIT_08(256'h7070704E4C2C2C2C0AE8C8C6A6A6A68686A6C8EAC8A6A6C8A68484A686422020),
    .INIT_09(256'hF7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5D5B3906E4C4C4C4E70909070),
    .INIT_0A(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_0B(256'hF7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_0C(256'hC8C8E8EAEA0A0A2C2A2C4C6E90B2B2D4D4D4D4F4F5F5F5F5F5F5F7F7F7F7F7F7),
    .INIT_0D(256'h20202220202020202020202020202020202020202222222222424264646486A6),
    .INIT_0E(256'h0000000000000022222020202020000000000000000000000000000020202020),
    .INIT_0F(256'h3579797979797957575713AA4422224446888844224422222244444422220000),
    .INIT_10(256'h2222222222222222222222222244688FB1B18F919191918F7799999999795533),
    .INIT_11(256'hA6A6A686A6A6C8EAC8C6A6C8A6A6A6A686422020002020202220222222222222),
    .INIT_12(256'hF9F9F9F9F9F9F7D5D3B2B2904E4C4C4E6E9090907090906E4E2C2C2C2A0AE8C8),
    .INIT_13(256'hFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_14(256'hF9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_15(256'hB2B2B2D2D4D4D4D4D4F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9),
    .INIT_16(256'h000020202020202222222222224242646486A6A8C8C8C8E8EA0A0A2C2C4C6E90),
    .INIT_17(256'h0000000000000000000000000000000020202020202020202020202020202020),
    .INIT_18(256'h22204466888A6622224422222244442222000000000000000000002020202020),
    .INIT_19(256'h2224468DAFB18FB1B1B1918F77777979575779797779797979799B799B57EF66),
    .INIT_1A(256'hA6A6A6A8A6624220202022222220222222222222222222222222222222220022),
    .INIT_1B(256'h6E4C4C4C4E6E9090909092704E2C2C2C2C0A0AE8C8A6A6A6A6A6A6EAEAC8A6A6),
    .INIT_1C(256'hF9F9F9F9F9F9F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F7F7F5D3B2B2B2),
    .INIT_1D(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9),
    .INIT_1E(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFB),
    .INIT_1F(256'h2242426486A6A8C8C8C8E8E80A0A2A2C4C6E90B2B2B2B2B2D2D4D4D4D4F5F5F5),
    .INIT_20(256'h0000002020222020202020202020202220202000000020202020202222222222),
    .INIT_21(256'h2222222222000000000000000022224222000020202000000000000000000000),
    .INIT_22(256'h775555779979BB9B79999B9B79799B9B9B358A22224266888A46222244222222),
    .INIT_23(256'h22222222222222222222422222222222222200222222466B8F918F91B1B19191),
    .INIT_24(256'h6E4E2C2C2C2C0AEAC8A6A6A6A6A6A6C8EAE8A6A6A6A6A6C8A864422020222222),
    .INIT_25(256'hF7F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7D5B2B3B3904E4C4C4C4E70909090B290),
    .INIT_26(256'hFBFBFBFBFBFBFBF9FBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7),
    .INIT_27(256'hF7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_28(256'h0A0A2C4C4E709092B2B2B2B2D2D4D4F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_29(256'h20202020200000000020202020202222222222224242646486A8A8C8C8C8EAEA),
    .INIT_2A(256'h0022444222000020202000000000000000000000000020202222202020202000),
    .INIT_2B(256'h79799BBB99F16622224466AAAA66224444222222222222222200000000000000),
    .INIT_2C(256'h22222222222200222222246A8F8F8F8F91B1B1B17733357799799B9B999BBB9B),
    .INIT_2D(256'hA6A6A6C8EAEAC8A6A6A6C6EAC864422022222220202222222222222222224222),
    .INIT_2E(256'hF9F7F7F7D5B3B3B3926E4C4C4C4E6E9090909290706E4E2C2C2C0AEAC8C8A6A6),
    .INIT_2F(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_30(256'hF9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9),
    .INIT_31(256'hD2D4F5F5F7F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_32(256'h202020222222222242426484A6A8A8A6C8E8EA0A0A2C2C4E70909090B2B2B2B2),
    .INIT_33(256'h0000000000000000000020222222202020202020202020200000002020202020),
    .INIT_34(256'h8A46446644002222222222222200000000000000222222220000202020000000),
    .INIT_35(256'h8D8F8F8F8F91B1B1773555799B799B9B9B9B9B9B79799BBB57AC4422224466AA),
    .INIT_36(256'hC884422222422020202222222222222222222222222222222222222222222468),
    .INIT_37(256'h4C4E6E909090909290704E2C2A2C0A0AE8C8A6A6A6A6A6C8EA0CC8A6A6A6C6EA),
    .INIT_38(256'hF9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F7F7F7F5D5B3B292704E4C),
    .INIT_39(256'hFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_3A(256'hF7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_3B(256'hA6A6A6A6C8EA0A0A0A2C4E6E90909090B2B2B2B2D2D4F5F5F7F5F7F7F7F7F7F7),
    .INIT_3C(256'h2222202020202020202020200000002020202020202020202022222242446486),
    .INIT_3D(256'h2200000000000022222222000000202020000000000000000000000000202222),
    .INIT_3E(256'h99799B9B9B9B9B9B99999B9B138A44442244888A664466664400222222220222),
    .INIT_3F(256'h22222222222222222020222222222220202022688D8F8F8F8F91B1B177575777),
    .INIT_40(256'h2A2A0A0AEAC8A6A6A6A6A6C6EA0CEAA6A484A6EAEA8662422242222022222222),
    .INIT_41(256'hF7F7F7F7F9F9F9F9F9F7F7F7F7D5B5B2B2904E4C4C4E4E90909090B292906E4C),
    .INIT_42(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7),
    .INIT_43(256'hF9F9FBFBFBFBFBFBFBFBFBFBFBF9F9F9FBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9),
    .INIT_44(256'h90909092B2B2B2B2D2D4D4F5F5F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_45(256'h000020202020202020202020202222424264648686A6A6C6C8EA0A0C2C2C4E70),
    .INIT_46(256'h0000002020200000000000000000000000222222222020202020202020202000),
    .INIT_47(256'hEF66444422668A88464466442200222222222222020000000000222222002000),
    .INIT_48(256'h22222222222244688DAFB1B1918F91B177777777777779999B99999B9B9B999B),
    .INIT_49(256'hEA0C0CA6A484A6EAEAA664422020202022222222222222222222222220202222),
    .INIT_4A(256'hF7F7D5B2B2926E4C4C4C4C70909090B2B2906E4C2A2A0A0A0AC8C6A6A6A6C6A6),
    .INIT_4B(256'hF9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F7F7),
    .INIT_4C(256'hFBF9F9FBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_4D(256'hF5F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFB),
    .INIT_4E(256'h202022424264648686A6A6C8EA0A0C2C2C2C4E70709090B2B2B2B2D2D2D2D4D4),
    .INIT_4F(256'h0000000020222222202020202020202020200000000020202020202020202020),
    .INIT_50(256'h2222442222222200000000000000222222200000202020202000000000000000),
    .INIT_51(256'h918F8F919977777757577779795757799B9B9999AC44244444AAAA6622444422),
    .INIT_52(256'h202022222222222222222222222222222020202222222222222222486B8FB1B1),
    .INIT_53(256'h909070B2B292906E2C2A2C0C0AE8C8A6A6A6C8A6C80C0CC88684A6E8EAA66442),
    .INIT_54(256'hF7D5D5F7F7F7F7F7F7F7F7F7F9F9F9F9F7F7F7F7F7D5B5B2B3B26E4E4C4C4C6E),
    .INIT_55(256'hF9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7),
    .INIT_56(256'hF9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9),
    .INIT_57(256'hEA0A2C2C4C4E6E709090B2B2B2B2B2D4D4D4D5F5F7F7F7F7F7F7F7F7F9F9F9F9),
    .INIT_58(256'h0000000000000000202020200000202000000020202222424264868686A6C8C8),
    .INIT_59(256'h0000002222000000002000000000000000000000000000202222222020202000),
    .INIT_5A(256'h57577979575777778822222266AA884422444444444422222222000000000000),
    .INIT_5B(256'h222222222020202022222222222222466B8D8F91918F8F919B79799999793555),
    .INIT_5C(256'h0AEAC8A6A6A6A8A6C8EA0CEA8484A6C8EAA66444222022222222222222222222),
    .INIT_5D(256'hF9F9F9F9F7F7F7F7F7D5D5B2B3B2906E4C4C4E4C6E906EB2B2B2906E4C2C2C2C),
    .INIT_5E(256'hF7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5D5F7F7F7F7F7F7F7F7F7),
    .INIT_5F(256'hFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F7F7F7F9F9F9F9F9F7F7F7F7F7F7F7F7F7),
    .INIT_60(256'hB2B2B2D4D5D5F5F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFB),
    .INIT_61(256'h2020200000000020222242424464848686A6C8E80A0A2C4C4E6E6E709092B2B2),
    .INIT_62(256'h0000000000000000000020222222222020200000000000000000000020202020),
    .INIT_63(256'h8888664444886644444402020200000000000000000000002000000000000000),
    .INIT_64(256'h222222466B8F8F8F91B1B191BB79799BBB9B5535575779775777793366222242),
    .INIT_65(256'h8684A6C8EAA88664222222222222222222222222222222222220202022222222),
    .INIT_66(256'hB3B3906E4C4C4C4C6E906E92B2B2906E6E2C2A0C0AEAC8C6C8A8A6A8C8C8ECEA),
    .INIT_67(256'hF9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F7F7F7F7F7F7D5D5B3),
    .INIT_68(256'hF9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9),
    .INIT_69(256'hF7F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9),
    .INIT_6A(256'h64646486A6A8C8EA0A2C2C4C4E6E70909092B2B2B2B2D4D4D5D5F7F7F7F7F7F7),
    .INIT_6B(256'h2222222020200000000000000000000000202020202020000000202022224242),
    .INIT_6C(256'h0000000000000000000000002000000000000000000000000000000000002222),
    .INIT_6D(256'hBB77799BBDBD775557577777797999EF442222448888444466A8664444222222),
    .INIT_6E(256'h2222222222222222222222222220202022222222222222468B8F8F8F91B1B1B1),
    .INIT_6F(256'hB2B290906E2C2A0A0AEAC8C8C8C8A6C8A6C8EAEAA684A6C8C8C8A66442422222),
    .INIT_70(256'hF7F5F7F7F7F7F7F9F9F9F9F7F7F7F7F7F7D5D5B2B2B3B2906E4C4C4C6E707090),
    .INIT_71(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_72(256'hF9F9FBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_73(256'h4E6E709090B2B2B2D2D4D4D5D5F5F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_74(256'h000000000020202020202000002020222242424464646486A6C8C8EA0C2C2C4C),
    .INIT_75(256'h0000000000000000000000000000000000202222222220202000000000000000),
    .INIT_76(256'h7977558844222244886644222222444422002222000000000000000000000000),
    .INIT_77(256'h2220202022222222222222446AAFAF8FB1B1B1B1BB77779BBBBD775777999979),
    .INIT_78(256'hC8C8A6C8C6A6C8EAA6A6A6C6C8EAC88442422222222222222222222222222222),
    .INIT_79(256'hF7F7F7F7F7D5D5B2B2B2B2906E4C4C4C4E6E706E90B2B2906E4E2C0A0A0AE8C8),
    .INIT_7A(256'hF7F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7D5D5D5F7F7F7F7F7F7F7F7F7),
    .INIT_7B(256'hF9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F5F5F5F7F7),
    .INIT_7C(256'hD5F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_7D(256'h002022222242424464648486A8C8E8EA0A2C2C4C4E6E707090B2B2D2D4D5D5D5),
    .INIT_7E(256'h0000000020222222222020202000000000000000000000000000000000000000),
    .INIT_7F(256'h2222222202022222000000000000002022222000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_67_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_67_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized12
   (p_63_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_63_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_63_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000000000000FFFE00),
    .INITP_01(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0000000000000FFFC0000000000000),
    .INITP_02(256'hFFFFFFFFFFFFFFFFFFFFFFE0000000000000FFFC0000000000000000000003FF),
    .INITP_03(256'hFFFFFFFFFFFE0000000000000FFFC0000000000000000000003FFFFFFFFFFFFF),
    .INITP_04(256'hF0000000000000FFF80000000000000000000003FFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_05(256'h000FFF80000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_06(256'h00000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8003000000),
    .INITP_07(256'h000000FFFFFFFFFFFFC07FFFFFFFFFFFFFFFFFFFFFF8003800000000FFF00000),
    .INITP_08(256'hFFFFFFC000003FFFFFFFFFFFFFFFFFFFC003C00000000FFF0000000000000000),
    .INITP_09(256'h007FFFFFFFFFFFFFFFFFFC001C00000000FFF0000000000000000000000FFFFF),
    .INITP_0A(256'hFFFFFF0FFFC011C00000000FFE0000000000000000000001FFFFFFFFFFE00000),
    .INITP_0B(256'h001E00000000FFE0000000000000000000003FFFFFFFFFF000000001FFFFFFFF),
    .INITP_0C(256'h0FFC0000000000000000000003FFFFFFFFC00000000001FFFFFFFFFFFF001F80),
    .INITP_0D(256'h000000000000003FFFFFFF80000000000007FFFFFFFFFFC000000000E0000000),
    .INITP_0E(256'h0007FFFFFFC00000000000001FFFFFFFFFF8000000000600000000FFC0000000),
    .INITP_0F(256'h00780000000000FFFFFFFFFE0000000000200000000FFC000000000000000000),
    .INIT_00(256'h688FB1B1B1B1B1B1BB77779BBBBB797779799B99797733662222226466442222),
    .INIT_01(256'hC6EAC88662424222222222424222222222222222222220002022222222222224),
    .INIT_02(256'h6E4C2C4C4E6E706E90B2B290706E2C0A0A0CEAC8C8C8A6C8C8C8C6EAC8A6A6C6),
    .INIT_03(256'hF7F7F7F7F7F7F7F7D5D5D5D5F7F7F7F7F7F7F7F7F7F7F7F7F7D5D5B290B2B290),
    .INIT_04(256'hF7F7F7F7F7F7D5D5D5D5D5F5F5F5F5D5D5F5F5F5F5F5F5F5F7F7F7F7F7F7F7F7),
    .INIT_05(256'hF9F9F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7),
    .INIT_06(256'hA8C8EA0A0A2C4C4E6E6E709090B2B2D2D5D5D5D5F5F7F7F7F7F7F7F9F9F9F9F9),
    .INIT_07(256'h00000000000000000000000000000000000000000020222222424264646486A6),
    .INIT_08(256'h0000002222222000000000000000000000000000000000002222222020202020),
    .INIT_09(256'hBBBB9B9999999B997957EF442222446686442222222222000022220200000000),
    .INIT_0A(256'h4242222222222222222220000022222222222224688DB1B1B1B1B1B1BB777799),
    .INIT_0B(256'h90704C2A2A2C0AE8C8C8C8C8C8C8A6C8EAC8A6C6A6EAEAA68464424222224242),
    .INIT_0C(256'hD5F5F7F7F7F5F5F7F7F7F7F7F7D5D5B2909090906E4C2C4C4C6E6E6E6E90B290),
    .INIT_0D(256'hD5D5D5D5D5D5D5D5F5F5F5F5F5F5F5F7F7F7F7F5F7F7F7F7F5F7F7F7D5D5D5D5),
    .INIT_0E(256'hF7F7F7F7F7D7F7F7F7F7F7D7D7D7D7D7D7D7D5D5D5D5D5D5D5D5D5D5D5D5D5D5),
    .INIT_0F(256'hB2B2D4D5D5D5D5D5F7F7F7F7F7F7F7F7F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_10(256'h00000000000000000020222222424264648686A8C8EA0A0A2C2C4E6E6E709092),
    .INIT_11(256'h0000000000000000000000202222222020202020000000000000000000000000),
    .INIT_12(256'h2222448866422222222200000044000000000000000000222222200000000000),
    .INIT_13(256'h0022222222222244688DAFB1B19191B1DD775777BBBBBB9B99999B9B7935AA44),
    .INIT_14(256'hC8C8C6C8EAC8A6C6A6E8EAC8A686644222224242424222222222222222220000),
    .INIT_15(256'hF5D5D5B2909090906E4C2C2C4C4C6E6E6E70909090704E2C2C2C0AEAC8C8C8C8),
    .INIT_16(256'hD5D5D5D5F5F5F5F5F5F7F7F5D5F5F7F7D5D5D5D5D5D5F5F5F5F5F5F5F7F5F5F5),
    .INIT_17(256'hB5B5B5B5B5B5B3B3B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D3D5D5D5D5D5D5D5D5),
    .INIT_18(256'hF7F7F7F7F7F7F7F7F7F7D7D7D7D7D7D7D7D7D7D7D7D5D5D5D5B5D5D5D5D5D5B5),
    .INIT_19(256'h224244646486A6A8C8EA0A0C2C4E6E6E709092B2B2D5D5D5D5D5D5D5F7F7F7F7),
    .INIT_1A(256'h2222202020202020000000000000000000000000000000000000000000202222),
    .INIT_1B(256'h2222000000000000000000222222200000000000000000000000000000002022),
    .INIT_1C(256'hB19191B1DD995577BBBBBD997799BBBB79116644222244884422222222000000),
    .INIT_1D(256'hC6A66442222242424242422222222222222200000022222222222246688B8DB1),
    .INIT_1E(256'h2C4C6E706E6E909090706E4C2C2C0CEAE8C8C8C8C8C6C8C8EAE8C6C6A6E8EAEA),
    .INIT_1F(256'hD5D5F5D5D5D5D5D5D5D5D5F5F5F5F5F5F5F5D5D5D5D5D5B29090906E6E4C2A2A),
    .INIT_20(256'h70909090909090B0B0B0B2B2B2D2D2D3D3D5D5D5D5D5D5D5D5D5D5F5D5D5D5D5),
    .INIT_21(256'hD5D5D5B5B5B4B5B5B39292929292929292929090707090909090907070707070),
    .INIT_22(256'h4E4E6E70909092B2B4D5D5D5D5D5D5D5F7F7F7F7F7F7F7F7F7F7F7F7F7D5D5D5),
    .INIT_23(256'h0000000000000000000000000000000000202222224244646486A6C8EAEA0C2C),
    .INIT_24(256'h2220000000000000000000000000000000202222222220202020202000000000),
    .INIT_25(256'h7799BBBB57CC4442222266AA4422222200000022220000000000000000002022),
    .INIT_26(256'h222020222222200000202222222222466A8D6D8FB1B1918FDDBB775599BBDD99),
    .INIT_27(256'h2C2C2C0AEAC8C8C8C8C6C8EAEAE8C6A6A6E8EAEAC8A664422222424242424222),
    .INIT_28(256'hD5D5D5D5D5D5D5D5D5D5D5B2906E6E6E6E4C2A2A2C4C4C704E4E709090706E4E),
    .INIT_29(256'hB2B2D2D2D2D2D2D3D3D3D5D5D5D5D5F5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5),
    .INIT_2A(256'h706E4E4E4E4E4E4E4C4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E6E6E6E90909090B2),
    .INIT_2B(256'hD5D5D5D5F5F7F7F7F7F7F7F7F7F7F7F7D5D5B5B5B2B292909092929270707070),
    .INIT_2C(256'h0000000000222222224244648486A6C8EA0C2C2C4C4E6E909092B2B2B4B4B4D4),
    .INIT_2D(256'h0000000000202220202020202020202020000000000000000000000000000000),
    .INIT_2E(256'h4422222200002222220000000000002222222222220000000000000000000000),
    .INIT_2F(256'h222222466A8D6D6DB1B1918FDDBB795599DDDDBB9999BB993388224422224488),
    .INIT_30(256'hEAEAC8A6A6E80A0AEAC884422242424442424220202020222222200000202222),
    .INIT_31(256'h906E6E6E6E4C2A0A2A2C2C704E4E6E909090704E2C2C2C0C0AE8E8C8C8C8C8EA),
    .INIT_32(256'hD3D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D3D3D5D5D5D5D5D5D5D5D5D5D5D5B2),
    .INIT_33(256'h2C2C2C4C4C4C2C2C2C2C2C4C4E4E6E6E6E6E6E9090B0B2B2B2B2B2B2B2B2B3D3),
    .INIT_34(256'hF7F7D5D5B5B292909070706E707070704E4E2C2C2C2C2C0A0A0A0A0A0A2A2C2C),
    .INIT_35(256'h86A6C8E80A2C2C2C4E6E9090B2B2B2B2B2B4B4B4D5D5D5F5F7F7F7F7F7F5F5F5),
    .INIT_36(256'h2020202000000000000000000000000000000000002020202022222242426464),
    .INIT_37(256'h0022222222222222220000000000000000000000000000000020202000002020),
    .INIT_38(256'hBBBB995777DDBB9977777933CC44224444446666442222220000222222000000),
    .INIT_39(256'h4242424442424220202022222222222000202222222222468A8D6D6D8FB1918F),
    .INIT_3A(256'h4E4E6E909090706E2C2A2C2C0CEAE8C8C8C8C8E8EAEAE8C8A6C80A0C0CEAA662),
    .INIT_3B(256'hD5D5D5D5D3B2B2D3D5D5D3B2D2D2D2D2D2B2B2B2906E6E6E6E4C2A0A0A2A2A4E),
    .INIT_3C(256'h2C4C4C4C4C4C4C6E8E9090909090B0B0B2B2B2B2B2B3D3D3D5D5D5D5D5D5D5D5),
    .INIT_3D(256'h4E4E4E4E2C0C0A0A0A0AEAE8E8EAEAEAEA0A0A0A0A0A0A0A0C0C0A0A0A0C2C2C),
    .INIT_3E(256'hB2B2B2B2B2B2B4B4D5D5D5F5F7F7F7F7F5F5F5F5D5D5B39290704E4E4E4E4E4E),
    .INIT_3F(256'h000000000000000000202020202222224244648486A6C8EA0A2C2C4E6E9090B2),
    .INIT_40(256'h0000000000000000000000002020202000000020202000000000000000000000),
    .INIT_41(256'hAA44444444464444222222220000222200000000002222222222002222000000),
    .INIT_42(256'h2222222020202222222222468A8F6D6D8FB19191BBBB997755BB997755555711),
    .INIT_43(256'h2C0AE8C8C8C8C8C8EAEAEAC8C6C60A2C2C0CC864424242444442422020202222),
    .INIT_44(256'hB2B2B2B2B2B2B2B2906E4C4C4C4C2A0A0A0A2A4C4E4C4E709090906E2C0A2C2C),
    .INIT_45(256'h6E6E8E9090909090B2B2B3B3B3B3B3D5D5D5D5D5D3B3D3D3B2B2B2B2B3D3B3B2),
    .INIT_46(256'hE8E8E8E8E8E8EAEAEAE8E8E8EAE8E8E8EAEA0A0A0A2A2C2C2C2A2A4C6E6E6E6E),
    .INIT_47(256'hF5F5D5D5D5F7D5D5B290706E4E4E4E4E4E4E2E2E2E2E2C2C0C0AEAEAE8E8C8C8),
    .INIT_48(256'h2022224242646484A6A6C8EA0A2C2C4E709092B2B2B2B2B2B2B2B4B4D5D5D5F5),
    .INIT_49(256'h2020202000000000000000000000000000000000000000000000000000202020),
    .INIT_4A(256'h0022220000000000002022222200002222200000000000000000000000000000),
    .INIT_4B(256'h8DAF8F6D8F8F91B1BBBDBB77339B997755555711884444224444444422222200),
    .INIT_4C(256'hC8C6E82C2C2EC884404242644442422020202222222222202022222222222246),
    .INIT_4D(256'h2C2C2A0A0A080A2A2C2C2C6E909090704E0A0C2C2C0AE8C8C8C8C8C8E8EAEAEA),
    .INIT_4E(256'hB2B2B2B3B3B3B3B3B3B3B3B3B2B2B2B2B2B2B2B2B2B2B2B2B29090906E4C2C2C),
    .INIT_4F(256'hC8C8C8C8C8C8E8E8EA0A0A0A0A0A0A2A4C4C6E6E6C6E6E6E90909090B2B2B3B3),
    .INIT_50(256'h4E2C2E2E2E2C2C2C0C0C0CEAEAEAEAC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_51(256'h0C2C4E6E70909092929292B2B2B2B2B4D5D5D5D5D5D5D5B3B2B3B2906E4E4E4E),
    .INIT_52(256'h00000000000000000000000000000000002020202222224244648486A6C8EA0A),
    .INIT_53(256'h2200002022000000000000000000000000000020202020200000000000000000),
    .INIT_54(256'h11799979777977EE662222222444224422222222444422000000222220002222),
    .INIT_55(256'h64424220202222222222222020222222222222468DAF8F8F8F8F91B1BBDDDD99),
    .INIT_56(256'h4E6E706E4E0C0A0C0C0AE8C8C8C8C8C8C8EAEA0AEAC8E80A2C4EEA8442424264),
    .INIT_57(256'hB2B2B2B0B0B2B29090909090706E6E4E4C2A0A0A0A0A0A0AE8E8E8E80A0A0A2C),
    .INIT_58(256'h0A0A0A0A2A2C4C4C4C4C4C6E6E6E9090B0B2B2B2B2B2B2B2B3B3B3B3B3B3B3B3),
    .INIT_59(256'hCAEAC8C8C8C8C8C8C8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8E8E8EA0A),
    .INIT_5A(256'hB2B2B2B2B2D2D2D2B2B2B290904E4E4C2C2C2C2C2C0C0C0C0C0C0A0AEAEAEAEA),
    .INIT_5B(256'h20222220202020202222224264648486A6C80A0C2C2C4E709090909092929292),
    .INIT_5C(256'h0000000000002020202000000000000000000000000000000000000000000000),
    .INIT_5D(256'h4444444444222222442222000000222222222222220000202200000000000000),
    .INIT_5E(256'h20222222222222468BAF8F8F8F8F8FB1BBDDDD9B3555BBBB9979338844222244),
    .INIT_5F(256'hC8C8C8A8C8C8EAEAEAE8E8082C4E0AA662426464646442202022222222222220),
    .INIT_60(256'h4E4C4C2C2C0A0A08E8EAE8E8C8C8C8C8E8E8E80A2C2C2C2C0CEAEAEAEAEAC8C8),
    .INIT_61(256'h6E6E6E90909090909092B2B2B3B3B3B3B3B3B2B2B2B290909090909070706E6E),
    .INIT_62(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8E8E8E8E8E8080A0A2A2A2A2C4C4C),
    .INIT_63(256'h4E4C2C2C0A0A0A0A0A0AEAEAEAEAEAEAEAE8E8C8C8C8C8C8C8A6A6A6A6A6A6A6),
    .INIT_64(256'h648484A6C8EA0A2C2C4E709090909090929292B2B2B2B2B2B2B2B2B292906E4E),
    .INIT_65(256'h0000000000000000000000000000000000000000202222202000202222224242),
    .INIT_66(256'h0020222222222222000000222200000000000000000000000020202000000000),
    .INIT_67(256'h8F8F8FB1BDDDDDBB7755BBBB9935CE6642224266464444444422222244220000),
    .INIT_68(256'h0A2E0CA66242646464644220202222202222222020202222222222468BAFB18F),
    .INIT_69(256'hA6A6A6A6C8C8C8E8EAEAEAEAEAC8C8C8C8C8A8A6A6A6A6A6A6A8C8EAEAE8E8E8),
    .INIT_6A(256'hB2B3B3B3B3B2B29090909090909090706E4E4E4E4C2C2C2A0A0AE8E8E8C8C8C8),
    .INIT_6B(256'hA6A6A6A6C8C8C8C8C8C8E8E8E8080A0A0A2A2A4C4C6E6E6E6E7090909092B2B2),
    .INIT_6C(256'hE8EAEAEAE8E8C8C8C8C8C8A6A6A6A6A6868686A6A6868686868686868686A6A6),
    .INIT_6D(256'h929292929292B2B2B2B2B2B2B2B2B290704E2C2C2C2C0A0A0AEAEAEAEAE8E8E8),
    .INIT_6E(256'h00000000000000000020202000000022224242426486A6A6C8EA0C2C4E4E7092),
    .INIT_6F(256'h0000000000000000000000002222202000000000000000000000000000000000),
    .INIT_70(256'h99338A4422224466444444442222224444220000222222222222220000002022),
    .INIT_71(256'h202222202022222020202222222222448BAFB1AF8F8F8FB1DDDDDDDD995599BB),
    .INIT_72(256'hC8C8A8A6A6A6A686868686868686A6C8C8E8C8C6E82C0CC86442648486646420),
    .INIT_73(256'h6E6E706E4E4E4C4C2C2C0A0A0AEAE8C8C6C8A6A6A6A6A6A6A6C8C8C8C8C8C8C8),
    .INIT_74(256'hE8E8E8080A0A2A2C4C4C6E6E6E6E6E909092B2B2B2B2B2B2B292909090909090),
    .INIT_75(256'hA6A6A6A6848484868686848484868686868686868686A6A6A6A6C8C8C6C6C6E8),
    .INIT_76(256'h9290906E4E2C0C0A0A0AEAE8E8EAEAEAE8C8C8C8E8EAEAEAEAE8E8E8C8C8C6A6),
    .INIT_77(256'h000000222242426484A6A6C6E80A2C2E4E70909292B292929292929292929292),
    .INIT_78(256'h2222200000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h2222444422220022224422222222220000002222000000000000000000000000),
    .INIT_7A(256'h222222468BAFB1B1B18F8FB1DDDDDDBD99355799993366442222446644446622),
    .INIT_7B(256'h64648686A6C8C8C6C6EA0CC88442648686866420202222202022202020202222),
    .INIT_7C(256'hE8E8C8C6A6A6A686868686A6A6A6A6A6A8C8C8A8C8C8A8A68686868664646464),
    .INIT_7D(256'h6E6E6E909092B2B29292B2B2929090909070706E6E6E6E4E4C2C2C2C2C0A0AE8),
    .INIT_7E(256'h868686868686868686868686A6A6A6C6C6C6C6E8E8E8E8E8080A0A2A4C4C4E6E),
    .INIT_7F(256'hE8E8E8E8E8E8EAEAEA0A0A0A0AEAEAEAE8C8C8C8C6A6A6A6A6A6A6A686868686),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_63_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_63_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized13
   (p_59_out,
    clka,
    ena,
    addra);
  output [8:0]p_59_out;
  input clka;
  input ena;
  input [16:0]addra;

  wire [16:0]addra;
  wire clka;
  wire ena;
  wire [7:7]ena_array;
  wire [8:0]p_59_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0007FFFFFFFFC0000000000000000000FFC0000000000000000000007FFFFFF0),
    .INITP_01(256'hF80000000000000000000FF8000000000000000000000FFFFFFE007FE0000000),
    .INITP_02(256'h0000000000FF8000000000000000000001FFFFFFC07FFFE0000000003FFFFFFF),
    .INITP_03(256'hF0000000000000000000001FFFFFE07FFFFFE000000001FFFFFFFE0000000000),
    .INITP_04(256'h000000000003FFFFFC3FFFFFFFC00000001FFFFFFFC00000000000000000000F),
    .INITP_05(256'h7FFFFFFFFFFFFFFE00000001FFFFFFFC00000000000000000000FF0000000000),
    .INITP_06(256'hFFFFFC0000001FFFFFFF800000000000000000000FF000000000000000000000),
    .INITP_07(256'h01FFFFFFF800000000000000000000FF000000000000000000000FFFFFFFFFFF),
    .INITP_08(256'h0000000000000000000FE000000000000000000000FFFFFFFFFFFFFFFFF00000),
    .INITP_09(256'h00000000FE000000000000000000001FFFFFFFFFFFFFFFFF8000003FFFFFFF00),
    .INITP_0A(256'h00000000000000000003FFFFFFFFFFFFFFFFFE000003FFFFFFF0000000000000),
    .INITP_0B(256'h000000007FFFFFFFFFFFFFFFFFF000007FFFFFFE000000000000000000000FE0),
    .INITP_0C(256'hFFFFFFFFFFFFFFFF80001FFFFFFFE000000000000000000000FE000000000000),
    .INITP_0D(256'hFFFFFC0003FFFFFFFF000000000000000000000FC000000000000000000007FF),
    .INITP_0E(256'hFFFFFFF000000000000000000000FE00000000000000000000FFFFFFFFFFFFFF),
    .INITP_0F(256'h0019F000000000000F800000000000000000000FFFFFFFFFFFFFFFFFFFE0007F),
    .INIT_00(256'hEA0C2C4E6E70909092B29290909290909090909070704E2C2C0C0A0AEAE8E8E8),
    .INIT_01(256'h0000000000000000000000000000000000000000000020222242426486A6A6C8),
    .INIT_02(256'h2222220000002200000000000000000000000020222020000000000000000000),
    .INIT_03(256'hBDBDBDBBBB555599993346222244664442666622222244442200002244442222),
    .INIT_04(256'hA662648686664422222222202020202020202222222222468DAFB1B1B1B19191),
    .INIT_05(256'h86868686A6A6A6A8A8A8A88686868686646464646464648486A6A6A6A6C8EAE8),
    .INIT_06(256'hB2909090706E6E6E6E4E4C4C2C2A2A0A0A0AEAE8C8C8C6A6A6A6868686868486),
    .INIT_07(256'hA6A6A6C6C6C6C6C6C6E8E8E8E8080A2A2C4C4C4C4E6E6E909090B0B09090B2B2),
    .INIT_08(256'h0A0A0AEAE8E8E8E8E8C6C6C6C6A6A6A6A6A68686868686848486848486868686),
    .INIT_09(256'h90909070909090706E4E2C0A0A0A0AEAE8C8E8E8E8E8E8E8EA0A2C2C2C2C0C0A),
    .INIT_0A(256'h0000000000000000002020224244648486A6C8E80A2C4C4E70909090B2B2B290),
    .INIT_0B(256'h0000000000002020200000000000000000000000000000000000000000000000),
    .INIT_0C(256'h2242664222666622222244442222224444442222222220000022220000000000),
    .INIT_0D(256'h2020202020202222222222668DAFB1B1B1B191B1BD9BBBBDDD99557777EF4444),
    .INIT_0E(256'h8686868664646464646464646486868684C6EAEAC88464868666642222222220),
    .INIT_0F(256'h2A2A0A0A0AE8E8C8C8A6A6A686868686868484848484846484868686A6A88686),
    .INIT_10(256'hE8E80A0A2A2A2C4C4C4C6E6E9090909090B0B2B3B2909090706E6E6E4E4C4C4C),
    .INIT_11(256'hC8C6A6A6A6A6A68686868686868686868686A6A6A6A6A6C6C6C6C6C6C6E8E8E8),
    .INIT_12(256'h0A0AEAE8E8E8E8E8EA0A0A0C2C2C2C2E4E2E2C0C0C2C2C2C0A0A0AEAE8E8C8C8),
    .INIT_13(256'h42646484A6A6E80A2C2C4E6E90909090B2B29292909070707070704E4C2C0A0A),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000020202222),
    .INIT_15(256'h2222444442222222000000002222220000000000000000000020222000000000),
    .INIT_16(256'h8BAFB1B1B1B1B1B199999BBBBB77333333AA4444222264222244442222224422),
    .INIT_17(256'h6464848484A6E8EAC88464868686642222222220202020202020202222222246),
    .INIT_18(256'h8686868684646464646464646464868686868686868686866464646464646464),
    .INIT_19(256'h9090909090B0B2B2B2909090706E6E6E4E4C2C2C2A0A0AE8E8C8C8C6A6A6A686),
    .INIT_1A(256'h86A6868686A6A6A6A6A6A6C6C6C6C6C6C8E8E8E8E8E8E80A0A0A2A2C4C4E6E6E),
    .INIT_1B(256'h4E4E50504E4E4E4E4E4E4E4E2E2C0C0A0A0A0AEAE8E8C8C6A6A6A6A6A6A68686),
    .INIT_1C(256'h90929290929290909070707070704E2C0A0A0AE8E8E8E8EAEA0A0A0A0A2C2C4E),
    .INIT_1D(256'h000000000000000000000000000000202020224242648486A6C8EA2C2C4E4E70),
    .INIT_1E(256'h2222000000000000000000000022222000000000000000000000000000000000),
    .INIT_1F(256'hBB993311EE662222222244224444442222224222222244442222222200000022),
    .INIT_20(256'hA8886422222222202020202020202022222222468B8F8FB1B1B1B3B199999BBB),
    .INIT_21(256'h6464646464668686868686868664646464646444446464648484C8C8C8846486),
    .INIT_22(256'h706E6E4E4C2C2C2A2A0AE8E8C8C6C6A6A6868684848484846464646464646464),
    .INIT_23(256'hC6C6C6C6C8C8E8E8E8E8E8080A0A2A2C4C4E6E90909090B2B2B2B09090909090),
    .INIT_24(256'h504E4E4E4E2C2C2C0A0AE8C8C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6),
    .INIT_25(256'h704E2C0A0A08E8E8E8E80A0A0A2C2C2C2C4E4E70707070707070709292927070),
    .INIT_26(256'h0000002020204242646484A6C6E80C4C4E4E6E90929292909290909090707070),
    .INIT_27(256'h2022200000000000000000000000000000000000000000000000002222000000),
    .INIT_28(256'h4444222222444422222244222222222222002242222200000000000000000000),
    .INIT_29(256'h20200020222222468A8D8FB1B1B3B3B1BB99BBBBBBBB5711AA44222222224222),
    .INIT_2A(256'h866464646464644444444464646486A8A8846486A8A866222022222020202020),
    .INIT_2B(256'hC6A6A6A686868484848484646464646464646464646464646464668686868686),
    .INIT_2C(256'h0A0A2C4C4E6E70909090B2B2B2B2909090909090706E6E4E4C2C2A2A0A0AE8C8),
    .INIT_2D(256'hE8E8E8C8C8A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C8C8E8E8E8E8E808),
    .INIT_2E(256'h2C4E4E4E4E4E7070929290707090B2D5D7D5B5929292B5B592704E4E4C2C0AE8),
    .INIT_2F(256'hE80C4E4E6E6E709090929292929090909070706E4E4C2A0A080808080A0A2C2C),
    .INIT_30(256'h00000000000000000000000000000022000000000000002020224242648486A6),
    .INIT_31(256'h2222222222202222220000000000000000000000202000000000000000000000),
    .INIT_32(256'hB1B1B191BBBBBBBB9BBB7911AA44444442222222444222422244442244442222),
    .INIT_33(256'h646486A6A8868486A8866422222222202020202020200020202222468A8F8FB1),
    .INIT_34(256'h8464646464646464646464646464648686868684646464646464644444444464),
    .INIT_35(256'hB3B3B29090909090706E6E4E4C2C2A0A0AEAE8C8C6A6A6A68686848484848484),
    .INIT_36(256'hA6A6A6A6A6C6C6C6C6C6C6C8C8C8E8E8E8E8E80A0A2A2C4C4E70909092B2B2B2),
    .INIT_37(256'hB5B5B5B5B5B5D5D7D7D7D7D7B5706E4E4E4C2C0A0A0AEAE8C8C8C8C8C8C8A6A6),
    .INIT_38(256'h90909090706E4E4C2C2A0A0A0A0A0A0A2A2C2C4E4E4E4E4E6E709292B5B5B5B5),
    .INIT_39(256'h0000000000000000000000202042426484A6A6C80A2C4E6E6E70909090929292),
    .INIT_3A(256'h0000000000000000200000000000000000000000000000000000000000000000),
    .INIT_3B(256'h8842444444424442222222222222222222222222442200002022222200000000),
    .INIT_3C(256'h222222202020202020002020222222468A8F8FAFB1B19191BBBB999BDDDDBB33),
    .INIT_3D(256'h848486868686846464646464646464646464646486646486A6A686A8A8866442),
    .INIT_3E(256'h4C2C0A0A0AE8E8C8C8A6A6A68686868686868484848484848484848484848484),
    .INIT_3F(256'hC8C8C8E8E8E8EA0A2A2C2C4E6E709092B2B3B3B3B3B3B390909090906E6E6E4E),
    .INIT_40(256'hD7B5B59290704E4C2C2C0A0AE8E8C8C8C8C8C6C6C6C6A6C6C6C6C6C6C6C8C8C8),
    .INIT_41(256'h2A2A2C2C2C4E4E5070707070909292B5B5B5D5D5D5D7D7D7F7F7F9F9F9F9F9F7),
    .INIT_42(256'h2242626486A6C6EA2C4E6E709090909090929292909290706E4E4C2C2C2A0A0A),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000020),
    .INIT_44(256'h2222222222202222222200002222222200000000000000000000000000000000),
    .INIT_45(256'h224222468A8D8F8FB1B19191BB9999BBBDDF99F1664244424242424422222222),
    .INIT_46(256'h64646464646464648664646686A6A6A8A8866442222222202020222020002020),
    .INIT_47(256'hA6A6868686868686868484848686868686868686868686A68686868686866464),
    .INIT_48(256'h70909293B3B3B3B3D5B3B3B2909090906E6E6E4C2C2A0A0AE8E8C8C8C8A6A6A6),
    .INIT_49(256'h0AEAE8E8C8C8C8C8C6C8C6C6C6C6C6C6C6C8C8C8C8C8C8E8E8E80A0A2C2C4E4E),
    .INIT_4A(256'h9292B2B4B5B5D5D5D5D7F7F7F7F9F9F9F9F9F9F9F9F7D7D7B5B290704E4E2C2C),
    .INIT_4B(256'h90909092929292929290706E4E4C2C2C2C2C2C2C2C4C4C4E4E4E707070707090),
    .INIT_4C(256'h00000000000000000000000000000000000020224242648486A6E80C4E6E7090),
    .INIT_4D(256'h2222222222000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'hBB999BBBBDDD57CE664422224444222220202222222222222222222222222222),
    .INIT_4F(256'h8686A8A8A8A86442222222202020222020202020222222468A8D8FAFB1B1B1B1),
    .INIT_50(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6868686868686848464646486646464),
    .INIT_51(256'hB2909090706E6E4C2C2A0A0AE8E8C8C8C8C6A6A6A6A6A6A6A6A6A6A6A68686A6),
    .INIT_52(256'hC6C6C6C6C8C8C8C8E8E8E8E8E8EA0A2C2C4E4E70709092B3B3B3B3B5D5D5B3B3),
    .INIT_53(256'hF7F7F7F9F9F9F9F9F9F9F9F7F7D5B59290704E4C2C0A0AEAE8C8C8C8C8C8C6C6),
    .INIT_54(256'h4C2C4C4E4E4E4E4E4E4E4E4E6E707070707090929292B2B2B4B5D5D5D5D5D7F7),
    .INIT_55(256'h000000000000222242626486A6C80A4E707090B2B2B2B2B29292929290706E4E),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h4444222220222222222222222222222222202222222222222222000000000000),
    .INIT_58(256'h2020222220202020202222468B8D8FAFB1D3B3B1BBBBBBBBBDBB35CC66442242),
    .INIT_59(256'hA6C8C8A8A8A8A6A6868686868684848484646464648688A8A8A8642222222222),
    .INIT_5A(256'hE8E8C8C8C6C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_5B(256'hEA0A0A2C4E4E70709092B3B3B5D5D5D5D5D5B5B3B3B29290906E6E4C2C0A0AE8),
    .INIT_5C(256'hF7F7D5D5B2B2906E4C2C2A0AEAE8C8C8C8C8C8C8C8C8C8C8C8C8C8E8E8E8E8E8),
    .INIT_5D(256'h6E707070707092929292B2B2B4D4D4D5D5D5D5D7F7F7F7F9F9F9F9F9F9F9F9F9),
    .INIT_5E(256'hC80A2C709092B2B2B2B2B2B292929292906E4C2C2C4C4E6E6E6E6E6E6E6E6E6E),
    .INIT_5F(256'h00000000000000000000000000000000000000000000000000002242426484A6),
    .INIT_60(256'h2222222222002220002222222222220000000000000000000000000000000000),
    .INIT_61(256'h8BAF8FAFB1B1B1B1BBBBBBBDBB9B33CC66222244444422202022222222222222),
    .INIT_62(256'hA686868686866464648686A8A8A8642220222222202022222020002020222246),
    .INIT_63(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8A8A8A8A8A8A8A8),
    .INIT_64(256'hD5D5D5D5D5D5D5D5B3B2929290706E4C2C2A0AE8E8E8C8C8C8C6C6A6A6A6A6A6),
    .INIT_65(256'h0AEAE8C8C8C8C8C8C8C8C8C8C8C8C8E8E8EAEA0A0A0A2C2C4E70909092B2B3B3),
    .INIT_66(256'hB2B2B2D4D5D5D5F7F7F7F7F7F9F7F9F9F9F9F9F9F7F7D5D5D5B2906E6E4C2C2A),
    .INIT_67(256'h92929290704E4E4E4E4E6E6E6E6E6E6E6E6E6E4E6E6E7070707090929292B2B2),
    .INIT_68(256'h00000000000000000000000000202242646486A6EA2C6E9092B2B2B2B2B2B2B2),
    .INIT_69(256'h2220000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h9957EFAA66222222422222200020222222222000202222220022222020224422),
    .INIT_6B(256'hA8A86422202222202020202220200000222222468AAF8FAFB1B1B191BDBDDDBD),
    .INIT_6C(256'hC6C8C8C8C8C8C8E8E8C8C8C8C8C8A8A8A8A8A8A8A8A6A6A686868664646486A8),
    .INIT_6D(256'h906E6E4C2C2A0A0AE8E8C8C8C8C8C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6),
    .INIT_6E(256'hC8C8C8E8E8EA0A0A0A2C2C4E70909293B3B3B5B5D5D5D5D5D5D5D5D5B3B3B292),
    .INIT_6F(256'hD5D5D5B5B5B2D5D5D5D5D5D5D4B290906E4C2C2A0A0AE8E8C8E8C8C8C8C8C8C8),
    .INIT_70(256'h6E6E6E6E4E4E4E4E4E6E6E6E6E707090909090B2B2B2B2D4D5D5D5F5F5D5D5D5),
    .INIT_71(256'h222242426484A6C80C4E709292B2B2B4B2B2B2B292909090704E4E6E6E6E7070),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h2222222222200000202222222222222222222222000000000000000000000000),
    .INIT_74(256'h20200002222222468AAF8FAFB1B1B191BDBDBDBB77310FCA6622222222222222),
    .INIT_75(256'hC8C8C8C8C8C8C8A8A8A8A8A8A8A88686646486A8A8A864222222222020202020),
    .INIT_76(256'hC8C8C8A6C6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8E8E8EAE8E8EAEAEAEAEAE8),
    .INIT_77(256'h9092B3B5B5D5D5D5D5D5D5D5D5D5D5D5B5B3B29290706E4C2C2A0A0AE8E8C8C8),
    .INIT_78(256'hB2B2B2906E4C2A0A0A0A0AE8E8E8E8C8C8C8C8C8C8C8C8E8EA0A0A0A2C2C4E6E),
    .INIT_79(256'h6E6E7070709090B2B2B2B2B2B2B2B2B090906E6E6E6E6E4C4C4C6E6E6E6E90B2),
    .INIT_7A(256'hB2B2B4D4B4B2B2B2929090706E6E6E70707070706E6E6E6E4E4E4E4E4E6E6E6E),
    .INIT_7B(256'h00000000000000000000000000000000000000002222424264A6C6EA2E7092B2),
    .INIT_7C(256'h4444222222222200000000000000000000000000000000000000000000000000),
    .INIT_7D(256'hAFB1B1919B9B9B9977EEECAA6422222222222222222222222220002022222222),
    .INIT_7E(256'hA8A8A88686648686A8A86422222222202020202020220022222222468AAFAF8F),
    .INIT_7F(256'hA6A6A6C8C8C8C8E8E8EAEA0A0AEAEA0A0A0A0A0AEAE8C8C8C8C8C8C8A8A8A8A8),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra[11:0],1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_59_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_59_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_i_1 
       (.I0(addra[15]),
        .I1(addra[16]),
        .I2(addra[13]),
        .I3(addra[12]),
        .I4(ena),
        .I5(addra[14]),
        .O(ena_array));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized14
   (p_55_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_55_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_55_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h000000F800000000000000000001FFFFFFFFFFFFFFF07FFE000FFFFFFFFF0000),
    .INITP_01(256'h00000000000000001FFFFFFFFFFFF80F807FF000FFFFFFFFF0000003FFC00000),
    .INITP_02(256'h000003FFFFFFFFFFF81FFF00FF801FFFFFFFFF0000007FFE00000000000F8000),
    .INITP_03(256'hFFFFFC07FFF803F801FFFFFFFFF000001FFFF00000000000E000000000000000),
    .INITP_04(256'h0001803FFFFFFFFF800003FFFF00000000000C000000000000000000003FFFFF),
    .INITP_05(256'hFFFFF800003FFFF80000000000C000000000000000000007FFFFFFFFFF007E00),
    .INITP_06(256'hFFFF80000000000C00000000000000000000FFFFFFFFFF0020000000000FFFFF),
    .INITP_07(256'h0000F00000000000000000000FFFFFFFFF80000000000001FFFFFFFFFF800001),
    .INITP_08(256'h00000000000001FFFFFFFFF00000000000003FFFFFFFFFF800000003F8000000),
    .INITP_09(256'h001FFFFFFFFE0000000000000FFFFFFFFFFF800000000180000000000E000000),
    .INITP_0A(256'hC0000000000000FFFFFFFFFFFC000000B0000000000000C00000000000000000),
    .INITP_0B(256'h0007FFFFFFFFFFC000000FC000000000000800000000000000000003FFFFFFFF),
    .INITP_0C(256'hFFFC0000003F800000000000000000000000000000003FFFFFFFF80000000000),
    .INITP_0D(256'h7C00000000000000000000000000000007FFFFFFFF800000000000007FFFFFFF),
    .INITP_0E(256'h00000000000000000000007FFFFFFFF00000000000000FFFFFFFFFFFC0000000),
    .INITP_0F(256'h00000000000FFFFFFFFE00000000000003FFFFFFFFFFFC000000000000000000),
    .INIT_00(256'hD5D5D5D5B5B5B2B290906E4C2C2A0A0AE8E8C8C8C8C8C8C6C6C6C6A6A6A6A6A6),
    .INIT_01(256'hE8E8E8E8E8C8C8C8C8C8E8E80A0A0C2C2C4E4E7092B3B5B5D5D5D7F7D5D5D5D5),
    .INIT_02(256'h6E6E4C4C2A2A0808082A0808E8E8E6E8E8082A4C6E6E90906E4C2C2A0A0A0AE8),
    .INIT_03(256'h6E707090909070706E6E6E6E4E4E4E4E6E6E6E4E4E4E6E6E7090909090908E8E),
    .INIT_04(256'h00000000000000002242426284A6E82C7092B2B2B4B4D4D4B4B2B2B29090706E),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h4422222222202222222222222222222222222244444422222222000000000000),
    .INIT_07(256'h222222202020202020220020222222468AAFAF8F8FB1B1B19B79575555CCAA88),
    .INIT_08(256'h0C0A0A0A0C0A2C2C0C0AEAEAC8C8C8C8C8C8C8C8C8A8A8A686868486A8A86422),
    .INIT_09(256'h4C2C2A0AE8E8C8C8C8C8C8C6C6C6C6C6C6C6C6A6A6A6C6C8C8C8E8E8EAEA0A0C),
    .INIT_0A(256'h0A0A2C2C4E6E709092B3B5D5D5D5F7F7F7D7D7D5D5D5D5D5D5D5B5B3B2908E6E),
    .INIT_0B(256'h08E8E6C6A4A4A4C4C6082A4C4E4E4C2C2A0A0A0AE8E8E8E8E8E8E8E8E8E8E8EA),
    .INIT_0C(256'h6E6E6E6E6E4E4E4E4C4E6E709090706E6E4C2A0A08E8E6E6E6E8E8E8084C4C2A),
    .INIT_0D(256'h84C6EA4C90B2B2B4D4D4D5D4D4B2B2B290909070909090909090706E6E6E6E6E),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000002022424264),
    .INIT_0F(256'h2222222222222244442222222200000000000000000000000000000000000000),
    .INIT_10(256'h2222424468ADAF8F8FB1B1B1BB79351133F1CA88442222222000202222222222),
    .INIT_11(256'hEAC8C8C8C8C8C8C8C8C8A8A8A6868686A8A86422222220202020202020222220),
    .INIT_12(256'hC6C6C6C6C6C6C6C6A6C6C6C8C8C8E8EAEA0A2C4E70505070704E4E4E4E2C0CEA),
    .INIT_13(256'hD5F7F7F7F7F7F7D7D7D7D7D5D5D5D5B3B3B2906E4E2C2A0AEAE8E8C8C8C8C8C6),
    .INIT_14(256'h0A2C2C2C2A0A0A0A0AE8E8E8E8E8E8E8E8E8E80A0A2C2C4E4E709092B3D5D5D5),
    .INIT_15(256'h6E4E4C2A08E8C6C6C6C6E60A4E92927070D7D7B57070702EEAC8C68482A4C6E8),
    .INIT_16(256'hB4B2B2B2B2909090909292909090706E6E6E6E6E4E4E4E4E4C4C2C4C4C4E6E6E),
    .INIT_17(256'h0000000000000000000000000000002242426484A6C82C6EB2B2B2D4D5D5D5D5),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h773511EFCECC8844002222222222202222222222222222222222424222002022),
    .INIT_1A(256'hA8868686A8A8642222222020202020202022222222424244688DAF8F8FB1B1B3),
    .INIT_1B(256'hE8EAEA0A0A0C4E709292929292707070704E2C0AEAC8C8C8C8C8C8C8C8CAC8A8),
    .INIT_1C(256'hD5D5D5D3B3B2906E4E4C2C0AEAE8E8C8C8C8C8C6C6C6C6C6C6C6C6C6C6C8C8C8),
    .INIT_1D(256'hE8E8E8E8E8E8EA0A0C2C4E4E707092B3B5D5D5D5D5D5D5F7F7F7F7F7F7F7F7D7),
    .INIT_1E(256'h9293702C0C7073504E70702E0CEAEAC8A484A4A4A4E80A0A0A0A0A0A0AE8E8E8),
    .INIT_1F(256'h90906E6E6E6E4E4C4C2C2C2C2C2C2C4C4C2C2C2C0A0AE8E6C6A4A4C6E80A2E70),
    .INIT_20(256'h00002222424264A6C8EA4E90B2B2B2D4D5D5D5D4B4B2B2B29090909090909090),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h2220202022222222222222222222222200000000202200000000000000000000),
    .INIT_23(256'h000000002222222222424244688A8DAF8FB1D3B17733F1CC8866442222202222),
    .INIT_24(256'h9292907070502E0CEAEAC8C8C8C8C8C8CACACAC8A8A88686A8A8642020222000),
    .INIT_25(256'h0AE8E8C8C8C8C6C6C6C6C6C6C6C6C6C8C8C8C8C8E8EA0C2C2C2C4E7092B29292),
    .INIT_26(256'h7092B2B5D5D5D5D5D5D5D7F7F7F7F7F7F7F7F7F7D5D5D5D5B3B2B0906E4C2C0A),
    .INIT_27(256'hC8C8EAC8C6A6A4A482A4C6E8EAEAEA0A0AE8E8E8E8E8E8E8E8EA0A0A2C2C4E6E),
    .INIT_28(256'h2C2C2C2C2A0A0A08E8C6C6A4A4C6E8E8EA0A2C4E502E0AC8A6C8EAE8C8EAEAC8),
    .INIT_29(256'hB2D4D4D4D4D5D5D4D4B2B2B2B09090929290909090706E4E4C4C4C2C2C2C2C2C),
    .INIT_2A(256'h000000000000000000000000000000000000000000222222426484A6EA2C70B2),
    .INIT_2B(256'h4442220000000000202200000000000000000000000000000000000000000000),
    .INIT_2C(256'h688A8DAF8DB1D3B15533EEAA8866442222202222202022222222202222222242),
    .INIT_2D(256'hC8C8C8CACACACACACAA8A886A8C8642022220000000000002222222222222266),
    .INIT_2E(256'hC6C8C8C8C8C8EAE8E8EA0C2E2E0A2C4E7092909090707070704E4E2E0CEAC8C8),
    .INIT_2F(256'hF9F9F9F9F7F7F7F7F7F5D5D5D3B2B2906E4E4C2A0AE8E8C8C8C8C6C6C6C6C6C6),
    .INIT_30(256'hC6E8E8E8E8E8E8E8E8E8E8E80A0A0A0A2C2C4E6E90B2B5D5D7D7D7D7D7D7F7F7),
    .INIT_31(256'hC6E80CEAC8C8C8E8EAC8A68464646464648484646484A6A6C8C8A6A6848484A6),
    .INIT_32(256'hB2B2B2B292909090706E6E4E4C2C2C2C2C2C2C2C2C2C0A0AE8E8E6C6C6A4A4A6),
    .INIT_33(256'h000000000000000000222242646486C80A4E90B2B4D4D4D4D4D4D5D4D4B2B2B2),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'hAA88664222222222002022422222222222224444442222000000202200000000),
    .INIT_36(256'hC8C8642222220000000000002222222222224266888BAD8D8DAFD1B15511EFCC),
    .INIT_37(256'h2C0A0A0A2C2C4C4C4C4C4E4E4E4E4E2E0CEACACACACACACACACACACACACACAA8),
    .INIT_38(256'hD5B3B290706E4C2C0AEAE8C8C8C6C6C6C6C6C6C6C8C8C8C8C8EAEAEAEAEAEA0A),
    .INIT_39(256'h0A0A0A2A2C4C4E7090B2D5D5F7F7F7F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F5D5),
    .INIT_3A(256'h62624242424262624242626284A6A6A684848484A4C6E8E8E8E8E8E8E8E8E80A),
    .INIT_3B(256'h4C2C2C2C2C2C0A0A0AEAE8E8C6C6A4A4A4A4A6C8C8C8C8C8A684646264846464),
    .INIT_3C(256'h6484A6E82C70B2B2D4D4D4D4D4D4D5D4D4B2B2B2B2B2B2B2909090906E6E4E4E),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000002222242),
    .INIT_3E(256'h2222222220224466422222220020222200000000000000000000000000000000),
    .INIT_3F(256'h2222222222224266888B8DADADAFB1D355553311886666420022222222224444),
    .INIT_40(256'h0C2C2C2E0CEAEAEACACACACACACACACACACACAC8CAC886422222220000000000),
    .INIT_41(256'hC8C6C6C6C6C6C8C8C8C8E8EAEAEAC8C8C8A6A6A4A6A4A4A4C6C6C6C6E8E80A0A),
    .INIT_42(256'hF7F7F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F5D5D5B3B2906E4C2C0AEAE8C8),
    .INIT_43(256'h646464848484848484A4A6C8E8E8E8E8E8E80A0A0A0A0A0A2A4C4E7090B2D5D5),
    .INIT_44(256'hA6A68484A6A6A8A8868484848464646464644242424222222222202242426464),
    .INIT_45(256'hD4D4D5D4D4B2B2B2B2B2B2B2909090706E6E4E4E4C2C2C2C2C0A0A0AE8E8C6C6),
    .INIT_46(256'h00000000000000000000000000000202222242448486C80C7092B2B2D4D4D4D4),
    .INIT_47(256'h2222222200000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'hAD8DAFF3335755EE664464422222222222224442220022222266664422224222),
    .INIT_49(256'hCACACACACACAEACACAC8864222222222000000002222222222224266888B8BAD),
    .INIT_4A(256'hC8A6A6848484848484A4A4A6C8C6C6C6C6C4C4C6C6E8EA0C0CEAEAEACACACACA),
    .INIT_4B(256'hF9F9F9F7F7F7F7F5D5D5D5B2906E4C2C0AEAE8C8C8C6C6C6C6C8C8C8C8C8E8EA),
    .INIT_4C(256'hE8E8E8E80A0A0A0A0A0A0A2A2C4C4E7092B2D5D7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_4D(256'h646242424242222222222222222222202022426464646262646484848484A4C6),
    .INIT_4E(256'h909070706E6E4E4E4C2C2C0A0A0A0AE8E8C6C6A6A4A68486A6A6848464646464),
    .INIT_4F(256'h000022222222426484A6EA4E92B2B2B2D4D4D5D5D5D5D5D4D4B2B2B2B2B2B290),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h2222222222222222000022224466442200222222222222222200000000000000),
    .INIT_52(256'h22202200000000002222222222222244688B8BADAD8DAFD33333EFAA66444444),
    .INIT_53(256'h0AEA0A0AE8C6C6A6A4A4A6C8E8EAEAEAEACACACACACACACACACAEACACAC88642),
    .INIT_54(256'h906E4E4C2A0AE8C8C8C6C6C6C6C6C8C8C8E8C8C8A6848464848486A6A8C8C8E8),
    .INIT_55(256'h4C4E6E90B2B4D5F7F7F9F9F9F9F9FBFBFBFBFBFBF9F9F9F9F7F7F7F7F5D5D5B2),
    .INIT_56(256'h22222222222242646664644264646484848484A6C6E8E8E80A0A0A0A0A0A0A2C),
    .INIT_57(256'h0A0AEAE8C8C6A6A6A6A686848686646464424242424242222220202022222222),
    .INIT_58(256'hB2B2B2D4D4D5D5D5D5D5D5D4D4B2B2B2B2B290909090706E6E6E4E4E4C2C2C0A),
    .INIT_59(256'h0000000000000000000000000000000000000000000222222242426484C80C70),
    .INIT_5A(256'h4444222220422222222222222200000000000000000000000000000000000000),
    .INIT_5B(256'h42222244688B8D8D8D8D8DD111EE886666444242222222222222222220202222),
    .INIT_5C(256'hA6C8C8CACAEAEAEACACACACACACACACACACA8644222000000000000022222222),
    .INIT_5D(256'hC6C6C8C8C8C8C6A6848484848486A6A8CAEAEAEA0C0C2E4E4E2CEAE8C6A484A4),
    .INIT_5E(256'hF9FBFBFBFBFBFBFBFBF9F9F9F9F7F7F7F7F5D5B392906E4E2C0AE8C8C8C6C6C6),
    .INIT_5F(256'h64646262648484A6A6C6C6E8E80A0A0A0A0A2C4C4E6E7090B2D5D5F7F7F9F9F9),
    .INIT_60(256'h8464646442424242444222202020202020202222222222222222426686866464),
    .INIT_61(256'hD4B2B2B2B2B2909090706E6E6E6E4E4E2C2C2C0A0AE8E8E8C6C6A6A6A6A88684),
    .INIT_62(256'h00000000000000000002222222426484A6E82C90B2B2B2D4D5D5D5D5D5D5D5D4),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'hCC88444444444222222222222222222220202222442220202222222222222200),
    .INIT_65(256'hCACACAEAEACA864422200000000000002222222242222224466A8D8D8D8D8DCF),
    .INIT_66(256'h86868686A8A8A8A8C8C80A2E504E4E2C0AC8A48484A6C6C8C8CAEAEAEACACACA),
    .INIT_67(256'hF9F9F7F7F7F7D5D5B2906E4E2C0AE8C8C6C6C6C6C6C6C6C8C8C6A68484848484),
    .INIT_68(256'hE80A0A0A0A2C2C6E6E9090B2B2D5D5F7F7F7F9F9F9FBFBFBFBFBFBFBFBFBF9F9),
    .INIT_69(256'h000020202000000020202022202242868686868686646242626284A6A6C6C6E8),
    .INIT_6A(256'h6E6E4E4C2C2C0C0A0AE8E8C6C6C6A6A6A6A88684646442424242424464442220),
    .INIT_6B(256'h22426484C60A4E92B2B2D4D4D5D5D5D5D5D5D5D4D4D2B2B2B2B29090906E6E6E),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000222222),
    .INIT_6D(256'h2222222220002244222222222222444422220000000000000000000000000000),
    .INIT_6E(256'h00000000222222222242442224488DAF8D8DAFD1884444444422422222222222),
    .INIT_6F(256'hE80C2C2E2C0CE8A6A48484A6C8C8CAEACACACACACACACAEAEACAA86442200000),
    .INIT_70(256'h2C0AE8C8C6C6C6C6A6C8C8A6A4848484848484626262626262646464848484C6),
    .INIT_71(256'hB4D5D5F7F7F7F9F9FBFBFBFBFBFBFBFBFBFBF9F9F9F9F7F7F7F7F7D5B2906E4E),
    .INIT_72(256'h22224288A888868486646442426284A6C6C8E8E80A0A0A0A2C2C4E6E709092B2),
    .INIT_73(256'hC6C6A6A484A68684646464424242646464422220202020202020202020202022),
    .INIT_74(256'hD4D5D5D5D5D5D5D5D4D4D2D2B2B29090906E6E6E6E6E4E2C2C2C0A0AE8E8E8C8),
    .INIT_75(256'h000000000000000000000000000000000022222242426486C82C70B2B2B2D4D4),
    .INIT_76(256'h0044442200000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h22468A8D8F8D8DAF666666888822222222222222222222000022444422222222),
    .INIT_78(256'hA6C8CAEACACACACACACACAEAEACAA88642200000000000000020222222424222),
    .INIT_79(256'h848484846264624242424242424242426462626484A4A6C8C8EAEAEAA6A48484),
    .INIT_7A(256'hFDFDFBFBFBFBFBF9F9F9F7F7F7F7F7D5B390704E2C0AE8C8C6C6C6C6C6C6A684),
    .INIT_7B(256'h42426262A6E80A0A0A2C2C4C6E709090B2B2B2D4D5D5F7F7F7F7F9F9FBFBFBFB),
    .INIT_7C(256'h424264646442202020202020202200002022202022224488A888868684646442),
    .INIT_7D(256'hB2B2B29090909070706E4E2C2C0A0AE8E8E8C6C6C6A6A6A6A664644242424242),
    .INIT_7E(256'h0000000020222222426484A60A4E9292B2B2D2D4D4D5D5D5D5D5D5D5D4D4D4D2),
    .INIT_7F(256'h0000000000202020202020000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_55_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_55_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized15
   (p_51_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_51_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_51_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hFFFFFFFFC00000000000003FFFFFFFFFFFC00000000000000000000000000000),
    .INITP_01(256'h000000000003FFFFFFFFFFFE0000000000000000000000000000000000000000),
    .INITP_02(256'h3FFFFFFFFFFFE0000000000000000000000000000000000000000FFFFFFFFE00),
    .INITP_03(256'hFF0000000000000000000000000000003000000001FFFFFFFFF0000000000000),
    .INITP_04(256'h0000000000000000000000000000001FFFFFFFFFE0000000000003FFFFFFFFFF),
    .INITP_05(256'h00000000000000000001FFFFFFFFFFFE5F00001FFFFFFFFFFFFFFFFE00000000),
    .INITP_06(256'h000000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000),
    .INITP_07(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000100000000000000000),
    .INITP_08(256'hFFFFFFFFFFFFFFFFFFFFFFF000000000000100000000000000000000000003FF),
    .INITP_09(256'hFFFFFFFFFFFF000000000000180000000000000000000000003FFFFFFFFFFFFF),
    .INITP_0A(256'hFF00000000000180000000000000000000000003FFFFFFFFFFFFFFFFFF3FFFFF),
    .INITP_0B(256'h00180000000000000000000000003FFFFFFFFFFFFFFFE021FFFFFFFFFFFFFFFF),
    .INITP_0C(256'h000000000000000003FFFFFFFFFFFFFC00001FFFFFFFFFFFFFFFFFFF80000000),
    .INITP_0D(256'h0000003FFFFFFFFFFFFFC00001FFFFFFFFFFFFFFFFFFF8000000000180000000),
    .INITP_0E(256'hFFFFFFFFFF00001FFFFFFFFFFFFFFFFFF8000000000018000000000000000000),
    .INITP_0F(256'h003FFFFFFFFFFFFFFFFFFFC0000000000180000000000000000000000003FFFF),
    .INIT_00(256'h8844422222222222202022202022442222222222222222000000000000000000),
    .INIT_01(256'hEACAA886422200000000000000202222224222222244688D8F8D6DAF88666666),
    .INIT_02(256'h20202222424242426262628484A6C8C8C8A6A6A6A6A6C8CACACACACACACACAEA),
    .INIT_03(256'hF7F7F7D5B290704E2C0AE8E8C6C6C6C6C6C6A684848464624222222020202020),
    .INIT_04(256'h7090B2B2B2D4D5D5D5D5F7F7F7F9F9F9F9FBFBFBFDFDFBFBFBFBFBF9F9F9F7F7),
    .INIT_05(256'h202220202222202022224488A8A88686646464644464426284E80A2C4C4C4E6E),
    .INIT_06(256'h2C0AEAE8C6C6C6C6A6A4A4848464646462624242626464646442222020202020),
    .INIT_07(256'h2C709292B2B2D2D5D5D5D5D5D5D5D5D5D4D4D4D2B2B2B2B2B2B29090706E4E4C),
    .INIT_08(256'h200000000000000000000000000000000000000000000020202222224264A6C8),
    .INIT_09(256'h2244442200222222222200000000000000000020000000002020424242424220),
    .INIT_0A(256'h00202222224222222244688B8D8D8D8F66666644644444444442222222222222),
    .INIT_0B(256'h626484A6A6C8C8A6A6A6A6C8CAEACACACACACAEAEACACAA86422000000000000),
    .INIT_0C(256'hC8C6C6C6C6A6A686644242422020202020202020202020202020424262624262),
    .INIT_0D(256'hF7F7F9F9F9FBFBFBFDFDFDFBFBFBFBF9F9F9F7F7F7F7D7D5B290704E2C0A0AE8),
    .INIT_0E(256'hA8A68686646464646464626262A40A4C6E70709092B3B3D4D5D5D5D5D5F7F7F7),
    .INIT_0F(256'h8484848484646464646464848464422020202020202220222222222222426488),
    .INIT_10(256'hD5D5D5D5D4D4D4D4B2B2B2B2B2B2B29290706E4E2C0A0AE8C6C6C6A6A4A4A484),
    .INIT_11(256'h000000000000000000000020222222224484A6EA2E709292B2B2D4D5D5D5D5D5),
    .INIT_12(256'h000000000000002000000000206286A8A6646442222000000000000000000000),
    .INIT_13(256'h6B8DAF8F44666644444466664442202222222222224422220020222222220000),
    .INIT_14(256'hCAEACACACACAEAEAEAEACAA8642200000000000020202222224242442444466A),
    .INIT_15(256'h20000020202022222222222020202242444442424242426486A8A8A8A6A6A6A6),
    .INIT_16(256'hFBFBFBF9F9F9F9F7F7F7D7D5B292706E4C2C0AE8E8C6C6C6C6A6846442222020),
    .INIT_17(256'h82840A4E9092B2B2D5D5D5D5D5D5D5F7F7F7F7F7F7F7F9F9F9FBFBFBFDFDFDFD),
    .INIT_18(256'h846462424242424222424242424222424242648686A686868484646464646462),
    .INIT_19(256'hD4B2B2B2B0906E6E4C2C0A08E8C6C6C6C6A6A6A4A48484848484848484848484),
    .INIT_1A(256'h222222426486C80C4E709292B2B2D4D5D5D5D5D5D5D5D5D5D4D4D4D4D4D4D4D4),
    .INIT_1B(256'h42C60A0CCA868664422000000000000000000000000000000000000000000022),
    .INIT_1C(256'h4422222222222222222222222022222220000000000000000000000020000000),
    .INIT_1D(256'h64220000000000002022222222222244444446486B8DAF8F4466666644666666),
    .INIT_1E(256'h20202244646464646442424264848686A6A686A6C8CACACACAEAEAEAECECEACA),
    .INIT_1F(256'hB392906E4E4C2A0AE8E8C8C8C8A6644222222200000000000020202020222222),
    .INIT_20(256'hF7F7F7F7F7F7F7F7F7F7F9F9F9FBFBFBFDFDFDFDFDFBFBFBF9F9F9F9F7F7D7D5),
    .INIT_21(256'h64666464648484A6A6A8C8C8C8C8C8C8C8CAEAEAE8E80A4E90B2B5D5D5D5D5F7),
    .INIT_22(256'h2C0A0AE8E8E8C6C6C6A6A6A6A6A6A6A6A6C6C6A6A6A6A6A68684868686866464),
    .INIT_23(256'hB2B2B2D4D5D4D4D4D5D5D5D5D5D5D5D5D5D5D5D4D4D4D4D2B2B290906E4E4E4C),
    .INIT_24(256'h00000000000000000000000000000000222222222222224464A6E82C6E709292),
    .INIT_25(256'h222222200000000000000000000000000000204284E8E8C8A686866442200000),
    .INIT_26(256'h2222224444244448688DAF8F4466868844444444422222222222222222222222),
    .INIT_27(256'h4242646486868686A8C8CACAEAEAEAEAEAECECEA864200000000000020222222),
    .INIT_28(256'hC884624222222000000000000000000000000020200022446686866664644242),
    .INIT_29(256'hF9F9FBFBFDFDFDFDFDFBFBFBF9F9F9F9F7F7D7D5B5B290706E4E2C2A0A0A0AE8),
    .INIT_2A(256'h4E5050707272939392706E90B2D5D5D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9),
    .INIT_2B(256'hEA0AEA0A0A0A0A0AEAEAEAEAEAEAEAEAECEACAC8C8EAEAC8CAEAEA0C0C2C2E2E),
    .INIT_2C(256'hD5D5D5D5D5D5D5D5D5D5D5D5D4D4B2B2B292929292929270704E2E2C0C0C0AEA),
    .INIT_2D(256'h00000022222222222222224464A6EA2E70909092B2B2B2D2D4D4D4D4D4D5D5D5),
    .INIT_2E(256'h000000000000206284C6C6A68484866442222000000000000000000000000000),
    .INIT_2F(256'h4466888844646666442022222222222222222222222200000000000000000000),
    .INIT_30(256'hEACACAEAEAECECECA844000000000000202222222222224444442448688DAF8F),
    .INIT_31(256'h00000000000020222000224486888886866442424242426484868686A6A8CACA),
    .INIT_32(256'hF9F9F9F9F9F7F7D5D5B3B290706E4E4C2C2C2C0AC86442424222000000202020),
    .INIT_33(256'hB5D5D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9FBFBFDFDFDFDFDFDFBFB),
    .INIT_34(256'h5050502E2E2E2E0C0C2E2E0C0C2E2E4E4E4E4E4E70909293B5B5B5B5B5B5B2B3),
    .INIT_35(256'hF7D5D5D5D5D7D7D7D7D7D7D7D7B5B59270704E4E2E2E2C2C2E2E2C4E2E2E2E2E),
    .INIT_36(256'h86C80A4E6E909090B2B2B2B2D2D4D4D4D4D4D5D5D5D5D5D5D5D5D5D5D5F7F7F7),
    .INIT_37(256'h8464646442222020000000000000000000000000000022222222222222224264),
    .INIT_38(256'h2222222222222222220000000000000000000000000000200000206482A4A484),
    .INIT_39(256'h000000002022222222222244444424466A8DAF8F448888664466664422222222),
    .INIT_3A(256'h8688888686866442424242426486868686A8CACAEAEACAEAEAECEC0ECA640000),
    .INIT_3B(256'h90706E4E4E4E6E2CA66242424222200020222020000000000020222220202264),
    .INIT_3C(256'hF7F7F7F7F7F7F9F9F9F9FBFBFDFDFDFDFDFDFBFBF9F9F9F9F9F7F7D5D5D3B292),
    .INIT_3D(256'h2C4E4E4E4E4C4C4C4E6E709090B2B2B2B5D5D5D5D5D7F7F7F7F7F7F7F7F7F7F7),
    .INIT_3E(256'hF9F9F7D7B5B592704E4E4E4E4E4E4E70704E4E507393724E2E2E2E2E2E50502C),
    .INIT_3F(256'hB2D2D4D4D4D4D5D5D5D5D5D5D5F5F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_40(256'h202020202020200000002222222222222222446486C80C4E6E6E9090B2B2B2B2),
    .INIT_41(256'h0000000000000000000000002020226462828484846464644242222222202020),
    .INIT_42(256'h444424466A8D8DAF668886664464664422222222222222222222222222000000),
    .INIT_43(256'h4264868686A8CACAEAEACAEAEAECEC0EEA662000000000002222222222222244),
    .INIT_44(256'h4242202020222020202020202022222220204266888888868686664442424242),
    .INIT_45(256'hFDFDFDFDFDFDFBFBFBF9F9F9F9F7F7D5D5D5B3B29090706E7090904EA6644242),
    .INIT_46(256'h6C6E9090B2D7F7D7D7F7F7F7F7F7F7F7F7F9F9F7F7F7F7F7F7F7F9F9F9F9FBFB),
    .INIT_47(256'h4C4E7070704E2E4E72704E2C0A0A2C2C0A2C2C0A2A2C4C2C2A2A2A2A4C4C4C4C),
    .INIT_48(256'hF7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9D7D5B492704E2C2C2C),
    .INIT_49(256'h2222222222224464A8EA2C4E6E6E8E9090B2B2B2B2B2D4D4D4D4D5D5D5D5D5D5),
    .INIT_4A(256'h2020206262828484846464644242222222222222222020202222222200002222),
    .INIT_4B(256'h4444442222224242222244442222222222000000000000000000000000000000),
    .INIT_4C(256'hEAECEC0C0CA8220000000000020222222222224244444424688DAF8F44666666),
    .INIT_4D(256'h2042422220204466888888888886664442424242426484A6A8C8CACACACACAEA),
    .INIT_4E(256'hF9F7F7F7D5D5D3B3B2B29290B2B2B36EC8C6A484626262424242202020202020),
    .INIT_4F(256'hF9F9F7F7F7F9F9F9F9F9F9F9F7F9F9F9F9F9FBFBFBFDFDFDFDFDFDFBFBF9F9F9),
    .INIT_50(256'h0808080808080808E8E8080808082A2A2A2A4C4C6E92B5D5F7F9F9F9F9F9F9F9),
    .INIT_51(256'hF9F9F9F9F9F9F9F9F9F9F7D7B490704E2C2A0A0A080A2A2C2A0A2A2C4E4E2C08),
    .INIT_52(256'h6E6E6E6E9090B2B2B2B2D4D4D4D5D5D5D5D5D5F5F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_53(256'h42422222222220202000002022222202222202022222222222446464A8EA2C4E),
    .INIT_54(256'h2222222222200000000000000000000000000000000020626282848484646442),
    .INIT_55(256'h020222222222224244464424468BAF8D44666666444442222222444444444444),
    .INIT_56(256'h666464424242424242626486A6C8CACACACACAEAEAECEC0C0EA8220000000000),
    .INIT_57(256'hB2D5D5924E4E2C0AEAEAECEACAA8A68664424242202020202042646686868666),
    .INIT_58(256'hF9F9F9F9F9F9FBFBFBFDFDFDFDFDFDFBFBFBF9F9F9F9F7F7D5D5D5D5B3B2B2B2),
    .INIT_59(256'h080808082A4C6EB3D5D5D7F7F9F9F9F9F9F9F9F9F9F9F9F7F9F9F9F9F9F9F9F9),
    .INIT_5A(256'hB292906E4C2A2A0A080808080808080A2A0A08E8E8E8E8E8E8E808E8E8E8E808),
    .INIT_5B(256'hD4D4D4D5D5D5F5F7F7F7F7F9F9F9F9F9F9F9FBF9F9F9F9F9F9F9F9F9F9F9F7D5),
    .INIT_5C(256'h22220200000000002222222222426464A8EA0C4E6E4E6E6E909090B2B2B2B2D4),
    .INIT_5D(256'h0000000000000000002020426262828484646442424242222222222222222222),
    .INIT_5E(256'h246AAF8D66686666444444444244222222444422222222222020000000000000),
    .INIT_5F(256'hA6A8C8CACAEAEAEAEAEAEC0C0EC8422022000002020222222022224244664624),
    .INIT_60(256'h0EEACAC8A8A68686646462424264646464646464646464644262624242626484),
    .INIT_61(256'hFDFDFDFDFBFBF9F9F9F9F7F7F5D5D5D5D5B3B3B3D5D5D5B59070704E2E2E2E50),
    .INIT_62(256'hFBFBFBF9F9F9FBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFDFDFD),
    .INIT_63(256'hE8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E808080808284C6EB3D7F9F9F9F9),
    .INIT_64(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5B4B2906E4C2C2A0A0808E8E8),
    .INIT_65(256'h42446484C8EA2C4E4E4E4E6E709090B2B2B2B2B2D4D4D4D5D5D5F5F7F7F7F9F9),
    .INIT_66(256'h8462628284646464424222222222222222222222220200000000000022222242),
    .INIT_67(256'h4244222222222222222222222222000000000000000000000000000000202040),
    .INIT_68(256'h2ECA6422220000020222222220222242446646242468AF8D8888664444666444),
    .INIT_69(256'h868684646464646464646464646464646464648486A8C8CACAEAEAEAEAEAEA0C),
    .INIT_6A(256'hF7F5D5D5D5D5D5D5D5D5F5D59290704E2C2C2C2E0CEAEAC8C8C8C8C8C8C8A886),
    .INIT_6B(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFDFDFDFFFFFDFDFBFBF9F9F9F9F7F7),
    .INIT_6C(256'hE8E8E8E8E8E8E8080A2A2A4C90B3D7F9F9F9F9FBFBFBFBFBFBFBFBFBF9F9F9F9),
    .INIT_6D(256'hF9F9F9F9F9F7F7D7D5D5B3906E4C4C2A0808E6E6E6E6E6E6E6E6E6E6E8E8E8E8),
    .INIT_6E(256'h6E909090B2B2B2B2D4D4D4D5D5D5F5F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_6F(256'h222222222222222222000000000000002222224444646486C8EA2C4E4E4E4E6E),
    .INIT_70(256'h2222000000000000000000000000200000202040846262626464646442422222),
    .INIT_71(256'h222222224466462422688D8DAA88664444666444224422224444222222222220),
    .INIT_72(256'h868686846464648484A6C8CACAEAEAEAEAEAEA0C2EEA64222222020202222222),
    .INIT_73(256'hB492704E2AE8E8E8EAE8C8C8C8C8C8C8EAEAC8C8A6A6A6848484868484848486),
    .INIT_74(256'hF9FBFBFBFBFDFDFDFFFFFFFDFBFBF9F9F9F9F9F7F7F5F5D5D5D5D5D5D5F7F7D5),
    .INIT_75(256'hD5D7D7F9F9FBFBFDFDFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_76(256'hB3906E4C2A080808E8E8E6E8E6E6E6E6E6E6E6E6E6E6E8E8E8E8E8084E9093B3),
    .INIT_77(256'hD5D5F5F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7D7D5),
    .INIT_78(256'h200000202222224464646486C8EA2C4E4E4E4E4E6E709090B2B2B2B2D4D4D4D4),
    .INIT_79(256'h0000200000202040846260626264646464424222222222222222222220000020),
    .INIT_7A(256'h8A88444444664444442222444444442222220000222000000000000000000000),
    .INIT_7B(256'hCACAEAEAEAEAEA0C2EEC86222222220200222222222222224466462422466B8D),
    .INIT_7C(256'hC6C6C6C6C8EAEAEAEAEAE8C6A6A6A6A6868686A6A6A686868684848484A6A8C8),
    .INIT_7D(256'hFBFBF9F9F9F9F9F7F7F7F5D5D5D5D5D5F5F7F7F7F7D5B5924E2AE8E8E8C8C6C6),
    .INIT_7E(256'hFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFDFDFFFFFFFFFD),
    .INIT_7F(256'hE8E8E6E6E6E6E6E6E8E8080A0A2C4E4EB5F9F9D7D9F9FBFBFBFBFDFDFDFBFBFB),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_51_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_51_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized16
   (p_47_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_47_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_47_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hFFFFFFFFFFFF0000000000180000000000000000000000003FFFFFFFFFFFFFFF),
    .INITP_01(256'hFC000000000F80000000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_02(256'hF80000000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_03(256'h0000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE000000001),
    .INITP_04(256'h00003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001F8000000000),
    .INITP_05(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF800000001F800000000000000000000),
    .INITP_06(256'hFFFFFFFFFFFFFFFFFFFFFFE00000003EC0000000000000000000000003FFFFFF),
    .INITP_07(256'hFFFFFFFFFFFFC0000007EC0000000000000000000000003FFFFFFFFFFFFFFFFF),
    .INITP_08(256'hFFC00003FFC0000000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_09(256'h0000000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0A(256'h00000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF081FFFC),
    .INITP_0B(256'h000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFC00000000000),
    .INITP_0C(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000000000000000000000),
    .INITP_0D(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000000000000000000001FFFFFFF),
    .INITP_0E(256'hFFFFFFFFFFFFFFFFFFFC00000000000000000000000000FFFFFFFFFFFFFFFFFF),
    .INITP_0F(256'hFFFFFFFFC00000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_00(256'hF9F9F9F9FBFBF9F9F9F9F9F9F9F9F9F9F9F7F7D7D7D5B3906E4C2C0A08080808),
    .INIT_01(256'hC8EA2C4C4C4E4E4E4E6E709092B2B2B2B2D4D4D4D5D5F5F7F7F7F7F9F9F9F9F9),
    .INIT_02(256'h6262646464444242424222222222222220202020202020222222424244646486),
    .INIT_03(256'h4444442222000000220000000000000000000000000000000020204084624262),
    .INIT_04(256'h22222222002222222222202244666644244468AF686644444466444444444444),
    .INIT_05(256'hE8C8C8C8C8A8A8A8A8A6A6A6A6868684A6A6A8C8C8CAEAEAECECEC0C2EEC8642),
    .INIT_06(256'hF5D5F5F5F5F7F7F7F7F7F7D5B36E2C0AE8C8C6C6C6C6C6A6C6C8E8E8E8EAEAEA),
    .INIT_07(256'hF9F9F9F9F9F9F9F9FBFBFBFBFDFDFDFFFFFFFFFDFBFBF9F9F9F9F9F7F7F7F5F5),
    .INIT_08(256'h7295B7B7D9FBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFBFBFDFBFBFBFBF9F9F9F9F9),
    .INIT_09(256'hFBFBFBFBFBF9F9F9F9F9D7D7B5B593704E4E4E4E4E2C2C2C2C4C4C4E4E507070),
    .INIT_0A(256'h90B2B2B2B2B2B2D4D5D5F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFB),
    .INIT_0B(256'h22222222222020202222222222424442446464A6C80A2C4C4C4C4C4E4E4E6E90),
    .INIT_0C(256'h0000000000000000000000002020204064624262626262646464444442422222),
    .INIT_0D(256'h44466644442468AF666644444444424244442222222222220000002020000000),
    .INIT_0E(256'hA8A8A6A6A6A6A8C8C8CAEAEC0C0C0C0C0EECA842222222222222222222202022),
    .INIT_0F(256'hD7B5704E2C0AC8C6C6C6A6A6C6C6C6C8C8E8E8E8E8E8EAE8C8C8C8C8C8C8C8A8),
    .INIT_10(256'hFDFDFDFFFFFFFFFDFBFBF9F9F9F9F9F7F7F7F5F5F5F5F5F5F7F7F7F7F9F9F9F9),
    .INIT_11(256'hFDFBFBFBFBFBFBFBFBFDFDFDFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFB),
    .INIT_12(256'hF9F9D9D7B5B5B5B5B595959395B5B5B7B7D9D9D9D9D9FBFBFBFDFDFDFDFDFDFD),
    .INIT_13(256'hF7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_14(256'h42424242646464A8EA0A2C2C2C4C4C4C4C4E6E709090B2B2B2B2B2D4D5D5F7F7),
    .INIT_15(256'h2020204262424262626262646464646444424242222222222222222222222222),
    .INIT_16(256'h4444444242442222222222000000002200000000000000000000002020202020),
    .INIT_17(256'h0C0C0C0C0EECA842222222222222222220202022244666462424488D66664444),
    .INIT_18(256'hA6C6C6C6C6C6C8C8C8C8E8E8E8C8C8C8C8C8C8CAC8C8C8C8C8C8C8C8C8EAEA0C),
    .INIT_19(256'hF9F9F9F7F7F7F5F5F5F5F5F5F7F7F7F7F9F9F9F9F9F7B592704E0AC6C6C6A6A6),
    .INIT_1A(256'hFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFDFDFDFFFFFFFFFFFDFBFBF9),
    .INIT_1B(256'hFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFBFBFBFBFBFBFDFDFDFDFDFD),
    .INIT_1C(256'hFBFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFDFDFDFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_1D(256'h2C2C4C4C4C4E6E70709090B2B2B2B2D4D5F5F7F7F7F7F7F9F9F9F9F9F9F9F9F9),
    .INIT_1E(256'h646464644442424242422222222222224242424242424242646486C8EA0A0C2C),
    .INIT_1F(256'h2020202200000000000000000000002020202020202020426242426262626264),
    .INIT_20(256'h2222202020002022244668462424466B66664444444444444244222242442222),
    .INIT_21(256'hC8C8C8C8C8C8C8C8CACAC8C8C8C8C8C8CAEAEA0C0C0C0C0E0EECA84222222222),
    .INIT_22(256'hF7F7F7F7F9F9F9F9F9F9D7B5B3924E0AE6C6C6A4C6C6A6A6A6C6C6C8C8C8C8C8),
    .INIT_23(256'hFBFBFBFBFBFBFBFBFDFDFDFFFFFFFFFFFDFBFBF9F9F9F9F7F7F7F7F5F5F5F5F7),
    .INIT_24(256'hFDFDFDFDFDFDFBFBFBFBFBFBFBFBFDFDFDFDFDFDFBFBFBFBFBFBFBFBF9F9F9F9),
    .INIT_25(256'hFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFDFDFD),
    .INIT_26(256'hB2B2B2D4D5F5F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFDFD),
    .INIT_27(256'h424222222222424242222244646486C8EAEA0A2C2C2C2C2C2C4C4E6E6E9090B2),
    .INIT_28(256'h0000000000000020202020424242626264646464646464644442424242424242),
    .INIT_29(256'h4424466A44444444224464444244224244442222220000000000002000000000),
    .INIT_2A(256'hEAEAEACACAEAEA0C2E0C0C0C0EECA84222222222222220202000000022466846),
    .INIT_2B(256'hD5B5B54E0AE8E8C6C6C6A6A4A4C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8CACAEAEA),
    .INIT_2C(256'hFFFFFFFFFDFBFBF9F9F9F9F9F7F7F7F5F5F5F5F7F7F7F7F7F9F9F9F9FBFBF9D7),
    .INIT_2D(256'hFBFBFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBF9F9FBFBFBFBFBFBFBFBFBFDFDFDFF),
    .INIT_2E(256'hFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFDFDFDFDFDFBFBFBFBFBFBFBFBFB),
    .INIT_2F(256'hF7F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFDFD),
    .INIT_30(256'h646486C8EAEA0A2C2C2C2C2C2C4C4C4E6E9090B2B2B2B2D4D5F5F7F7F7F7F7F7),
    .INIT_31(256'h4242626264848484646464644444424242424242222242424242424242424244),
    .INIT_32(256'h2244222242222222222200000000000000000000000000000000202020202042),
    .INIT_33(256'h0E0CCA4422222222224222202000000022466846464646684244444422664422),
    .INIT_34(256'hA4A4A4A4A4C6C6C6C6C6C8C8C8C8C8C8C8C8CAEAEAEAEAEAEAEA0C2E2E2E0CEC),
    .INIT_35(256'hF7F7F7F5F5F5F7F7F7F7F7F7F7F9F9F9F9FBFBF9D7D7D7924E0A0AE8C6C6C6C6),
    .INIT_36(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFFFFFFFFFFFDFBFBF9F9F9F9F9),
    .INIT_37(256'hFFFFFFFFFFFFFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFDFDFDFBFBFBFB),
    .INIT_38(256'hFBFBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFFFDFDFDFDFDFDFDFDFDFDFDFFFF),
    .INIT_39(256'h2C2C4C4E6E90909090B2B2D4D5D5F5F7F7F7F7F7F7F9F9F9F9F9F9F9F9FBFBFB),
    .INIT_3A(256'h4444424242422222222242424222222222424264646486C8E8EA0A0A2C2C2C2C),
    .INIT_3B(256'h0000000000000000000000000000202020202040424262626484848464646444),
    .INIT_3C(256'h2020000022466846464646684466644422664422224222224242222222222200),
    .INIT_3D(256'hC8C8C8C8C8C8CAEAEAEAEAEAEA0A0C4E4E2E0CEC0C0CCA644222222242442220),
    .INIT_3E(256'hF7F7F9F9F9F9FBFBF9F7F9B5904E2C0A0A0AE8E8C6C6C6A6A6C6C6C6C6C6C6C6),
    .INIT_3F(256'hFBFBFBFBFDFDFDFFFFFFFFFFFDFBFBF9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_40(256'hFBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_41(256'hFDFDFDFDFDFFFFFFFDFDFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFDFDFDFDFBFBFB),
    .INIT_42(256'hD4D5D5F7F7F7F7F7F7F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFDFDFDFDFDFD),
    .INIT_43(256'h2222222222424266646486C8E8EAEA0A0A0C0C2C2C2C2C4C4E7090909090B2B2),
    .INIT_44(256'h0000202020202040424262626464848464646242424242424222222222222242),
    .INIT_45(256'h6666664422664422224244444444420022222200222000000000000000000000),
    .INIT_46(256'h0C0C2C2E50502E0C0C0CCA644222224244442222202020222246682446686846),
    .INIT_47(256'hB5924E2C2C2C2C2C0A0AE8E8E8C6C6C6C6C6C6C8C8C8C8C8C8C8EAEAEAEA0C0C),
    .INIT_48(256'hFDFBFBF9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9FBF9F9F9D7),
    .INIT_49(256'hFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFFFFFFFFFF),
    .INIT_4A(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFDFBFBFBFBFBFBFBFBFBFBFDFDFDFDFD),
    .INIT_4B(256'hF9F9F9F9F9F9FBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFF),
    .INIT_4C(256'hC8EAEA0A0A0A0C2C2C2C2C4C4E6E7070709092B2D4D5D5F7F7F7F7F7F7F7F9F9),
    .INIT_4D(256'h64848484646464424242424222222222222222224242424242424466866486C8),
    .INIT_4E(256'h6444440022222200222200000022000000000000000020202020204042426262),
    .INIT_4F(256'h4222224242424222202000222246682446686826668866442244444444446466),
    .INIT_50(256'h4C0A0A0AE8E8E8EA0AEAE8E8E8EAEA0A0C0C0C2C2E2C2C2E50704E0C0C0CCA64),
    .INIT_51(256'hF7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9FBF9F9F9F7D5924E4E6E706E4E6E6E4E),
    .INIT_52(256'hFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFFFFFFFFFFFBFBFBF9F9F9F9F9F9F7F7F7),
    .INIT_53(256'hFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_54(256'hFBFBFBFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_55(256'h4E6E7070909090B2D4D5D5D5F7F7F7F7F7F7F7F9F9F9F9F9F9F9FBFBFBFBFBFB),
    .INIT_56(256'h22222222222222424242424242424464848486A8C8C8EA0A0A0A0A0C2C2C2C4C),
    .INIT_57(256'h2222000000000000000020202020404042426264848484848464646442422020),
    .INIT_58(256'h22446824688A6846666644222222444444446666442222224444220000000000),
    .INIT_59(256'h0AEA0A0A0C0C2C2E4E504E4E7092722E2E0CCA64424222222222424222200000),
    .INIT_5A(256'hF9F9F9F9FBFBF9F9F9F7D5936E6E6E709093B5D5B59270704E4E4E4E4E4E2C0C),
    .INIT_5B(256'hFBFDFDFFFFFFFFFFFBFBFBFBF9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9),
    .INIT_5C(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_5D(256'hFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFBFBFBFBFBFBFBFB),
    .INIT_5E(256'hD5F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFD),
    .INIT_5F(256'h424242648486A6A8C8C8EAEA0A0A0A0A0A0A2C2C4E4E6E70709090B2B2D5D5D5),
    .INIT_60(256'h2020424242426284848484848484646442424242424242222222424244444242),
    .INIT_61(256'h4222424444446644222222224442220000000022222200000000000000002020),
    .INIT_62(256'h7092934E2E0CCA6442424222224242222242200222246624688A684666644222),
    .INIT_63(256'h92706E6E7093D5D7F7D7D7B5B5B5B5B5B59392704E4E4E4E4E4E4E7092937270),
    .INIT_64(256'hF9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9FBF9F9F9F9F7D5),
    .INIT_65(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFFFFFFFFFDFBFBFBFB),
    .INIT_66(256'hFFFFFDFDFDFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_67(256'hF9F9F9F9F9FBFBFBFBFBFBFBFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_68(256'hEAEAEA0A0A0A2A2C4C4E4E6E709090B2B2D4D5D5D5F7F7F7F7F7F7F7F9F9F9F9),
    .INIT_69(256'h846464624242424242424242224242424444424242424464848486A6A6C8E8EA),
    .INIT_6A(256'h2222220000000022442200000000002020002020202042424042628484848484),
    .INIT_6B(256'h224242224244222222246624688A6A4866444222422222424444664422222222),
    .INIT_6C(256'hF9F9D9D7D7D7D5B593929292929292B3B5B5B592929292502E0CCA6242422222),
    .INIT_6D(256'hF7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F7D5B390706E90B3D7F9F9F9F9),
    .INIT_6E(256'hFBFBFBFBFBFBFBFBFBFDFDFDFFFFFFFFFDFBFBFBF9F9F9F9F9F9F9F9F7F7F7F7),
    .INIT_6F(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9FBFBFBFBFBFBFBFBFB),
    .INIT_70(256'hFBFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFB),
    .INIT_71(256'h6E7090B2B2B2D4D5D5D5F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9FBFBFBFBFBFB),
    .INIT_72(256'h424242424242424242446464648486A6A6C8C8E8E8EAEAEA0A0A0A2C2C4C4E6E),
    .INIT_73(256'h000000222222222020204240426284A6A6A6A6A6848462424242424242424242),
    .INIT_74(256'h466A8B4866444442444222446444664422222222222222220000202242220000),
    .INIT_75(256'hB5B5D5D7D7D7B5B5929292724E0CCA6242222222224244444244422222446644),
    .INIT_76(256'hF9F9F9F9F9F9F9F9F7D7B5906E7092B5D7F9F9FBFBFBF9F9F9F9F7F7D7D5D5D5),
    .INIT_77(256'hFFFFFFFFFDFBFBFBF9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F9F9F9),
    .INIT_78(256'hFBFBFBFBFBFBFBFBFBFBF9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFD),
    .INIT_79(256'hFDFDFDFDFDFDFDFDFDFDFDFDFDFDFBFBFBFDFDFBFBFBFBFBFBFBFBFBFDFDFBFB),
    .INIT_7A(256'hF7F7F7F7F7F7F7F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFDFFFD),
    .INIT_7B(256'h64648686A6A6C8C8C8E8EAEA0A0A0A2C2C4C4E4E6E709092B2B2D4D5D5D5F5F7),
    .INIT_7C(256'h4284A6C8EAEAC8A6868442424242424242424242424242424242424242446664),
    .INIT_7D(256'h6666664422222222222022220020222222000000200020224242422220424240),
    .INIT_7E(256'h502CC86242222222224244444422442222426644466A8D686444444444442244),
    .INIT_7F(256'h907090B2B5D7F9F9FBFBFBFBF9F9F9F9F9F7F7D7D7D7D7F7D7D5D5D5B5929395),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_47_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_47_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized17
   (p_43_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_43_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_43_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000000000C000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_01(256'h000E0000000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00),
    .INITP_02(256'h003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000000000000),
    .INITP_03(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000000000000000060000000),
    .INITP_04(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000000000000000000000000003FFFFFFFF),
    .INITP_05(256'hFFFFFFFFFFFFFFFFFC000000000000000000000000001FFFFFFFFFFFFFFFFFFF),
    .INITP_06(256'hFFFFFFC000000000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_07(256'h00000000000000000000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_08(256'h000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000),
    .INITP_09(256'h0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000000000000000),
    .INITP_0A(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000000000000000000000),
    .INITP_0B(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFC000000000000000000000000000FFFFFFFFFF),
    .INITP_0C(256'hFFFFFFFFFFFFFFFC000000000000000000000000000FFFFFFFFFFFFFFFFFFFFF),
    .INITP_0D(256'hFFFFC0000000000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0E(256'h0000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_0F(256'h00000000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000000),
    .INIT_00(256'hF9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F7F9D7B3),
    .INIT_01(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFFFFFFFFFDFBFBFBF9F9F9F9),
    .INIT_02(256'hFBFBFBFBFBFDFBFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_03(256'hF9F9F9FBFBFBFBFBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFB),
    .INIT_04(256'h0A0A0A2C2C2C4E4E6E6E9090B2B2D2D5D5D5F5F5F7F7F7F7F7F7F7F9F9F9F9F9),
    .INIT_05(256'h42424242424242424244644442424242424266646464868686A6A8C8C8C8E8EA),
    .INIT_06(256'h002022220000000020000022424242202042424062A6C8EA2C2CEAC8A6644242),
    .INIT_07(256'h4422444222224444466A8D684444444466444244666686442222422222202022),
    .INIT_08(256'hF9F9F9F9F9F9F7F7D7D7F7F7F7D5D5B5B593B5B5702EC8624222222222424464),
    .INIT_09(256'hF7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F7D7B3909090B2B5D7F9F9FBFBFB),
    .INIT_0A(256'hFBFBFBFBFBFBFDFDFFFFFFFFFDFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7),
    .INIT_0B(256'hFBFBFBFBFDFDFDFDFBFBFBFBFBFBF9F9FBFBFBFBFBFBFBFBFBFBFBF9F9F9F9FB),
    .INIT_0C(256'hFBFBFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_0D(256'h90B2B2D4D5D5D5F5F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFB),
    .INIT_0E(256'h44424242424266646464648686A6A8A8C8C8E8EAEAEA0A0A2C2C4C4E4E6E7090),
    .INIT_0F(256'h202220202042424262A6C8EA0C2C0CEAA6644242424242424242424244646464),
    .INIT_10(256'h4422446466224466888888442222222222222222222222222020000000000000),
    .INIT_11(256'hF7D7D5D5B5B5B5B5722EC8624222222222426466442222442224664626688D68),
    .INIT_12(256'hFBFBF9F9F9F9F9F7D5B390909090D5D7F7F9FBFBF9F9F9F9F9F9F7F7F7D7F7F7),
    .INIT_13(256'hFDFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F9F9F9F9F9F9FB),
    .INIT_14(256'hFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFDFDFFFFFFFF),
    .INIT_15(256'hFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFDFBFBFBFBFB),
    .INIT_16(256'hF7F7F7F7F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFD),
    .INIT_17(256'h86A6A6A6C8C8C8E8EAEA0A0A2C2C4C4E4E6E709090B2B2D4D5D5D5D5F7F7F7F7),
    .INIT_18(256'hEA0A0AC884424242424242424222424464646464444242424242666464646484),
    .INIT_19(256'h4242222222222222222222222222220000202020224242202042424262A6C8C8),
    .INIT_1A(256'h4222222222426466440022444444664624688B68442244664422446688888844),
    .INIT_1B(256'h9090B0B3D5F7F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7D7D5B5B5B5B5924ECA62),
    .INIT_1C(256'hF9F9F9F9F9F7F7F7F7F7F7F7F7F9F9F9F9F9F9FBFBFBFBF9F9F9F9F7F7D5B390),
    .INIT_1D(256'hF9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFDFFFFFFFFFDFBFBF9F9F9F9F9F9F9F9F9),
    .INIT_1E(256'hFBFBFBFBF9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9),
    .INIT_1F(256'hF9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_20(256'h2C2C2C4E4E6E6E9090B2B2B2D5D5D5D5F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9),
    .INIT_21(256'h22424244644464644442424242446664446464648686A6A6C8C8C8C8E8E80A0A),
    .INIT_22(256'h2222220000002020224444222020424264A6C8C8C8E8C8A66240424242424222),
    .INIT_23(256'h4444444624486A68222244444444444466888844424222422222222222222222),
    .INIT_24(256'hF7F7F7F7F7F7F7D7D5D7F7D7D5B5B393924ECA62422222222242646644002266),
    .INIT_25(256'hF7F7F7F9F9F9F9F9FBFBFBFBF9F9F9F7F7F7D5B390909090B3D5F7F9F9F9F7F7),
    .INIT_26(256'hF9FBFBFDFFFFFFFDFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7),
    .INIT_27(256'hFBFBFBFBFBF9F9F9F9F9F9F9F9F9F7F7F9F9F9F7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_28(256'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9FBFBFBFBFBFB),
    .INIT_29(256'hD5D5D5D5F5F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFB),
    .INIT_2A(256'h42446664444464648486A6A6C8C8C8C8E8E8EA0A2C2C2C4C4E4E6E709092B2B2),
    .INIT_2B(256'h2020424284A6A6C6C8C8A6844240424222224222424244424244644442424242),
    .INIT_2C(256'h2244444444888844224244442222222222222222222222000000002022444442),
    .INIT_2D(256'hD5B5B5929250EA624222222222426486642242664424444446686A6A44444444),
    .INIT_2E(256'hF9F9F9F7F7F7F7D5B3908E8E90B3B5D5F7F7F7F7F7F7F7F7F9F7F7D5D5D5F7D7),
    .INIT_2F(256'hF9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9FBF9F9),
    .INIT_30(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFDFFFDFDFBFBF9F9),
    .INIT_31(256'hFBFBFBFBFBFBFBFBF9F9F9F9F9F9FBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F7F7F7),
    .INIT_32(256'hF7F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_33(256'hA6A6C8C8C8E8EA0A2C2C2C2C4E4E6E709090B2B2B5D5D5D5D5D7F7F7F7F7F7F7),
    .INIT_34(256'h424242424222424244444242444444424242424242426464424264646486A6A6),
    .INIT_35(256'h4222222222222222222222000000002022424242424262428484A6A6A6A68462),
    .INIT_36(256'h22426466642022444424444446686B8B66666666444244446686A86422224464),
    .INIT_37(256'h909090B3D5D5D5D5D5D5F7F7F9F9F7D5D5D5D7D7D7D5B5B29250EA6442222222),
    .INIT_38(256'hF7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F5D3B19090),
    .INIT_39(256'hF7F7F7F7F9F9F9F9F9F9F9FBFDFDFDFDFBFBF9F9F9F9F9F7F7F7F7F7F7F7F7F7),
    .INIT_3A(256'hF9F9FBFBFBF9F9F9F9F9F9F9F9F7F7F7F7F5F5F5F5F5F5F5F7F7F7F7F7F7F7F7),
    .INIT_3B(256'hF9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9),
    .INIT_3C(256'h4E4E4E6E709090B2B2B5D5D5D5D5D5F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_3D(256'h64444442424242424242644442426464648486A6A6A6A6C8C8E8EA0A0C2C2C2C),
    .INIT_3E(256'h000000202222424242646464848484A4A6846242424242424242424444444464),
    .INIT_3F(256'h46686A8B44666666442244444466886422204244424222224222222222222220),
    .INIT_40(256'hF7F9F7F7D5D5D5D7D7D5B5B29250EA6442222222224264666420222424446624),
    .INIT_41(256'hF7F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7D5B3B0906E6E9090B3D3D5D5D5D5D5F7),
    .INIT_42(256'hFDFDFDFBFBF9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7D7D7D7F7F7F7F7F7F7F7F7),
    .INIT_43(256'hF7F7F5D5D5D2D2D3F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9FB),
    .INIT_44(256'hFBFBFBFBF9F9F9FBFBF9F9F9F9F9F9F9F9F9F9F9F9FBFBFBF9F9F9F9F9F9F9F7),
    .INIT_45(256'hD5D5D5F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFB),
    .INIT_46(256'h42446464646486A6A6A6A6C8C8C8E8EA0A2C2C2C2C4E4E6E6E709092B2B3D5D5),
    .INIT_47(256'h8486A68686644242424242424242424244646464444444444242424242424444),
    .INIT_48(256'h6664664442222222422222222222222222222222200000202222444242646464),
    .INIT_49(256'h9250EA644242222222426466440022222444662446686A8A4486866644224466),
    .INIT_4A(256'hF9F7F7F7D5D5B390906E8E9090B0B3D3D5D5D5F7F7F7F7F7F7D5F5D7D7D5B5B3),
    .INIT_4B(256'hF7F7F7F7F7F7F7F7D5D5D5D5D5D5D5F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_4C(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9FBFBFBFBFBF9F9F9F9F9F7F7F7),
    .INIT_4D(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5D2D2B0B0B0B2D2D5F5F5F7),
    .INIT_4E(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9FBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_4F(256'hC8C8E8EA0A0C2C2C2C4C4E4E6E709092B2B2D5D5D5D5D5D5F7F7F7F7F7F7F7F7),
    .INIT_50(256'h424244446464646444446444424242424242424242446444646486A6A6A6A6C8),
    .INIT_51(256'h422222222222222220000020202242424262626484A6A6868464424242424242),
    .INIT_52(256'h440022444446682446686A6A6488886644444466666644444222222222222222),
    .INIT_53(256'h8E9090B2B3D5F5F7F7F7F7F7F7F7F7D5D5D5B5B39250EA644242222222426466),
    .INIT_54(256'hB3B3D5D5F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5D3B390908E6E),
    .INIT_55(256'hF7F7F7F7F9F9F9F9FBFBFBF9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7D5B5B3B3),
    .INIT_56(256'hF9F9F9F7F7F7D5D2B0B08E8E8E90B0D2D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_57(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_58(256'h4E70909092B2B2D5D5D5D5D5D7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9),
    .INIT_59(256'h42424242424242426264444464648686A6A6A6A6C8C8E8EA0A0A2C2C2C2C4E4E),
    .INIT_5A(256'h2022426464626262848686866442424242424242424464666664644444446444),
    .INIT_5B(256'h66AAAA6642444444666644444222222200202242442222222222222220000020),
    .INIT_5C(256'hF7F7D5D5D5D5D5B59250EA644242424242426464420022444666682446686A6A),
    .INIT_5D(256'hF7F9F9F9F9F9F9F9F9F9F9F9F7F7D5D5B3B0906E6E8E90B0B2D5D5F7F7F7F7F7),
    .INIT_5E(256'hF9F7F7F7F7F7F7F7F7F7F7F7F7F7F7D7D5B592909090B2D5D5F5F5F7F7F7F7F7),
    .INIT_5F(256'h6E90B2D5F5F7F7F7F7F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_60(256'hF9F9F9F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F7F7F7F7F7D5D5B28E6C6C6C6C),
    .INIT_61(256'hD5D5F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_62(256'h64648686A6A6A6A6C6C8C8EA0A0A2C2C2C2C4C4E4E6E709090B2B2B3D5D5D5D5),
    .INIT_63(256'h4242424242426444424464866664446464444442424242424242424242646464),
    .INIT_64(256'h2222222220002242662222222222222220002020202022648484626284868664),
    .INIT_65(256'h42424222424244442200224446466624686A6A6A88AAAA662244666644664422),
    .INIT_66(256'hF7F7F7D5D3B390908E9090B2B3D3D5D5F7F7F7F7F7F7D7D5D5D5D5B59250EA64),
    .INIT_67(256'hF5F7F7F7F7B5906E6E6E90B2B2D5F5F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_68(256'hF9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F9F7F7F7F7F7F7F7F7F7F7F5F5F5F5F5F5),
    .INIT_69(256'hF7F7F7F7F7F7F7F7F7F5D5D3B2B08E6C4A4A4C4C6EB2D5F7F7F9F9F9F9F9F9F9),
    .INIT_6A(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_6B(256'hEA0A0C2C2C2C2C4E4E6E709090B2B2B2B3D5D5D5D5D5D7F7F7F7F7F7F7F7F7F7),
    .INIT_6C(256'h646464866442424242424242424242424264646464648686A6A6A6A6A6C8C8EA),
    .INIT_6D(256'h4222424222222020202022648686846284868664424242424242646464646464),
    .INIT_6E(256'h44444424686A6A68A88886664444666644666644222222222020222244442222),
    .INIT_6F(256'hB2B3B3D5D5F7F7F7F7F7F7D7D5D5B5B59350EA64424222222242444422202244),
    .INIT_70(256'h90B2D5D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F7F7F7D5D3B29090909090),
    .INIT_71(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F5F5F5F5F5F5F5F5F5F7F7F7D5926E4C4C6E90),
    .INIT_72(256'h906E4C4A4A2A2C6E90B5F7F7F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7),
    .INIT_73(256'hF9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F5D5D5D2B2B0),
    .INIT_74(256'h9092B2B2B2B3D5D5D5D5D5F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9),
    .INIT_75(256'h64424242424464646464868486A6A6A6A6C8C8EAEA0A0C2C2C2C2C4E4E4E7090),
    .INIT_76(256'h84A6A68484868464424242424242424464646464646666644244644442424244),
    .INIT_77(256'h4444666664666644222222002222222222444444444444442222202020202262),
    .INIT_78(256'hD7D5B5B59350EA64422222222242444222222244442424448A8A6A6888666444),
    .INIT_79(256'hF7F7F7F7F7F7F7F7F9F9F7F7F7D5B3B0909090909090B3D5D5F7F7F7F7F7F7D7),
    .INIT_7A(256'hF5F5F5F5F5F5D5D5D5F5F7F7F7D7B36E4C2A4C6E6E90B2D3D5F5F7F7F7F7F7F7),
    .INIT_7B(256'hF9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F5),
    .INIT_7C(256'hF5F5F5F5F5F5F5F7F7F7F5F5F5D5D5D3B2B0908E6E4C4A2A2A2A2C6EB3D5F7F7),
    .INIT_7D(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_7E(256'h86A6A6A6A6A6C8E8EA0A0C2C2C2C2C2E4E4E6E70909092B2B2B2B5D5D5D5D5D7),
    .INIT_7F(256'h4242426464646464648664424264644242424264644242424242444464648484),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_43_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_43_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized18
   (p_39_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_39_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_39_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000000000000),
    .INITP_01(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0000000000000000000000000007),
    .INITP_02(256'hFFFFFFFFFFFFFFFFFFFFFFFFC0000000000000000000000000007FFFFFFFFFFF),
    .INITP_03(256'hFFFFFFFFFFFFFC0000000000000000000000000003FFFFFFFFFFFFFFFFFFDFFF),
    .INITP_04(256'hFFC0000000000000000000000000003FFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF),
    .INITP_05(256'h00000000000000000003FFFFFFFFFFFFFFFFFE0FFFFFFFFFFFFFFFFFFFFFFFFF),
    .INITP_06(256'h000000003FFFFFFFFFFFFFFFFFC0FFFFFFFFFFFFFFFFFFFFFFFFFFFC00000000),
    .INITP_07(256'hFFFFFFFFFFFFFFF80FFFFFFFFFFFFFFF7FFFFFFFFFFFC0000000000000000000),
    .INITP_08(256'hFFFE00FFFFFFFFFFFFFFF7FFFFFFFFFFFC0000000000000000000000000003FF),
    .INITP_09(256'h01FFFFFFFF5FFFFFFFFFFFC0000000000000000000000000001FFFFFFFFFFFFF),
    .INITP_0A(256'hFFFFFFFFFFFC0000000000000000000000000001FFFFFFFFFFFFFFFF8007FFFC),
    .INITP_0B(256'hC0000000000000000000000000000FFFFFFFFFFFFFFFE0003FFC0000FFFCFFF0),
    .INITP_0C(256'h000000000000000000FFFFFFFFFFFFFFF800003E0000007C03FF07FFFFFFFFFF),
    .INITP_0D(256'h00000007FFFFFFFFFFFFFE00000000000000000FF07FFFFFFFFFFC0000000000),
    .INITP_0E(256'hFFFFFFFFFFC000000000000000003F01FFFFFFFFFFC000000000000000000000),
    .INITP_0F(256'h000000000000000001E007FFFFFFFFFC00000000000000000000000000007FFF),
    .INIT_00(256'h224222222222444466444442222020202020204284A6A6848484644442424242),
    .INIT_01(256'h2242444222222244442424468A8B6A6A66644444444466666466664422222222),
    .INIT_02(256'hF7F7D5B3B0908E6E6E90B0D3D5F7F7F7F7F7F7F7D7D5B5939350EA6442222222),
    .INIT_03(256'hF7F7B5904C2A2A4C6E6E90B2D5D5F5F7F7F7F5F5F7F7F7F7F7F7F7F7F7F9F7F7),
    .INIT_04(256'hF7F7F7F7F5F5F5F5F5F7F7F7F7F7F7F7F5F5F5F5F5F5F5F5F5D5D5D5D5D5F7F7),
    .INIT_05(256'hD5D3B2B0906E6E6C4C2A2A0A0A2A4C90B5F7F7F7F9F9F9F9F9F9F9F9F7F7F7F7),
    .INIT_06(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F5F5F5F5F5F5F5F5F5F5F5D5D5),
    .INIT_07(256'h2C2C2C2E4E4E4E7070909092B2B2B3D5D5D5D5D5D7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_08(256'h64646442424242646462424242424244646484848686A6A6A6A6C8C8EA0A0C0C),
    .INIT_09(256'h200020202020204284A6A6846264644442646464644242646464868684646464),
    .INIT_0A(256'h8B8A6A6A44444444444466666666664422222242424222222220226466644422),
    .INIT_0B(256'hD5D5F7F7F7F7F7F7D7B5B5939350EA6442222222224244222022224446442466),
    .INIT_0C(256'hB2D3D5F5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7D5B3B1906E6E6E90B3),
    .INIT_0D(256'hF7F7F5F5F5F5F5F5F5F5F5F5D5D5D5D5D5D5D5F7F7F7D7B34E2A0A2A4C6E6E90),
    .INIT_0E(256'h0A2C6EB3D5F7F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F5F5F5F5F4F4F5F5F5F5),
    .INIT_0F(256'hF7F7F7F7F5F5F5F5F5F5F5F5F5F5F5D5D5D3D3B3B2B0908E6E6C4C4A2A0A0808),
    .INIT_10(256'hB2B3B3D5D5D5D5D5D5D5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7),
    .INIT_11(256'h42424242646484848486A6A6A6A6A8C8EA0A0A0C2C2C2C2E4E4E4E6E70909090),
    .INIT_12(256'h6264644442646464646464646464868664646486644242424242626464624242),
    .INIT_13(256'h6688886642222244222222442220224464444222000020222220204284A6A684),
    .INIT_14(256'h9250EA64424222224244444220224266664424666A6848682222444444446466),
    .INIT_15(256'hF7F7F7F7F7F7F7F7F9F9F7D5D5B3908E8E8E90B0B3D5D5D5F7F7F7D7D7D5B593),
    .INIT_16(256'hD4D4D5D3D3D3D5D5D7F7F9D5702C2A2A2A4C4C6E90B2D3D5D5F5F5F5F5F5F7F7),
    .INIT_17(256'hF9F7F7F7F7F5F5F5F5F5F5F4F4D2D2D2F4F5F5F5F5F5F5F5F5F5F5F5F5F4D4D4),
    .INIT_18(256'hD5D5D5D3D3B3B3B090906E6C4C4C2A2A0808E8082A4E92D5F7F7F7F9F9F9F9F9),
    .INIT_19(256'hD5D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F5F5F7F7F5F5F5D5D5F5F5F5D5D5),
    .INIT_1A(256'hA6A6A8C8EAEA0A0C2C2C2C2E4E4E4E7070909092B2B3B5D5D5D5D5D5D5D5D5D5),
    .INIT_1B(256'h64646462648486646464646242626464624242424242424264648484848686A6),
    .INIT_1C(256'h2222222222444442220020222222224264848484646464444244646464646464),
    .INIT_1D(256'h202244664624246868686A682000224466644466668644442222224422224466),
    .INIT_1E(256'hD5B3909090909090B3B3B3B5D5D7D7D7D7D5B5937350EA644242422242444422),
    .INIT_1F(256'hB34C0A0A2A2A4C4C8E90B2B3D5D5D5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F5),
    .INIT_20(256'hD2D2D2D2D2D2D2D4D4D4D4D4D2D2D2D2D2D2D2D2D2B2B2B2B2B2B3D5D7F7F9F7),
    .INIT_21(256'h2A2A2A0AE8E8E6E80A4EB3D5F7F7F9F9F9F9F9F7F7F7F7F5F5F4D4D4D4D4D2D2),
    .INIT_22(256'hF5F5F5F5F5F5F5F5F5F5F5D5D3D3D5D5D5D5D5D3D3D3B3B3B2B0B0908E6E4C4C),
    .INIT_23(256'h4E4E6E707070909092B2B3B3B5D5D5D5D5D5D5D5D5D5D5D5F5F5F5F5F5F5F5F5),
    .INIT_24(256'h4264646464426242424242426464848684868686A6A6A8C8C8EA0A0C2C2C2C2C),
    .INIT_25(256'h2222204264848464646464644464646464646464646464646464848664646462),
    .INIT_26(256'h2220222244444464666644442222224422224444222222222244444422002022),
    .INIT_27(256'hB5D5D7D7D7D5B5937350EA644242422242444222222244444424466A68686A48),
    .INIT_28(256'hB3D3D5D5D5F5F5F5F5F5F7F7F7F7F7F7F7F7F7F5D5B3B2909090909090B3B3B3),
    .INIT_29(256'hB2B0B0B0B0B0B0B0B0B0B0909090B2B3D5F7F7F7D56E2A0A0A2A2A4C6E8E90B2),
    .INIT_2A(256'hF7F7F7F9F7F7F7F7F7F5F5D5D4D2D2B2B2B0B0B0B0B0B0B0B0B0B2B2D2D2D2D2),
    .INIT_2B(256'hD3D3D3D3D3D3D3B3B3B2B2B090908E6E6E4C2A2A2A0A0AE8E8E8C6E80A6EB3D5),
    .INIT_2C(256'hB3B5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5),
    .INIT_2D(256'h6264648684868686A6A6A6C8C8EA0A0C2C2C2C2C4E4E4E70707090909092B2B3),
    .INIT_2E(256'h6464648686646464646464646484848686646462626464646462646242424242),
    .INIT_2F(256'h2222224422224222222222222244444442222222222222426486866464426464),
    .INIT_30(256'h4242422242442222422244442424468A68686848422220224444446666664444),
    .INIT_31(256'hF5F5F5F5F5F5F5F5D5D3B3B19090909090B3B3B5B5D5D5D5D5D5B5937330EA64),
    .INIT_32(256'h6E7090B3D5D7F7F7D7904C0A080A2A2A4C6E6E90B2B2D3D3D3D5D5D5D5D5F5F5),
    .INIT_33(256'hB0B08E8E8E8E8E8E8E6E6E8E8E8E9090B0B0B0B090909090909090909090906E),
    .INIT_34(256'h8E6E6C4C4C2A2A2A0808E8E8E8C6C6E80A6EB2D5D5F7F7F7F7F5F5F5D2D2D2B2),
    .INIT_35(256'hD5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D3D3D3D3D3B3B3B3B2B2B2B2B2B2909090),
    .INIT_36(256'hC8EA0A0A0C2C2C2C2C4E4E4E70707090909292B2B3B3B3B5D5D5D5D5D5D5D5D5),
    .INIT_37(256'h8484848686646462626464646462646242424242626464868484868686A6A6C8),
    .INIT_38(256'h2244444444222222424222426486866464424264646486868684646464646484),
    .INIT_39(256'h4446668A68686848442222202242446666664444222222442222422222222222),
    .INIT_3A(256'hB39190909091B3B3B5D5D5D5D5B5B593722EEA64424242222244222242222244),
    .INIT_3B(256'hE80A082A2A4C6E6E90B0B2B2B2D3D3D3D5D5D5D5D5D5D5D5D5D5D5D5D5D5B3B3),
    .INIT_3C(256'h4C6C6C6E6E6E8E6E6E6E6E6E6E6E6E6E6E6E4E4C4C4E6E90B3D5D7F7F7B56E0A),
    .INIT_3D(256'hC6C6C6E80A4EB0B2D4D5D4D4D2D2D2B0B08E8E8E6E6C4C4A4C4A4C4C4C4A4C4C),
    .INIT_3E(256'hB3B3B3B3B3B3B3B3B3B3B2B0B0B0B09090906E6E6E4C4C2A2A2A0A0808E8E8C6),
    .INIT_3F(256'h6E70707090909092B2B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3),
    .INIT_40(256'h6464646262424242626464648484868686A6A6C8C8EA0A0C0C0C2C2C2C4E4E4E),
    .INIT_41(256'h6486868664646464648486868684646464648484846484848464646264648464),
    .INIT_42(256'h2222444466444444222222422222422222422222224444224244222242444242),
    .INIT_43(256'hB5B5B593702ECA64424242222244222222222446464668686868684844422222),
    .INIT_44(256'hB2B2B2B3D3D5D5D5D5D3D3D3D3D3D5D5D5D5D3B3B3B39090909093B3B5B5B5B5),
    .INIT_45(256'h4C4C4C4C2C2A2A2A2A2C4C6E90B3B5D5D7D5700AE80808082A2C4C6E6E9090B0),
    .INIT_46(256'h8E8E8C6C6A4A4A2A2A2A28080808080808082A2A2A2A2A2A4C4C4C4C4C4C4C4C),
    .INIT_47(256'h90906E6E6E4E4C4C2C2A0A0A0A0808E8E8E8C6C6C6C6C6C60A2C6E909090B0B0),
    .INIT_48(256'hB2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B0B0B0B0909090B0B09090),
    .INIT_49(256'h84848686A6A6A6C8C8EAEA0A0C0C0C2C2C2E4E4E4E7070707070909292B2B2B2),
    .INIT_4A(256'h8464646464646464646464646464646264646464646464646242424262646464),
    .INIT_4B(256'h2244442222222222222242222244222242444442646464646464648486868686),
    .INIT_4C(256'h2242422220222446464668686A6A6A6844444422222222444444664422224422),
    .INIT_4D(256'hD3D3D3D5D5D5D3B39190909090909093B3B5B5B5B5B59393702ECA6442422222),
    .INIT_4E(256'h4E7090B2B5B5702CE808E8080A2A2A4C4C6E709090B2B2B2B3B3B3B3B3B3D3D3),
    .INIT_4F(256'hE6E6E6E8E8E8E808080808080A2A2A2A2A2A2A2A2A2A2A0A0A0A0A0A0A2A2A2C),
    .INIT_50(256'h08E8E8E8E6C6C6C6A6A6A6C6E80A2C4C4C6C6C6C4C4A4A2A282828080808E8E6),
    .INIT_51(256'h90B2B09090909090909090909090909090906E6E6E6E4C4C4C2A2A2A2A0A0808),
    .INIT_52(256'h0A0C0C2C2C2C2E4E4E4E70707070709092929292929090909090909090909090),
    .INIT_53(256'h646464646464646464646464626242426264646484848686A6A6A6C8C8EAEA0A),
    .INIT_54(256'h2244222242644442446464646262648686868686848464646464646464646464),
    .INIT_55(256'h8A8B686B44444422202222444444664422224222224444222222222222224222),
    .INIT_56(256'h907090939393B3B3B3939373502ECA6242422222224222222222244444466868),
    .INIT_57(256'h0A0A2A2A4C4C6E70909090B0B2B2B2B2B2B2B2B2B2B3D3D3D3D3B3B390909090),
    .INIT_58(256'h080808080A0A0A0A0A0A0A080808E8EA0A0A0A0A2A4C6E709093702CEAE8E8E8),
    .INIT_59(256'hC6E8080A2A2A2A2A282828080808E6C6C6A4A4A6A6C6C6C6E6E6E6E6E6E8E8E8),
    .INIT_5A(256'h6E6E6E6E6E6E6E4C4C4C4C2A2A0A0A0A0A0808E8E8E8E8E8C6C6C6A6A6A6A6A6),
    .INIT_5B(256'h4E6E70709090909090909090909090909090909090909090909090906E6E6E6E),
    .INIT_5C(256'h62624242646464648484868686A6A6C8C8EAEAEA0A0A0C2C2C2C2E4E4E4E4E4E),
    .INIT_5D(256'h424264A6A8A6A686868464646464646464646464646464646464646464646464),
    .INIT_5E(256'h4444444422222222222242222222222222224222222222224244422244646464),
    .INIT_5F(256'h502EC862422222222222222222222244444668688B6A688B4444442220204244),
    .INIT_60(256'h9090909090B0B2B2B2B2B3B3B3B3B3B390907070707090939393939393939373),
    .INIT_61(256'hE8E8E8E8E8E8080A0A2A2A4C6E70702CE8E8E8E8E8080A2A2A4C4C6E70909090),
    .INIT_62(256'hC6C6A482624242626484A6C6C6C6C6C6C6C6E6E8E8E8E8E8E80808080808E8E8),
    .INIT_63(256'h0A08080808E8E8E8E8E8C8C6C6C6A6A6A6A6A6A4A4C6C6E8E8E80808080806E6),
    .INIT_64(256'h7070706E6E6E6E6E6E6E6E6E6E6E6E6E6E4E4C4E6E4E4E4E4E4C4C4C4C2A2A2A),
    .INIT_65(256'h86A6A6C8C8EAEAEA0A0A0C2C2C2C2C2E4E4E4E4E4E4E6E6E7070707070709090),
    .INIT_66(256'h6464646464646464646464646464646464646464624242626464646484848686),
    .INIT_67(256'h2222222222224242222242424242424244646464424264A6C8C8A8A6A6846464),
    .INIT_68(256'h22222244464646686A68688D6444444220204244444244444222224222222222),
    .INIT_69(256'hB2B3B3B390907070707070909393939393937370502EC8624222222222222222),
    .INIT_6A(256'h4C4E4E2CE8C8C8E8E8080A0A2A2C4C4C6E6E6E9090909090909090B0B0B2B2B2),
    .INIT_6B(256'hA6C6C6C6C6C6C6C6C6C6C6E6E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8080A0A2A),
    .INIT_6C(256'hC6A6A6A6A6A6A48484A4A4C6C6C6E6E6E6E6E6C6A48260402000002020406284),
    .INIT_6D(256'h4E4E4E4C4C4C2C4C4C4C4C4C4C2C2C2A2A2A0A08080808E8E8E8E8E8C8C6C6C6),
    .INIT_6E(256'h2C2C2C2C2C2C2C4E4E4E4E4E6E6E6E6E6E6E6E6E6E6E6E6E6E6E4E4C4C6E6E4E),
    .INIT_6F(256'h646464646464646462424262646464648484848686A6A6A8C8C8EAEAEA0A0C0C),
    .INIT_70(256'h424244424464666464626284C8C8C8A8A6868484846464646464646464646464),
    .INIT_71(256'h6666644422002222424444444442224444222222222020222222444222224444),
    .INIT_72(256'h7092939393707070500EA8424242222222222222222244464646688D6A688B8B),
    .INIT_73(256'h0A0A2A2C4C4C4C6E6E6E6E6E909090909090909090B3B3B39090707070707070),
    .INIT_74(256'hE6E8E8E8E8E8E8C8C8E8C8C8A6A6A4A6E8E8080A0A2C2C0AE8C8E8C8E8E8E80A),
    .INIT_75(256'hA4C6C6E6C6C6A48282624020200000002020206284A6A6A6A6A6A6C6C6C6C6C6),
    .INIT_76(256'h2A2A2A0A0A0A0A080808E8E8E8E8E8C8C8C6C6C6A6A6A6A6A6A6A6A48484A4A4),
    .INIT_77(256'h4E4E4E4E4E4E4E6E6E4E4E4E4E4C4C4C4C4C4C4C4C4C4C4C2C2C2C2C2C2C2A2A),
    .INIT_78(256'h646464646484848686A6A6A8C8C8E8EAEA0A0C0C2C2C2C2C2C2C2C2C4E4E4E4E),
    .INIT_79(256'hC6E8C8C8C8A68684846464646464646464646464646464646464846464646464),
    .INIT_7A(256'h4444422222224444442222222222224222226644424244644444648664626486),
    .INIT_7B(256'h4242222242422222224466664646688A48688B6B664444442200224466662242),
    .INIT_7C(256'h6E6E6E7090909090909090909090707070706E6E7070939371707050500EA842),
    .INIT_7D(256'h62626284A6C8E80A0A0C0AE8C8C6C8C8C8E8E8E8E80A0A2A2A2C4C4C4E6E6E6E),
    .INIT_7E(256'h20202020404040426284A4A6A6A6A6C6C6C6C6C6C6E8C8C8C8C8C8C8C8C8A684),
    .INIT_7F(256'hE8E8C8C8C6C6C6A6A6A6A6A6A6A6A6A6A4A48484A4A4A6C6C6A4A48262624240),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_39_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_39_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized19
   (p_35_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_35_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_35_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000004003FFFFFFFFFC00000000000000000000000000007FFFFFFFFFFFFF8),
    .INITP_01(256'hFFFFFFFFFC00000000000000000000000000007FFFFFFFFFFFFE000000000000),
    .INITP_02(256'h0000000000000000000000000003FFFFFFFFFFFF800000000000000000000000),
    .INITP_03(256'h00000000000000003FFFFFFFFFFE0000000000000000000000000FFFFFFFFF80),
    .INITP_04(256'h000001FF0F99CBF0000000000000000000000000003FFFFFFFF8000000000000),
    .INITP_05(256'h00000000000000000000000000000001FFFFFFFF8000000000000000C0000000),
    .INITP_06(256'h0000000000000000000007FFFFFFF8000000000000000E000000000000000000),
    .INITP_07(256'h00000000000FFFFFFF8000000000000000F80000000000000000000000000000),
    .INITP_08(256'h7FFFFFF800000000000000038000000000000000000000000000003000000000),
    .INITP_09(256'h0000000000003C00000000000000000000000000000380000000000000000000),
    .INITP_0A(256'h01C000000000000000000000000000007800000000000000000001FFFFFF8000),
    .INITP_0B(256'h00000000000000000000078000000000000000000007FFFFF800000000000000),
    .INITP_0C(256'h0000000000FC000000000000000000000383FF80000000000000000C00000000),
    .INITP_0D(256'hC0000000000000000000000007F80000000000000000C0000000000000000000),
    .INITP_0E(256'h000000000000003F00000000000000000300000000000000000000000000000F),
    .INITP_0F(256'h0003F00000000000000000300000000000000000000000000001FE0000000000),
    .INIT_00(256'h4C2C2C2C4C2C2C2C2C2C2A2A2A2A2A2A2A2A2A0A0A0A0A080808080808E8E8E8),
    .INIT_01(256'hC8C8E8EAEA0A0C0C0C2C2C2C2C2C2C2C2C2C2C2C4C4C4C4C4C4E4E4C4C4C4C4C),
    .INIT_02(256'h6464646462646464646464646464646464646464646464646484848686A6A6A8),
    .INIT_03(256'h224444422222646444424444426486A884646484A6C8C8C8C8C8A68684646464),
    .INIT_04(256'h4644666A46688D6B444444442200224464644444444444222242424444444422),
    .INIT_05(256'h70706E6E6E6E4E4E4E707070707050502E0CA842222222224242222222446666),
    .INIT_06(256'hC6C6C6C6C6C8E8E8E8E808080A2A2A2C4C4C4E4E6E6E6E6E6E6E6E6E6E709090),
    .INIT_07(256'hA6A6A6A6C6C6C6C6C6C8C8C6C6C8C8C8A6A4624240426282A4C6E8E8EA0AEAE8),
    .INIT_08(256'hA6A6A6A6A6A48484848484A4A4A48484846262424040404262626262626284A4),
    .INIT_09(256'h2A0A2A2A0A0A0A0A0A080808080808E8E8E8E8E8E8C8C8C6C6A6A6A6A6A6A6A6),
    .INIT_0A(256'h2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2A2C2C2A2A2A2A2A2A2A2A2A2A2A),
    .INIT_0B(256'h6464646464646464646464646484868686A6A6A8C8C8C8EAEA0A0C0C0C0C2C2C),
    .INIT_0C(256'h4264A8A886848484A6C6C8C8C8C8A6A6A6846464848484646464646464848464),
    .INIT_0D(256'h2200224244444444446664224444444444442222224444444222646444444242),
    .INIT_0E(256'h707050502E0CA84222222222424222222244666644446668486A8D6D44424444),
    .INIT_0F(256'h080A2A2A2C2C4C4C4C4E4E6E6E6E6E6E6E6E6E6E6E6E4E4E4E4E4E4E4E507070),
    .INIT_10(256'hC6C8C8C6A46240404262628284A6C8E8E8E8E8C6C6C6C6C6C6C8C8E8E8E8E8E8),
    .INIT_11(256'h848484848484626262626262648464626262648484A4A6A6A6A6C6C6C6C6C6C6),
    .INIT_12(256'h08E8E8E8E8E8E8C8C8C8C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A48484848484),
    .INIT_13(256'h2A2A2A2A2A2A2A2A2A2A2A0A2A2A2A2A0A0A0A0A0A0A0A0A0A0A0A0808080808),
    .INIT_14(256'h8484868686A6A6A8C8C8C8EAEAEA0A0C0C0C0C0C0C0C0C0C0C0C0C0C2C2C2C2A),
    .INIT_15(256'hA6C8A6A6A6A68486868684848464646484848684846464646464646464646464),
    .INIT_16(256'h44444444442222222264664444426464644442424264A8A8A8A68484A4A4C6A6),
    .INIT_17(256'h422222222244664424444668686B8D8D44444444220022224444444244666644),
    .INIT_18(256'h4E4E4E4E4E4E4E4E4E4C4E4E4E4E4E4E4E4E70707050502E2EECA84222222222),
    .INIT_19(256'h84A6C6C8C8C6C6C6C6C6C8C6C6C8C8C8E8E8E8E808080A0A2A2C2C2C2C4C4C4C),
    .INIT_1A(256'h848484848464646484A4A6A6A6A6A6C6C6C6C6C6C8C8C8A68462406262828484),
    .INIT_1B(256'hA6A6A6A6A6A6C6C6C6A6C6C6A6A6A6A484848484848484848484848484848484),
    .INIT_1C(256'h0A0A0A0A0A0A0A0808080A0A0A0808E8E8E8E8E8E8E8E8E8E8E8C8C8C6C6C6A6),
    .INIT_1D(256'hEAEA0A0A0C0C0A0A0C0C0C0C0C0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_1E(256'h84846464848486848484646464646464646464648484868686A6A6A8C8C8C8E8),
    .INIT_1F(256'h4444646464644242426486A8EAC8C6A48484A4A4A4A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_20(256'h6A6B6D8D44444444220022424464444444668866444444444422222022666644),
    .INIT_21(256'h2C2C2C2C2C2E4E4E4E4E4E2E2EECA84222222222422222222244664424446648),
    .INIT_22(256'hC6C6C8C8C8E8E8E8E8E8080A0A0A2A2C2C2C2C2C2C4C4C4C4C4C4C4C4C2C2C2C),
    .INIT_23(256'hA6A6A6A6C6C6C6C6C6C6C6A68484626282848484A4A6A6C6C6C6A6A6C6C6C8C8),
    .INIT_24(256'hC6A6A6A6A684848484848484848484848484848484848484848484648484A4A6),
    .INIT_25(256'hE8E8E8E8E8E8E8E8E8E8E8E8C8C8C8C6C6C6A6A6A6A6A6A6A6A6C6C6C6C6C8C8),
    .INIT_26(256'hEAEAEAEA0A0A0A0A0AEAE80808E8E8080A08E8E808E8080808080808E8E8E8E8),
    .INIT_27(256'h64646464646464648484868686A6A6A8C8C8C8C8EAEAEA0A0A0A0A0A0A0A0A0A),
    .INIT_28(256'h0C0CE8C6A482A48484A4A6A6A6A6A6A6C8C8A6A6A68484648484848484846464),
    .INIT_29(256'h44444444446466664442224244442222426644444444644464644442426284C8),
    .INIT_2A(256'h2EEC8642222222224220222222444444444668686A6B8D8F4444444222002244),
    .INIT_2B(256'h0A0A0A0A0A2A2A2A2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C4E4E4E4E2E2E),
    .INIT_2C(256'hA6A6A6848484A4A4A4A6A6A6C6A6A6A6C6C6C6C6A6A6C8C8C8C8C8E8E8E8E808),
    .INIT_2D(256'h848484848484848484848484848484848484A4A6A6A6A6A6C6C6C6C6C6C6A6A6),
    .INIT_2E(256'hC8C8C6C6C6A6A6A6A6A6A6A6A6C6C6C6C6C8C8C8C8A6A6A6A6A6868484848484),
    .INIT_2F(256'hE8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8C8),
    .INIT_30(256'h86A6A6A8C8C8C8C8EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAE8E8E8E8E8E8E8E8),
    .INIT_31(256'h84A6A6A6C6C8C8C8A6A684848484848484848464646464646464646464848686),
    .INIT_32(256'h44222222446664444466664444644442426484A62C0C0AE8C6A4A4848484C8A6),
    .INIT_33(256'h22444424446888686A6B8D8F4444422222202244444422224466888866444464),
    .INIT_34(256'h2C2C2A2A2A2A2A0A0A0A2C2C0C2C2C2E2E2E2E2E0EEA86424222222242222222),
    .INIT_35(256'hC6A6C6C6C6C6C6C6A6A6C6C8C6C6C8C8E8E8E8E8E8080A0A0A0A0A0A0A2A2C2C),
    .INIT_36(256'h848484848484A4A6A6A6A6A6A6C6C6C6A6A6A6A6A6A6A6A6A6A6A4A6A6A6A6A6),
    .INIT_37(256'hA6C6C6C6C6C8E8EAE8C8C6C6A6A6A6A686868484848484848684848484848484),
    .INIT_38(256'hE8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8C8C8C8C6C6A6A6A6A6A6A6A6A6A6),
    .INIT_39(256'hEAEAEAEAEAEAEAC8C8C8C8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8),
    .INIT_3A(256'h848484848484846464646464646464646484848686A6A6A8C8C8C8C8CAEAEAEA),
    .INIT_3B(256'h44444442426484840A0A2C2C0AC6A4A48484C8A684A6A6A6A6C6C8C8C8C8A686),
    .INIT_3C(256'h4444222222222244444222224266868886644466642222224466444444666644),
    .INIT_3D(256'h0C0C2C2C2C2E2E2E0ECA664242422222222222222244442246688A6A686B8FAF),
    .INIT_3E(256'hC6C6C6C8C8E8E8E8E8E8E8E80A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_3F(256'hA6C6C6A6A6A6C6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C8C8C8C6C6A6A6C6C6),
    .INIT_40(256'hC6A6A6A6A6A6A684848486868686868484848484848484848484A4A6A6A6A6A6),
    .INIT_41(256'hE8E8E8E8C8C8C8C6C6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6E80A0AEAC8C8C8),
    .INIT_42(256'hC8C8C8C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8),
    .INIT_43(256'h646464646484848686A6A6A8C8C8C8C8C8EAEAEAEAEAEAEAEAC8C8C8C8C8C8C8),
    .INIT_44(256'h2CE8C6A6A484E8A684A4A6A6A6A6C6C8C8C8A6A6A6A6A6868684848464646464),
    .INIT_45(256'h22446666666644646644222244664444446666444444444242648462C8EA2C2C),
    .INIT_46(256'h22424222222222222244442444688A68686B8DB1444422222222224444222222),
    .INIT_47(256'hE8080A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0C0C0C2C2E0E0E0ECA6442),
    .INIT_48(256'hA6A6A6A6A6A6A6A6C6C8C8C8C8C8C8C6C6A6A6C6C6C6C6C6C6C8C8E8E8E8E8E8),
    .INIT_49(256'hA6A6A6868484848484848484848484A4A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_4A(256'hA6A6A6A6A6C6C6C6A6C6C8C6C6E82C2C0AE8C8C8C8C8C8A6A6A6A6A6A6A6A6A6),
    .INIT_4B(256'hC8C8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8C8C8C8C6C6A6A6A6A6),
    .INIT_4C(256'hC8C8C8C8C8C8EAEAEAC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C6C6C6C8),
    .INIT_4D(256'hA6A6A6C6C8C6C6A6A6A6A6A6A6A6868484846462646464646484848686A6A6A8),
    .INIT_4E(256'h4466644444446444446444422264646284C80A2C4C0AE8C6A4A4C8A484A4A4A6),
    .INIT_4F(256'h44686A48686B8DB1444442220022446444222222444466666666664466644444),
    .INIT_50(256'h0A0A0A0A0A0A0A0A0A0C0C0C0C0E0E0E0EC86442224242222222222022444422),
    .INIT_51(256'hC8C8C8C6C6C6C6A6A6C6C6C6C6C8C8C8E8E8E8E8E8E8E80A0A0A0A0A0A0A0A0A),
    .INIT_52(256'h84848484A4A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C8C8C8),
    .INIT_53(256'hC80A2C2E0CE8C8C8C8C8C8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6848484848484),
    .INIT_54(256'hE8E8E8E8E8E8E8E8E8E8C8C8C8C6C6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C8C8C6),
    .INIT_55(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C6C6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C8E8E8),
    .INIT_56(256'hA6A6868484846462646464646484848686A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_57(256'h4242646262A6E80A4E0AE8C6A6C6C8A6A4A6A6A6A6A6A6A6A6A6A6C6C6C6C6A6),
    .INIT_58(256'h002266664422222222446688AA88664486664444446466866644644444444442),
    .INIT_59(256'h0C0C0C0E0CA86422224242222222222244664444468A8A688D8D8DB144444422),
    .INIT_5A(256'hC6C6C8C8E8E8E8E8E8E8E8E8E8080A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0C0C),
    .INIT_5B(256'hA6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C6C6C6A6A6A6A6C6),
    .INIT_5C(256'hA6A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6868484848484A4A6A6A6A6A6A6),
    .INIT_5D(256'hC6C6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C8C8C8C8E80A4E4E2EEAE8C8C8C8C8A6),
    .INIT_5E(256'hC6C6C6C6C6C6C6C6C6C8C8C8C8C6C6C6C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C6),
    .INIT_5F(256'h6464848686A6A6A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A8A8A6C8C8C6C6C6),
    .INIT_60(256'hC6C6C8A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6A6A6A6A684848484646464646464),
    .INIT_61(256'h8666664488666666666688886642644444444442424464866284A6E82C0AE8C8),
    .INIT_62(256'h2222222244444444688A8A6AAFAF8DB144444422002264442222222222426466),
    .INIT_63(256'hE8E8E8E8EAEA0A0A0AEAEAEAEAEA0A0A0A0A0C0C0C0C0C0E0CA8442222424222),
    .INIT_64(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C6C6C6A6A6A6A6A6C6C8C8C8E8E8E8E8E8E8E8),
    .INIT_65(256'hA6A6A6A6A6A6A686868484848484A4A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C8),
    .INIT_66(256'hA6A6C6C6C8C8C6E80A2C70704E0AE8E8C8C8C8C8A6C8C8A8A8A8A6A6A6A6A6A6),
    .INIT_67(256'hC8C6C6C6C6C8C8C8C8C8C8C8C8C8C8C8C6C6C6C6C6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_68(256'hC8C8C8C8C8C8C8C8C8C8C8A8A6A6A6C6C6C6C6C6C6A6A6C6C6C6C6C6C6C6C6C8),
    .INIT_69(256'hA6C6C6C6C6A6A6A6A6A6848686848464646464646464848686A6A6A8A8C8C8C8),
    .INIT_6A(256'h6642644444444444424486A8646284C80A0AEAE8E8C8C8C6C6C6C6C6A6A6A6A6),
    .INIT_6B(256'hAFAF8D8F44444422224244442222222222424444446444226666666664446686),
    .INIT_6C(256'hEAEAEAEAEA0A0C0C0C0C0E0E0CA84222224242222222222244442444688A6A6B),
    .INIT_6D(256'hC8C8C6C6A6A6A6A6A6C6C6C8C8C8E8E8E8E8E8E8E8E8E8E8E8E8EAEAEAEAEAEA),
    .INIT_6E(256'h8686A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_6F(256'h702CEAE8E8C8C8C8C8C8C8C8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A686868686),
    .INIT_70(256'hC8C8C8C6C6C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C6C8E82C707093),
    .INIT_71(256'hA6A6A6A6C6C6C6A6A6A6A6A6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8),
    .INIT_72(256'h8686846464646464646484868686A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8C8A8A8),
    .INIT_73(256'h88646284C8E80A0AE8C8C8C6C6C8C6C6C6A6A6A6C6C6C6C6C6A6A6A6A6A68686),
    .INIT_74(256'h22222222222222446466442266666666644444666644444464444444424486CA),
    .INIT_75(256'hECA64222224242222222224444444446686A6A8DAFAF8D6D4444444422444444),
    .INIT_76(256'hC8C8C8E8E8E8E8E8E8E8E8EAEAEAEAEAEAEAE8E8E8EAEAEAEAEA0A0C0C0C0E0E),
    .INIT_77(256'hA8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C6C6A6A6A6A6C6C6C6),
    .INIT_78(256'hA8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A68686868686A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_79(256'hA6A6A6A6A6A6A6A6A6A6C6C8C8C6E80A7092B3B5934E0AE8E8E8E8C8C8C8C8A8),
    .INIT_7A(256'hA6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C8C6C6A6A6A6A6A6A6A6),
    .INIT_7B(256'h8686A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_7C(256'hC8C8C8C8C6C6C6C6C8C8C8C6C6A6A6A6A6A6A6A6A68684646464646464648486),
    .INIT_7D(256'h88888666666644446464444466666444424466A8CC866464A6C80A0AE8C8E8C8),
    .INIT_7E(256'h4444666668686BAFD1B18F6D4444444444444444422222222222226488886644),
    .INIT_7F(256'hE8E8E8E8E8E8E8E8E8E8E8EAEAEA0A0C0C0C0E0EEC8642222242422222222244),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_35_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_35_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized2
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire CASCADEINA;
  wire CASCADEINB;
  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ;
  wire [31:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hFFC701EFFF807FFE07EFFFFFFFFF80000000000000000007FFFCFAC000000000),
    .INIT_01(256'h0FFF0FFF1FFFFFFFF8000000000000000001FFFFC7D60800000000000083C7C7),
    .INIT_02(256'hFFF7FFF000000000000000001FFFFE3EE0000000000C80080E7E7FF8C01EDF00),
    .INIT_03(256'h000000000000001FFFF1F70000000000C800C0E7FFFC3803E7F603FF84700067),
    .INIT_04(256'h0001C7FFAFB0000000000C800E0FFFFFC301667061FFF00CC0007FFFFFFFE000),
    .INIT_05(256'h80000000008800F0FFFFE0C03646011DBE7DD980081FFFFFFFE0010000000000),
    .INIT_06(256'h800F1FF9FC080D8F000FF38FF0780803FFFFFFFF20100000000000001E37FC34),
    .INIT_07(256'h003840003E71FE0FC0002FFBFFFEFFE180000000000007E1FFE1EE0000000018),
    .INIT_08(256'h3FFFFF7C23FFFFFFFFFF78080000000000020FFF3F60000000009803E1FF3FF1),
    .INIT_09(256'hFFFFFFFFFF8000000000000078FFFFF90000000009007F1FFBFB6007860087FF),
    .INIT_0A(256'h0000000000000FC1FFFFE8000000019007F1FFFF240078601CFFFF7FFFFFC03F),
    .INIT_0B(256'h003C1FFFFD800000001901FF1FFFF0803F8001DFFFE7FFFFFC03FFFFFFFFFFF8),
    .INIT_0C(256'h20000001107FE1FFFF1007F80017FFFC7FFFFFC07FFFFFC03FFFD80600000000),
    .INIT_0D(256'h7E1BFF6301FFC00077FF07F8FFFC0FFEFFC001FCF8B8200000000000C4FFFFE6),
    .INIT_0E(256'hF830073FFDFE07FFF1FFFFBCE0FFFFCFC000000000000043FFCAB00000001387),
    .INIT_0F(256'h007FFFC0FFFFFF7FFFFFBC0000000000000407FCF580000001387FC3B3FC243F),
    .INIT_10(256'hFFFFFFFFF9C06000000000000037E7AA0000001387FC013FC4C79F060063FFFF),
    .INIT_11(256'h0620000000000003B41D70000001283DC013F0D9E371E0101EEF8003FFFF8FFF),
    .INIT_12(256'h00000368D7C000002603E8813E13BE743E01003CC001F0FFFFFF87FF9FFFFFFC),
    .INIT_13(256'h00000320188753E307C7EFE000043C003FF1E1EFBE7FFFFDFF0FFBE700000000),
    .INIT_14(256'hF4AC30783E7C000FC38007FE0001FFFFFF7F3F80FFFF700000000000001604B0),
    .INIT_15(256'h0001FC3000E000003FFFFFFFFBF007FFF700000000000001E0250000007201E3),
    .INIT_16(256'h00181FFFFFFFEFFF003FFFF30000000000000E0178000007603D7FCE821E63C0),
    .INIT_17(256'hFCFFC000FFFFF8000000000006D00BC0000076061FFEC843CE7900013F80001C),
    .INIT_18(256'hFF8000000000000500CC000006C0E1FFACC03DDE00001900C003000783FF7FBF),
    .INIT_19(256'h00007087400000E69E1FFEC48381E0000780080000007FFFFE03FFFFFC1FC7FF),
    .INIT_1A(256'h000C3DF3FFEC2830380000FC0000000001FFFF01FFCFFF0FFA7FF07F00000000),
    .INIT_1B(256'h43164700001E80000000001FFFC1FFF0FC331F377E03FC0000000000070C7800),
    .INIT_1C(256'hC00000000001FFFE7FFE0F80418300600FF080000000003807200000C79F3FFE),
    .INIT_1D(256'hFFE3FFEFCF63193FF230043FFC0000000003904E10000CF0F3FFE011C4F00003),
    .INIT_1E(256'hFE00E1EFD02DFFC0000000001F85810000CE3F3FFE26198F6000F80000000000),
    .INIT_1F(256'h4FFFC000000001CC5B000008C7E3FFA06BB3FE000F00000000001FFE7FFFFE78),
    .INIT_20(256'h000CC14000008C7E0FFA49F27F0000E00000000001FFFF7FFFC170E00CFF7E0B),
    .INIT_21(256'h08C7E0FFE73EEFF0000400000000003FBC203FBC0C02009FFBE0187FFF000000),
    .INIT_22(256'hEAF80000000000000007C00031F1C1002607FFDF0013FFF000000000C0258000),
    .INIT_23(256'h000000001000E73E3C600061FFFEFC025FFF80000000040238000098FE0FFEEF),
    .INIT_24(256'h1E3F800C0001FFF9F7E010FFFF0000000022224000010FF07FEE758300002000),
    .INIT_25(256'hF87FFFBF0607FFF000000002221C000011FF87FE37D05800020000000000F000),
    .INIT_26(256'h3FFF8000000000212002030FF87DE3725F80040000000000008007C7F801C003),
    .INIT_27(256'h000206001070FF8FDE4F8DF000C0000000000008007FF9803C00F8061FF9F834),
    .INIT_28(256'h1FFFFFE9E6DE001C0000000000000007FFFF83C07C00C4FFDFC301FFFE000000),
    .INIT_29(256'hA0030C000000000000007FFFFC781F801CCFFEFE180FFFF80000000060D00187),
    .INIT_2A(256'h0000000007DFFF8701F0018FFFF7E4007FFFE00000000209000063FFFEBD9ADB),
    .INIT_2B(256'hFFF1F01E0010FFFF3F4007FFFF000000002068000CFFFFC7CB4D7C01C1000000),
    .INIT_2C(256'h1BFFF9D0203FFFF000000002048000DFFFFEBC69EFC07200000000000000003F),
    .INIT_2D(256'hFFFF000000002018000DFFFFEBC4A9BA0F600000000000000381FFF83E03E001),
    .INIT_2E(256'h02034000CFFFEEBF555F23E600000000000000181FFF03E03E00113FFFDF8309),
    .INIT_2F(256'hFEE3FF33F07C000000000000000003FFE0FE03F00007FFFEF8309FFFFE000000),
    .INIT_30(256'hC00000000000000001FFFC1FE03FC0007FFFE7C10DFFFFE00000000024000C5F),
    .INIT_31(256'h0000003FFF83FE03FC001FFFFE74004FFFFE0000000001C000E5FFE078EE7F1F),
    .INIT_32(256'h7FE07F8003FFFFE3A0427FFFF0000000801200044FFF948E7FE7E00000000000),
    .INIT_33(256'hFFFF9E0033FFFF80000008016000C4FFFC46B7FFFC000000000000000007FFF8),
    .INIT_34(256'hFFFF800000001D00080FFFC4F71BDFC00000000000000000BFFF8FF807F9C03F),
    .INIT_35(256'h01980081FFF8E143FC3800000000000000001BFFE9FE603FFF03FFFFFCF0119F),
    .INIT_36(256'hCD3BBF0DB80000000000000001FFEC3FC603FDF03FFFFFEF81087FEFF8000000),
    .INIT_37(256'h000000000000013FFF07F8001FDFC1FFFFFF7C0803FF7F800000000980085FFF),
    .INIT_38(256'h001FFFE0FF8001FFFF07FFFFF3C0001FF7FF00000000A80085FFFDDFB7F07300),
    .INIT_39(256'h001FFFFC7FFFFFBE0401FFFFF80002000AC00247FF9C727F0000000000000000),
    .INIT_3A(256'hFFFBF0600FFFFF80002000DC00367FF1BB27F8000000000000000007FFFE1FF8),
    .INIT_3B(256'hFFFC00020005000363FF30F06F800000000000000000FFFC0BFF0001FFFFC7FF),
    .INIT_3C(256'h3400741FF09726F8000000000000000007FFB07FE0001FFFFE7FFFFFBF0003FF),
    .INIT_3D(256'h20560000000000000000007FF00FFC0003FFFFFFFFFFF9F8003FFFFFC0000000),
    .INIT_3E(256'h00000000001FFC03FF80003FFFEFFFFFFF9FC181BFFFFE00000003400FC00EF5),
    .INIT_3F(256'hFF007EF00003FFFE77FFFFFEFC1813FFFFE000000024008500113C2C00000000),
    .INIT_40(256'h3FFFF81FFFFFEFF1803FFFFE0000001A6000700123C1C0000000000000000007),
    .INIT_41(256'hFC7F1803FFFFE00000006F00338E0DB82E000000000000000000FFE00DFE0000),
    .INIT_42(256'hFF00000006F0033C088E83F000100000000000001FF800FC80000BFFFF81FFFF),
    .INIT_43(256'h8011C1EA7C38000000000000000007FF803F800001FFFFF9FFFFFFC3F8803FFF),
    .INIT_44(256'h000000000000000000FFE007F000001FFFFFFFFFFFFF3F8801FFFFF00000001B),
    .INIT_45(256'h0000001FFCC0C0000003FFFFE3FFFFFFF9F8440FFFFF80000001B80080103547),
    .INIT_46(256'h1E0000007FFFFE1FFFFFFFC78660FFFFF800000011E0DF009330C1E000000000),
    .INIT_47(256'hFF80FFFFFFFC786217FFFD800000013E0D0805E20E7E0000000000000003FFB8),
    .INIT_48(256'hE387317FFFD900000013E01F01A70DEDC0000000000000007FE707E000000FFF),
    .INIT_49(256'h900000013E0087E0565EFC0000000000000007FE61F0000000FFFFFC1FFFFFFF),
    .INIT_4A(256'h19E1F42FAF8000000000000000FE00300000001FFFFFE7FFFFFFFE3C3303FFFF),
    .INIT_4B(256'h000000000000000FC00600000003FFFFFC7FFFFFFFF2C1101FFFFB00000013E0),
    .INIT_4C(256'h0001FC00C80000003FFFFF9FFFFFFFFF0C1981FF9FB8000000DE01FE216ABBC8),
    .INIT_4D(256'h800007FFFFF9EFFFFFFFF841DC1FFDEB8000000DE0B9B81A87BC000000000000),
    .INIT_4E(256'hE7FFFFFFFFC61DC0FFCEB80000009E011F41DB73E0000000000000001F8139C1),
    .INIT_4F(256'h61DC0FFCFF800000097009C745A73E030000000000000EE066180000007FFFFF),
    .INIT_50(256'h000000F300DAE378F7E0000000000000007E06E18000000FFFFFFEFFFFFFFFFC),
    .INIT_51(256'hFC3F9EF80000000000000003F80FF0000001FFFFFFFFFFFF8FFFC31EE07FEFF8),
    .INIT_52(256'h000000000000FF81FF8000001FFFFFFFFFFFF0FFFC70FE03FE7F8000000F2003),
    .INIT_53(256'h1FF03FF8000007FFFFFFFFFFFE0FFFC787F01FE7F8000000EA000328A36F0000),
    .INIT_54(256'h03FFFFFFFFFFFFE0FFF8483F80FE3E80000004A0637BFE7C0003000000000000),
    .INIT_55(256'hFFFE0FFF80C3FC0FF3E80000005F06BF31C38C0030000000000001FF07FE0000),
    .INIT_56(256'h3FC07F3E40000003F06BF37C78C0020000000000003FC0FFC000007FFFFFFFFF),
    .INIT_57(256'h000037003FBB47B00000000000000003FC1FFC00000FFFFFFFFFFFFFF061F01C),
    .INIT_58(256'h38F200000000000000007FC1FFE00021FFFFFFFFFFFFFE001F01C1FE07F1E400),
    .INIT_59(256'h0000000007F81FFF000FBFFFFFFFFFFFFFE000401C1FE07F5E4000000340019C),
    .INIT_5A(256'h83FFC003FFFFFFFFFFF0FFFE00060161DE03F1E4000000240000CF8F60000000),
    .INIT_5B(256'hFFFE7F8007FFE000F0161DF03F8A70000002608300F57C00000000000000007F),
    .INIT_5C(256'hF0001F0030DF03FCB70000002609D0171BC00000000000000007F03FF0007FFF),
    .INIT_5D(256'hF83FCBB0000002709C00739800000000000000007F07FF0007FFFFFFE020000F),
    .INIT_5E(256'h002E08C40F7320000000000000000FE03FE0007FFFFFF8000000780003E01B0F),
    .INIT_5F(256'h220000000000000000FE03F80003FFFFFC0000000000000001F8EF83FEFB0000),
    .INIT_60(256'h0000000FC03F0000003FBE00000000000000001F86FC1FEF90000003C08C02F7),
    .INIT_61(256'hE000000000000000000000000001F86FC1FF794000003A08E05E444000000000),
    .INIT_62(256'h00FFFE00000000001F837C0FF39E000002A0AF07E4040000000000000000F80F),
    .INIT_63(256'h000001F833E0FF38E000002A0BE31EE000000000000000000F83F80000000000),
    .INIT_64(256'h07E38E00000291963FEC080000000000000000F07F800000047FFFFFFFFE0000),
    .INIT_65(256'h291D723EB100000000000000000F03FF00000FFFE000007FFE000000001F813E),
    .INIT_66(256'h0000000000000001E07FF00007FF800000003FFC00000001F811E07E38700000),
    .INIT_67(256'h00001E0FFF0001FDE01F800000FFF800061FFD811E03E1C3000002B9D61FEF00),
    .INIT_68(256'h00F0041FFF7F0007FFC000F1FF8001F03F1C3100002F8CCE7FC0000000000000),
    .INIT_69(256'hFFC401FCE00FFFF8001F03F8E21000027CE9E6F4400000000000000007E0FFF0),
    .INIT_6A(256'hFFFC0040F03F8651800027CE034FCE00000000000000007C1FFF00B80003FFFF),
    .INIT_6B(256'hFC713C00027CEF09FDC00000000000000007C1FFFFF80001FFFFFFFFF00FFF00),
    .INIT_6C(256'hCFD7FFF81800000000000000F83FFFFE00003FFFFFFFFF007FF03FFF011FE003),
    .INIT_6D(256'h0000000000000F87FFFF80C7C7FFFFFFFFFE03FF87FFC03FFF07FFC393E00025),
    .INIT_6E(256'h00F8FFFFE03CFC6FFFFFFFFFF83FFFFFF803FFFFFFFF38BE000246F45FFF83C0),
    .INIT_6F(256'hFF00FFFFFFFFFF81FFFFFF01FFFFFFFFFB9BE000240F657FF8FC000000000000),
    .INIT_70(256'hFFF807FFFFC03FFFFF3FFFFDBC000240F63FC71E000000000000001F0FFFF80F),
    .INIT_71(256'h07FFFFFFFFFFCFC0002409B3FCFBC000000000000003F0FFFF81FF000CFFFFFF),
    .INIT_72(256'hFEFE00024019BFE73E000000000000003E1FFFE0FF000007FFFFFFFFC03FEFF8),
    .INIT_73(256'hAFFF772080000000000003C1FFFC3F00FEF00FFFFFFFFE03FFFF01FFFFEFFFFF),
    .INIT_74(256'h00000000007C1FFF8FE03FFFF83FFFFFFFF07FFFF03FFFFC7FFFFFEDE0002601),
    .INIT_75(256'h83FFF1F807FE1CE1FFFFFFFF07FFFE03FFFFEFFFFFFFDE0002E09EFEFFF21800),
    .INIT_76(256'h002701FFFFFFE0FF3FE07FFFFFFFFFFFFFE0002E0107EDFF818000000000000F),
    .INIT_77(256'hFC1F81FE0FFFFFFFFFFFFFFE0002F18E7F9FD800000000000000F27FF83007F0),
    .INIT_78(256'hFFFFFFFFFFFFE0002F08C7F001800000000000001E3FFF0000FE001F1C1BFFFF),
    .INIT_79(256'hE60002F01F7F033010000000000001E7FFF0001FF001FC781FFFFFC1E01FE1FF),
    .INIT_7A(256'hE07A018000000000003CFFFC0007FF800FE1E0FFFFF83E00FE0FFFFFFFFFFFFF),
    .INIT_7B(256'h00000003DFFF81F07FFE00100E07FFFF87C007E0FFFFFFFFFFFFFF60002703F7),
    .INIT_7C(256'hF81807FFF00000603FFF80FC007E0FFFFFFFFFFFFFF6000070F97E0600300000),
    .INIT_7D(256'h040E03FFF81E0003E0FFFFFFFFC7FFFF60000F0F51C00227000000000000FBFF),
    .INIT_7E(256'hC0003E0FFFFFFFE07FFFF60000F0F1B000066000000000000F3FFF03803FFF00),
    .INIT_7F(256'hFFC6023E3F60002F80EA0001EC000000000000E7FFE0F00703FFC007F01FFF81),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("LOWER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(CASCADEINA),
        .CASCADEOUTB(CASCADEINB),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED [31:0]),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0002B83EA0001F0000000000000EFFFC7F80E07E0FFFE7003FF0380003E07FFF),
    .INIT_01(256'h03C0000000000001CFDFFFFFF81E3EF8F0C003FF0780000F07FFFFFC000041FE),
    .INIT_02(256'h00003DF0FFFFF0000C2FEF63003FE0F00000707FFFFF8FC0000F20003B8AA800),
    .INIT_03(256'hE6000F19A5F18607FC1E00000787FFFF81FFC000720003B84D00003000000000),
    .INIT_04(256'h8F307FC1E00600787FFFF81FF8000320002DCD30000E000000000000039F1FFF),
    .INIT_05(256'hFC0783FFFD90FF0000320006C4B30003C00000000000007BF9FFFC0007FF9D80),
    .INIT_06(256'h300000012000684930303C0000000000000F3FDFFFC001FF8E703FF1FFF81C03),
    .INIT_07(256'h0686E3030780000000000000F7FDFFF800FE7F80000FEFFF01C3FFE0383FF800),
    .INIT_08(256'h0000000000001EFFDFFF801FCF98C003FE7FF81C3FFE0183FF80F83E00000200),
    .INIT_09(256'h01CFC1FFF803FFF800003FFBA041C7FFF01C3FF87C7F1E00002000682FF03073),
    .INIT_0A(256'h7FFF000103FBBF003C7FFF81C3FF3EFE0C3E000200029147020F600000000000),
    .INIT_0B(256'hC3F80787FFF80E1FF3FF03B9E0003001B915F800E60000000000001DF81FFF80),
    .INIT_0C(256'hC0F1FFEFFB5C6F0003001350BE000850000000000003DF01FFC80FFFF1800037),
    .INIT_0D(256'h81F80030003D17E001038000000000003BF01FF880FFBC5C00013C3F81F87FFF),
    .INIT_0E(256'hA944003060000000000007BF80FF8C1FFFE3800003E1E03F87FFFC0E1FF8F001),
    .INIT_0F(256'h000000000073F80FFF83FFC07800023E080FF03E1FE063FFFE00078CC0010003),
    .INIT_10(256'h7E00FFF83FFC07C00021F481FC03E1FF0E3FFF00001CFE0010007A927C070000),
    .INIT_11(256'h7FFC00061FC4F9003E1FF0E3FF8000003FF0008007A7BFC0E000000000000007),
    .INIT_12(256'h2F0003F0FF0E1FF00000C1DF000800397FFC0E000003F000000067E00FFFC3FF),
    .INIT_13(256'h70F600001F8FF0008003D7DFC0000000478000000E7E00FFFC3FFFFFE00073FE),
    .INIT_14(256'h7F8008003DBCF80000000DF8000000E7F7001FF01FFFFFFFFFFE06C0003F07F0),
    .INIT_15(256'h8F800000007F8000000CFFF8000FFFC000000003FCD80001F07F87004000019C),
    .INIT_16(256'h38000001CFFFC0000001E0DDFE63FE0200001F03F83C00000030E1FC034001DB),
    .INIT_17(256'hFC00003FC30FF3A6787F000001F03F83E6800003060FC034001EB8F900000010),
    .INIT_18(256'h39E000007800001F03F81FF8000030307C014001EB9F120000000B8000001C7F),
    .INIT_19(256'h8300F81F80FDE600230307801C031EB9E7F8000003F000000183FFC0000FC060),
    .INIT_1A(256'h9C038071F038018001B3DE3F2000001E000000381FF8000FF8CE3C01FFF80C7F),
    .INIT_1B(256'hC018001979FC62000001E000000380FFE003FFE8E3FF3FFFF21FFC7E1F80F807),
    .INIT_1C(256'hC40000000E000000780FFE007FFF0F1FFFFFFE5FFFE7E1F807C000FF8FCFFF03),
    .INIT_1D(256'h00001F80FFE007FFF018FFFFFF19FFFFFE3F807C000E1003FFFF3C01A001971F),
    .INIT_1E(256'h003FFF8067FFFFFC7EFFFFE3F807C000E73E3FFFFFC01A0018C3F4C8000008F0),
    .INIT_1F(256'hFFF17F07FFFF7F0C7C0001BFF81FFFFE01A001803FDF00000087800001F807FF),
    .INIT_20(256'hFFF0E7E00084FFF01FFFE01A001837FFE00000083C00003F803FF003FFFFC18F),
    .INIT_21(256'hB3FF80007C018001827FE000000081F00007F003FF003FFFFFE1F01F8D81FFFF),
    .INIT_22(256'h5C001827FC000000001F80007E003FF003FFFFFFE0007F001FFFFFFF1E7E0007),
    .INIT_23(256'h00000009FC0001E001FF001FFFFFC7FFE0000601FFFFF1E7E0003DDFFFFC0180),
    .INIT_24(256'h001E000FF000FFFFE000000000F00FFFFF0F7E0007C6FFFFF00000C00080FFCC),
    .INIT_25(256'h0FFFC0000000007F80FFFFF0F7F0007E07FFFF80000C00081FFDD0000000FF80),
    .INIT_26(256'h000FF01FFFFF0F7F0007FB0FFFFC0018C00081F7CD0000000FFE0001E000FF00),
    .INIT_27(256'hF0F7F0003FEC1FFFE003CD1C083FA5C00000007DE0001E000FF000FFFC000000),
    .INIT_28(256'h661FFF001ED1C087BFFE00000007800001E0007F800FFFC000000201FE01FFFF),
    .INIT_29(256'h1A086BFFE40000003C00003F0007F800FFFC000000001F80FFFFFF0F7F0003FF),
    .INIT_2A(256'h00000FF00043F8003F8003FFC00003E000F81FFFFFF0F7F8001FFBFF0E0008ED),
    .INIT_2B(256'h1FC001F8001FFE000E78003FC3FFFFFF8F7F8001FFCF87FC01EFD0308F3BF8C0),
    .INIT_2C(256'hFFF000600007FC3FFFFFF8F7FE001FFEF9C03FFBDD034CFEBF8C080001FF000E),
    .INIT_2D(256'hFF07FFFFFF8F7FF001FFF3CFE07E1FC06FC7EDF00080001FE000C3FC001FC000),
    .INIT_2E(256'hE7FFE00FFF9E7F8000F907FC5FDF10080003FC000C7FEC00FE000FFF80000000),
    .INIT_2F(256'hF3FE0004987FC5FFF20000C033C00107FFC007E000FFF80000001FC07FFFFFF8),
    .INIT_30(256'hFC5FFF200000261C00703FFC007E000FFF80000003FC07FFFFFFC67FFF80FFFE),
    .INIT_31(256'h0060800F837FE003F000FFFC000000FFE07FFFFFFEF7FFF80FFFE79FFC000D87),
    .INIT_32(256'hFFC03F0007FFFC0000FFFC1FFFFFFFEF7FFFC0FFFF3CFFC000D87BC5FF100000),
    .INIT_33(256'hFFF000FFFFC7FFFFFFFEF7FFF80FFFF1E7F0000D87BC5FF1C30000079801F83B),
    .INIT_34(256'hFFF8001FE7783F007FFFCF3E0000D87BC7FF9F300060FF001F03BFFC03F0003F),
    .INIT_35(256'h81C007FFFC7801C01D87BE7FF97000060FF002F03BFFC03F0001FFFFFC1FFFFF),
    .INIT_36(256'hE00E01D87BC4FF93880000FC00CE03BFFC01F0001FFFFFFFFFFFFFF00000FE6F),
    .INIT_37(256'h6DFD3CC0006F801FE03BFFE01F8001FFFFFFFFFFFFF8000007F0F800003FFFE3),
    .INIT_38(256'hF800FF0377FE00F8000FFFFFFFFFFFFE0600003F0F000001FFFE3F00E01D879D),
    .INIT_39(256'hE00FC000FFFFFFFFFFFFC7F00001FBC000000FFFE1FC0600DC7B979FF0C80027),
    .INIT_3A(256'hFFFFFFFFF1E70C000FFC0000007FFF0FF0700DC7BA79FF8180000F803FF0067F),
    .INIT_3B(256'h63F0003F00003E00FFFC7F8700DC7B2F5FF8180018F803E60047FE00FE0007FF),
    .INIT_3C(256'h037801FFC3F0000DC730F5FE01D001CF003DC006FFE007E0007FFFFFFFFFF830),
    .INIT_3D(256'h80005C730F1FF01FB01EF007F8006FFE003F0001FFFFFFFFC00E0CFF00000000),
    .INIT_3E(256'hFF007F80FE00FF0000FFE003F8001FFFFF000007C09FE000000000B1C000FE3F),
    .INIT_3F(256'h0FE6080FFE003FC0007FFFF00000F011FE00000000190E0007F1FC0C058630F3),
    .INIT_40(256'h01FC000000000000380121C0000000009070007F8FE0E058630B7FF0E3F00FE0),
    .INIT_41(256'h00000F8320180030000004038007DC3E070586217FFF1F3600F001FE4180FFE0),
    .INIT_42(256'h001F8007C0680C0005E3F020D8621FFF1BB1E00F039FB81007FE001F80000000),
    .INIT_43(256'h00E000003F01050621F3F7134F00703FEFC3007FF001F8000000000001E0F600),
    .INIT_44(256'h0050465F9F713C700FE3FDFC3007FF003FC00000000000FC0F40007FFFFFFFC2),
    .INIT_45(256'h13C780F03FFFC7003FF003FE00000000007F01F4000FFFFFFFFE0407000003F8),
    .INIT_46(256'hFC7803FF001FF000000001FFC07F600FC001FDFFE0483C00000F800504F9F8F7),
    .INIT_47(256'hFF800000003FF80FF7BF80000000030281F800003800C04F1F87F13E7C4F87FF),
    .INIT_48(256'hF801FF3F07FFE0000018281FE00003C00C0423FC7F16E6C4FFFFFFC7803FF000),
    .INIT_49(256'hFFF00000F2007F00007E00C0023FF3F36664EF7FFFFC7803FF000FFFFFFFFFFF),
    .INIT_4A(256'h03FFF80FE00C0073AF3F26224E73FFFFC7803FF000FFFFFFFFFFFC013FF803FF),
    .INIT_4B(256'hC00716F3F06030E73FC7FC7C03FF0007FFFFFFFFFE000FFFF7FFFFFFE3FE03A0),
    .INIT_4C(256'h073E737C7FC3E03FF0000FFFFFFF088003FFFFFFC07FFFFFF00E701FFFC0FE00),
    .INIT_4D(256'h8E03FF80007FFFC000000FFFFF7FF801FFFFFFC06F80FFFF8FF01C0071EF3F99),
    .INIT_4E(256'hFFC00000007FFFFDFC000FFFFF8F80FE01FFF8FFC7C0060CF1FD9073A79BFFF8),
    .INIT_4F(256'hFFFFC780007FFFFF0E0FF00FFFFFFC7C0041CF1DE3C3BFB1BF3FFFF03FFE0007),
    .INIT_50(256'hFFFFC071FFE01FFFFFFFC0041CF1FE7E73F79FF87FFF03FFE00000000000000F),
    .INIT_51(256'h803FFFFFFC0041CF1FEFE7BF7DFFFFFFF07FFE00000000000003FFFFFE000001),
    .INIT_52(256'h0498F1FDFCFFD7EFFFFFFF07FFE0000000000001FFFFFFF0181E0FFFF807BFFF),
    .INIT_53(256'hFF733FFFFFF07FFE0000000000003FFFFFFFC1FFF07FFF007FFFFC00FFFFFFC0),
    .INIT_54(256'h07FFE0000000000003FFFFFFFFE7FF87FFF867FFFFE000007FFE00599F1FDF87),
    .INIT_55(256'h0000003FFFFFCFFE3FF8FFFFFFFFFFFF000000FFA00F39F3FFDCFFF3937FFFFF),
    .INIT_56(256'hFC7FFFF03FFFFFFFFFFFF8000003FA00F39E1CCF8FFF78E3FFFFD87FFE000000),
    .INIT_57(256'hFFFFFFFFFFE000003FA0077BE1CC7CFFF7071FFFFF87FFE001F1F3601C03FFFF),
    .INIT_58(256'h000001FA0077BE38F7CFFF687DFFFFF87FFE003FFFFF43C3FFFFFF87FFFF01FF),
    .INIT_59(256'h79E39F3FFFF641FFFFFFC7FFE001FFFFFFE07FFFFFF87FFFFE4FFFFFFFFFFFF8),
    .INIT_5A(256'hE69FFFFFFC7FFF007FFFFFFFFFFFFFFF97FFFFFFFFFFFFFFFFFF8000001FA007),
    .INIT_5B(256'hFFF07FFFFFFFFFFFFFFFF33FFFFFFFFFFFFFFFFFFC000000FA00F72F78637FFF),
    .INIT_5C(256'hFFFFFFFFFF39FFFFFFFFFFFFFFFFFFFC00000FA01F76F7C737CFFF21FFFFFFC7),
    .INIT_5D(256'h9FFFFFFFFFFFFFFFFFFFE000007A01EEFF74FE7EFFE10FFFFFFE7FFF8FFFFFFF),
    .INIT_5E(256'hFFFFFFFFFE000007C01EEFFF1FFFFFF69C7FFFFFE7FFFDFFFFFFFFFFFFFFFFE6),
    .INIT_5F(256'h00007401CD3FF9F31FFF6CCFFFFFFF7FFFDFFFFFFFFFFFFFFFFEC41FFFFFFFFF),
    .INIT_60(256'hFFFDB03FFFACFFFFFFFFFFFFFFFFFFFFFFFFFFFFC8403FFFFFFFFFFFFFFFFFE0),
    .INIT_61(256'h7E07FFFFFFFFFFFFFFFFFFFFFFFFF90003FFFFFFFFFF9FFFFFFE000007401CD3),
    .INIT_62(256'hFFFFFFFFFFFFFFFFFFA0A003FFFFFFFFE1FFFFFFF800007401CA1FFFDF83FFFD),
    .INIT_63(256'hFFFFFFF219000FFFFFFFF0FEFFFFFFC00007401DAF3FFFFE7FFD13E07FFFF1FF),
    .INIT_64(256'h007FFFFFFC0FC7FFFFFE00003001DAF3FFFFC7FFC09F00FFFF1FFFFFFFFFFFFF),
    .INIT_65(256'hF87FFFFFE00003803D2F1FFFFC3FFC78FCEFFFF1FFFFFFFFFFFFFFFFFFFE4090),
    .INIT_66(256'h003801D5FC7FFF07DEC247FEFFFE1FFFFFFFFFFFFFFFFFFFE0010007FFFFFF80),
    .INIT_67(256'hFFF1FCE4143FC1FFE03FFFFFFFFFFFFFFFFFFE80103FFFFFFFFC0007FFFFFFC0),
    .INIT_68(256'hFEFFFE03FFFFFFFFFFFFFFFFFFC8010FFFFFFFFFC0007FFFFFFE000280397FC7),
    .INIT_69(256'hFFFFFFFFFFFFFFFD83F7FFFFFFFFFE2007FFFFFFE0006803AFFCFFFFFFCE0023),
    .INIT_6A(256'hFFFFCFC0FFFFFFFFFFFF813FFFFFFE00068033F8FFFFFFFFE0071FFFFFC03FFF),
    .INIT_6B(256'hFFFFFFFFFE33FFFFFFF00070031F8FFFFFFFFC1EF03FFFF803FFFFFFFFFFFFFF),
    .INIT_6C(256'h3FFFFFFE00010035F0FFFFFFFFC2FF83FFF9803FFFFFFFFFFFFFFFFFFC07FFFF),
    .INIT_6D(256'h10067E1FFFFFFFFCEFF807FE0003FFFFFFFFFFFFFFFFFFFFF9FFFFFFFFFFFFE3),
    .INIT_6E(256'hFFFFDF7F800000001FFFFFFFFFFFFFFFFFFF8003F8001FFFFFFF93FFFFFFE000),
    .INIT_6F(256'h000001FFFFFFFFFFFFFF9FF0000000000007FFFFFC1FFFFFFE080000E3E1FFFF),
    .INIT_70(256'hFFFFFFFFF9FC0000000000001FFFFFE1FFFFFFE080200EBE0FFFFFFFDFF1F800),
    .INIT_71(256'h00000000000000CFFFFFFFFFFFFF1C0201EBC1FBFFFFFCB807E00000000FFFFF),
    .INIT_72(256'h00080FFFFFFFFFFFF1C0003EB81FF0FFFFCFE03400000000FFFFFFFFFFFFFF1F),
    .INIT_73(256'hFFFFFE1C0403EB01FF0FFFFCFFC33800000007FFFFFFFFFFFFF0800000000000),
    .INIT_74(256'h3D700FF89FFFDFFC33C00000007FFFFFFFFFFFFE0000000000000000001FFFFF),
    .INIT_75(256'hCDFFF1DC00000007FFFFFFFFFFFFE00000000000000000007FFFFFFFFFC0C040),
    .INIT_76(256'h00007FFFFFFFFFFFFE0000007C000000000000707FFFFFFC0C0400D602FF81FF),
    .INIT_77(256'hFFFFFFE000060FFFE8200010000200783FFFC0C0C00D406FB81FFE7EE707C000),
    .INIT_78(256'hE1CFFFFFF81FE906200003FFF8080800A4047B87FCFBF8385C00000003FFFFFF),
    .INIT_79(256'hFFFFF600003FFF8080801AC047F833C399F185C00000003FFFFFFFFFFFFF8000),
    .INIT_7A(256'hFFF8081901A8003F831C3E1F805F00000001FFFFFFFFFFFFF8000F987FFFC3C7),
    .INIT_7B(256'h8303C831C1F9FC04F00000001FFFFFFFFFFFFFE008F983E1F00FF0FFFBE00003),
    .INIT_7C(256'hC0604700000000FFFFFFFFFFFFFF01CFF81C06047C070F1C0001FFFF00811032),
    .INIT_7D(256'h000FFFFFFFFFFFFFF80DDF808027F30E2061C0001FFFF008100368607F039C0F),
    .INIT_7E(256'hFFFFFFE0FCF00030FFA3F870120003FFFF010200344607B01C807E4300300000),
    .INIT_7F(256'h003F0FF87F8F0820003FFFF010220284003A00F803FE058040000000FFFFFFFF),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("UPPER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(CASCADEINA),
        .CASCADEINB(CASCADEINB),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED [31:1],DOUTA}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized20
   (p_31_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_31_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_31_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000000000000000000000000000000000003FF000000000000000000000),
    .INITP_01(256'h000000000000000000000000000003FF8000000000000000000000003F000000),
    .INITP_02(256'h0000000000000000007FF8000000000000000000000003F00000000000000000),
    .INITP_03(256'h00000007FF8000000000000000000000003F0000000000000000000000000000),
    .INITP_04(256'h000000000000000000000003F000000000000000000070000000000000000000),
    .INITP_05(256'h000000000000370000000000000000000000000000000000000000000000FFFC),
    .INITP_06(256'h0220000000000000000000000000000000000000000000000FFFE00000000000),
    .INITP_07(256'h00000000000000000000000000000000000001FFFC0000000000000000000000),
    .INITP_08(256'h000000000000000000000000001FFFC000000000000100000000000200000000),
    .INITP_09(256'h0000000000000001FFF800000000000030000000000060000000000000000000),
    .INITP_0A(256'h00003FFF80000000000003800000000006000000000000000000000000000000),
    .INITP_0B(256'h0000000000380000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h8000000000000000000000000000000000000000000000000000000001FF8000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000003),
    .INITP_0E(256'h00000000000000000000000000000000000000000000000000003C0000000000),
    .INITP_0F(256'h000000000000000000000000000000000000000003C000000000080000000000),
    .INIT_00(256'hC8C8C8C8C8C8C8C8C8C8C8C6C6C6A6A6A6A6C6C6C6C8C8C8C8E8E8E8E8E8E8E8),
    .INIT_01(256'hA6A6A6A6A68686A6A6A6A6A6A6A6A6A6A6A6A6A8A8A8C8C8C8C8C8C8C8C8C8C8),
    .INIT_02(256'hC8C80A4E92B5B5B5B5700A0AE8EAEAEAC8C8C8C8C8C8A8A8A8A8A6A6A6A6A6A6),
    .INIT_03(256'hC6C6C8C8C8C8C8C8C8C8C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C8),
    .INIT_04(256'hC8C8C8C8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C6C6),
    .INIT_05(256'hC6A6A6A6A6A6A6A6A6A6846464646464646484848686A6A6A8C8C8C8C8C8C8C8),
    .INIT_06(256'h6666664444646466EECA666284C6E8E8E8E8E8E8E8C8C8C8C8C6C6C8C8C8C8C8),
    .INIT_07(256'h4444444444444444442242444422224466866644868888888866444464664444),
    .INIT_08(256'hEAEA0C0C0C0C0C0CEA864222224222222222222244466666686A8DD1D3D1B16D),
    .INIT_09(256'hC8C6C6A6A6A6A6C6C6C6C8C8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8EA),
    .INIT_0A(256'hA6A6A6A6A6A6A6A8A8A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_0B(256'h0AEAEAEACAC8C8C8C8C8C8C8A8A8A6A8A8A6A6A6A6A6A6A6A68686A6A6A6A6A6),
    .INIT_0C(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C8C8E82C7093B5D7D7D7932C0A),
    .INIT_0D(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6),
    .INIT_0E(256'h64646464646484848686A6A6A8A8A8C8C8C8C8A8A8A8A8A8A8A8A6A6A6A6A6A6),
    .INIT_0F(256'h6284C6C8E8E8E8E8E8E8E8E8E8C8C8C8C8C8C8C8C6C6A6A6A6A6A6A6A6A68684),
    .INIT_10(256'h44422222646666446688888888864444446666646466644444668666CCCC8864),
    .INIT_11(256'h424242222222222244444666688BAFD3B1B1B18F646444444444444444424444),
    .INIT_12(256'hC8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8EAEAEA0A0C0C0C0C0CCA642222),
    .INIT_13(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C6C6A6A6A6A6A6C6C6C6C8),
    .INIT_14(256'hC8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8A8A8C8),
    .INIT_15(256'hA6A6A6A6A6A6C8C8C80A4E93B5D7D7D7D7B5702C0AEAEAEAEACAC8C8C8C8C8C8),
    .INIT_16(256'hA6A6A6A6A6A6A6C6C6C6C6C6C6C6C6C6C6C6A6A6A6A4A6A6A6A6A6A6A6A6A6A6),
    .INIT_17(256'hA8A8A8A8C8C8C8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_18(256'hE8E8E8E8E8C8C8C6C6C6C6C8C8C8C6A6A6A6868464646464646484848686A6A6),
    .INIT_19(256'h66664444446686646466646464868866AACAA864426284A6C8C8E8E8E8E8E8E8),
    .INIT_1A(256'h688DAFD3B1AFB18F666666444444444444444444444222224466664466666686),
    .INIT_1B(256'hE8E8E8E8E8E8EAEAEAEA0A0C0C0C0C0EA8642222424242222220222244444668),
    .INIT_1C(256'hC8C8C8C8C8C8C8C8C8C6C6C6A6A6A6A6C6C6C6C8C8C8C8C8C8E8E8E8E8E8E8E8),
    .INIT_1D(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_1E(256'hD7D7D7F9F9D7934E0AEAEAEAEACAC8C8C8C8C8C8C8C8A8A8A6A6A6A6A6A6A6A6),
    .INIT_1F(256'hC6C6C6C6C6A6A6A6A4A4A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8E8E82C72B5),
    .INIT_20(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6),
    .INIT_21(256'hC8C6C6A6A6A6868464646464646484848686A6A6A8A8A8A8C8C8C8A8A8A8A6A6),
    .INIT_22(256'h6486A888A8AAAA8844224284A6C6C6E8E808080AE8E8E8E8C8C8C6C6C6C6C6C8),
    .INIT_23(256'h4444444444444444444442444444646466666688886444444464866664646466),
    .INIT_24(256'h0C0C0C0EA64222224242422222202244444466686A8DAFD3AFAFB1AF66666666),
    .INIT_25(256'hC6A6A6A6C6C6C6C6C8C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8E8E8EAEAEAEA0A0C),
    .INIT_26(256'hA6A6A6A8A8A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C6C6C6),
    .INIT_27(256'hEAEACACACAC8C8C8C8C8C8C8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_28(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6C6C8E80A70B5D7D7D7D7F9F9D7B54E2C0AEAEA),
    .INIT_29(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6A6A6A6A4A4A6A6),
    .INIT_2A(256'h646484848486A6A6A6A8A8A8A8C8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_2B(256'h84A6C4E6E8E8E8E8E8E8E8E8C8C8C6C6C6C6C6C8C6C6C6A6A686848464646464),
    .INIT_2C(256'h44444444666688AAA88864444242866666666686646688A8AACCCCCC86222062),
    .INIT_2D(256'h22202222224466688B8DAFB18F8FAF8F66666666664444444444444444444444),
    .INIT_2E(256'hC8C8E8E8E8E8E8E8E8E8E8E8E8E8EAEAEAEA0A0CEC0C0C0C8642222242424222),
    .INIT_2F(256'hC8C8C8C8C8C8CACAC8C8C8C8C8C8C8C8C8C6C6C6C6A6A6A6C6C6C6C6C8C8C8C8),
    .INIT_30(256'hA8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8A8A8A8C8C8C8C8C8),
    .INIT_31(256'hA6C8C8EA2C93D7D7D7D7D7D7D7D7D7702C0A0AEAEAEACAC8C8C8C8C8C8C8C8C8),
    .INIT_32(256'hA6A6A6A6A6A6A6A6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_33(256'hA8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_34(256'hC8C8C8C6C6C6C8C8C8C8C8A6A68684646462626464646484848686A6A6A6A8A8),
    .INIT_35(256'h42448686868686A8868688A8AACACCAA8844222062A4A4C6E6E8E8E8E8E8E8E8),
    .INIT_36(256'h6D8D8F8F44666666664444444444444444444444444464668888888888666444),
    .INIT_37(256'hE8E8EAEAEAEA0AEAECEC0EEC644222424242422222222222224446688DAFD1AF),
    .INIT_38(256'hC8C8C8C8C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8),
    .INIT_39(256'hA6A6A6A6A6A6A6A6A6A6A8A8A8A8A8C8C8C8C8C8C8C8C8C8C8C8EAEACAC8C8C8),
    .INIT_3A(256'hD7D7D7924E0AEAEAEAC8C8C8C8C8C8C8C8C6A6A6A8A8A8A8A8A8A8A8A6A6A6A6),
    .INIT_3B(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8C8E80A70B5D7D7D7D7D7D7),
    .INIT_3C(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_3D(256'hA68484646242426264646464848686A6A6A6A6A8A8A8A8A8A8A8A6A6A6A6A6A6),
    .INIT_3E(256'hCACACACCAA6642204062A4A6C6C6C8E8C8C8E8E8E8E8E8C8C8C8C8C8C8C8C8A6),
    .INIT_3F(256'h44444444444444444444644466666666666664646466A888866686A88886A8CA),
    .INIT_40(256'h6442224242422222222242444444466A8DAFB18F8D8F8F8F4466666666664444),
    .INIT_41(256'hC6C6C6C6C6C8C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8E8EAEAEAEAEAEAECEC0EEA),
    .INIT_42(256'hA8A8A8C8C8C8C8C8C8C8C8C8C8EAEC0CEAC8C8C8C8C6C6C6C6C6C6C8C8C6C6C6),
    .INIT_43(256'hC6C6C6C6A6A6A6A6A6A6A6A6A6A6A8A8A8A6A6A6A6A8A8A8A8A8A6A6A6A6A6A8),
    .INIT_44(256'hA6A6A6A6A6A6A6A6A8C8EA2C92B5B5D7D7D7D7D5D5D5D5902C0AE8E8C8C8C8C6),
    .INIT_45(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_46(256'h848686A6A6A6A6A8A8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_47(256'hA4A6C6C6C6C6C8E8C8E8C8C8C8C8C8C8C6A6A6A6A68484624220424262646464),
    .INIT_48(256'h666666644464666444648686866686A8A888A8AACAAAAACCAA684422202084A4),
    .INIT_49(256'h4446688DAFAF8F8F8FAFB18F4466666666444444444444444444444444444444),
    .INIT_4A(256'hE8E8E8E8E8E8E8E8E8E8EAEAEAEAEAEAEC0C0ECA644242424222222222224244),
    .INIT_4B(256'hC8EA0C0CECC8C8C8C8C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8),
    .INIT_4C(256'hA6A6A6A6A6A8A8A8A8A8A8A8A8A6A6A6A6A6A6A6A6A8A8C8C8C8C8C8C8C8C8C8),
    .INIT_4D(256'h92B5B5B5B5B3B2B2B292906E2AE8C6C6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_4E(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A686868686A6A6A6A6A6A6A6A6A8C8EA4E),
    .INIT_4F(256'hA8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_50(256'hC6A6A6A6A6A6A6A684846442202020224264646484848686A6A6A6A8A8A8A8A8),
    .INIT_51(256'h666686A8A8A88888AA8888AA88664442202042628484A4A6A6C6C6C8C6C6C8C6),
    .INIT_52(256'h4444444444444444444444444444444444444444646666444444666442426466),
    .INIT_53(256'hEAEAEAECEC0C0EA844424242422222222222444444468AAFAF8F8F8FAFB1B1B1),
    .INIT_54(256'hA6A6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8EAEA),
    .INIT_55(256'hA6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8EA0E2E0CEAC8C8C8C6C6C6),
    .INIT_56(256'h08C6C6C6A4A4A6A4A4A4A4A4A4A4A4A4A4A4A4A6A6A6A6A6A6A6C6C6C8C6A6A6),
    .INIT_57(256'hA6A6A6868686868686A6A6A6A6A6A6A6A6C80A4E70929290906E6E6C4C4C2C2A),
    .INIT_58(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_59(256'h200000224242646484848686A6A6A6A6A8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6),
    .INIT_5A(256'h6664666422000042626284A4A4A6C6C6C6C6C6A6A6A6A6A6A684868484644220),
    .INIT_5B(256'h44444444444444444466666444444444424244646686A8AAAAA8886486668688),
    .INIT_5C(256'h422222222222424444468DB1AF8F8F8FAFB1B3B1444444444444442222444444),
    .INIT_5D(256'hC6C6C6C6C8C8C8C8E8E8E8E8E8E8E8E8E8E8EAEAEAEAEAECECECEC8642224242),
    .INIT_5E(256'hA6A6A6C6C8C8C8C8C8EA2E2E2EEAC8C8C8C6C6A6A6A6A6C6C6C6C6C6C6A6C6C6),
    .INIT_5F(256'hA4A4A4A4A4A4A4A4A4A4A4A4A6A6A6A6A6A6A6A6A6A6A6A6A4A4A6A6A6A6A6A6),
    .INIT_60(256'hA6A6A6A6A6C8EA2C4E2C2C2C2A08080806E6E6E6C6C4A4A4A4A4A4A4A4A4A4A4),
    .INIT_61(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A68686868686868686A6A6),
    .INIT_62(256'h86A6A6A6A6A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_63(256'h8484A4A6A4A4A6A6A48484848484848464424020000000024242646464848686),
    .INIT_64(256'h44444444446444646686AAA8A8A8864264668686866666442200002020428284),
    .INIT_65(256'hAF8F8FAFB1D3D3B1444444444444442222224444444444444444422244646666),
    .INIT_66(256'hE8E8E8E8E8E8E8EAEAEAEAECECECEC644222224242222222222244444668AFAF),
    .INIT_67(256'h2EECC8C8C8C6C6A6A6A6A6A6A6C6C6C6C6A6C6C6C6C6C6C8C8C8C8C8C8E8E8E8),
    .INIT_68(256'hA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A6A6A6A6A6A6C6C6C8C8C8C8EA2E30),
    .INIT_69(256'hE6C6E4C4C4C4A4C4C4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4),
    .INIT_6A(256'hA6A6A6A6A6A6A6A6A6868684848484868686A6A6A6A6A6A6A6C6E8EAE8E8E6E6),
    .INIT_6B(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_6C(256'h646464644242200000000000224244646464868686A6A6A6A6A8A8A8A8A6A6A6),
    .INIT_6D(256'h8686864244646464666664444420000020206262628484848484848484848484),
    .INIT_6E(256'h444444442222444444444444444444224444646644446444446464666686A888),
    .INIT_6F(256'hECECCA64422222224222222222224446466AAFAFAF8F8FB1B1B3B18F44444444),
    .INIT_70(256'hA6C6C6C6C6C6A6C6C6C6C8C8C8C8C8C8C8E8E8E8E8E8E8E8E8E8E8EAEAEAEAEC),
    .INIT_71(256'hA4A4A4A4A4A4A4A4A6A6A6A6C6C6C8C8C8EA2E2E2E0CCAC8C8C6A6A6A6A6A6A6),
    .INIT_72(256'hA2A2A4A4A4A4A4A4A4A4A4A4A2A2A2A2A2A2A2A4A4A4A4A4A4A4A4A4A4A4A4A4),
    .INIT_73(256'h8484848484868686868484A6A4A6A6A6A4A4A4A4A4A4A4A2A2A2A2A2A2A2A2A2),
    .INIT_74(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A686848484),
    .INIT_75(256'h2242426464648486868686A6A6A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_76(256'h4422000000202042426262626282828282626262624242422220000000000000),
    .INIT_77(256'h4444444244444444444466644464666666668886666464444242444466666464),
    .INIT_78(256'h22224446668DAFAFAFAF8FB1B1B1B18F44444444444444444444444444444444),
    .INIT_79(256'hC8C8C8C8C8E8E8E8E8E8E8E8E8E8E8EAEAEAEAEC0CECA8424220222222222222),
    .INIT_7A(256'hA6A6C6C6C8E80C2E2E0CCAC8C8C8A6A6A6A6A6A6A6C6C6C6C6C6A6A6C6C6C8C8),
    .INIT_7B(256'h828282828282A2A2A28282A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A6),
    .INIT_7C(256'h84848484828282828282828282828282828282828282828282828282828282A2),
    .INIT_7D(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A686848484848484848484848484848484),
    .INIT_7E(256'hA6A8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_7F(256'h4242626262424242422020200000000000000000202242446464648486868686),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_31_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_31_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized21
   (p_27_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_27_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_27_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000800000000018000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000001800000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000100000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000010000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000200000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000010000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000001800800000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h6666888664646666644444442222224444646666442222000000002020404242),
    .INIT_01(256'hB1B3B1B144444444442244444444444444444444444442424244444444446466),
    .INIT_02(256'hE8E8E8EAEAEAEA0C0CEA864220222222222222222242446668ADAFAF8F8FAFB1),
    .INIT_03(256'hC8C8C6A6A6A484A6A6A6C6C6C6C6A6C6C6C6C8C8C8C8C8C8C8E8E8E8E8E8E8E8),
    .INIT_04(256'hA2A2A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A6A6A6A6C6E8EA0CEACAC8),
    .INIT_05(256'h828282828282828282828282828282828282A28282828282828282A282828282),
    .INIT_06(256'hA6A6A6A684848484848484846464646262626262626262628282828282828282),
    .INIT_07(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_08(256'h0000000000000000002042446464648486868686A6A8A8A8A8A8A8A8A8A8A8A6),
    .INIT_09(256'h2222222242426666644244220000000000002020202020202020202000000000),
    .INIT_0A(256'h2222224444444444444442224244444444444466666688866442446444424242),
    .INIT_0B(256'h2022422222222222224244668AADAF8F8FAFB1B3B3D3B18F6444444444224444),
    .INIT_0C(256'hC6C6C6C6C6C6C8C8C8C8C8C8C8E8E8E8E8E8E8E8C8E8E8EAEAEAEA0C0CCA6442),
    .INIT_0D(256'hA4A4A4A4A4A4A4A4A4A4A4A6A6A6C6C8E8C8C8C8A6A6C8A6A6848484A6A6A6C6),
    .INIT_0E(256'h82828282828282828282828282828282A2A2A2A2A2A2A2A2A4A4A4A4A4A4A4A4),
    .INIT_0F(256'h6462626262626262626262626262828282828282828282828282828282828282),
    .INIT_10(256'hA6A6A6A6A6A6C6C6C6C6C6C6C6C6C6C6C6A6A6A6A6A6A6868464648484646464),
    .INIT_11(256'h6464648486868686A6A6A6A6A6A8A8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_12(256'h2200000000000000000000000000000000000000000000000000000000202242),
    .INIT_13(256'h2242444444444466666686886644444444444222224222222022446686662222),
    .INIT_14(256'h8A8DAF8FAFB1D3D3B3B3B18F6644444444224444222222222244444444444442),
    .INIT_15(256'hC8E8E8E8E8E8E8C8C8C8E8EAEAEAEA0CECA84242222242222222222222224266),
    .INIT_16(256'hA4A4A6A6C6C6C6A6A6A6A8A6A6848484A6A6A6A6C6C6C6C6C6C6C8C8C8C8C8C8),
    .INIT_17(256'h82828282A2A2A2A2A2A2A2A2A2A4A2A2A2A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4),
    .INIT_18(256'h6262626262626262828282828282828282828282828280808080828282828282),
    .INIT_19(256'hC6C6C6C6C6A6A6A6A68684848464626262624242424242424242424240406262),
    .INIT_1A(256'hA6A6A8A8A8A8A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C6),
    .INIT_1B(256'h0000000000000000000000000000000000002042446464868686868686A6A6A6),
    .INIT_1C(256'h6644446444424444444222202022426688884444242200000000000000000000),
    .INIT_1D(256'h6644444444424442222222224242424464644444444444424444444444648686),
    .INIT_1E(256'hEAEAEC0CEAA842222222222222222222222244668A8D8F8FB1D3D3D3B3B3B18F),
    .INIT_1F(256'hA686848486A6A6A6C6C6C6C6C6C6C8C8C8C8C8C8C8E8E8E8EAEAE8C8C8C8C8EA),
    .INIT_20(256'hA2A2A2A2A2A2A2A2A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A6A6A6A6A6A6A6A6),
    .INIT_21(256'h626060606060606060608080808080828282828282A2A2A2A2A2A2A2A2A2A2A2),
    .INIT_22(256'h6462626242422220202040404242424242424262626262626262626282828282),
    .INIT_23(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6C6C6C6C6C6C6C6C6C6C6C6C6A6A6A6A6868484),
    .INIT_24(256'h0000000000002022426464868686868686A6A6A6A6A6A6A6A6A8A8A8A6A6A6A6),
    .INIT_25(256'h2020426686666666442202000000000000000000000000000000000000000000),
    .INIT_26(256'h4222224264644444444444424222424242668886644444444244446444444222),
    .INIT_27(256'h22222222222244688BAF8FB1B1B3D3D3B3B1B1B1644444444442424222222222),
    .INIT_28(256'hC6C6C8C8C8C8C8C8C8E8E8E8EAEAE8C8C8C8C8EAEAEAECECCA86422022222222),
    .INIT_29(256'hA2A4A4A4A4A4A4A48484848484A4A6A6A6A6A6A6A684848484A6A6A6C6C6C6C6),
    .INIT_2A(256'h80828282828282A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2),
    .INIT_2B(256'h4242424242426262626262626262828282828282826260606060606262606080),
    .INIT_2C(256'hC6C6C6C6C6C6C6C6C6C6C6C6C6A6A6A6A6868464626242424220200000202040),
    .INIT_2D(256'h868686868686A6A6A6A6A6A6A6A6A8A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000002242446464),
    .INIT_2F(256'h4222222222648686666444424244644444444442222042444444666644222200),
    .INIT_30(256'hB3B3B3D3D3B18FB1664442444422224222202222222222424444444444444444),
    .INIT_31(256'hEAEAC8C8C8C8C8EAEAEAECECC8644220224242222222222222426688ADAF8FB1),
    .INIT_32(256'h8284848484868686868484848484A6A6C6C6C6C6C6C6C8C8C8C8C8C8C8C8E8E8),
    .INIT_33(256'hA2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A4A4A4A4A4A482848282),
    .INIT_34(256'h6284848484828282828282828282826262628282828282828282A2A2A2A2A2A2),
    .INIT_35(256'hC6A6A6A6A6868464624242222000000000002020424242426262626262626262),
    .INIT_36(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C6C6C6C6C6C6C6C6C6C6C6),
    .INIT_37(256'h0000000000000000000000000000002042446464648484868686A6A6A6A6A6A6),
    .INIT_38(256'h4244442222444444422222222244444444222200000000000000000000000000),
    .INIT_39(256'h6422424422202020222222224444444444444242422222222242648666644442),
    .INIT_3A(256'hA844422022422222222222222244668AADAFB1B3B3B3B3B3B1918FD366444444),
    .INIT_3B(256'h8484A6A6A6C6C6C6C6C6C8C8C8C8C8C8C8C8E8E8EAEAE8C8C8C8C8EAEAEAECEC),
    .INIT_3C(256'hA2A2A2A2A2A2A2A2A2A2A2A2A2A4A48282626262626282828484848484848484),
    .INIT_3D(256'h84A484848482828282828282828282A2A2A282A2A2A2A2A2A2A2A2A2A2A2A2A2),
    .INIT_3E(256'h200000000000202042424242626262626262626484A6A6A6A684828284848284),
    .INIT_3F(256'hA6A6A6A6A6A6A6A6C8C8C6C6C6C6C6C6C6C6C6C6C6A6A6A6A686846462424220),
    .INIT_40(256'h0000002022446464646484868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_41(256'h2244224444422222200000000000000000000000000000000000000000000000),
    .INIT_42(256'h4244444444222222224244442222426464444242424242222222444444222022),
    .INIT_43(256'h2244688B8DAFB3B3B3B3B3D3B18F91B386644444642244442222202022224242),
    .INIT_44(256'hC8C8C8C8C8C8E8E8EAE8E8C8C8C8C8EAEAEA0CCA864222222222222222222222),
    .INIT_45(256'h8282828262402020404262626262646464646484848484A6A6A6C6C6C6C8C8C8),
    .INIT_46(256'hA6A4A4A4A4A28282A2A2A2A4A4A4A4A4A4A4A4A4A4A2A2A4828282A2A2A4A4A4),
    .INIT_47(256'h646464646262628484A6C8A8A8868484848484848484848484848484A4A4A6A6),
    .INIT_48(256'hC8C8C8C8C6C6C6C8C6A6A6A6A686846464624240200000000000204042424242),
    .INIT_49(256'h848686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000002242646464648484),
    .INIT_4B(256'h4442424242424244444442422222224242222020224422444442222222200000),
    .INIT_4C(256'hB191B1B388664444442242422222222222224222222242644442222222224444),
    .INIT_4D(256'hC8C8C8EAEAECECC86422222222222222222222222446688BAFB1D3B3B3D5B3D3),
    .INIT_4E(256'h4242626262626264648484A6A6A6C6C6C6C8C8C8C8C8C8C8C8C8E8E8E8E8E8C8),
    .INIT_4F(256'hA6C6C6C6C4A4A4A4A4A4A4A4A484A4A4A4C6C6A4828482624020202020424242),
    .INIT_50(256'hC8A88484848486A6A6A6A684A48484A6A6A8C8C8C8C8C8A6A4A482A2A2A4A4A6),
    .INIT_51(256'hA6868484846462422000000000002042424242628486866464626484A6A8CACA),
    .INIT_52(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C6C8C8C8C8C8C8C8C8C6C6C8C8C8A6A6A6),
    .INIT_53(256'h000000000000000000000000002244646464848484868686A6A6A6A6A6A6A6A6),
    .INIT_54(256'h4222222222222020224222424242422222200000002000000000000000000000),
    .INIT_55(256'h2222222222224222222242644442222222224244444442422222224444444444),
    .INIT_56(256'h22222222222222224446688BAFB1D3B3B3D3B3B1B1B1B1B38866644444422222),
    .INIT_57(256'hA6C6C6C8C8C8C8C8C8C8C8C8C8E8E8E8E8E8E8C8C8C8CAEAEAECEAA644222042),
    .INIT_58(256'hA6A4A4A4C6C8C8A68484844220202020204042424242424242426264648484A6),
    .INIT_59(256'hA684A4A6C8CAEAEAECECEAC8C6A6A4A4A4A4C6C8C8E8E8C8C6C6A4A6C6C6C6C6),
    .INIT_5A(256'h000022426262426284A6A68684646484A6C8CACACACAA68484A6A8C8C8C8C8A6),
    .INIT_5B(256'hA6A6A6C6C8C8C8C8C8C8C8C8C8C8C8C8C8A6A6A6A6A686868684646242200000),
    .INIT_5C(256'h00224464646464848484868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_5D(256'h4242444222000000002000000000000000000000000000000000000000000000),
    .INIT_5E(256'h4444222222222242444444444222224244444442424222222220202022422222),
    .INIT_5F(256'hAFD3D3B3B3B1918FB1B3D3D38666444442442222222222202222422222224244),
    .INIT_60(256'hC8E8E8E8E8E8C8C8C8C8CAEAEAECCA644220204222222222222222224468486B),
    .INIT_61(256'h00002020202040424242424040426264648484A6A6C6C8C8C8C8C8C8C8C8C8C8),
    .INIT_62(256'hC8C8A6A6C6C8C8EAEAECECEAE8C8A6C6C8C8C8C8C8A6A6A6C8EACAA684866220),
    .INIT_63(256'h86848484A6C8CAECCCCAC8A686A8CAEAEAECEAC8A8A6A6A8CAEAECECECECECEA),
    .INIT_64(256'hC8C8C8C8C8A6A6A6A6A6A6A6A686846242422000000022426462426286A8A886),
    .INIT_65(256'h868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8),
    .INIT_66(256'h0000000000000000000000000000000000000000002242446464646484848686),
    .INIT_67(256'h4442222222222222224242222222202222222222224244222220000000000000),
    .INIT_68(256'h8666444422442222222222222222424442222242444222222222222242444444),
    .INIT_69(256'hEAECA864222222222222222222222224468A6A6B8FD3D3D3B18F8F91B3D3D3B3),
    .INIT_6A(256'h424264646484A6A6A6C8C8C8C8C8C8C8C8C8C8C8E8E8E8EAE8E8C8C8C8C8EAEA),
    .INIT_6B(256'hEAC8C8C8EAEAEAEAC8A6A6C8EAECCA8686864200000020202020204242424240),
    .INIT_6C(256'hA8C8EAECECECECECCAA8A8C8ECECECECECEEECECEAC8A6A6C8EAEAECECECECEC),
    .INIT_6D(256'hA686848464624220000022426464626486A8A8A8A6848486A8CACAECECECEAA8),
    .INIT_6E(256'hA6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8C8C8C8A6A6A6A6A6A8),
    .INIT_6F(256'h000000000000000000002242646464646484848686868686A6A6A6A6A6A6A6A6),
    .INIT_70(256'h2222222222222222222222222222222000000000002222220000000000000000),
    .INIT_71(256'h2222224244422242422222222222202222424444444444224242222222424242),
    .INIT_72(256'h22222224668A8D8B8DB1D3D3B18F8FB3D3D3D3B3666644442222422222222222),
    .INIT_73(256'hC8C8C8C8C8C8C8C8E8E8EAEAE8E8C8C8C8C8EAEAEACA86422222222222222222),
    .INIT_74(256'hECECCAA8A8A84400000020202020404242424242426264848484A6A6A6C8C8C8),
    .INIT_75(256'hECECECECEEECEE0EECCAA8C8CAECECECECECECECECEAC8EAECECECECCAA8A8CA),
    .INIT_76(256'h6464646486A8A8A8A88686A6A8CACCCCECECEAC8A8CAECECECECECECEACACACA),
    .INIT_77(256'hC6C8C8C8C8C8C8C8C8C8C8C8C8C8A6A6A6A6A6A8A8A686868484644222204242),
    .INIT_78(256'h426464646464848484868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_79(256'h2222222200000000202222222222220000000000000000000000000000002242),
    .INIT_7A(256'h2220202222224244444444444444422222222222222222224222222222222222),
    .INIT_7B(256'hB3B1B1D3D3D3D3B3668666444422222222222222222222224444424442222222),
    .INIT_7C(256'hE8E8C8C8C8C8EAEAEAC8642222222222222222222222224468ADAD8B6B8FB1D3),
    .INIT_7D(256'h40404242626262626264848484A6A6A6C6C8C8C8C8C8C8C8C8C8C8C8E8EAEAEA),
    .INIT_7E(256'hEAECECECECECECEC0CEAEAEAECECEEEEEAC8C8EAECECCAA8CAA8440000002020),
    .INIT_7F(256'hA8CACCCCCCECCACACACAECECECECECECECCACAECECECECECECECEC0E0EECC8CA),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_27_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_27_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized22
   (p_23_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_23_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_23_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000018018),
    .INITP_02(256'h000000000000000000000000000000000000000000000000F001800000000000),
    .INITP_03(256'h0000000000000000000000000000000000000381F81000000000000000000000),
    .INITP_04(256'h0000000000000000000000000018030000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h000003FFF8000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h00000000000000000000000000000000000000000000000000000000007FFFFE),
    .INITP_0F(256'h00000000000000000000000000000000000000000000000FFFFFF80000000000),
    .INIT_00(256'hC8C8A6A6A6A6A8A8A8A6A6A6A6868464624242626464646486A8A8A8A8A8A6A8),
    .INIT_01(256'hA6A6A6A6A6A6C8C8C8C8C8A6A6A6A6A6A6A6A6A6C6C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_02(256'h2222220000000000000000000000000000002022426464646464648484868686),
    .INIT_03(256'h4444422222222222224222424222422222222222222242222220002020202222),
    .INIT_04(256'h4422222222222242222222224244444442222222222222222222224244444444),
    .INIT_05(256'h22222220222222222222244668ADAD8D6B8DB1B1D3D3D3D3D3D3B3B166A88866),
    .INIT_06(256'h84A6A6A6C8C8C8C8C8C8C8C8C8C8C8C8E8EAEAEAE8E8C8C8C8CAEAEAEAA84220),
    .INIT_07(256'hECEEEEEEECCACAECECECCACACAA8440000002040404062626264646484848484),
    .INIT_08(256'hECEEEEECECCACAECECECECEEECECEC0E0EECCACAECECECECECECEE0E0CECEAEC),
    .INIT_09(256'hA6A6A68484626262646464648686A8A8A8A8A8A8AACACACCCCCCCACACACAECEC),
    .INIT_0A(256'hA6A6A6A6A6A6A6A6A6C6C8C8C8C8C8C8C8C8C8C8C8C8A6A6A6A6A8A8A8A6A6A6),
    .INIT_0B(256'h000000000000002242446464646464648484868686A6A6A6A6A6C8C8C8C8C8C8),
    .INIT_0C(256'h4222422222222222222242442222202020202222222222220000000000000000),
    .INIT_0D(256'h2242446442222222222222222020202242444444424242424222222222424242),
    .INIT_0E(256'h8A8DADAD8D8DB1B1B1D3D3D3B3B1B1B186AACAA8644222222222224242222222),
    .INIT_0F(256'hC8C8C8E8E8EAEAEAE8E8C8C8C8EAEAEACA862220222222202222222222224446),
    .INIT_10(256'hCA86420000002040406262626464848484848486A6A6A6A6C8C8C8C8C8C8C8C8),
    .INIT_11(256'h0E0E0E0EECECCACAECECECECECEEEE0E0CECEAECEEEEEEEEECEACAECECECCACA),
    .INIT_12(256'h64868688A8A8A6A8A8CACACACCCCCCCACACAECECECECECEEECECCAECECECEEEE),
    .INIT_13(256'hC8C8C8C8C8C8C8C8C8C8A6A6A8A8A8A8A6A6A6A6A6A6A6A48484826264646262),
    .INIT_14(256'h646464648484868686A6A6A6A6A6A6A8A8A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8),
    .INIT_15(256'h4422222020202022222222222222000000000000000000000000002042426464),
    .INIT_16(256'h2020002022424244424242444442222222422242422242424222222222224244),
    .INIT_17(256'h9191B1B366AACCAA644422222220222242222220222244644222222222222220),
    .INIT_18(256'hC8EAEAEACA4422222242222222222242422222466A8DAFAFAF8D8DAFD1D39191),
    .INIT_19(256'h64648486868686A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8E8E8EAEAEAEAC8C8E8E8),
    .INIT_1A(256'h0C0C0E0E0CECECECECEEEE0EECECEAECECECCAC8CA6622000000204262628282),
    .INIT_1B(256'hCACACACACACCECECECECECECECCCCACCECECECECECEE0E0E0EECCAEAECECEC0E),
    .INIT_1C(256'hA8A8A8A8A8A8A6A6A6A6A6A484848484826262426486868686868686A8CACACA),
    .INIT_1D(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8C8A8A8),
    .INIT_1E(256'h2222220000000000000000000000000022424464646464646484848686A6A6A6),
    .INIT_1F(256'h4242222222222222222222222222222222424444422220202020202022222242),
    .INIT_20(256'h2222222242422222222242444222222222222020222020202242424242222242),
    .INIT_21(256'h22222242422224468B8DAFD1AF8D8DAFB1B1B1B1B1B1B3D36666888864664442),
    .INIT_22(256'hC8C8C8C8C8C8C8C8C8C8E8EAEAEAEAEAC8C8E8C8C8EAEACA8642222222222222),
    .INIT_23(256'hECECCCECECECCAA8A8642000002042426282828284848486A686A6A6A6A6A6C8),
    .INIT_24(256'hECCCCACAECECECECECECEE0E0EECCAEAECECECECECEC0C0EECECECECEEEEEEEE),
    .INIT_25(256'hA484848484826262628486868664646486A8CACACACACAAACACACCECECECECEC),
    .INIT_26(256'hA6A6A6A6A6A6A8C8C8C8C8C8C8C8C8C8C8C8A8A8A8A8A8A8A8A8A8A6A6A6A6A4),
    .INIT_27(256'h000000002242446464646464648484868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_28(256'h2222222222224244442222202020202222222222222222220000000000000000),
    .INIT_29(256'h2222222222222222222020202222222222222242424222222222222222222222),
    .INIT_2A(256'hAFAFAF8FAFB1B1D3B3B3B3D56666666644646444222222224242224242222242),
    .INIT_2B(256'hEAEAEAEAC8C8C8C8C8EAEAA8642222222222222222222242222244668DAFB1B1),
    .INIT_2C(256'h204042628282848484848686A6A6A6A6A6A6C6C8C8C8C8C8C8C8C8C8C8C8E8EA),
    .INIT_2D(256'hEEECCACAECECECECECECECECECECECECEEEEECECECECCCECECCAAAA886420000),
    .INIT_2E(256'h6462626486A8A8A8CACAA8A8A8CACACCECECECECECCAC8CAECECECECECECECEE),
    .INIT_2F(256'hC8C8C8C8C8C8C8C8A8A8A8A8A8C8A8A6A6A6A6A6A4A4A4A4A484828282848484),
    .INIT_30(256'h64648484848686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8C8C8C8C8),
    .INIT_31(256'h2020222222222022222222220000000000000000000000000022424464646464),
    .INIT_32(256'h2022222222222242422222222222222222222222224242222222224244444222),
    .INIT_33(256'h6666666644446644222222224242224242222222222222222220222222202020),
    .INIT_34(256'h42202222222222222222444222424466ADAFAFAFAFD1D1AF8F8FB1D3D3B3B3D3),
    .INIT_35(256'hA6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8E8EAEAEAEAEAEAC8EAC8C8EAEAEAA6),
    .INIT_36(256'hECCAECECEEEEECECECCCCACCCCCAA886662220204062628282848484848686A6),
    .INIT_37(256'h86A8C8CACACACAECCAA8A8A8CAECECECECECECECECECCACAECECECECECECECEC),
    .INIT_38(256'hC8C8C8A8A6A6A6A6A6A4A4A4A4A4A484848484826262628486A6A6A6A6A8A686),
    .INIT_39(256'hA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_3A(256'h22200000000000000000000000224242424464646464646484848686A6A6A6A6),
    .INIT_3B(256'h2222222222202222224244422222222244444222222222222222222020222222),
    .INIT_3C(256'h4244424242222222222222224222222222202020202020202022222222222242),
    .INIT_3D(256'h22444446ADAF8FAFB1D3D1B1B1B1B1D3D3D3D3D5666666644444666422222222),
    .INIT_3E(256'hC8C8C8C8C8EAEAEAEAEAEAEAEAEAE8C8EAEACA86202022222222222222224442),
    .INIT_3F(256'hCAA886644220204062628284848484A4A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8),
    .INIT_40(256'hCACACACAECECECECECCAA8CACAECECECECECECECCACACAECECECECCCCACACACA),
    .INIT_41(256'hA4A4A4A4A4A4A28282828484A4A48484848484628484A6C8C8C8C8CAC8A686A8),
    .INIT_42(256'hA6A6A6A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A8A8A6A6A6A6A6A6A4),
    .INIT_43(256'h0020224242424464646464648484848686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_44(256'h2222222222222242424222222222222020222222222222200000000000000000),
    .INIT_45(256'h4222222222202020202020202020202222222242424442222222222222424444),
    .INIT_46(256'hB1B1B1D3D3D3D5D5444444444444644422222222444442422242422222222222),
    .INIT_47(256'hEAEAEAEAEAEAA864202222222222222222222222224444488DAF8FB1D3D3B3B1),
    .INIT_48(256'h8484A4A6A6A6A6A6A6A6A6A6A6C6C8C8C8C8C8C8C8C8C8C8E8EAEAEAEAEAEAEA),
    .INIT_49(256'hA8C8CACACACACAC8A8A8CACACACACACAA8A8A6C8A886644240404062828282A4),
    .INIT_4A(256'hA4A4A4A2828282828284A4A4A4A4848486848486868688A8C8C8C8C8C8A686A6),
    .INIT_4B(256'hC8C8C8C8C8C8C8C8C8C8C8A8A8A8A6A6A6A6A6A6A6A6A6A4A4A4C4C4A4A4A4A4),
    .INIT_4C(256'h8484848486A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8C8C8C8C8C8C8C8C8),
    .INIT_4D(256'h4242442220202022222222200000000000000000002022424242444464646464),
    .INIT_4E(256'h0000202022222242424444422222424222222222222222222222222242424242),
    .INIT_4F(256'h4444666444422242444442222242422242222222422222222220202020202020),
    .INIT_50(256'h2222222222222222222444688DAFB1B1B1D3D3B3B3B1B1B1B3B3B3D388664444),
    .INIT_51(256'hC8C6C8C8C8C8C8C8C8E8E8EAEAEAEAEAEAEAEAEAEAEAEAEAEAEA864220222222),
    .INIT_52(256'hA8A8A8A6A68484A6A68464626062828282A2A2A4A4A4A6A6A6A8A8A6A6A6A6A6),
    .INIT_53(256'h82828282A4A4A484848484A6A6A6A6A6A6A684A6A6A6A8A8A8A8A6A6A6A6A6A8),
    .INIT_54(256'hC8C8A8A8A6A6A6A6A6A6A6A4A4C4C4C4C4C4C4C4C4C4C4C2C2C2C4A2A2A4A4A2),
    .INIT_55(256'hA6A6A6A6A6A6A6A6A6A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_56(256'h0000000000000000002022424242444444646464848484848686A6A6A6A6A6A6),
    .INIT_57(256'h2222424242222222202020202022202022224242444464422222222222222222),
    .INIT_58(256'h2242444242222222222222222220202020202020000000202022222242444442),
    .INIT_59(256'hADAFD1D3B3B3B3B3B3B1B1B1B3B3B3B388664444424466664442224244442222),
    .INIT_5A(256'hEAEAEAEAEAEAEAEAEAEAEAEAEACA862220222222222222222222222222224468),
    .INIT_5B(256'h6282A2A2A2A2A2A4A4A6A6A8A8A8A8A8A8A8A8C8C8C6C8C8C8C8C8C8C8E8E8EA),
    .INIT_5C(256'hA4A4A4A4A4A484A4A6A6A6A6A6A6A6A6A6A6A6A48484A6A6A48484A4A4848482),
    .INIT_5D(256'hA4C4C6E4E4E4E4E4E4E4E4E4E4E4E4C4C4C4C4C4A4A4A2A2A2A2A2A4A4A48284),
    .INIT_5E(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A8A6A6A6A6A6A6A4),
    .INIT_5F(256'h424242424444646486868686868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A8),
    .INIT_60(256'h2022222020202222424464444242444442424222222242444222200000202222),
    .INIT_61(256'h2222222020202000000000000020222222424242222242422222222222222020),
    .INIT_62(256'hB3B3B3B388664444424486664444424464644222202244444222222220222222),
    .INIT_63(256'hEACA642222222222222222222222222222224468ADB1D3D3D3B1B1B3B3B1D1B1),
    .INIT_64(256'hA8A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8E8EAEAEAEAEAEAEAEAEAEAEAEAEAEA),
    .INIT_65(256'hA4A4A4A4A4A4A4A2A2A2A4A4A4A4A2A2A2A2828282A2A2A2A2A4A4A4A4A6A6A8),
    .INIT_66(256'h0604040404E4E4E4E4E4E4C2C2C2A2C2C4A2A2A2A2A2A2A2A4A4A2A4A4A4A4A4),
    .INIT_67(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8A8A6A8A8A6A6A6C6E808080606060604040606),
    .INIT_68(256'h86868686A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_69(256'h4244444444424242424444646444444242222222224242424244648486868686),
    .INIT_6A(256'h0000202222222222222222222222222222222222222242222220002022224242),
    .INIT_6B(256'h4444424466664422224244442222222220222222222222202020200000202020),
    .INIT_6C(256'h22222222222244688DB1B1B3D3D3D3D3B1B1D3D3D3B1B3B36666444442446666),
    .INIT_6D(256'hC8C8C8E8E8E8EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAA842202222222220202222),
    .INIT_6E(256'hA2A2A2A2A2A2A2A2A2A2A2A4A4A4A4A6A6A6A8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_6F(256'hE2E2E2E4E4E4E4E4E4E4E4E4E2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2A2A2),
    .INIT_70(256'hC8C8A8C8A8A6A6C6E82C6E6E4C4A4828262648484848484626240404040606E4),
    .INIT_71(256'hA6A6A6A6A6C8C8C8C8A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A8A8C8C8C8C8C8),
    .INIT_72(256'h2242648688442222224242424244446464646464648484868686A6A6A6A686A6),
    .INIT_73(256'h2222222222222222222222222222202020202022424242424244444242424222),
    .INIT_74(256'h2222222020222222222222222020002020202020202020202020202022222222),
    .INIT_75(256'hB3D3D3D3B1B1D3D3D3D3B1B16644444444224444444422224444442242444222),
    .INIT_76(256'hEAEAEAEAEAEAEAEAC864200000222222222222222222222222224468AFD3B1B1),
    .INIT_77(256'hA4A4A6A6C6C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8E8E8E8EAEAEAEAEAEA),
    .INIT_78(256'hE2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2A2A2A2A2A4A4A4),
    .INIT_79(256'h6C6C6C6A6A6A6A8A8A8CACAC8A6A46260404040404E4E4E4E4E4E4E4E4E4E4E4),
    .INIT_7A(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8A8C8C8C8C8C8C8C8C8C8C8C8C6C80A2C6E6E),
    .INIT_7B(256'h444444646486866464848484848484848486A6A6C8C8C8A6A6A8C8C8C8C8C8C8),
    .INIT_7C(256'h2020202022222222222242644442426466666444424244646664444464646444),
    .INIT_7D(256'h2020202020202000000020202020222222222242222222222222222222000000),
    .INIT_7E(256'h6644424444446666666444444444442242422222222222222222222222222220),
    .INIT_7F(256'h0022222222222222222222222222246AD1D3B1B1D3D3D3B1B1B1D3D3D3D3D3B3),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_23_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_23_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized23
   (p_19_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_19_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_19_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h000000000000000000000000000000000000FFFFFFF000000000000000000000),
    .INITP_01(256'h0000000000000000000000000FFFFFFF00000000000000000000000000000000),
    .INITP_02(256'h00000000000000FFFFFFE0000000000000000000000000000000000000000000),
    .INITP_03(256'h001FFFFFC0000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h00000000000000000000000000000000000000000000000000000003FFFFFF00),
    .INITP_06(256'h000000000000000000000000000000000000000000003FFFFFF8000000000000),
    .INITP_07(256'h0000000000000000000000000000000007FFFFFFC00000000000000000000000),
    .INITP_08(256'h0000000000000000000001FFFFFFFC0000000000000000000000000000000000),
    .INITP_09(256'h00000000001FFFFFFF8000000000000000000000000000000000000000000000),
    .INITP_0A(256'hFFFFFFC000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000003),
    .INITP_0C(256'h00000000000000000000000000000000000000000000000000007FFFFFF00000),
    .INITP_0D(256'h000000000000000000000000000000000000000007FFFFFF0000000000003E00),
    .INITP_0E(256'h000000000000000000000000000000FFFFFFF8000000000007F0000000000000),
    .INITP_0F(256'h0000000000000000000FFFFFFFC00000000000FF000000000000000000000000),
    .INIT_00(256'hC8C8C8C8C8C8C8C8C8C8C8E8E8E8EAEAEAEAEAEAEAEAEAEAEAEAEAEA86200000),
    .INIT_01(256'hE4C2C2C2C2C2C2C2C2C2C2C2C2C2C2C4C4C4C4A4A4A6A6C8C8C8C8C8C8C8C8C8),
    .INIT_02(256'hAC8A68260404060606040404E4E4E4E4E4E4E4E4E4E2E2E4E4E4E4E4E4E4E4E4),
    .INIT_03(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C80A2C4C4C4C6C6C6C6C6C8A8A8A8CACAC),
    .INIT_04(256'h6484848486A6C8C8C8C8A6A6A6A6A6A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_05(256'h6666666464644444444444444444444444646464646464646486866464646464),
    .INIT_06(256'h2020222222222242422222222222222220000000202020202022222222424464),
    .INIT_07(256'h4444442244444242222222222222222222222020202020200000000000000020),
    .INIT_08(256'h2222446AAFB1D3D3D3D5D3B1B1B3D3D3D3D3D3D3664422224444666666666444),
    .INIT_09(256'hC8E8EAEAEAEAEAEAEAEAEAEAEAEAEAC864000000002222222222222222222222),
    .INIT_0A(256'hC2C2C4C4C4C4C4C6A6C6C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_0B(256'hE4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4C4C2C2C2C2C2C2C2C2C2C2),
    .INIT_0C(256'hC8C8C8E80A2C4C4C4C4C6C6C6C6C6A6A8A8A8A8A8A8A68482606060606060606),
    .INIT_0D(256'hA6A6A8C8C8C8C8C8C8C8C8C8CACAE8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_0E(256'h424222224244444444444444646464646464646464848484A6A6C8A6A6A6A6A6),
    .INIT_0F(256'h22222222222000002020202020222222424242648688A8A88866444222224242),
    .INIT_10(256'h2022222222202020202000000000000000002020202020222222424442424222),
    .INIT_11(256'hB3D3D3D3D5D5D5D5864422224242446644446644444444224444444222222222),
    .INIT_12(256'hEAEACA86220000000020222222222222224222222224466A8DB1D3D3D3D3D3B1),
    .INIT_13(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8EAEAEAEAEAEAEAEAEAEAEA),
    .INIT_14(256'hE4E4E4E4E4E4E4E4E4E4C4C4C4C4C4C4C4C4C4C2C4C4C4C4C4C6C6C6C8C8C8C8),
    .INIT_15(256'h6C6A6A6A6A6A688A8A8A6A4826060404040604E4E4E4E4E4E4E4E4E4E4E4E4E4),
    .INIT_16(256'hCACAE8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8E8EA2C4E4E4C4C4C4C4C),
    .INIT_17(256'h424464646464646484848484A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_18(256'h22222222222242446486A8CAA886442220202222222222222222222242424242),
    .INIT_19(256'h0000000000202020200020202222444444424442222222222222222020202222),
    .INIT_1A(256'h2222444444444466664444222244442222222222202244422220000020200000),
    .INIT_1B(256'h22000022444422222244688B6BAFB1B1D3D3B3B3D3D5D5D5D5D5D5D566442222),
    .INIT_1C(256'hC8C8C8C8C8C8C8C8E8EAEAEAEAEAEAEAEAEAEAEAEAEAA8640020000000002222),
    .INIT_1D(256'hC4C4C4C4C4C4C4C4C4C4C4C4C6C6C6C8C8C8C8C8CACAC8C8C8C8C8C8C8C8C8C8),
    .INIT_1E(256'h4806E4E4E4E4E4E4E4E4E4E4E4E6E4E4E4C4C4C4C4C4C4C4E4E4C4C4C4C4C4C4),
    .INIT_1F(256'hC8C8C8C8C8C8C8C8C8E8EA2C50706E4E4E4E4C4C4C4A6A6A6A6A6A68686A6A68),
    .INIT_20(256'hA6C8C8A6A6A6A6A6A6A6A6A6A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A8C8C8C8),
    .INIT_21(256'h86664442222222000000000000202222224242424242426464646464848484A6),
    .INIT_22(256'h2222444444222242222222224244422222222222222222424242424242424464),
    .INIT_23(256'h2242442222222222222244442220000000000000202020202020202020202020),
    .INIT_24(256'h8D8F8F8FB1B1B1B3D3D3D3D5D5D5D5D566442222222244444444446666444222),
    .INIT_25(256'hEAEAEAEAEAEAEAEAEACA862200220000000022222200002244442222224468AD),
    .INIT_26(256'hC6C8C8C8C8C8CACACACAC8C8C8CAC8C8C8C8C8C8C8C8C8C8C8C8C8C8E8EAEAEA),
    .INIT_27(256'hE4E4E4E4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C6C6),
    .INIT_28(256'h709270706E6E4C4C4C4A4A4A4A4A6A6A686A6A6A48280606E4E4E4E4E4E4E4E4),
    .INIT_29(256'hA6A6A6A8A8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8CACACAC8C8E80A4E),
    .INIT_2A(256'h0000202022224242424242446464646484848486A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_2B(256'h4244422222224242424244444442424242424222424222222220200000000000),
    .INIT_2C(256'h2220000000000020202020202020202020202020202244444222222222222222),
    .INIT_2D(256'hD5D5D5D364444422222222446466446444442222444422222242422222002242),
    .INIT_2E(256'h00000000000022222220222244442222222468ADAF8D8FB1B1B1B1B3D3D3D5D5),
    .INIT_2F(256'hCACACACAC8C8C8C8C8C8C8C8C8C8C8C8E8EAEAEAEAEAEAEAEAEAEAEAEAA86420),
    .INIT_30(256'hC4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C6C6C6C8C8C8CACACACACACACACACA),
    .INIT_31(256'h4A4A4A4A4A6A6A6A4A48280606E4E4E4E4E4E4E4E4E4E4E4C4C4C4C4C4C4C4C4),
    .INIT_32(256'hC8C8C8C8C8C8C8C8C8C8CACACACACAEAEAEA0C5092927070706E6E4E4C4C4A4A),
    .INIT_33(256'h44646464648486A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8C8E8),
    .INIT_34(256'h4444424242422222424222220000002222220000000000002022224242424242),
    .INIT_35(256'h2020202020202020202042442222222222222222222222222222424242424244),
    .INIT_36(256'h4466446464442244444422224444222222222222222220000000202020202020),
    .INIT_37(256'h442222224424688D8F8F8FB1D1B3B1D3D3D3D3D3D3D3D3B34442222222222222),
    .INIT_38(256'hC8C8C8E8E8EAEAEAEAEAEAEAEAEAEAEAC8642200000200000020222222222222),
    .INIT_39(256'hC4C4C4C4C6C6C8C8C8CACACACACACACACACAEAEACACACACACAC8C8C8C8C8C8C8),
    .INIT_3A(256'h0606E6E4E4E4E4E4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4),
    .INIT_3B(256'hEAEAEAEAEA0A2E93939290907070706E6E4C4C4C4A4A4A4A4A4A4A4A48482828),
    .INIT_3C(256'hA6A6A6A6A6A6A6A6A6A6A6A6A8C8C8C8C8C8CAEAEACAC8C8C8C8C8C8C8CAEAEA),
    .INIT_3D(256'h000020224422220000000000202222222242424242426464648486868686A6A6),
    .INIT_3E(256'h2220202222222222222222222222424444446464444242424242222242644422),
    .INIT_3F(256'h4444222022222222222222200000202020202020000000002020202020204222),
    .INIT_40(256'hB1D3B1D3D3D3B3B1B1B1B1B14444444422222222444442444444224242424222),
    .INIT_41(256'hEAEAEACA86422000220200000020222222222222222222224444466A6DB18FB1),
    .INIT_42(256'hEAEACACACACAEAEAEAEAEACAC8C8C8C8C8C8C8C8C8C8E8E8E8EAEAEACACAEAEA),
    .INIT_43(256'hC4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C6C6C6C8C8C8C8CACAEA),
    .INIT_44(256'h709090706E4E4C4C4C4C4A2A2A2A2A28282828280806E6E4E4E4E4C4C4C4C4C4),
    .INIT_45(256'hA6A8C8C8C8C8CAEAEAEACAC8C8C8C8C8C8CAEAEAEAEAEA0A0A2C70B5B3929092),
    .INIT_46(256'h00202222222222424242446464648484848486A6A6A6A6A6A6A6A6A6A6A6A6A6),
    .INIT_47(256'h2222224244666664444442424242222042666442222222444422000000000000),
    .INIT_48(256'h2000002020202222202000002020202222204222202020202242422222222222),
    .INIT_49(256'h4444444422222222224222444444442222222242444422202222222222222220),
    .INIT_4A(256'h0020222220222222222222424444666A6B8F8F8FB1B1B1B1B1B1B18F8F8F91B1),
    .INIT_4B(256'hC8C8C8C8C8C8C8C8C8C8E8E8E8EAEAEAEAEAEAEAEAEAEAA86420000022000000),
    .INIT_4C(256'hC4C4C6C6C6C6C6C6C6C6C6C6C8C8C8C8CACACAEAEAEAEAEAEAEAEAEAEAEAEACA),
    .INIT_4D(256'h2A2A2A280808080806E6E6E4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4),
    .INIT_4E(256'hC8C8C8C8C8C8CAEAEAEAEA0A0A2C93B5B593929290707070706E6E4C4C2C2A2A),
    .INIT_4F(256'h6464648484848686A6A6A6A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8CAEAEAEAEAC8),
    .INIT_50(256'h4242424222444444444444422200000000000000000022424242424242424264),
    .INIT_51(256'h2020202220202220002020202242422222202020202020222244646666664444),
    .INIT_52(256'h4244422222222222424422202022222222222222222000202022424444222020),
    .INIT_53(256'h422446686B8D8F8FB1D3D3B1B1B1B1B1B3D3D3D3442222222222222222222222),
    .INIT_54(256'hEAEAC8EAEAEACACAEAEAC8842000000002000000202022200000222220222222),
    .INIT_55(256'hC8E8E8EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEACAC8C8C8C8C8C8C8C8C8E8E8E8),
    .INIT_56(256'hC6C6C6C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C6C6C6C6C6C6C6C6C6C6C6C8),
    .INIT_57(256'h2C70B5B5B5B5B5B3909070706E6E6E4E4C2C2C2A2A0A08080806E6E6E6E6E6C6),
    .INIT_58(256'hA6A6A6A6A6A6A6A6A6C8C8C8C8C8CAEAEAEAEACAC8C8C8C8C8C8C8CAEAEA0A0A),
    .INIT_59(256'h0000000000000000000022424444424242424242646464648484848686A6A6A6),
    .INIT_5A(256'h2022222222202020202022222222424466666464444444446466644444442200),
    .INIT_5B(256'h0022222222222222220000000020224444222020222220202000422020202220),
    .INIT_5C(256'hD3B3D3B3D3D5D5D5222222222022222222222222222222222222222242444220),
    .INIT_5D(256'h20000000000000002200202020000020002222224224466A8D6B8FAFD1D3D3D3),
    .INIT_5E(256'hEAEAEAEAEAEACAC8C8C8C8C8C8C8C8C8C8C8E8EAEAEACAEAEAEACAEAEACAA642),
    .INIT_5F(256'hC6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8E8EAEAEAEAEAEAEAEAEAEAEA),
    .INIT_60(256'h6E6E6E4E4E4E4C2C2A0A0808E8E6E6E6E6E6C6C6C6C6C6C6C6C6C6C4C6C6C6C6),
    .INIT_61(256'hC8C8C8CAEAEAEAEACAC8C8CAEACACAEAEA0A0A0A4E93D7D7D7D5B5B593929070),
    .INIT_62(256'h424242424242424242646464648484868686A6A6A6A6A6A6A6A6A6A6A6C8C8C8),
    .INIT_63(256'h4222224264666464446464446464644442222220222000000000000000002022),
    .INIT_64(256'h0020222222200020202020202020442220222222200020222222222222222222),
    .INIT_65(256'h2222224444222222222222222222222244442222002222222222222220000020),
    .INIT_66(256'h2222000000222222422244688D4B8FD1D1D1D1D3D3D3D3D3D3D3D3D322444422),
    .INIT_67(256'hEAC8C8C8C8E8EAEAEAEACAEAEAEAEAEACAA86422200000000000000020000022),
    .INIT_68(256'hC6C6C6C8C8C8C8C8EAEAEAEAEAEAEAEAEAEA0C0C0C0C0AEAEAEAEAC8C8C8C8EA),
    .INIT_69(256'hE8E8E8E6E6E6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6),
    .INIT_6A(256'hEAEACAEAEA0A0A4E93D7D7D7D7D7D5B5B5B5B292706E6E6E6E6E4E4E2C2A0A0A),
    .INIT_6B(256'h64848486868686A6A6A6A6A6A6A6A6A6A6C8C8C8C8C8C8CAEAEAEAEAEACACAEA),
    .INIT_6C(256'h4464646444422222222222220000000000000022224242422242424242626464),
    .INIT_6D(256'h2000442220202222200000202220222222222242422200446666646444646464),
    .INIT_6E(256'h2222224244422222202222222222200000000020222222202020202020202020),
    .INIT_6F(256'h8D6BAFD1D1D1B1B1D3D3D3D3D3D3B3B344444444222022424422222222222222),
    .INIT_70(256'hEAEAEAEAA8662200000000000000000000000022222220000022222242224468),
    .INIT_71(256'hEAEAEAEAEA0C2C2E2E4E2C0AEAEAEAC8C8C8EAEAEAE8C8C8E8EAEAEAEAEAEAEA),
    .INIT_72(256'hC6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8C8EAEAEAEA),
    .INIT_73(256'hF9F9D7D5D5D5B5B392706E6E6E6E4E4E4E2C2C0A0AE8E8E8E8E8E8C8C6C6C6C6),
    .INIT_74(256'hA6A6A6A6A6A6C8C8C8C8C8CAEAEAEAEAEAEAEAEAEAEAEAEA0A0A0C70B5F9F9F9),
    .INIT_75(256'h222000000000002022222222222222424242646464648484868686A6A6A6A6A6),
    .INIT_76(256'h2020202222202022424220668886646444446464446464646464444222424222),
    .INIT_77(256'h2000000000002022222222200020202020202020000044222020202220202020),
    .INIT_78(256'hD3D3D3B344444444442222222222222222222222222222224442222222222222),
    .INIT_79(256'h00000000002020222222000000222222444444688D8DAFAFB1B1B1D3D3D5D3D3),
    .INIT_7A(256'hEAEAEACACAEAEAEAEAE8E8E8E8EAEAEAEAEAEAEAEAEAEAC88642000000000000),
    .INIT_7B(256'hC6C6C6C6C6C8C8C8C8C8C8C8C8C8C8C8CAEAEAEAEAEAEAEA0A2C4E707293500C),
    .INIT_7C(256'h6E4E4E4E4E4E2C2C0C0AE8E8E8E8E8E8C8C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6),
    .INIT_7D(256'hEAEAEAEAEAEAEAEAEAEAEAEA0A0A2C93D7F9F9F9F9F9F7D7D7D7D5B5B392906E),
    .INIT_7E(256'h22222222424242646464848484868686A6A6A6A6A6A6A6A6A6A6A8C8C8C8CACA),
    .INIT_7F(256'h8886646444444444646464646464644422224242222220202020002022222242),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_19_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_19_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized24
   (p_15_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_15_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_15_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000FFFFFFFE00000000000FF80000000000000000000000000000000000),
    .INITP_01(256'hFFFFF80000000000FF8000000000000000000000000000000000000000000000),
    .INITP_02(256'h00000FF800000000000000000000000000000000000000000000000000003FFF),
    .INITP_03(256'h0000000000000000000000000000000000000000000000001FFFFFFFFFE00000),
    .INITP_04(256'h00000000000000000000000000000000000003FFFFFFFFFF0000000000FFC000),
    .INITP_05(256'h000000000000000000000000003FFFFFFFFFF8000000000FFC00000000000000),
    .INITP_06(256'h0000000000000003FFFFFFFFFFE000000000FFC0000000000000000000000000),
    .INITP_07(256'h00003FFFFFFFFFFF000000001FFE000000000000000000000000000000000000),
    .INITP_08(256'hFFFFFC00000001FFE00000000000000000000000000000000000000000000000),
    .INITP_09(256'h001FFF0000000000000000000000000000000000000000000000000001FFFFFF),
    .INITP_0A(256'h00000000000000000000000000000000000000000000001FFFFFFFFFFFF00000),
    .INITP_0B(256'h000000000000000000000000000000000001FFFFFFFFFFFF80000003FFF00000),
    .INITP_0C(256'h0000000000000000000000001FFFFFFFFFFFFC000000FFFF0000000000000000),
    .INITP_0D(256'h00000000000001FFFFFFFFFFFFFC000037FFF000000000000000000000000000),
    .INITP_0E(256'h001FFFFFFFFFFFFFE00007FFFF00000000000000000000000000000000000000),
    .INITP_0F(256'hFFFFFFE000FFFFF0000000000000000000000000000000000000000000000000),
    .INIT_00(256'h2020202020202020202044222020202022222020202020222220222222222286),
    .INIT_01(256'h2222222222222222222222226442222222222220200000002020222022222220),
    .INIT_02(256'h00222222424444468AD1AF8DAFAFB1B1D3D3D3B1B1B1B1B14422224444222020),
    .INIT_03(256'hE8EAEAEAEAEAEACAEAEAEAA64220000000000000000000002022202222220000),
    .INIT_04(256'hC8C8C8C8CACAEAEAEAEAEAEA0A2E507295B7932E0AEAEACAEAEAEAEAEAE8E8E8),
    .INIT_05(256'hE8E8E8E8E8C8C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C8),
    .INIT_06(256'h0A0A4EB5F9F9FBF9F9F9F9F7F9F7F7D7D5B59290706E4E4E4E4C2C2C2C0A0AE8),
    .INIT_07(256'h8484868686A6A6A6A6A6A6A6A6A6A6C8C8C8CACAEAEAEAEAEAEAEAEAEAEAEAEA),
    .INIT_08(256'h4264644442224244444222202000002022224444422222224242426264646484),
    .INIT_09(256'h2222222020202220202022222242444222224488888664644442446442426444),
    .INIT_0A(256'h4444222222222020202020202020202020202020202020202020202020224422),
    .INIT_0B(256'h8D8FAFAFB1B1B18FB1B3D3B32222222222222200002222222222222222222220),
    .INIT_0C(256'h2200000000000000000000002022222222000000002222222244244468AFAD8D),
    .INIT_0D(256'h0C4E7295B7D7B5500CEAEAEAEAEAEAEAEAEAEAC8EAEAEAEAEAEAEAEAEAEAC864),
    .INIT_0E(256'hC6C6C6C6C6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C8C8C8C8C8CACAEAEAEAEAEAEA),
    .INIT_0F(256'hF9F9F9F7D7D5B5B29290706E4E4E4C2C2C2C0A0A08E8E8E8C8C8C8C8C8C8C8C6),
    .INIT_10(256'hA6A6A6C8C8C8EAEAEAEAEAEAEAEAEAEAEAEA0A0A0C2E93D7F9F9FBFBF9F9F9F9),
    .INIT_11(256'h2200000000222242444222222242424242646464648486868686A6A6A6A6A6A6),
    .INIT_12(256'h2042444222222288AA8864644442446464446444424242424222224244444422),
    .INIT_13(256'h2020202220202220202020202020222020226442222222202022222220202020),
    .INIT_14(256'h2222222222222222222222222222222222222220444242222220202020202020),
    .INIT_15(256'h00002222000000000020222222222424468DAF8D8D8DAFAFAFB1B18FB1D3D3D3),
    .INIT_16(256'hEAEAEAEAEAEAEACAEAEAEAEAEAEAEAEACAC88642000000000000000000000000),
    .INIT_17(256'hC8C8C8C8C8C8C8C8C8C8C8C8CAEAEAEAEAEAEAEA0C4E93B5D7D7D7932EEAEAEA),
    .INIT_18(256'h7070704E4E4E4E2C2A0A08E8E8E8C8C8C8C8C8C8C8C8C6C6C6C8C8C6C6C8C8C8),
    .INIT_19(256'hEAEAEA0A0A0A0A0C2C70D7F9F9FBFBFBFBFBF9F9F9F9F9F9F9F7D7D5B5B29270),
    .INIT_1A(256'h424242424242646464648486868686A6A6A6A6A6A6A6A6C8C8C8EAEAEAEAEAEA),
    .INIT_1B(256'h6464646464446464424242424222222244444422200000000000202244444242),
    .INIT_1C(256'h20202020202244422222222020222222002020202022222222422266A8AA6666),
    .INIT_1D(256'h2222222222222222224242222220202020202222222020200020222222202020),
    .INIT_1E(256'h22222424246A8DADAFAFD1D1B1B1B1B1B1B1D3D3222222222222222222222222),
    .INIT_1F(256'hEAEAEACAC8864200000000000000000000000000000000000000000000202222),
    .INIT_20(256'hCAEAEAEAEAEAEAEA0C5095D7D7D7D9B5500AEAEAEAEAEAEAEAEACACAEAEAEAEA),
    .INIT_21(256'hEAE8E8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_22(256'hFBFBFBFBFBFBFBF9F9F9F9F9F9F9F7F7D7D5B5B3B3B3B392909090704E2C2A0A),
    .INIT_23(256'h86868686A68686A6A6A6A6C8C8C8EAEAEAEAEAEAEAEA0A0A0A0A0A2C70B5F9F9),
    .INIT_24(256'h4244442222222222000000000000202244444444442222424242426464646484),
    .INIT_25(256'h2022222200202020002020202242224286AA8864668686646444646444424242),
    .INIT_26(256'h2020222220202222222220000020226422200020200020202020422222202222),
    .INIT_27(256'hD3D3D3D3B1B1D3D3222222222222222222222222222222222222222222222222),
    .INIT_28(256'h000000000000000000000000000000000020222222224444448A688DD1D1D1D1),
    .INIT_29(256'hF9D7F9D7730CEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAC88642000000000000),
    .INIT_2A(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8CAEAEAEAEAEAEAEA0C73B7D9),
    .INIT_2B(256'hF9F9F9F9F9F7F7D7D7D7D7D5D5B5B5B3906E4E2C0AE8E8E8E8E8C8C8C8C8C8C8),
    .INIT_2C(256'hC8C8CACAEAEAEAEAEAEA0A0A0C0A0C4E93D9F9FBFBFBFBFBFBFBFBF9F9F9F9F9),
    .INIT_2D(256'h000000202242646664222042424242646464646484848686868686A6A6A6A6A8),
    .INIT_2E(256'h2242222264A8A866868686646464646464444442426486442222222200000000),
    .INIT_2F(256'h2020226644200000202020202020224222202222222222220020222000202020),
    .INIT_30(256'h0000202022222222222222222222222220222220202222222220202242222000),
    .INIT_31(256'h000000000022222222224444468A8B8D8FAFD1D1B1B1D3D3D1B1B1D322000000),
    .INIT_32(256'hEAEAEAEAEACACACACACACA864200000000000000000000000000000022000000),
    .INIT_33(256'hC8C8C8C8C8C8C8E8EAEAEAEAEAEAEAEA2C93D7F9F9D7F9D7932EEAEAEAEAEAEA),
    .INIT_34(256'hD5D5B5B3B393906E2C0A0AEAEAE8E8E8E8C8C8C8C8C8C8C8C8C8C8C8E8C8C8C8),
    .INIT_35(256'h0C0A2C70D7F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F7F7D7),
    .INIT_36(256'h42424242426464646484848686868686A6A6A6A6C8C8C8CACAEAEAEAEAEA0A0A),
    .INIT_37(256'h6664646464424442424466444222222200000000000000000022448686422222),
    .INIT_38(256'h2220224442202022202222220020202000202222224422204486A88686868666),
    .INIT_39(256'h2222222220202020202020202220202242422220202020424420000020202022),
    .INIT_3A(256'h44686A8DAFAFAFD1B1B1D3D3D1D1D1D320000000002022222222202022222222),
    .INIT_3B(256'h2000000000000000000000000000000022000000000000002222222222222224),
    .INIT_3C(256'hEAEAEA0A2C95D7F9F9D7F9D795500CEAEAEAEAEAEAEAEAEAEACACACACAC8A864),
    .INIT_3D(256'hEAEAEAE8E8E8E8C8C8C8C8C8C8C8C8E8E8E8C8C8C8C8C8C8C8C8E8EAEAEAEAEA),
    .INIT_3E(256'hFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F7F7D7D5D5D5D5B5B36E2C2A0A),
    .INIT_3F(256'h8686868686A6A6A6A8C8C8C8C8CAEAEAEAEA0A0A0A0C4EB5F9F9F9F9FBFBFBFB),
    .INIT_40(256'h4422000000000000000020000020426466444222224242424244646464648486),
    .INIT_41(256'h0020202020202222424422224488888886868686866664646444444442424244),
    .INIT_42(256'h2220002022222222202000204442222020202022220022444220002020222242),
    .INIT_43(256'hD3D3D3D300000000000000000020202000002020202020202020202020202020),
    .INIT_44(256'h00000000220000000000000022222222222222222446686B8DAFAFB1B1D1D3D1),
    .INIT_45(256'hB5702CEAEAEAEAEAEAEAEAEAEACACACAC8A86422000000000000000000000000),
    .INIT_46(256'hE8E8E8E8E8E8C8C8C8C8C8E8E8E8EAEAEAEAEAEAEAEAEA0A2EB5D7F9F9F7F9D7),
    .INIT_47(256'hF9F9F9F9F9F9F9F9F9F9F7D7D7D7D7D5B3702C0A0A0AEAEAEAE8E8E8E8E8E8E8),
    .INIT_48(256'hC8C8E8EAEAEAEA0A0A2C92D7F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9),
    .INIT_49(256'h2022224244444222204242424242646464646484868686868686A6A6A6A8C8C8),
    .INIT_4A(256'h66A8888886868686888686866444646444422244644400000000000000002020),
    .INIT_4B(256'h4244442222222022222022424220002020224244202020202020202042642222),
    .INIT_4C(256'h0000000000000000002020202222222020202022222000202222222220000000),
    .INIT_4D(256'h00222222222222222444686A8DAFAFB1D1D1D3D1D3D3D1B10000000000000000),
    .INIT_4E(256'hEACACAC8A8842200000000000000000000000000000000002200000000000000),
    .INIT_4F(256'hEAEAEAEAEAEAEAEAEAEAEA0C4EB5F9F9F9F9F9D7D7932E0AEAEAEAEAEAEAEAEA),
    .INIT_50(256'hF9F9F9F7D7B36E2C0A0A0A0AEAEAEAEAEAEAEAEAE8E8E8E8E8E8E8E8E8E8E8EA),
    .INIT_51(256'hF9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9FBFBFBFBFBF9F9F9),
    .INIT_52(256'h424242646464646484868686868686A6A6A6A8C8C8C8C8E8EAEAEA0A2C70B5F9),
    .INIT_53(256'h6464646464422244444420000000000000000020222222222242424242424242),
    .INIT_54(256'h222200202022424420202020200000204244222266AA86868688A88688868686),
    .INIT_55(256'h2222222020202022222020202020222020000020226444422222222220202222),
    .INIT_56(256'h8DADAFD1D1D3B1D1D3D1B18F0000000000000022220000000000000000002022),
    .INIT_57(256'h000000000000000000000000000000000000000000222222222222224446686A),
    .INIT_58(256'h70D7F9F9F9F9F9D7D7B54E0CEAEAEAEAEAEAEAEAEACACAA88642200000000000),
    .INIT_59(256'h0AEAEAEAEAEAEAEAEAE8E8E8E8E8E8E8E8EAEAEAEAEAEAEAEAEAEAEAEAEA0A2C),
    .INIT_5A(256'hFBFBFBFBFBFBFBFBFBFBF9FBFBFBFBFBFBFBF9F9F9F9F9F9F9D7B5702C0A0A0A),
    .INIT_5B(256'h868686A6A6A6A6A8C8C8C8C8E8EAEA0A2E92D7F9F9F9F9F9F9FBFBFBFBFBFDFD),
    .INIT_5C(256'h0000000000000000222222222222424242422042424242426464646464868686),
    .INIT_5D(256'h202000204244200066AA668688A8CAA8A8868888646444646442224244442200),
    .INIT_5E(256'h2020202020202022224444442220222000202222222220202222224220222020),
    .INIT_5F(256'h0000000000002222222020000000000000002022222222222220222020202020),
    .INIT_60(256'h000000000000000000222222222222222244686A8BADD1D1D3D3D3D3D3D3B1B1),
    .INIT_61(256'hEAEAEAEAEAEAEAEAEACAA8864200000000000000000000000000000000000000),
    .INIT_62(256'hEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA0A0A0A2E95D9F9F9F9F9F9F7D7B5500C),
    .INIT_63(256'hFBFBFBFBFBF9F9F9FBFBF9F9F9F9F9B34E2C0A0A0A0AEAEAEAEAEAEAEAEAEAEA),
    .INIT_64(256'hE8EAEA0C4EB5D7D7D9F9F9F9F9F9FBFBFBFBFBFDFDFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_65(256'h222242444242202222424242426464646484868686868686A6A6A6A6C8C8C8C8),
    .INIT_66(256'h88AACCAA88868686644442444442222244444442220000000000000022222222),
    .INIT_67(256'h2200200000202222224242222222222220222020222020222242222066AA8886),
    .INIT_68(256'h0000000000002022222222222222202020202020202022222222200022224444),
    .INIT_69(256'h222222222244688A8B8DAFD1D1D1B1B1B1D1D3B1000000000000224244200000),
    .INIT_6A(256'h2000000000000000000000000000000000000000002000000000000022222222),
    .INIT_6B(256'hEAEA0A0AEA0A2C70D7F9FBF9F9F9F7F7D7B5700CEAEAEAEAEAEAEAEAEAA88642),
    .INIT_6C(256'hF9F9F9D7934C0A0A0A0A0A0A0A0AEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA),
    .INIT_6D(256'hF9F9FBFBFBFBFBFBFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9FBFBFBF9F9),
    .INIT_6E(256'h424464646464848486868686A6A6A6A6A8C8C8C8E8EAEA0C5095B7D7D7D7F9F9),
    .INIT_6F(256'h4442222242444444222200000000000020222222222242424242222222224242),
    .INIT_70(256'h2222222222222222222222222222222066CACA8888CACCCA8686866644644444),
    .INIT_71(256'h2222222020202020202020202022220020224244422020202020222242444422),
    .INIT_72(256'hAFB1AFAFB1D1D3D3000000000000004444200000202020220000202222222222),
    .INIT_73(256'h0000000000000000000000000000000022220222224444444444668A8D8D6B8D),
    .INIT_74(256'hF9F9F7F7D7B5700CEAEAEAEAEAEAEAEAC8864220000000000000000000000000),
    .INIT_75(256'h0A0A0AEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA0A0A0A0A2C4E93F9F9FBF9),
    .INIT_76(256'hFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9D5702C2A0A0A0A0A),
    .INIT_77(256'h86A6A6A6A6C8C8C8C8E8EA0C5093B5B5D7D7D7F9F9F9F9FBFBFBFBFBFBFBFBFB),
    .INIT_78(256'h0000000000222222222242424242424222222242424244446464646484848686),
    .INIT_79(256'h2222202066AACAA8A8CACCAA6686866464646464646442222244444442220000),
    .INIT_7A(256'h2022222020204244442020000020424222222200000022222222222020222222),
    .INIT_7B(256'h0000204444220000202000222020202222222222222220202020202022222222),
    .INIT_7C(256'h0000000022222200224444444444468A8D8D6B6B8DAFAFAFAFB1D1D300000000),
    .INIT_7D(256'hEAEAEAC886422000000000000000000000000000000000000000000000002000),
    .INIT_7E(256'hEAEAEAEAEAEAEAEA0A0A0A0A2C4E93D7FBFBFBF9F9F9D7D7D7B5702CEAEAEAEA),
    .INIT_7F(256'hF9F9F9F9F9F9F9F9F9F9F9F9F7B34E2C0A0A0A0A0A0A0A0A0A0A0AEAEAEAEAEA),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_15_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_15_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized25
   (p_11_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_11_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_11_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hFFFF0000000000000000000000000000000000000000000000000001FFFFFFFF),
    .INITP_01(256'h000000000000000000000000000000000000000000001FFFFFFFFFFFFFFF807F),
    .INITP_02(256'h0000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFF0000000),
    .INITP_03(256'h000000000000000000000007FFFFFFFFFFFFFFFFFFFFFF000000000000000000),
    .INITP_04(256'h0000000000003FFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000000),
    .INITP_05(256'h01FFFFFFFFFFFFFFFFFFFFFE0000000000000000000000000000000000000000),
    .INITP_06(256'hFFFFFFFFFFFFC000000000000000000000000000000000000000000000000000),
    .INITP_07(256'hFC000000000000000000000000000000000000000000000000000007FFFFFFFF),
    .INITP_08(256'h000000000000000000000000002000000000000000001FFFFFFFFFFFFFFFFFFF),
    .INITP_09(256'h0000000000000006000000000000000000FFFFFFFFFFFFFFFFFFFF8000000000),
    .INITP_0A(256'h000060000000000000000007FFFFFFFFFFFFFFFFFFF800000000000000000000),
    .INITP_0B(256'h0000000000003FFFFFFFFFFFFFFFFFFF00000000000000000000000000000000),
    .INITP_0C(256'h00FFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000006000000),
    .INITP_0D(256'hFFFFFFFFFF000000000000000000000000000000000000C00000000000000000),
    .INITP_0E(256'h00000000000000000000000000000000000400000000000000000003FFFFFFFF),
    .INITP_0F(256'h000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFC0),
    .INIT_00(256'h4E9293B5D5D7D7D7F7F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9),
    .INIT_01(256'h22424242222222224242424444646464648484868686A6A6A6A6A8C8C8C8EA0C),
    .INIT_02(256'h6486866466868664646444222242444422220000000000000000222222222222),
    .INIT_03(256'h0020424222200000000020222222202020202222222222204488A8A8AACCCCAA),
    .INIT_04(256'h2222222222222222222200202222202222224222202022202000224444222000),
    .INIT_05(256'h444446688DADAD8D8DADADAFAF8F8FB100000000000022446622000000000022),
    .INIT_06(256'h0000000000000000000000000000000000002200000000002222220022424422),
    .INIT_07(256'h7093D7F9FBFBF9F9F9F9D7D7B593500CEAEAEAEACAEACAA64220000000000000),
    .INIT_08(256'hF7D7934E2A0A0A0A0A0A0A0A0A0A0A0A0AEAEAEAEAEAEAEAEA0A0A0A0A0A2C4E),
    .INIT_09(256'hF9FBFBFBFBFBFBFBFBFBFBFBF9F9F9FBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_0A(256'h444264646464648486868686A6A6A6A6C8C8E80A2E709292B5D5D5D7D7F7F9F9),
    .INIT_0B(256'h2242444422200000000000000000222222222222224242424222222222424242),
    .INIT_0C(256'h2222202020202022222222204286CACACACCCCAA648886668688866464644222),
    .INIT_0D(256'h2222202022222220002020200000224244222000002022424222000000002022),
    .INIT_0E(256'hAF6D4B6D00000000000022446622220000002022222222222222222222222022),
    .INIT_0F(256'h0000000000002200000000002222222222224444224422468CCFAFAD8D8D8DAF),
    .INIT_10(256'h93704E0CEAEAEAEACACA88442000000000000000000000000000000000000000),
    .INIT_11(256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A2C4E7093D7D7F9F9FBF9F9F9F9D7D7B5),
    .INIT_12(256'hF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7D5904C2A0A0A0A0A0A0A),
    .INIT_13(256'h8686A6A6A6A8C8E80A2C4E7092B3B5B5D5D7D7F7F9F9F9F9FBFBFBFBFBFBFBFB),
    .INIT_14(256'h0000222222222222424242424242222222424242424242646464648484868484),
    .INIT_15(256'h4488ECECECCCCA88648688868688666464644422224244442220000000000000),
    .INIT_16(256'h0000222222222000000000224442200000000022222222222222222222222222),
    .INIT_17(256'h4444220000002222224444222222222222202222442200000000000000000000),
    .INIT_18(256'h222222424422444444444446688A8BADADAD8D6BAFAFAF8D0000000000000022),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000200000000000),
    .INIT_1A(256'h0A0A0A2C4E93B5D7F9F9F9F9F9F9F9F9D7D7B593704E2C0CEAEAEAEACA864422),
    .INIT_1B(256'hF9F9F9F9F9F9F7F7F7F9F7B36E2C2A2A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_1C(256'h709092B3B5B5D5D7F7F9F9F9F9FBFBFBFBFBFBFBF9F9FBFBFBFBFBFBFBF9F9F9),
    .INIT_1D(256'h4242422222424242424242426464646484848484848686A6A6A6C8C8EA0A2C4E),
    .INIT_1E(256'h8686646464666442224244222222222200000000000022222222224242424242),
    .INIT_1F(256'h44442222000000222222222022222222202020424486A8CACACAA86644868666),
    .INIT_20(256'h2222222222002022222200000000000000000000002222222222000000000022),
    .INIT_21(256'h668AADAFAFAFAF8DAFD1D3D10000000000000020446622000000222222444442),
    .INIT_22(256'h0000000000000000000000000000202220000000444444222222446444444444),
    .INIT_23(256'hF9F9F9D7D7B59592702E0CEAEAEACACAA8642200000000000000000000000000),
    .INIT_24(256'h904C2A2A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A4E93D5F7F9F9F9F9F9),
    .INIT_25(256'hF9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F7F7F7F7D5),
    .INIT_26(256'h426464646464848484848486A6A6A6C8E8EA0A2C4E70709292B2B5D5D7F7F7F9),
    .INIT_27(256'h2222222200000000000022222222224242424242424242222222424242424242),
    .INIT_28(256'h2222222220000022426488A8A8AAAA8844666666868666646466664422222222),
    .INIT_29(256'h0000000000000022002222220020000000000000222222222200002022222020),
    .INIT_2A(256'h0000000020000000226622000020222222424422222222222000222222220000),
    .INIT_2B(256'h000022222200002266864420224244444442424466AACFCFAFAFD1AFAFAFD1F3),
    .INIT_2C(256'hEACACAA864220000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0A0A0A0A0A0A0A0A0A0A2C70B5F7F9F9F9F9F9F9F9F9F9D7B5B592704E2C0AEA),
    .INIT_2E(256'hFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F7F7F7F7F7B3904C2C2A0A0A0A0A0A0A0A),
    .INIT_2F(256'h86A6A6A6C8C8E80A0C2E4E707090B2B5D5D5F7F7F7F7F9F9F9FBFBFBFBFBFBFB),
    .INIT_30(256'h4222224242222242424242422222222242424242424242646464646464848484),
    .INIT_31(256'hA8CACCAA66866664888686646464664422222200224422000000000000002242),
    .INIT_32(256'h00000000000000002222222222200000222220202020222220200000226488A8),
    .INIT_33(256'h0020222222224422222222222020222222220000000000000000002222222220),
    .INIT_34(256'h20444444444242426488ACAD8D8DAFAD8D8DAFD1000000002000000022662222),
    .INIT_35(256'h0000000000000000000000000000000000000000000022222200002288A86600),
    .INIT_36(256'hD7F9F9F9F9F9F9F9F9F9D7D7B59370502E0CEAEAEACAA8644200000000000000),
    .INIT_37(256'hF9F9F9F9F7F7F7F7F7B3704C2C2A2A0A0A0A0A0A0A0A0A0A0A0A0A0A0A2C4EB5),
    .INIT_38(256'h4E7090B2B2D5D5D5F7F7F7F9F9F9FBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9),
    .INIT_39(256'h42222222224242424242424264646464646464848486A6A6A6C8C8E8EA0C2C4E),
    .INIT_3A(256'h6464644422222200224422000000000000002242442222424220204242424242),
    .INIT_3B(256'h22220020222222200020202222222200204286A8CAECEECC86866464A8888666),
    .INIT_3C(256'h2022222222220000000000000000002222000000000000000000000000002022),
    .INIT_3D(256'h686868684848688B000000002222000022444222202022200042644222222220),
    .INIT_3E(256'h0000002200000000000000222000002066886600224422224444222244466868),
    .INIT_3F(256'h9572502E0C0CEAEAEAA864220000000000000000000000000000000000000000),
    .INIT_40(256'h4C2C2C2A0A0A0A0A0A0A0A0A0A0A0A0A2A4E93D5F7F9F9F9F9F9F9F9F9D7D7B5),
    .INIT_41(256'hF7F9F9F9FBFBFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7D5B34E),
    .INIT_42(256'h446464646464646484868686A6A6C8C8C8EAEA0C2C4E709092B2B4D5D5D5F5F7),
    .INIT_43(256'h0000000000000042442222424222424242424242424222222242424242424242),
    .INIT_44(256'h2222222020226686CAEC0EECCAA86464AAAAA886666686664422220022222200),
    .INIT_45(256'h2200000022002222000000000000000000002022442220002222222220202222),
    .INIT_46(256'h2222222222444422000020000044864422222222222220222222220000000000),
    .INIT_47(256'h0000000044664400224422224444444446666868688A6A6A6A6A6B6B22222222),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0A0A0A2A4C90B5F7F9F9F9F9F9F9F9F7F7D5B5B592704E2C0CEAECEAA8644200),
    .INIT_4A(256'hF9F7F7F9F9F7F7F7F7F7F9F9F9F9F7F7F7F7D5904C2C2A2A2A0A0A0A0A0A0A0A),
    .INIT_4B(256'h86A6A6A6A6C8C8EA0A2C4E6E709092B2B2D5D5F7F7F7F7F9F9F9F9F9F9F9F9F9),
    .INIT_4C(256'h2222424242424242424242222222424242424242424264646464646464848484),
    .INIT_4D(256'hECAA6444A8AAA888866688644222220020222200000000000000002242222022),
    .INIT_4E(256'h00000000000022424444220000224222222222222222422222428686CA0E0EEE),
    .INIT_4F(256'h0044864422222222220200222244222000002000200000002200202200000000),
    .INIT_50(256'h22664444466666688A8A8A8B8D8D8D8D22222222222220002222444222000000),
    .INIT_51(256'h0000000000000000000000000000000000000002220000002244442242422222),
    .INIT_52(256'hF9F9F7D7D7D5B592704E2C0C0CEAEAC884422000000000000000000000000000),
    .INIT_53(256'hF9F7F7F7F7F7F7B36E4C2A2A2A0A0A0A0A0A0A0A0A2A2A4C70B3D7F9F9F9F9F9),
    .INIT_54(256'h4E6E709092B2D5D5D5D5F7F7F7F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F9),
    .INIT_55(256'h22222222424242424242626262646464646484848486A6A6A6A6C8C8EA0A2C2C),
    .INIT_56(256'h2242222222222200000000000000002242222022224242424242424242424222),
    .INIT_57(256'h00224442222222222222422222428688EC0E0EEEEEAA6444A8AAA88886668844),
    .INIT_58(256'h2244222200002000000000000000000000000000000000000000224444664420),
    .INIT_59(256'hAFB1D1AF22222220000000002222444422200020204466442222222222000000),
    .INIT_5A(256'h000000000000002222200000224444224222222022664444666866688AAA8B8D),
    .INIT_5B(256'hECEAA88642200000000000000000000000000000000000000000000000220000),
    .INIT_5C(256'h0A2A2A2A0A0A0A0A2A2C4C70B3D5F7F9F9F9F9F9F9F7D7D5D5B593704E2C0C0C),
    .INIT_5D(256'hF7F7F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7D5B36E4C2A),
    .INIT_5E(256'h42426464646464648484848686A6A6C6C8E80A0A2C4C4E6E7092B2B2D5D5D5F5),
    .INIT_5F(256'h0000002242422022224242424242424242424222222222222242424242424242),
    .INIT_60(256'h204286A8EC0E0EECECA86464AAAAA8A88886A844224442222222220000000000),
    .INIT_61(256'h0000000000000000000000000000224444666622222242422222222222222220),
    .INIT_62(256'h2222446644220022224464422222222222000000222222220000000000000000),
    .INIT_63(256'h204244222222222220444466666868688AACADAFB1D1D3D12222000000000022),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000022200020),
    .INIT_65(256'hD5F7F9F9F9F9F9F9F9F7D5B5B592704E2C0C0C0AEACA66222000000000000000),
    .INIT_66(256'hF7F7F7F7F7F7F9F7F7F7F7F7F7F7F7F7D5B36E4C2A2A2A2A2A2A2A2C4C6E90B3),
    .INIT_67(256'h8486A6A6C6C8E8E80A0A2C4E4E709092B2B2D5D5F5F7F7F7F7F7F9F9F7F7F7F7),
    .INIT_68(256'h4242424242424222222222222242424242424242424242446464646464648484),
    .INIT_69(256'hAACAAAA88888AA44424444222222220000000000000000224242222222424242),
    .INIT_6A(256'h0000004444446444442242422222222222222200002266A80E0EEECACA664264),
    .INIT_6B(256'h2222222222000000002022000000000000000000002000000000000000000000),
    .INIT_6C(256'h6666666688AAADAFAFD1D3D32200000000002022222244444422202222224222),
    .INIT_6D(256'h0000000000000000000000000000000022220020204244424222222220224466),
    .INIT_6E(256'h92704E2C0C0A0C0AC88642000000000000000000000000000000000000000000),
    .INIT_6F(256'hF7F7F7F7F7F7D5B3906E4E4E6E6E909093B3D5F7F7F7F7F9F9F9F7F7F7D5B5B2),
    .INIT_70(256'h2C4C4E6E9092B2B2D4D5F7F7F7F7F7F7F9F9F7F7F7F7F7F7F7F7F9F7F7F7F7F7),
    .INIT_71(256'h222242424242424242424242446464646464646484848484A6A6C6C8E8E80A2C),
    .INIT_72(256'h2222220000000000000000224242222222424242424242424242422222222222),
    .INIT_73(256'h222022222222220000226488EC0EEECACA642242A8CACAA88886A86464666422),
    .INIT_74(256'h0000000000000000002222000000000000000000002022224222446644446464),
    .INIT_75(256'h2222000020000022222222424422222220222222222222222000000000000000),
    .INIT_76(256'h00000000222222202042644242222222220044666688666666688AAFAFAFB1B1),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'hD7D7D7D7F7F7F7F7F7F7F7F7F7F7F7D7D5B39070704E2C0C0C0CECEA86422000),
    .INIT_79(256'hD5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F7D7D5D5D5),
    .INIT_7A(256'h4242446464646464648484848484A6A6C6C8E8EA0A2A2C4C4E6E709092B2D5D5),
    .INIT_7B(256'h2242222222224242424242424242422222222222222242424242424242424242),
    .INIT_7C(256'hCAEEECCAA8642244A8A8AAA88688A88666868844424222000000000000000020),
    .INIT_7D(256'h0000000000000000000020002000224444446686442222222222220000204266),
    .INIT_7E(256'h4444222222424442424222220000000000000000000000200000000000222200),
    .INIT_7F(256'h222222222200446666886666666868ADAFD1B1B1442220202222202222222022),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_11_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_11_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized26
   (p_7_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_7_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_7_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000000004000000000000000000007FFFFFFFFFFFFFFFF0000000000000),
    .INITP_01(256'h004000000000000000000001FFFFFFFFFFFFFFFE000000000000000000000000),
    .INITP_02(256'h00000000000007FFFFFFFFFFFFFFC00000000000000000000000000000000000),
    .INITP_03(256'h001FFFFFFFFFFFFFF80000000000000000000000000000000000000000000000),
    .INITP_04(256'hFFFFFF8000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h000000000000000000000000000000000000000000000000000000007FFFFFFF),
    .INITP_06(256'h0000000000000000000000000000000000000000000000FFFFFFFFFFFFF00000),
    .INITP_07(256'h000000000004000000000000000000000001FFFFFFFFFFFC0000000000000000),
    .INITP_08(256'h40000000000000000000000003FFFFFFFFFF0000000000000000000000000000),
    .INITP_09(256'h000000000000001FFFFFFFFFE000000000000000000000000000000000000000),
    .INITP_0A(256'h000001FFFFFFF800000000000000000000000000000000000000040000000000),
    .INITP_0B(256'hFF00000000000000000000000000000000000000006000000000000000000000),
    .INITP_0C(256'h00000000000000000000000000000004000000000000000000000000000FFFFF),
    .INITP_0D(256'h000000000000000000000000000000000000000000000000007F800000000000),
    .INITP_0E(256'h0000000008000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000002244422020424422),
    .INIT_01(256'hF7F7D5D5B3906E4E2E2C0C0AEAEAEAA864000000000000000000000000000000),
    .INIT_02(256'hF7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7),
    .INIT_03(256'h848484A6A6C6C8E8E8080A2A2C4C4E6E7090B2B2D3D5D5F5F7F7F7F7F7F7F7F7),
    .INIT_04(256'h4242424222222222222242424242424242424242424242446464646464646464),
    .INIT_05(256'h8888886664668864444222000000000000000000222222222222424242424242),
    .INIT_06(256'h0000222242226688644222222222222000204286EC0EECCA88444264A8A8A8A8),
    .INIT_07(256'h2000000000002200000000000000000000222000000000000000000000202200),
    .INIT_08(256'h6868668AAFD1D3D3442222222222222222200022444422222244444244422222),
    .INIT_09(256'h0000000000000000000000002244442222424222202222224422224466686868),
    .INIT_0A(256'hEACAA86420000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'hF9F9F9F9F9F9F9F9F7F7F7F7F7F7F7F7F7F7F7F7F7D5D5B3906E4E2C0C0C0AEA),
    .INIT_0C(256'h0A2A2C4C4E6E8E90B0B2D2D3D5F5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9),
    .INIT_0D(256'h424242424242424242424242424264646464646464848484A6A6C6C8C8E8E80A),
    .INIT_0E(256'h0000000000000000202222222222424242424242424242424242422222424242),
    .INIT_0F(256'h22222222222244A8EC0EECCA66444466A886A8A8A88866644464864442222200),
    .INIT_10(256'h0000000000220000000000000000202020222222202222202222646666444242),
    .INIT_11(256'h2222222222200022424422224444444242422222220000000000220000000000),
    .INIT_12(256'h2042666442424222202222224644224468886868686846668DCFD3D344222222),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'hF7F7F7D7D7D7D5D5D5B3B290704E2C2C0A0AEAEAEAA864200000000000000000),
    .INIT_15(256'hB2D2D5D5D5F5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F7F7F7F7),
    .INIT_16(256'h42424242646464646464648484A6A6A6C6C6C8E8E80A0A2A2C4C4C6E6E9090B0),
    .INIT_17(256'h2242424242424242424242424242424242424242424242424242424242424242),
    .INIT_18(256'h64646464A886A8A8A88864666464664442222200000000000000000000222222),
    .INIT_19(256'h00222220222242222222222222424444666444422222222222204266CAECECA8),
    .INIT_1A(256'h4464442242442222222222000000000000000000002222222200000000000000),
    .INIT_1B(256'h4466444488888A6868686866688B8FB144222222222022222022202222222222),
    .INIT_1C(256'h0000000000000000000000000000000000000000202244664442424222222222),
    .INIT_1D(256'h4C2C2C0A0AEAEAEAC86420000000000000000000000000000000000000000000),
    .INIT_1E(256'hF7F7F7F7F7F7F5F7F7F7F7F7F7F7F7F7F7F7F7F7D5D5D5D5D5D5D5B2B290704E),
    .INIT_1F(256'h8486A6A6A6A6C6C8E8E8E80A0A2A2A2C4C4C6E6E8E90B0B2B2D5D5D5D5F5F7F7),
    .INIT_20(256'h4242424242424242424242424242424242424242424242424262646462626484),
    .INIT_21(256'h4464866444422000000000000000000000222222224242424242424242424242),
    .INIT_22(256'h22424244646444424242222222202266CCEECC8642646486A886A8A886664444),
    .INIT_23(256'h2200000000000000000022222200000000000000002220202022222222222222),
    .INIT_24(256'h68688DB142222222202022220022222222222244444444224444422244442222),
    .INIT_25(256'h0000000000000000202222664442444220202222448866466668888A8A888888),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'hF7F7F7F7F7F7F5D5D5D5D5D5B5B3B290706E4C2C2C0A0A0A0AEAEAC886420000),
    .INIT_28(256'hE808080A2A2A2C4C4C6C6E8E9090B0B2B2B2B2D2D2D5D5D5D5D5D5D5F5F5F7F7),
    .INIT_29(256'h424242424242424242424242424242626262626484848486A6A6A6C6C6C8E8E8),
    .INIT_2A(256'h0000000000202222224242424242424242424242424242424242424242424242),
    .INIT_2B(256'h22224286CCEECC66426486A8CCA8AAA886664444444486444422000000000000),
    .INIT_2C(256'h2222000000000000002020202022222222222020222222424444444242424442),
    .INIT_2D(256'h0022222200002242444444444444222244664444440000000000000000002222),
    .INIT_2E(256'h4442424220000022228888664668688A8A8A8888886868AF2222222220202222),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000202264),
    .INIT_30(256'hB290906E4E4C2C0A0A0A0A0AEAEAC88642000000000000000000000000000000),
    .INIT_31(256'h6C6E6E8E90909090B0B2B2D2D3D5D5D5D5F5F5F7F7F7F7F7D5D5D5D5D3B2B2B2),
    .INIT_32(256'h42424242626262646464848484A6A6A6A6C6C6C6E8E8E8E8080A0A2A2A2A4C4C),
    .INIT_33(256'h4242424242424242424242424242424242424242424242424242424242424242),
    .INIT_34(256'hECA8AAA886666444444466424422000000000000000000000020222242424242),
    .INIT_35(256'h202220222220202022222222424444422222444242424486CCEEEC86646486A8),
    .INIT_36(256'h4444222242644444442200002000000000002222222200000000000000000000),
    .INIT_37(256'h4668688A8A8A8A888868688B2222222200202222202222220000002222446644),
    .INIT_38(256'h000000000000000000000000000000000020424444444242222000002266AA68),
    .INIT_39(256'hEAC8864200000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'hB2B2B2B2D2D3D5D5D5D5D5D5D5B2B2B2B2B29090706E4E4C2C2A0A0A0A0AEAEA),
    .INIT_3B(256'h848484A6A6A6A6C6C6C6C6E8E8E8E808080A2A2A2A4C4C4C6E6E6E8E9090B0B2),
    .INIT_3C(256'h4242424242424242424242424242424242424242424242424242626264646464),
    .INIT_3D(256'h4222000000000000000000000000222242424242424242424242424242424242),
    .INIT_3E(256'h224444422222442222424486CC0EEEA8646686A8EEAAAAA88886644444646642),
    .INIT_3F(256'h2222202220000022222222000000000000000000202222222220202022222222),
    .INIT_40(256'h2222222200202222222222220000002222446444444442222244424444220020),
    .INIT_41(256'h000000000020444244444444222220224446AA8A6666888AAA8A8A8888886868),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h9090909090706E4E4C2C2A0A0A0A0A0AEAEAEAEACA8644200000000000000000),
    .INIT_44(256'hC6C8E8E8E8E8080A2A2A2A2A2C4C4E6E6E6E6E9090909090B0B2B2B2B2B2B2B2),
    .INIT_45(256'h424242424242424242424242424242426264646464848484A6A6A6A6C6C6C6C6),
    .INIT_46(256'h0000222242424242424242424242424242424242424242424242424242424242),
    .INIT_47(256'hCC0EEEA8646466A8EECCCCCAA886644444666642442200000000000000000000),
    .INIT_48(256'h0000000000200000002222222222222222222222224244422222422222224486),
    .INIT_49(256'h2200000022446444444444222222222244220022222222222200000022222200),
    .INIT_4A(256'h2220002224668A8A684488AAACAC8A6866688868222222220000202222442222),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000020424244446464),
    .INIT_4C(256'h0A0A0AEAEAEAE8C8864420000000000000000000000000000000000000000000),
    .INIT_4D(256'h0A0A0A2A2A4C4C4C6E6E6E6E6E6E8E8E6E6E6E6E6E6E6E4E4E4C2C2C2A0A0A0A),
    .INIT_4E(256'h4242424242426464646484848484A6A6A6A6A6C6C6C6C6C8E8E8E8080A0A0A0A),
    .INIT_4F(256'h4242424242424242424242424242424242424242424242424242424242424242),
    .INIT_50(256'h8666444466866444442220000000000000000000000020222242424242424242),
    .INIT_51(256'h2222222242222222224244444222222220224488EC0EEC8642224488ECEECCAA),
    .INIT_52(256'h2242222222220022220000222200000000222200002222220020000020222222),
    .INIT_53(256'hAAAAAD8A68668888222242220000002222422222222000002244664444666444),
    .INIT_54(256'h0000000000000000000000222220204222426486222200000244688C8A46688A),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h4C4C4C4C4C2C4C4C4C2C2C2C2A2A0A0A0A0A0A0A0AEAEAEAEAC8C8A642200000),
    .INIT_57(256'h848484A4A6A6A6A6A6C6C6C6C6C6E8E8E8E8E8E8E8E8E80A2A2A2A2C2C2C4C4C),
    .INIT_58(256'h4242424242424242424242424242424242424242424242424242426264646464),
    .INIT_59(256'h0000000000000000000020222242424242424242424242424242424242424242),
    .INIT_5A(256'h44422222222264A8EE110EAA86424286CCECCA88666644446688444222222222),
    .INIT_5B(256'h2200000000002222224422220000002022424242222222444442222222424244),
    .INIT_5C(256'h2222002222222222220000000022444464868666444444222200222222222222),
    .INIT_5D(256'h2222202222426486442220000022688A8A6866888AAAACAD8A88888822224444),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000020),
    .INIT_5F(256'h0A0A0A0A0A0A0A0AE8E8E8EACAA8844200000000000000000000000000000000),
    .INIT_60(256'hC6C6C6C6C8C8E8E8E8E8E8E8080A0A0A0A0A0A0A0A2A2A2A0A0A0A0A0A0A0A0A),
    .INIT_61(256'h4242424242424242424242424242426262646464646484848486A6A6A6A6A6A6),
    .INIT_62(256'h2242424242424242424242424242424242424242424242424242424242424242),
    .INIT_63(256'hCA444288CCECCA88666464448688424222202022000000000000000000000020),
    .INIT_64(256'h000000224244444222224244444222224242424244444222224266AAEE0EEEEC),
    .INIT_65(256'h0022424444668666646666442222222222222222202020200000202244444422),
    .INIT_66(256'h00226668688A4666888A8A8DAD8A686822222242222222222222222222220000),
    .INIT_67(256'h0000000000000000000000000000000000000000002222222222446664222222),
    .INIT_68(256'hA864220000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'hE8E8E8E8E8E8E8E8E80A0A080808080808E8E8E8E8E8EAEAE8E8E8E8E8E8E8EA),
    .INIT_6A(256'h42424262626464646464648484848484A6A6A6A6A6A6A6C6C6C6C6C8C8E8E8E8),
    .INIT_6B(256'h4242424242424242424242424242424242424242424242424242424242424242),
    .INIT_6C(256'h8686224222202020000000000000000000000000224242424242424242424242),
    .INIT_6D(256'h424242224442222242444442424486CAEEEEECECEC444288CCCCCAA866446464),
    .INIT_6E(256'h6444444442222222222220000000202242444422002020224444422222224242),
    .INIT_6F(256'hAF8A686820002222222222222222222222222222222222444264666664866666),
    .INIT_70(256'h000000000000000022222222222022444422222200226666686A4646688A8A8D),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'hE8E8E8E8E8E8E8E8E8E8E8E8E8C8C8E8E8E8C8A6642200000000000000000000),
    .INIT_73(256'h8484848484A4A6A6A6A6A6A6A6C6C6C6C6C6C8C8E8E8E8E8E8E8E8E8E8E8E8E8),
    .INIT_74(256'h4242424242424242424242424242424242424242424242626264626262626464),
    .INIT_75(256'h0000000000000000202242424242424242424242424242424242424242424242),
    .INIT_76(256'h446486CC0EEECCCAA8424288CACCCAA866424464868622424222222220000000),
    .INIT_77(256'h0000002022444220002242444442202022424242444444424444222222446444),
    .INIT_78(256'h2022224422220022222222424464666644444464666644444442424242222020),
    .INIT_79(256'h2220204244422222202244686868684666888A8DADAD8A682200202222222222),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000222222),
    .INIT_7B(256'hC8C8C8C8C8C8A664200000000000000000000000000000000000000000000000),
    .INIT_7C(256'hA6A6A6C6C6C6C6C6C6C8C8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8C8C8),
    .INIT_7D(256'h424242424242424242424262626262626262626464648484848484A6A6A6A6A6),
    .INIT_7E(256'h4242424242424242424242424242424242424242424242424242424242424242),
    .INIT_7F(256'hCACAAA8864426464866642422222222222000000000000000000000000204242),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_7_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_7_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized27
   (p_3_out,
    clka,
    ram_ena,
    ena,
    addra);
  output [8:0]p_3_out;
  input clka;
  input ram_ena;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [8:0]p_3_out;
  wire ram_ena;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000080),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000080),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000008000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h4222222022222242446444424444222222424264664464CA0EEECAAA64224488),
    .INIT_01(256'h4244666666444444646686666444424242222222200000202244442220224244),
    .INIT_02(256'h68688A666688ACAD8DADAD682220202222222222202222222222000022222222),
    .INIT_03(256'h0000000000000000000000000000000000222244444222224242222222444446),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'hC8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C8A88664422000000000),
    .INIT_06(256'h42626262626262626262646484848484A6A6A6A6A6A6A6A6A6C6C6C6C6C6C8C8),
    .INIT_07(256'h4242424242424242424242424242424242424242424242424242424242424242),
    .INIT_08(256'h2222222222220000000000000000000000204242424242424242424242424242),
    .INIT_09(256'h6464444442422264666686CAEEECCAAA422264A8CAECCA886444646466664444),
    .INIT_0A(256'h6644422222222222222020222244442220222244422222222242444442424244),
    .INIT_0B(256'h2220202222222222222222222222202022222222424466868644444444446466),
    .INIT_0C(256'h000000000000224464444222422222222244444646688A666668ADADADADAD88),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'hC8C8C8C8C8C8C8A8A8A686644222000000000000000000000000000000000000),
    .INIT_0F(256'h646484848484848484A6A6A6A6A6A6A6C6C6C6C6C6C8C8C8C8C8C8C8C8C8C8C8),
    .INIT_10(256'h4242424242424242424242424242424242424242426262626262626262626264),
    .INIT_11(256'h0000000000202242424242424242424242424242424242424242424242424242),
    .INIT_12(256'hECCCCACA422264A8AAECCA886644646666666464422222222222222200000000),
    .INIT_13(256'h22444222202222444422424242424242422222426466664444424244446688CA),
    .INIT_14(256'h2222222022222222424466888844444442222244444444222220202222222222),
    .INIT_15(256'h422222222266664646688A6644468A8DAFAFAD8A222222222222442222222222),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000204244444242),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'hA6A6A6A6A6A6A6A6C6C6C6C6C6C6C6A6A6A6C6C8C8C8C8C8C8A8A68664644222),
    .INIT_19(256'h42424242424242424262626262626262626262626464648484848484848486A6),
    .INIT_1A(256'h4262624242626262624242424242424242424242424242424242424242424242),
    .INIT_1B(256'h6664668666644444422222222222222200000000000000000020224242424242),
    .INIT_1C(256'h44424222222222424466664442226642224486AACCCACAA842226488AAECAA88),
    .INIT_1D(256'h8864444242222022424444422222000022424222224222222022424444424444),
    .INIT_1E(256'h4444686AAFAFAD8A222222222222444422222222222222222222222242446688),
    .INIT_1F(256'h0000000000000000000000000000002022224244442222222266888848688866),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'hA6A6A6A6A6A6A6A6A8A8A6A6A686644422200000000000000000000000000000),
    .INIT_22(256'h626262626262626262626464648484848484848484A4A6A6A6A6A6A6A6A6A6A6),
    .INIT_23(256'h4242424242424242424242424242424242424242424242424242424242626262),
    .INIT_24(256'h4244222202000000000000000020224242424242646464626262626262624242),
    .INIT_25(256'h22226644222266AACACACAA8424264A8CAEEAAA8866666866442424242424222),
    .INIT_26(256'h4442220020424222222222222222424442424464644442222222222244666644),
    .INIT_27(256'h2222444442202222222222222222222242446688886644444242222222222242),
    .INIT_28(256'h0020222222224264664422222244888A68468A684644466AADAD8C8A22424222),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h4242200000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h6464646464848484848484A4A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6868464),
    .INIT_2C(256'h4242424242424242424242424242424242424262626262626262626262626264),
    .INIT_2D(256'h0000202242424242646464626242424242626242424242424242424242424242),
    .INIT_2E(256'h424266AAECEEAA88868686664422446444444442444444222200000000000000),
    .INIT_2F(256'h2242444222224244444444646444444444644442222222222044AAEEECECECCA),
    .INIT_30(256'h2220222222424466868666646444222222222222446664222242444222202022),
    .INIT_31(256'h22446668684666686866468A8AADAF8D22444422202042444220222222424444),
    .INIT_32(256'h0000000000000000000000000000000000000000000022444222224264666444),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h8484848486868686868686848664646442422220200000000000000000000000),
    .INIT_35(256'h4242424242424242626262626262626262626262646464646464646464646484),
    .INIT_36(256'h6262626262626262424242424242424242424242424242424242424242424242),
    .INIT_37(256'h4222446464644442444444222222000000000000000000202242424264646464),
    .INIT_38(256'h4444446444444442222022222044AAEECCCCECEC666686A80EECA88886668666),
    .INIT_39(256'h6644222222222222424444444444444442222020224444222222422242424444),
    .INIT_3A(256'h6AADAF8B42444442222222444422222222446686422222222242444466868686),
    .INIT_3B(256'h0000000000000022000022444222222244646644224268888866446688884668),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h4242222000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h6262626262626262646464646464646464646464646464648484848464646442),
    .INIT_3F(256'h6242424242424242424242424242424242424242426262626242426262626262),
    .INIT_40(256'h4444220000000000000000002242424244646464626262626462626262626262),
    .INIT_41(256'h2244A8ECCAA8A8AAA8AAAACAECCA888666648864444244446464644464664442),
    .INIT_42(256'h4444444444444242424442222242424242424244424464644442644422202222),
    .INIT_43(256'h2222222222446686442222224242444464666686664422222222222222224242),
    .INIT_44(256'h42222220224444424244668AAA8844468888462468ADAD6A2244444222222222),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000002244),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h6464646464646464646464646464626262422020000000000000000000000000),
    .INIT_48(256'h4242424242424242426262626262626262626262626262626262626264646464),
    .INIT_49(256'h2022424242646464626264646464646262626262626262424242424242424242),
    .INIT_4A(256'hCAA8866464668844446464444444666666664444444422000000220200000000),
    .INIT_4B(256'h4242424244424244444444444242666442224242446688EECC886666AACCECEC),
    .INIT_4C(256'h4222424466666666666442222222222222222222224444444464644442424222),
    .INIT_4D(256'hCCCD664466884602468AAB8A2244442222222222222244422222446644222242),
    .INIT_4E(256'h0000000000000000000000000000000000202222422222202022424244424488),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h6462626242200000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h6262626262626262626262626262626264646464646464646464646464646464),
    .INIT_52(256'h6464646462626262626262624242424242424242424242424242424262626262),
    .INIT_53(256'h4444668888444444646442000000020200000000202242424264646462646464),
    .INIT_54(256'h2242646444224242646688EEEEAA866686CAECECCAA886646466884444666644),
    .INIT_55(256'h4442222222222220202242444464444242424242424242424242444466644442),
    .INIT_56(256'h2222422222222222222266664422444444422222222222446466668686644444),
    .INIT_57(256'h00000000002222204242222222424244442244668ACFCD6844446622224488AD),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h6262626264646464646464646464646464646464646442422200000000000000),
    .INIT_5B(256'h6262626262626262626262624242426262626262626262626262626262626262),
    .INIT_5C(256'h0000000000000000002222424264646464646464646464646464626262626262),
    .INIT_5D(256'hECAA86666486A8CC0ECA64424466884444668666644466888866444444444222),
    .INIT_5E(256'h42646664644442424242222222426466664422222020444442222244646688CC),
    .INIT_5F(256'h4422444444444422222222224264668686644244442222222222222222202022),
    .INIT_60(256'h222244444442444488CCEFAC66446644222266AD222222222222222222224466),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000022222042422222),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h6464646464646442424242422000000000000000000000000000000000000000),
    .INIT_64(256'h6242626262626262626262626262626264646262626262626464646464646464),
    .INIT_65(256'h4264646464646464646464646464646464626262626262626262626262626262),
    .INIT_66(256'h64888866666688A886666688AA88444444444422020000000022020000222242),
    .INIT_67(256'h22446464442222222000424442222042446486CACCCA8886646486CAEECC8664),
    .INIT_68(256'h2244668688866664442222222222222222202022424464666664644442424242),
    .INIT_69(256'h6846666644224488222222222222222222204266666466444464664222424222),
    .INIT_6A(256'h0000000000000000000000000022222022422222222242444444444466AACFAD),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h6262626464646262626262626464646464646464646464646464624242422220),
    .INIT_6E(256'h6464646464646462626262626262626262626262626262626262626262626262),
    .INIT_6F(256'hCCAA664444444444220000000022220000002222426464646464646464646464),
    .INIT_70(256'h42200042646486CACAAAA8A8866686AACCCCA88686A88866646486AA888888AA),
    .INIT_71(256'h4242422222222222424244646666646442222222424244442220222220204244),
    .INIT_72(256'h2222222222002244666666644444664444444442222244668888886644222222),
    .INIT_73(256'h00222222222222222222224244664444668AADAD8A6868664422244622222222),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h6464646464646464646464646464424242222200000000000000000000000000),
    .INIT_77(256'h6262626262626262626262626262626262626262626264646464626262626262),
    .INIT_78(256'h0022220000002222424464646464646464646464646464646464646462626262),
    .INIT_79(256'hA8A8A8AAA8AAAAA888A88664444466AAAAA8AAAAEECC88444466666644000000),
    .INIT_7A(256'h666664644442222222424222222022422220424444202042648686CACAA886A8),
    .INIT_7B(256'h4444644444444444442242446688A88644222242424442222222222222224244),
    .INIT_7C(256'h0000000000000000000000000000000022222222222222222200202264668866),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_3_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_3_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ram_ena),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized3
   (\douta[1] ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ,
    clka,
    ena,
    addra);
  output [0:0]\douta[1] ;
  output \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ;
  input clka;
  input ena;
  input [16:0]addra;

  wire \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ;
  wire [16:0]addra;
  wire clka;
  wire [0:0]\douta[1] ;
  wire ena;
  wire [15:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED ;
  wire [15:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB18E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hF082013FFFFF018000684001878F801FE07A070000000FFFFF7FFFFFFFFF1FC7),
    .INIT_01(256'hE018403686002C3C7800FD07B078000000DFFFE3FFFFFFFFFFFF7003F8FFC7F8),
    .INIT_02(256'h02C1C30003987BC3C0000001FFFFFFFFFFFFFFFCFF003F8FF83F9F88403BFFFF),
    .INIT_03(256'hC000780180001FFFFFFFFFFFFFFF8FF000F8FF87F9F804007FFFFC078401EBF2),
    .INIT_04(256'h03FFFFFFFFFFFFFFFC7F800987FC7FDF804007FFFF8038801E3F000F0C100031),
    .INIT_05(256'hFFFFFFEF9800903FC7F9F8080FFFFFF8030803E7F80DF0D90000180003800000),
    .INIT_06(256'h8020183F1F8183FFFFFF8031003E79C09F0D80000000021C0000001FFFFFFFFF),
    .INIT_07(256'h303FFFFFF0001007E7081FF0F80000000070E00000007FFFFFFFFFFFFFFFE3FB),
    .INIT_08(256'h01007D6001FF1F4080001E070180000001FFFFFFFFCFFFFFFE7FFE07000061E0),
    .INIT_09(256'hFDE6000000F00007E000001FFFFFFFFFFFFFFFFFF27FFF0700006607FFFFC000),
    .INIT_0A(256'h30001F00000EFFFFFFFFFFFFFFFFFFFE0FFFFFFE9FE1FFFFF800002007D60007),
    .INIT_0B(256'h47FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFC0000200FD40003FDE3000000F),
    .INIT_0C(256'hFFFFF8FFFFFDE9FFFFFFF7FE7FFC0000200FD40007FFE38000006300007FC380),
    .INIT_0D(256'hFFFF00001FFFE1FFC0000001F500007FFE70000000000003FFFF007FFFFFFFFF),
    .INIT_0E(256'hF80FFC0000400758000FFFFE46000000000000F03400FFFFFCFFFFF0FF30C3FF),
    .INIT_0F(256'h00758000FFFEF00000000000003FFFFF3FFFF3FFF0FFC2E30071FFFFFFFE03FF),
    .INIT_10(256'hFF00000001000003FFFFFFFFFCFFF80FFE0720019FFFFFFFFFFFFF003FC00008),
    .INIT_11(256'h0000386047DF1FFFFF00FFE0200000FFFFFFFFFFFFE001FE00008006D80007FF),
    .INIT_12(256'h71FFFFF807E1C0C00007FFFFFFFFFFFC001FF0001000ED40077FFEF02000003A),
    .INIT_13(256'h000E00007FFFFFFFFFFF0001FE0001000EE405F77FEF43000003B00001C60000),
    .INIT_14(256'hFFFFFFFF80001FE0002001CA700FF7FE66300000380C0013F00001BF9FFFC07E),
    .INIT_15(256'h01DE0004001DEF03EF5FDEF900000380C1FC0000001FFFFFFF03F801F80007FF),
    .INIT_16(256'h9EF000F1FDEE80000030001BE00000007FFFFFF01E001FE0000FFFFFFFFFF000),
    .INIT_17(256'hC00000020001FD0E0C0003FFFFFF01C0027F80007FFFFFFFFE00001C00004001),
    .INIT_18(256'h1FD07180001FFFFFF00C0027FC00C7FFFFFFFFC00003C00008001197000F9FFE),
    .INIT_19(256'hFFFFFF0000043FE00EFFFFFFFFF800007C00018000397800F9FF1C0000000000),
    .INIT_1A(256'h40FF01FFFFFFFFFF0000078000100000D3800E7FE0C000180002007F07F00000),
    .INIT_1B(256'hFFFFE0000077000300001D3007E7FE0C000180000003FFFC000C07FFFFE20000),
    .INIT_1C(256'h0000200003D3000F3800C000000200009FFF8000403FFFFE20000807FC1FFFFF),
    .INIT_1D(256'h3200F9800C000000200009FFFC400003FFFFE30001203FF0FFFFFFFFFC000000),
    .INIT_1E(256'h000002000093FFFF00003FFFFF300016C0FF03FFFFFFFF8001E000000400001D),
    .INIT_1F(256'h7FFFB80001FFFFF30002FC07D83FFFFFFFC0007A000000800001D3C00F9808C0),
    .INIT_20(256'hFFFF80002FFC3F001FFFFFF840071000001000003CFE00FC0D8C000000200001),
    .INIT_21(256'hE1F003FFFFFF8C0065000001000001EA7909C088C0000002000327FF7BC0100F),
    .INIT_22(256'hC000046808002000000727F89C0FCE0000003000203FF31E00807FFFF80005FF),
    .INIT_23(256'h0C00000075C08800F060000002000013FF30E00C03FFFF80005FFF87F801FFFF),
    .INIT_24(256'h000002000001000000051FFBE000F01FFFFC000BFFFE01F80FFFF800004A8080),
    .INIT_25(256'h1801000049BFFF0007803FFFE0017FFFFC00E000FE000001B008018000000668),
    .INIT_26(256'hFF78003803FFFE0017FFFFFE030003C00000BB40001000000064C00000000008),
    .INIT_27(256'hFFF002FFFFFFF808000000000BB4000200000003AE0000000000C1801800045B),
    .INIT_28(256'hFFE04000000000BB4000600000003A6000000000000C010000CCFFFB8001801F),
    .INIT_29(256'h000BF2000C00000003B7000000000000E010300CBFFF9C000001FFFF802FFFFF),
    .INIT_2A(256'h000000BB701000000000060003004B96FDC0000007FFF804FFFFFFFFFA000000),
    .INIT_2B(256'h000000000070000004B84FDC0000003FFFC047FFFFFFFFD000000001FFA00180),
    .INIT_2C(256'h0060004987FCF0000003FFFE083FFFFFFFFE8000000017FA00100000000FB600),
    .INIT_2D(256'hCF0000001FFFF081FFFFFFFFE4000000037E200300000000FF33001800000003),
    .INIT_2E(256'hFF880FFFFFFFFF400000002FC200400000000FD0F80180000000380E00009AFF),
    .INIT_2F(256'hFFFA00000004FC2008000000007D07C01800000003838000082FFE780000007F),
    .INIT_30(256'h9FC2010000000007D0FF01800000601830000082FFE780000001FFFCC07FFFFF),
    .INIT_31(256'h0002FE818018020000018180000C2BBE700000000FFFCF03FFFFFFFF90000001),
    .INIT_32(256'hC1F21C00080C0000B89BE700000000FFFE380FFFFFFFFD800000E3FC60300000),
    .INIT_33(256'hC0001C1FFF2000000001FFF0E03FFFFFFE48000008FF8C06000000007FE40E01),
    .INIT_34(256'h000000000FFF07C07FFFFFE0D800013FE1C0C00000000EFF4ED00C1F20000000),
    .INIT_35(256'hFE3E01FFFFFF07800037FC381000000000A7F5FE00C170000000040000C1FFF0),
    .INIT_36(256'hFB380006FF838300000000027F20300407000000000000060F7F06000000003F),
    .INIT_37(256'h706000000000A7F87E00607800000000000026F3F060080000003FF0780FFFFF),
    .INIT_38(256'h0E7F8FC0060500C00000080003731D860180000001FFC3E07FFFFE7900004FF0),
    .INIT_39(256'h500C000001C20077B0D800080000000FFF1F81FF0007D8000CFE0E0C00000000),
    .INIT_3A(256'h20077B0D4000800000007FF87C0780008C80018F81C180000000006CF8E00070),
    .INIT_3B(256'h0000000003FFC1F0000000640030F818300000000006878CF00787006000001E),
    .INIT_3C(256'hFF0FC0000002200E00070200000000006060CD00387000000001E2002FB0D440),
    .INIT_3D(256'h1CFF0001E04000000000063604C00382000000001FB002E50160000000000007),
    .INIT_3E(256'h000000000467202E001C0000000000BF003E50DE0000000000003FF81F800000),
    .INIT_3F(256'h1A026800C7C000000001E801650DDC000000000001FFE07C000001F007003C08),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram 
       (.ADDRARDADDR(addra[13:0]),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED [15:1],\douta[1] }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED [15:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED [1:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED [1:0]),
        .ENARDEN(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ),
        .ENBWREN(1'b0),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h0400)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_i_1__0 
       (.I0(addra[14]),
        .I1(ena),
        .I2(addra[15]),
        .I3(addra[16]),
        .O(\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_0 ));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized4
   (DOUTA,
    clka,
    ENA,
    ena,
    addra);
  output [0:0]DOUTA;
  input clka;
  input ENA;
  input ena;
  input [15:0]addra;

  wire CASCADEINA;
  wire CASCADEINB;
  wire [0:0]DOUTA;
  wire ENA;
  wire [15:0]addra;
  wire clka;
  wire ena;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ;
  wire [31:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0007FE0000000001F81000000000000000000000000000000003063FFFFFFFFF),
    .INIT_01(256'h0000F000E00000000000000000000000000000003831F7FFFFFFFFC7FF7C3838),
    .INIT_02(256'h000000000000000000000000000001C19FFFFFFFFFF07FF7F1818000FFE00000),
    .INIT_03(256'h0000000000000000000E0CFFFFFFFFFF07FF3F1800003FFC000000007F8FFF98),
    .INIT_04(256'h00000000706FFFFFFFFFF07FF1F0000003FF800000000FF3FFFF800000000000),
    .INIT_05(256'h7FFFFFFFFF07FF0F000000FFF800000201823E7FF7E000000000000000000000),
    .INIT_06(256'h7FF0E006000FFE00000000700F87F7FC000000000000000000000000000003C2),
    .INIT_07(256'hFFC00000000E01F03FFFD000000100000000000000000000001E19FFFFFFFFE0),
    .INIT_08(256'hC0000083FC000000000000000000000000000000C0DFFFFFFFFF07FC1E00C001),
    .INIT_09(256'h00000000000000000000000000000004FFFFFFFFF0FF80E004007FF800000000),
    .INIT_0A(256'h0000000000000000000027FFFFFFFE0FF80E000007FF80000000000000003FC0),
    .INIT_0B(256'h00000000037FFFFFFFE0FE00E00000FFC00000000000000003FC000000000000),
    .INIT_0C(256'hDFFFFFFE0F801E00001FF800000000000000003F800000000000000000000000),
    .INIT_0D(256'h81E40083FE000000000000000003F00100000000000000000000000000000011),
    .INIT_0E(256'h00000000000000000E00000000000000000000000000000000058FFFFFFFE078),
    .INIT_0F(256'h0000003F000000000000000000000000000000000C7FFFFFFE07803C40003BC0),
    .INIT_10(256'h00000000000000000000000000000065FFFFFFE07803FE000738600000000000),
    .INIT_11(256'h000000000000000008030FFFFFFE17C03FE000E61C0000000000000000007000),
    .INIT_12(256'h00000080303FFFFFC1FC177E001C418000000000000000000000780000000000),
    .INIT_13(256'hFFFFFC1FE17FE003F838000000000000000000004000000200F0000000000000),
    .INIT_14(256'hFF103F87C000000000000000000000000000C07F00000000000000000008038F),
    .INIT_15(256'h000000000000000000000000040FF8000000000000000000001CFFFFFF81FE1F),
    .INIT_16(256'h0000000000001000FFC000000000000000000000E7FFFFF81FE3FFF103E1FC00),
    .INIT_17(256'h03003FFF00000000000000000020063FFFFF81FFFFFF307C3F80000000000000),
    .INIT_18(256'h00000000000000020023FFFFF83FFFFFF307C3E0000000000000000000000000),
    .INIT_19(256'h000000013FFFFF017FFFFF38FC7E000000000000000000000000000003FFF800),
    .INIT_1A(256'hFFF003FFFFF3CFCFC00000000000000000000000003000FFFB800F8000000000),
    .INIT_1B(256'hBDE9F80000000000000000000000000F03CF1F3881FC00000000000000000BFF),
    .INIT_1C(256'h00000000000000000001F07FC183FF9FF000000000000000009FFFFF007FFFFF),
    .INIT_1D(256'h00000000309FF83FF3FFFBC00000000000000025EFFFF00FFFFFFFDE3F000000),
    .INIT_1E(256'hFE00E00FEFDE00000000000000025EFFFF01FFFFFFFBE7F00000000000000000),
    .INIT_1F(256'hF00000000000000026FFFFF03FFFFFFFB47C0000000000000000000000000187),
    .INIT_20(256'h0000022FFFFF03FFFFFFB20F800000000000000000000000003EF0E00C007FFC),
    .INIT_21(256'hF03FFFFFF841F000000000000000000000000043FC02008003FFE78000000000),
    .INIT_22(256'h1B0000000000000000000000000E3F002600001FFFFC00000000000000037FFF),
    .INIT_23(256'h0000000000000001C3E000600000FFFDE00000000000000017FFFF07FFFFFF08),
    .INIT_24(256'h00007FFC0000000607FFEF00000000000000013FFFF0FFFFFFF083BC00000000),
    .INIT_25(256'h0780003FFFF8000000000000000BFFFF0FFFFFFFD83380000000000000000000),
    .INIT_26(256'hC0000000000000009FFDF0FFFFFFFD8E60000000000000000000000007FFC000),
    .INIT_27(256'h00000DFFEF0FFFFFFF908E0000000000000000000000067FFC0007F9E001FFFB),
    .INIT_28(256'hFFFFFFF210E00000000000000000000000007FC003FF3B001FFFFE0000000000),
    .INIT_29(256'h40000000000000000000000003F8007FE33000FFFFF0000000000000004FFE70),
    .INIT_2A(256'h000000000000007F000FFE700007FBFF8000000000000004FFFF1FFFFFFE219C),
    .INIT_2B(256'h000FF001FFEF00003FBFF80000000000000027FFF3FFFFFFEC31800000000000),
    .INIT_2C(256'hE40001DFFFC0000000000000027FFF3FFFFF7E87300000000000000000000000),
    .INIT_2D(256'h0000000000000037FFF3FFFFF7E86200000000000000000000000007FE001FFE),
    .INIT_2E(256'h00013FFF3FFFFF7D8C60000000000000000000000000FFE001FFEEC0001FFFFE),
    .INIT_2F(256'hFFFFD0840000000000000000000000001FFE000FFFF80000FFFFE00000000000),
    .INIT_30(256'h0000000000000000000003FFE0003FFF800007FFFE0000000000000013FFF3FF),
    .INIT_31(256'h00000000007FFE0003FFE0000077FFF000000000000000BFFF1FFFFFFD188000),
    .INIT_32(256'hFFE0007FFC000003BFFF8000000000000009FFF3FFFFEFD11000000000000000),
    .INIT_33(256'h00001FFFFC00000000000000DFFF3FFFFFFB1200000000000000000000000007),
    .INIT_34(256'h00000000000004FFF7FFFFFF61200000000000000000000000007FF800063FC0),
    .INIT_35(256'h0047FF7FFFFFF62400000000000000000000000017FE600000FC000000FFFFE0),
    .INIT_36(256'hFE47C0020000000000000000000013FFC600020FC000000FFFFF800000000000),
    .INIT_37(256'h000000000000000000FFF80000203E0000007FFFFC000000000000047FF7BFFF),
    .INIT_38(256'h0000001FFF80000000F8000003FFFFE000000000000067FF7BFFFFE878000000),
    .INIT_39(256'h000000038000003FFFFE000000000000063FFFBFFFFE8F800000000000000000),
    .INIT_3A(256'h0003FFFFF000000000000033FFF9FFFFD0F8000000000000000000000001FFF8),
    .INIT_3B(256'h0000000000037FFF9FFFFD0F800000000000000000000003FFFF000000003800),
    .INIT_3C(256'h13FFFBFFFF20D800000000000000000000004FFFE0000000018000003FFFFC00),
    .INIT_3D(256'h1F80000000000000000000000FFFFC0000000000000001FFFFC0000000000000),
    .INIT_3E(256'h00000000000003FFFF80000000100000001FFFFE400000000000013FFFBFFF06),
    .INIT_3F(256'h00FFFEF00000000188000000FFFFEC00000000000013FFFBFFE043F000000000),
    .INIT_40(256'h000007E000000FFFFFC00000000000011FFFBFFE043E00000000000000000000),
    .INIT_41(256'h007FFFFC00000000000018FFCFFFF1C7C0000000000000000000001FFDFE0000),
    .INIT_42(256'h00000000018FFCFFFF107C0000000000000000000007FFFC80000000007E0000),
    .INIT_43(256'h7FEFFE1387C0000000000000000000007FFF80000000000600000003FFFFC000),
    .INIT_44(256'h000000000000000000001FFFF00000000000000000003FFFFE00000000000008),
    .INIT_45(256'h0000000003FFC000000000001C00000001FFFFF000000000000087FF7FEF38F8),
    .INIT_46(256'hFE000000000001E000000007FFFF000000000000081FE0FFE38F000000000000),
    .INIT_47(256'h007F000000007FFFE800020000000081FE07F9F1F0000000000000000000007F),
    .INIT_48(256'h03FFFE800020000000081FE0FE263E020000000000000000001FFFE000000000),
    .INIT_49(256'h0000000081FF780061E000000000000000000001FFF0000000000003E0000000),
    .INIT_4A(256'hE600065C00000000000000000001FFF000000000000018000000003FFFFC0000),
    .INIT_4B(256'h00000000000000003FFE000000000000038000000002FFFFE00000000000081F),
    .INIT_4C(256'h000003FFC800000000000060000000000FFFFE00600000000041FE001E45C000),
    .INIT_4D(256'h80000000000610000000007FFFE00210000000041F4647EC7800000000000000),
    .INIT_4E(256'h180000000007FFFF00310000000041FEE0FE87800000000000000000007EF9C1),
    .INIT_4F(256'h7FFFF00300000000048FFE3FE8780000000000000000001F9E18000000000000),
    .INIT_50(256'h0000002CFFE7FD8700000000000000000001F9E1800000000000010000000000),
    .INIT_51(256'h7FD06000000000000000000007FFF0000000000000000000000003FFFF801000),
    .INIT_52(256'h000000000000007FFF8000000000000000000000007FFFFC018000000002DFFC),
    .INIT_53(256'h000FFFF8000000000000000000000007FFFFE0180000000025FFFFFD1C000000),
    .INIT_54(256'h000000000000000000004FFFFF01C1000000025F9FFFA1800000000000000000),
    .INIT_55(256'h0000000000FFFFF00C1000000030F9FFFA3C00000000000000000000FFFE0000),
    .INIT_56(256'hFFFF80C1800000010F9FFFC3800000000000000000003FFFC000000000000000),
    .INIT_57(256'h000010FFFFF43800000000000000000003FFFC0000000000000000000000001F),
    .INIT_58(256'h47000000000000000000003FFFE0000000000000000000000001FFFFF80E1800),
    .INIT_59(256'h000000000007FFFF0000000000000000000000001FFFFF80E1800000013FFFFF),
    .INIT_5A(256'h7FFFC00000000000000000000000017FFFFC0E1800000013FFFFF87000000000),
    .INIT_5B(256'h00000000000000000017FFFFC071800000011FFCFF8E00000000000000000000),
    .INIT_5C(256'h000000003FFFFC030800000011FFEFE8E40000000000000000000FFFF0000000),
    .INIT_5D(256'hFFC030400000010FFFFE8C60000000000000000000FFFF000000000000000000),
    .INIT_5E(256'h0019FFFFF0800000000000000000001FFFE00000000000000000000000001BFF),
    .INIT_5F(256'h00000000000000000001FFF800000000000000000000000001FFFFFC01040000),
    .INIT_60(256'h000000003FFF000000000000000000000000001FFFFFE01060000000BFFFFD08),
    .INIT_61(256'hE000000000000000000000000001FFFFFE008600000009FFFF81800000000000),
    .INIT_62(256'h00FFFE00000000001FFFFFF00C600000019FDFFA1800000000000000000007FF),
    .INIT_63(256'h000001FFFFFF00C700000019FCFFA1000000000000000000007FF80000000000),
    .INIT_64(256'hF81C700000018EEFF4100000000000000000000FFF800000047FFFFFFFFE0000),
    .INIT_65(256'h18EEFF4100000000000000000000FFFF00000FFFFFFFFFFFFE000000001FFFFF),
    .INIT_66(256'h00000000000000001FFFF00007FFFFFFFFFFFFFC00000001FFFFFF81C7800000),
    .INIT_67(256'h000001FFFF0001FFFFE07FFFFFFFF800061FFFFFFFFC1E3C00000186EFE81000),
    .INIT_68(256'h00FFFFE00080FFFFFFC000F1FFFFFFFFC0E3C00000187F708000000000000000),
    .INIT_69(256'h003BFFFCE00FFFFFFFFFFC071C00000103F608000000000000000000001FFFF0),
    .INIT_6A(256'hFFFFFFBFFFC079E00000103F7D8000000000000000000003FFFF00BFFFFC0000),
    .INIT_6B(256'h038E00000103F3D0000000000000000000003FFFFFFFFFFE000000000FFFFF00),
    .INIT_6C(256'h3F3A0000000000000000000007FFFFFFFFFFC000000000FFFFF03FFFFEE01FFC),
    .INIT_6D(256'h000000000000007FFFFFFF38380000000001FFFF87FFFFC000F8003C60000012),
    .INIT_6E(256'h0007FFFFFFC303900000000007FFFFFFFFFC00000000C700000139FBA0000000),
    .INIT_6F(256'h00FF00000000007FFFFFFFFE000000000460000013FF9A000000000000000000),
    .INIT_70(256'h0007FFFFFFFFC00000C000020000013FF98020000000000000000000FFFFFFF0),
    .INIT_71(256'hF8000000000030000013FFC8020000000000000000000FFFFFFE00FFF3000000),
    .INIT_72(256'h010000013FFC4000000000000000000001FFFFFF00FFFFF8000000003FFFEFFF),
    .INIT_73(256'hC8000000000000000000003FFFFFC0FFFFFFF000000001FFFFFFFE0000000000),
    .INIT_74(256'h000000000003FFFFF01FFFFFFFC00000000FFFFFFFC0000000000010000011FF),
    .INIT_75(256'h7FFFFE07FFFE1CFE00000000FFFFFFFC0000000000000000019FFC8000000000),
    .INIT_76(256'h0007FE0000001FFF3FFF80000000000000000019FFE800000000000000000000),
    .INIT_77(256'h03FF81FFF00000000000000000018EFE800000000000000000000FFFFFCFFFF0),
    .INIT_78(256'h000000000000000018FFE800000000000000000001FFFFFFFFFE00001FE40000),
    .INIT_79(256'h1800018FFD800000000000000000001FFFFFFFFFF000007FE000003FE01FFE00),
    .INIT_7A(256'h00000000000000000003FFFFFFFFFF800001FF000007FE00FFF0000000000000),
    .INIT_7B(256'h000000003FFFFFFFFFFE00000FF800007FC007FF00000000000000800010FFD8),
    .INIT_7C(256'hFFFFFFFFF000007FC0007FFC007FF00000000000000800010FFD800000000000),
    .INIT_7D(256'h040FFC0007FE0003FF00000000380000800018FF9800000000000000000007FF),
    .INIT_7E(256'hC0003FF00000001F80000800018FF900000000000000000000FFFFFFFFFFFF00),
    .INIT_7F(256'h0039FDC1C08000187F700000000000000000001FFFFFFFFFFFFFFFFFFFE0007F),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("LOWER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(CASCADEINA),
        .CASCADEOUTB(CASCADEINB),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOADO_UNCONNECTED [31:0]),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_B_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h000187C700000000000000000001FFFFFFFFFFFFF0001FFFC00FF80003FF8000),
    .INIT_01(256'h00000000000000003FDFFFFFFFFFC007003FFC00FF80000FF8000003FFFFBE00),
    .INIT_02(256'h000003F0FFFFFFFFF01F8F80FFC01FF000007F8000007FFFFFF0C000087C3000),
    .INIT_03(256'hFFFFF007BDFE01F803FE000007F800007FFFFFFF8C0000878E00000000000000),
    .INIT_04(256'h700F803FE000007F800007FFFFFFFCC0001C31C00000000000000000007F1FFF),
    .INIT_05(256'h0007FC00027FFFFFFFCC0001C33C00000000000000000007F9FFFFFFF8007E7F),
    .INIT_06(256'hCFFFFFFEC0001831C0000000000000000000FFDFFFFFFE00718000000007FC00),
    .INIT_07(256'h01810C0000000000000000000FFDFFFFFF00000000000000FFC000003FC007FF),
    .INIT_08(256'h00000000000001FFDFFFFFE000000000000007FC000001FC007F0001FFFFFC00),
    .INIT_09(256'h003FC1FFFFFC0000000000005FBFC000001FC007800001FFFFC0001811000000),
    .INIT_0A(256'h80000000000000FFFC000001FC00C001F001FFFC000180180000000000000000),
    .INIT_0B(256'h0007FF8000000FE00C00FFC01FFFC000080600000000000000000003F81FFFFF),
    .INIT_0C(256'h00FE000004BF80FFFC0000C0C00000000000000000003F01FFFFF00000000008),
    .INIT_0D(256'h7E07FFC000040800000000000000000007F01FFFFF0040000000C0007FF80000),
    .INIT_0E(256'h60B80000000000000000007F80FFFFE0000000001C001FFF8000000FE0000000),
    .INIT_0F(256'h00000000000FF80FFFFC0000000001C007FFF001E0007C00000000703FFE0000),
    .INIT_10(256'hFE00FFFFC0000000001E007FFC001E000FC00000000301FFE000060D80000000),
    .INIT_11(256'h00000001E003F90001E000FC00000000000FFF00006040000000000000000000),
    .INIT_12(256'h1F00000F000FE00000000020FFF00007000000000000000000001FE00FFFFC00),
    .INIT_13(256'h7F08000000000FFF00003020000000003800000001FE00FFFFC0000000000C00),
    .INIT_14(256'h007FF00003830000000002000000001FF7001FFFE00000000001F9C00000F800),
    .INIT_15(256'h70000000000000000003FFF8000FFFFFFFFFFFFFFCF800000F8007FF80000060),
    .INIT_16(256'h000000003FFFC0000001FFFFFFFFFE02000000FC003FF800000F0003FF800038),
    .INIT_17(256'hFC00000003FFF3FFFFFF0000000FC003FF000000F8003FF80001870000000000),
    .INIT_18(256'hFFFFFFFFF8000000FC001FF000000FC003FF80001860000000000000000003FF),
    .INIT_19(256'h000007E000FD000000FC007FF80001860000000000000000007FFFC00000007F),
    .INIT_1A(256'h9FFC000E0007FFC0004820000000000000000007FFF80000000FC3FE0007FC00),
    .INIT_1B(256'h3FFC0006C60000000000000000007FFFE0000000FC00C0000E000000007F0007),
    .INIT_1C(256'h000000000000000007FFFE0000000FE0000001C000000007F80000FFF0000000),
    .INIT_1D(256'h0000007FFFE00000001F000000F8000000007F80000FFFFC000003FFC0006CE0),
    .INIT_1E(256'h000000007800000C0100000007F80000F8C1C000003FFC00074C000000000000),
    .INIT_1F(256'h000F00F8000000FF800001C007E00001FFC0007CC0000000000000000007FFFF),
    .INIT_20(256'h000FF8000007000FE0001FFC0007E80000000000000000007FFFF000000001F0),
    .INIT_21(256'h3C007FFF83FFE0007E8000000000000000000FFFFF0000000001FFFF827E0000),
    .INIT_22(256'hFE0007E8000000000000000001FFFFF000000000000000FFE0000000FF800000),
    .INIT_23(256'h000000000000001FFFFF0000000038001FFFF9FE00000FF8000001E00003FE7F),
    .INIT_24(256'h0001FFFFF00000001FFFFFFFFF0FF00000FF8000000700000FFFFFE0007E0000),
    .INIT_25(256'h00003FFFFFFFFF807F00000FF80000001800007FFFFE0007F000000000000000),
    .INIT_26(256'hFFF00FE00000FF80000001F00003FFFFE0007F0000000000000000001FFFFF00),
    .INIT_27(256'h0FF80000000FE0001FFFFE0007F0400000000000000001FFFFF0000003FFFFFF),
    .INIT_28(256'h7FE000FFFFE0007F4000000000000000001FFFFF8000003FFFFFFFFE01FE0000),
    .INIT_29(256'h0007F4000000000000000000FFFFF8000003FFFFFFFFE07F000000FF80000000),
    .INIT_2A(256'h00000000000007FFFF8000003FFFFFFFFF07E000000FF800000003FFF1FFFFFE),
    .INIT_2B(256'h003FFFF8000001FFFFFFFFC03C0000007F800000000F87FFFFFFE0007FC00000),
    .INIT_2C(256'h000FFFFFFFF803C0000007F800000000F8003FFBDE0003F00000000000000000),
    .INIT_2D(256'h00F80000007F8000000003C0007E1FE0003F00000000000000000003FFFFC000),
    .INIT_2E(256'hF8000000001E000000FE0003D000000000000000000013FFFE0000007FFFFFFF),
    .INIT_2F(256'hF0000004E0003D00000000000C000000003FFFE0000007FFFFFFE03F80000007),
    .INIT_30(256'h03D00000000001E000000003FFFE0000007FFFFFFC03F80000003F8000000000),
    .INIT_31(256'h001F000000001FFFF0000003FFFFFF001F80000001F800000000078000000E00),
    .INIT_32(256'h003FFF00000003FFFF0003E00000001F80000000003C000000E0003D00E00000),
    .INIT_33(256'h000FFF00003800000001F80000000001E000000E0003D00E0000000060000000),
    .INIT_34(256'h000000001F80000000000F000000E0003F0060000000000000000003FFF00000),
    .INIT_35(256'h00000000007800001E0001F0060000000000000000003FFF0000000003E00000),
    .INIT_36(256'hE00001E0003C0060000000000000000003FFF0000000000000000000000001F0),
    .INIT_37(256'hE2020000000000000000001FFF8000000000000000000000000F000000000003),
    .INIT_38(256'h000000000001FFF8000000000000000006000000F000000000003F00001E0002),
    .INIT_39(256'h1FFFC00000000000000007F0000004000000000001FC0000E0006F6000000000),
    .INIT_3A(256'h0000000001FF0000000000000000000FF0000E0007F600000000000000000000),
    .INIT_3B(256'hE000000000003E0000007F8000E000FFE000000000000000000001FFFE000000),
    .INIT_3C(256'h03F8000003F0000E000FFE000000000000000000001FFFE0000000000000003F),
    .INIT_3D(256'h80006000FFE000000000000000000001FFFF000000000000000FFC0000000000),
    .INIT_3E(256'h000000000000000000001FFFF800000000000007FF8000000000003FC000003F),
    .INIT_3F(256'h0000000001FFFFC0000000000000FFF0000000000001FE000001FC0006000FFC),
    .INIT_40(256'hFFFC0000000000003FFF0000000000001FF000000FE0006000FB800000000000),
    .INIT_41(256'h00000FFCE0000030000000FF8000003E0006001F70000008000000000000001F),
    .INIT_42(256'h001F8007C00FFC000003F000E001FF00E0000000000000000001FFFF80000000),
    .INIT_43(256'h7FE000003F0006001FF0080000000000000000000FFFF8000000000001FF0E00),
    .INIT_44(256'h006001BF0080000000000000000000FFFFC00000000000FFF0C0007FFFFFFFC0),
    .INIT_45(256'h0000000000000000000FFFFE00000000007FFE0C000FFFFFFFFE07FF000003F8),
    .INIT_46(256'h00000000FFFFF000000001FFFF80E00FFFFFFFFFE077FC00000F80060007F008),
    .INIT_47(256'hFF800000003FFFF00FBFFFFFFFFFFF037FF800003800E000FF00000000000000),
    .INIT_48(256'hFFFE00FFF8001FFFFFF837FFE00003C00E001FF0000000000000000000000FFF),
    .INIT_49(256'h000FFFFFF3FFFF00007E00E001FF0000000000000000000000FFFFFFFFFFFFFF),
    .INIT_4A(256'hFFFFF80FE00E000FA0000000000000000000000FFFFFFFFFFFFFFFFEC007FC00),
    .INIT_4B(256'hE000F60000000000000000000000FFFFFFFFFFFFFFFFF000080000001C01FFBF),
    .INIT_4C(256'h00000080000000000FFFFFFFFFFFFFFFFC000000000000000FFF8FFFFFC0FE00),
    .INIT_4D(256'h0000007FFFFFFFFFFFFFF000000000000000003FF07FFFFF8FF01E000FE00000),
    .INIT_4E(256'hFFFFFFFFFF8000000000000000707F01FFFFF8FFC7E001EC0000000000040000),
    .INIT_4F(256'h000000000000000001F00FFFFFFFFC7E003FC00000000000400000000001FFFF),
    .INIT_50(256'h0000000E001FFFFFFFFFE003FC00000000000000000000001FFFFFFFFFFFFFF0),
    .INIT_51(256'h7FFFFFFFFE003FC00000000000000000000001FFFFFFFFFFFFFC000000000000),
    .INIT_52(256'h037800020000000000000000001FFFFFFFFFFFFE000000000000000000004000),
    .INIT_53(256'h000C000000000001FFFFFFFFFFFFC0000000000000000000000003FFFFFFFFE0),
    .INIT_54(256'h00001FFFFFFFFFFFFC0000000000000000000000001FFFFFFFFC002780002000),
    .INIT_55(256'hFFFFFFC0000030000000000000000000FFFFFFFFC000F80000000000E0000000),
    .INIT_56(256'h0380000000000000000007FFFFFFFC000F80003000000F000000000001FFFFFF),
    .INIT_57(256'h00000000001FFFFFFFC000F80003800000F820000000001FFE0E0C9FE3FC0000),
    .INIT_58(256'hFFFFFFFC000F800008000007820000000001FFC00000BC3C0000007800000000),
    .INIT_59(256'hF80000C000003E00000000001FFE0000001F8000000780000000000000000007),
    .INIT_5A(256'h01E00000000000FF8000000000000000780000000000000000007FFFFFFFC000),
    .INIT_5B(256'h000F80000000000000000FC0000000000000000003FFFFFFFC000F10001C8000),
    .INIT_5C(256'h0000000000FE00000000000000000003FFFFFFC000F10000C830001E00000000),
    .INIT_5D(256'hE00000000000000000001FFFFFFC001E000000810010F0000000000070000000),
    .INIT_5E(256'h0000000001FFFFFF8001E000000000010380000000000200000000000000001E),
    .INIT_5F(256'hFFFFF8003CC0000CE00018300000000000200000000000000001C7E000000000),
    .INIT_60(256'h00004FC000C30000000000000000000000000000387FC000000000000000001F),
    .INIT_61(256'h01F80000000000000000000000000703FC000000000060000001FFFFFF8003CC),
    .INIT_62(256'h000000000000000000603FFC000000001E00000007FFFFF80039E000007C000E),
    .INIT_63(256'h0000000E01FFF00000000F010000003FFFFF800390C000018002E01F80000000),
    .INIT_64(256'hFF80000003F038000001FFFFF800390C000038003F00FF000000000000000000),
    .INIT_65(256'h078000001FFFFF000310E00003C003F00310000000000000000000000001C01F),
    .INIT_66(256'hFFF00032038000F8213F80010000000000000000000000001801FFF80000007F),
    .INIT_67(256'h000E031BF8003E000000000000000000000001801FC000000003FFF80000003F),
    .INIT_68(256'h010000000000000000000000003801F0000000003FFF80000001FFFF00070038),
    .INIT_69(256'h000000000000000383F80000000001DFF80000001FFFF000600300000031FFC0),
    .INIT_6A(256'h00003FFF0000000000007FC0000001FFFF000E07000000001FF8000000000000),
    .INIT_6B(256'h0000000001FC0000000FFFE000C07000000003E1000000000000000000000000),
    .INIT_6C(256'hC0000001FFFE000C0F000000003C000000000000000000000000000003F80000),
    .INIT_6D(256'hE001C1E00000000300000000000000000000000000000000000000000000001F),
    .INIT_6E(256'h00002000000000000000000000000000000000000000000000007C0000001FFF),
    .INIT_6F(256'h000000000000000000000000000000000000000003E0000001F7FE00181E0000),
    .INIT_70(256'h0000000000000000000000000000001E0000001F7FC00181F000000020000000),
    .INIT_71(256'h0000000000000000000000000000E3FC00183E00000003000000000000000000),
    .INIT_72(256'h00000000000000000E3FC00187E0000000300008000000000000000000000000),
    .INIT_73(256'h000001E3F80018FE000000030000C00000000000000000000000000000000000),
    .INIT_74(256'h030FF000000020000C0000000000000000000000000000000000000000000000),
    .INIT_75(256'h02000020000000000000000000000000000000000000000000000000003F3F80),
    .INIT_76(256'h000000000000000000000000000000000000000000000003F3F80031FD000000),
    .INIT_77(256'h0000000000000000000000000000000000003F3F00033F900000000000000000),
    .INIT_78(256'h00300000000000000000000007F7F00063FB8000000000000000000000000000),
    .INIT_79(256'h000000000000007F7F00063FB800000000000000000000000000000000000000),
    .INIT_7A(256'h0007F7E00067FFC0000000000000000000000000000000000000000780003C00),
    .INIT_7B(256'h7CFC00000000000000000000000000000000000000007C1E0FF00F0004000000),
    .INIT_7C(256'h0000000000000000000000000000000007E3F9FF83F8F0E000000000FF7E000E),
    .INIT_7D(256'h00000000000000000000207F7FDFFCFFDF9E000000000FF7E000E79F80000000),
    .INIT_7E(256'h00000000030FFFFFFFDFFFFFEC00000000FEFC000C39F8000000000000000000),
    .INIT_7F(256'hFFFFFFFFFFFFFFC00000000FEFC00183FFC00000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("UPPER"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T 
       (.ADDRARDADDR(addra),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(CASCADEINA),
        .CASCADEINB(CASCADEINB),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOADO_UNCONNECTED [31:1],DOUTA}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.CASCADED_PRIM36.ram_T_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized5
   (\douta[2] ,
    clka,
    \addra[15] ,
    ena,
    addra);
  output [0:0]\douta[2] ;
  input clka;
  input \addra[15] ;
  input ena;
  input [14:0]addra;

  wire [14:0]addra;
  wire \addra[15] ;
  wire clka;
  wire [0:0]\douta[2] ;
  wire ena;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hFFFC00000000FE7C00183FFE0000000000000000000000000080000000000038),
    .INIT_01(256'h1FE7800181FFF00000000000000000000000001C0000000000008FFFFFFFFFFF),
    .INIT_02(256'hFF0000000000000000000000000000000000000000FFFFFFFFFFFFFF80000000),
    .INIT_03(256'h0000000000000000000000000000000FFFFFFFFFFFFFF800000003F87800180D),
    .INIT_04(256'h000000000000000000007FFFFFFFFFFFFF800000007FC7000100FFF000000000),
    .INIT_05(256'h0000000007FFFFFFFFFFFFF000000007FCF0001007F200000000000000000000),
    .INIT_06(256'h7FDFFFFFFFFE000000007FCE0001063F60000000000000000000000000000000),
    .INIT_07(256'hC00000000FFFE00010F7F0000000000000000000000000000000000000000004),
    .INIT_08(256'hFE00031FFF00000000000000000000000000000000300000000001F8FFFFFFFF),
    .INIT_09(256'h0000000000000000000000000000000000000000000000F8FFFF980000003FFF),
    .INIT_0A(256'h00000000000000000000000000000000000000016000000007FFFFC00031FFF8),
    .INIT_0B(256'h000000000000000000000000000000000000003FFFFC00033FFFC00000000000),
    .INIT_0C(256'h0000070000000000000000018003FFFFC00033FFF80000000000000000000000),
    .INIT_0D(256'h0000000000001E003FFFFC00037FFF8000000000000000000000000000000000),
    .INIT_0E(256'h07F003FFFF800037FFF000000000000000000000080000000300000F00FF3C00),
    .INIT_0F(256'h00037FFF00000000000000000000000000000C000F003D1FFFFE000000000000),
    .INIT_10(256'h000000000000000000000000030007F001F8FFFFE0000000000000FFC03FFFF0),
    .INIT_11(256'h000007800000000000FF001FDFFFFF0000000000001FFE01FFFF000037FFF800),
    .INIT_12(256'h00000007F81E3FFFFFF8000000000003FFE00FFFE000033FFF80000000000000),
    .INIT_13(256'hFFFFFFFF800000000000FFFE01FFFE000023FFF8000000000000000000380000),
    .INIT_14(256'h000000007FFFE01FFFC000060FFF000000000000000000000000000060003F81),
    .INIT_15(256'hFE21FFF8000020FFF000000000000000000000000000000000FC07FFFFFFF800),
    .INIT_16(256'h020FFF000000000000000000000000000000000FE1FFFFFFFFF0000000000FFF),
    .INIT_17(256'h0000000000000000000000000000FE3FFE7FFFFF8000000001FFFFE3FFFF8000),
    .INIT_18(256'h00000000000000000FF3FFE7FFFF38000000003FFFFC3FFFF0000070FFF00000),
    .INIT_19(256'h000000FFFFFC3FFFF10000000007FFFF83FFFE00000707FF0000000000000000),
    .INIT_1A(256'hC0FFFE0000000000FFFFF87FFFE00000307FF000000000000000000000000000),
    .INIT_1B(256'h00001FFFFF88FFFC0000030FFF000000000000000000000000000000001DFFFF),
    .INIT_1C(256'hFFFFC0000030FFF000000000000000000000000000000001DFFFF807FFE00000),
    .INIT_1D(256'h0DFF000000000000000000000000000000001CFFFF003FFF0000000003FFFFFF),
    .INIT_1E(256'h00000000000C00000000000000CFFFF000FFFC000000007FFFFFFFFFF8000003),
    .INIT_1F(256'h800000000000000CFFFE0007FFC00000003FFFFBFFFFFF000000303FF0000000),
    .INIT_20(256'h00007FFFE0003FFFE0000007BFFF1FFFFFE000000381FF000000000000000000),
    .INIT_21(256'h01FFFC00000073FFE1FFFFFE0000001806F00000000000000000180000000000),
    .INIT_22(256'h3FFFFC0FF7FFC00000008007000000000000000001C000000000000007FFFC00),
    .INIT_23(256'hF00000000C3F7000000000000000000C000000000000007FFFC00007FFFE0000),
    .INIT_24(256'hFF000000000000000000E000000000000003FFF8000001FFF00007FFFFC0FF7F),
    .INIT_25(256'h0000000006400000000000001FFF00000000FFFF01FFFFF807F7FE00000001E7),
    .INIT_26(256'h00000000000001FFF000000003FFFC3FFFFF807FFFE00000001C3FF000000000),
    .INIT_27(256'h000FFE000000000FFFFFFFFFF807FFFC0000000061FF00000000000000000024),
    .INIT_28(256'h00007FFFFFFFFF807FFF80000000061FF0000000000000000003000000000000),
    .INIT_29(256'hFFF803FFF00000000070FF00000000000000000040000000000000007FE00000),
    .INIT_2A(256'h000000070FE00000000000000000046900000000000007FC0000000003FFFFFF),
    .INIT_2B(256'h00000000000000000047B00000000000003FC0000000001FFFFFFFFF803FFE00),
    .INIT_2C(256'h000000067800000000000001F80000000000FFFFFFFFF003FFE00000000071FF),
    .INIT_2D(256'h0000000000000F800000000007FFFFFFFF003FFC00000000030CF00000000000),
    .INIT_2E(256'h007800000000007FFFFFFFE003FF800000000030070000000000000000006700),
    .INIT_2F(256'h0003FFFFFFFC003FF000000000030030000000000000000007F0000000000000),
    .INIT_30(256'h8003FE000000000030000000000000000000007F0000000000000003C0000000),
    .INIT_31(256'h0000018000000000000000000003F4400000000000003F00000000001FFFFFFF),
    .INIT_32(256'h00000000000000007F6400000000000001F80000000001FFFFFFE0007FC00000),
    .INIT_33(256'h000003E0000000000000000FE0000000000FFFFFF8000FF800000000001C0000),
    .INIT_34(256'h000000000000FFC000000000FFFFFF0001FF000000000000C020000000000000),
    .INIT_35(256'h01FE0000000007FFFFF0003FE000000000400C010000000000000000003E0000),
    .INIT_36(256'h003FFFFE0003FC000000000C00E000000000000000000001F080000000000000),
    .INIT_37(256'h7F80000000004007FE0000000000000000001F0C000000000000000FF8000000),
    .INIT_38(256'h00007FC0000200000000000000FCE2000000000000003FE000000001FFFFC000),
    .INIT_39(256'h200000000000000FCF2000000000000000FF800000001FFFFC000FF000000000),
    .INIT_3A(256'h0000FCF20000000000000007FC00000000FFFF8001FE00000000000007E00000),
    .INIT_3B(256'h0000000000003FF000000007FFF0001FC00000000000007C0000000000000000),
    .INIT_3C(256'h00FFC00000003FFE0007FC0000000000001FC20000000000000000001FCF2000),
    .INIT_3D(256'h00FF0001FF80000000000001FC30000000000000000001F8FE00000000000000),
    .INIT_3E(256'h0000000000001FE10000000000000000000F8F200000000000000007FF800000),
    .INIT_3F(256'h01FE10000000000000001000F8F220000000000000001FFC0000000000003FF0),
    .INIT_40(256'h0000000001000F8FE200000000000000007FF0000000000007FE000000000000),
    .INIT_41(256'h01F0BC000000000000000001FFE00000000000FFC00000000000000FF3000000),
    .INIT_42(256'h0000000000000FFFC0000000003FF800000000000009FF100000000000000000),
    .INIT_43(256'h003FFF800000001FFF000000000000005FF80000000000000000000F0B800000),
    .INIT_44(256'h0003FFE000000000000007FFC0000000000000000000E0B00000000000000000),
    .INIT_45(256'h00000000007FFE0000000000000000000E1F000000000000000000001FFFF800),
    .INIT_46(256'hFFE0000000000000000000E1F0000000000000000000007FFFF00007FFFC0000),
    .INIT_47(256'h00000000000F1F8000000000000000000000FFFFF807FFFFC000000000000007),
    .INIT_48(256'hF1F80000000000000000000001FFFFFFFFFFF8000000000000007FFF00000000),
    .INIT_49(256'h000000000000001FFFFFFFFFFF0000000000000007FFF0000000000000000000),
    .INIT_4A(256'h000000FFFFFFFFE0000000000000003FDF0000000000000000001E1F04000000),
    .INIT_4B(256'hFF380000000000000003FEF0000060000000000001B0F0400000000000000000),
    .INIT_4C(256'h000000003FE70000020000000000001F8F04000000000000000000000003FFFF),
    .INIT_4D(256'h70000000000000000001F9F00000000000000000000000000079FE0000000000),
    .INIT_4E(256'h000000001F8F00000000000000000000000000000000400000000000000003FE),
    .INIT_4F(256'hE00000000000000000000000000000000000000000000000003FE30000000000),
    .INIT_50(256'h0000000000000000000000000000000000000001FE10000000200000000001F0),
    .INIT_51(256'h00000000000000000000000000001FC10000008000000000001F1F0000000000),
    .INIT_52(256'h000000000000000003FE10000018000000000001F1F000000000000000000000),
    .INIT_53(256'h0000003FF10000018000000000001F1F00000000000000000000000000000000),
    .INIT_54(256'h000018000000000001F1F8000000000000000000000000000000000000000000),
    .INIT_55(256'h0000003F1F80000000000000000000000000000000000000000000000003FF30),
    .INIT_56(256'h0000000000000000000000000000000000000000000000003FF8000000C00000),
    .INIT_57(256'h00000000000000000000000000000000000003FF80001007000000000003F1F0),
    .INIT_58(256'h000000000000000000000000003FE90000001000000000003FFE200000000000),
    .INIT_59(256'h0000000000000001BED0000000000000000003CFE20000000000000000000000),
    .INIT_5A(256'h000019E60000000000000000001CFC2018000000000000000000000000000000),
    .INIT_5B(256'h0001800000000001C3C201800000000000000000000000000000000000000000),
    .INIT_5C(256'h00001F1C631C0000000000000000000000000000000000000000000000DF2000),
    .INIT_5D(256'hC0000000000000000000000000000000000000000000000CF30000001C000000),
    .INIT_5E(256'h000000000000000000000000000000000000CF10000000E00000000001F1E61F),
    .INIT_5F(256'h00000000000000000000000000000002000700000000001FFFC1FE0000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(1),
    .READ_WIDTH_B(1),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(1),
    .WRITE_WIDTH_B(1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:1],\douta[2] }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(\addra[15] ),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized6
   (p_87_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_87_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_87_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h8F8F8F9191918F91919191919191919191919191919191919191919191919191),
    .INIT_01(256'h6464646664646466868686866686AACA8642444444666A8D8F8F8F8F91918F8F),
    .INIT_02(256'h0000000000000000000000000000000022000000002022222222224242426464),
    .INIT_03(256'h2222222022222220202222222020000000000000000000000000000000000000),
    .INIT_04(256'h6466668664646664648686646464646464444242424242424242422222222222),
    .INIT_05(256'hA8A8A8A888866686666686888664646686868686666466868686868688888666),
    .INIT_06(256'h4466866644424244444242424242424242446664646666644444646666668688),
    .INIT_07(256'h8F8F8D6D8DAF8F8D8D8D8D8B8B8A688868686646666866644444424264644444),
    .INIT_08(256'h91918FB1B18F8F8F8FB1B18F8F8F8F8F8F8FB1B1B18F8F8F8F8FAFB1B18F8F8F),
    .INIT_09(256'h9191919191919191919191919191919191919191B1B1B1B1B1B16D6B6DB1B1B1),
    .INIT_0A(256'h866686CAA88644424444666A8DAFAF8F8F91918F8F8F8F9191918F9191919191),
    .INIT_0B(256'h0000002222220000002222222222224242426444646464666466646686866686),
    .INIT_0C(256'h2020000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h6466646464644242424242424242424222222222222222222222222022222222),
    .INIT_0E(256'h88A8888666668688888686868686646686868664646466646464646464646464),
    .INIT_0F(256'h4222424244446464646464444264868688A8A8A8888686666464668688868686),
    .INIT_10(256'h6868686846666668888866444444424244444244446464444242424242424242),
    .INIT_11(256'hB1B1B1B18F8F8FB1B18F8F8F8F8F8FAFB18F8F8F8D8D8D8D8D8D8FAF8D8D8D8B),
    .INIT_12(256'h9191919191919191B19191918F8F6B4B8DB1B19191918FB1B1B1B18F8F8FB1B1),
    .INIT_13(256'h6AAFAFB18F9191918F8F8F8F8F8F8F9191919191919191919191919191919191),
    .INIT_14(256'h202222424444444464646466646664646666646686646488A8A8664444444446),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000002020),
    .INIT_16(256'h4242424242424222222222222222222222222222222020200000000000000000),
    .INIT_17(256'h8686666666868666646464646464646466868686866664646464646444424242),
    .INIT_18(256'h86A8A8A8AACCCAAAA8868686A8A8A8A8A8A8A8A8A8A8A8A8A88688A8A8888686),
    .INIT_19(256'h4244424242424244444242424242444222224242424244646464646664644464),
    .INIT_1A(256'h8F8F8F8FAF8F8F8D8D6D8DAFAFAF8D8D8D8B8A68684646666646668866664442),
    .INIT_1B(256'h8F8D4B6B8DB1B191919191B1B1B1B1B18F8F8FB1B1B1B1B18F8F8FB1B18F8F8D),
    .INIT_1C(256'h8F8F9191919191919191919191919191919191919191919191919191B1B1B1B1),
    .INIT_1D(256'h44646464646464668664446686A8A86664424244668AADAF918F91918F8F8F8F),
    .INIT_1E(256'h0000000000000000000000000000000000000000202022424242424464444444),
    .INIT_1F(256'h2222424222222222222222222000000000000000000000000000000000000000),
    .INIT_20(256'h6464646464868686646464646464646464646464444442424242424222424222),
    .INIT_21(256'hCCCCAA88A8A8A8A8A8A8AACAA8A8A8A888888686888888868686868686646464),
    .INIT_22(256'h424244422222424264646666646464646444646688A88888A8AAAAA88686A8CA),
    .INIT_23(256'h8F8D8B6B6B8B6868464646666666888866444422424242424242444242424242),
    .INIT_24(256'hB1B1B1B18F8F8FB1B1B1B1B18F8F8F8F8F8F8F8D8FAFAF8F8F8F8F8F8D8D8F8F),
    .INIT_25(256'h91919191919191919191919191919191B1B1B1B18F6D4B6BAFB1B1B1919191B1),
    .INIT_26(256'h4486CC88866442444446688DB18F8F8F8F8F8F8F8F8F91919191919191919191),
    .INIT_27(256'h0000000000000020202022222222224444424242424464644444646666666644),
    .INIT_28(256'h2222000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h6464646464646464646444444442444242424242224242444222222222222222),
    .INIT_2A(256'hA8A8A88888A8A8A8A8A8A8868686868686866464646464646464646464646464),
    .INIT_2B(256'h444264444464868688868666668686868686AACCECCAA8648688A8A8A8CACACA),
    .INIT_2C(256'h6888888866444222424242424242422242424242424242424242424464668866),
    .INIT_2D(256'h8F8F8F8F8F8F8F6D8FB1AF8F8F8D8F8F8FAF8D6D8D8D6B6B6868664646666646),
    .INIT_2E(256'h91919191B1B1B1B18F6D4B8DAFB1B1B1919191B1B1B1B1B18F8F8F8FB1B1B1B1),
    .INIT_2F(256'hAFAF8F8F8F8F8F8F8F8F8F919191919191919191919191919191919191919191),
    .INIT_30(256'h22424264644442424242446442446466668666644466AA88A88664644222246B),
    .INIT_31(256'h0000000000000000000000000000000000000000000000222222222222222222),
    .INIT_32(256'h4444444242424442424244444222222222222222222222202020000000000000),
    .INIT_33(256'h8686868686868686646464646464646464646464646464646486868686646444),
    .INIT_34(256'h6486868688A8AACAA88664668688A8A8AACACAAA86AAAAA8AACACACAAAA8A886),
    .INIT_35(256'h4242422042424242422222424444446464668664422264446488AAA886868664),
    .INIT_36(256'h8F8D8FAFAF8D6D6D8D8D8B6B4646464666686644888866442222224242424242),
    .INIT_37(256'hB191B1B1B19191B1B1B1B1B18FAFAFAFB1B1B18F8F8F8F8F8F8F8D8DAFB1B18F),
    .INIT_38(256'h919191919191919191919191919191919191919191919191B1B1B1916D6B498D),
    .INIT_39(256'h444444646464646444646686A8888666444442448AAF8F9191918F8FAF8F8F8F),
    .INIT_3A(256'h0000000000000000000000202022222222222222424244424242424242424242),
    .INIT_3B(256'h4442424242224242422222222222222222202000000000000000000000000000),
    .INIT_3C(256'h646464646464646464646464648686A8A8866464646464646464644442424444),
    .INIT_3D(256'h868688A8AAA8A8A888A8CACACCCACCCAAAA888A8A88686666464646444424464),
    .INIT_3E(256'h424244646664444242444464A8AAA8868686868664648688A8A8A8A886646486),
    .INIT_3F(256'h4644666868686866886644422222424242424242222222224242222242424242),
    .INIT_40(256'hAFAFAFAFB1B1B18F6D8F8F8F8F8F8F8FB1B18F8F8F6D8DAFAF8D8D8D8D8B8B68),
    .INIT_41(256'h919191919191919191919191B1B1B1B16D6B6B8DB18F9191B1B1B1B1B1B18FAF),
    .INIT_42(256'h888866644442424446688F9191918F8F8F8F8F8F919191919191919191919191),
    .INIT_43(256'h0022222222222222224242222242424242424242424242446464644444446486),
    .INIT_44(256'h2222222222202020000000000000000000000000000000000000000000002020),
    .INIT_45(256'h6486868686866664646464646464646464646464444242424242424244444222),
    .INIT_46(256'hCACACCCAAAA88686866464646464646444444444444444646464646464646464),
    .INIT_47(256'h888686646464646464648686868686666464668686868686888686868688A8CA),
    .INIT_48(256'h4242424242424242222242424242424242424242424444644444644444446466),
    .INIT_49(256'h8F8F8F8F8FAF8F8F8D8D8F8F8D6B8DAD8D686846464666686868666666444242),
    .INIT_4A(256'hAFB1B1916D6B6B8FB191918FB1B1B3B1B18F8F8FAFAFAFAFB1B1B18F8F8F8F8D),
    .INIT_4B(256'h91918F8F8F8F8F8F8F91919191B1B19191919191919191919191919191919191),
    .INIT_4C(256'h4242444242424242424242444444444444444466866664646444424244246B8F),
    .INIT_4D(256'h0000000000000000000000000000000000202020000020222222222222224222),
    .INIT_4E(256'h8686866464646464644242444442424244424242224242422222202020202000),
    .INIT_4F(256'h6464646464646464644444646464646464646464668686866666868664646686),
    .INIT_50(256'h866464646464666666666464666666868686A8AACACACCCACAA8866464646464),
    .INIT_51(256'h4242424242424242444444444444646464668686866664644264646464666686),
    .INIT_52(256'h6B8BAD8D8B464646466666686866464444444242424242424242422222424242),
    .INIT_53(256'h91B1B1B1B18F8F8FAFAFAFAFB1B1B18F8F8F8F8D8F8F8F8F8F8F8F8F8D8F8F8F),
    .INIT_54(256'hB1B1919191919191919191919191919191919191AFB1B1916D4B6BAFB1B1918F),
    .INIT_55(256'h444444644444446466644444666442424422488DB191918F8F8F8F8F91919191),
    .INIT_56(256'h0000000000202020200000202222222222222222424444444242424242424242),
    .INIT_57(256'h6442424242424242424242444222222222222220000000000000000000000000),
    .INIT_58(256'h4444646464646464646464646464648464648486868686868686646464646464),
    .INIT_59(256'h646464668686A8AAAACACACAAAA8866686868664646464646464646464646464),
    .INIT_5A(256'h4244646464868686666464424264646464868686664442446464646664646464),
    .INIT_5B(256'h6846442444444444424242424242222222224242424242444242424244446444),
    .INIT_5C(256'hB1B1B18F8F8F8F8D8D8F8F8F8F8F8F8F8D8F8F8D6B8DAD8B6846444666666668),
    .INIT_5D(256'h9191919191919191B1B1B1916D6B6BAFB1B1B18F8FB1B18F8F8FAFAFAFAFB1B1),
    .INIT_5E(256'h646464442222446A8F9191918F8F8F8FB1B19191919191919191919191919191),
    .INIT_5F(256'h2022222222222222224244444444422242424242444444444444446466644444),
    .INIT_60(256'h4242222222222222222000000000000000000000000000002020202000002020),
    .INIT_61(256'h6464646464648686868464648686866464646464646262424242424242444444),
    .INIT_62(256'hA886868686868686646466666464646464644444444444446464444444444442),
    .INIT_63(256'h4264646464868666644242644444446464646464646466868686A8AAAACAAAA8),
    .INIT_64(256'h4222202222222222424242424242424244444444444464646686866464444242),
    .INIT_65(256'h8F8F8D8D8F8F8D8D8D8D8D684666444666666666464424244444444442424242),
    .INIT_66(256'h6B6B8D8FB1B1B1918F8F8F8FAFAFAFAFAFB1B1B1B1B1B18F8FB1AF8D8D8F8F8F),
    .INIT_67(256'h8F8F8F8FB19191919191919191919191919191919191919191919191B1B1B1AF),
    .INIT_68(256'h444442224242424242424244444444646464444444446444424444466B8FB1B1),
    .INIT_69(256'h0000000000000000000000200020200000202222202020222222222222222242),
    .INIT_6A(256'h6484848684646464646484846442424242646444424242222222222222222000),
    .INIT_6B(256'h8666646464646464444444444444424242424242626464646484868684646464),
    .INIT_6C(256'h4242424244646464646686868686A8AAAAAAA8A88888A88686866464648688A8),
    .INIT_6D(256'h4244444442424444446464646686644242424242446464646486666444424242),
    .INIT_6E(256'h6646446666664424222444444444444242424222222222424222222242424222),
    .INIT_6F(256'hB1B1AFD1AFB1B1B1D1D3B18FAFB1AF8D8D8D8F8F8F8F6D8FB18F8D6D8DAD8A68),
    .INIT_70(256'h91919191919191919191919191919191B1B1B1AF6B6B8D8FB1B1B1B1B18F8F8F),
    .INIT_71(256'h44444444444444446444424264864444686B8FAF8F8F8F8F91918F8F91919191),
    .INIT_72(256'h0000000000202222222222202222222222222222224222224242424242424244),
    .INIT_73(256'h8664424242646464424242422222222222222222200000000000000000000000),
    .INIT_74(256'h6464646444444464646464648484A68686868484848484868684646484848686),
    .INIT_75(256'h66668688A8A8A8888888A8888686866486868686866444444442444444444444),
    .INIT_76(256'h6444426464444244446464644464444242424242424444444464646464646666),
    .INIT_77(256'h4444422242424222222242424222222242424222424444422242424464648666),
    .INIT_78(256'hAFB1B18D6B6D8F8F8F8F8DAFB18F6D6B6B8D6A66444466664644242222244666),
    .INIT_79(256'h91919191B1B1B18F496B8D8FB1B1B1B1B18F8F8FB1AFAFD1AFB1B1B1D3D1B1AF),
    .INIT_7A(256'h4466444446468B8FAF8F8F8F8F8F8F8F8F919191919191919191919191919191),
    .INIT_7B(256'h0002220000222222222222224242424242424242424244444244444464442222),
    .INIT_7C(256'h4242424242222222222000000000000000000000000000000000202222222220),
    .INIT_7D(256'h84A6A6A686A6A6A6A6A6A686A686868484648686866464626262646264644242),
    .INIT_7E(256'h8686868686868666646464646464646464644444646464646464646464848484),
    .INIT_7F(256'h4242424242424242424244646464646464646464646466868688A8A8A8A8A8A8),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_87_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_87_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized7
   (p_83_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_83_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_83_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000002240000000000000000000000000000000000000000),
    .INITP_03(256'h00000000007FE0000000000000000000000000000000000000E0000000000000),
    .INITP_04(256'hFE00000000000000000000000000000000000007000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000007F8000000000000000000000000000000001F),
    .INITP_06(256'h00000000000000007FC000000000000000000000000000000023FFF000000000),
    .INITP_07(256'h00000FFF0000000000000000000000000000000FFFFF30000000000000000000),
    .INITP_08(256'h0000000000000000000000000001FFFFF3000000000000000000000000000000),
    .INITP_09(256'h00000000000000001FFFFFF80000000000000000000000000000000003FFF800),
    .INITP_0A(256'h000001FFFFFFC0000000000000000000000000000000007FFFC0070000000000),
    .INITP_0B(256'hFE000000000000000000000000000000000FFFFFC0FC00000000000000000000),
    .INITP_0C(256'h00000000000000000000003FFFFFFF9FF00000000000000000000000003FFFFF),
    .INITP_0D(256'h00000000000FFFFFFFFFFFC0000000000000000000000007FFFFFFC000000000),
    .INITP_0E(256'hFFFFFFFFFFFE000000000000000000000000FFFFFFFC00000000000000000000),
    .INITP_0F(256'hF000000000000000000000000FFFFFFFC0000000000000000000000000000007),
    .INIT_00(256'h4222202242424242424444422222424464646464424244646444446444446464),
    .INIT_01(256'hAF8D8D6D6B6A4644444466444424222444466644224242222222424242424242),
    .INIT_02(256'hB1B1B1B1B1AF8F8FAF8D8DD1AFB1B1D3D3B1B1B1B1D1B18D6B6DAF8F8F8F8FB1),
    .INIT_03(256'h918F8F8F8F91919191919191919191919191919191919191B1B1B18D496BAFB1),
    .INIT_04(256'h2242424222222222424244444242444466644222204244444444688DAFAF8F8F),
    .INIT_05(256'h0000000000000000000000000000002022222200002222000000202020222220),
    .INIT_06(256'hC8A8A6A686848484868464646264644264646442424242424242222222222000),
    .INIT_07(256'h8686866664646464646464646464646484848486A6A6C8A6A6A6A6A6A6A6A8A6),
    .INIT_08(256'h6464646464646464646464668686888888A8A8A8868686868688866464868686),
    .INIT_09(256'h2222424464646442426464424242444444424242422222422222424242424464),
    .INIT_0A(256'h2222224666664444222242422222424444444242222222222242424242424242),
    .INIT_0B(256'hAFB1D3D3D3D1D1D1D1F3D18D6B6DAF8F8F8F8FAF6D6D8D8B6868442444666444),
    .INIT_0C(256'h919191919191919191919191B1B1B16D496BAFB1B1B1B1B1B1B18F8DAF8D8DD1),
    .INIT_0D(256'h424242648866422222202264664444688DAF8F8F919191919191919191919191),
    .INIT_0E(256'h0000000000000000222222200000000000002020222222222222224242424242),
    .INIT_0F(256'h6264644242646464426464424242424242222200000000000000002020200000),
    .INIT_10(256'h6464648486A6A6A6A8C8C8C8C8A8A6A6A6A6A6A8C8C8C8C8C8A6A68684846462),
    .INIT_11(256'h6464646464648686868686868686868686A6A6A6A8A686646464646464648484),
    .INIT_12(256'h4242424242424242222222222242424444446464424242424444446464646464),
    .INIT_13(256'h2242444444444422222222422222224242424242424242424242424244424242),
    .INIT_14(256'h6D8D8D8DB18F8D6D6B8D8B684666444444464422222244886644224222424222),
    .INIT_15(256'hB1B18F6D498DAFB1B1B1B1B3B1B18F8FB18D8DF3AFF315F3D1F313F3F315D18D),
    .INIT_16(256'h646666686B8DAF8F8F8F91919191919191919191919191919191919191919191),
    .INIT_17(256'h202020000020202022222222222222424242424242424266AA86442242202042),
    .INIT_18(256'h6442424242422222222222202020202020200000000000002222222222222220),
    .INIT_19(256'hA6A6A6A6A6C6C8C80A0C0CEAE8A6A68484848484646464646464646462646464),
    .INIT_1A(256'h86A8A686846464424264646464646464848686846486868686A6A6A6A8C8C8C8),
    .INIT_1B(256'h4242444444444444444444444242424444644444444444646464646464646686),
    .INIT_1C(256'h2222222222224242424242424242424242424244444242424242222222222222),
    .INIT_1D(256'h4646444666442222244446664444224444644422426466666664442220222222),
    .INIT_1E(256'hB1B1B1AFB18D8DF3D113153515375737153713D18D6D8DAFAF8F8D6B6D8B6A68),
    .INIT_1F(256'h9191919191919191919191919191919191919191B1B18F6D498DAFD1D3D3D3D3),
    .INIT_20(256'h222222224242424242424264888644224222202222446668686BAF8F8F919191),
    .INIT_21(256'h2020202020200000000000000000002222222000000020000020222222222222),
    .INIT_22(256'hE8C6A6A684A6A684848464646484846464648464646442424242222222222222),
    .INIT_23(256'h648686868686848464848686A6A8A8C8C8EAC8A6A6A6A6C8C8E8EAEAEA0A0A0A),
    .INIT_24(256'h4242424242444444444444444444446464868686868686646464646464646464),
    .INIT_25(256'h4244424242424444444242422222222020202242424244444242444444444442),
    .INIT_26(256'h4644444466444222424444644442222020222222222242222222424244444444),
    .INIT_27(256'h57797957375715F3AF8DAFD1AF8D8D8D8D8D6A46666666464444222244666666),
    .INIT_28(256'h9191919191919191B1B18F8D6B8DAFD3F3D3D3D3D1D3F3B1D1AFD11515353757),
    .INIT_29(256'h66664422222222222222446668688DAFAFB19191919191919191919191919191),
    .INIT_2A(256'h0000000000000000000000202020202020222222222222222222424242424244),
    .INIT_2B(256'h8686868664848484646464626242424222222222222220202020200000000000),
    .INIT_2C(256'hA8C8C8C8C8CAA6A6A6A6A8C8EA0A0C0C0C0C0C0C0AE8C6C6A6A6A6A6A6868684),
    .INIT_2D(256'h424464668688868666646464848686868684648486868686868484848486A6A8),
    .INIT_2E(256'h2222202020224242444444424242424242424242424242424442424444444444),
    .INIT_2F(256'h2222202020202020222242222242424444444444444242424242444442424222),
    .INIT_30(256'hAF8D8D8D8D8B6846666646442444244466686866444444446644222242424242),
    .INIT_31(256'h6B8DB1D3D3B1D3D3D3F515F1F1F1133737575759799B9B7959593715CFADD1F3),
    .INIT_32(256'h66686AAFAFB191919191919191919191919191919191919191919191B18F8F8D),
    .INIT_33(256'h2020202020222222222222222222424242424242648666422220222220222244),
    .INIT_34(256'h6464424242424242222222222220200000000000000000000000000000000020),
    .INIT_35(256'hEA0C2C2C2C4E4E4C2C0AE8E8C8C6A6A6A6A6A6A6A6A8A8A68686868484848464),
    .INIT_36(256'h86868686846464648486868684848486A6A8C8C8C8C8C8C8C8C8A6A6A6C8C8C8),
    .INIT_37(256'h4242424242424242424244446442424242444464646486868888866664646486),
    .INIT_38(256'h4242424444444442424242424242424242222222202020202222424244424242),
    .INIT_39(256'h2224466888886846444444224422224442222222222220202020202222224242),
    .INIT_3A(256'h13153559797979799B9B9B9B7B595935D1CF1313CFADADAF8D68464666464424),
    .INIT_3B(256'h91919191919191919191919191919191B1AF8F8D8D8DD1D3D3B1D3F315375913),
    .INIT_3C(256'h2222224242424242448888642220222220222022446668AFAFAF919191919191),
    .INIT_3D(256'h2222200000000000000000000000000000000000202000002022222222222222),
    .INIT_3E(256'hE8E8C6C6C6C6C6C8C8C8C8A8A6A6A6A686868484846464644242424242422222),
    .INIT_3F(256'h8484A6A6A8C8C8C8C8C8C8C8C8C8A6A6A8C8EAEA0A2C2C2C2C4E6E4E4C2C0A0A),
    .INIT_40(256'h6444444244446466868688868686646464646464646464646464646464848484),
    .INIT_41(256'h4442424222222020202222224242424242424242222222222222424242446464),
    .INIT_42(256'h2222222222222020202222222000202222224244444242424242424242424242),
    .INIT_43(256'h9B797935F1F13515F1CFAFAD8D46466666442424242468888868662424442222),
    .INIT_44(256'h91919191B1AF8D8D8D8DD1D1B1D1F31557797B373535577979799B9BBDBDBDBD),
    .INIT_45(256'h2222222220202222444646ADAFAFB1B191919191919191919191919191919191),
    .INIT_46(256'h0000000000000000000000002020222222222222222222424242424242668866),
    .INIT_47(256'hC8C8E8C8C8A6A684846464646462424242424222222220000000000000002222),
    .INIT_48(256'hC8C8C8C8C8EA0A2C2C4C4E707070909090704C2A0AE8E8C8C6C6A6C6A6C6C8C8),
    .INIT_49(256'h646464646464646462426464646464646484848486A6C8C8C8C8C8C8C8C8C8C8),
    .INIT_4A(256'h4242424242424222222222224242424242446464646464646686868686866464),
    .INIT_4B(256'h2020222222424444444242424242424242424242444222222222202022222242),
    .INIT_4C(256'h8A66466666664424444668686866442244444422222220202020202022222222),
    .INIT_4D(256'hB1D1F337799B9B793557799B9B9B9BBDDDDDBDBD9B9999551313573535F3CFCF),
    .INIT_4E(256'h8B8FB1B1B191919191919191919191919191919191919191AF8F8D8D8D8DB1B1),
    .INIT_4F(256'h0020202222222222222222224242424242648666222222222222222042444468),
    .INIT_50(256'h6464626242424242222222000000000000000000000000000000000000202020),
    .INIT_51(256'h929292B2B2B3704C2A0AE8E8E8E8C8C6A6C6C8C8EA0C0C0CEAC8C8A686848464),
    .INIT_52(256'h646464848686A6A6A6C8C8C8C8C8C8A6A6C8C8C8C8C8C8C8EA0C2C4E70909292),
    .INIT_53(256'h4242424242424244646464646686868686866664646464644242426442426464),
    .INIT_54(256'h4242424242424242422222222222222022424242424242424242422222222222),
    .INIT_55(256'h6846222242222242222020202020202220222020202022224244444444444242),
    .INIT_56(256'h9B9BBBDDDDDDDDBDBBBB9B57353557575735F1AD886646666644444446686868),
    .INIT_57(256'h91B1B1B1B1B1B19191919191AF8D8D6B6D8DAFB1B1D1F5577B9BBD9B5757999B),
    .INIT_58(256'h2222424242446666222222224222222042644424688DAFB18F8F91B191919191),
    .INIT_59(256'h2020202000000000000000000000000000202020202020202222222222222222),
    .INIT_5A(256'h0A0AE8E8C8C8E8EA0C2C2C2C0C0AE8C8A6A68484868464646262424242422220),
    .INIT_5B(256'hC8C8C8C6A6C8EAEAEAEAE8EA0A2E7092B5B5B5B2B2B2B2B2D5D5926E2C0A0808),
    .INIT_5C(256'h646666868686866464644242424464646464648486868686A6A6A6A8EAEAEAEA),
    .INIT_5D(256'h2222222222222222222222222222222222222222424242424242426264646464),
    .INIT_5E(256'h2020202220202020202222424444424242424242424242424242424222222222),
    .INIT_5F(256'h555577577957138A6866666666242444668A6668664422222222222222202020),
    .INIT_60(256'h8F8D8D6B8D8D8FB1D1D315579BBBBDBB57579BBBBB9BBBDDDFDFDDBDBBBDBB79),
    .INIT_61(256'h2222220042664422448BAFB18F8F919191918F8F91B1B1B1B1B1B1B1B1B1B1B1),
    .INIT_62(256'h0000202020202020202020202222222020222222222222224242646644222242),
    .INIT_63(256'h2C0A0A0AE8C8A6A6A6A684848464626264424222222220202000000000000000),
    .INIT_64(256'h2C70B5D7D7D7B590B2B3B3B3B5B592706E4C2C2A0A0A2A0A0AE8E80A2C2C2C2C),
    .INIT_65(256'h4464646686868684868686A6A6A6C8C8EAEAE8EAC8C8C8C8C8EA0A2C2C0C0A0A),
    .INIT_66(256'h2222222222222222222222224242426464646466666464648686646464646444),
    .INIT_67(256'h4442424242424222224242424222222222222020202022222222222222222222),
    .INIT_68(256'h44244446688A6868444242222222222220200020202020202020202022424244),
    .INIT_69(256'h9BBBBBBD777799BBBBBBBBDDDFDFDDBDBDBD9B99777799777957F18A88666644),
    .INIT_6A(256'h91918F8F9191918F91B1B1B1B1B1B1B1B1B1B1B1AF8D8D6B8D8FAFD1F3153757),
    .INIT_6B(256'h2222222020222222222222222222446464424242422020002266660022668DB1),
    .INIT_6C(256'hA684846464644242222222202020000000000000000020200020202020202020),
    .INIT_6D(256'h92929292B3B5924C2C4C6E4E2C0A0A0A2C2C2C2C2C0A2C2C2C0AE8C6A6A6A6A6),
    .INIT_6E(256'hA6C8EAEAC8A6A6C8E8E8E8EA0A2C4E4E4E2C2C4E92D5D7F7F7D5B29090B2B2B2),
    .INIT_6F(256'h446464648464868686866464424264648686868664646686A88684648486A6A6),
    .INIT_70(256'h2222222222222220202222222222222222222222222222222222222222224242),
    .INIT_71(256'h2222222222200020200020202020202242446464444242424242222222222222),
    .INIT_72(256'hDDDDDDBDBBBB9B997779BB997933CC8888886442226668888868684622224222),
    .INIT_73(256'hB19191B1B1B1B1B1AF8D8D6B8FAFB1D11337597999BBBBBB9999999BBBBDBDDD),
    .INIT_74(256'h2022424464424244422222202264882000448BB1B1B18F8FB191918F919191B1),
    .INIT_75(256'h2220202000000000000000000020202000002020202222222222222222222222),
    .INIT_76(256'h704E2C0A0A2C4E4E4E0A0A2C4E700CC8C6C6C8C6A6A686848464644242424242),
    .INIT_77(256'h4E709292706E90B5D7D7D5B5B5D5D5B3B2B2B2B3B5B5D7F9F9F9F9B5906E6E90),
    .INIT_78(256'h4464646464868686666464648484648486A6C8C8C8C8C8EAE8E8C8C6E80A2C2E),
    .INIT_79(256'h2222222222222222222222222222222222224244646464646466868686646464),
    .INIT_7A(256'h4222424244644442424222422222222222222222222020202022222222222222),
    .INIT_7B(256'h7713AA464466444244668A886846222222424442424222222220202222222242),
    .INIT_7C(256'hAFB1D1F335799B9B9B9B9B999999999BBBDDDDDDDDDDBDBDBB999B7977779977),
    .INIT_7D(256'h224488222024688FB1B1918F918F8F8F8F8F919191919191B1B1B1B1AF8D8B8D),
    .INIT_7E(256'h0000200000000020202020222222222222222222224242426444424242424222),
    .INIT_7F(256'h2C6E4E0AE8C8C6C6A6A6A6A68684846464646242424222202000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_83_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_83_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized8
   (p_79_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_79_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_79_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000000000FFFFFFF8000000000000000000000000000000FFFFFFFFFFFF),
    .INITP_01(256'h001FFFFFFF0000000000000000000000000000007FFFFFFFFFFFFFC000000000),
    .INITP_02(256'h00000000000000000000000000000FFFFFFFFFFFFFFC00000000000000000000),
    .INITP_03(256'h000000000000000001FFFFFFFFFFFFFFF00000000000000000000001FFFFFFF0),
    .INITP_04(256'h0000003FFFFFFFFFFFFFFF80000000000000000000001FFFFFFE000000000000),
    .INITP_05(256'hFFFFFFFFFFFC0000000000000000000003FFFFFFE00000000000000000000000),
    .INITP_06(256'hE0000000000000000000003FFFFFFE00000000000000000000000000000FFFFF),
    .INITP_07(256'h000000000003FFFFFFC03000000000000000000000000001FFFFFFFFFFFFFFFF),
    .INITP_08(256'hFFFFFFFC06000000000000000000000000001FFFFFFFFFFFFFFFFF0000000000),
    .INITP_09(256'h00000000000000000000000003FFFFFFFFFFFFFFFFF000000000000000000000),
    .INITP_0A(256'h000000000000007FFFFFFFFFFFFFFFFF800000000000000000000FFFFFFF8060),
    .INITP_0B(256'h001FFFFFFFFFFFFFFFFFFC00000000000000000003FFFFFFF00E000000000000),
    .INITP_0C(256'hFFFFFFFFFFE00000000000000000003FFFFFFE00C00000000000000000000000),
    .INITP_0D(256'h00000000000000000007FFFFFFE01800000000000000000000000007FFFFFFFF),
    .INITP_0E(256'h000000007FFFFFFE0180000000000000000000000000FFFFFFFFFFFFFFFFFFFF),
    .INITP_0F(256'hFFFFE0300000000000000000000000001FFFFFFFFFFFFFFFFFFFF80000000000),
    .INIT_00(256'hD7D7D7B3B0B2B5D7D9F9FBFBFBFBFBF9D7926E6E70704E2A0A2C2C4E4E2C0A0A),
    .INIT_01(256'h64648486A6C8C8C8C8C8EAEAEAEAE8E82C4E709293B3B5B3929092B5D5D5B5D5),
    .INIT_02(256'h2222222222424244646464646464646464646444646464446464646464646464),
    .INIT_03(256'h2222222222222222202020202022222222222222222220222222222222222222),
    .INIT_04(256'h6644444464644442222222222020222222224242424242424244424242222222),
    .INIT_05(256'h79999999BBBDDDDDDDBDBBBDBD99BD995755775735EF8844226464648888AA88),
    .INIT_06(256'h918F8F8F8F8F8F9191919191B1B1B1B18F8D8B8DB1B1D1F337799BBBBBBB9B77),
    .INIT_07(256'h2222222222222222224242424464222242424222202266222022468DB1B1B1B1),
    .INIT_08(256'hA686848484646464624242422220200000000000000000000000000020202020),
    .INIT_09(256'hFBFBFBFBF9D592707070704E2C2A2C2C4E4C2C2A2A2C4E4E2C08C6C6C6A6A6A6),
    .INIT_0A(256'hEA0A0A2C7092B5B5D5B5B5B5B5B392B5B5B5B5D5D7D7B5B3B2B5D7F9FBFBFBFB),
    .INIT_0B(256'h6444446464444242424444424264646464646484848484A6C8C8C8C8C8C8EAEA),
    .INIT_0C(256'h2022222222222222222020202222222222222222222222424244444444646464),
    .INIT_0D(256'h2020222222222242422242424242422242422222222222222222222220202020),
    .INIT_0E(256'hBDBBDD9957353533EF88444422446466AAAAAA88444466646444444222222020),
    .INIT_0F(256'hB1B1B1B18D8D8BADD1B1D11357799BBDBDBBBB79797979799BBDBDDDDDBBBBBD),
    .INIT_10(256'h4264222022422222222244222022446AAFB1B1B18F91918F8F8F8F8F919191B1),
    .INIT_11(256'h4222202020200000000000000000000000202020202022222222222222224242),
    .INIT_12(256'h4E4C2C2C2C4C4C2C2C2A4C6E6E2CE8C8C6C6A6A6A6A6A6868686846464624242),
    .INIT_13(256'hD5D5B2B5B3B2B2D5B5B5B5B5D5F7F9FBFDFDFBFBFBFBFBFBF9F9D79290909070),
    .INIT_14(256'h44646464646464848484A6C8E8EAE8C8C8C8EAEA0A2C4E70B3B5D7D7D7D5B5B5),
    .INIT_15(256'h2222222020222222424242424244446444444242424242424242424242424442),
    .INIT_16(256'h4242422242222220222222222222222020222222222222222222222020202020),
    .INIT_17(256'h22446688CCEFAC88646444442222222222202020202020222222222222224242),
    .INIT_18(256'h577B9BBDBDBBBB9B797977779BBBBDBDDDBBBBBBBBBDBB7955333311AA442244),
    .INIT_19(256'h202022488F9191918FB1918F8F8F8F8F9191B1B1B1B1B1B18D8D8DADD1D1F315),
    .INIT_1A(256'h0000000000202020202020222222222222222242424442222022424222224422),
    .INIT_1B(256'h6E6E2C0AE8C6C6C6A6A6A6A68686868484646462424242202020200000002000),
    .INIT_1C(256'hF9FBFBFBFBFBFBFBFBFDFBFBFBF9F9D7B290909290704E2C2A2C2C4E4E2C0A2C),
    .INIT_1D(256'hEAE8E8C8C8E8EA0A2C4E70B3B5D7D7D7D7D7D5D5D5D7D5B5B392B2B5D7D7D7F7),
    .INIT_1E(256'h42424244424242422222222222224242446464446464646464648484A6A6C8C8),
    .INIT_1F(256'h2220202022222222222222202020202020202020202020202222424242424242),
    .INIT_20(256'h2220202020202020202020222222224222224242424222222222202020222222),
    .INIT_21(256'h99BBBBBDDDBDBDBB9BDD9B77555533EF88444444224466AACEEF886666864222),
    .INIT_22(256'h918F8F8F8F9191B1B1B1B1B18D8DADAFD1D1F537799BBDBDBDBBBDBD9B795777),
    .INIT_23(256'h2222222222222242424244422022424222226400202022246D8F919191919191),
    .INIT_24(256'hA6A6868684848464644242222020202202202020202020202020202020202022),
    .INIT_25(256'hFBFBF9F9D7B290B290B2904E2A2C2C4C4E4E2C0A2C4E4E2C0AC8C6C6C6A6A6A6),
    .INIT_26(256'hD5F7F9D7D7D7D7D5D5D5D5D5D7D7D7D7F9F9F9FBFBFBFBFBFBFBFBFBFBFDFDFB),
    .INIT_27(256'h4242424464646444646464848484A6A6C8C8C8E8E8E8E8E8EAEA0C2C4E70B3D5),
    .INIT_28(256'h2020202020202022202020222242424244444442424242424242222020222222),
    .INIT_29(256'h2222424222224242422222222220202022222222220020202222222222222020),
    .INIT_2A(256'h575755CC866444422264AAEEF1CF686666442222222220202020202020202022),
    .INIT_2B(256'h8D8DADCFF1F31537799BBDDDBDBBBDDFBB997977799BBBBBDDDDBB9BBBBDBB79),
    .INIT_2C(256'h222242222222642020202222488DB1B1919191B1B191918F8F8F8FB1B1B1B1B1),
    .INIT_2D(256'h2222222202202020000000000000202020202222222222222222222242224242),
    .INIT_2E(256'h4C2C2C2C4E4E6E4C2A2A4C4C2C0AE8C6C6C6A6A6A6A6A6868484848464624242),
    .INIT_2F(256'hF9F9FBFBFBFBFBFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9D5B29090929290),
    .INIT_30(256'hA6A8C8C8C8C8E8E8E8E8EAEA0A0C2C4E7092D5D7D7D7D7D7D7D7D7D7D7D5D7D7),
    .INIT_31(256'h4242424242424242444442222220202020222242424444646464646464648486),
    .INIT_32(256'h2220202222222222202020222222222222202020202020202020202020222222),
    .INIT_33(256'hEFAA684644444444222222222000002020202022424242424242424222222222),
    .INIT_34(256'hBDBBBDDDBB997979999BBBBBDDDD9BBBBDBDBD79775733AA6644222288AACCF1),
    .INIT_35(256'h468DAFB1919191B1B1B191918F8F8F8F91B1B1B18D8DAFCFF3F31537799BBBBD),
    .INIT_36(256'h0000000020202222222222222222222222224242422222222242642220202022),
    .INIT_37(256'h4C2C0AE8C6C6C6A6A6A6A6A68686868484646442422222222222222200000000),
    .INIT_38(256'hFBFBFBFBFBFBFBFBFBFBF9FBF9F7D5909090B2926E4C2C2C2C4C706E2C0A2A4C),
    .INIT_39(256'h0C2C4E7090B2D5F7D7D7D7D7D7D7F7D7D7D7F9F9FBFBFDFDFDFDFDFDFDFBFBFB),
    .INIT_3A(256'h20202222222222424244646464646464848686A6A8C8C8C8C8C8C8E8E8E8EA0A),
    .INIT_3B(256'h2222222020202020000000202020202022222242424242424242424244422222),
    .INIT_3C(256'h2020002000002242444442424242222222222222222220222020202022222222),
    .INIT_3D(256'hDDBDBBBDDDBDBB795755EF6844222244CCEF1111CCAA68664444444422222220),
    .INIT_3E(256'h918F8F8F8F91B1B18D8DAFD1F3F31537799B9BBBBBBBBDDDBB9999999BBBBBBB),
    .INIT_3F(256'h2222222222224242422222222242642220202002246A8FB1919191B1B1B1B1B1),
    .INIT_40(256'hA6A6A68484848464424222222222222220000000000000000020202222222222),
    .INIT_41(256'hF9F9D7B27090B2B2906E4C2A2A2C6E704E2C2C4C4C4C2C0AE8C6C6C6A6A6A6A6),
    .INIT_42(256'hF7F9F9F9F9F9FBFBFDFDFDFDFDFDFDFDFBFBFBFDFBFBFDFBFBFBFBFBFBFBF9FB),
    .INIT_43(256'h6464648486A6A6A8C8C8C8C8C8C8C8C8E8E8EA0A2C4E6E90B2B2D5D5D7D7D7D7),
    .INIT_44(256'h2020202222424242424242424242424242222220202222222242424242646464),
    .INIT_45(256'h4242422222222220202020222222202222222222222020000000000000000000),
    .INIT_46(256'h22222266EF3333F1ACAA66444466642222222220202020200020224444424222),
    .INIT_47(256'h13133557799B9B9B9BBBBDDDBB9B9B9BBBBDBBBBBDBBBBDDDFDD9B5755138A46),
    .INIT_48(256'h224264222020200022488DAF9191919191B1B1B1B1918F6F8F8FB1B18DAFAFD1),
    .INIT_49(256'h2222222222200000000000000000202022222222222222222222424242422222),
    .INIT_4A(256'h2A2A4C70706E4C4C4C4C4E2CE8C6C6C6C6A6A6A6A6A6A6A6A6A6A68464624242),
    .INIT_4B(256'hFDFDFDFBFBFBFBFDFBFBFBFDFBFBFBFBFBFBF9F9F9F9F9D59090909092906E2C),
    .INIT_4C(256'hC8C8C8C8E8E80A2C4C4E7090B2B3D5D5D5F7F7F9F9F9F9FBFBFDFDFDFDFDFDFD),
    .INIT_4D(256'h4242422222202020224242424242424242646464646464848686A6A8C8C8C8C8),
    .INIT_4E(256'h2222222222222020200000000000000000000000202022224242424242424242),
    .INIT_4F(256'h4488662200202222200020222022424242222242424242222222202020202020),
    .INIT_50(256'hBDBBBBBBBBBB9B9BBDBBDDDDDDDF9B5513CF664422222288CC3313CCAAAA4422),
    .INIT_51(256'hB19191919191B1B1B1B19191918F8F8F8DAFD1F315355759799B9B999B9BBBDD),
    .INIT_52(256'h0000202020222222222222222222424242422222224264222020202022466B8F),
    .INIT_53(256'h0AE8C6C6C6C6A6A6A6A6A6A6A6A6A6A684846462424222222220200000000000),
    .INIT_54(256'hFDFBFBFBFBFBFBFBFBF9F9F9B5907090B2926E4C2A0A2A4C6E6E4E4C4C4E4C2C),
    .INIT_55(256'hD5D5D5D5D5F7F7F9F9FBFBFBFDFDFDFDFFFFFDFDFDFDFDFBFBFBFDFDFBFBFBFB),
    .INIT_56(256'h4242424264646464646484848486A6A6C8C8C8C6C6C8C8E8E80A2C4C4E7090B2),
    .INIT_57(256'h0000000000000020202222424242424242424242424220202020222222424242),
    .INIT_58(256'h4442224222224242424222222220202000202022222222222220200000000000),
    .INIT_59(256'hDDDF9913CE8A444220668888575711AA68662224666622222222222020002042),
    .INIT_5A(256'h918F8F8FAFD1133757597979799B9B999BBBBBDDBDBBBBBB9BBB9B999BBBDDDD),
    .INIT_5B(256'h222242424242222222424420200000002024488DB1919191919191B1B1B191B1),
    .INIT_5C(256'hA6A4A6A6A6A68464624242422222202020000000000000202022222222222222),
    .INIT_5D(256'hF7B59090B2B2906E2C0A2A4C4C4E6E4C4C4E4E4C2C0AE8C6C6C6C6C6C6A6A6A6),
    .INIT_5E(256'hFDFFFFFFFDFDFDFDFDFDFBFBFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9FB),
    .INIT_5F(256'hA6A6A6A6A6A6A6C6C8E8E80A0A2C4E6E9090B2B2D5F5D5D5F7F7F7F9F9FBFBFD),
    .INIT_60(256'h42424242424222222220202022222242424242424262646464646464848484A6),
    .INIT_61(256'h2220202020202022222222202000000000000000000000000000202222424242),
    .INIT_62(256'h5533CC6644222246664422222222220022444444224242424242424222202022),
    .INIT_63(256'h799B9B9B9BBBBDDDBDBBBBBBBBBB9B79579BDDDFDFDD99F18844222242668ACE),
    .INIT_64(256'h202000202022466B8F91B1B1919191B1B1B19191B1919191CFF1357979797B79),
    .INIT_65(256'h4222222020200000000000202022222222222222222242424242222220224422),
    .INIT_66(256'h4C4C6E6E4E4E4E6E4E2C0AE8C6C6C6C6C6C6A6A6A6A4A6A6A6A6A68464624242),
    .INIT_67(256'hFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9FBF9D7B39090B2B3904E2A2C4C),
    .INIT_68(256'h2C4C6E90B2B2B2D5F5F5F5D5F7F7F9F9F9FBFBFDFDFFFFFDFDFDFDFDFDFDFBFB),
    .INIT_69(256'h222222424242424242626464646464848484A6A6C8C8A6A6A6A6C6C8E80A0A0A),
    .INIT_6A(256'h0000000000000000000000000020222242424242424242422222222220202222),
    .INIT_6B(256'h2222222244646442224242424242422222202020202020202020202020202000),
    .INIT_6C(256'hBBBDBB793599BDDFDFBD79EF662220206488AA1133F18A442202444444222222),
    .INIT_6D(256'hB1919191B1B19191B1B1B1B1D11357799B9B7979999B9B9BBBBDBDDDBDBBBB9B),
    .INIT_6E(256'h202022222222222222222242424222222022442222222020202244688F91B1B1),
    .INIT_6F(256'hE8E6C6C6C6C6A6A6A6A4A6A6A6A6A6A684646462424222222020000000000020),
    .INIT_70(256'hFBFBFBFBF9FBFBF9F9F9D592909092906E2C4C4C4C4C6E706E4C4E6E704E2C08),
    .INIT_71(256'hF7F7F9F9F9FBFBFDFDFDFDFDFDFDFDFDFDFDFBFBFDFDFBFBFBFBFBFBFBFBFBFB),
    .INIT_72(256'h6462648484A6A6C6C6A6A6A6A6C6C8E80A0A2C2C4C6E90B2B4D4D2D5F5F5F5F7),
    .INIT_73(256'h0020224242424242424242222222222222222222222222424242424262626264),
    .INIT_74(256'h2222222222222220202020202020202020000000000000000000000000000000),
    .INIT_75(256'h6622204286AAEF3313AA66442422442422222222222242646664422222424242),
    .INIT_76(256'hF11335799B9B79799BBBBBBBBDBDBDDDBBBDBD99BBBBBB995579BDDFDFBD57CC),
    .INIT_77(256'h424242222022442222222020202022468D91B1B1B19191B1B1B1B1B1B1B1B191),
    .INIT_78(256'hA4A6A6A6A6846462424242222220202000000020202022222222222222224242),
    .INIT_79(256'h906E7090704C2A2C4C4C6E706E4C4C6E90702C0808E8E8E8C8C6A6A6A6A6A484),
    .INIT_7A(256'hFDFDFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9FBFBF9F9F9F7B5),
    .INIT_7B(256'hC6C8E80A2A2C4C4E7090B2D4D4D4D2F5F5F5F7F7F7F7F9F9FBFBFBFDFDFDFDFD),
    .INIT_7C(256'h222222222222222222224242424242424262626464648484A6A6A6A6A6A6A4A6),
    .INIT_7D(256'h2020202000000000000000000000000000000000222222224242424242424222),
    .INIT_7E(256'h2246664422222222224244666444224222422222222220202222202020202020),
    .INIT_7F(256'hBDDDBDDDBBBDBD999B9B9B997999BDDFDF9B13AA4422224286EF3535CF684444),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_79_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_79_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_zrn_blk_mem_gen_prim_wrapper_init__parameterized9
   (p_75_out,
    clka,
    ena_array,
    ena,
    addra);
  output [8:0]p_75_out;
  input clka;
  input [0:0]ena_array;
  input ena;
  input [11:0]addra;

  wire [11:0]addra;
  wire clka;
  wire ena;
  wire [0:0]ena_array;
  wire [8:0]p_75_out;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* CLOCK_DOMAINS = "COMMON" *) 
  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000003FFFFFFFFFFFFFFFFFFFFC0000000000000000007FF),
    .INITP_01(256'h00000000007FFFFFFFFFFFFFFFFFFFFE0000000000000000007FFFFFFC070000),
    .INITP_02(256'hFFFFFFFFFFFFFFFFFFFFE0000000000000000007FFFFFFC06000000000000000),
    .INITP_03(256'hFFFFFFFFFF8000000000000000007FFFFFFC0C00000000000000000000000007),
    .INITP_04(256'h00000000000000000FFFFFFF8080000000000000000000000000FFFFFFFFFFFF),
    .INITP_05(256'h000000FFFFFFF8000000000000000000000000001FFFFFFFFFFFFFFFFFFFFFF8),
    .INITP_06(256'hFF0000000000000000000000000017FFFFFFFFFFFFFFFFFFFFFFC00000000000),
    .INITP_07(256'h000000000000000003FFFFFFFFFFFFFFFFFFFFFFFE00000000000000000FFFFF),
    .INITP_08(256'h0000003FFFFFFFFFFFFFFFFFFFFFFFE00000000000000000FFFFFFF000000000),
    .INITP_09(256'hFFFFFFFFFFFFFFFFFFFF00000000000000000FFFFFFF00000000000000000000),
    .INITP_0A(256'hFFFFFFFFF00000000000000000FFFFFFE000000000000000000000000003FFFF),
    .INITP_0B(256'h000000000000000FFFFFFC00000000000000000000000001FFFFFFFFFFFFFFFF),
    .INITP_0C(256'h0000FFFFFFC00000000000000000000000007FFFFFFFFFFFFFFFFFFFFFFFFF00),
    .INITP_0D(256'h0000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF8000000000000),
    .INITP_0E(256'h00000000000003FFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000FFFFFF8),
    .INITP_0F(256'h00FFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000FFFFF3000000000000),
    .INIT_00(256'h202022446B8FB1B19191B1B1B1B1B1B1B1919191F1133557799979999BBBBBBB),
    .INIT_01(256'h2222222220000000202020222222222222224242424242422242422222222000),
    .INIT_02(256'h6E4E4C4C90904C0A0808E8E8C8C8C6A6A6A6A68484A6A6C8C8A6846462424242),
    .INIT_03(256'hFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9FBF9F9F7B3906E9092902C2C4C4E6E6E),
    .INIT_04(256'hD4D2D4F5F5F5F7F7F7F9F9F9FBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFBFBFB),
    .INIT_05(256'h4242626262626464648484A6A6A6C8C8A6A6A6C8C8E80A2C2C4C6E90B2B2D4D4),
    .INIT_06(256'h0000000000002020222242422222222222424222222222202022224242424242),
    .INIT_07(256'h4442222222202022222220202020002020202020202000000000000000000000),
    .INIT_08(256'h999BBBBDBD99EF8844224466CC33571388442222226644222200222222424244),
    .INIT_09(256'hB19191B191919191F1133557799B7999BBBBBBBBBDDDBDDDBDDDDD9B99997777),
    .INIT_0A(256'h222222222222224242424242424222202222200020202224488F919191B1B1B1),
    .INIT_0B(256'hE8E8C8C6A6A6A6A6A6A6A6C6C8A6A48462624242422222222220000000202020),
    .INIT_0C(256'hF9F9F9FBFBF9F9F7D5B27090B3B24E4C4C4C4C4E6E6E4E4C6E706E2C0A0A08E8),
    .INIT_0D(256'hFBFBFBFBFBFDFDFDFDFDFDFDFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_0E(256'hA6A6C8A6A6A6C6E8E80A0A2C4C6E90B2B2B2B2D2D2D2D4F5F7F7F7F7F9F9F9F9),
    .INIT_0F(256'h42222222222222222222202020222242424242424242626262646484848486A6),
    .INIT_10(256'h2020002020202220200000000020000000000000000000000020202242424242),
    .INIT_11(256'hEF5533AA44242222446644222222444444444422222222222222222222222020),
    .INIT_12(256'h799B7979BBBBBDBDBDDDBDDDBDDDDDBBBB9B775799BB999BBB99EF8844226488),
    .INIT_13(256'h424222002222002222222222468D8F91B1B1B1B1B191919191919191EF133557),
    .INIT_14(256'hC8C6A68484646242424222222220000000202020222222222222224242424242),
    .INIT_15(256'h92B3704E4C4C4C4C6E6E6E4C4C6E706E2C0A08E8E8E8E8C8C6A6A6A6A6A4A6A6),
    .INIT_16(256'hFDFDFDFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9FBFBF9F9F7F7D59290),
    .INIT_17(256'h4E7092B2B2B2B2B2D2D4D4F5F7F7F7F9F9F9F9FBFBFBFBFBFBFDFBFBFDFDFDFD),
    .INIT_18(256'h222242424242424242626464646484848486A6A6A6A6A6A6A6C6C8E8EA0A2A2C),
    .INIT_19(256'h0020000000000000000000202022222242424242222220202222222222202020),
    .INIT_1A(256'h4444444444442222000022222222222222222020202020202020202000000000),
    .INIT_1B(256'hBDDDDDBBBDBB797799BB99777755EE66422264AA1333EE662222224444442222),
    .INIT_1C(256'h246A8F91B1B1B1B1B1B1B19191919191F1335557779B7999BBBBBDBDDDDDDDDD),
    .INIT_1D(256'h2222000000202020222222222222224242424242424220002020002222222222),
    .INIT_1E(256'h2C4C70904E2A0A0A0AE8E8E8C8A6A6A6A68484A6C8C8C6A68484646464424222),
    .INIT_1F(256'hF9F9F9F9F9FBF9F9F9F9F9F9F9F9F9F9F9F7B59290B2926E4C4C4E4C4E6E6E4E),
    .INIT_20(256'hF7F7F7F9F9F9F9FBFBFBFBFBFBFDFBFBFBFBFBFDFDFDFDFDFDFDFBFBFBFBFBFB),
    .INIT_21(256'h846484848486A6A6A6A6A6A6C6C8E8E80A0A2C4C6E9092B2B2B0B2D2D4D5D5F5),
    .INIT_22(256'h2222222222224242222220202022222222222222224242424242446464646464),
    .INIT_23(256'h2222202020202020202020202020200000000000000000000000000000002020),
    .INIT_24(256'h33CEAA44222266EE11EF88242422224444422242444444444444200020222222),
    .INIT_25(256'h919191911155577777997999BBBBBDBDBDDDDDDDDDDDDDBBBDBB99799BBD9B77),
    .INIT_26(256'h222222224242424242422220202200000020222224466D8FB1B1B19191B1B191),
    .INIT_27(256'hC8A6A6A6A6848484A6C8C8A6A684646464424242222200000020202022222222),
    .INIT_28(256'hF9F9F9F9F9F9D7B39092B2906E4C4E4C4C4E6E6E4C4C6E90704C2A0A0AE8E8E8),
    .INIT_29(256'hFBFBFBFBFBFBFBFBFDFDFDFDFDFDFBFBFBFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9),
    .INIT_2A(256'hE8E8E80A0A2A4C6E9092909090B2D4D5D5D4D4D5F7F7F7F9F9F9F9F9FBFBFBFB),
    .INIT_2B(256'h2022222222222222424242424242646464646484846484848484A6A6A6A6C6E8),
    .INIT_2C(256'h0000000000000000000000000000000000202022222222222222222222202020),
    .INIT_2D(256'h4622224444222222222264664422002222222222202220202020202020202020),
    .INIT_2E(256'h9BBDBDBDBDDDDDDFDDDFDFBDBB9B7979BBBDBD9911886622224488EFEFAA4644),
    .INIT_2F(256'h202020000000222224266B8FB1B1B19191B1B1B191919191135777777777999B),
    .INIT_30(256'hA684848464624242422220000020202022222222222222224242424242422220),
    .INIT_31(256'h906E4C4E4C2C4C706E4C4C6E904E2C2A0A0AE8C8C6C6A6A6A6A6848486A6C8C8),
    .INIT_32(256'hFDFDFBFBFBFBFBFBFBFBF9F9F9FBFBF9F9F9F9F9F9F9F9FBFBFBF9D7B290B2B2),
    .INIT_33(256'hB2D4D5D5D5D4D4F5F7F7F7F9F9F9F9F9F9FBFBFBFBFBFDFBFBFBFBFDFDFDFDFD),
    .INIT_34(256'h4242646464646484848484A6A6A4A6A6C6C8E80AEA0A0A2C2A4C6E9090B2B2B2),
    .INIT_35(256'h0000002020202222222222222220202020202020222222222222224242424242),
    .INIT_36(256'h2222224444222200202222202022222020202020000000000000000000000000),
    .INIT_37(256'hBBBB9B9BBDBB9957F166222266AAEEEEAA664444444444442222222244668866),
    .INIT_38(256'h8FB1919191B1B1B191919191357799797755999B9BBDDDBDBDBDDDDFDDDDDDBD),
    .INIT_39(256'h0020202022222222222222224242424242424222202020000000202222466B8D),
    .INIT_3A(256'h6E6E4C2C0A0A0AE8C6C6A6A6A6A6868484A6A6A6A68684848464646242422200),
    .INIT_3B(256'hF9FBFBF9F9F9F9F9F9F9F9F9F9F9F9F9D59292B2B2904C4C4C2C4C6E6E4C2C4C),
    .INIT_3C(256'hF9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFDFDFBFBFBFBFBFBFBF9F9),
    .INIT_3D(256'hA6A6A6C6C8E80A0A0A2C2C4C4E709090B2B2B2B2D4D5D5D5D5D5D5F7F7F9F9F9),
    .INIT_3E(256'h222020202020202222222222202222424242424242626464648484848484A6A6),
    .INIT_3F(256'h2222222020202020000000000000000000000000000020202022222222222222),
    .INIT_40(256'h4688CCCC88664444444444222222222222224442222244222222222022222220),
    .INIT_41(256'h55999999793379999BDDDDDDBDBDBDDDDDDDDDBDBBBB9BBBBDBBBB55CC442244),
    .INIT_42(256'h424242424242422222222000000020202246486B8F91919191B1B19191919191),
    .INIT_43(256'hA6A6868686A6A6A6A6A686848484846464422220002020202222222222222222),
    .INIT_44(256'hF9F9F9F9F7B592B2B2906E4C4C2C4C4E6E4E4C4C4C6E4E2C2A0A0AE8C6C6A6A6),
    .INIT_45(256'hFBFBFBFBFBFBFBFDFDFDFDFDFBFBFBFBFBFBFBF9F9F9F9FBFBFBF9F9F9F9F9F9),
    .INIT_46(256'h909090B2B2B2B2B2D4D5D5D5D5F5F7F7F7F7F7F9F9F9F9F9F9F9FBFBFBFBFBFB),
    .INIT_47(256'h202222424242426264646484848484A4A6A6A6A6A6A6C6C8C8E80A0A2C4C4C6E),
    .INIT_48(256'h0000000000000000002020222222222222222222222220202020222222222222),
    .INIT_49(256'h2222222222202020202222222222222222202020202020202020200000000000),
    .INIT_4A(256'hDDBDBDDDDDDDDDBDBB999BBBBDBB9933882222446688CCAA8866444442444422),
    .INIT_4B(256'h000020202246486B8D91919191B1B19191919191579999999913779999BDDDDD),
    .INIT_4C(256'h8484848464422220202020202222222222222222424242424242422222222200),
    .INIT_4D(256'h4C2C4C4C4E6E4E4C4C6E4E4C2C2A0A0AE8C6C6A6A6A686868686A6A6A8A8A686),
    .INIT_4E(256'hFBFBFBFBFBFBFBFBF9F9F9FBFBFBF9F9F9F9F9F9F9F9F9F9F9D7B2B2B2B06E4C),
    .INIT_4F(256'hF5F7F7F7F7F7F7F7F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFD),
    .INIT_50(256'h8486A6A6A6A6A6A6A6C6E8E8E8E80A2C4E4E6E709090B0B2D2D4D2D2D4D5D5D5),
    .INIT_51(256'h2222222222222222222020202022222222222222222242424244646464646484),
    .INIT_52(256'h2222222222222020202020200000000000000000000000000000000000202222),
    .INIT_53(256'hBB9B55CC4422224488AAAA888866444442222222222200202222000000000020),
    .INIT_54(256'h91B1B1919191919177999B9B99135577799BBDBDBDDDDDDDDDDDDDBD9B999BBD),
    .INIT_55(256'h202222222222222242424242422222222222220000002022224446488D8F9191),
    .INIT_56(256'h4C2C0A0AE8C6C6A6A6A686868686A6A6C8C8C8A6848486846464422020202020),
    .INIT_57(256'hFBFBF9F9F9F9F9F9FBF9F9F9F9F9B292B2B2906E4C2C4C4C4E6E6E4E4C4E6E4E),
    .INIT_58(256'hF9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_59(256'h0A0A2A6E6E6E7090B090B0B2D2D4D4D4D5D5D5D5F7F7F7F7F7F7F7F7F7F9F9F9),
    .INIT_5A(256'h222222222222222222424242646464646484848486A6A6A6A6A6A6A6C6E8EA0A),
    .INIT_5B(256'h0000000000000000000000000000000020222222222222202020202020202020),
    .INIT_5C(256'h6664222222222222220000202200000000000020222222202222222020202000),
    .INIT_5D(256'h993355777779BBBBBDDDDDDDBDBDDDBD9B99BBBD9B79EF862222224488888866),
    .INIT_5E(256'h422222222022222000000000222226488D8FB191919191B1B1B1B1917799BBBB),
    .INIT_5F(256'h8686A6A6A6C8C8A6848484848464424222202020202242222222222222424242),
    .INIT_60(256'hF9F9B492909090704E4C4C4C4C6E6E4E4E4E6E6E4E4C0A0AEAC8C6A6A6A68684),
    .INIT_61(256'hFBFBFBFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9FBFBFBF9F9F9FBFBFBF9F9F9),
    .INIT_62(256'hD2D2D4D5F5F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9FBFBFBFBFBFBFBFBFB),
    .INIT_63(256'h646464646484848686A6A6A6A6A6A6C8E80A0A0A0A2C6E6E6E90B0B2B2B2B2D2),
    .INIT_64(256'h0000202020222222222020202020202020202022222222222220222222424244),
    .INIT_65(256'h0000000000202020202222222022202020202000000000000000000000000000),
    .INIT_66(256'hBDDDDDBD7977999B5511A8442222426688866688886622224444222222000000),
    .INIT_67(256'h202224488D8FB19191919191B191919179999B9B99557999775799BBBBBDBDDD),
    .INIT_68(256'h8464644222202020202222222242222222424242422222222222222222200000),
    .INIT_69(256'h4C4E6E6E4E4E4E6E4E4C0A0A0AE8C6A6A6A6A6848684A6A6A6C8C8A684848484),
    .INIT_6A(256'hF9F9F9F9F9F9F9F9F9FBFBF9F9F9F9F9F9F9F9F9F9F9D792909090906E4C4C4C),
    .INIT_6B(256'hF7F7F7F7F7F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB),
    .INIT_6C(256'hC6C6E8EA0A0A0A0A2C4C6E6E6E90B2B2D2D4D4D2D2D4D5F5F7F7F7F7F7F7F7F7),
    .INIT_6D(256'h2020202020202222222220202222222242424264646464848484A6A6A6A6A6A6),
    .INIT_6E(256'h2220202020200000000000000000000000000000202020222222222220202020),
    .INIT_6F(256'h22224466888888AA884422222222222200000000000000000020202022222222),
    .INIT_70(256'h919191919999999999559999775779997979999B9B9B9B793513333511AA6644),
    .INIT_71(256'h4242422222424242422222222222222222222020202224488D8DB19191919191),
    .INIT_72(256'h0AEAC8A6A6A6A686868484A6A6C8C8C8A6848484848464422220202020202242),
    .INIT_73(256'hF9F9F9F9F9F9F9F9F9F9F9B2906E90906E4E4C4C4C4C6E6E6E4C4C4E4E4C2A0A),
    .INIT_74(256'hF9F9FBFBFBFBFBFBFBFBFBFDFBFBFBFBFBFBFBFBFBF9F9F9F9F9F9F9F9FBFBFB),
    .INIT_75(256'h90B2B2D4D4D4D2D2D4D5F5F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9),
    .INIT_76(256'h22222242424244646464848484A6A6A6A6A6A6C6E8EA0A0A2C2C2A2A4C6E9090),
    .INIT_77(256'h0000000000000000202022222222222020202020202020202020222222202020),
    .INIT_78(256'h0022220000000000000000000020202222222222222020202000000000000000),
    .INIT_79(256'h777779797977777979797735F1F11133EF886644444466888888AAAA66442222),
    .INIT_7A(256'h2222222220222222222224486B8D8F9191B191918F8F8F91997977799955999B),
    .INIT_7B(256'hA6C6C8C8A6868484848464422220202020202242424242222242424242422222),
    .INIT_7C(256'h906E7090706E4E4E4C4C4E6E6E4C4C4E4E4E2C0A0AEAE8C6A6A6A6A6868484A4),
    .INIT_7D(256'hFDFDFDFDFDFDFBFBFBFBF9F9F9F9F9F9F9FBFBFBF9F9F9F9F9F9F9F9F9F9F9B5),
    .INIT_7E(256'hF7F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9F9F9F9F9F9F9F9FBFBFBFBFBFBFBFDFD),
    .INIT_7F(256'hA6A6A6A6A6C6C8E80A2C2C2C2C2C2C2C4E90B2B2B2D2D4D5D4D4D2D4D5F5F7F7),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],p_75_out[7:0]}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],p_75_out[8]}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(ena),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module blk_mem_zrn_blk_mem_gen_top
   (douta,
    addra,
    ena,
    clka);
  output [11:0]douta;
  input [16:0]addra;
  input ena;
  input clka;

  wire [16:0]addra;
  wire clka;
  wire [11:0]douta;
  wire ena;

  blk_mem_zrn_blk_mem_gen_generic_cstr \valid.cstr 
       (.addra(addra),
        .clka(clka),
        .douta(douta),
        .ena(ena));
endmodule

(* C_ADDRA_WIDTH = "17" *) (* C_ADDRB_WIDTH = "17" *) (* C_ALGORITHM = "1" *) 
(* C_AXI_ID_WIDTH = "4" *) (* C_AXI_SLAVE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_BYTE_SIZE = "9" *) (* C_COMMON_CLK = "0" *) (* C_COUNT_18K_BRAM = "3" *) 
(* C_COUNT_36K_BRAM = "29" *) (* C_CTRL_ECC_ALGO = "NONE" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DISABLE_WARN_BHV_COLL = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_ELABORATION_DIR = "./" *) 
(* C_ENABLE_32BIT_ADDRESS = "0" *) (* C_EN_DEEPSLEEP_PIN = "0" *) (* C_EN_ECC_PIPE = "0" *) 
(* C_EN_RDADDRA_CHG = "0" *) (* C_EN_RDADDRB_CHG = "0" *) (* C_EN_SAFETY_CKT = "0" *) 
(* C_EN_SHUTDOWN_PIN = "0" *) (* C_EN_SLEEP_PIN = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     8.178452 mW" *) 
(* C_FAMILY = "artix7" *) (* C_HAS_AXI_ID = "0" *) (* C_HAS_ENA = "1" *) 
(* C_HAS_ENB = "0" *) (* C_HAS_INJECTERR = "0" *) (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
(* C_HAS_MEM_OUTPUT_REGS_B = "0" *) (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
(* C_HAS_REGCEA = "0" *) (* C_HAS_REGCEB = "0" *) (* C_HAS_RSTA = "0" *) 
(* C_HAS_RSTB = "0" *) (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
(* C_INITA_VAL = "0" *) (* C_INITB_VAL = "0" *) (* C_INIT_FILE = "blk_mem_zrn.mem" *) 
(* C_INIT_FILE_NAME = "blk_mem_zrn.mif" *) (* C_INTERFACE_TYPE = "0" *) (* C_LOAD_INIT_FILE = "1" *) 
(* C_MEM_TYPE = "3" *) (* C_MUX_PIPELINE_STAGES = "0" *) (* C_PRIM_TYPE = "1" *) 
(* C_READ_DEPTH_A = "90000" *) (* C_READ_DEPTH_B = "90000" *) (* C_READ_WIDTH_A = "12" *) 
(* C_READ_WIDTH_B = "12" *) (* C_RSTRAM_A = "0" *) (* C_RSTRAM_B = "0" *) 
(* C_RST_PRIORITY_A = "CE" *) (* C_RST_PRIORITY_B = "CE" *) (* C_SIM_COLLISION_CHECK = "ALL" *) 
(* C_USE_BRAM_BLOCK = "0" *) (* C_USE_BYTE_WEA = "0" *) (* C_USE_BYTE_WEB = "0" *) 
(* C_USE_DEFAULT_DATA = "0" *) (* C_USE_ECC = "0" *) (* C_USE_SOFTECC = "0" *) 
(* C_USE_URAM = "0" *) (* C_WEA_WIDTH = "1" *) (* C_WEB_WIDTH = "1" *) 
(* C_WRITE_DEPTH_A = "90000" *) (* C_WRITE_DEPTH_B = "90000" *) (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
(* C_WRITE_MODE_B = "WRITE_FIRST" *) (* C_WRITE_WIDTH_A = "12" *) (* C_WRITE_WIDTH_B = "12" *) 
(* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "blk_mem_gen_v8_3_3" *) (* downgradeipidentifiedwarnings = "yes" *) 
module blk_mem_zrn_blk_mem_gen_v8_3_3
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    deepsleep,
    shutdown,
    rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [0:0]wea;
  input [16:0]addra;
  input [11:0]dina;
  output [11:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [0:0]web;
  input [16:0]addrb;
  input [11:0]dinb;
  output [11:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [16:0]rdaddrecc;
  input sleep;
  input deepsleep;
  input shutdown;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input s_aresetn;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [11:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [11:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [16:0]s_axi_rdaddrecc;

  wire \<const0> ;
  wire [16:0]addra;
  wire clka;
  wire [11:0]douta;
  wire ena;

  assign dbiterr = \<const0> ;
  assign doutb[11] = \<const0> ;
  assign doutb[10] = \<const0> ;
  assign doutb[9] = \<const0> ;
  assign doutb[8] = \<const0> ;
  assign doutb[7] = \<const0> ;
  assign doutb[6] = \<const0> ;
  assign doutb[5] = \<const0> ;
  assign doutb[4] = \<const0> ;
  assign doutb[3] = \<const0> ;
  assign doutb[2] = \<const0> ;
  assign doutb[1] = \<const0> ;
  assign doutb[0] = \<const0> ;
  assign rdaddrecc[16] = \<const0> ;
  assign rdaddrecc[15] = \<const0> ;
  assign rdaddrecc[14] = \<const0> ;
  assign rdaddrecc[13] = \<const0> ;
  assign rdaddrecc[12] = \<const0> ;
  assign rdaddrecc[11] = \<const0> ;
  assign rdaddrecc[10] = \<const0> ;
  assign rdaddrecc[9] = \<const0> ;
  assign rdaddrecc[8] = \<const0> ;
  assign rdaddrecc[7] = \<const0> ;
  assign rdaddrecc[6] = \<const0> ;
  assign rdaddrecc[5] = \<const0> ;
  assign rdaddrecc[4] = \<const0> ;
  assign rdaddrecc[3] = \<const0> ;
  assign rdaddrecc[2] = \<const0> ;
  assign rdaddrecc[1] = \<const0> ;
  assign rdaddrecc[0] = \<const0> ;
  assign rsta_busy = \<const0> ;
  assign rstb_busy = \<const0> ;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[3] = \<const0> ;
  assign s_axi_bid[2] = \<const0> ;
  assign s_axi_bid[1] = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_dbiterr = \<const0> ;
  assign s_axi_rdaddrecc[16] = \<const0> ;
  assign s_axi_rdaddrecc[15] = \<const0> ;
  assign s_axi_rdaddrecc[14] = \<const0> ;
  assign s_axi_rdaddrecc[13] = \<const0> ;
  assign s_axi_rdaddrecc[12] = \<const0> ;
  assign s_axi_rdaddrecc[11] = \<const0> ;
  assign s_axi_rdaddrecc[10] = \<const0> ;
  assign s_axi_rdaddrecc[9] = \<const0> ;
  assign s_axi_rdaddrecc[8] = \<const0> ;
  assign s_axi_rdaddrecc[7] = \<const0> ;
  assign s_axi_rdaddrecc[6] = \<const0> ;
  assign s_axi_rdaddrecc[5] = \<const0> ;
  assign s_axi_rdaddrecc[4] = \<const0> ;
  assign s_axi_rdaddrecc[3] = \<const0> ;
  assign s_axi_rdaddrecc[2] = \<const0> ;
  assign s_axi_rdaddrecc[1] = \<const0> ;
  assign s_axi_rdaddrecc[0] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[3] = \<const0> ;
  assign s_axi_rid[2] = \<const0> ;
  assign s_axi_rid[1] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_sbiterr = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign sbiterr = \<const0> ;
  GND GND
       (.G(\<const0> ));
  blk_mem_zrn_blk_mem_gen_v8_3_3_synth inst_blk_mem_gen
       (.addra(addra),
        .clka(clka),
        .douta(douta),
        .ena(ena));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_3_3_synth" *) 
module blk_mem_zrn_blk_mem_gen_v8_3_3_synth
   (douta,
    addra,
    ena,
    clka);
  output [11:0]douta;
  input [16:0]addra;
  input ena;
  input clka;

  wire [16:0]addra;
  wire clka;
  wire [11:0]douta;
  wire ena;

  blk_mem_zrn_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.addra(addra),
        .clka(clka),
        .douta(douta),
        .ena(ena));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
