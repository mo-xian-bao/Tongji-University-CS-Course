// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Apr 10 14:32:34 2026
// Host        : LAPTOP-V0AHCU9H running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dist_mem_gen_0_sim_netlist.v
// Design      : dist_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dist_mem_gen_0,dist_mem_gen_v8_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (a,
    spo);
  input [10:0]a;
  output [31:0]spo;

  wire [10:0]a;
  wire [31:0]spo;
  wire [31:0]NLW_U0_dpo_UNCONNECTED;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "artix7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "11" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "2048" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "dist_mem_gen_0.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_12 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[31:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule

(* C_ADDR_WIDTH = "11" *) (* C_DEFAULT_DATA = "0" *) (* C_DEPTH = "2048" *) 
(* C_ELABORATION_DIR = "./" *) (* C_FAMILY = "artix7" *) (* C_HAS_CLK = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_DPO = "0" *) (* C_HAS_DPRA = "0" *) 
(* C_HAS_I_CE = "0" *) (* C_HAS_QDPO = "0" *) (* C_HAS_QDPO_CE = "0" *) 
(* C_HAS_QDPO_CLK = "0" *) (* C_HAS_QDPO_RST = "0" *) (* C_HAS_QDPO_SRST = "0" *) 
(* C_HAS_QSPO = "0" *) (* C_HAS_QSPO_CE = "0" *) (* C_HAS_QSPO_RST = "0" *) 
(* C_HAS_QSPO_SRST = "0" *) (* C_HAS_SPO = "1" *) (* C_HAS_WE = "0" *) 
(* C_MEM_INIT_FILE = "dist_mem_gen_0.mif" *) (* C_MEM_TYPE = "0" *) (* C_PARSER_TYPE = "1" *) 
(* C_PIPELINE_STAGES = "0" *) (* C_QCE_JOINED = "0" *) (* C_QUALIFY_WE = "0" *) 
(* C_READ_MIF = "1" *) (* C_REG_A_D_INPUTS = "0" *) (* C_REG_DPRA_INPUT = "0" *) 
(* C_SYNC_ENABLE = "1" *) (* C_WIDTH = "32" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_12
   (a,
    d,
    dpra,
    clk,
    we,
    i_ce,
    qspo_ce,
    qdpo_ce,
    qdpo_clk,
    qspo_rst,
    qdpo_rst,
    qspo_srst,
    qdpo_srst,
    spo,
    dpo,
    qspo,
    qdpo);
  input [10:0]a;
  input [31:0]d;
  input [10:0]dpra;
  input clk;
  input we;
  input i_ce;
  input qspo_ce;
  input qdpo_ce;
  input qdpo_clk;
  input qspo_rst;
  input qdpo_rst;
  input qspo_srst;
  input qdpo_srst;
  output [31:0]spo;
  output [31:0]dpo;
  output [31:0]qspo;
  output [31:0]qdpo;

  wire \<const0> ;
  wire [10:0]a;
  wire [31:0]spo;

  assign dpo[31] = \<const0> ;
  assign dpo[30] = \<const0> ;
  assign dpo[29] = \<const0> ;
  assign dpo[28] = \<const0> ;
  assign dpo[27] = \<const0> ;
  assign dpo[26] = \<const0> ;
  assign dpo[25] = \<const0> ;
  assign dpo[24] = \<const0> ;
  assign dpo[23] = \<const0> ;
  assign dpo[22] = \<const0> ;
  assign dpo[21] = \<const0> ;
  assign dpo[20] = \<const0> ;
  assign dpo[19] = \<const0> ;
  assign dpo[18] = \<const0> ;
  assign dpo[17] = \<const0> ;
  assign dpo[16] = \<const0> ;
  assign dpo[15] = \<const0> ;
  assign dpo[14] = \<const0> ;
  assign dpo[13] = \<const0> ;
  assign dpo[12] = \<const0> ;
  assign dpo[11] = \<const0> ;
  assign dpo[10] = \<const0> ;
  assign dpo[9] = \<const0> ;
  assign dpo[8] = \<const0> ;
  assign dpo[7] = \<const0> ;
  assign dpo[6] = \<const0> ;
  assign dpo[5] = \<const0> ;
  assign dpo[4] = \<const0> ;
  assign dpo[3] = \<const0> ;
  assign dpo[2] = \<const0> ;
  assign dpo[1] = \<const0> ;
  assign dpo[0] = \<const0> ;
  assign qdpo[31] = \<const0> ;
  assign qdpo[30] = \<const0> ;
  assign qdpo[29] = \<const0> ;
  assign qdpo[28] = \<const0> ;
  assign qdpo[27] = \<const0> ;
  assign qdpo[26] = \<const0> ;
  assign qdpo[25] = \<const0> ;
  assign qdpo[24] = \<const0> ;
  assign qdpo[23] = \<const0> ;
  assign qdpo[22] = \<const0> ;
  assign qdpo[21] = \<const0> ;
  assign qdpo[20] = \<const0> ;
  assign qdpo[19] = \<const0> ;
  assign qdpo[18] = \<const0> ;
  assign qdpo[17] = \<const0> ;
  assign qdpo[16] = \<const0> ;
  assign qdpo[15] = \<const0> ;
  assign qdpo[14] = \<const0> ;
  assign qdpo[13] = \<const0> ;
  assign qdpo[12] = \<const0> ;
  assign qdpo[11] = \<const0> ;
  assign qdpo[10] = \<const0> ;
  assign qdpo[9] = \<const0> ;
  assign qdpo[8] = \<const0> ;
  assign qdpo[7] = \<const0> ;
  assign qdpo[6] = \<const0> ;
  assign qdpo[5] = \<const0> ;
  assign qdpo[4] = \<const0> ;
  assign qdpo[3] = \<const0> ;
  assign qdpo[2] = \<const0> ;
  assign qdpo[1] = \<const0> ;
  assign qdpo[0] = \<const0> ;
  assign qspo[31] = \<const0> ;
  assign qspo[30] = \<const0> ;
  assign qspo[29] = \<const0> ;
  assign qspo[28] = \<const0> ;
  assign qspo[27] = \<const0> ;
  assign qspo[26] = \<const0> ;
  assign qspo[25] = \<const0> ;
  assign qspo[24] = \<const0> ;
  assign qspo[23] = \<const0> ;
  assign qspo[22] = \<const0> ;
  assign qspo[21] = \<const0> ;
  assign qspo[20] = \<const0> ;
  assign qspo[19] = \<const0> ;
  assign qspo[18] = \<const0> ;
  assign qspo[17] = \<const0> ;
  assign qspo[16] = \<const0> ;
  assign qspo[15] = \<const0> ;
  assign qspo[14] = \<const0> ;
  assign qspo[13] = \<const0> ;
  assign qspo[12] = \<const0> ;
  assign qspo[11] = \<const0> ;
  assign qspo[10] = \<const0> ;
  assign qspo[9] = \<const0> ;
  assign qspo[8] = \<const0> ;
  assign qspo[7] = \<const0> ;
  assign qspo[6] = \<const0> ;
  assign qspo[5] = \<const0> ;
  assign qspo[4] = \<const0> ;
  assign qspo[3] = \<const0> ;
  assign qspo[2] = \<const0> ;
  assign qspo[1] = \<const0> ;
  assign qspo[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_12_synth \synth_options.dist_mem_inst 
       (.a(a),
        .spo(spo));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_12_synth
   (spo,
    a);
  output [31:0]spo;
  input [10:0]a;

  wire [10:0]a;
  wire [31:0]spo;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_rom \gen_rom.rom_inst 
       (.a(a),
        .spo(spo));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_rom
   (spo,
    a);
  output [31:0]spo;
  input [10:0]a;

  wire [10:0]a;
  wire [31:0]spo;
  wire \spo[0]_INST_0_i_10_n_0 ;
  wire \spo[0]_INST_0_i_11_n_0 ;
  wire \spo[0]_INST_0_i_12_n_0 ;
  wire \spo[0]_INST_0_i_13_n_0 ;
  wire \spo[0]_INST_0_i_14_n_0 ;
  wire \spo[0]_INST_0_i_15_n_0 ;
  wire \spo[0]_INST_0_i_16_n_0 ;
  wire \spo[0]_INST_0_i_17_n_0 ;
  wire \spo[0]_INST_0_i_18_n_0 ;
  wire \spo[0]_INST_0_i_19_n_0 ;
  wire \spo[0]_INST_0_i_1_n_0 ;
  wire \spo[0]_INST_0_i_20_n_0 ;
  wire \spo[0]_INST_0_i_21_n_0 ;
  wire \spo[0]_INST_0_i_22_n_0 ;
  wire \spo[0]_INST_0_i_23_n_0 ;
  wire \spo[0]_INST_0_i_24_n_0 ;
  wire \spo[0]_INST_0_i_25_n_0 ;
  wire \spo[0]_INST_0_i_26_n_0 ;
  wire \spo[0]_INST_0_i_27_n_0 ;
  wire \spo[0]_INST_0_i_28_n_0 ;
  wire \spo[0]_INST_0_i_29_n_0 ;
  wire \spo[0]_INST_0_i_2_n_0 ;
  wire \spo[0]_INST_0_i_30_n_0 ;
  wire \spo[0]_INST_0_i_31_n_0 ;
  wire \spo[0]_INST_0_i_32_n_0 ;
  wire \spo[0]_INST_0_i_33_n_0 ;
  wire \spo[0]_INST_0_i_34_n_0 ;
  wire \spo[0]_INST_0_i_35_n_0 ;
  wire \spo[0]_INST_0_i_36_n_0 ;
  wire \spo[0]_INST_0_i_37_n_0 ;
  wire \spo[0]_INST_0_i_38_n_0 ;
  wire \spo[0]_INST_0_i_39_n_0 ;
  wire \spo[0]_INST_0_i_3_n_0 ;
  wire \spo[0]_INST_0_i_40_n_0 ;
  wire \spo[0]_INST_0_i_41_n_0 ;
  wire \spo[0]_INST_0_i_42_n_0 ;
  wire \spo[0]_INST_0_i_43_n_0 ;
  wire \spo[0]_INST_0_i_44_n_0 ;
  wire \spo[0]_INST_0_i_45_n_0 ;
  wire \spo[0]_INST_0_i_46_n_0 ;
  wire \spo[0]_INST_0_i_47_n_0 ;
  wire \spo[0]_INST_0_i_48_n_0 ;
  wire \spo[0]_INST_0_i_49_n_0 ;
  wire \spo[0]_INST_0_i_4_n_0 ;
  wire \spo[0]_INST_0_i_50_n_0 ;
  wire \spo[0]_INST_0_i_51_n_0 ;
  wire \spo[0]_INST_0_i_52_n_0 ;
  wire \spo[0]_INST_0_i_53_n_0 ;
  wire \spo[0]_INST_0_i_54_n_0 ;
  wire \spo[0]_INST_0_i_5_n_0 ;
  wire \spo[0]_INST_0_i_6_n_0 ;
  wire \spo[0]_INST_0_i_7_n_0 ;
  wire \spo[0]_INST_0_i_8_n_0 ;
  wire \spo[0]_INST_0_i_9_n_0 ;
  wire \spo[10]_INST_0_i_10_n_0 ;
  wire \spo[10]_INST_0_i_11_n_0 ;
  wire \spo[10]_INST_0_i_12_n_0 ;
  wire \spo[10]_INST_0_i_13_n_0 ;
  wire \spo[10]_INST_0_i_14_n_0 ;
  wire \spo[10]_INST_0_i_15_n_0 ;
  wire \spo[10]_INST_0_i_16_n_0 ;
  wire \spo[10]_INST_0_i_17_n_0 ;
  wire \spo[10]_INST_0_i_1_n_0 ;
  wire \spo[10]_INST_0_i_2_n_0 ;
  wire \spo[10]_INST_0_i_3_n_0 ;
  wire \spo[10]_INST_0_i_4_n_0 ;
  wire \spo[10]_INST_0_i_5_n_0 ;
  wire \spo[10]_INST_0_i_6_n_0 ;
  wire \spo[10]_INST_0_i_7_n_0 ;
  wire \spo[10]_INST_0_i_8_n_0 ;
  wire \spo[10]_INST_0_i_9_n_0 ;
  wire \spo[11]_INST_0_i_10_n_0 ;
  wire \spo[11]_INST_0_i_11_n_0 ;
  wire \spo[11]_INST_0_i_12_n_0 ;
  wire \spo[11]_INST_0_i_13_n_0 ;
  wire \spo[11]_INST_0_i_14_n_0 ;
  wire \spo[11]_INST_0_i_15_n_0 ;
  wire \spo[11]_INST_0_i_16_n_0 ;
  wire \spo[11]_INST_0_i_17_n_0 ;
  wire \spo[11]_INST_0_i_18_n_0 ;
  wire \spo[11]_INST_0_i_19_n_0 ;
  wire \spo[11]_INST_0_i_1_n_0 ;
  wire \spo[11]_INST_0_i_20_n_0 ;
  wire \spo[11]_INST_0_i_21_n_0 ;
  wire \spo[11]_INST_0_i_22_n_0 ;
  wire \spo[11]_INST_0_i_23_n_0 ;
  wire \spo[11]_INST_0_i_24_n_0 ;
  wire \spo[11]_INST_0_i_25_n_0 ;
  wire \spo[11]_INST_0_i_26_n_0 ;
  wire \spo[11]_INST_0_i_27_n_0 ;
  wire \spo[11]_INST_0_i_28_n_0 ;
  wire \spo[11]_INST_0_i_29_n_0 ;
  wire \spo[11]_INST_0_i_2_n_0 ;
  wire \spo[11]_INST_0_i_30_n_0 ;
  wire \spo[11]_INST_0_i_3_n_0 ;
  wire \spo[11]_INST_0_i_4_n_0 ;
  wire \spo[11]_INST_0_i_5_n_0 ;
  wire \spo[11]_INST_0_i_6_n_0 ;
  wire \spo[11]_INST_0_i_7_n_0 ;
  wire \spo[11]_INST_0_i_8_n_0 ;
  wire \spo[11]_INST_0_i_9_n_0 ;
  wire \spo[12]_INST_0_i_10_n_0 ;
  wire \spo[12]_INST_0_i_11_n_0 ;
  wire \spo[12]_INST_0_i_12_n_0 ;
  wire \spo[12]_INST_0_i_13_n_0 ;
  wire \spo[12]_INST_0_i_14_n_0 ;
  wire \spo[12]_INST_0_i_15_n_0 ;
  wire \spo[12]_INST_0_i_16_n_0 ;
  wire \spo[12]_INST_0_i_17_n_0 ;
  wire \spo[12]_INST_0_i_18_n_0 ;
  wire \spo[12]_INST_0_i_19_n_0 ;
  wire \spo[12]_INST_0_i_1_n_0 ;
  wire \spo[12]_INST_0_i_20_n_0 ;
  wire \spo[12]_INST_0_i_21_n_0 ;
  wire \spo[12]_INST_0_i_22_n_0 ;
  wire \spo[12]_INST_0_i_23_n_0 ;
  wire \spo[12]_INST_0_i_24_n_0 ;
  wire \spo[12]_INST_0_i_25_n_0 ;
  wire \spo[12]_INST_0_i_26_n_0 ;
  wire \spo[12]_INST_0_i_27_n_0 ;
  wire \spo[12]_INST_0_i_28_n_0 ;
  wire \spo[12]_INST_0_i_29_n_0 ;
  wire \spo[12]_INST_0_i_2_n_0 ;
  wire \spo[12]_INST_0_i_30_n_0 ;
  wire \spo[12]_INST_0_i_31_n_0 ;
  wire \spo[12]_INST_0_i_32_n_0 ;
  wire \spo[12]_INST_0_i_33_n_0 ;
  wire \spo[12]_INST_0_i_34_n_0 ;
  wire \spo[12]_INST_0_i_35_n_0 ;
  wire \spo[12]_INST_0_i_36_n_0 ;
  wire \spo[12]_INST_0_i_37_n_0 ;
  wire \spo[12]_INST_0_i_38_n_0 ;
  wire \spo[12]_INST_0_i_3_n_0 ;
  wire \spo[12]_INST_0_i_4_n_0 ;
  wire \spo[12]_INST_0_i_5_n_0 ;
  wire \spo[12]_INST_0_i_6_n_0 ;
  wire \spo[12]_INST_0_i_7_n_0 ;
  wire \spo[12]_INST_0_i_8_n_0 ;
  wire \spo[12]_INST_0_i_9_n_0 ;
  wire \spo[13]_INST_0_i_10_n_0 ;
  wire \spo[13]_INST_0_i_11_n_0 ;
  wire \spo[13]_INST_0_i_12_n_0 ;
  wire \spo[13]_INST_0_i_13_n_0 ;
  wire \spo[13]_INST_0_i_14_n_0 ;
  wire \spo[13]_INST_0_i_15_n_0 ;
  wire \spo[13]_INST_0_i_16_n_0 ;
  wire \spo[13]_INST_0_i_17_n_0 ;
  wire \spo[13]_INST_0_i_18_n_0 ;
  wire \spo[13]_INST_0_i_19_n_0 ;
  wire \spo[13]_INST_0_i_1_n_0 ;
  wire \spo[13]_INST_0_i_20_n_0 ;
  wire \spo[13]_INST_0_i_21_n_0 ;
  wire \spo[13]_INST_0_i_22_n_0 ;
  wire \spo[13]_INST_0_i_23_n_0 ;
  wire \spo[13]_INST_0_i_24_n_0 ;
  wire \spo[13]_INST_0_i_25_n_0 ;
  wire \spo[13]_INST_0_i_26_n_0 ;
  wire \spo[13]_INST_0_i_27_n_0 ;
  wire \spo[13]_INST_0_i_28_n_0 ;
  wire \spo[13]_INST_0_i_29_n_0 ;
  wire \spo[13]_INST_0_i_2_n_0 ;
  wire \spo[13]_INST_0_i_30_n_0 ;
  wire \spo[13]_INST_0_i_3_n_0 ;
  wire \spo[13]_INST_0_i_4_n_0 ;
  wire \spo[13]_INST_0_i_5_n_0 ;
  wire \spo[13]_INST_0_i_6_n_0 ;
  wire \spo[13]_INST_0_i_7_n_0 ;
  wire \spo[13]_INST_0_i_8_n_0 ;
  wire \spo[13]_INST_0_i_9_n_0 ;
  wire \spo[14]_INST_0_i_10_n_0 ;
  wire \spo[14]_INST_0_i_11_n_0 ;
  wire \spo[14]_INST_0_i_12_n_0 ;
  wire \spo[14]_INST_0_i_13_n_0 ;
  wire \spo[14]_INST_0_i_14_n_0 ;
  wire \spo[14]_INST_0_i_15_n_0 ;
  wire \spo[14]_INST_0_i_16_n_0 ;
  wire \spo[14]_INST_0_i_17_n_0 ;
  wire \spo[14]_INST_0_i_18_n_0 ;
  wire \spo[14]_INST_0_i_19_n_0 ;
  wire \spo[14]_INST_0_i_1_n_0 ;
  wire \spo[14]_INST_0_i_20_n_0 ;
  wire \spo[14]_INST_0_i_21_n_0 ;
  wire \spo[14]_INST_0_i_22_n_0 ;
  wire \spo[14]_INST_0_i_23_n_0 ;
  wire \spo[14]_INST_0_i_24_n_0 ;
  wire \spo[14]_INST_0_i_25_n_0 ;
  wire \spo[14]_INST_0_i_26_n_0 ;
  wire \spo[14]_INST_0_i_2_n_0 ;
  wire \spo[14]_INST_0_i_3_n_0 ;
  wire \spo[14]_INST_0_i_4_n_0 ;
  wire \spo[14]_INST_0_i_5_n_0 ;
  wire \spo[14]_INST_0_i_6_n_0 ;
  wire \spo[14]_INST_0_i_7_n_0 ;
  wire \spo[14]_INST_0_i_8_n_0 ;
  wire \spo[14]_INST_0_i_9_n_0 ;
  wire \spo[15]_INST_0_i_10_n_0 ;
  wire \spo[15]_INST_0_i_11_n_0 ;
  wire \spo[15]_INST_0_i_12_n_0 ;
  wire \spo[15]_INST_0_i_13_n_0 ;
  wire \spo[15]_INST_0_i_14_n_0 ;
  wire \spo[15]_INST_0_i_15_n_0 ;
  wire \spo[15]_INST_0_i_16_n_0 ;
  wire \spo[15]_INST_0_i_17_n_0 ;
  wire \spo[15]_INST_0_i_18_n_0 ;
  wire \spo[15]_INST_0_i_19_n_0 ;
  wire \spo[15]_INST_0_i_1_n_0 ;
  wire \spo[15]_INST_0_i_20_n_0 ;
  wire \spo[15]_INST_0_i_21_n_0 ;
  wire \spo[15]_INST_0_i_22_n_0 ;
  wire \spo[15]_INST_0_i_2_n_0 ;
  wire \spo[15]_INST_0_i_3_n_0 ;
  wire \spo[15]_INST_0_i_4_n_0 ;
  wire \spo[15]_INST_0_i_5_n_0 ;
  wire \spo[15]_INST_0_i_6_n_0 ;
  wire \spo[15]_INST_0_i_7_n_0 ;
  wire \spo[15]_INST_0_i_8_n_0 ;
  wire \spo[15]_INST_0_i_9_n_0 ;
  wire \spo[16]_INST_0_i_10_n_0 ;
  wire \spo[16]_INST_0_i_11_n_0 ;
  wire \spo[16]_INST_0_i_12_n_0 ;
  wire \spo[16]_INST_0_i_13_n_0 ;
  wire \spo[16]_INST_0_i_14_n_0 ;
  wire \spo[16]_INST_0_i_15_n_0 ;
  wire \spo[16]_INST_0_i_16_n_0 ;
  wire \spo[16]_INST_0_i_17_n_0 ;
  wire \spo[16]_INST_0_i_18_n_0 ;
  wire \spo[16]_INST_0_i_19_n_0 ;
  wire \spo[16]_INST_0_i_1_n_0 ;
  wire \spo[16]_INST_0_i_20_n_0 ;
  wire \spo[16]_INST_0_i_21_n_0 ;
  wire \spo[16]_INST_0_i_22_n_0 ;
  wire \spo[16]_INST_0_i_23_n_0 ;
  wire \spo[16]_INST_0_i_24_n_0 ;
  wire \spo[16]_INST_0_i_25_n_0 ;
  wire \spo[16]_INST_0_i_26_n_0 ;
  wire \spo[16]_INST_0_i_27_n_0 ;
  wire \spo[16]_INST_0_i_28_n_0 ;
  wire \spo[16]_INST_0_i_29_n_0 ;
  wire \spo[16]_INST_0_i_2_n_0 ;
  wire \spo[16]_INST_0_i_30_n_0 ;
  wire \spo[16]_INST_0_i_31_n_0 ;
  wire \spo[16]_INST_0_i_32_n_0 ;
  wire \spo[16]_INST_0_i_33_n_0 ;
  wire \spo[16]_INST_0_i_34_n_0 ;
  wire \spo[16]_INST_0_i_35_n_0 ;
  wire \spo[16]_INST_0_i_36_n_0 ;
  wire \spo[16]_INST_0_i_37_n_0 ;
  wire \spo[16]_INST_0_i_38_n_0 ;
  wire \spo[16]_INST_0_i_39_n_0 ;
  wire \spo[16]_INST_0_i_3_n_0 ;
  wire \spo[16]_INST_0_i_40_n_0 ;
  wire \spo[16]_INST_0_i_41_n_0 ;
  wire \spo[16]_INST_0_i_42_n_0 ;
  wire \spo[16]_INST_0_i_43_n_0 ;
  wire \spo[16]_INST_0_i_44_n_0 ;
  wire \spo[16]_INST_0_i_45_n_0 ;
  wire \spo[16]_INST_0_i_46_n_0 ;
  wire \spo[16]_INST_0_i_47_n_0 ;
  wire \spo[16]_INST_0_i_48_n_0 ;
  wire \spo[16]_INST_0_i_49_n_0 ;
  wire \spo[16]_INST_0_i_4_n_0 ;
  wire \spo[16]_INST_0_i_50_n_0 ;
  wire \spo[16]_INST_0_i_51_n_0 ;
  wire \spo[16]_INST_0_i_52_n_0 ;
  wire \spo[16]_INST_0_i_53_n_0 ;
  wire \spo[16]_INST_0_i_5_n_0 ;
  wire \spo[16]_INST_0_i_6_n_0 ;
  wire \spo[16]_INST_0_i_7_n_0 ;
  wire \spo[16]_INST_0_i_8_n_0 ;
  wire \spo[16]_INST_0_i_9_n_0 ;
  wire \spo[17]_INST_0_i_10_n_0 ;
  wire \spo[17]_INST_0_i_11_n_0 ;
  wire \spo[17]_INST_0_i_12_n_0 ;
  wire \spo[17]_INST_0_i_13_n_0 ;
  wire \spo[17]_INST_0_i_14_n_0 ;
  wire \spo[17]_INST_0_i_15_n_0 ;
  wire \spo[17]_INST_0_i_16_n_0 ;
  wire \spo[17]_INST_0_i_17_n_0 ;
  wire \spo[17]_INST_0_i_18_n_0 ;
  wire \spo[17]_INST_0_i_19_n_0 ;
  wire \spo[17]_INST_0_i_1_n_0 ;
  wire \spo[17]_INST_0_i_20_n_0 ;
  wire \spo[17]_INST_0_i_21_n_0 ;
  wire \spo[17]_INST_0_i_22_n_0 ;
  wire \spo[17]_INST_0_i_23_n_0 ;
  wire \spo[17]_INST_0_i_24_n_0 ;
  wire \spo[17]_INST_0_i_25_n_0 ;
  wire \spo[17]_INST_0_i_26_n_0 ;
  wire \spo[17]_INST_0_i_27_n_0 ;
  wire \spo[17]_INST_0_i_28_n_0 ;
  wire \spo[17]_INST_0_i_29_n_0 ;
  wire \spo[17]_INST_0_i_2_n_0 ;
  wire \spo[17]_INST_0_i_30_n_0 ;
  wire \spo[17]_INST_0_i_31_n_0 ;
  wire \spo[17]_INST_0_i_32_n_0 ;
  wire \spo[17]_INST_0_i_33_n_0 ;
  wire \spo[17]_INST_0_i_34_n_0 ;
  wire \spo[17]_INST_0_i_35_n_0 ;
  wire \spo[17]_INST_0_i_36_n_0 ;
  wire \spo[17]_INST_0_i_37_n_0 ;
  wire \spo[17]_INST_0_i_38_n_0 ;
  wire \spo[17]_INST_0_i_39_n_0 ;
  wire \spo[17]_INST_0_i_3_n_0 ;
  wire \spo[17]_INST_0_i_40_n_0 ;
  wire \spo[17]_INST_0_i_41_n_0 ;
  wire \spo[17]_INST_0_i_42_n_0 ;
  wire \spo[17]_INST_0_i_43_n_0 ;
  wire \spo[17]_INST_0_i_44_n_0 ;
  wire \spo[17]_INST_0_i_45_n_0 ;
  wire \spo[17]_INST_0_i_46_n_0 ;
  wire \spo[17]_INST_0_i_4_n_0 ;
  wire \spo[17]_INST_0_i_5_n_0 ;
  wire \spo[17]_INST_0_i_6_n_0 ;
  wire \spo[17]_INST_0_i_7_n_0 ;
  wire \spo[17]_INST_0_i_8_n_0 ;
  wire \spo[17]_INST_0_i_9_n_0 ;
  wire \spo[18]_INST_0_i_10_n_0 ;
  wire \spo[18]_INST_0_i_11_n_0 ;
  wire \spo[18]_INST_0_i_12_n_0 ;
  wire \spo[18]_INST_0_i_13_n_0 ;
  wire \spo[18]_INST_0_i_14_n_0 ;
  wire \spo[18]_INST_0_i_15_n_0 ;
  wire \spo[18]_INST_0_i_16_n_0 ;
  wire \spo[18]_INST_0_i_17_n_0 ;
  wire \spo[18]_INST_0_i_18_n_0 ;
  wire \spo[18]_INST_0_i_19_n_0 ;
  wire \spo[18]_INST_0_i_1_n_0 ;
  wire \spo[18]_INST_0_i_20_n_0 ;
  wire \spo[18]_INST_0_i_21_n_0 ;
  wire \spo[18]_INST_0_i_22_n_0 ;
  wire \spo[18]_INST_0_i_23_n_0 ;
  wire \spo[18]_INST_0_i_24_n_0 ;
  wire \spo[18]_INST_0_i_25_n_0 ;
  wire \spo[18]_INST_0_i_26_n_0 ;
  wire \spo[18]_INST_0_i_27_n_0 ;
  wire \spo[18]_INST_0_i_28_n_0 ;
  wire \spo[18]_INST_0_i_29_n_0 ;
  wire \spo[18]_INST_0_i_2_n_0 ;
  wire \spo[18]_INST_0_i_30_n_0 ;
  wire \spo[18]_INST_0_i_31_n_0 ;
  wire \spo[18]_INST_0_i_32_n_0 ;
  wire \spo[18]_INST_0_i_33_n_0 ;
  wire \spo[18]_INST_0_i_34_n_0 ;
  wire \spo[18]_INST_0_i_35_n_0 ;
  wire \spo[18]_INST_0_i_36_n_0 ;
  wire \spo[18]_INST_0_i_37_n_0 ;
  wire \spo[18]_INST_0_i_38_n_0 ;
  wire \spo[18]_INST_0_i_39_n_0 ;
  wire \spo[18]_INST_0_i_3_n_0 ;
  wire \spo[18]_INST_0_i_40_n_0 ;
  wire \spo[18]_INST_0_i_41_n_0 ;
  wire \spo[18]_INST_0_i_42_n_0 ;
  wire \spo[18]_INST_0_i_43_n_0 ;
  wire \spo[18]_INST_0_i_4_n_0 ;
  wire \spo[18]_INST_0_i_5_n_0 ;
  wire \spo[18]_INST_0_i_6_n_0 ;
  wire \spo[18]_INST_0_i_7_n_0 ;
  wire \spo[18]_INST_0_i_8_n_0 ;
  wire \spo[18]_INST_0_i_9_n_0 ;
  wire \spo[19]_INST_0_i_10_n_0 ;
  wire \spo[19]_INST_0_i_11_n_0 ;
  wire \spo[19]_INST_0_i_12_n_0 ;
  wire \spo[19]_INST_0_i_13_n_0 ;
  wire \spo[19]_INST_0_i_14_n_0 ;
  wire \spo[19]_INST_0_i_15_n_0 ;
  wire \spo[19]_INST_0_i_16_n_0 ;
  wire \spo[19]_INST_0_i_17_n_0 ;
  wire \spo[19]_INST_0_i_18_n_0 ;
  wire \spo[19]_INST_0_i_19_n_0 ;
  wire \spo[19]_INST_0_i_1_n_0 ;
  wire \spo[19]_INST_0_i_20_n_0 ;
  wire \spo[19]_INST_0_i_21_n_0 ;
  wire \spo[19]_INST_0_i_22_n_0 ;
  wire \spo[19]_INST_0_i_23_n_0 ;
  wire \spo[19]_INST_0_i_24_n_0 ;
  wire \spo[19]_INST_0_i_25_n_0 ;
  wire \spo[19]_INST_0_i_26_n_0 ;
  wire \spo[19]_INST_0_i_27_n_0 ;
  wire \spo[19]_INST_0_i_28_n_0 ;
  wire \spo[19]_INST_0_i_29_n_0 ;
  wire \spo[19]_INST_0_i_2_n_0 ;
  wire \spo[19]_INST_0_i_30_n_0 ;
  wire \spo[19]_INST_0_i_31_n_0 ;
  wire \spo[19]_INST_0_i_32_n_0 ;
  wire \spo[19]_INST_0_i_33_n_0 ;
  wire \spo[19]_INST_0_i_34_n_0 ;
  wire \spo[19]_INST_0_i_35_n_0 ;
  wire \spo[19]_INST_0_i_3_n_0 ;
  wire \spo[19]_INST_0_i_4_n_0 ;
  wire \spo[19]_INST_0_i_5_n_0 ;
  wire \spo[19]_INST_0_i_6_n_0 ;
  wire \spo[19]_INST_0_i_7_n_0 ;
  wire \spo[19]_INST_0_i_8_n_0 ;
  wire \spo[19]_INST_0_i_9_n_0 ;
  wire \spo[1]_INST_0_i_10_n_0 ;
  wire \spo[1]_INST_0_i_11_n_0 ;
  wire \spo[1]_INST_0_i_12_n_0 ;
  wire \spo[1]_INST_0_i_13_n_0 ;
  wire \spo[1]_INST_0_i_14_n_0 ;
  wire \spo[1]_INST_0_i_15_n_0 ;
  wire \spo[1]_INST_0_i_16_n_0 ;
  wire \spo[1]_INST_0_i_17_n_0 ;
  wire \spo[1]_INST_0_i_18_n_0 ;
  wire \spo[1]_INST_0_i_19_n_0 ;
  wire \spo[1]_INST_0_i_1_n_0 ;
  wire \spo[1]_INST_0_i_20_n_0 ;
  wire \spo[1]_INST_0_i_21_n_0 ;
  wire \spo[1]_INST_0_i_22_n_0 ;
  wire \spo[1]_INST_0_i_23_n_0 ;
  wire \spo[1]_INST_0_i_24_n_0 ;
  wire \spo[1]_INST_0_i_25_n_0 ;
  wire \spo[1]_INST_0_i_26_n_0 ;
  wire \spo[1]_INST_0_i_27_n_0 ;
  wire \spo[1]_INST_0_i_28_n_0 ;
  wire \spo[1]_INST_0_i_29_n_0 ;
  wire \spo[1]_INST_0_i_2_n_0 ;
  wire \spo[1]_INST_0_i_30_n_0 ;
  wire \spo[1]_INST_0_i_31_n_0 ;
  wire \spo[1]_INST_0_i_32_n_0 ;
  wire \spo[1]_INST_0_i_33_n_0 ;
  wire \spo[1]_INST_0_i_34_n_0 ;
  wire \spo[1]_INST_0_i_35_n_0 ;
  wire \spo[1]_INST_0_i_36_n_0 ;
  wire \spo[1]_INST_0_i_37_n_0 ;
  wire \spo[1]_INST_0_i_38_n_0 ;
  wire \spo[1]_INST_0_i_39_n_0 ;
  wire \spo[1]_INST_0_i_3_n_0 ;
  wire \spo[1]_INST_0_i_40_n_0 ;
  wire \spo[1]_INST_0_i_41_n_0 ;
  wire \spo[1]_INST_0_i_4_n_0 ;
  wire \spo[1]_INST_0_i_5_n_0 ;
  wire \spo[1]_INST_0_i_6_n_0 ;
  wire \spo[1]_INST_0_i_7_n_0 ;
  wire \spo[1]_INST_0_i_8_n_0 ;
  wire \spo[1]_INST_0_i_9_n_0 ;
  wire \spo[20]_INST_0_i_10_n_0 ;
  wire \spo[20]_INST_0_i_11_n_0 ;
  wire \spo[20]_INST_0_i_12_n_0 ;
  wire \spo[20]_INST_0_i_13_n_0 ;
  wire \spo[20]_INST_0_i_14_n_0 ;
  wire \spo[20]_INST_0_i_15_n_0 ;
  wire \spo[20]_INST_0_i_16_n_0 ;
  wire \spo[20]_INST_0_i_17_n_0 ;
  wire \spo[20]_INST_0_i_18_n_0 ;
  wire \spo[20]_INST_0_i_19_n_0 ;
  wire \spo[20]_INST_0_i_1_n_0 ;
  wire \spo[20]_INST_0_i_20_n_0 ;
  wire \spo[20]_INST_0_i_21_n_0 ;
  wire \spo[20]_INST_0_i_22_n_0 ;
  wire \spo[20]_INST_0_i_23_n_0 ;
  wire \spo[20]_INST_0_i_24_n_0 ;
  wire \spo[20]_INST_0_i_25_n_0 ;
  wire \spo[20]_INST_0_i_26_n_0 ;
  wire \spo[20]_INST_0_i_27_n_0 ;
  wire \spo[20]_INST_0_i_28_n_0 ;
  wire \spo[20]_INST_0_i_29_n_0 ;
  wire \spo[20]_INST_0_i_2_n_0 ;
  wire \spo[20]_INST_0_i_30_n_0 ;
  wire \spo[20]_INST_0_i_31_n_0 ;
  wire \spo[20]_INST_0_i_32_n_0 ;
  wire \spo[20]_INST_0_i_33_n_0 ;
  wire \spo[20]_INST_0_i_34_n_0 ;
  wire \spo[20]_INST_0_i_35_n_0 ;
  wire \spo[20]_INST_0_i_36_n_0 ;
  wire \spo[20]_INST_0_i_37_n_0 ;
  wire \spo[20]_INST_0_i_38_n_0 ;
  wire \spo[20]_INST_0_i_39_n_0 ;
  wire \spo[20]_INST_0_i_3_n_0 ;
  wire \spo[20]_INST_0_i_40_n_0 ;
  wire \spo[20]_INST_0_i_41_n_0 ;
  wire \spo[20]_INST_0_i_42_n_0 ;
  wire \spo[20]_INST_0_i_4_n_0 ;
  wire \spo[20]_INST_0_i_5_n_0 ;
  wire \spo[20]_INST_0_i_6_n_0 ;
  wire \spo[20]_INST_0_i_7_n_0 ;
  wire \spo[20]_INST_0_i_8_n_0 ;
  wire \spo[20]_INST_0_i_9_n_0 ;
  wire \spo[21]_INST_0_i_10_n_0 ;
  wire \spo[21]_INST_0_i_11_n_0 ;
  wire \spo[21]_INST_0_i_12_n_0 ;
  wire \spo[21]_INST_0_i_13_n_0 ;
  wire \spo[21]_INST_0_i_14_n_0 ;
  wire \spo[21]_INST_0_i_15_n_0 ;
  wire \spo[21]_INST_0_i_16_n_0 ;
  wire \spo[21]_INST_0_i_17_n_0 ;
  wire \spo[21]_INST_0_i_18_n_0 ;
  wire \spo[21]_INST_0_i_19_n_0 ;
  wire \spo[21]_INST_0_i_1_n_0 ;
  wire \spo[21]_INST_0_i_20_n_0 ;
  wire \spo[21]_INST_0_i_21_n_0 ;
  wire \spo[21]_INST_0_i_22_n_0 ;
  wire \spo[21]_INST_0_i_23_n_0 ;
  wire \spo[21]_INST_0_i_24_n_0 ;
  wire \spo[21]_INST_0_i_25_n_0 ;
  wire \spo[21]_INST_0_i_26_n_0 ;
  wire \spo[21]_INST_0_i_27_n_0 ;
  wire \spo[21]_INST_0_i_28_n_0 ;
  wire \spo[21]_INST_0_i_29_n_0 ;
  wire \spo[21]_INST_0_i_2_n_0 ;
  wire \spo[21]_INST_0_i_30_n_0 ;
  wire \spo[21]_INST_0_i_31_n_0 ;
  wire \spo[21]_INST_0_i_32_n_0 ;
  wire \spo[21]_INST_0_i_33_n_0 ;
  wire \spo[21]_INST_0_i_34_n_0 ;
  wire \spo[21]_INST_0_i_35_n_0 ;
  wire \spo[21]_INST_0_i_36_n_0 ;
  wire \spo[21]_INST_0_i_37_n_0 ;
  wire \spo[21]_INST_0_i_38_n_0 ;
  wire \spo[21]_INST_0_i_39_n_0 ;
  wire \spo[21]_INST_0_i_3_n_0 ;
  wire \spo[21]_INST_0_i_40_n_0 ;
  wire \spo[21]_INST_0_i_41_n_0 ;
  wire \spo[21]_INST_0_i_42_n_0 ;
  wire \spo[21]_INST_0_i_43_n_0 ;
  wire \spo[21]_INST_0_i_44_n_0 ;
  wire \spo[21]_INST_0_i_4_n_0 ;
  wire \spo[21]_INST_0_i_5_n_0 ;
  wire \spo[21]_INST_0_i_6_n_0 ;
  wire \spo[21]_INST_0_i_7_n_0 ;
  wire \spo[21]_INST_0_i_8_n_0 ;
  wire \spo[21]_INST_0_i_9_n_0 ;
  wire \spo[22]_INST_0_i_10_n_0 ;
  wire \spo[22]_INST_0_i_11_n_0 ;
  wire \spo[22]_INST_0_i_12_n_0 ;
  wire \spo[22]_INST_0_i_13_n_0 ;
  wire \spo[22]_INST_0_i_14_n_0 ;
  wire \spo[22]_INST_0_i_15_n_0 ;
  wire \spo[22]_INST_0_i_16_n_0 ;
  wire \spo[22]_INST_0_i_17_n_0 ;
  wire \spo[22]_INST_0_i_18_n_0 ;
  wire \spo[22]_INST_0_i_19_n_0 ;
  wire \spo[22]_INST_0_i_1_n_0 ;
  wire \spo[22]_INST_0_i_20_n_0 ;
  wire \spo[22]_INST_0_i_21_n_0 ;
  wire \spo[22]_INST_0_i_22_n_0 ;
  wire \spo[22]_INST_0_i_23_n_0 ;
  wire \spo[22]_INST_0_i_24_n_0 ;
  wire \spo[22]_INST_0_i_25_n_0 ;
  wire \spo[22]_INST_0_i_26_n_0 ;
  wire \spo[22]_INST_0_i_27_n_0 ;
  wire \spo[22]_INST_0_i_28_n_0 ;
  wire \spo[22]_INST_0_i_29_n_0 ;
  wire \spo[22]_INST_0_i_2_n_0 ;
  wire \spo[22]_INST_0_i_30_n_0 ;
  wire \spo[22]_INST_0_i_31_n_0 ;
  wire \spo[22]_INST_0_i_32_n_0 ;
  wire \spo[22]_INST_0_i_33_n_0 ;
  wire \spo[22]_INST_0_i_34_n_0 ;
  wire \spo[22]_INST_0_i_35_n_0 ;
  wire \spo[22]_INST_0_i_36_n_0 ;
  wire \spo[22]_INST_0_i_3_n_0 ;
  wire \spo[22]_INST_0_i_4_n_0 ;
  wire \spo[22]_INST_0_i_5_n_0 ;
  wire \spo[22]_INST_0_i_6_n_0 ;
  wire \spo[22]_INST_0_i_7_n_0 ;
  wire \spo[22]_INST_0_i_8_n_0 ;
  wire \spo[22]_INST_0_i_9_n_0 ;
  wire \spo[23]_INST_0_i_10_n_0 ;
  wire \spo[23]_INST_0_i_11_n_0 ;
  wire \spo[23]_INST_0_i_12_n_0 ;
  wire \spo[23]_INST_0_i_13_n_0 ;
  wire \spo[23]_INST_0_i_14_n_0 ;
  wire \spo[23]_INST_0_i_15_n_0 ;
  wire \spo[23]_INST_0_i_16_n_0 ;
  wire \spo[23]_INST_0_i_17_n_0 ;
  wire \spo[23]_INST_0_i_18_n_0 ;
  wire \spo[23]_INST_0_i_19_n_0 ;
  wire \spo[23]_INST_0_i_1_n_0 ;
  wire \spo[23]_INST_0_i_20_n_0 ;
  wire \spo[23]_INST_0_i_21_n_0 ;
  wire \spo[23]_INST_0_i_22_n_0 ;
  wire \spo[23]_INST_0_i_23_n_0 ;
  wire \spo[23]_INST_0_i_24_n_0 ;
  wire \spo[23]_INST_0_i_25_n_0 ;
  wire \spo[23]_INST_0_i_26_n_0 ;
  wire \spo[23]_INST_0_i_27_n_0 ;
  wire \spo[23]_INST_0_i_28_n_0 ;
  wire \spo[23]_INST_0_i_29_n_0 ;
  wire \spo[23]_INST_0_i_2_n_0 ;
  wire \spo[23]_INST_0_i_30_n_0 ;
  wire \spo[23]_INST_0_i_31_n_0 ;
  wire \spo[23]_INST_0_i_32_n_0 ;
  wire \spo[23]_INST_0_i_33_n_0 ;
  wire \spo[23]_INST_0_i_34_n_0 ;
  wire \spo[23]_INST_0_i_35_n_0 ;
  wire \spo[23]_INST_0_i_36_n_0 ;
  wire \spo[23]_INST_0_i_3_n_0 ;
  wire \spo[23]_INST_0_i_4_n_0 ;
  wire \spo[23]_INST_0_i_5_n_0 ;
  wire \spo[23]_INST_0_i_6_n_0 ;
  wire \spo[23]_INST_0_i_7_n_0 ;
  wire \spo[23]_INST_0_i_8_n_0 ;
  wire \spo[23]_INST_0_i_9_n_0 ;
  wire \spo[24]_INST_0_i_10_n_0 ;
  wire \spo[24]_INST_0_i_11_n_0 ;
  wire \spo[24]_INST_0_i_12_n_0 ;
  wire \spo[24]_INST_0_i_13_n_0 ;
  wire \spo[24]_INST_0_i_14_n_0 ;
  wire \spo[24]_INST_0_i_15_n_0 ;
  wire \spo[24]_INST_0_i_16_n_0 ;
  wire \spo[24]_INST_0_i_17_n_0 ;
  wire \spo[24]_INST_0_i_18_n_0 ;
  wire \spo[24]_INST_0_i_19_n_0 ;
  wire \spo[24]_INST_0_i_1_n_0 ;
  wire \spo[24]_INST_0_i_20_n_0 ;
  wire \spo[24]_INST_0_i_21_n_0 ;
  wire \spo[24]_INST_0_i_22_n_0 ;
  wire \spo[24]_INST_0_i_23_n_0 ;
  wire \spo[24]_INST_0_i_24_n_0 ;
  wire \spo[24]_INST_0_i_25_n_0 ;
  wire \spo[24]_INST_0_i_26_n_0 ;
  wire \spo[24]_INST_0_i_27_n_0 ;
  wire \spo[24]_INST_0_i_28_n_0 ;
  wire \spo[24]_INST_0_i_29_n_0 ;
  wire \spo[24]_INST_0_i_2_n_0 ;
  wire \spo[24]_INST_0_i_30_n_0 ;
  wire \spo[24]_INST_0_i_3_n_0 ;
  wire \spo[24]_INST_0_i_4_n_0 ;
  wire \spo[24]_INST_0_i_5_n_0 ;
  wire \spo[24]_INST_0_i_6_n_0 ;
  wire \spo[24]_INST_0_i_7_n_0 ;
  wire \spo[24]_INST_0_i_8_n_0 ;
  wire \spo[24]_INST_0_i_9_n_0 ;
  wire \spo[25]_INST_0_i_10_n_0 ;
  wire \spo[25]_INST_0_i_11_n_0 ;
  wire \spo[25]_INST_0_i_12_n_0 ;
  wire \spo[25]_INST_0_i_13_n_0 ;
  wire \spo[25]_INST_0_i_14_n_0 ;
  wire \spo[25]_INST_0_i_15_n_0 ;
  wire \spo[25]_INST_0_i_16_n_0 ;
  wire \spo[25]_INST_0_i_17_n_0 ;
  wire \spo[25]_INST_0_i_18_n_0 ;
  wire \spo[25]_INST_0_i_19_n_0 ;
  wire \spo[25]_INST_0_i_1_n_0 ;
  wire \spo[25]_INST_0_i_20_n_0 ;
  wire \spo[25]_INST_0_i_21_n_0 ;
  wire \spo[25]_INST_0_i_22_n_0 ;
  wire \spo[25]_INST_0_i_23_n_0 ;
  wire \spo[25]_INST_0_i_24_n_0 ;
  wire \spo[25]_INST_0_i_25_n_0 ;
  wire \spo[25]_INST_0_i_26_n_0 ;
  wire \spo[25]_INST_0_i_27_n_0 ;
  wire \spo[25]_INST_0_i_28_n_0 ;
  wire \spo[25]_INST_0_i_29_n_0 ;
  wire \spo[25]_INST_0_i_2_n_0 ;
  wire \spo[25]_INST_0_i_30_n_0 ;
  wire \spo[25]_INST_0_i_31_n_0 ;
  wire \spo[25]_INST_0_i_32_n_0 ;
  wire \spo[25]_INST_0_i_3_n_0 ;
  wire \spo[25]_INST_0_i_4_n_0 ;
  wire \spo[25]_INST_0_i_5_n_0 ;
  wire \spo[25]_INST_0_i_6_n_0 ;
  wire \spo[25]_INST_0_i_7_n_0 ;
  wire \spo[25]_INST_0_i_8_n_0 ;
  wire \spo[25]_INST_0_i_9_n_0 ;
  wire \spo[26]_INST_0_i_10_n_0 ;
  wire \spo[26]_INST_0_i_11_n_0 ;
  wire \spo[26]_INST_0_i_12_n_0 ;
  wire \spo[26]_INST_0_i_13_n_0 ;
  wire \spo[26]_INST_0_i_14_n_0 ;
  wire \spo[26]_INST_0_i_15_n_0 ;
  wire \spo[26]_INST_0_i_16_n_0 ;
  wire \spo[26]_INST_0_i_17_n_0 ;
  wire \spo[26]_INST_0_i_18_n_0 ;
  wire \spo[26]_INST_0_i_19_n_0 ;
  wire \spo[26]_INST_0_i_1_n_0 ;
  wire \spo[26]_INST_0_i_20_n_0 ;
  wire \spo[26]_INST_0_i_21_n_0 ;
  wire \spo[26]_INST_0_i_22_n_0 ;
  wire \spo[26]_INST_0_i_23_n_0 ;
  wire \spo[26]_INST_0_i_24_n_0 ;
  wire \spo[26]_INST_0_i_25_n_0 ;
  wire \spo[26]_INST_0_i_26_n_0 ;
  wire \spo[26]_INST_0_i_27_n_0 ;
  wire \spo[26]_INST_0_i_28_n_0 ;
  wire \spo[26]_INST_0_i_29_n_0 ;
  wire \spo[26]_INST_0_i_2_n_0 ;
  wire \spo[26]_INST_0_i_30_n_0 ;
  wire \spo[26]_INST_0_i_31_n_0 ;
  wire \spo[26]_INST_0_i_32_n_0 ;
  wire \spo[26]_INST_0_i_33_n_0 ;
  wire \spo[26]_INST_0_i_34_n_0 ;
  wire \spo[26]_INST_0_i_35_n_0 ;
  wire \spo[26]_INST_0_i_36_n_0 ;
  wire \spo[26]_INST_0_i_37_n_0 ;
  wire \spo[26]_INST_0_i_38_n_0 ;
  wire \spo[26]_INST_0_i_39_n_0 ;
  wire \spo[26]_INST_0_i_3_n_0 ;
  wire \spo[26]_INST_0_i_40_n_0 ;
  wire \spo[26]_INST_0_i_41_n_0 ;
  wire \spo[26]_INST_0_i_42_n_0 ;
  wire \spo[26]_INST_0_i_43_n_0 ;
  wire \spo[26]_INST_0_i_4_n_0 ;
  wire \spo[26]_INST_0_i_5_n_0 ;
  wire \spo[26]_INST_0_i_6_n_0 ;
  wire \spo[26]_INST_0_i_7_n_0 ;
  wire \spo[26]_INST_0_i_8_n_0 ;
  wire \spo[26]_INST_0_i_9_n_0 ;
  wire \spo[27]_INST_0_i_10_n_0 ;
  wire \spo[27]_INST_0_i_11_n_0 ;
  wire \spo[27]_INST_0_i_12_n_0 ;
  wire \spo[27]_INST_0_i_13_n_0 ;
  wire \spo[27]_INST_0_i_14_n_0 ;
  wire \spo[27]_INST_0_i_15_n_0 ;
  wire \spo[27]_INST_0_i_16_n_0 ;
  wire \spo[27]_INST_0_i_17_n_0 ;
  wire \spo[27]_INST_0_i_18_n_0 ;
  wire \spo[27]_INST_0_i_19_n_0 ;
  wire \spo[27]_INST_0_i_1_n_0 ;
  wire \spo[27]_INST_0_i_20_n_0 ;
  wire \spo[27]_INST_0_i_21_n_0 ;
  wire \spo[27]_INST_0_i_22_n_0 ;
  wire \spo[27]_INST_0_i_23_n_0 ;
  wire \spo[27]_INST_0_i_24_n_0 ;
  wire \spo[27]_INST_0_i_25_n_0 ;
  wire \spo[27]_INST_0_i_26_n_0 ;
  wire \spo[27]_INST_0_i_27_n_0 ;
  wire \spo[27]_INST_0_i_28_n_0 ;
  wire \spo[27]_INST_0_i_29_n_0 ;
  wire \spo[27]_INST_0_i_2_n_0 ;
  wire \spo[27]_INST_0_i_30_n_0 ;
  wire \spo[27]_INST_0_i_31_n_0 ;
  wire \spo[27]_INST_0_i_32_n_0 ;
  wire \spo[27]_INST_0_i_33_n_0 ;
  wire \spo[27]_INST_0_i_34_n_0 ;
  wire \spo[27]_INST_0_i_35_n_0 ;
  wire \spo[27]_INST_0_i_36_n_0 ;
  wire \spo[27]_INST_0_i_37_n_0 ;
  wire \spo[27]_INST_0_i_38_n_0 ;
  wire \spo[27]_INST_0_i_39_n_0 ;
  wire \spo[27]_INST_0_i_3_n_0 ;
  wire \spo[27]_INST_0_i_40_n_0 ;
  wire \spo[27]_INST_0_i_41_n_0 ;
  wire \spo[27]_INST_0_i_42_n_0 ;
  wire \spo[27]_INST_0_i_43_n_0 ;
  wire \spo[27]_INST_0_i_44_n_0 ;
  wire \spo[27]_INST_0_i_4_n_0 ;
  wire \spo[27]_INST_0_i_5_n_0 ;
  wire \spo[27]_INST_0_i_6_n_0 ;
  wire \spo[27]_INST_0_i_7_n_0 ;
  wire \spo[27]_INST_0_i_8_n_0 ;
  wire \spo[27]_INST_0_i_9_n_0 ;
  wire \spo[28]_INST_0_i_10_n_0 ;
  wire \spo[28]_INST_0_i_11_n_0 ;
  wire \spo[28]_INST_0_i_12_n_0 ;
  wire \spo[28]_INST_0_i_13_n_0 ;
  wire \spo[28]_INST_0_i_14_n_0 ;
  wire \spo[28]_INST_0_i_15_n_0 ;
  wire \spo[28]_INST_0_i_16_n_0 ;
  wire \spo[28]_INST_0_i_17_n_0 ;
  wire \spo[28]_INST_0_i_18_n_0 ;
  wire \spo[28]_INST_0_i_19_n_0 ;
  wire \spo[28]_INST_0_i_1_n_0 ;
  wire \spo[28]_INST_0_i_20_n_0 ;
  wire \spo[28]_INST_0_i_21_n_0 ;
  wire \spo[28]_INST_0_i_22_n_0 ;
  wire \spo[28]_INST_0_i_23_n_0 ;
  wire \spo[28]_INST_0_i_24_n_0 ;
  wire \spo[28]_INST_0_i_25_n_0 ;
  wire \spo[28]_INST_0_i_26_n_0 ;
  wire \spo[28]_INST_0_i_27_n_0 ;
  wire \spo[28]_INST_0_i_28_n_0 ;
  wire \spo[28]_INST_0_i_29_n_0 ;
  wire \spo[28]_INST_0_i_2_n_0 ;
  wire \spo[28]_INST_0_i_30_n_0 ;
  wire \spo[28]_INST_0_i_31_n_0 ;
  wire \spo[28]_INST_0_i_32_n_0 ;
  wire \spo[28]_INST_0_i_33_n_0 ;
  wire \spo[28]_INST_0_i_34_n_0 ;
  wire \spo[28]_INST_0_i_35_n_0 ;
  wire \spo[28]_INST_0_i_36_n_0 ;
  wire \spo[28]_INST_0_i_37_n_0 ;
  wire \spo[28]_INST_0_i_38_n_0 ;
  wire \spo[28]_INST_0_i_39_n_0 ;
  wire \spo[28]_INST_0_i_3_n_0 ;
  wire \spo[28]_INST_0_i_40_n_0 ;
  wire \spo[28]_INST_0_i_41_n_0 ;
  wire \spo[28]_INST_0_i_42_n_0 ;
  wire \spo[28]_INST_0_i_43_n_0 ;
  wire \spo[28]_INST_0_i_44_n_0 ;
  wire \spo[28]_INST_0_i_45_n_0 ;
  wire \spo[28]_INST_0_i_46_n_0 ;
  wire \spo[28]_INST_0_i_47_n_0 ;
  wire \spo[28]_INST_0_i_48_n_0 ;
  wire \spo[28]_INST_0_i_4_n_0 ;
  wire \spo[28]_INST_0_i_5_n_0 ;
  wire \spo[28]_INST_0_i_6_n_0 ;
  wire \spo[28]_INST_0_i_7_n_0 ;
  wire \spo[28]_INST_0_i_8_n_0 ;
  wire \spo[28]_INST_0_i_9_n_0 ;
  wire \spo[29]_INST_0_i_10_n_0 ;
  wire \spo[29]_INST_0_i_11_n_0 ;
  wire \spo[29]_INST_0_i_12_n_0 ;
  wire \spo[29]_INST_0_i_13_n_0 ;
  wire \spo[29]_INST_0_i_14_n_0 ;
  wire \spo[29]_INST_0_i_15_n_0 ;
  wire \spo[29]_INST_0_i_16_n_0 ;
  wire \spo[29]_INST_0_i_17_n_0 ;
  wire \spo[29]_INST_0_i_18_n_0 ;
  wire \spo[29]_INST_0_i_19_n_0 ;
  wire \spo[29]_INST_0_i_1_n_0 ;
  wire \spo[29]_INST_0_i_20_n_0 ;
  wire \spo[29]_INST_0_i_21_n_0 ;
  wire \spo[29]_INST_0_i_22_n_0 ;
  wire \spo[29]_INST_0_i_23_n_0 ;
  wire \spo[29]_INST_0_i_24_n_0 ;
  wire \spo[29]_INST_0_i_25_n_0 ;
  wire \spo[29]_INST_0_i_26_n_0 ;
  wire \spo[29]_INST_0_i_27_n_0 ;
  wire \spo[29]_INST_0_i_28_n_0 ;
  wire \spo[29]_INST_0_i_29_n_0 ;
  wire \spo[29]_INST_0_i_2_n_0 ;
  wire \spo[29]_INST_0_i_30_n_0 ;
  wire \spo[29]_INST_0_i_31_n_0 ;
  wire \spo[29]_INST_0_i_32_n_0 ;
  wire \spo[29]_INST_0_i_33_n_0 ;
  wire \spo[29]_INST_0_i_34_n_0 ;
  wire \spo[29]_INST_0_i_35_n_0 ;
  wire \spo[29]_INST_0_i_36_n_0 ;
  wire \spo[29]_INST_0_i_37_n_0 ;
  wire \spo[29]_INST_0_i_38_n_0 ;
  wire \spo[29]_INST_0_i_39_n_0 ;
  wire \spo[29]_INST_0_i_3_n_0 ;
  wire \spo[29]_INST_0_i_40_n_0 ;
  wire \spo[29]_INST_0_i_41_n_0 ;
  wire \spo[29]_INST_0_i_42_n_0 ;
  wire \spo[29]_INST_0_i_43_n_0 ;
  wire \spo[29]_INST_0_i_44_n_0 ;
  wire \spo[29]_INST_0_i_45_n_0 ;
  wire \spo[29]_INST_0_i_46_n_0 ;
  wire \spo[29]_INST_0_i_47_n_0 ;
  wire \spo[29]_INST_0_i_48_n_0 ;
  wire \spo[29]_INST_0_i_49_n_0 ;
  wire \spo[29]_INST_0_i_4_n_0 ;
  wire \spo[29]_INST_0_i_50_n_0 ;
  wire \spo[29]_INST_0_i_51_n_0 ;
  wire \spo[29]_INST_0_i_5_n_0 ;
  wire \spo[29]_INST_0_i_6_n_0 ;
  wire \spo[29]_INST_0_i_7_n_0 ;
  wire \spo[29]_INST_0_i_8_n_0 ;
  wire \spo[29]_INST_0_i_9_n_0 ;
  wire \spo[2]_INST_0_i_10_n_0 ;
  wire \spo[2]_INST_0_i_11_n_0 ;
  wire \spo[2]_INST_0_i_12_n_0 ;
  wire \spo[2]_INST_0_i_13_n_0 ;
  wire \spo[2]_INST_0_i_14_n_0 ;
  wire \spo[2]_INST_0_i_15_n_0 ;
  wire \spo[2]_INST_0_i_16_n_0 ;
  wire \spo[2]_INST_0_i_17_n_0 ;
  wire \spo[2]_INST_0_i_18_n_0 ;
  wire \spo[2]_INST_0_i_19_n_0 ;
  wire \spo[2]_INST_0_i_1_n_0 ;
  wire \spo[2]_INST_0_i_20_n_0 ;
  wire \spo[2]_INST_0_i_21_n_0 ;
  wire \spo[2]_INST_0_i_22_n_0 ;
  wire \spo[2]_INST_0_i_23_n_0 ;
  wire \spo[2]_INST_0_i_24_n_0 ;
  wire \spo[2]_INST_0_i_25_n_0 ;
  wire \spo[2]_INST_0_i_26_n_0 ;
  wire \spo[2]_INST_0_i_27_n_0 ;
  wire \spo[2]_INST_0_i_28_n_0 ;
  wire \spo[2]_INST_0_i_29_n_0 ;
  wire \spo[2]_INST_0_i_2_n_0 ;
  wire \spo[2]_INST_0_i_30_n_0 ;
  wire \spo[2]_INST_0_i_31_n_0 ;
  wire \spo[2]_INST_0_i_32_n_0 ;
  wire \spo[2]_INST_0_i_33_n_0 ;
  wire \spo[2]_INST_0_i_34_n_0 ;
  wire \spo[2]_INST_0_i_35_n_0 ;
  wire \spo[2]_INST_0_i_36_n_0 ;
  wire \spo[2]_INST_0_i_37_n_0 ;
  wire \spo[2]_INST_0_i_38_n_0 ;
  wire \spo[2]_INST_0_i_39_n_0 ;
  wire \spo[2]_INST_0_i_3_n_0 ;
  wire \spo[2]_INST_0_i_40_n_0 ;
  wire \spo[2]_INST_0_i_4_n_0 ;
  wire \spo[2]_INST_0_i_5_n_0 ;
  wire \spo[2]_INST_0_i_6_n_0 ;
  wire \spo[2]_INST_0_i_7_n_0 ;
  wire \spo[2]_INST_0_i_8_n_0 ;
  wire \spo[2]_INST_0_i_9_n_0 ;
  wire \spo[30]_INST_0_i_10_n_0 ;
  wire \spo[30]_INST_0_i_11_n_0 ;
  wire \spo[30]_INST_0_i_12_n_0 ;
  wire \spo[30]_INST_0_i_13_n_0 ;
  wire \spo[30]_INST_0_i_14_n_0 ;
  wire \spo[30]_INST_0_i_15_n_0 ;
  wire \spo[30]_INST_0_i_16_n_0 ;
  wire \spo[30]_INST_0_i_17_n_0 ;
  wire \spo[30]_INST_0_i_18_n_0 ;
  wire \spo[30]_INST_0_i_1_n_0 ;
  wire \spo[30]_INST_0_i_2_n_0 ;
  wire \spo[30]_INST_0_i_3_n_0 ;
  wire \spo[30]_INST_0_i_4_n_0 ;
  wire \spo[30]_INST_0_i_5_n_0 ;
  wire \spo[30]_INST_0_i_6_n_0 ;
  wire \spo[30]_INST_0_i_7_n_0 ;
  wire \spo[30]_INST_0_i_8_n_0 ;
  wire \spo[30]_INST_0_i_9_n_0 ;
  wire \spo[31]_INST_0_i_10_n_0 ;
  wire \spo[31]_INST_0_i_11_n_0 ;
  wire \spo[31]_INST_0_i_12_n_0 ;
  wire \spo[31]_INST_0_i_13_n_0 ;
  wire \spo[31]_INST_0_i_14_n_0 ;
  wire \spo[31]_INST_0_i_15_n_0 ;
  wire \spo[31]_INST_0_i_16_n_0 ;
  wire \spo[31]_INST_0_i_17_n_0 ;
  wire \spo[31]_INST_0_i_18_n_0 ;
  wire \spo[31]_INST_0_i_19_n_0 ;
  wire \spo[31]_INST_0_i_1_n_0 ;
  wire \spo[31]_INST_0_i_20_n_0 ;
  wire \spo[31]_INST_0_i_21_n_0 ;
  wire \spo[31]_INST_0_i_22_n_0 ;
  wire \spo[31]_INST_0_i_23_n_0 ;
  wire \spo[31]_INST_0_i_24_n_0 ;
  wire \spo[31]_INST_0_i_25_n_0 ;
  wire \spo[31]_INST_0_i_26_n_0 ;
  wire \spo[31]_INST_0_i_27_n_0 ;
  wire \spo[31]_INST_0_i_28_n_0 ;
  wire \spo[31]_INST_0_i_29_n_0 ;
  wire \spo[31]_INST_0_i_2_n_0 ;
  wire \spo[31]_INST_0_i_30_n_0 ;
  wire \spo[31]_INST_0_i_31_n_0 ;
  wire \spo[31]_INST_0_i_32_n_0 ;
  wire \spo[31]_INST_0_i_33_n_0 ;
  wire \spo[31]_INST_0_i_34_n_0 ;
  wire \spo[31]_INST_0_i_3_n_0 ;
  wire \spo[31]_INST_0_i_4_n_0 ;
  wire \spo[31]_INST_0_i_5_n_0 ;
  wire \spo[31]_INST_0_i_6_n_0 ;
  wire \spo[31]_INST_0_i_7_n_0 ;
  wire \spo[31]_INST_0_i_8_n_0 ;
  wire \spo[31]_INST_0_i_9_n_0 ;
  wire \spo[3]_INST_0_i_10_n_0 ;
  wire \spo[3]_INST_0_i_11_n_0 ;
  wire \spo[3]_INST_0_i_12_n_0 ;
  wire \spo[3]_INST_0_i_13_n_0 ;
  wire \spo[3]_INST_0_i_14_n_0 ;
  wire \spo[3]_INST_0_i_15_n_0 ;
  wire \spo[3]_INST_0_i_16_n_0 ;
  wire \spo[3]_INST_0_i_17_n_0 ;
  wire \spo[3]_INST_0_i_18_n_0 ;
  wire \spo[3]_INST_0_i_19_n_0 ;
  wire \spo[3]_INST_0_i_1_n_0 ;
  wire \spo[3]_INST_0_i_20_n_0 ;
  wire \spo[3]_INST_0_i_21_n_0 ;
  wire \spo[3]_INST_0_i_22_n_0 ;
  wire \spo[3]_INST_0_i_23_n_0 ;
  wire \spo[3]_INST_0_i_24_n_0 ;
  wire \spo[3]_INST_0_i_25_n_0 ;
  wire \spo[3]_INST_0_i_26_n_0 ;
  wire \spo[3]_INST_0_i_27_n_0 ;
  wire \spo[3]_INST_0_i_28_n_0 ;
  wire \spo[3]_INST_0_i_29_n_0 ;
  wire \spo[3]_INST_0_i_2_n_0 ;
  wire \spo[3]_INST_0_i_30_n_0 ;
  wire \spo[3]_INST_0_i_31_n_0 ;
  wire \spo[3]_INST_0_i_32_n_0 ;
  wire \spo[3]_INST_0_i_33_n_0 ;
  wire \spo[3]_INST_0_i_34_n_0 ;
  wire \spo[3]_INST_0_i_35_n_0 ;
  wire \spo[3]_INST_0_i_3_n_0 ;
  wire \spo[3]_INST_0_i_4_n_0 ;
  wire \spo[3]_INST_0_i_5_n_0 ;
  wire \spo[3]_INST_0_i_6_n_0 ;
  wire \spo[3]_INST_0_i_7_n_0 ;
  wire \spo[3]_INST_0_i_8_n_0 ;
  wire \spo[3]_INST_0_i_9_n_0 ;
  wire \spo[4]_INST_0_i_10_n_0 ;
  wire \spo[4]_INST_0_i_11_n_0 ;
  wire \spo[4]_INST_0_i_12_n_0 ;
  wire \spo[4]_INST_0_i_13_n_0 ;
  wire \spo[4]_INST_0_i_14_n_0 ;
  wire \spo[4]_INST_0_i_15_n_0 ;
  wire \spo[4]_INST_0_i_16_n_0 ;
  wire \spo[4]_INST_0_i_17_n_0 ;
  wire \spo[4]_INST_0_i_18_n_0 ;
  wire \spo[4]_INST_0_i_19_n_0 ;
  wire \spo[4]_INST_0_i_1_n_0 ;
  wire \spo[4]_INST_0_i_20_n_0 ;
  wire \spo[4]_INST_0_i_21_n_0 ;
  wire \spo[4]_INST_0_i_22_n_0 ;
  wire \spo[4]_INST_0_i_23_n_0 ;
  wire \spo[4]_INST_0_i_24_n_0 ;
  wire \spo[4]_INST_0_i_25_n_0 ;
  wire \spo[4]_INST_0_i_26_n_0 ;
  wire \spo[4]_INST_0_i_27_n_0 ;
  wire \spo[4]_INST_0_i_28_n_0 ;
  wire \spo[4]_INST_0_i_29_n_0 ;
  wire \spo[4]_INST_0_i_2_n_0 ;
  wire \spo[4]_INST_0_i_30_n_0 ;
  wire \spo[4]_INST_0_i_31_n_0 ;
  wire \spo[4]_INST_0_i_32_n_0 ;
  wire \spo[4]_INST_0_i_3_n_0 ;
  wire \spo[4]_INST_0_i_4_n_0 ;
  wire \spo[4]_INST_0_i_5_n_0 ;
  wire \spo[4]_INST_0_i_6_n_0 ;
  wire \spo[4]_INST_0_i_7_n_0 ;
  wire \spo[4]_INST_0_i_8_n_0 ;
  wire \spo[4]_INST_0_i_9_n_0 ;
  wire \spo[5]_INST_0_i_10_n_0 ;
  wire \spo[5]_INST_0_i_11_n_0 ;
  wire \spo[5]_INST_0_i_12_n_0 ;
  wire \spo[5]_INST_0_i_13_n_0 ;
  wire \spo[5]_INST_0_i_14_n_0 ;
  wire \spo[5]_INST_0_i_15_n_0 ;
  wire \spo[5]_INST_0_i_16_n_0 ;
  wire \spo[5]_INST_0_i_17_n_0 ;
  wire \spo[5]_INST_0_i_18_n_0 ;
  wire \spo[5]_INST_0_i_19_n_0 ;
  wire \spo[5]_INST_0_i_1_n_0 ;
  wire \spo[5]_INST_0_i_20_n_0 ;
  wire \spo[5]_INST_0_i_21_n_0 ;
  wire \spo[5]_INST_0_i_22_n_0 ;
  wire \spo[5]_INST_0_i_23_n_0 ;
  wire \spo[5]_INST_0_i_24_n_0 ;
  wire \spo[5]_INST_0_i_25_n_0 ;
  wire \spo[5]_INST_0_i_26_n_0 ;
  wire \spo[5]_INST_0_i_27_n_0 ;
  wire \spo[5]_INST_0_i_28_n_0 ;
  wire \spo[5]_INST_0_i_29_n_0 ;
  wire \spo[5]_INST_0_i_2_n_0 ;
  wire \spo[5]_INST_0_i_30_n_0 ;
  wire \spo[5]_INST_0_i_31_n_0 ;
  wire \spo[5]_INST_0_i_32_n_0 ;
  wire \spo[5]_INST_0_i_33_n_0 ;
  wire \spo[5]_INST_0_i_34_n_0 ;
  wire \spo[5]_INST_0_i_35_n_0 ;
  wire \spo[5]_INST_0_i_36_n_0 ;
  wire \spo[5]_INST_0_i_37_n_0 ;
  wire \spo[5]_INST_0_i_38_n_0 ;
  wire \spo[5]_INST_0_i_3_n_0 ;
  wire \spo[5]_INST_0_i_4_n_0 ;
  wire \spo[5]_INST_0_i_5_n_0 ;
  wire \spo[5]_INST_0_i_6_n_0 ;
  wire \spo[5]_INST_0_i_7_n_0 ;
  wire \spo[5]_INST_0_i_8_n_0 ;
  wire \spo[5]_INST_0_i_9_n_0 ;
  wire \spo[6]_INST_0_i_10_n_0 ;
  wire \spo[6]_INST_0_i_11_n_0 ;
  wire \spo[6]_INST_0_i_12_n_0 ;
  wire \spo[6]_INST_0_i_13_n_0 ;
  wire \spo[6]_INST_0_i_14_n_0 ;
  wire \spo[6]_INST_0_i_15_n_0 ;
  wire \spo[6]_INST_0_i_16_n_0 ;
  wire \spo[6]_INST_0_i_17_n_0 ;
  wire \spo[6]_INST_0_i_18_n_0 ;
  wire \spo[6]_INST_0_i_19_n_0 ;
  wire \spo[6]_INST_0_i_1_n_0 ;
  wire \spo[6]_INST_0_i_20_n_0 ;
  wire \spo[6]_INST_0_i_21_n_0 ;
  wire \spo[6]_INST_0_i_22_n_0 ;
  wire \spo[6]_INST_0_i_23_n_0 ;
  wire \spo[6]_INST_0_i_2_n_0 ;
  wire \spo[6]_INST_0_i_3_n_0 ;
  wire \spo[6]_INST_0_i_4_n_0 ;
  wire \spo[6]_INST_0_i_5_n_0 ;
  wire \spo[6]_INST_0_i_6_n_0 ;
  wire \spo[6]_INST_0_i_7_n_0 ;
  wire \spo[6]_INST_0_i_8_n_0 ;
  wire \spo[6]_INST_0_i_9_n_0 ;
  wire \spo[7]_INST_0_i_10_n_0 ;
  wire \spo[7]_INST_0_i_11_n_0 ;
  wire \spo[7]_INST_0_i_12_n_0 ;
  wire \spo[7]_INST_0_i_13_n_0 ;
  wire \spo[7]_INST_0_i_14_n_0 ;
  wire \spo[7]_INST_0_i_15_n_0 ;
  wire \spo[7]_INST_0_i_16_n_0 ;
  wire \spo[7]_INST_0_i_17_n_0 ;
  wire \spo[7]_INST_0_i_18_n_0 ;
  wire \spo[7]_INST_0_i_19_n_0 ;
  wire \spo[7]_INST_0_i_1_n_0 ;
  wire \spo[7]_INST_0_i_20_n_0 ;
  wire \spo[7]_INST_0_i_21_n_0 ;
  wire \spo[7]_INST_0_i_22_n_0 ;
  wire \spo[7]_INST_0_i_23_n_0 ;
  wire \spo[7]_INST_0_i_2_n_0 ;
  wire \spo[7]_INST_0_i_3_n_0 ;
  wire \spo[7]_INST_0_i_4_n_0 ;
  wire \spo[7]_INST_0_i_5_n_0 ;
  wire \spo[7]_INST_0_i_6_n_0 ;
  wire \spo[7]_INST_0_i_7_n_0 ;
  wire \spo[7]_INST_0_i_8_n_0 ;
  wire \spo[7]_INST_0_i_9_n_0 ;
  wire \spo[8]_INST_0_i_10_n_0 ;
  wire \spo[8]_INST_0_i_11_n_0 ;
  wire \spo[8]_INST_0_i_12_n_0 ;
  wire \spo[8]_INST_0_i_13_n_0 ;
  wire \spo[8]_INST_0_i_14_n_0 ;
  wire \spo[8]_INST_0_i_15_n_0 ;
  wire \spo[8]_INST_0_i_16_n_0 ;
  wire \spo[8]_INST_0_i_17_n_0 ;
  wire \spo[8]_INST_0_i_18_n_0 ;
  wire \spo[8]_INST_0_i_19_n_0 ;
  wire \spo[8]_INST_0_i_1_n_0 ;
  wire \spo[8]_INST_0_i_20_n_0 ;
  wire \spo[8]_INST_0_i_21_n_0 ;
  wire \spo[8]_INST_0_i_22_n_0 ;
  wire \spo[8]_INST_0_i_23_n_0 ;
  wire \spo[8]_INST_0_i_2_n_0 ;
  wire \spo[8]_INST_0_i_3_n_0 ;
  wire \spo[8]_INST_0_i_4_n_0 ;
  wire \spo[8]_INST_0_i_5_n_0 ;
  wire \spo[8]_INST_0_i_6_n_0 ;
  wire \spo[8]_INST_0_i_7_n_0 ;
  wire \spo[8]_INST_0_i_8_n_0 ;
  wire \spo[8]_INST_0_i_9_n_0 ;
  wire \spo[9]_INST_0_i_10_n_0 ;
  wire \spo[9]_INST_0_i_11_n_0 ;
  wire \spo[9]_INST_0_i_12_n_0 ;
  wire \spo[9]_INST_0_i_13_n_0 ;
  wire \spo[9]_INST_0_i_14_n_0 ;
  wire \spo[9]_INST_0_i_15_n_0 ;
  wire \spo[9]_INST_0_i_16_n_0 ;
  wire \spo[9]_INST_0_i_17_n_0 ;
  wire \spo[9]_INST_0_i_18_n_0 ;
  wire \spo[9]_INST_0_i_19_n_0 ;
  wire \spo[9]_INST_0_i_1_n_0 ;
  wire \spo[9]_INST_0_i_20_n_0 ;
  wire \spo[9]_INST_0_i_21_n_0 ;
  wire \spo[9]_INST_0_i_22_n_0 ;
  wire \spo[9]_INST_0_i_23_n_0 ;
  wire \spo[9]_INST_0_i_24_n_0 ;
  wire \spo[9]_INST_0_i_25_n_0 ;
  wire \spo[9]_INST_0_i_26_n_0 ;
  wire \spo[9]_INST_0_i_27_n_0 ;
  wire \spo[9]_INST_0_i_28_n_0 ;
  wire \spo[9]_INST_0_i_2_n_0 ;
  wire \spo[9]_INST_0_i_3_n_0 ;
  wire \spo[9]_INST_0_i_4_n_0 ;
  wire \spo[9]_INST_0_i_5_n_0 ;
  wire \spo[9]_INST_0_i_6_n_0 ;
  wire \spo[9]_INST_0_i_7_n_0 ;
  wire \spo[9]_INST_0_i_8_n_0 ;
  wire \spo[9]_INST_0_i_9_n_0 ;

  MUXF7 \spo[0]_INST_0 
       (.I0(\spo[0]_INST_0_i_1_n_0 ),
        .I1(\spo[0]_INST_0_i_2_n_0 ),
        .O(spo[0]),
        .S(a[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[0]_INST_0_i_1 
       (.I0(\spo[0]_INST_0_i_3_n_0 ),
        .I1(\spo[0]_INST_0_i_4_n_0 ),
        .I2(a[3]),
        .I3(\spo[0]_INST_0_i_5_n_0 ),
        .I4(a[5]),
        .I5(\spo[0]_INST_0_i_6_n_0 ),
        .O(\spo[0]_INST_0_i_1_n_0 ));
  MUXF8 \spo[0]_INST_0_i_10 
       (.I0(\spo[0]_INST_0_i_27_n_0 ),
        .I1(\spo[0]_INST_0_i_28_n_0 ),
        .O(\spo[0]_INST_0_i_10_n_0 ),
        .S(a[6]));
  MUXF7 \spo[0]_INST_0_i_11 
       (.I0(\spo[0]_INST_0_i_29_n_0 ),
        .I1(\spo[0]_INST_0_i_30_n_0 ),
        .O(\spo[0]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_12 
       (.I0(\spo[0]_INST_0_i_31_n_0 ),
        .I1(\spo[0]_INST_0_i_32_n_0 ),
        .O(\spo[0]_INST_0_i_12_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_13 
       (.I0(\spo[0]_INST_0_i_33_n_0 ),
        .I1(\spo[0]_INST_0_i_34_n_0 ),
        .O(\spo[0]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_14 
       (.I0(\spo[0]_INST_0_i_35_n_0 ),
        .I1(\spo[0]_INST_0_i_36_n_0 ),
        .O(\spo[0]_INST_0_i_14_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_15 
       (.I0(\spo[0]_INST_0_i_37_n_0 ),
        .I1(\spo[0]_INST_0_i_38_n_0 ),
        .O(\spo[0]_INST_0_i_15_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_16 
       (.I0(\spo[0]_INST_0_i_39_n_0 ),
        .I1(\spo[0]_INST_0_i_40_n_0 ),
        .O(\spo[0]_INST_0_i_16_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h000000F500220038)) 
    \spo[0]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000000F100F00040)) 
    \spo[0]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h00020A0000010000)) 
    \spo[0]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[0]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[0]_INST_0_i_2 
       (.I0(\spo[0]_INST_0_i_7_n_0 ),
        .I1(\spo[0]_INST_0_i_8_n_0 ),
        .I2(a[3]),
        .I3(\spo[0]_INST_0_i_9_n_0 ),
        .I4(a[5]),
        .I5(\spo[0]_INST_0_i_10_n_0 ),
        .O(\spo[0]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000400080100080B)) 
    \spo[0]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_20_n_0 ));
  MUXF7 \spo[0]_INST_0_i_21 
       (.I0(\spo[0]_INST_0_i_41_n_0 ),
        .I1(\spo[0]_INST_0_i_42_n_0 ),
        .O(\spo[0]_INST_0_i_21_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_22 
       (.I0(\spo[0]_INST_0_i_43_n_0 ),
        .I1(\spo[0]_INST_0_i_44_n_0 ),
        .O(\spo[0]_INST_0_i_22_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_23 
       (.I0(\spo[0]_INST_0_i_45_n_0 ),
        .I1(\spo[0]_INST_0_i_46_n_0 ),
        .O(\spo[0]_INST_0_i_23_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_24 
       (.I0(\spo[0]_INST_0_i_47_n_0 ),
        .I1(\spo[0]_INST_0_i_48_n_0 ),
        .O(\spo[0]_INST_0_i_24_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000000000370711)) 
    \spo[0]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[0]_INST_0_i_25_n_0 ));
  MUXF7 \spo[0]_INST_0_i_26 
       (.I0(\spo[0]_INST_0_i_49_n_0 ),
        .I1(\spo[0]_INST_0_i_50_n_0 ),
        .O(\spo[0]_INST_0_i_26_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_27 
       (.I0(\spo[0]_INST_0_i_51_n_0 ),
        .I1(\spo[0]_INST_0_i_52_n_0 ),
        .O(\spo[0]_INST_0_i_27_n_0 ),
        .S(a[7]));
  MUXF7 \spo[0]_INST_0_i_28 
       (.I0(\spo[0]_INST_0_i_53_n_0 ),
        .I1(\spo[0]_INST_0_i_54_n_0 ),
        .O(\spo[0]_INST_0_i_28_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h000000F300F000C2)) 
    \spo[0]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_29_n_0 ));
  MUXF8 \spo[0]_INST_0_i_3 
       (.I0(\spo[0]_INST_0_i_11_n_0 ),
        .I1(\spo[0]_INST_0_i_12_n_0 ),
        .O(\spo[0]_INST_0_i_3_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h000006000000B693)) 
    \spo[0]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h000000A400000012)) 
    \spo[0]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800002519)) 
    \spo[0]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000C000800010104)) 
    \spo[0]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h00000001005A0000)) 
    \spo[0]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h00010F0400080000)) 
    \spo[0]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000002800000443)) 
    \spo[0]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h0000001F0090003C)) 
    \spo[0]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000FD00000030)) 
    \spo[0]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h0000050400000080)) 
    \spo[0]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_39_n_0 ));
  MUXF8 \spo[0]_INST_0_i_4 
       (.I0(\spo[0]_INST_0_i_13_n_0 ),
        .I1(\spo[0]_INST_0_i_14_n_0 ),
        .O(\spo[0]_INST_0_i_4_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h0000044D00000084)) 
    \spo[0]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h000F0F0000060000)) 
    \spo[0]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h000000000019695C)) 
    \spo[0]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[0]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000850000)) 
    \spo[0]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[0]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0001001800020008)) 
    \spo[0]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[0]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h00000A820000009C)) 
    \spo[0]_INST_0_i_45 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h000105020000000E)) 
    \spo[0]_INST_0_i_46 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h000B0F0C000C0000)) 
    \spo[0]_INST_0_i_47 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h0000048700000C04)) 
    \spo[0]_INST_0_i_48 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_48_n_0 ));
  LUT6 #(
    .INIT(64'h000000000F00F417)) 
    \spo[0]_INST_0_i_49 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[0]_INST_0_i_49_n_0 ));
  MUXF8 \spo[0]_INST_0_i_5 
       (.I0(\spo[0]_INST_0_i_15_n_0 ),
        .I1(\spo[0]_INST_0_i_16_n_0 ),
        .O(\spo[0]_INST_0_i_5_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h00000D2400000226)) 
    \spo[0]_INST_0_i_50 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_50_n_0 ));
  LUT6 #(
    .INIT(64'h00000C0200000050)) 
    \spo[0]_INST_0_i_51 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_51_n_0 ));
  LUT6 #(
    .INIT(64'h00000000001F09BA)) 
    \spo[0]_INST_0_i_52 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[0]_INST_0_i_52_n_0 ));
  LUT6 #(
    .INIT(64'h00030F04000C0000)) 
    \spo[0]_INST_0_i_53 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_53_n_0 ));
  LUT6 #(
    .INIT(64'h0000000600000D22)) 
    \spo[0]_INST_0_i_54 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[0]_INST_0_i_54_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[0]_INST_0_i_6 
       (.I0(\spo[0]_INST_0_i_17_n_0 ),
        .I1(\spo[0]_INST_0_i_18_n_0 ),
        .I2(a[6]),
        .I3(\spo[0]_INST_0_i_19_n_0 ),
        .I4(a[7]),
        .I5(\spo[0]_INST_0_i_20_n_0 ),
        .O(\spo[0]_INST_0_i_6_n_0 ));
  MUXF8 \spo[0]_INST_0_i_7 
       (.I0(\spo[0]_INST_0_i_21_n_0 ),
        .I1(\spo[0]_INST_0_i_22_n_0 ),
        .O(\spo[0]_INST_0_i_7_n_0 ),
        .S(a[6]));
  MUXF8 \spo[0]_INST_0_i_8 
       (.I0(\spo[0]_INST_0_i_23_n_0 ),
        .I1(\spo[0]_INST_0_i_24_n_0 ),
        .O(\spo[0]_INST_0_i_8_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hB888FFFFB8880000)) 
    \spo[0]_INST_0_i_9 
       (.I0(\spo[0]_INST_0_i_25_n_0 ),
        .I1(a[7]),
        .I2(\spo[12]_INST_0_i_25_n_0 ),
        .I3(a[2]),
        .I4(a[6]),
        .I5(\spo[0]_INST_0_i_26_n_0 ),
        .O(\spo[0]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[10]_INST_0 
       (.I0(\spo[10]_INST_0_i_1_n_0 ),
        .I1(\spo[10]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[10]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[10]_INST_0_i_4_n_0 ),
        .O(spo[10]));
  LUT6 #(
    .INIT(64'h0000000083808080)) 
    \spo[10]_INST_0_i_1 
       (.I0(\spo[10]_INST_0_i_5_n_0 ),
        .I1(a[5]),
        .I2(a[7]),
        .I3(\spo[10]_INST_0_i_6_n_0 ),
        .I4(a[2]),
        .I5(a[6]),
        .O(\spo[10]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB800B80030FF3000)) 
    \spo[10]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_33_n_0 ),
        .I1(a[6]),
        .I2(\spo[10]_INST_0_i_14_n_0 ),
        .I3(a[7]),
        .I4(\spo[30]_INST_0_i_17_n_0 ),
        .I5(a[2]),
        .O(\spo[10]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hB800B80000330000)) 
    \spo[10]_INST_0_i_11 
       (.I0(\spo[30]_INST_0_i_17_n_0 ),
        .I1(a[6]),
        .I2(\spo[28]_INST_0_i_38_n_0 ),
        .I3(a[7]),
        .I4(\spo[10]_INST_0_i_15_n_0 ),
        .I5(a[2]),
        .O(\spo[10]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[10]_INST_0_i_12 
       (.I0(\spo[8]_INST_0_i_5_n_0 ),
        .I1(\spo[10]_INST_0_i_16_n_0 ),
        .I2(a[6]),
        .I3(\spo[28]_INST_0_i_21_n_0 ),
        .I4(a[7]),
        .I5(\spo[10]_INST_0_i_17_n_0 ),
        .O(\spo[10]_INST_0_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h00030800)) 
    \spo[10]_INST_0_i_13 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[10]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h0000020000000900)) 
    \spo[10]_INST_0_i_14 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[10]_INST_0_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00080040)) 
    \spo[10]_INST_0_i_15 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[10]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800000000)) 
    \spo[10]_INST_0_i_16 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[10]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h000000BD0000003C)) 
    \spo[10]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[10]_INST_0_i_17_n_0 ));
  MUXF7 \spo[10]_INST_0_i_2 
       (.I0(\spo[10]_INST_0_i_7_n_0 ),
        .I1(\spo[10]_INST_0_i_8_n_0 ),
        .O(\spo[10]_INST_0_i_2_n_0 ),
        .S(a[5]));
  MUXF7 \spo[10]_INST_0_i_3 
       (.I0(\spo[10]_INST_0_i_9_n_0 ),
        .I1(\spo[10]_INST_0_i_10_n_0 ),
        .O(\spo[10]_INST_0_i_3_n_0 ),
        .S(a[5]));
  MUXF7 \spo[10]_INST_0_i_4 
       (.I0(\spo[10]_INST_0_i_11_n_0 ),
        .I1(\spo[10]_INST_0_i_12_n_0 ),
        .O(\spo[10]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000002000000110)) 
    \spo[10]_INST_0_i_5 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[10]_INST_0_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h00010002)) 
    \spo[10]_INST_0_i_6 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[10]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000000050400040)) 
    \spo[10]_INST_0_i_7 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[6]),
        .O(\spo[10]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hBB30883000000000)) 
    \spo[10]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[6]),
        .I2(\spo[23]_INST_0_i_18_n_0 ),
        .I3(a[2]),
        .I4(\spo[10]_INST_0_i_13_n_0 ),
        .I5(a[7]),
        .O(\spo[10]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020150000)) 
    \spo[10]_INST_0_i_9 
       (.I0(a[6]),
        .I1(a[0]),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[2]),
        .O(\spo[10]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0 
       (.I0(\spo[11]_INST_0_i_1_n_0 ),
        .I1(\spo[11]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[11]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[11]_INST_0_i_4_n_0 ),
        .O(spo[11]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_1 
       (.I0(\spo[11]_INST_0_i_5_n_0 ),
        .I1(\spo[11]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[11]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[11]_INST_0_i_8_n_0 ),
        .O(\spo[11]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAF00A000CFFFC000)) 
    \spo[11]_INST_0_i_10 
       (.I0(\spo[13]_INST_0_i_18_n_0 ),
        .I1(\spo[27]_INST_0_i_36_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[1]),
        .O(\spo[11]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h4F70000000000000)) 
    \spo[11]_INST_0_i_11 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[7]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[11]_INST_0_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'hC0202000)) 
    \spo[11]_INST_0_i_12 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[0]),
        .I4(a[2]),
        .O(\spo[11]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    \spo[11]_INST_0_i_13 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[2]),
        .I2(\spo[18]_INST_0_i_23_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[11]_INST_0_i_23_n_0 ),
        .O(\spo[11]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h88888888B8BBB888)) 
    \spo[11]_INST_0_i_14 
       (.I0(\spo[11]_INST_0_i_24_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_18_n_0 ),
        .I5(a[1]),
        .O(\spo[11]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h3030003000C00088)) 
    \spo[11]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[11]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h2000800051003000)) 
    \spo[11]_INST_0_i_16 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(\spo[31]_INST_0_i_29_n_0 ),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[11]_INST_0_i_16_n_0 ));
  MUXF7 \spo[11]_INST_0_i_17 
       (.I0(\spo[11]_INST_0_i_25_n_0 ),
        .I1(\spo[11]_INST_0_i_26_n_0 ),
        .O(\spo[11]_INST_0_i_17_n_0 ),
        .S(a[7]));
  MUXF7 \spo[11]_INST_0_i_18 
       (.I0(\spo[11]_INST_0_i_27_n_0 ),
        .I1(\spo[11]_INST_0_i_28_n_0 ),
        .O(\spo[11]_INST_0_i_18_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0400880800000000)) 
    \spo[11]_INST_0_i_19 
       (.I0(a[0]),
        .I1(\spo[31]_INST_0_i_29_n_0 ),
        .I2(a[8]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[11]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_2 
       (.I0(\spo[11]_INST_0_i_9_n_0 ),
        .I1(\spo[11]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[11]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[11]_INST_0_i_12_n_0 ),
        .O(\spo[11]_INST_0_i_2_n_0 ));
  MUXF7 \spo[11]_INST_0_i_20 
       (.I0(\spo[11]_INST_0_i_29_n_0 ),
        .I1(\spo[11]_INST_0_i_30_n_0 ),
        .O(\spo[11]_INST_0_i_20_n_0 ),
        .S(a[7]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h00000014)) 
    \spo[11]_INST_0_i_21 
       (.I0(a[0]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[1]),
        .O(\spo[11]_INST_0_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h00140000)) 
    \spo[11]_INST_0_i_22 
       (.I0(a[0]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[1]),
        .O(\spo[11]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000001900F00000)) 
    \spo[11]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[11]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000001A00000285)) 
    \spo[11]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[11]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h00000A10000000C0)) 
    \spo[11]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[11]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h00000000000300D0)) 
    \spo[11]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[11]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h000000000001FB3C)) 
    \spo[11]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[11]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000000700800038)) 
    \spo[11]_INST_0_i_28 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[11]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000C004000000080)) 
    \spo[11]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[11]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_3 
       (.I0(\spo[11]_INST_0_i_13_n_0 ),
        .I1(\spo[11]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[11]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[11]_INST_0_i_16_n_0 ),
        .O(\spo[11]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000A080000000000)) 
    \spo[11]_INST_0_i_30 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[2]),
        .O(\spo[11]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_4 
       (.I0(\spo[11]_INST_0_i_17_n_0 ),
        .I1(\spo[11]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[11]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[11]_INST_0_i_20_n_0 ),
        .O(\spo[11]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_5 
       (.I0(\spo[31]_INST_0_i_33_n_0 ),
        .I1(\spo[23]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(\spo[23]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(\spo[11]_INST_0_i_21_n_0 ),
        .O(\spo[11]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \spo[11]_INST_0_i_6 
       (.I0(\spo[15]_INST_0_i_16_n_0 ),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[20]_INST_0_i_24_n_0 ),
        .I5(a[7]),
        .O(\spo[11]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA00FCFCFA000C0C0)) 
    \spo[11]_INST_0_i_7 
       (.I0(\spo[18]_INST_0_i_23_n_0 ),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_21_n_0 ),
        .O(\spo[11]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[11]_INST_0_i_8 
       (.I0(\spo[27]_INST_0_i_36_n_0 ),
        .I1(\spo[11]_INST_0_i_22_n_0 ),
        .I2(a[7]),
        .I3(\spo[10]_INST_0_i_6_n_0 ),
        .I4(a[2]),
        .I5(\spo[30]_INST_0_i_9_n_0 ),
        .O(\spo[11]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h033B000808000800)) 
    \spo[11]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[0]),
        .O(\spo[11]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0 
       (.I0(\spo[12]_INST_0_i_1_n_0 ),
        .I1(\spo[12]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[12]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[12]_INST_0_i_4_n_0 ),
        .O(spo[12]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_1 
       (.I0(\spo[12]_INST_0_i_5_n_0 ),
        .I1(\spo[12]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[12]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[12]_INST_0_i_8_n_0 ),
        .O(\spo[12]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_10 
       (.I0(\spo[12]_INST_0_i_24_n_0 ),
        .I1(\spo[12]_INST_0_i_25_n_0 ),
        .I2(a[6]),
        .I3(\spo[12]_INST_0_i_26_n_0 ),
        .I4(a[7]),
        .I5(\spo[12]_INST_0_i_27_n_0 ),
        .O(\spo[12]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h88F0FFFF88F00000)) 
    \spo[12]_INST_0_i_11 
       (.I0(\spo[28]_INST_0_i_32_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_17_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[12]_INST_0_i_28_n_0 ),
        .O(\spo[12]_INST_0_i_11_n_0 ));
  MUXF7 \spo[12]_INST_0_i_12 
       (.I0(\spo[12]_INST_0_i_29_n_0 ),
        .I1(\spo[12]_INST_0_i_30_n_0 ),
        .O(\spo[12]_INST_0_i_12_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h30B3008033000000)) 
    \spo[12]_INST_0_i_13 
       (.I0(\spo[25]_INST_0_i_14_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_13_n_0 ));
  MUXF7 \spo[12]_INST_0_i_14 
       (.I0(\spo[12]_INST_0_i_31_n_0 ),
        .I1(\spo[12]_INST_0_i_32_n_0 ),
        .O(\spo[12]_INST_0_i_14_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_15 
       (.I0(\spo[12]_INST_0_i_33_n_0 ),
        .I1(\spo[31]_INST_0_i_21_n_0 ),
        .I2(a[6]),
        .I3(\spo[28]_INST_0_i_48_n_0 ),
        .I4(a[7]),
        .I5(\spo[12]_INST_0_i_34_n_0 ),
        .O(\spo[12]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_16 
       (.I0(\spo[12]_INST_0_i_35_n_0 ),
        .I1(\spo[12]_INST_0_i_36_n_0 ),
        .I2(a[6]),
        .I3(\spo[12]_INST_0_i_37_n_0 ),
        .I4(a[7]),
        .I5(\spo[12]_INST_0_i_38_n_0 ),
        .O(\spo[12]_INST_0_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h00000018)) 
    \spo[12]_INST_0_i_17 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[12]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h001C000100080002)) 
    \spo[12]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000810914)) 
    \spo[12]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[12]_INST_0_i_19_n_0 ));
  MUXF7 \spo[12]_INST_0_i_2 
       (.I0(\spo[12]_INST_0_i_9_n_0 ),
        .I1(\spo[12]_INST_0_i_10_n_0 ),
        .O(\spo[12]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h000000020001010C)) 
    \spo[12]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h000004C00000002A)) 
    \spo[12]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000009500000202)) 
    \spo[12]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h00000088000004C0)) 
    \spo[12]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000048B)) 
    \spo[12]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'h0004)) 
    \spo[12]_INST_0_i_25 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[12]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000008040000002D)) 
    \spo[12]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h000000F400000000)) 
    \spo[12]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000008300700004)) 
    \spo[12]_INST_0_i_28 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[12]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000000F1000000B0)) 
    \spo[12]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[12]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_3 
       (.I0(\spo[12]_INST_0_i_11_n_0 ),
        .I1(\spo[12]_INST_0_i_12_n_0 ),
        .I2(a[5]),
        .I3(\spo[12]_INST_0_i_13_n_0 ),
        .I4(a[6]),
        .I5(\spo[12]_INST_0_i_14_n_0 ),
        .O(\spo[12]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000022400000902)) 
    \spo[12]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h00080000001C000C)) 
    \spo[12]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h000000C1001A0000)) 
    \spo[12]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[12]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000002090000000C)) 
    \spo[12]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0004000802000002)) 
    \spo[12]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200010094)) 
    \spo[12]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[12]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000087000000880)) 
    \spo[12]_INST_0_i_36 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h000000430090009C)) 
    \spo[12]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[12]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h0001010300000E0C)) 
    \spo[12]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[12]_INST_0_i_38_n_0 ));
  MUXF7 \spo[12]_INST_0_i_4 
       (.I0(\spo[12]_INST_0_i_15_n_0 ),
        .I1(\spo[12]_INST_0_i_16_n_0 ),
        .O(\spo[12]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[12]_INST_0_i_5 
       (.I0(\spo[20]_INST_0_i_34_n_0 ),
        .I1(\spo[31]_INST_0_i_34_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_21_n_0 ),
        .I4(a[2]),
        .I5(\spo[12]_INST_0_i_17_n_0 ),
        .O(\spo[12]_INST_0_i_5_n_0 ));
  MUXF7 \spo[12]_INST_0_i_6 
       (.I0(\spo[12]_INST_0_i_18_n_0 ),
        .I1(\spo[12]_INST_0_i_19_n_0 ),
        .O(\spo[12]_INST_0_i_6_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h1F90000000400000)) 
    \spo[12]_INST_0_i_7 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[7]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[1]),
        .O(\spo[12]_INST_0_i_7_n_0 ));
  MUXF7 \spo[12]_INST_0_i_8 
       (.I0(\spo[12]_INST_0_i_20_n_0 ),
        .I1(\spo[12]_INST_0_i_21_n_0 ),
        .O(\spo[12]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAAFFAA00C000C000)) 
    \spo[12]_INST_0_i_9 
       (.I0(\spo[12]_INST_0_i_22_n_0 ),
        .I1(\spo[28]_INST_0_i_24_n_0 ),
        .I2(a[1]),
        .I3(a[6]),
        .I4(\spo[12]_INST_0_i_23_n_0 ),
        .I5(a[7]),
        .O(\spo[12]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \spo[13]_INST_0 
       (.I0(\spo[13]_INST_0_i_1_n_0 ),
        .I1(a[3]),
        .I2(\spo[13]_INST_0_i_2_n_0 ),
        .I3(a[4]),
        .I4(\spo[13]_INST_0_i_3_n_0 ),
        .O(spo[13]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_1 
       (.I0(\spo[13]_INST_0_i_4_n_0 ),
        .I1(\spo[13]_INST_0_i_5_n_0 ),
        .I2(a[5]),
        .I3(\spo[13]_INST_0_i_6_n_0 ),
        .I4(a[6]),
        .I5(\spo[13]_INST_0_i_7_n_0 ),
        .O(\spo[13]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00FF0000E2002200)) 
    \spo[13]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[7]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[2]),
        .O(\spo[13]_INST_0_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h40002100)) 
    \spo[13]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[28]_INST_0_i_24_n_0 ),
        .I4(a[1]),
        .O(\spo[13]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_12 
       (.I0(\spo[31]_INST_0_i_30_n_0 ),
        .I1(\spo[13]_INST_0_i_19_n_0 ),
        .I2(a[6]),
        .I3(\spo[13]_INST_0_i_20_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_25_n_0 ),
        .O(\spo[13]_INST_0_i_12_n_0 ));
  MUXF8 \spo[13]_INST_0_i_13 
       (.I0(\spo[13]_INST_0_i_21_n_0 ),
        .I1(\spo[13]_INST_0_i_22_n_0 ),
        .O(\spo[13]_INST_0_i_13_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_14 
       (.I0(\spo[8]_INST_0_i_5_n_0 ),
        .I1(\spo[13]_INST_0_i_23_n_0 ),
        .I2(a[6]),
        .I3(\spo[13]_INST_0_i_24_n_0 ),
        .I4(a[7]),
        .I5(\spo[13]_INST_0_i_25_n_0 ),
        .O(\spo[13]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hF0883333F0880000)) 
    \spo[13]_INST_0_i_15 
       (.I0(\spo[30]_INST_0_i_14_n_0 ),
        .I1(a[6]),
        .I2(\spo[30]_INST_0_i_15_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[13]_INST_0_i_26_n_0 ),
        .O(\spo[13]_INST_0_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h00000310)) 
    \spo[13]_INST_0_i_16 
       (.I0(a[1]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .O(\spo[13]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000004700040010)) 
    \spo[13]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[13]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT4 #(
    .INIT(16'h0221)) 
    \spo[13]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[13]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0002020000010A00)) 
    \spo[13]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_2 
       (.I0(\spo[13]_INST_0_i_8_n_0 ),
        .I1(\spo[13]_INST_0_i_9_n_0 ),
        .I2(a[5]),
        .I3(\spo[13]_INST_0_i_10_n_0 ),
        .I4(a[6]),
        .I5(\spo[13]_INST_0_i_11_n_0 ),
        .O(\spo[13]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000020800020900)) 
    \spo[13]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_20_n_0 ));
  MUXF7 \spo[13]_INST_0_i_21 
       (.I0(\spo[13]_INST_0_i_27_n_0 ),
        .I1(\spo[13]_INST_0_i_28_n_0 ),
        .O(\spo[13]_INST_0_i_21_n_0 ),
        .S(a[7]));
  MUXF7 \spo[13]_INST_0_i_22 
       (.I0(\spo[13]_INST_0_i_29_n_0 ),
        .I1(\spo[13]_INST_0_i_30_n_0 ),
        .O(\spo[13]_INST_0_i_22_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00000C00000008F0)) 
    \spo[13]_INST_0_i_23 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[13]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000085000000260)) 
    \spo[13]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[13]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h000000D20001003C)) 
    \spo[13]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[13]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000010C000000080)) 
    \spo[13]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[13]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h00080008000D000C)) 
    \spo[13]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h000A000000030000)) 
    \spo[13]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0300020000000000)) 
    \spo[13]_INST_0_i_29 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[13]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_3 
       (.I0(\spo[13]_INST_0_i_12_n_0 ),
        .I1(\spo[13]_INST_0_i_13_n_0 ),
        .I2(a[3]),
        .I3(\spo[13]_INST_0_i_14_n_0 ),
        .I4(a[5]),
        .I5(\spo[13]_INST_0_i_15_n_0 ),
        .O(\spo[13]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000060000)) 
    \spo[13]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[13]_INST_0_i_4 
       (.I0(\spo[31]_INST_0_i_33_n_0 ),
        .I1(\spo[23]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(\spo[23]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[13]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hA0CFA0C0AFC0A0C0)) 
    \spo[13]_INST_0_i_5 
       (.I0(\spo[20]_INST_0_i_24_n_0 ),
        .I1(\spo[13]_INST_0_i_16_n_0 ),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8830B8300000C000)) 
    \spo[13]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[13]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h88B88888BB888888)) 
    \spo[13]_INST_0_i_7 
       (.I0(\spo[13]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(a[0]),
        .I4(\spo[31]_INST_0_i_28_n_0 ),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h8833880030003000)) 
    \spo[13]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(\spo[29]_INST_0_i_20_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[1]),
        .O(\spo[13]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEEE222E200000000)) 
    \spo[13]_INST_0_i_9 
       (.I0(\spo[28]_INST_0_i_20_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[1]),
        .I4(\spo[13]_INST_0_i_18_n_0 ),
        .I5(a[7]),
        .O(\spo[13]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[14]_INST_0 
       (.I0(\spo[14]_INST_0_i_1_n_0 ),
        .I1(\spo[14]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[14]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[14]_INST_0_i_4_n_0 ),
        .O(spo[14]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[14]_INST_0_i_1 
       (.I0(\spo[14]_INST_0_i_5_n_0 ),
        .I1(\spo[14]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[14]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[14]_INST_0_i_8_n_0 ),
        .O(\spo[14]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA0FFA000C000C000)) 
    \spo[14]_INST_0_i_10 
       (.I0(\spo[30]_INST_0_i_15_n_0 ),
        .I1(\spo[19]_INST_0_i_31_n_0 ),
        .I2(a[2]),
        .I3(a[6]),
        .I4(\spo[14]_INST_0_i_22_n_0 ),
        .I5(a[7]),
        .O(\spo[14]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[14]_INST_0_i_11 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_21_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[15]_INST_0_i_18_n_0 ),
        .O(\spo[14]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h88888888B8BBB888)) 
    \spo[14]_INST_0_i_12 
       (.I0(\spo[14]_INST_0_i_23_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_18_n_0 ),
        .I5(a[1]),
        .O(\spo[14]_INST_0_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h0000CC80)) 
    \spo[14]_INST_0_i_13 
       (.I0(a[1]),
        .I1(\spo[28]_INST_0_i_24_n_0 ),
        .I2(a[0]),
        .I3(a[2]),
        .I4(a[7]),
        .O(\spo[14]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010331000)) 
    \spo[14]_INST_0_i_14 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(\spo[14]_INST_0_i_24_n_0 ),
        .I3(a[0]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[2]),
        .O(\spo[14]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFF0A00000C000C0)) 
    \spo[14]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(\spo[22]_INST_0_i_24_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[14]_INST_0_i_15_n_0 ));
  MUXF7 \spo[14]_INST_0_i_16 
       (.I0(\spo[14]_INST_0_i_25_n_0 ),
        .I1(\spo[14]_INST_0_i_26_n_0 ),
        .O(\spo[14]_INST_0_i_16_n_0 ),
        .S(a[7]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h08400000)) 
    \spo[14]_INST_0_i_17 
       (.I0(a[1]),
        .I1(\spo[31]_INST_0_i_28_n_0 ),
        .I2(a[0]),
        .I3(a[2]),
        .I4(a[7]),
        .O(\spo[14]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h1011100091448000)) 
    \spo[14]_INST_0_i_18 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(\spo[30]_INST_0_i_16_n_0 ),
        .I5(a[0]),
        .O(\spo[14]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200000108)) 
    \spo[14]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[14]_INST_0_i_19_n_0 ));
  MUXF7 \spo[14]_INST_0_i_2 
       (.I0(\spo[14]_INST_0_i_9_n_0 ),
        .I1(\spo[14]_INST_0_i_10_n_0 ),
        .O(\spo[14]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000004700000012)) 
    \spo[14]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[14]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'h000B0008)) 
    \spo[14]_INST_0_i_21 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[14]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000000C700040000)) 
    \spo[14]_INST_0_i_22 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[14]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000020C00000900)) 
    \spo[14]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[14]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'h07)) 
    \spo[14]_INST_0_i_24 
       (.I0(a[9]),
        .I1(a[8]),
        .I2(a[10]),
        .O(\spo[14]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000008F000000F0)) 
    \spo[14]_INST_0_i_25 
       (.I0(a[8]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[14]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0002080200080204)) 
    \spo[14]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[14]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[14]_INST_0_i_3 
       (.I0(\spo[14]_INST_0_i_11_n_0 ),
        .I1(\spo[14]_INST_0_i_12_n_0 ),
        .I2(a[5]),
        .I3(\spo[14]_INST_0_i_13_n_0 ),
        .I4(a[6]),
        .I5(\spo[14]_INST_0_i_14_n_0 ),
        .O(\spo[14]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[14]_INST_0_i_4 
       (.I0(\spo[14]_INST_0_i_15_n_0 ),
        .I1(\spo[14]_INST_0_i_16_n_0 ),
        .I2(a[5]),
        .I3(\spo[14]_INST_0_i_17_n_0 ),
        .I4(a[6]),
        .I5(\spo[14]_INST_0_i_18_n_0 ),
        .O(\spo[14]_INST_0_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \spo[14]_INST_0_i_5 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_21_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .O(\spo[14]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hA00FA0000FC000C0)) 
    \spo[14]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(\spo[15]_INST_0_i_16_n_0 ),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[1]),
        .O(\spo[14]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8B333FBB88000088)) 
    \spo[14]_INST_0_i_7 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_24_n_0 ),
        .O(\spo[14]_INST_0_i_7_n_0 ));
  MUXF7 \spo[14]_INST_0_i_8 
       (.I0(\spo[14]_INST_0_i_19_n_0 ),
        .I1(\spo[14]_INST_0_i_20_n_0 ),
        .O(\spo[14]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h33B800B800000000)) 
    \spo[14]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[6]),
        .I2(\spo[30]_INST_0_i_15_n_0 ),
        .I3(a[2]),
        .I4(\spo[14]_INST_0_i_21_n_0 ),
        .I5(a[7]),
        .O(\spo[14]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[15]_INST_0 
       (.I0(\spo[15]_INST_0_i_1_n_0 ),
        .I1(\spo[15]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[15]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[15]_INST_0_i_4_n_0 ),
        .O(spo[15]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \spo[15]_INST_0_i_1 
       (.I0(\spo[15]_INST_0_i_5_n_0 ),
        .I1(a[5]),
        .I2(\spo[15]_INST_0_i_6_n_0 ),
        .I3(a[6]),
        .I4(\spo[15]_INST_0_i_7_n_0 ),
        .O(\spo[15]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0500000025150000)) 
    \spo[15]_INST_0_i_10 
       (.I0(a[6]),
        .I1(a[0]),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[1]),
        .O(\spo[15]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[15]_INST_0_i_11 
       (.I0(\spo[31]_INST_0_i_30_n_0 ),
        .I1(\spo[15]_INST_0_i_18_n_0 ),
        .I2(a[6]),
        .I3(\spo[15]_INST_0_i_19_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_25_n_0 ),
        .O(\spo[15]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \spo[15]_INST_0_i_12 
       (.I0(\spo[15]_INST_0_i_20_n_0 ),
        .I1(a[7]),
        .I2(\spo[25]_INST_0_i_21_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_18_n_0 ),
        .I5(a[2]),
        .O(\spo[15]_INST_0_i_12_n_0 ));
  MUXF7 \spo[15]_INST_0_i_13 
       (.I0(\spo[15]_INST_0_i_21_n_0 ),
        .I1(\spo[15]_INST_0_i_22_n_0 ),
        .O(\spo[15]_INST_0_i_13_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h2020104000000000)) 
    \spo[15]_INST_0_i_14 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(\spo[31]_INST_0_i_29_n_0 ),
        .I3(a[8]),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[15]_INST_0_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h70000000)) 
    \spo[15]_INST_0_i_15 
       (.I0(a[0]),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[28]_INST_0_i_24_n_0 ),
        .I4(a[2]),
        .O(\spo[15]_INST_0_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'h0016)) 
    \spo[15]_INST_0_i_16 
       (.I0(a[0]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .O(\spo[15]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000080100020000)) 
    \spo[15]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[15]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h00000000007F0100)) 
    \spo[15]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[15]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0000020400000900)) 
    \spo[15]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[15]_INST_0_i_19_n_0 ));
  MUXF7 \spo[15]_INST_0_i_2 
       (.I0(\spo[15]_INST_0_i_8_n_0 ),
        .I1(\spo[15]_INST_0_i_9_n_0 ),
        .O(\spo[15]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0002000000030010)) 
    \spo[15]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[15]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h000000CF000000B8)) 
    \spo[15]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[15]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000007F00800018)) 
    \spo[15]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[15]_INST_0_i_22_n_0 ));
  MUXF7 \spo[15]_INST_0_i_3 
       (.I0(\spo[15]_INST_0_i_10_n_0 ),
        .I1(\spo[15]_INST_0_i_11_n_0 ),
        .O(\spo[15]_INST_0_i_3_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[15]_INST_0_i_4 
       (.I0(\spo[15]_INST_0_i_12_n_0 ),
        .I1(\spo[15]_INST_0_i_13_n_0 ),
        .I2(a[5]),
        .I3(\spo[15]_INST_0_i_14_n_0 ),
        .I4(a[6]),
        .I5(\spo[15]_INST_0_i_15_n_0 ),
        .O(\spo[15]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h500054040000AA00)) 
    \spo[15]_INST_0_i_5 
       (.I0(a[6]),
        .I1(\spo[15]_INST_0_i_16_n_0 ),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[15]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h03333FBB00000088)) 
    \spo[15]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_24_n_0 ),
        .O(\spo[15]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8B88BC8000000000)) 
    \spo[15]_INST_0_i_7 
       (.I0(\spo[28]_INST_0_i_24_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[15]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h88880000CC00CF00)) 
    \spo[15]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[6]),
        .I2(a[2]),
        .I3(\spo[28]_INST_0_i_24_n_0 ),
        .I4(a[1]),
        .I5(a[7]),
        .O(\spo[15]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hA0FFA000C000C000)) 
    \spo[15]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[28]_INST_0_i_37_n_0 ),
        .I2(a[2]),
        .I3(a[6]),
        .I4(\spo[15]_INST_0_i_17_n_0 ),
        .I5(a[7]),
        .O(\spo[15]_INST_0_i_9_n_0 ));
  MUXF7 \spo[16]_INST_0 
       (.I0(\spo[16]_INST_0_i_1_n_0 ),
        .I1(\spo[16]_INST_0_i_2_n_0 ),
        .O(spo[16]),
        .S(a[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[16]_INST_0_i_1 
       (.I0(\spo[16]_INST_0_i_3_n_0 ),
        .I1(\spo[16]_INST_0_i_4_n_0 ),
        .I2(a[3]),
        .I3(\spo[16]_INST_0_i_5_n_0 ),
        .I4(a[5]),
        .I5(\spo[16]_INST_0_i_6_n_0 ),
        .O(\spo[16]_INST_0_i_1_n_0 ));
  MUXF8 \spo[16]_INST_0_i_10 
       (.I0(\spo[16]_INST_0_i_28_n_0 ),
        .I1(\spo[16]_INST_0_i_29_n_0 ),
        .O(\spo[16]_INST_0_i_10_n_0 ),
        .S(a[6]));
  MUXF7 \spo[16]_INST_0_i_11 
       (.I0(\spo[16]_INST_0_i_30_n_0 ),
        .I1(\spo[16]_INST_0_i_31_n_0 ),
        .O(\spo[16]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_12 
       (.I0(\spo[16]_INST_0_i_32_n_0 ),
        .I1(\spo[16]_INST_0_i_33_n_0 ),
        .O(\spo[16]_INST_0_i_12_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_13 
       (.I0(\spo[16]_INST_0_i_34_n_0 ),
        .I1(\spo[16]_INST_0_i_35_n_0 ),
        .O(\spo[16]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_14 
       (.I0(\spo[16]_INST_0_i_36_n_0 ),
        .I1(\spo[16]_INST_0_i_37_n_0 ),
        .O(\spo[16]_INST_0_i_14_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_15 
       (.I0(\spo[16]_INST_0_i_38_n_0 ),
        .I1(\spo[16]_INST_0_i_39_n_0 ),
        .O(\spo[16]_INST_0_i_15_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_16 
       (.I0(\spo[16]_INST_0_i_40_n_0 ),
        .I1(\spo[16]_INST_0_i_41_n_0 ),
        .O(\spo[16]_INST_0_i_16_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0002007A0032009F)) 
    \spo[16]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h03300200)) 
    \spo[16]_INST_0_i_18 
       (.I0(a[1]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .O(\spo[16]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h000000000099090F)) 
    \spo[16]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[16]_INST_0_i_2 
       (.I0(\spo[16]_INST_0_i_7_n_0 ),
        .I1(\spo[16]_INST_0_i_8_n_0 ),
        .I2(a[3]),
        .I3(\spo[16]_INST_0_i_9_n_0 ),
        .I4(a[5]),
        .I5(\spo[16]_INST_0_i_10_n_0 ),
        .O(\spo[16]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0057004000400082)) 
    \spo[16]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_20_n_0 ));
  MUXF7 \spo[16]_INST_0_i_21 
       (.I0(\spo[16]_INST_0_i_42_n_0 ),
        .I1(\spo[16]_INST_0_i_43_n_0 ),
        .O(\spo[16]_INST_0_i_21_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_22 
       (.I0(\spo[16]_INST_0_i_44_n_0 ),
        .I1(\spo[16]_INST_0_i_45_n_0 ),
        .O(\spo[16]_INST_0_i_22_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00000A0400000C65)) 
    \spo[16]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000567D)) 
    \spo[16]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[9]),
        .I3(a[1]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000000009089515)) 
    \spo[16]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_25_n_0 ));
  MUXF7 \spo[16]_INST_0_i_26 
       (.I0(\spo[16]_INST_0_i_46_n_0 ),
        .I1(\spo[16]_INST_0_i_47_n_0 ),
        .O(\spo[16]_INST_0_i_26_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_27 
       (.I0(\spo[16]_INST_0_i_48_n_0 ),
        .I1(\spo[16]_INST_0_i_49_n_0 ),
        .O(\spo[16]_INST_0_i_27_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_28 
       (.I0(\spo[16]_INST_0_i_50_n_0 ),
        .I1(\spo[16]_INST_0_i_51_n_0 ),
        .O(\spo[16]_INST_0_i_28_n_0 ),
        .S(a[7]));
  MUXF7 \spo[16]_INST_0_i_29 
       (.I0(\spo[16]_INST_0_i_52_n_0 ),
        .I1(\spo[16]_INST_0_i_53_n_0 ),
        .O(\spo[16]_INST_0_i_29_n_0 ),
        .S(a[7]));
  MUXF8 \spo[16]_INST_0_i_3 
       (.I0(\spo[16]_INST_0_i_11_n_0 ),
        .I1(\spo[16]_INST_0_i_12_n_0 ),
        .O(\spo[16]_INST_0_i_3_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h000F0F0B0000020E)) 
    \spo[16]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h000A060200090F0F)) 
    \spo[16]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h000000AF0000004A)) 
    \spo[16]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h00000080000000BF)) 
    \spo[16]_INST_0_i_33 
       (.I0(a[9]),
        .I1(a[0]),
        .I2(a[2]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[16]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h000000A500200092)) 
    \spo[16]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h00000000090E0017)) 
    \spo[16]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h00030F0000040000)) 
    \spo[16]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h00001060000012DD)) 
    \spo[16]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000F000950014)) 
    \spo[16]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h0000008800D200E7)) 
    \spo[16]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_39_n_0 ));
  MUXF8 \spo[16]_INST_0_i_4 
       (.I0(\spo[16]_INST_0_i_13_n_0 ),
        .I1(\spo[16]_INST_0_i_14_n_0 ),
        .O(\spo[16]_INST_0_i_4_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h000000C0000007A0)) 
    \spo[16]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h0032001800120037)) 
    \spo[16]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h000000E900B00000)) 
    \spo[16]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h00000000009D8B4D)) 
    \spo[16]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000B9BF0F)) 
    \spo[16]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h000000000033007C)) 
    \spo[16]_INST_0_i_45 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h000000000F00F433)) 
    \spo[16]_INST_0_i_46 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[16]_INST_0_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h000000F700002242)) 
    \spo[16]_INST_0_i_47 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h0020000800000037)) 
    \spo[16]_INST_0_i_48 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_48_n_0 ));
  LUT6 #(
    .INIT(64'h00000A0A0000060D)) 
    \spo[16]_INST_0_i_49 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_49_n_0 ));
  MUXF8 \spo[16]_INST_0_i_5 
       (.I0(\spo[16]_INST_0_i_15_n_0 ),
        .I1(\spo[16]_INST_0_i_16_n_0 ),
        .O(\spo[16]_INST_0_i_5_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h000000AA00000384)) 
    \spo[16]_INST_0_i_50 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_50_n_0 ));
  LUT6 #(
    .INIT(64'h0000001700000008)) 
    \spo[16]_INST_0_i_51 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[16]_INST_0_i_51_n_0 ));
  LUT6 #(
    .INIT(64'h000000CD00320000)) 
    \spo[16]_INST_0_i_52 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_52_n_0 ));
  LUT6 #(
    .INIT(64'h0000070600009ABF)) 
    \spo[16]_INST_0_i_53 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[16]_INST_0_i_53_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[16]_INST_0_i_6 
       (.I0(\spo[16]_INST_0_i_17_n_0 ),
        .I1(\spo[16]_INST_0_i_18_n_0 ),
        .I2(a[6]),
        .I3(\spo[16]_INST_0_i_19_n_0 ),
        .I4(a[7]),
        .I5(\spo[16]_INST_0_i_20_n_0 ),
        .O(\spo[16]_INST_0_i_6_n_0 ));
  MUXF8 \spo[16]_INST_0_i_7 
       (.I0(\spo[16]_INST_0_i_21_n_0 ),
        .I1(\spo[16]_INST_0_i_22_n_0 ),
        .O(\spo[16]_INST_0_i_7_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[16]_INST_0_i_8 
       (.I0(\spo[16]_INST_0_i_23_n_0 ),
        .I1(\spo[31]_INST_0_i_20_n_0 ),
        .I2(a[6]),
        .I3(\spo[16]_INST_0_i_24_n_0 ),
        .I4(a[7]),
        .I5(\spo[16]_INST_0_i_25_n_0 ),
        .O(\spo[16]_INST_0_i_8_n_0 ));
  MUXF8 \spo[16]_INST_0_i_9 
       (.I0(\spo[16]_INST_0_i_26_n_0 ),
        .I1(\spo[16]_INST_0_i_27_n_0 ),
        .O(\spo[16]_INST_0_i_9_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0 
       (.I0(\spo[17]_INST_0_i_1_n_0 ),
        .I1(\spo[17]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[17]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[17]_INST_0_i_4_n_0 ),
        .O(spo[17]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0_i_1 
       (.I0(\spo[17]_INST_0_i_5_n_0 ),
        .I1(\spo[17]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[17]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[17]_INST_0_i_8_n_0 ),
        .O(\spo[17]_INST_0_i_1_n_0 ));
  MUXF7 \spo[17]_INST_0_i_10 
       (.I0(\spo[17]_INST_0_i_28_n_0 ),
        .I1(\spo[17]_INST_0_i_29_n_0 ),
        .O(\spo[17]_INST_0_i_10_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_11 
       (.I0(\spo[17]_INST_0_i_30_n_0 ),
        .I1(\spo[17]_INST_0_i_31_n_0 ),
        .O(\spo[17]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_12 
       (.I0(\spo[17]_INST_0_i_32_n_0 ),
        .I1(\spo[17]_INST_0_i_33_n_0 ),
        .O(\spo[17]_INST_0_i_12_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_13 
       (.I0(\spo[17]_INST_0_i_34_n_0 ),
        .I1(\spo[17]_INST_0_i_35_n_0 ),
        .O(\spo[17]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_14 
       (.I0(\spo[17]_INST_0_i_36_n_0 ),
        .I1(\spo[17]_INST_0_i_37_n_0 ),
        .O(\spo[17]_INST_0_i_14_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hBBBB8888B888B888)) 
    \spo[17]_INST_0_i_15 
       (.I0(\spo[17]_INST_0_i_38_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_21_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[1]),
        .O(\spo[17]_INST_0_i_15_n_0 ));
  MUXF7 \spo[17]_INST_0_i_16 
       (.I0(\spo[17]_INST_0_i_39_n_0 ),
        .I1(\spo[17]_INST_0_i_40_n_0 ),
        .O(\spo[17]_INST_0_i_16_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_17 
       (.I0(\spo[17]_INST_0_i_41_n_0 ),
        .I1(\spo[17]_INST_0_i_42_n_0 ),
        .O(\spo[17]_INST_0_i_17_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hFA290000D01A0000)) 
    \spo[17]_INST_0_i_18 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_18_n_0 ));
  MUXF7 \spo[17]_INST_0_i_19 
       (.I0(\spo[17]_INST_0_i_43_n_0 ),
        .I1(\spo[17]_INST_0_i_44_n_0 ),
        .O(\spo[17]_INST_0_i_19_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0_i_2 
       (.I0(\spo[17]_INST_0_i_9_n_0 ),
        .I1(\spo[17]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[17]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[17]_INST_0_i_12_n_0 ),
        .O(\spo[17]_INST_0_i_2_n_0 ));
  MUXF7 \spo[17]_INST_0_i_20 
       (.I0(\spo[17]_INST_0_i_45_n_0 ),
        .I1(\spo[17]_INST_0_i_46_n_0 ),
        .O(\spo[17]_INST_0_i_20_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h000000000015413C)) 
    \spo[17]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[17]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000002200E50052)) 
    \spo[17]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000022E00000001)) 
    \spo[17]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000007000C30000)) 
    \spo[17]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000301000001005)) 
    \spo[17]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000002C7000000B8)) 
    \spo[17]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000005000630014)) 
    \spo[17]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h00000102000001FF)) 
    \spo[17]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[0]),
        .I3(a[1]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000000C2000A00AF)) 
    \spo[17]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0_i_3 
       (.I0(\spo[17]_INST_0_i_13_n_0 ),
        .I1(\spo[17]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[17]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[17]_INST_0_i_16_n_0 ),
        .O(\spo[17]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000C90000002A0)) 
    \spo[17]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000020A0000040D)) 
    \spo[17]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000005500400036)) 
    \spo[17]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000491733)) 
    \spo[17]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[17]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h00000F0000000040)) 
    \spo[17]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000020D0000044A)) 
    \spo[17]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h00000012000F0020)) 
    \spo[17]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h0000000009000B1D)) 
    \spo[17]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[17]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000000090008D)) 
    \spo[17]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h000000000C008F37)) 
    \spo[17]_INST_0_i_39 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[1]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[17]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0_i_4 
       (.I0(\spo[17]_INST_0_i_17_n_0 ),
        .I1(\spo[17]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[17]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[17]_INST_0_i_20_n_0 ),
        .O(\spo[17]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000003400050034)) 
    \spo[17]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[17]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h00000E40000003C0)) 
    \spo[17]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h000000040000008B)) 
    \spo[17]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h00000F4000000040)) 
    \spo[17]_INST_0_i_43 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[17]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000105200000007)) 
    \spo[17]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h0000064200000208)) 
    \spo[17]_INST_0_i_45 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[17]_INST_0_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h000002030000000C)) 
    \spo[17]_INST_0_i_46 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[17]_INST_0_i_46_n_0 ));
  LUT5 #(
    .INIT(32'h48FF4800)) 
    \spo[17]_INST_0_i_5 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .I4(\spo[17]_INST_0_i_21_n_0 ),
        .O(\spo[17]_INST_0_i_5_n_0 ));
  MUXF7 \spo[17]_INST_0_i_6 
       (.I0(\spo[17]_INST_0_i_22_n_0 ),
        .I1(\spo[17]_INST_0_i_23_n_0 ),
        .O(\spo[17]_INST_0_i_6_n_0 ),
        .S(a[7]));
  MUXF7 \spo[17]_INST_0_i_7 
       (.I0(\spo[17]_INST_0_i_24_n_0 ),
        .I1(\spo[17]_INST_0_i_25_n_0 ),
        .O(\spo[17]_INST_0_i_7_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hD0B0804000A080A0)) 
    \spo[17]_INST_0_i_8 
       (.I0(a[7]),
        .I1(a[0]),
        .I2(\spo[31]_INST_0_i_29_n_0 ),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[17]_INST_0_i_8_n_0 ));
  MUXF7 \spo[17]_INST_0_i_9 
       (.I0(\spo[17]_INST_0_i_26_n_0 ),
        .I1(\spo[17]_INST_0_i_27_n_0 ),
        .O(\spo[17]_INST_0_i_9_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0 
       (.I0(\spo[18]_INST_0_i_1_n_0 ),
        .I1(\spo[18]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[18]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[18]_INST_0_i_4_n_0 ),
        .O(spo[18]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_1 
       (.I0(\spo[18]_INST_0_i_5_n_0 ),
        .I1(\spo[18]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[18]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[18]_INST_0_i_8_n_0 ),
        .O(\spo[18]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8B88BB8B8B88B888)) 
    \spo[18]_INST_0_i_10 
       (.I0(\spo[18]_INST_0_i_29_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_18_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[18]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hBB888888B8BB8888)) 
    \spo[18]_INST_0_i_11 
       (.I0(\spo[18]_INST_0_i_30_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[18]_INST_0_i_11_n_0 ));
  MUXF7 \spo[18]_INST_0_i_12 
       (.I0(\spo[18]_INST_0_i_31_n_0 ),
        .I1(\spo[18]_INST_0_i_32_n_0 ),
        .O(\spo[18]_INST_0_i_12_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hB800FFFFB8000000)) 
    \spo[18]_INST_0_i_13 
       (.I0(\spo[28]_INST_0_i_24_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[18]_INST_0_i_33_n_0 ),
        .O(\spo[18]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hBFBC330383803000)) 
    \spo[18]_INST_0_i_14 
       (.I0(\spo[25]_INST_0_i_18_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[25]_INST_0_i_14_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[18]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_15 
       (.I0(\spo[28]_INST_0_i_37_n_0 ),
        .I1(\spo[31]_INST_0_i_23_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_38_n_0 ),
        .I4(a[2]),
        .I5(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[18]_INST_0_i_15_n_0 ));
  MUXF7 \spo[18]_INST_0_i_16 
       (.I0(\spo[18]_INST_0_i_34_n_0 ),
        .I1(\spo[18]_INST_0_i_35_n_0 ),
        .O(\spo[18]_INST_0_i_16_n_0 ),
        .S(a[7]));
  MUXF7 \spo[18]_INST_0_i_17 
       (.I0(\spo[18]_INST_0_i_36_n_0 ),
        .I1(\spo[18]_INST_0_i_37_n_0 ),
        .O(\spo[18]_INST_0_i_17_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h40F0FFFF40F00000)) 
    \spo[18]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[18]_INST_0_i_38_n_0 ),
        .O(\spo[18]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_19 
       (.I0(\spo[18]_INST_0_i_39_n_0 ),
        .I1(\spo[18]_INST_0_i_40_n_0 ),
        .I2(a[7]),
        .I3(\spo[31]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_18_n_0 ),
        .O(\spo[18]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_2 
       (.I0(\spo[18]_INST_0_i_9_n_0 ),
        .I1(\spo[18]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[18]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[18]_INST_0_i_12_n_0 ),
        .O(\spo[18]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_20 
       (.I0(\spo[18]_INST_0_i_41_n_0 ),
        .I1(\spo[18]_INST_0_i_42_n_0 ),
        .I2(a[7]),
        .I3(\spo[18]_INST_0_i_43_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_21_n_0 ),
        .O(\spo[18]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000004D0002006A)) 
    \spo[18]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000004800000008D)) 
    \spo[18]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \spo[18]_INST_0_i_23 
       (.I0(a[8]),
        .I1(a[10]),
        .I2(a[0]),
        .O(\spo[18]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h00200020002C0018)) 
    \spo[18]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[18]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000090040)) 
    \spo[18]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0000002000000324)) 
    \spo[18]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h00000E2600000C1A)) 
    \spo[18]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000082400000182)) 
    \spo[18]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000004C0000008B)) 
    \spo[18]_INST_0_i_29 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_3 
       (.I0(\spo[18]_INST_0_i_13_n_0 ),
        .I1(\spo[18]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[18]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[18]_INST_0_i_16_n_0 ),
        .O(\spo[18]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000003C00000008)) 
    \spo[18]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000080800090000)) 
    \spo[18]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[18]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h000000000017005A)) 
    \spo[18]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0031003000020008)) 
    \spo[18]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[18]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h000000F000430000)) 
    \spo[18]_INST_0_i_34 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h000000B0000000C4)) 
    \spo[18]_INST_0_i_35 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[18]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000003600890000)) 
    \spo[18]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h0000004900000022)) 
    \spo[18]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[18]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h0000005500100028)) 
    \spo[18]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[18]_INST_0_i_38_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h00080003)) 
    \spo[18]_INST_0_i_39 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[18]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[18]_INST_0_i_4 
       (.I0(\spo[18]_INST_0_i_17_n_0 ),
        .I1(\spo[18]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[18]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[18]_INST_0_i_20_n_0 ),
        .O(\spo[18]_INST_0_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'h0002)) 
    \spo[18]_INST_0_i_40 
       (.I0(a[0]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[18]_INST_0_i_40_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000007)) 
    \spo[18]_INST_0_i_41 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[18]_INST_0_i_41_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00040108)) 
    \spo[18]_INST_0_i_42 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[18]_INST_0_i_42_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT4 #(
    .INIT(16'h0002)) 
    \spo[18]_INST_0_i_43 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[18]_INST_0_i_43_n_0 ));
  MUXF7 \spo[18]_INST_0_i_5 
       (.I0(\spo[18]_INST_0_i_21_n_0 ),
        .I1(\spo[18]_INST_0_i_22_n_0 ),
        .O(\spo[18]_INST_0_i_5_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00000000CFA0C0A0)) 
    \spo[18]_INST_0_i_6 
       (.I0(\spo[18]_INST_0_i_23_n_0 ),
        .I1(\spo[28]_INST_0_i_25_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[2]),
        .O(\spo[18]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00E2FFFF00E20000)) 
    \spo[18]_INST_0_i_7 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[1]),
        .I2(\spo[22]_INST_0_i_21_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[18]_INST_0_i_24_n_0 ),
        .O(\spo[18]_INST_0_i_7_n_0 ));
  MUXF7 \spo[18]_INST_0_i_8 
       (.I0(\spo[18]_INST_0_i_25_n_0 ),
        .I1(\spo[18]_INST_0_i_26_n_0 ),
        .O(\spo[18]_INST_0_i_8_n_0 ),
        .S(a[7]));
  MUXF7 \spo[18]_INST_0_i_9 
       (.I0(\spo[18]_INST_0_i_27_n_0 ),
        .I1(\spo[18]_INST_0_i_28_n_0 ),
        .O(\spo[18]_INST_0_i_9_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[19]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[19]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[19]_INST_0_i_4_n_0 ),
        .O(spo[19]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_1 
       (.I0(\spo[19]_INST_0_i_5_n_0 ),
        .I1(\spo[19]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[19]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[19]_INST_0_i_8_n_0 ),
        .O(\spo[19]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_10 
       (.I0(\spo[19]_INST_0_i_27_n_0 ),
        .I1(\spo[10]_INST_0_i_6_n_0 ),
        .I2(a[7]),
        .I3(\spo[20]_INST_0_i_23_n_0 ),
        .I4(a[2]),
        .I5(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[19]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h08BB088883888088)) 
    \spo[19]_INST_0_i_11 
       (.I0(\spo[31]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[1]),
        .O(\spo[19]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h1055100099440000)) 
    \spo[19]_INST_0_i_12 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_28_n_0 ),
        .I5(a[0]),
        .O(\spo[19]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h8888888888888B88)) 
    \spo[19]_INST_0_i_13 
       (.I0(\spo[19]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[2]),
        .O(\spo[19]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_14 
       (.I0(\spo[19]_INST_0_i_29_n_0 ),
        .I1(\spo[19]_INST_0_i_30_n_0 ),
        .I2(a[7]),
        .I3(\spo[19]_INST_0_i_31_n_0 ),
        .I4(a[2]),
        .I5(\spo[30]_INST_0_i_17_n_0 ),
        .O(\spo[19]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hC000C00070FF7000)) 
    \spo[19]_INST_0_i_15 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_18_n_0 ),
        .I5(a[2]),
        .O(\spo[19]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h4A4FFFFF40400000)) 
    \spo[19]_INST_0_i_16 
       (.I0(a[7]),
        .I1(\spo[19]_INST_0_i_32_n_0 ),
        .I2(a[1]),
        .I3(a[0]),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_28_n_0 ),
        .O(\spo[19]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h88888888BBB888B8)) 
    \spo[19]_INST_0_i_17 
       (.I0(\spo[19]_INST_0_i_33_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_34_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[19]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h462D000046520000)) 
    \spo[19]_INST_0_i_18 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[19]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h60FF6000B000B000)) 
    \spo[19]_INST_0_i_19 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[7]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[2]),
        .O(\spo[19]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_2 
       (.I0(\spo[19]_INST_0_i_9_n_0 ),
        .I1(\spo[19]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[19]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[19]_INST_0_i_12_n_0 ),
        .O(\spo[19]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB833B80030003000)) 
    \spo[19]_INST_0_i_20 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_35_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_21_n_0 ),
        .I5(a[1]),
        .O(\spo[19]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000040400000016)) 
    \spo[19]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[19]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h00000000005000F3)) 
    \spo[19]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[19]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000001900FE0000)) 
    \spo[19]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[19]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h000000D0004000C5)) 
    \spo[19]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[19]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h000C0900)) 
    \spo[19]_INST_0_i_25 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[19]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h00060000)) 
    \spo[19]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[19]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h00020001)) 
    \spo[19]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[19]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000020100000442)) 
    \spo[19]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[19]_INST_0_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h00210000)) 
    \spo[19]_INST_0_i_29 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[19]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_3 
       (.I0(\spo[19]_INST_0_i_13_n_0 ),
        .I1(\spo[19]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[19]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[19]_INST_0_i_16_n_0 ),
        .O(\spo[19]_INST_0_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h00000403)) 
    \spo[19]_INST_0_i_30 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[19]_INST_0_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    \spo[19]_INST_0_i_31 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[19]_INST_0_i_31_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \spo[19]_INST_0_i_32 
       (.I0(a[10]),
        .I1(a[8]),
        .O(\spo[19]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800002F1B)) 
    \spo[19]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[19]_INST_0_i_33_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT4 #(
    .INIT(16'h0210)) 
    \spo[19]_INST_0_i_34 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[19]_INST_0_i_34_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h00000306)) 
    \spo[19]_INST_0_i_35 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[19]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[19]_INST_0_i_4 
       (.I0(\spo[19]_INST_0_i_17_n_0 ),
        .I1(\spo[19]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[19]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[19]_INST_0_i_20_n_0 ),
        .O(\spo[19]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0015295500000000)) 
    \spo[19]_INST_0_i_5 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[0]),
        .I5(\spo[31]_INST_0_i_29_n_0 ),
        .O(\spo[19]_INST_0_i_5_n_0 ));
  MUXF7 \spo[19]_INST_0_i_6 
       (.I0(\spo[19]_INST_0_i_21_n_0 ),
        .I1(\spo[19]_INST_0_i_22_n_0 ),
        .O(\spo[19]_INST_0_i_6_n_0 ),
        .S(a[7]));
  MUXF7 \spo[19]_INST_0_i_7 
       (.I0(\spo[19]_INST_0_i_23_n_0 ),
        .I1(\spo[19]_INST_0_i_24_n_0 ),
        .O(\spo[19]_INST_0_i_7_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hA030004000A000A0)) 
    \spo[19]_INST_0_i_8 
       (.I0(a[7]),
        .I1(a[0]),
        .I2(\spo[31]_INST_0_i_29_n_0 ),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[19]_INST_0_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \spo[19]_INST_0_i_9 
       (.I0(\spo[19]_INST_0_i_25_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_26_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[19]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[1]_INST_0 
       (.I0(\spo[1]_INST_0_i_1_n_0 ),
        .I1(\spo[1]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[1]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[1]_INST_0_i_4_n_0 ),
        .O(spo[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[1]_INST_0_i_1 
       (.I0(\spo[1]_INST_0_i_5_n_0 ),
        .I1(\spo[1]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[1]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[1]_INST_0_i_8_n_0 ),
        .O(\spo[1]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hC000C000A0FFA000)) 
    \spo[1]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(\spo[13]_INST_0_i_18_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_18_n_0 ),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_10_n_0 ));
  MUXF7 \spo[1]_INST_0_i_11 
       (.I0(\spo[1]_INST_0_i_28_n_0 ),
        .I1(\spo[1]_INST_0_i_29_n_0 ),
        .O(\spo[1]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_12 
       (.I0(\spo[1]_INST_0_i_30_n_0 ),
        .I1(\spo[1]_INST_0_i_31_n_0 ),
        .O(\spo[1]_INST_0_i_12_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_13 
       (.I0(\spo[1]_INST_0_i_32_n_0 ),
        .I1(\spo[1]_INST_0_i_33_n_0 ),
        .O(\spo[1]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_14 
       (.I0(\spo[1]_INST_0_i_34_n_0 ),
        .I1(\spo[1]_INST_0_i_35_n_0 ),
        .O(\spo[1]_INST_0_i_14_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_15 
       (.I0(\spo[1]_INST_0_i_36_n_0 ),
        .I1(\spo[1]_INST_0_i_37_n_0 ),
        .O(\spo[1]_INST_0_i_15_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h8070FFFF80700000)) 
    \spo[1]_INST_0_i_16 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[1]_INST_0_i_38_n_0 ),
        .O(\spo[1]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBB88888888888)) 
    \spo[1]_INST_0_i_17 
       (.I0(\spo[1]_INST_0_i_39_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_18_n_0 ),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h8830FFFF88300000)) 
    \spo[1]_INST_0_i_18 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[2]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_38_n_0 ),
        .O(\spo[1]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h2F20FFFF2F200000)) 
    \spo[1]_INST_0_i_19 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[1]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_21_n_0 ),
        .I4(a[7]),
        .I5(\spo[1]_INST_0_i_40_n_0 ),
        .O(\spo[1]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[1]_INST_0_i_2 
       (.I0(\spo[1]_INST_0_i_9_n_0 ),
        .I1(\spo[1]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[1]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[1]_INST_0_i_12_n_0 ),
        .O(\spo[1]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hC5C0FFFFC5C00000)) 
    \spo[1]_INST_0_i_20 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[1]),
        .I3(\spo[25]_INST_0_i_21_n_0 ),
        .I4(a[7]),
        .I5(\spo[1]_INST_0_i_41_n_0 ),
        .O(\spo[1]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h000000D000130082)) 
    \spo[1]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[1]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000079901)) 
    \spo[1]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[1]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h00020C0800090100)) 
    \spo[1]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000001500F00040)) 
    \spo[1]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[1]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0002080800020108)) 
    \spo[1]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0000080C0000CB1B)) 
    \spo[1]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[1]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h000002E0000004B4)) 
    \spo[1]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h00000CFC00000CE0)) 
    \spo[1]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000004C00940081)) 
    \spo[1]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[1]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[1]_INST_0_i_3 
       (.I0(\spo[1]_INST_0_i_13_n_0 ),
        .I1(\spo[1]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[1]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[1]_INST_0_i_16_n_0 ),
        .O(\spo[1]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000008200000FC4)) 
    \spo[1]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000040300000480)) 
    \spo[1]_INST_0_i_31 
       (.I0(a[8]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0121020000000000)) 
    \spo[1]_INST_0_i_32 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[1]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000F01000004000A)) 
    \spo[1]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000020000300130)) 
    \spo[1]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h00080A0000020900)) 
    \spo[1]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h00000C6800000C90)) 
    \spo[1]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h0000043000000202)) 
    \spo[1]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000ED00160004)) 
    \spo[1]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[1]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h0008000200070300)) 
    \spo[1]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[1]_INST_0_i_4 
       (.I0(\spo[1]_INST_0_i_17_n_0 ),
        .I1(\spo[1]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[1]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[1]_INST_0_i_20_n_0 ),
        .O(\spo[1]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0033013000000200)) 
    \spo[1]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h0000328000000045)) 
    \spo[1]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[1]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \spo[1]_INST_0_i_5 
       (.I0(\spo[1]_INST_0_i_21_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_34_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[1]),
        .O(\spo[1]_INST_0_i_5_n_0 ));
  MUXF7 \spo[1]_INST_0_i_6 
       (.I0(\spo[1]_INST_0_i_22_n_0 ),
        .I1(\spo[1]_INST_0_i_23_n_0 ),
        .O(\spo[1]_INST_0_i_6_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_7 
       (.I0(\spo[1]_INST_0_i_24_n_0 ),
        .I1(\spo[1]_INST_0_i_25_n_0 ),
        .O(\spo[1]_INST_0_i_7_n_0 ),
        .S(a[7]));
  MUXF7 \spo[1]_INST_0_i_8 
       (.I0(\spo[1]_INST_0_i_26_n_0 ),
        .I1(\spo[1]_INST_0_i_27_n_0 ),
        .O(\spo[1]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hA000A000C0FFC000)) 
    \spo[1]_INST_0_i_9 
       (.I0(\spo[8]_INST_0_i_20_n_0 ),
        .I1(\spo[28]_INST_0_i_24_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .I4(\spo[20]_INST_0_i_25_n_0 ),
        .I5(a[2]),
        .O(\spo[1]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0 
       (.I0(\spo[20]_INST_0_i_1_n_0 ),
        .I1(\spo[20]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[20]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[20]_INST_0_i_4_n_0 ),
        .O(spo[20]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_1 
       (.I0(\spo[20]_INST_0_i_5_n_0 ),
        .I1(\spo[20]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[20]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[20]_INST_0_i_8_n_0 ),
        .O(\spo[20]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0F40004000800080)) 
    \spo[20]_INST_0_i_10 
       (.I0(a[0]),
        .I1(\spo[31]_INST_0_i_28_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[2]),
        .O(\spo[20]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hB88833F3B88800C0)) 
    \spo[20]_INST_0_i_11 
       (.I0(\spo[20]_INST_0_i_26_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[0]),
        .I4(a[2]),
        .I5(\spo[20]_INST_0_i_27_n_0 ),
        .O(\spo[20]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h0800FFFF08000000)) 
    \spo[20]_INST_0_i_12 
       (.I0(a[1]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[0]),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[20]_INST_0_i_28_n_0 ),
        .O(\spo[20]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_13 
       (.I0(\spo[20]_INST_0_i_29_n_0 ),
        .I1(\spo[20]_INST_0_i_30_n_0 ),
        .I2(a[6]),
        .I3(\spo[20]_INST_0_i_31_n_0 ),
        .I4(a[7]),
        .I5(\spo[20]_INST_0_i_32_n_0 ),
        .O(\spo[20]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \spo[20]_INST_0_i_14 
       (.I0(\spo[20]_INST_0_i_33_n_0 ),
        .I1(a[6]),
        .I2(\spo[31]_INST_0_i_17_n_0 ),
        .I3(a[2]),
        .I4(\spo[20]_INST_0_i_34_n_0 ),
        .I5(a[7]),
        .O(\spo[20]_INST_0_i_14_n_0 ));
  MUXF7 \spo[20]_INST_0_i_15 
       (.I0(\spo[20]_INST_0_i_35_n_0 ),
        .I1(\spo[20]_INST_0_i_36_n_0 ),
        .O(\spo[20]_INST_0_i_15_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_16 
       (.I0(\spo[20]_INST_0_i_37_n_0 ),
        .I1(\spo[20]_INST_0_i_38_n_0 ),
        .I2(a[7]),
        .I3(\spo[30]_INST_0_i_13_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_28_n_0 ),
        .O(\spo[20]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hF6FF900011000000)) 
    \spo[20]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_28_n_0 ),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_17_n_0 ));
  MUXF7 \spo[20]_INST_0_i_18 
       (.I0(\spo[20]_INST_0_i_39_n_0 ),
        .I1(\spo[20]_INST_0_i_40_n_0 ),
        .O(\spo[20]_INST_0_i_18_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000004500000080)) 
    \spo[20]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[20]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_2 
       (.I0(\spo[20]_INST_0_i_9_n_0 ),
        .I1(\spo[20]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[20]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[20]_INST_0_i_12_n_0 ),
        .O(\spo[20]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000A000800040200)) 
    \spo[20]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[20]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005C57)) 
    \spo[20]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[20]_INST_0_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00100002)) 
    \spo[20]_INST_0_i_22 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h00040300)) 
    \spo[20]_INST_0_i_23 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[20]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT5 #(
    .INIT(32'h00040008)) 
    \spo[20]_INST_0_i_24 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h00040F00)) 
    \spo[20]_INST_0_i_25 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[20]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00010008)) 
    \spo[20]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h0000050C)) 
    \spo[20]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[20]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h00000000008F0136)) 
    \spo[20]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[20]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000000AC00000003)) 
    \spo[20]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_29_n_0 ));
  MUXF7 \spo[20]_INST_0_i_3 
       (.I0(\spo[20]_INST_0_i_13_n_0 ),
        .I1(\spo[20]_INST_0_i_14_n_0 ),
        .O(\spo[20]_INST_0_i_3_n_0 ),
        .S(a[5]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h00230020)) 
    \spo[20]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h00000007)) 
    \spo[20]_INST_0_i_31 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[20]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000220000003F5F)) 
    \spo[20]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[0]),
        .I3(a[1]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[20]_INST_0_i_32_n_0 ));
  MUXF7 \spo[20]_INST_0_i_33 
       (.I0(\spo[20]_INST_0_i_41_n_0 ),
        .I1(\spo[20]_INST_0_i_42_n_0 ),
        .O(\spo[20]_INST_0_i_33_n_0 ),
        .S(a[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00090000)) 
    \spo[20]_INST_0_i_34 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0005010F00060400)) 
    \spo[20]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000004400000069)) 
    \spo[20]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_36_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT5 #(
    .INIT(32'h00070004)) 
    \spo[20]_INST_0_i_37 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[20]_INST_0_i_37_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h000A0009)) 
    \spo[20]_INST_0_i_38 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[20]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h00000E020000040D)) 
    \spo[20]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_4 
       (.I0(\spo[20]_INST_0_i_15_n_0 ),
        .I1(\spo[20]_INST_0_i_16_n_0 ),
        .I2(a[5]),
        .I3(\spo[20]_INST_0_i_17_n_0 ),
        .I4(a[6]),
        .I5(\spo[20]_INST_0_i_18_n_0 ),
        .O(\spo[20]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000004001000FF)) 
    \spo[20]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[20]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h00000A0200000A04)) 
    \spo[20]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[20]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h0000008D00000090)) 
    \spo[20]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_42_n_0 ));
  MUXF7 \spo[20]_INST_0_i_5 
       (.I0(\spo[20]_INST_0_i_19_n_0 ),
        .I1(\spo[20]_INST_0_i_20_n_0 ),
        .O(\spo[20]_INST_0_i_5_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00E2FFFF00E20000)) 
    \spo[20]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_32_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[20]_INST_0_i_21_n_0 ),
        .O(\spo[20]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h147D0000F40A0000)) 
    \spo[20]_INST_0_i_7 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[20]_INST_0_i_8 
       (.I0(\spo[20]_INST_0_i_22_n_0 ),
        .I1(\spo[30]_INST_0_i_13_n_0 ),
        .I2(a[7]),
        .I3(\spo[24]_INST_0_i_24_n_0 ),
        .I4(a[2]),
        .I5(\spo[20]_INST_0_i_23_n_0 ),
        .O(\spo[20]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFF008F8FFF008080)) 
    \spo[20]_INST_0_i_9 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[1]),
        .I2(a[7]),
        .I3(\spo[20]_INST_0_i_24_n_0 ),
        .I4(a[2]),
        .I5(\spo[20]_INST_0_i_25_n_0 ),
        .O(\spo[20]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0 
       (.I0(\spo[21]_INST_0_i_1_n_0 ),
        .I1(\spo[21]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[21]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[21]_INST_0_i_4_n_0 ),
        .O(spo[21]));
  MUXF7 \spo[21]_INST_0_i_1 
       (.I0(\spo[21]_INST_0_i_5_n_0 ),
        .I1(\spo[21]_INST_0_i_6_n_0 ),
        .O(\spo[21]_INST_0_i_1_n_0 ),
        .S(a[5]));
  MUXF7 \spo[21]_INST_0_i_10 
       (.I0(\spo[21]_INST_0_i_33_n_0 ),
        .I1(\spo[21]_INST_0_i_34_n_0 ),
        .O(\spo[21]_INST_0_i_10_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h6A020000450A0000)) 
    \spo[21]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_12 
       (.I0(\spo[21]_INST_0_i_35_n_0 ),
        .I1(\spo[21]_INST_0_i_36_n_0 ),
        .I2(a[7]),
        .I3(\spo[23]_INST_0_i_18_n_0 ),
        .I4(a[2]),
        .I5(\spo[21]_INST_0_i_37_n_0 ),
        .O(\spo[21]_INST_0_i_12_n_0 ));
  MUXF7 \spo[21]_INST_0_i_13 
       (.I0(\spo[21]_INST_0_i_38_n_0 ),
        .I1(\spo[21]_INST_0_i_39_n_0 ),
        .O(\spo[21]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[21]_INST_0_i_14 
       (.I0(\spo[21]_INST_0_i_40_n_0 ),
        .I1(\spo[21]_INST_0_i_41_n_0 ),
        .O(\spo[21]_INST_0_i_14_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_15 
       (.I0(\spo[21]_INST_0_i_42_n_0 ),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[6]),
        .I3(\spo[21]_INST_0_i_43_n_0 ),
        .I4(a[7]),
        .I5(\spo[21]_INST_0_i_44_n_0 ),
        .O(\spo[21]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000C101D2)) 
    \spo[21]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[21]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h000000F0000000E0)) 
    \spo[21]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000008B8000006AA)) 
    \spo[21]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0010001500000008)) 
    \spo[21]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_19_n_0 ));
  MUXF7 \spo[21]_INST_0_i_2 
       (.I0(\spo[21]_INST_0_i_7_n_0 ),
        .I1(\spo[21]_INST_0_i_8_n_0 ),
        .O(\spo[21]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h000000000058000B)) 
    \spo[21]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h000D010000040800)) 
    \spo[21]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000000D0001100D2)) 
    \spo[21]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000006F00000408)) 
    \spo[21]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0001000000020000)) 
    \spo[21]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[21]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000004600000290)) 
    \spo[21]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0008000000000000)) 
    \spo[21]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[21]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h000000000041001C)) 
    \spo[21]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h00000000007F4100)) 
    \spo[21]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[21]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000009000200027)) 
    \spo[21]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_3 
       (.I0(\spo[21]_INST_0_i_9_n_0 ),
        .I1(\spo[21]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[21]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[21]_INST_0_i_12_n_0 ),
        .O(\spo[21]_INST_0_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h0000001D)) 
    \spo[21]_INST_0_i_30 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[10]),
        .O(\spo[21]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000FF3508)) 
    \spo[21]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[21]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000000B00000030)) 
    \spo[21]_INST_0_i_32 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0003010100020002)) 
    \spo[21]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[21]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000020200009A75)) 
    \spo[21]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[0]),
        .I3(a[1]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_34_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h01300002)) 
    \spo[21]_INST_0_i_35 
       (.I0(a[1]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .O(\spo[21]_INST_0_i_35_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'h0014)) 
    \spo[21]_INST_0_i_36 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .I3(a[0]),
        .O(\spo[21]_INST_0_i_36_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h000C0001)) 
    \spo[21]_INST_0_i_37 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[21]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h00000A1000000840)) 
    \spo[21]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h00000000002300F2)) 
    \spo[21]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_39_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \spo[21]_INST_0_i_4 
       (.I0(\spo[21]_INST_0_i_13_n_0 ),
        .I1(a[6]),
        .I2(\spo[21]_INST_0_i_14_n_0 ),
        .I3(a[5]),
        .I4(\spo[21]_INST_0_i_15_n_0 ),
        .O(\spo[21]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000110010)) 
    \spo[21]_INST_0_i_40 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[21]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h000000770004005A)) 
    \spo[21]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h000000B00001005A)) 
    \spo[21]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000C10000)) 
    \spo[21]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[21]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000603200000000)) 
    \spo[21]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_5 
       (.I0(\spo[21]_INST_0_i_16_n_0 ),
        .I1(\spo[21]_INST_0_i_17_n_0 ),
        .I2(a[6]),
        .I3(\spo[21]_INST_0_i_18_n_0 ),
        .I4(a[7]),
        .I5(\spo[21]_INST_0_i_19_n_0 ),
        .O(\spo[21]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_6 
       (.I0(\spo[21]_INST_0_i_20_n_0 ),
        .I1(\spo[21]_INST_0_i_21_n_0 ),
        .I2(a[6]),
        .I3(\spo[21]_INST_0_i_22_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[21]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_7 
       (.I0(\spo[21]_INST_0_i_23_n_0 ),
        .I1(\spo[21]_INST_0_i_24_n_0 ),
        .I2(a[6]),
        .I3(\spo[21]_INST_0_i_25_n_0 ),
        .I4(a[7]),
        .I5(\spo[21]_INST_0_i_26_n_0 ),
        .O(\spo[21]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0_i_8 
       (.I0(\spo[21]_INST_0_i_27_n_0 ),
        .I1(\spo[21]_INST_0_i_28_n_0 ),
        .I2(a[6]),
        .I3(\spo[21]_INST_0_i_29_n_0 ),
        .I4(a[7]),
        .I5(\spo[21]_INST_0_i_30_n_0 ),
        .O(\spo[21]_INST_0_i_8_n_0 ));
  MUXF7 \spo[21]_INST_0_i_9 
       (.I0(\spo[21]_INST_0_i_31_n_0 ),
        .I1(\spo[21]_INST_0_i_32_n_0 ),
        .O(\spo[21]_INST_0_i_9_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0 
       (.I0(\spo[22]_INST_0_i_1_n_0 ),
        .I1(\spo[22]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[22]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[22]_INST_0_i_4_n_0 ),
        .O(spo[22]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_1 
       (.I0(\spo[22]_INST_0_i_5_n_0 ),
        .I1(\spo[22]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[22]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[22]_INST_0_i_8_n_0 ),
        .O(\spo[22]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8080C0000808FC00)) 
    \spo[22]_INST_0_i_10 
       (.I0(\spo[28]_INST_0_i_24_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[22]_INST_0_i_10_n_0 ));
  MUXF7 \spo[22]_INST_0_i_11 
       (.I0(\spo[22]_INST_0_i_22_n_0 ),
        .I1(\spo[22]_INST_0_i_23_n_0 ),
        .O(\spo[22]_INST_0_i_11_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00B8BB3300B88800)) 
    \spo[22]_INST_0_i_12 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(\spo[22]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(a[2]),
        .I5(\spo[22]_INST_0_i_25_n_0 ),
        .O(\spo[22]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_13 
       (.I0(\spo[22]_INST_0_i_26_n_0 ),
        .I1(\spo[22]_INST_0_i_27_n_0 ),
        .I2(a[6]),
        .I3(\spo[22]_INST_0_i_28_n_0 ),
        .I4(a[7]),
        .I5(\spo[22]_INST_0_i_29_n_0 ),
        .O(\spo[22]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hA0AFA0A0C0C0C0C0)) 
    \spo[22]_INST_0_i_14 
       (.I0(\spo[22]_INST_0_i_30_n_0 ),
        .I1(\spo[22]_INST_0_i_31_n_0 ),
        .I2(a[6]),
        .I3(a[2]),
        .I4(\spo[30]_INST_0_i_13_n_0 ),
        .I5(a[7]),
        .O(\spo[22]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_15 
       (.I0(\spo[22]_INST_0_i_32_n_0 ),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[6]),
        .I3(\spo[24]_INST_0_i_26_n_0 ),
        .I4(a[7]),
        .I5(\spo[22]_INST_0_i_33_n_0 ),
        .O(\spo[22]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_16 
       (.I0(\spo[24]_INST_0_i_28_n_0 ),
        .I1(\spo[22]_INST_0_i_34_n_0 ),
        .I2(a[6]),
        .I3(\spo[22]_INST_0_i_35_n_0 ),
        .I4(a[7]),
        .I5(\spo[22]_INST_0_i_36_n_0 ),
        .O(\spo[22]_INST_0_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h00030400)) 
    \spo[22]_INST_0_i_17 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[22]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00080001)) 
    \spo[22]_INST_0_i_18 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[22]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'h000A0004)) 
    \spo[22]_INST_0_i_19 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[22]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_2 
       (.I0(\spo[22]_INST_0_i_9_n_0 ),
        .I1(\spo[22]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[22]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[22]_INST_0_i_12_n_0 ),
        .O(\spo[22]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00040F00)) 
    \spo[22]_INST_0_i_20 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[22]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT4 #(
    .INIT(16'h0120)) 
    \spo[22]_INST_0_i_21 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[22]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000FF4300)) 
    \spo[22]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[22]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h00000000009000D1)) 
    \spo[22]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[22]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'h0012)) 
    \spo[22]_INST_0_i_24 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[22]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h0020001A)) 
    \spo[22]_INST_0_i_25 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[22]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000004100000020C)) 
    \spo[22]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[22]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000006000FF0000)) 
    \spo[22]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[2]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[22]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000040200000000)) 
    \spo[22]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[22]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000002D800000406)) 
    \spo[22]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[22]_INST_0_i_29_n_0 ));
  MUXF7 \spo[22]_INST_0_i_3 
       (.I0(\spo[22]_INST_0_i_13_n_0 ),
        .I1(\spo[22]_INST_0_i_14_n_0 ),
        .O(\spo[22]_INST_0_i_3_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0005000400000002)) 
    \spo[22]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[22]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h00000014000F0000)) 
    \spo[22]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[22]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000020200000804)) 
    \spo[22]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[22]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0020002200AC0010)) 
    \spo[22]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[22]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000774D00)) 
    \spo[22]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[22]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000000700000018)) 
    \spo[22]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[22]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000800)) 
    \spo[22]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[22]_INST_0_i_36_n_0 ));
  MUXF7 \spo[22]_INST_0_i_4 
       (.I0(\spo[22]_INST_0_i_15_n_0 ),
        .I1(\spo[22]_INST_0_i_16_n_0 ),
        .O(\spo[22]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hA0A0A0A0C0CFC0C0)) 
    \spo[22]_INST_0_i_5 
       (.I0(\spo[22]_INST_0_i_17_n_0 ),
        .I1(\spo[22]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_21_n_0 ),
        .I5(a[2]),
        .O(\spo[22]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h88F0FFFF88F00000)) 
    \spo[22]_INST_0_i_6 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_18_n_0 ),
        .O(\spo[22]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0_i_7 
       (.I0(\spo[22]_INST_0_i_19_n_0 ),
        .I1(\spo[24]_INST_0_i_19_n_0 ),
        .I2(a[7]),
        .I3(\spo[31]_INST_0_i_18_n_0 ),
        .I4(a[2]),
        .I5(\spo[22]_INST_0_i_20_n_0 ),
        .O(\spo[22]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[22]_INST_0_i_8 
       (.I0(\spo[27]_INST_0_i_36_n_0 ),
        .I1(a[1]),
        .I2(\spo[22]_INST_0_i_21_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_21_n_0 ),
        .O(\spo[22]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hB0CCB00031B120A0)) 
    \spo[22]_INST_0_i_9 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[0]),
        .O(\spo[22]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0 
       (.I0(\spo[23]_INST_0_i_1_n_0 ),
        .I1(\spo[23]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[23]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[23]_INST_0_i_4_n_0 ),
        .O(spo[23]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_1 
       (.I0(\spo[23]_INST_0_i_5_n_0 ),
        .I1(\spo[23]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[23]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[23]_INST_0_i_8_n_0 ),
        .O(\spo[23]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000040009)) 
    \spo[23]_INST_0_i_10 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[23]_INST_0_i_10_n_0 ));
  MUXF8 \spo[23]_INST_0_i_11 
       (.I0(\spo[23]_INST_0_i_24_n_0 ),
        .I1(\spo[23]_INST_0_i_25_n_0 ),
        .O(\spo[23]_INST_0_i_11_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h4020FFFF40200000)) 
    \spo[23]_INST_0_i_12 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[23]_INST_0_i_26_n_0 ),
        .O(\spo[23]_INST_0_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h0B080000)) 
    \spo[23]_INST_0_i_13 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_22_n_0 ),
        .I4(a[2]),
        .O(\spo[23]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_14 
       (.I0(\spo[31]_INST_0_i_23_n_0 ),
        .I1(\spo[23]_INST_0_i_27_n_0 ),
        .I2(a[7]),
        .I3(\spo[25]_INST_0_i_20_n_0 ),
        .I4(a[2]),
        .I5(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[23]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hBB30883000000000)) 
    \spo[23]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(\spo[25]_INST_0_i_21_n_0 ),
        .I3(a[1]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[2]),
        .O(\spo[23]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_16 
       (.I0(\spo[23]_INST_0_i_28_n_0 ),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[6]),
        .I3(\spo[25]_INST_0_i_27_n_0 ),
        .I4(a[7]),
        .I5(\spo[23]_INST_0_i_29_n_0 ),
        .O(\spo[23]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_17 
       (.I0(\spo[31]_INST_0_i_26_n_0 ),
        .I1(\spo[23]_INST_0_i_30_n_0 ),
        .I2(a[6]),
        .I3(\spo[23]_INST_0_i_31_n_0 ),
        .I4(a[7]),
        .I5(\spo[23]_INST_0_i_32_n_0 ),
        .O(\spo[23]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \spo[23]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[23]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h02040000)) 
    \spo[23]_INST_0_i_19 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .I4(a[1]),
        .O(\spo[23]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hB888FFFFB8880000)) 
    \spo[23]_INST_0_i_2 
       (.I0(\spo[23]_INST_0_i_9_n_0 ),
        .I1(a[6]),
        .I2(\spo[23]_INST_0_i_10_n_0 ),
        .I3(a[7]),
        .I4(a[5]),
        .I5(\spo[23]_INST_0_i_11_n_0 ),
        .O(\spo[23]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT5 #(
    .INIT(32'h000C0008)) 
    \spo[23]_INST_0_i_20 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[23]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h1100110100000000)) 
    \spo[23]_INST_0_i_21 
       (.I0(a[8]),
        .I1(a[10]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[23]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000040100000020)) 
    \spo[23]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0002090000080000)) 
    \spo[23]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[23]_INST_0_i_23_n_0 ));
  MUXF7 \spo[23]_INST_0_i_24 
       (.I0(\spo[23]_INST_0_i_33_n_0 ),
        .I1(\spo[23]_INST_0_i_34_n_0 ),
        .O(\spo[23]_INST_0_i_24_n_0 ),
        .S(a[7]));
  MUXF7 \spo[23]_INST_0_i_25 
       (.I0(\spo[23]_INST_0_i_35_n_0 ),
        .I1(\spo[23]_INST_0_i_36_n_0 ),
        .O(\spo[23]_INST_0_i_25_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00000C0000000380)) 
    \spo[23]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h00010000)) 
    \spo[23]_INST_0_i_27 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[23]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h000000B000000000)) 
    \spo[23]_INST_0_i_28 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000B800)) 
    \spo[23]_INST_0_i_29 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[23]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_3 
       (.I0(\spo[23]_INST_0_i_12_n_0 ),
        .I1(\spo[23]_INST_0_i_13_n_0 ),
        .I2(a[5]),
        .I3(\spo[23]_INST_0_i_14_n_0 ),
        .I4(a[6]),
        .I5(\spo[23]_INST_0_i_15_n_0 ),
        .O(\spo[23]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000001200D70000)) 
    \spo[23]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[23]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000003000000240)) 
    \spo[23]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200000900)) 
    \spo[23]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[23]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000000C000000010)) 
    \spo[23]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000010000000200)) 
    \spo[23]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[23]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000FF0100)) 
    \spo[23]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[23]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000004900000000)) 
    \spo[23]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_36_n_0 ));
  MUXF7 \spo[23]_INST_0_i_4 
       (.I0(\spo[23]_INST_0_i_16_n_0 ),
        .I1(\spo[23]_INST_0_i_17_n_0 ),
        .O(\spo[23]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[23]_INST_0_i_5 
       (.I0(\spo[28]_INST_0_i_20_n_0 ),
        .I1(\spo[23]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(\spo[23]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(\spo[23]_INST_0_i_20_n_0 ),
        .O(\spo[23]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h3088FFFF30880000)) 
    \spo[23]_INST_0_i_6 
       (.I0(\spo[28]_INST_0_i_32_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_21_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[23]_INST_0_i_21_n_0 ),
        .O(\spo[23]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8830FFFF88300000)) 
    \spo[23]_INST_0_i_7 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_20_n_0 ),
        .O(\spo[23]_INST_0_i_7_n_0 ));
  MUXF7 \spo[23]_INST_0_i_8 
       (.I0(\spo[23]_INST_0_i_22_n_0 ),
        .I1(\spo[23]_INST_0_i_23_n_0 ),
        .O(\spo[23]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hB3B0030383800000)) 
    \spo[23]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[28]_INST_0_i_25_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_20_n_0 ),
        .O(\spo[23]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0 
       (.I0(\spo[24]_INST_0_i_1_n_0 ),
        .I1(\spo[24]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[24]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[24]_INST_0_i_4_n_0 ),
        .O(spo[24]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_1 
       (.I0(\spo[24]_INST_0_i_5_n_0 ),
        .I1(\spo[24]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[24]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[24]_INST_0_i_8_n_0 ),
        .O(\spo[24]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCC002E2200000000)) 
    \spo[24]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_21_n_0 ),
        .I1(a[1]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[24]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC010FFFFC0100000)) 
    \spo[24]_INST_0_i_11 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[0]),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_23_n_0 ),
        .O(\spo[24]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h000000000E04D484)) 
    \spo[24]_INST_0_i_12 
       (.I0(a[0]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[24]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h0B0308000B300800)) 
    \spo[24]_INST_0_i_13 
       (.I0(\spo[28]_INST_0_i_24_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[0]),
        .O(\spo[24]_INST_0_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h45400000)) 
    \spo[24]_INST_0_i_14 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_19_n_0 ),
        .I4(a[7]),
        .O(\spo[24]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hB833B80030003000)) 
    \spo[24]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(\spo[24]_INST_0_i_24_n_0 ),
        .I3(a[2]),
        .I4(\spo[24]_INST_0_i_25_n_0 ),
        .I5(a[1]),
        .O(\spo[24]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_16 
       (.I0(\spo[25]_INST_0_i_26_n_0 ),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[6]),
        .I3(\spo[24]_INST_0_i_26_n_0 ),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_27_n_0 ),
        .O(\spo[24]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_17 
       (.I0(\spo[24]_INST_0_i_28_n_0 ),
        .I1(\spo[25]_INST_0_i_30_n_0 ),
        .I2(a[6]),
        .I3(\spo[24]_INST_0_i_29_n_0 ),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_30_n_0 ),
        .O(\spo[24]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h00000A1400000A40)) 
    \spo[24]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[24]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h00000102)) 
    \spo[24]_INST_0_i_19 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .I4(a[1]),
        .O(\spo[24]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_2 
       (.I0(\spo[24]_INST_0_i_9_n_0 ),
        .I1(\spo[24]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[24]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[24]_INST_0_i_12_n_0 ),
        .O(\spo[24]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00060F00)) 
    \spo[24]_INST_0_i_20 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[24]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000030000000048)) 
    \spo[24]_INST_0_i_21 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[24]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000002C000000070)) 
    \spo[24]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[24]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000005600FF0000)) 
    \spo[24]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[24]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h00000409)) 
    \spo[24]_INST_0_i_24 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[24]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \spo[24]_INST_0_i_25 
       (.I0(a[8]),
        .I1(a[10]),
        .I2(a[0]),
        .O(\spo[24]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000200000)) 
    \spo[24]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[24]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0020002200A40010)) 
    \spo[24]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[24]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h000A0000000B0004)) 
    \spo[24]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[24]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000001D00000018)) 
    \spo[24]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[24]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_3 
       (.I0(\spo[24]_INST_0_i_13_n_0 ),
        .I1(\spo[24]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[25]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[24]_INST_0_i_15_n_0 ),
        .O(\spo[24]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000300000800)) 
    \spo[24]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[24]_INST_0_i_30_n_0 ));
  MUXF7 \spo[24]_INST_0_i_4 
       (.I0(\spo[24]_INST_0_i_16_n_0 ),
        .I1(\spo[24]_INST_0_i_17_n_0 ),
        .O(\spo[24]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0808C80880803000)) 
    \spo[24]_INST_0_i_5 
       (.I0(\spo[28]_INST_0_i_24_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[25]_INST_0_i_14_n_0 ),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[24]_INST_0_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h04FF0400)) 
    \spo[24]_INST_0_i_6 
       (.I0(a[1]),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[24]_INST_0_i_18_n_0 ),
        .O(\spo[24]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[24]_INST_0_i_7 
       (.I0(\spo[30]_INST_0_i_14_n_0 ),
        .I1(\spo[24]_INST_0_i_19_n_0 ),
        .I2(a[7]),
        .I3(\spo[25]_INST_0_i_20_n_0 ),
        .I4(a[2]),
        .I5(\spo[24]_INST_0_i_20_n_0 ),
        .O(\spo[24]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[24]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_25_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[24]_INST_0_i_21_n_0 ),
        .O(\spo[24]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hBBB88B8B8B888888)) 
    \spo[24]_INST_0_i_9 
       (.I0(\spo[24]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[29]_INST_0_i_20_n_0 ),
        .I4(a[1]),
        .I5(\spo[25]_INST_0_i_21_n_0 ),
        .O(\spo[24]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0 
       (.I0(\spo[25]_INST_0_i_1_n_0 ),
        .I1(\spo[25]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[25]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[25]_INST_0_i_4_n_0 ),
        .O(spo[25]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0_i_1 
       (.I0(\spo[25]_INST_0_i_5_n_0 ),
        .I1(\spo[25]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[25]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[25]_INST_0_i_8_n_0 ),
        .O(\spo[25]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h3000C808)) 
    \spo[25]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_21_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_17_n_0 ),
        .I4(a[2]),
        .O(\spo[25]_INST_0_i_10_n_0 ));
  LUT5 #(
    .INIT(32'h08FF0800)) 
    \spo[25]_INST_0_i_11 
       (.I0(a[1]),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[25]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h000000000A00D484)) 
    \spo[25]_INST_0_i_12 
       (.I0(a[0]),
        .I1(\spo[28]_INST_0_i_24_n_0 ),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[2]),
        .I5(a[7]),
        .O(\spo[25]_INST_0_i_12_n_0 ));
  LUT5 #(
    .INIT(32'h03008080)) 
    \spo[25]_INST_0_i_13 
       (.I0(\spo[25]_INST_0_i_22_n_0 ),
        .I1(a[6]),
        .I2(a[2]),
        .I3(\spo[25]_INST_0_i_23_n_0 ),
        .I4(a[7]),
        .O(\spo[25]_INST_0_i_13_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \spo[25]_INST_0_i_14 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .O(\spo[25]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hEE55440050005000)) 
    \spo[25]_INST_0_i_15 
       (.I0(a[7]),
        .I1(\spo[25]_INST_0_i_24_n_0 ),
        .I2(\spo[25]_INST_0_i_25_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0_i_16 
       (.I0(\spo[25]_INST_0_i_26_n_0 ),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[6]),
        .I3(\spo[25]_INST_0_i_27_n_0 ),
        .I4(a[7]),
        .I5(\spo[25]_INST_0_i_28_n_0 ),
        .O(\spo[25]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0_i_17 
       (.I0(\spo[25]_INST_0_i_29_n_0 ),
        .I1(\spo[25]_INST_0_i_30_n_0 ),
        .I2(a[6]),
        .I3(\spo[25]_INST_0_i_31_n_0 ),
        .I4(a[7]),
        .I5(\spo[25]_INST_0_i_32_n_0 ),
        .O(\spo[25]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'h0102)) 
    \spo[25]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[25]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \spo[25]_INST_0_i_19 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .O(\spo[25]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0_i_2 
       (.I0(\spo[25]_INST_0_i_9_n_0 ),
        .I1(\spo[25]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[25]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[25]_INST_0_i_12_n_0 ),
        .O(\spo[25]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h00080F00)) 
    \spo[25]_INST_0_i_20 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[25]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    \spo[25]_INST_0_i_21 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[25]_INST_0_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h00300020)) 
    \spo[25]_INST_0_i_22 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[25]_INST_0_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h00020004)) 
    \spo[25]_INST_0_i_23 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[25]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT4 #(
    .INIT(16'h0302)) 
    \spo[25]_INST_0_i_24 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[25]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT4 #(
    .INIT(16'h0021)) 
    \spo[25]_INST_0_i_25 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[25]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200000004)) 
    \spo[25]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000040000020000)) 
    \spo[25]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000000208040000)) 
    \spo[25]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800000004)) 
    \spo[25]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'h88B8BBBB88B88888)) 
    \spo[25]_INST_0_i_3 
       (.I0(\spo[25]_INST_0_i_13_n_0 ),
        .I1(a[5]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[7]),
        .I4(a[6]),
        .I5(\spo[25]_INST_0_i_15_n_0 ),
        .O(\spo[25]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000571500)) 
    \spo[25]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[25]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h00000061000000A8)) 
    \spo[25]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[25]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \spo[25]_INST_0_i_32 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[25]_INST_0_i_32_n_0 ));
  MUXF7 \spo[25]_INST_0_i_4 
       (.I0(\spo[25]_INST_0_i_16_n_0 ),
        .I1(\spo[25]_INST_0_i_17_n_0 ),
        .O(\spo[25]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0808000033003000)) 
    \spo[25]_INST_0_i_5 
       (.I0(\spo[25]_INST_0_i_14_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(\spo[28]_INST_0_i_24_n_0 ),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[25]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4455440050AA5000)) 
    \spo[25]_INST_0_i_6 
       (.I0(a[7]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(\spo[27]_INST_0_i_25_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F004F4F0F004040)) 
    \spo[25]_INST_0_i_7 
       (.I0(a[1]),
        .I1(\spo[25]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(\spo[25]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .I5(\spo[25]_INST_0_i_20_n_0 ),
        .O(\spo[25]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCC330000B800B800)) 
    \spo[25]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[2]),
        .I4(\spo[25]_INST_0_i_21_n_0 ),
        .I5(a[1]),
        .O(\spo[25]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h0800080054440444)) 
    \spo[25]_INST_0_i_9 
       (.I0(a[7]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[1]),
        .I3(a[0]),
        .I4(\spo[25]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[25]_INST_0_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \spo[26]_INST_0 
       (.I0(\spo[26]_INST_0_i_1_n_0 ),
        .I1(a[3]),
        .I2(\spo[26]_INST_0_i_2_n_0 ),
        .I3(a[4]),
        .I4(\spo[26]_INST_0_i_3_n_0 ),
        .O(spo[26]));
  MUXF7 \spo[26]_INST_0_i_1 
       (.I0(\spo[26]_INST_0_i_4_n_0 ),
        .I1(\spo[26]_INST_0_i_5_n_0 ),
        .O(\spo[26]_INST_0_i_1_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_10 
       (.I0(\spo[26]_INST_0_i_31_n_0 ),
        .I1(\spo[26]_INST_0_i_32_n_0 ),
        .I2(a[6]),
        .I3(\spo[27]_INST_0_i_39_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_33_n_0 ),
        .O(\spo[26]_INST_0_i_10_n_0 ));
  MUXF8 \spo[26]_INST_0_i_11 
       (.I0(\spo[26]_INST_0_i_34_n_0 ),
        .I1(\spo[26]_INST_0_i_35_n_0 ),
        .O(\spo[26]_INST_0_i_11_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h0000040000000027)) 
    \spo[26]_INST_0_i_12 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h0000007000000048)) 
    \spo[26]_INST_0_i_13 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h000000110010006C)) 
    \spo[26]_INST_0_i_14 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[26]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h00140012000A0000)) 
    \spo[26]_INST_0_i_15 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0000080000000100)) 
    \spo[26]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000D91187)) 
    \spo[26]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[26]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000004E800000010)) 
    \spo[26]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h000000400000004F)) 
    \spo[26]_INST_0_i_19 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_19_n_0 ));
  MUXF7 \spo[26]_INST_0_i_2 
       (.I0(\spo[26]_INST_0_i_6_n_0 ),
        .I1(\spo[26]_INST_0_i_7_n_0 ),
        .O(\spo[26]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h000000010000060A)) 
    \spo[26]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040030)) 
    \spo[26]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000400020005010F)) 
    \spo[26]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0002000000010000)) 
    \spo[26]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h000000DF000000C8)) 
    \spo[26]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000024000000407)) 
    \spo[26]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0008000000030006)) 
    \spo[26]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000002800B9001E)) 
    \spo[26]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[26]_INST_0_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h000E0000)) 
    \spo[26]_INST_0_i_28 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[26]_INST_0_i_28_n_0 ));
  MUXF7 \spo[26]_INST_0_i_29 
       (.I0(\spo[26]_INST_0_i_36_n_0 ),
        .I1(\spo[26]_INST_0_i_37_n_0 ),
        .O(\spo[26]_INST_0_i_29_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_3 
       (.I0(\spo[26]_INST_0_i_8_n_0 ),
        .I1(\spo[26]_INST_0_i_9_n_0 ),
        .I2(a[3]),
        .I3(\spo[26]_INST_0_i_10_n_0 ),
        .I4(a[5]),
        .I5(\spo[26]_INST_0_i_11_n_0 ),
        .O(\spo[26]_INST_0_i_3_n_0 ));
  MUXF7 \spo[26]_INST_0_i_30 
       (.I0(\spo[26]_INST_0_i_38_n_0 ),
        .I1(\spo[26]_INST_0_i_39_n_0 ),
        .O(\spo[26]_INST_0_i_30_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00020A000001010F)) 
    \spo[26]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000008F00000080)) 
    \spo[26]_INST_0_i_32 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0000000700000070)) 
    \spo[26]_INST_0_i_33 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_33_n_0 ));
  MUXF7 \spo[26]_INST_0_i_34 
       (.I0(\spo[26]_INST_0_i_40_n_0 ),
        .I1(\spo[26]_INST_0_i_41_n_0 ),
        .O(\spo[26]_INST_0_i_34_n_0 ),
        .S(a[7]));
  MUXF7 \spo[26]_INST_0_i_35 
       (.I0(\spo[26]_INST_0_i_42_n_0 ),
        .I1(\spo[26]_INST_0_i_43_n_0 ),
        .O(\spo[26]_INST_0_i_35_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000000000041101)) 
    \spo[26]_INST_0_i_36 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[26]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h00000C0000030700)) 
    \spo[26]_INST_0_i_37 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h00000015000000F0)) 
    \spo[26]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[26]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h0000006100000040)) 
    \spo[26]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_4 
       (.I0(\spo[26]_INST_0_i_12_n_0 ),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[6]),
        .I3(\spo[26]_INST_0_i_13_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_14_n_0 ),
        .O(\spo[26]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000080A0000090A)) 
    \spo[26]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h0000022001200110)) 
    \spo[26]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[26]_INST_0_i_41_n_0 ));
  LUT5 #(
    .INIT(32'h000F0008)) 
    \spo[26]_INST_0_i_42 
       (.I0(a[8]),
        .I1(a[2]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[0]),
        .O(\spo[26]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h000000B2000000A7)) 
    \spo[26]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[26]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_5 
       (.I0(\spo[26]_INST_0_i_15_n_0 ),
        .I1(\spo[26]_INST_0_i_16_n_0 ),
        .I2(a[6]),
        .I3(\spo[26]_INST_0_i_17_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_18_n_0 ),
        .O(\spo[26]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_6 
       (.I0(\spo[26]_INST_0_i_19_n_0 ),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[6]),
        .I3(\spo[26]_INST_0_i_20_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_21_n_0 ),
        .O(\spo[26]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_7 
       (.I0(\spo[26]_INST_0_i_22_n_0 ),
        .I1(\spo[26]_INST_0_i_23_n_0 ),
        .I2(a[6]),
        .I3(\spo[27]_INST_0_i_29_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_24_n_0 ),
        .O(\spo[26]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0_i_8 
       (.I0(\spo[26]_INST_0_i_25_n_0 ),
        .I1(\spo[26]_INST_0_i_26_n_0 ),
        .I2(a[6]),
        .I3(\spo[26]_INST_0_i_27_n_0 ),
        .I4(a[7]),
        .I5(\spo[26]_INST_0_i_28_n_0 ),
        .O(\spo[26]_INST_0_i_8_n_0 ));
  MUXF8 \spo[26]_INST_0_i_9 
       (.I0(\spo[26]_INST_0_i_29_n_0 ),
        .I1(\spo[26]_INST_0_i_30_n_0 ),
        .O(\spo[26]_INST_0_i_9_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0 
       (.I0(\spo[27]_INST_0_i_1_n_0 ),
        .I1(\spo[27]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[27]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[27]_INST_0_i_4_n_0 ),
        .O(spo[27]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0_i_1 
       (.I0(\spo[27]_INST_0_i_5_n_0 ),
        .I1(\spo[27]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[27]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[27]_INST_0_i_8_n_0 ),
        .O(\spo[27]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \spo[27]_INST_0_i_10 
       (.I0(\spo[27]_INST_0_i_29_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[28]_INST_0_i_32_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_21_n_0 ),
        .O(\spo[27]_INST_0_i_10_n_0 ));
  MUXF7 \spo[27]_INST_0_i_11 
       (.I0(\spo[27]_INST_0_i_30_n_0 ),
        .I1(\spo[27]_INST_0_i_31_n_0 ),
        .O(\spo[27]_INST_0_i_11_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hBB888B8BBB888888)) 
    \spo[27]_INST_0_i_12 
       (.I0(\spo[27]_INST_0_i_32_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_20_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_21_n_0 ),
        .O(\spo[27]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h485A4800DD5A8800)) 
    \spo[27]_INST_0_i_13 
       (.I0(a[7]),
        .I1(\spo[28]_INST_0_i_24_n_0 ),
        .I2(a[2]),
        .I3(a[0]),
        .I4(\spo[31]_INST_0_i_28_n_0 ),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \spo[27]_INST_0_i_14 
       (.I0(\spo[27]_INST_0_i_33_n_0 ),
        .I1(a[7]),
        .I2(\spo[28]_INST_0_i_32_n_0 ),
        .I3(a[1]),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_21_n_0 ),
        .O(\spo[27]_INST_0_i_14_n_0 ));
  MUXF7 \spo[27]_INST_0_i_15 
       (.I0(\spo[27]_INST_0_i_34_n_0 ),
        .I1(\spo[27]_INST_0_i_35_n_0 ),
        .O(\spo[27]_INST_0_i_15_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hA000A00030F530A0)) 
    \spo[27]_INST_0_i_16 
       (.I0(a[7]),
        .I1(a[0]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[2]),
        .I4(\spo[27]_INST_0_i_36_n_0 ),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_16_n_0 ));
  MUXF7 \spo[27]_INST_0_i_17 
       (.I0(\spo[27]_INST_0_i_37_n_0 ),
        .I1(\spo[27]_INST_0_i_38_n_0 ),
        .O(\spo[27]_INST_0_i_17_n_0 ),
        .S(a[7]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \spo[27]_INST_0_i_18 
       (.I0(\spo[27]_INST_0_i_39_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[27]_INST_0_i_40_n_0 ),
        .O(\spo[27]_INST_0_i_18_n_0 ));
  MUXF7 \spo[27]_INST_0_i_19 
       (.I0(\spo[27]_INST_0_i_41_n_0 ),
        .I1(\spo[27]_INST_0_i_42_n_0 ),
        .O(\spo[27]_INST_0_i_19_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0_i_2 
       (.I0(\spo[27]_INST_0_i_9_n_0 ),
        .I1(\spo[27]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[27]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[27]_INST_0_i_12_n_0 ),
        .O(\spo[27]_INST_0_i_2_n_0 ));
  MUXF7 \spo[27]_INST_0_i_20 
       (.I0(\spo[27]_INST_0_i_43_n_0 ),
        .I1(\spo[27]_INST_0_i_44_n_0 ),
        .O(\spo[27]_INST_0_i_20_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000041A00000608)) 
    \spo[27]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h00000EE800000A01)) 
    \spo[27]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200000097)) 
    \spo[27]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00040003)) 
    \spo[27]_INST_0_i_24 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[27]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT4 #(
    .INIT(16'h0032)) 
    \spo[27]_INST_0_i_25 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[27]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h00000015000800DA)) 
    \spo[27]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[27]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h00000070000000C8)) 
    \spo[27]_INST_0_i_27 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h001000820010005F)) 
    \spo[27]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h00000867000000A0)) 
    \spo[27]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0_i_3 
       (.I0(\spo[27]_INST_0_i_13_n_0 ),
        .I1(\spo[27]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[27]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[27]_INST_0_i_16_n_0 ),
        .O(\spo[27]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000000FF000000C8)) 
    \spo[27]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h00020003000A0002)) 
    \spo[27]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000020600000008)) 
    \spo[27]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000002A10000008E)) 
    \spo[27]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000F500F0)) 
    \spo[27]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[27]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h000000810000004A)) 
    \spo[27]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_35_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \spo[27]_INST_0_i_36 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[0]),
        .O(\spo[27]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h00000088003700F0)) 
    \spo[27]_INST_0_i_37 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[27]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000800000004F)) 
    \spo[27]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h00000000009400A7)) 
    \spo[27]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[27]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0_i_4 
       (.I0(\spo[27]_INST_0_i_17_n_0 ),
        .I1(\spo[27]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[27]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[27]_INST_0_i_20_n_0 ),
        .O(\spo[27]_INST_0_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h000F0008)) 
    \spo[27]_INST_0_i_40 
       (.I0(a[9]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[27]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h000000F000F900F0)) 
    \spo[27]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[27]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h0000000C00000047)) 
    \spo[27]_INST_0_i_42 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h0000000A00000407)) 
    \spo[27]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000251500)) 
    \spo[27]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[27]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'hB8888888888B8888)) 
    \spo[27]_INST_0_i_5 
       (.I0(\spo[27]_INST_0_i_21_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(a[0]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_5_n_0 ));
  MUXF7 \spo[27]_INST_0_i_6 
       (.I0(\spo[27]_INST_0_i_22_n_0 ),
        .I1(\spo[27]_INST_0_i_23_n_0 ),
        .O(\spo[27]_INST_0_i_6_n_0 ),
        .S(a[7]));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \spo[27]_INST_0_i_7 
       (.I0(\spo[27]_INST_0_i_24_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_17_n_0 ),
        .I3(a[7]),
        .I4(\spo[27]_INST_0_i_25_n_0 ),
        .O(\spo[27]_INST_0_i_7_n_0 ));
  MUXF7 \spo[27]_INST_0_i_8 
       (.I0(\spo[27]_INST_0_i_26_n_0 ),
        .I1(\spo[27]_INST_0_i_27_n_0 ),
        .O(\spo[27]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h8B88888888BB8888)) 
    \spo[27]_INST_0_i_9 
       (.I0(\spo[27]_INST_0_i_28_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[1]),
        .O(\spo[27]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0 
       (.I0(\spo[28]_INST_0_i_1_n_0 ),
        .I1(\spo[28]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[28]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[28]_INST_0_i_4_n_0 ),
        .O(spo[28]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_1 
       (.I0(\spo[28]_INST_0_i_5_n_0 ),
        .I1(\spo[28]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[28]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[28]_INST_0_i_8_n_0 ),
        .O(\spo[28]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_10 
       (.I0(\spo[28]_INST_0_i_30_n_0 ),
        .I1(\spo[28]_INST_0_i_31_n_0 ),
        .I2(a[7]),
        .I3(\spo[31]_INST_0_i_21_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_32_n_0 ),
        .O(\spo[28]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_11 
       (.I0(\spo[28]_INST_0_i_33_n_0 ),
        .I1(\spo[28]_INST_0_i_27_n_0 ),
        .I2(a[6]),
        .I3(\spo[28]_INST_0_i_34_n_0 ),
        .I4(a[7]),
        .I5(\spo[28]_INST_0_i_35_n_0 ),
        .O(\spo[28]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h74A8302030753020)) 
    \spo[28]_INST_0_i_12 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_17_n_0 ),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8888888888888)) 
    \spo[28]_INST_0_i_13 
       (.I0(\spo[28]_INST_0_i_36_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_14 
       (.I0(\spo[28]_INST_0_i_37_n_0 ),
        .I1(\spo[28]_INST_0_i_38_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_21_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_39_n_0 ),
        .O(\spo[28]_INST_0_i_14_n_0 ));
  MUXF7 \spo[28]_INST_0_i_15 
       (.I0(\spo[28]_INST_0_i_40_n_0 ),
        .I1(\spo[28]_INST_0_i_41_n_0 ),
        .O(\spo[28]_INST_0_i_15_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_16 
       (.I0(\spo[28]_INST_0_i_42_n_0 ),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_38_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_43_n_0 ),
        .O(\spo[28]_INST_0_i_16_n_0 ));
  MUXF7 \spo[28]_INST_0_i_17 
       (.I0(\spo[28]_INST_0_i_44_n_0 ),
        .I1(\spo[28]_INST_0_i_45_n_0 ),
        .O(\spo[28]_INST_0_i_17_n_0 ),
        .S(a[7]));
  MUXF7 \spo[28]_INST_0_i_18 
       (.I0(\spo[28]_INST_0_i_46_n_0 ),
        .I1(\spo[28]_INST_0_i_47_n_0 ),
        .O(\spo[28]_INST_0_i_18_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hB8888B8888888888)) 
    \spo[28]_INST_0_i_19 
       (.I0(\spo[28]_INST_0_i_48_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[28]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h8F80FFFF8F800000)) 
    \spo[28]_INST_0_i_2 
       (.I0(\spo[28]_INST_0_i_9_n_0 ),
        .I1(a[7]),
        .I2(a[6]),
        .I3(\spo[28]_INST_0_i_10_n_0 ),
        .I4(a[5]),
        .I5(\spo[28]_INST_0_i_11_n_0 ),
        .O(\spo[28]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00000021)) 
    \spo[28]_INST_0_i_20 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h00200000)) 
    \spo[28]_INST_0_i_21 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[28]_INST_0_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h00080030)) 
    \spo[28]_INST_0_i_22 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000D91185)) 
    \spo[28]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[28]_INST_0_i_23_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \spo[28]_INST_0_i_24 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .O(\spo[28]_INST_0_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT4 #(
    .INIT(16'h1400)) 
    \spo[28]_INST_0_i_25 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .I3(a[0]),
        .O(\spo[28]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h00380020)) 
    \spo[28]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h00100020)) 
    \spo[28]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT4 #(
    .INIT(16'h0200)) 
    \spo[28]_INST_0_i_28 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[8]),
        .I3(a[1]),
        .O(\spo[28]_INST_0_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h00200006)) 
    \spo[28]_INST_0_i_29 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_3 
       (.I0(\spo[28]_INST_0_i_12_n_0 ),
        .I1(\spo[28]_INST_0_i_13_n_0 ),
        .I2(a[5]),
        .I3(\spo[28]_INST_0_i_14_n_0 ),
        .I4(a[6]),
        .I5(\spo[28]_INST_0_i_15_n_0 ),
        .O(\spo[28]_INST_0_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h00070804)) 
    \spo[28]_INST_0_i_30 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[28]_INST_0_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h000B0000)) 
    \spo[28]_INST_0_i_31 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_31_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \spo[28]_INST_0_i_32 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[0]),
        .O(\spo[28]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800000047)) 
    \spo[28]_INST_0_i_33 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000004200000696)) 
    \spo[28]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000005200000004)) 
    \spo[28]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000B92106)) 
    \spo[28]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[28]_INST_0_i_36_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h00000200)) 
    \spo[28]_INST_0_i_37 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[28]_INST_0_i_37_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT4 #(
    .INIT(16'h0200)) 
    \spo[28]_INST_0_i_38 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[28]_INST_0_i_38_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h00000F70)) 
    \spo[28]_INST_0_i_39 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .O(\spo[28]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_4 
       (.I0(\spo[28]_INST_0_i_16_n_0 ),
        .I1(\spo[28]_INST_0_i_17_n_0 ),
        .I2(a[5]),
        .I3(\spo[28]_INST_0_i_18_n_0 ),
        .I4(a[6]),
        .I5(\spo[28]_INST_0_i_19_n_0 ),
        .O(\spo[28]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000500080092)) 
    \spo[28]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[28]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h00000020001C0024)) 
    \spo[28]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[28]_INST_0_i_41_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h00090002)) 
    \spo[28]_INST_0_i_42 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[28]_INST_0_i_42_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h00000414)) 
    \spo[28]_INST_0_i_43 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[1]),
        .O(\spo[28]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000000700000030)) 
    \spo[28]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h00000000009000A5)) 
    \spo[28]_INST_0_i_45 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[28]_INST_0_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h00000CF000000800)) 
    \spo[28]_INST_0_i_46 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h000000B2000000A5)) 
    \spo[28]_INST_0_i_47 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[28]_INST_0_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h0002020000010800)) 
    \spo[28]_INST_0_i_48 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[28]_INST_0_i_48_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_5 
       (.I0(\spo[30]_INST_0_i_9_n_0 ),
        .I1(\spo[28]_INST_0_i_20_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_21_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_22_n_0 ),
        .O(\spo[28]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \spo[28]_INST_0_i_6 
       (.I0(\spo[28]_INST_0_i_23_n_0 ),
        .I1(a[7]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_25_n_0 ),
        .I5(a[1]),
        .O(\spo[28]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_7 
       (.I0(\spo[30]_INST_0_i_13_n_0 ),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_26_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_27_n_0 ),
        .O(\spo[28]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0_i_8 
       (.I0(\spo[30]_INST_0_i_9_n_0 ),
        .I1(\spo[28]_INST_0_i_28_n_0 ),
        .I2(a[7]),
        .I3(\spo[10]_INST_0_i_6_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_29_n_0 ),
        .O(\spo[28]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h000200820010006F)) 
    \spo[28]_INST_0_i_9 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_9_n_0 ));
  MUXF7 \spo[29]_INST_0 
       (.I0(\spo[29]_INST_0_i_1_n_0 ),
        .I1(\spo[29]_INST_0_i_2_n_0 ),
        .O(spo[29]),
        .S(a[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[29]_INST_0_i_1 
       (.I0(\spo[29]_INST_0_i_3_n_0 ),
        .I1(\spo[29]_INST_0_i_4_n_0 ),
        .I2(a[3]),
        .I3(\spo[29]_INST_0_i_5_n_0 ),
        .I4(a[5]),
        .I5(\spo[29]_INST_0_i_6_n_0 ),
        .O(\spo[29]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h88B8FFFF88B80000)) 
    \spo[29]_INST_0_i_10 
       (.I0(\spo[29]_INST_0_i_30_n_0 ),
        .I1(a[7]),
        .I2(\spo[30]_INST_0_i_18_n_0 ),
        .I3(a[2]),
        .I4(a[6]),
        .I5(\spo[29]_INST_0_i_31_n_0 ),
        .O(\spo[29]_INST_0_i_10_n_0 ));
  MUXF7 \spo[29]_INST_0_i_11 
       (.I0(\spo[29]_INST_0_i_32_n_0 ),
        .I1(\spo[29]_INST_0_i_33_n_0 ),
        .O(\spo[29]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_12 
       (.I0(\spo[29]_INST_0_i_34_n_0 ),
        .I1(\spo[29]_INST_0_i_35_n_0 ),
        .O(\spo[29]_INST_0_i_12_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_13 
       (.I0(\spo[29]_INST_0_i_36_n_0 ),
        .I1(\spo[29]_INST_0_i_37_n_0 ),
        .O(\spo[29]_INST_0_i_13_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_14 
       (.I0(\spo[29]_INST_0_i_38_n_0 ),
        .I1(\spo[29]_INST_0_i_39_n_0 ),
        .O(\spo[29]_INST_0_i_14_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h00000C420000048F)) 
    \spo[29]_INST_0_i_15 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h000A000000010000)) 
    \spo[29]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[29]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000008000D400A7)) 
    \spo[29]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000000FF0094003C)) 
    \spo[29]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0000042A00000627)) 
    \spo[29]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[29]_INST_0_i_2 
       (.I0(\spo[29]_INST_0_i_7_n_0 ),
        .I1(\spo[29]_INST_0_i_8_n_0 ),
        .I2(a[3]),
        .I3(\spo[29]_INST_0_i_9_n_0 ),
        .I4(a[5]),
        .I5(\spo[29]_INST_0_i_10_n_0 ),
        .O(\spo[29]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT4 #(
    .INIT(16'h0230)) 
    \spo[29]_INST_0_i_20 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[29]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h00000000001929FF)) 
    \spo[29]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000444800001A2A)) 
    \spo[29]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_22_n_0 ));
  MUXF7 \spo[29]_INST_0_i_23 
       (.I0(\spo[29]_INST_0_i_40_n_0 ),
        .I1(\spo[29]_INST_0_i_41_n_0 ),
        .O(\spo[29]_INST_0_i_23_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_24 
       (.I0(\spo[29]_INST_0_i_42_n_0 ),
        .I1(\spo[29]_INST_0_i_43_n_0 ),
        .O(\spo[29]_INST_0_i_24_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h000002C800000C07)) 
    \spo[29]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT5 #(
    .INIT(32'h02000000)) 
    \spo[29]_INST_0_i_26 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[29]_INST_0_i_26_n_0 ));
  MUXF7 \spo[29]_INST_0_i_27 
       (.I0(\spo[29]_INST_0_i_44_n_0 ),
        .I1(\spo[29]_INST_0_i_45_n_0 ),
        .O(\spo[29]_INST_0_i_27_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_28 
       (.I0(\spo[29]_INST_0_i_46_n_0 ),
        .I1(\spo[29]_INST_0_i_47_n_0 ),
        .O(\spo[29]_INST_0_i_28_n_0 ),
        .S(a[7]));
  MUXF7 \spo[29]_INST_0_i_29 
       (.I0(\spo[29]_INST_0_i_48_n_0 ),
        .I1(\spo[29]_INST_0_i_49_n_0 ),
        .O(\spo[29]_INST_0_i_29_n_0 ),
        .S(a[7]));
  MUXF8 \spo[29]_INST_0_i_3 
       (.I0(\spo[29]_INST_0_i_11_n_0 ),
        .I1(\spo[29]_INST_0_i_12_n_0 ),
        .O(\spo[29]_INST_0_i_3_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h00000036002B008E)) 
    \spo[29]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_30_n_0 ));
  MUXF7 \spo[29]_INST_0_i_31 
       (.I0(\spo[29]_INST_0_i_50_n_0 ),
        .I1(\spo[29]_INST_0_i_51_n_0 ),
        .O(\spo[29]_INST_0_i_31_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000000000FFFFB2)) 
    \spo[29]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h0000006C0029001E)) 
    \spo[29]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h000000A600000032)) 
    \spo[29]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h000000900000303D)) 
    \spo[29]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h000000000015894D)) 
    \spo[29]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h00000000000D6F5F)) 
    \spo[29]_INST_0_i_37 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000FF0000)) 
    \spo[29]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h00000044009D00DC)) 
    \spo[29]_INST_0_i_39 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_39_n_0 ));
  MUXF8 \spo[29]_INST_0_i_4 
       (.I0(\spo[29]_INST_0_i_13_n_0 ),
        .I1(\spo[29]_INST_0_i_14_n_0 ),
        .O(\spo[29]_INST_0_i_4_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'h0000000000FFE140)) 
    \spo[29]_INST_0_i_40 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000992B2F)) 
    \spo[29]_INST_0_i_41 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h000003080000BF3F)) 
    \spo[29]_INST_0_i_42 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h00000406000005EC)) 
    \spo[29]_INST_0_i_43 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h000000000808969D)) 
    \spo[29]_INST_0_i_44 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005E35)) 
    \spo[29]_INST_0_i_45 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000FFFF38)) 
    \spo[29]_INST_0_i_46 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h000012D700002228)) 
    \spo[29]_INST_0_i_47 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000F1F)) 
    \spo[29]_INST_0_i_48 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_48_n_0 ));
  LUT6 #(
    .INIT(64'h000000700086006B)) 
    \spo[29]_INST_0_i_49 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[29]_INST_0_i_49_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[29]_INST_0_i_5 
       (.I0(\spo[29]_INST_0_i_15_n_0 ),
        .I1(\spo[29]_INST_0_i_16_n_0 ),
        .I2(a[6]),
        .I3(\spo[29]_INST_0_i_17_n_0 ),
        .I4(a[7]),
        .I5(\spo[29]_INST_0_i_18_n_0 ),
        .O(\spo[29]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0030002D000000C2)) 
    \spo[29]_INST_0_i_50 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[29]_INST_0_i_50_n_0 ));
  LUT6 #(
    .INIT(64'h000000000049117F)) 
    \spo[29]_INST_0_i_51 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[10]),
        .O(\spo[29]_INST_0_i_51_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[29]_INST_0_i_6 
       (.I0(\spo[29]_INST_0_i_19_n_0 ),
        .I1(\spo[29]_INST_0_i_20_n_0 ),
        .I2(a[6]),
        .I3(\spo[29]_INST_0_i_21_n_0 ),
        .I4(a[7]),
        .I5(\spo[29]_INST_0_i_22_n_0 ),
        .O(\spo[29]_INST_0_i_6_n_0 ));
  MUXF8 \spo[29]_INST_0_i_7 
       (.I0(\spo[29]_INST_0_i_23_n_0 ),
        .I1(\spo[29]_INST_0_i_24_n_0 ),
        .O(\spo[29]_INST_0_i_7_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hB888FFFFB8880000)) 
    \spo[29]_INST_0_i_8 
       (.I0(\spo[29]_INST_0_i_25_n_0 ),
        .I1(a[7]),
        .I2(\spo[29]_INST_0_i_26_n_0 ),
        .I3(a[2]),
        .I4(a[6]),
        .I5(\spo[29]_INST_0_i_27_n_0 ),
        .O(\spo[29]_INST_0_i_8_n_0 ));
  MUXF8 \spo[29]_INST_0_i_9 
       (.I0(\spo[29]_INST_0_i_28_n_0 ),
        .I1(\spo[29]_INST_0_i_29_n_0 ),
        .O(\spo[29]_INST_0_i_9_n_0 ),
        .S(a[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0 
       (.I0(\spo[2]_INST_0_i_1_n_0 ),
        .I1(\spo[2]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[2]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[2]_INST_0_i_4_n_0 ),
        .O(spo[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_1 
       (.I0(\spo[2]_INST_0_i_5_n_0 ),
        .I1(\spo[2]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[2]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[2]_INST_0_i_8_n_0 ),
        .O(\spo[2]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[2]_INST_0_i_10 
       (.I0(\spo[2]_INST_0_i_27_n_0 ),
        .I1(a[1]),
        .I2(\spo[25]_INST_0_i_21_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[2]_INST_0_i_28_n_0 ),
        .O(\spo[2]_INST_0_i_10_n_0 ));
  MUXF7 \spo[2]_INST_0_i_11 
       (.I0(\spo[2]_INST_0_i_29_n_0 ),
        .I1(\spo[2]_INST_0_i_30_n_0 ),
        .O(\spo[2]_INST_0_i_11_n_0 ),
        .S(a[7]));
  MUXF7 \spo[2]_INST_0_i_12 
       (.I0(\spo[2]_INST_0_i_31_n_0 ),
        .I1(\spo[2]_INST_0_i_32_n_0 ),
        .O(\spo[2]_INST_0_i_12_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0FC000C0A0C0A0C0)) 
    \spo[2]_INST_0_i_13 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[31]_INST_0_i_21_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_25_n_0 ),
        .I5(a[2]),
        .O(\spo[2]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BB8B8B88B888)) 
    \spo[2]_INST_0_i_14 
       (.I0(\spo[2]_INST_0_i_33_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_18_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[2]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h00E2FFFF00E20000)) 
    \spo[2]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[2]_INST_0_i_34_n_0 ),
        .O(\spo[2]_INST_0_i_15_n_0 ));
  MUXF7 \spo[2]_INST_0_i_16 
       (.I0(\spo[2]_INST_0_i_35_n_0 ),
        .I1(\spo[2]_INST_0_i_36_n_0 ),
        .O(\spo[2]_INST_0_i_16_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h33B800B8CCC000C0)) 
    \spo[2]_INST_0_i_17 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_20_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[2]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hB888FFFFB8880000)) 
    \spo[2]_INST_0_i_18 
       (.I0(\spo[2]_INST_0_i_37_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_20_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[6]_INST_0_i_23_n_0 ),
        .O(\spo[2]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_19 
       (.I0(\spo[2]_INST_0_i_38_n_0 ),
        .I1(\spo[28]_INST_0_i_37_n_0 ),
        .I2(a[7]),
        .I3(\spo[2]_INST_0_i_39_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_18_n_0 ),
        .O(\spo[2]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_2 
       (.I0(\spo[2]_INST_0_i_9_n_0 ),
        .I1(\spo[2]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[2]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[2]_INST_0_i_12_n_0 ),
        .O(\spo[2]_INST_0_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \spo[2]_INST_0_i_20 
       (.I0(\spo[9]_INST_0_i_27_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_29_n_0 ),
        .I3(a[2]),
        .I4(\spo[2]_INST_0_i_40_n_0 ),
        .O(\spo[2]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h00020010)) 
    \spo[2]_INST_0_i_21 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[2]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h00000004000004B0)) 
    \spo[2]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h00000000001149A2)) 
    \spo[2]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[2]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h00000A0C00000A00)) 
    \spo[2]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[2]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h00000B82000000CA)) 
    \spo[2]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0000000800000803)) 
    \spo[2]_INST_0_i_26 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[2]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT4 #(
    .INIT(16'h0322)) 
    \spo[2]_INST_0_i_27 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .O(\spo[2]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000060000000690)) 
    \spo[2]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000AB5700)) 
    \spo[2]_INST_0_i_29 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[2]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_3 
       (.I0(\spo[2]_INST_0_i_13_n_0 ),
        .I1(\spo[2]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[2]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[2]_INST_0_i_16_n_0 ),
        .O(\spo[2]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000000000000C9)) 
    \spo[2]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000000200000C12)) 
    \spo[2]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h0000014000000C80)) 
    \spo[2]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h000000C000F90018)) 
    \spo[2]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[2]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h00000000005581C0)) 
    \spo[2]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[2]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h0000008000020097)) 
    \spo[2]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[0]),
        .O(\spo[2]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000A50000)) 
    \spo[2]_INST_0_i_36 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[2]_INST_0_i_36_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00000C01)) 
    \spo[2]_INST_0_i_37 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[2]_INST_0_i_37_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \spo[2]_INST_0_i_38 
       (.I0(a[0]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[2]_INST_0_i_38_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h01020000)) 
    \spo[2]_INST_0_i_39 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .I4(a[1]),
        .O(\spo[2]_INST_0_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_4 
       (.I0(\spo[2]_INST_0_i_17_n_0 ),
        .I1(\spo[2]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[2]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[2]_INST_0_i_20_n_0 ),
        .O(\spo[2]_INST_0_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h00080023)) 
    \spo[2]_INST_0_i_40 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[2]_INST_0_i_40_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0_i_5 
       (.I0(\spo[2]_INST_0_i_21_n_0 ),
        .I1(\spo[28]_INST_0_i_37_n_0 ),
        .I2(a[7]),
        .I3(\spo[30]_INST_0_i_15_n_0 ),
        .I4(a[2]),
        .I5(\spo[23]_INST_0_i_18_n_0 ),
        .O(\spo[2]_INST_0_i_5_n_0 ));
  MUXF7 \spo[2]_INST_0_i_6 
       (.I0(\spo[2]_INST_0_i_22_n_0 ),
        .I1(\spo[2]_INST_0_i_23_n_0 ),
        .O(\spo[2]_INST_0_i_6_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h88B8FFFF88B80000)) 
    \spo[2]_INST_0_i_7 
       (.I0(\spo[9]_INST_0_i_15_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_20_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[2]_INST_0_i_24_n_0 ),
        .O(\spo[2]_INST_0_i_7_n_0 ));
  MUXF7 \spo[2]_INST_0_i_8 
       (.I0(\spo[2]_INST_0_i_25_n_0 ),
        .I1(\spo[2]_INST_0_i_26_n_0 ),
        .O(\spo[2]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h22002200F0FFF000)) 
    \spo[2]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_20_n_0 ),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_29_n_0 ),
        .I3(a[7]),
        .I4(\spo[20]_INST_0_i_25_n_0 ),
        .I5(a[2]),
        .O(\spo[2]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[30]_INST_0 
       (.I0(\spo[30]_INST_0_i_1_n_0 ),
        .I1(\spo[30]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[30]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[30]_INST_0_i_4_n_0 ),
        .O(spo[30]));
  MUXF7 \spo[30]_INST_0_i_1 
       (.I0(\spo[30]_INST_0_i_5_n_0 ),
        .I1(\spo[30]_INST_0_i_6_n_0 ),
        .O(\spo[30]_INST_0_i_1_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000010000080800)) 
    \spo[30]_INST_0_i_10 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[30]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h0000000001001400)) 
    \spo[30]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(\spo[30]_INST_0_i_16_n_0 ),
        .I4(a[0]),
        .I5(a[6]),
        .O(\spo[30]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAF00A00000C000C0)) 
    \spo[30]_INST_0_i_12 
       (.I0(\spo[30]_INST_0_i_9_n_0 ),
        .I1(\spo[30]_INST_0_i_17_n_0 ),
        .I2(a[6]),
        .I3(a[2]),
        .I4(\spo[30]_INST_0_i_18_n_0 ),
        .I5(a[7]),
        .O(\spo[30]_INST_0_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00020000)) 
    \spo[30]_INST_0_i_13 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[30]_INST_0_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00080004)) 
    \spo[30]_INST_0_i_14 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[30]_INST_0_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT5 #(
    .INIT(32'h01000000)) 
    \spo[30]_INST_0_i_15 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[30]_INST_0_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \spo[30]_INST_0_i_16 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .O(\spo[30]_INST_0_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    \spo[30]_INST_0_i_17 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[30]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h00000010)) 
    \spo[30]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[30]_INST_0_i_18_n_0 ));
  MUXF7 \spo[30]_INST_0_i_2 
       (.I0(\spo[30]_INST_0_i_7_n_0 ),
        .I1(\spo[30]_INST_0_i_8_n_0 ),
        .O(\spo[30]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000000055B000B0)) 
    \spo[30]_INST_0_i_3 
       (.I0(a[5]),
        .I1(a[2]),
        .I2(\spo[30]_INST_0_i_9_n_0 ),
        .I3(a[7]),
        .I4(\spo[30]_INST_0_i_10_n_0 ),
        .I5(a[6]),
        .O(\spo[30]_INST_0_i_3_n_0 ));
  MUXF7 \spo[30]_INST_0_i_4 
       (.I0(\spo[30]_INST_0_i_11_n_0 ),
        .I1(\spo[30]_INST_0_i_12_n_0 ),
        .O(\spo[30]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hA080008000000000)) 
    \spo[30]_INST_0_i_5 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_21_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[6]),
        .O(\spo[30]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000001004400)) 
    \spo[30]_INST_0_i_6 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[1]),
        .I5(a[6]),
        .O(\spo[30]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hBB30883000000000)) 
    \spo[30]_INST_0_i_7 
       (.I0(\spo[30]_INST_0_i_13_n_0 ),
        .I1(a[6]),
        .I2(\spo[30]_INST_0_i_14_n_0 ),
        .I3(a[2]),
        .I4(\spo[30]_INST_0_i_15_n_0 ),
        .I5(a[7]),
        .O(\spo[30]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000D0808080)) 
    \spo[30]_INST_0_i_8 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_20_n_0 ),
        .I5(a[6]),
        .O(\spo[30]_INST_0_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \spo[30]_INST_0_i_9 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[30]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[31]_INST_0 
       (.I0(\spo[31]_INST_0_i_1_n_0 ),
        .I1(\spo[31]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[31]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[31]_INST_0_i_4_n_0 ),
        .O(spo[31]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[31]_INST_0_i_1 
       (.I0(\spo[31]_INST_0_i_5_n_0 ),
        .I1(\spo[31]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[31]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[31]_INST_0_i_8_n_0 ),
        .O(\spo[31]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[31]_INST_0_i_10 
       (.I0(\spo[31]_INST_0_i_24_n_0 ),
        .I1(\spo[31]_INST_0_i_25_n_0 ),
        .I2(a[6]),
        .I3(\spo[31]_INST_0_i_26_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_27_n_0 ),
        .O(\spo[31]_INST_0_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h10000080)) 
    \spo[31]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[0]),
        .I4(a[2]),
        .O(\spo[31]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h0D00080004002000)) 
    \spo[31]_INST_0_i_12 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_29_n_0 ),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[31]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h0F004F4F0F004040)) 
    \spo[31]_INST_0_i_13 
       (.I0(a[1]),
        .I1(\spo[31]_INST_0_i_22_n_0 ),
        .I2(a[7]),
        .I3(\spo[25]_INST_0_i_14_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_18_n_0 ),
        .O(\spo[31]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h80808080202F2020)) 
    \spo[31]_INST_0_i_14 
       (.I0(\spo[25]_INST_0_i_14_n_0 ),
        .I1(a[0]),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[31]_INST_0_i_15 
       (.I0(\spo[31]_INST_0_i_30_n_0 ),
        .I1(\spo[31]_INST_0_i_18_n_0 ),
        .I2(a[6]),
        .I3(\spo[31]_INST_0_i_31_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_26_n_0 ),
        .O(\spo[31]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hF088F08833BB0088)) 
    \spo[31]_INST_0_i_16 
       (.I0(\spo[31]_INST_0_i_32_n_0 ),
        .I1(a[6]),
        .I2(\spo[31]_INST_0_i_33_n_0 ),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_34_n_0 ),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \spo[31]_INST_0_i_17 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[31]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'h0034)) 
    \spo[31]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .O(\spo[31]_INST_0_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \spo[31]_INST_0_i_19 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[31]_INST_0_i_19_n_0 ));
  MUXF7 \spo[31]_INST_0_i_2 
       (.I0(\spo[31]_INST_0_i_9_n_0 ),
        .I1(\spo[31]_INST_0_i_10_n_0 ),
        .O(\spo[31]_INST_0_i_2_n_0 ),
        .S(a[5]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT4 #(
    .INIT(16'h0004)) 
    \spo[31]_INST_0_i_20 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[31]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT4 #(
    .INIT(16'h0200)) 
    \spo[31]_INST_0_i_21 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[31]_INST_0_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h0100)) 
    \spo[31]_INST_0_i_22 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .O(\spo[31]_INST_0_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h00040002)) 
    \spo[31]_INST_0_i_23 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[31]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000802)) 
    \spo[31]_INST_0_i_24 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \spo[31]_INST_0_i_25 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h0001000000000000)) 
    \spo[31]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00030004)) 
    \spo[31]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[31]_INST_0_i_27_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \spo[31]_INST_0_i_28 
       (.I0(a[10]),
        .I1(a[9]),
        .I2(a[8]),
        .O(\spo[31]_INST_0_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \spo[31]_INST_0_i_29 
       (.I0(a[9]),
        .I1(a[10]),
        .O(\spo[31]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[31]_INST_0_i_3 
       (.I0(\spo[31]_INST_0_i_11_n_0 ),
        .I1(\spo[31]_INST_0_i_12_n_0 ),
        .I2(a[5]),
        .I3(\spo[31]_INST_0_i_13_n_0 ),
        .I4(a[6]),
        .I5(\spo[31]_INST_0_i_14_n_0 ),
        .O(\spo[31]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \spo[31]_INST_0_i_30 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040100)) 
    \spo[31]_INST_0_i_31 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h00000000001F0000)) 
    \spo[31]_INST_0_i_32 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[31]_INST_0_i_32_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \spo[31]_INST_0_i_33 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[31]_INST_0_i_33_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h00100000)) 
    \spo[31]_INST_0_i_34 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .O(\spo[31]_INST_0_i_34_n_0 ));
  MUXF7 \spo[31]_INST_0_i_4 
       (.I0(\spo[31]_INST_0_i_15_n_0 ),
        .I1(\spo[31]_INST_0_i_16_n_0 ),
        .O(\spo[31]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAA80008000000000)) 
    \spo[31]_INST_0_i_5 
       (.I0(a[1]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[0]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[7]),
        .O(\spo[31]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h30003000B833B800)) 
    \spo[31]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_18_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[31]_INST_0_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h40FF4000)) 
    \spo[31]_INST_0_i_7 
       (.I0(a[1]),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[31]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCC88008833300030)) 
    \spo[31]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_20_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_21_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[2]),
        .O(\spo[31]_INST_0_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hE2220000)) 
    \spo[31]_INST_0_i_9 
       (.I0(\spo[25]_INST_0_i_14_n_0 ),
        .I1(a[7]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_23_n_0 ),
        .I4(a[6]),
        .O(\spo[31]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0 
       (.I0(\spo[3]_INST_0_i_1_n_0 ),
        .I1(\spo[3]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[3]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[3]_INST_0_i_4_n_0 ),
        .O(spo[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0_i_1 
       (.I0(\spo[3]_INST_0_i_5_n_0 ),
        .I1(\spo[3]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[3]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[3]_INST_0_i_8_n_0 ),
        .O(\spo[3]_INST_0_i_1_n_0 ));
  MUXF7 \spo[3]_INST_0_i_10 
       (.I0(\spo[3]_INST_0_i_27_n_0 ),
        .I1(\spo[3]_INST_0_i_28_n_0 ),
        .O(\spo[3]_INST_0_i_10_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hB080808000000C00)) 
    \spo[3]_INST_0_i_11 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[3]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hC5C05555C5C00000)) 
    \spo[3]_INST_0_i_12 
       (.I0(a[7]),
        .I1(\spo[31]_INST_0_i_20_n_0 ),
        .I2(a[2]),
        .I3(\spo[3]_INST_0_i_29_n_0 ),
        .I4(a[1]),
        .I5(\spo[31]_INST_0_i_22_n_0 ),
        .O(\spo[3]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hCA0AC000C055C000)) 
    \spo[3]_INST_0_i_13 
       (.I0(a[7]),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \spo[3]_INST_0_i_14 
       (.I0(\spo[3]_INST_0_i_30_n_0 ),
        .I1(a[7]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[3]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0_i_15 
       (.I0(\spo[18]_INST_0_i_39_n_0 ),
        .I1(\spo[28]_INST_0_i_37_n_0 ),
        .I2(a[7]),
        .I3(\spo[20]_INST_0_i_24_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_18_n_0 ),
        .O(\spo[3]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h8F80FFFF8F800000)) 
    \spo[3]_INST_0_i_16 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[1]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_19_n_0 ),
        .I4(a[7]),
        .I5(\spo[3]_INST_0_i_31_n_0 ),
        .O(\spo[3]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0C0030000000C808)) 
    \spo[3]_INST_0_i_17 
       (.I0(\spo[25]_INST_0_i_14_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[28]_INST_0_i_24_n_0 ),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[3]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[3]_INST_0_i_18 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_25_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[3]_INST_0_i_32_n_0 ),
        .O(\spo[3]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hBB30883088888888)) 
    \spo[3]_INST_0_i_19 
       (.I0(\spo[31]_INST_0_i_21_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_18_n_0 ),
        .I3(a[1]),
        .I4(\spo[3]_INST_0_i_33_n_0 ),
        .I5(a[2]),
        .O(\spo[3]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0_i_2 
       (.I0(\spo[3]_INST_0_i_9_n_0 ),
        .I1(\spo[3]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[3]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[3]_INST_0_i_12_n_0 ),
        .O(\spo[3]_INST_0_i_2_n_0 ));
  MUXF7 \spo[3]_INST_0_i_20 
       (.I0(\spo[3]_INST_0_i_34_n_0 ),
        .I1(\spo[3]_INST_0_i_35_n_0 ),
        .O(\spo[3]_INST_0_i_20_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h0000034000000440)) 
    \spo[3]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0002020000030401)) 
    \spo[3]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[10]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[1]),
        .O(\spo[3]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000512980)) 
    \spo[3]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[3]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000008A000000EB)) 
    \spo[3]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0020000000340001)) 
    \spo[3]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[3]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h00000512)) 
    \spo[3]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .O(\spo[3]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h00000032005F0020)) 
    \spo[3]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[3]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0008080000060000)) 
    \spo[3]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[3]_INST_0_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT4 #(
    .INIT(16'h0403)) 
    \spo[3]_INST_0_i_29 
       (.I0(a[9]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[8]),
        .O(\spo[3]_INST_0_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0_i_3 
       (.I0(\spo[3]_INST_0_i_13_n_0 ),
        .I1(\spo[3]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[3]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[3]_INST_0_i_16_n_0 ),
        .O(\spo[3]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000798100)) 
    \spo[3]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[3]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000004500020012)) 
    \spo[3]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[3]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h000000FB006000FC)) 
    \spo[3]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[3]_INST_0_i_32_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT4 #(
    .INIT(16'h0036)) 
    \spo[3]_INST_0_i_33 
       (.I0(a[0]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .O(\spo[3]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0020007000240001)) 
    \spo[3]_INST_0_i_34 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[3]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h00000500000000E0)) 
    \spo[3]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0_i_4 
       (.I0(\spo[3]_INST_0_i_17_n_0 ),
        .I1(\spo[3]_INST_0_i_18_n_0 ),
        .I2(a[5]),
        .I3(\spo[3]_INST_0_i_19_n_0 ),
        .I4(a[6]),
        .I5(\spo[3]_INST_0_i_20_n_0 ),
        .O(\spo[3]_INST_0_i_4_n_0 ));
  MUXF7 \spo[3]_INST_0_i_5 
       (.I0(\spo[3]_INST_0_i_21_n_0 ),
        .I1(\spo[3]_INST_0_i_22_n_0 ),
        .O(\spo[3]_INST_0_i_5_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h88888888B8BBB888)) 
    \spo[3]_INST_0_i_6 
       (.I0(\spo[3]_INST_0_i_23_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[27]_INST_0_i_36_n_0 ),
        .I5(a[1]),
        .O(\spo[3]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hC0B8FFFFC0B80000)) 
    \spo[3]_INST_0_i_7 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[3]_INST_0_i_7_n_0 ));
  MUXF7 \spo[3]_INST_0_i_8 
       (.I0(\spo[3]_INST_0_i_24_n_0 ),
        .I1(\spo[3]_INST_0_i_25_n_0 ),
        .O(\spo[3]_INST_0_i_8_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h88338800B8CC8800)) 
    \spo[3]_INST_0_i_9 
       (.I0(\spo[3]_INST_0_i_26_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0 
       (.I0(\spo[4]_INST_0_i_1_n_0 ),
        .I1(\spo[4]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[4]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[4]_INST_0_i_4_n_0 ),
        .O(spo[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_1 
       (.I0(\spo[4]_INST_0_i_5_n_0 ),
        .I1(\spo[4]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[4]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[4]_INST_0_i_8_n_0 ),
        .O(\spo[4]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCFA0C0A000000000)) 
    \spo[4]_INST_0_i_10 
       (.I0(\spo[22]_INST_0_i_21_n_0 ),
        .I1(\spo[25]_INST_0_i_21_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[4]_INST_0_i_21_n_0 ),
        .I5(a[2]),
        .O(\spo[4]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h5500212155000000)) 
    \spo[4]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[0]),
        .I5(\spo[25]_INST_0_i_14_n_0 ),
        .O(\spo[4]_INST_0_i_11_n_0 ));
  MUXF7 \spo[4]_INST_0_i_12 
       (.I0(\spo[4]_INST_0_i_22_n_0 ),
        .I1(\spo[4]_INST_0_i_23_n_0 ),
        .O(\spo[4]_INST_0_i_12_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_13 
       (.I0(\spo[4]_INST_0_i_24_n_0 ),
        .I1(\spo[4]_INST_0_i_25_n_0 ),
        .I2(a[6]),
        .I3(\spo[4]_INST_0_i_26_n_0 ),
        .I4(a[7]),
        .I5(\spo[4]_INST_0_i_27_n_0 ),
        .O(\spo[4]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_14 
       (.I0(\spo[31]_INST_0_i_23_n_0 ),
        .I1(\spo[9]_INST_0_i_20_n_0 ),
        .I2(a[6]),
        .I3(\spo[9]_INST_0_i_25_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_25_n_0 ),
        .O(\spo[4]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_15 
       (.I0(\spo[28]_INST_0_i_37_n_0 ),
        .I1(\spo[12]_INST_0_i_17_n_0 ),
        .I2(a[7]),
        .I3(\spo[4]_INST_0_i_28_n_0 ),
        .I4(a[2]),
        .I5(\spo[4]_INST_0_i_29_n_0 ),
        .O(\spo[4]_INST_0_i_15_n_0 ));
  MUXF7 \spo[4]_INST_0_i_16 
       (.I0(\spo[4]_INST_0_i_30_n_0 ),
        .I1(\spo[4]_INST_0_i_31_n_0 ),
        .O(\spo[4]_INST_0_i_16_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h4F0040000F4F0040)) 
    \spo[4]_INST_0_i_17 
       (.I0(a[0]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[1]),
        .O(\spo[4]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hE200FFFFE2000000)) 
    \spo[4]_INST_0_i_18 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[1]),
        .I2(\spo[31]_INST_0_i_19_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[4]_INST_0_i_32_n_0 ),
        .O(\spo[4]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0000010400001A51)) 
    \spo[4]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[4]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_2 
       (.I0(\spo[4]_INST_0_i_9_n_0 ),
        .I1(\spo[4]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[4]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[4]_INST_0_i_12_n_0 ),
        .O(\spo[4]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000114922)) 
    \spo[4]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[4]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT4 #(
    .INIT(16'h000B)) 
    \spo[4]_INST_0_i_21 
       (.I0(a[9]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[8]),
        .O(\spo[4]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000031000000002)) 
    \spo[4]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[4]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h000B010000060804)) 
    \spo[4]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[4]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0008000000000204)) 
    \spo[4]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[4]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h00000A4700000A20)) 
    \spo[4]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[4]_INST_0_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'h0008000C)) 
    \spo[4]_INST_0_i_26 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[4]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002027837)) 
    \spo[4]_INST_0_i_27 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[0]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[4]_INST_0_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h00020104)) 
    \spo[4]_INST_0_i_28 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[4]_INST_0_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h00000F04)) 
    \spo[4]_INST_0_i_29 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[4]_INST_0_i_29_n_0 ));
  MUXF7 \spo[4]_INST_0_i_3 
       (.I0(\spo[4]_INST_0_i_13_n_0 ),
        .I1(\spo[4]_INST_0_i_14_n_0 ),
        .O(\spo[4]_INST_0_i_3_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000001F000000FC)) 
    \spo[4]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[4]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0008090000000002)) 
    \spo[4]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[4]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h00000AE2000004A1)) 
    \spo[4]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[4]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[4]_INST_0_i_4 
       (.I0(\spo[4]_INST_0_i_15_n_0 ),
        .I1(\spo[4]_INST_0_i_16_n_0 ),
        .I2(a[5]),
        .I3(\spo[4]_INST_0_i_17_n_0 ),
        .I4(a[6]),
        .I5(\spo[4]_INST_0_i_18_n_0 ),
        .O(\spo[4]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000030113000)) 
    \spo[4]_INST_0_i_5 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(\spo[28]_INST_0_i_24_n_0 ),
        .I3(a[0]),
        .I4(\spo[25]_INST_0_i_14_n_0 ),
        .I5(a[2]),
        .O(\spo[4]_INST_0_i_5_n_0 ));
  MUXF7 \spo[4]_INST_0_i_6 
       (.I0(\spo[4]_INST_0_i_19_n_0 ),
        .I1(\spo[4]_INST_0_i_20_n_0 ),
        .O(\spo[4]_INST_0_i_6_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h88008800B8FFB800)) 
    \spo[4]_INST_0_i_7 
       (.I0(\spo[9]_INST_0_i_15_n_0 ),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_20_n_0 ),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[1]),
        .O(\spo[4]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h40500040A000A020)) 
    \spo[4]_INST_0_i_8 
       (.I0(a[7]),
        .I1(a[0]),
        .I2(\spo[31]_INST_0_i_29_n_0 ),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[4]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h0FA000A0C000C000)) 
    \spo[4]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[25]_INST_0_i_25_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[4]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0 
       (.I0(\spo[5]_INST_0_i_1_n_0 ),
        .I1(\spo[5]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[5]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[5]_INST_0_i_4_n_0 ),
        .O(spo[5]));
  MUXF7 \spo[5]_INST_0_i_1 
       (.I0(\spo[5]_INST_0_i_5_n_0 ),
        .I1(\spo[5]_INST_0_i_6_n_0 ),
        .O(\spo[5]_INST_0_i_1_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_10 
       (.I0(\spo[30]_INST_0_i_13_n_0 ),
        .I1(\spo[23]_INST_0_i_18_n_0 ),
        .I2(a[7]),
        .I3(\spo[22]_INST_0_i_18_n_0 ),
        .I4(a[2]),
        .I5(\spo[31]_INST_0_i_27_n_0 ),
        .O(\spo[5]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_11 
       (.I0(\spo[5]_INST_0_i_26_n_0 ),
        .I1(\spo[5]_INST_0_i_27_n_0 ),
        .I2(a[6]),
        .I3(\spo[31]_INST_0_i_25_n_0 ),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_28_n_0 ),
        .O(\spo[5]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_12 
       (.I0(\spo[5]_INST_0_i_29_n_0 ),
        .I1(\spo[5]_INST_0_i_30_n_0 ),
        .I2(a[6]),
        .I3(\spo[5]_INST_0_i_31_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_25_n_0 ),
        .O(\spo[5]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_13 
       (.I0(\spo[5]_INST_0_i_32_n_0 ),
        .I1(\spo[30]_INST_0_i_9_n_0 ),
        .I2(a[6]),
        .I3(\spo[5]_INST_0_i_33_n_0 ),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_34_n_0 ),
        .O(\spo[5]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_14 
       (.I0(\spo[5]_INST_0_i_35_n_0 ),
        .I1(\spo[5]_INST_0_i_36_n_0 ),
        .I2(a[6]),
        .I3(\spo[5]_INST_0_i_37_n_0 ),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_38_n_0 ),
        .O(\spo[5]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h0000000400810070)) 
    \spo[5]_INST_0_i_15 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h000000AA00180027)) 
    \spo[5]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[1]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h00000084002100BA)) 
    \spo[5]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000001E800000202)) 
    \spo[5]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[5]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0008020000010000)) 
    \spo[5]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[5]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_2 
       (.I0(\spo[5]_INST_0_i_7_n_0 ),
        .I1(\spo[5]_INST_0_i_8_n_0 ),
        .I2(a[5]),
        .I3(\spo[5]_INST_0_i_9_n_0 ),
        .I4(a[6]),
        .I5(\spo[5]_INST_0_i_10_n_0 ),
        .O(\spo[5]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000910D52)) 
    \spo[5]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[5]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \spo[5]_INST_0_i_21 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[5]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000003800FF0000)) 
    \spo[5]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000000F00000098)) 
    \spo[5]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT4 #(
    .INIT(16'h0043)) 
    \spo[5]_INST_0_i_24 
       (.I0(a[8]),
        .I1(a[0]),
        .I2(a[9]),
        .I3(a[10]),
        .O(\spo[5]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000109700002060)) 
    \spo[5]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[9]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[5]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000004000000022B)) 
    \spo[5]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[5]_INST_0_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h0000004700000080)) 
    \spo[5]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[5]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h000000990010000C)) 
    \spo[5]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h0040000400000030)) 
    \spo[5]_INST_0_i_29 
       (.I0(a[9]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[5]_INST_0_i_29_n_0 ));
  MUXF7 \spo[5]_INST_0_i_3 
       (.I0(\spo[5]_INST_0_i_11_n_0 ),
        .I1(\spo[5]_INST_0_i_12_n_0 ),
        .O(\spo[5]_INST_0_i_3_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0000001800FF0018)) 
    \spo[5]_INST_0_i_30 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h0000080200002791)) 
    \spo[5]_INST_0_i_31 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[10]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h000000000029095A)) 
    \spo[5]_INST_0_i_32 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[5]_INST_0_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h00000B00000000C0)) 
    \spo[5]_INST_0_i_33 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[5]_INST_0_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002000001)) 
    \spo[5]_INST_0_i_34 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[5]_INST_0_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h00000022000300D2)) 
    \spo[5]_INST_0_i_35 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h0000007F00C80070)) 
    \spo[5]_INST_0_i_36 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h000000FF0080003C)) 
    \spo[5]_INST_0_i_37 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[5]_INST_0_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h000000000041D3FC)) 
    \spo[5]_INST_0_i_38 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[8]),
        .I4(a[9]),
        .I5(a[10]),
        .O(\spo[5]_INST_0_i_38_n_0 ));
  MUXF7 \spo[5]_INST_0_i_4 
       (.I0(\spo[5]_INST_0_i_13_n_0 ),
        .I1(\spo[5]_INST_0_i_14_n_0 ),
        .O(\spo[5]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_5 
       (.I0(\spo[5]_INST_0_i_15_n_0 ),
        .I1(\spo[26]_INST_0_i_24_n_0 ),
        .I2(a[6]),
        .I3(\spo[5]_INST_0_i_16_n_0 ),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_17_n_0 ),
        .O(\spo[5]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0_i_6 
       (.I0(\spo[5]_INST_0_i_18_n_0 ),
        .I1(\spo[5]_INST_0_i_19_n_0 ),
        .I2(a[6]),
        .I3(\spo[5]_INST_0_i_20_n_0 ),
        .I4(a[7]),
        .I5(\spo[5]_INST_0_i_21_n_0 ),
        .O(\spo[5]_INST_0_i_6_n_0 ));
  MUXF7 \spo[5]_INST_0_i_7 
       (.I0(\spo[5]_INST_0_i_22_n_0 ),
        .I1(\spo[5]_INST_0_i_23_n_0 ),
        .O(\spo[5]_INST_0_i_7_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'hAF00A000CFFFC000)) 
    \spo[5]_INST_0_i_8 
       (.I0(\spo[18]_INST_0_i_23_n_0 ),
        .I1(\spo[5]_INST_0_i_24_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[1]),
        .O(\spo[5]_INST_0_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h8BBB8888)) 
    \spo[5]_INST_0_i_9 
       (.I0(\spo[5]_INST_0_i_25_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .O(\spo[5]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0 
       (.I0(\spo[6]_INST_0_i_1_n_0 ),
        .I1(\spo[6]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[6]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[6]_INST_0_i_4_n_0 ),
        .O(spo[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_1 
       (.I0(\spo[6]_INST_0_i_5_n_0 ),
        .I1(\spo[6]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(\spo[6]_INST_0_i_7_n_0 ),
        .I4(a[6]),
        .I5(\spo[6]_INST_0_i_8_n_0 ),
        .O(\spo[6]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD500FFFF80000000)) 
    \spo[6]_INST_0_i_10 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[6]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h4800480040005000)) 
    \spo[6]_INST_0_i_11 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_29_n_0 ),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[6]_INST_0_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h0000B080)) 
    \spo[6]_INST_0_i_12 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[31]_INST_0_i_19_n_0 ),
        .I4(a[2]),
        .O(\spo[6]_INST_0_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h06001800)) 
    \spo[6]_INST_0_i_13 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[1]),
        .O(\spo[6]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h88B8FFFF88B80000)) 
    \spo[6]_INST_0_i_14 
       (.I0(\spo[6]_INST_0_i_20_n_0 ),
        .I1(a[2]),
        .I2(\spo[27]_INST_0_i_25_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[6]_INST_0_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h9780250517002000)) 
    \spo[6]_INST_0_i_15 
       (.I0(a[7]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[0]),
        .I5(\spo[28]_INST_0_i_24_n_0 ),
        .O(\spo[6]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_16 
       (.I0(\spo[31]_INST_0_i_30_n_0 ),
        .I1(\spo[31]_INST_0_i_27_n_0 ),
        .I2(a[6]),
        .I3(\spo[6]_INST_0_i_21_n_0 ),
        .I4(a[7]),
        .I5(\spo[7]_INST_0_i_19_n_0 ),
        .O(\spo[6]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_17 
       (.I0(\spo[7]_INST_0_i_20_n_0 ),
        .I1(\spo[6]_INST_0_i_22_n_0 ),
        .I2(a[6]),
        .I3(\spo[7]_INST_0_i_22_n_0 ),
        .I4(a[7]),
        .I5(\spo[6]_INST_0_i_23_n_0 ),
        .O(\spo[6]_INST_0_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00080007)) 
    \spo[6]_INST_0_i_18 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .O(\spo[6]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h04010000)) 
    \spo[6]_INST_0_i_19 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[0]),
        .I4(a[1]),
        .O(\spo[6]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_2 
       (.I0(\spo[6]_INST_0_i_9_n_0 ),
        .I1(\spo[6]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[6]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[6]_INST_0_i_12_n_0 ),
        .O(\spo[6]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h00380022)) 
    \spo[6]_INST_0_i_20 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[6]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h00000100000000C0)) 
    \spo[6]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[6]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h000200000000000C)) 
    \spo[6]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[6]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h000000BD0040003C)) 
    \spo[6]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[6]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_3 
       (.I0(\spo[6]_INST_0_i_13_n_0 ),
        .I1(\spo[6]_INST_0_i_14_n_0 ),
        .I2(a[5]),
        .I3(\spo[6]_INST_0_i_15_n_0 ),
        .I4(a[6]),
        .I5(\spo[7]_INST_0_i_12_n_0 ),
        .O(\spo[6]_INST_0_i_3_n_0 ));
  MUXF7 \spo[6]_INST_0_i_4 
       (.I0(\spo[6]_INST_0_i_16_n_0 ),
        .I1(\spo[6]_INST_0_i_17_n_0 ),
        .O(\spo[6]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h80808C8003000000)) 
    \spo[6]_INST_0_i_5 
       (.I0(\spo[31]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[25]_INST_0_i_14_n_0 ),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[6]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFF000000AFCFA0C0)) 
    \spo[6]_INST_0_i_6 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[21]_INST_0_i_36_n_0 ),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[6]_INST_0_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h0000B800)) 
    \spo[6]_INST_0_i_7 
       (.I0(a[2]),
        .I1(a[7]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_28_n_0 ),
        .I4(a[1]),
        .O(\spo[6]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h30333000B800B800)) 
    \spo[6]_INST_0_i_8 
       (.I0(\spo[25]_INST_0_i_21_n_0 ),
        .I1(a[7]),
        .I2(\spo[6]_INST_0_i_18_n_0 ),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[6]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0_i_9 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[6]_INST_0_i_19_n_0 ),
        .I2(a[7]),
        .I3(\spo[30]_INST_0_i_15_n_0 ),
        .I4(a[2]),
        .I5(\spo[28]_INST_0_i_37_n_0 ),
        .O(\spo[6]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[7]_INST_0 
       (.I0(\spo[7]_INST_0_i_1_n_0 ),
        .I1(\spo[7]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[7]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[7]_INST_0_i_4_n_0 ),
        .O(spo[7]));
  MUXF7 \spo[7]_INST_0_i_1 
       (.I0(\spo[7]_INST_0_i_5_n_0 ),
        .I1(\spo[7]_INST_0_i_6_n_0 ),
        .O(\spo[7]_INST_0_i_1_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h88888888888888B8)) 
    \spo[7]_INST_0_i_10 
       (.I0(\spo[7]_INST_0_i_18_n_0 ),
        .I1(a[7]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[7]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hE008400808550800)) 
    \spo[7]_INST_0_i_11 
       (.I0(a[7]),
        .I1(\spo[31]_INST_0_i_28_n_0 ),
        .I2(a[1]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[7]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h88888888BBB888B8)) 
    \spo[7]_INST_0_i_12 
       (.I0(\spo[9]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(\spo[8]_INST_0_i_20_n_0 ),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_17_n_0 ),
        .I5(a[2]),
        .O(\spo[7]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[7]_INST_0_i_13 
       (.I0(\spo[31]_INST_0_i_30_n_0 ),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[6]),
        .I3(\spo[10]_INST_0_i_16_n_0 ),
        .I4(a[7]),
        .I5(\spo[7]_INST_0_i_19_n_0 ),
        .O(\spo[7]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[7]_INST_0_i_14 
       (.I0(\spo[7]_INST_0_i_20_n_0 ),
        .I1(\spo[7]_INST_0_i_21_n_0 ),
        .I2(a[6]),
        .I3(\spo[7]_INST_0_i_22_n_0 ),
        .I4(a[7]),
        .I5(\spo[7]_INST_0_i_23_n_0 ),
        .O(\spo[7]_INST_0_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \spo[7]_INST_0_i_15 
       (.I0(a[8]),
        .I1(a[9]),
        .I2(a[10]),
        .I3(a[1]),
        .O(\spo[7]_INST_0_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h0002000C)) 
    \spo[7]_INST_0_i_16 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[7]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000002000000112)) 
    \spo[7]_INST_0_i_17 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h0002002200210010)) 
    \spo[7]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h0004000000000008)) 
    \spo[7]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_19_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \spo[7]_INST_0_i_2 
       (.I0(\spo[9]_INST_0_i_8_n_0 ),
        .I1(a[5]),
        .I2(\spo[7]_INST_0_i_7_n_0 ),
        .I3(a[6]),
        .I4(\spo[7]_INST_0_i_8_n_0 ),
        .O(\spo[7]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000102)) 
    \spo[7]_INST_0_i_20 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0002000400000000)) 
    \spo[7]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0000090000000002)) 
    \spo[7]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h000000FB0000003C)) 
    \spo[7]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[7]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[7]_INST_0_i_3 
       (.I0(\spo[7]_INST_0_i_9_n_0 ),
        .I1(\spo[7]_INST_0_i_10_n_0 ),
        .I2(a[5]),
        .I3(\spo[7]_INST_0_i_11_n_0 ),
        .I4(a[6]),
        .I5(\spo[7]_INST_0_i_12_n_0 ),
        .O(\spo[7]_INST_0_i_3_n_0 ));
  MUXF7 \spo[7]_INST_0_i_4 
       (.I0(\spo[7]_INST_0_i_13_n_0 ),
        .I1(\spo[7]_INST_0_i_14_n_0 ),
        .O(\spo[7]_INST_0_i_4_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hA000A000CF00C000)) 
    \spo[7]_INST_0_i_5 
       (.I0(\spo[7]_INST_0_i_15_n_0 ),
        .I1(\spo[30]_INST_0_i_13_n_0 ),
        .I2(a[6]),
        .I3(a[2]),
        .I4(\spo[28]_INST_0_i_42_n_0 ),
        .I5(a[7]),
        .O(\spo[7]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFE200E2)) 
    \spo[7]_INST_0_i_6 
       (.I0(\spo[30]_INST_0_i_17_n_0 ),
        .I1(a[2]),
        .I2(\spo[7]_INST_0_i_16_n_0 ),
        .I3(a[7]),
        .I4(\spo[7]_INST_0_i_17_n_0 ),
        .I5(a[6]),
        .O(\spo[7]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4400580000000000)) 
    \spo[7]_INST_0_i_7 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_29_n_0 ),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[7]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hA000A000CF00C000)) 
    \spo[7]_INST_0_i_8 
       (.I0(\spo[31]_INST_0_i_20_n_0 ),
        .I1(\spo[31]_INST_0_i_17_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[7]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h80408040400F4000)) 
    \spo[7]_INST_0_i_9 
       (.I0(a[0]),
        .I1(\spo[31]_INST_0_i_28_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[7]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[8]_INST_0 
       (.I0(\spo[8]_INST_0_i_1_n_0 ),
        .I1(\spo[8]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[8]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[8]_INST_0_i_4_n_0 ),
        .O(spo[8]));
  LUT6 #(
    .INIT(64'h00A000A0C0CFC0C0)) 
    \spo[8]_INST_0_i_1 
       (.I0(\spo[8]_INST_0_i_5_n_0 ),
        .I1(\spo[9]_INST_0_i_6_n_0 ),
        .I2(a[5]),
        .I3(a[7]),
        .I4(\spo[8]_INST_0_i_6_n_0 ),
        .I5(a[6]),
        .O(\spo[8]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h0040)) 
    \spo[8]_INST_0_i_10 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[1]),
        .I3(a[7]),
        .O(\spo[8]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h8F800F0F8F800000)) 
    \spo[8]_INST_0_i_11 
       (.I0(a[2]),
        .I1(\spo[31]_INST_0_i_33_n_0 ),
        .I2(a[6]),
        .I3(\spo[8]_INST_0_i_18_n_0 ),
        .I4(a[7]),
        .I5(\spo[8]_INST_0_i_19_n_0 ),
        .O(\spo[8]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hD800500033110000)) 
    \spo[8]_INST_0_i_12 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(\spo[31]_INST_0_i_28_n_0 ),
        .I3(a[1]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[8]_INST_0_i_12_n_0 ));
  LUT5 #(
    .INIT(32'h88888B88)) 
    \spo[8]_INST_0_i_13 
       (.I0(\spo[9]_INST_0_i_22_n_0 ),
        .I1(a[7]),
        .I2(a[1]),
        .I3(\spo[8]_INST_0_i_20_n_0 ),
        .I4(a[2]),
        .O(\spo[8]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h0FA000A000C000C0)) 
    \spo[8]_INST_0_i_14 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[31]_INST_0_i_20_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[25]_INST_0_i_18_n_0 ),
        .I5(a[2]),
        .O(\spo[8]_INST_0_i_14_n_0 ));
  MUXF7 \spo[8]_INST_0_i_15 
       (.I0(\spo[8]_INST_0_i_21_n_0 ),
        .I1(\spo[8]_INST_0_i_22_n_0 ),
        .O(\spo[8]_INST_0_i_15_n_0 ),
        .S(a[7]));
  LUT6 #(
    .INIT(64'h003000003B080000)) 
    \spo[8]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[7]),
        .I2(a[1]),
        .I3(a[8]),
        .I4(\spo[31]_INST_0_i_29_n_0 ),
        .I5(a[0]),
        .O(\spo[8]_INST_0_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h8833880030003000)) 
    \spo[8]_INST_0_i_17 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(a[7]),
        .I2(\spo[31]_INST_0_i_22_n_0 ),
        .I3(a[2]),
        .I4(\spo[8]_INST_0_i_23_n_0 ),
        .I5(a[1]),
        .O(\spo[8]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h0000002000210010)) 
    \spo[8]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[8]_INST_0_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h00000000000000F4)) 
    \spo[8]_INST_0_i_19 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[8]_INST_0_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[8]_INST_0_i_2 
       (.I0(\spo[8]_INST_0_i_7_n_0 ),
        .I1(\spo[8]_INST_0_i_8_n_0 ),
        .I2(a[5]),
        .I3(\spo[8]_INST_0_i_9_n_0 ),
        .I4(a[6]),
        .I5(\spo[8]_INST_0_i_10_n_0 ),
        .O(\spo[8]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT4 #(
    .INIT(16'h000B)) 
    \spo[8]_INST_0_i_20 
       (.I0(a[8]),
        .I1(a[0]),
        .I2(a[9]),
        .I3(a[10]),
        .O(\spo[8]_INST_0_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h0000001F0000003C)) 
    \spo[8]_INST_0_i_21 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[8]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h0008090000000000)) 
    \spo[8]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[8]_INST_0_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \spo[8]_INST_0_i_23 
       (.I0(a[10]),
        .I1(a[8]),
        .I2(a[0]),
        .O(\spo[8]_INST_0_i_23_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \spo[8]_INST_0_i_3 
       (.I0(\spo[8]_INST_0_i_11_n_0 ),
        .I1(a[5]),
        .I2(\spo[8]_INST_0_i_12_n_0 ),
        .I3(a[6]),
        .I4(\spo[8]_INST_0_i_13_n_0 ),
        .O(\spo[8]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[8]_INST_0_i_4 
       (.I0(\spo[8]_INST_0_i_14_n_0 ),
        .I1(\spo[8]_INST_0_i_15_n_0 ),
        .I2(a[5]),
        .I3(\spo[8]_INST_0_i_16_n_0 ),
        .I4(a[6]),
        .I5(\spo[8]_INST_0_i_17_n_0 ),
        .O(\spo[8]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    \spo[8]_INST_0_i_5 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[8]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0001000200000000)) 
    \spo[8]_INST_0_i_6 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[1]),
        .I5(a[2]),
        .O(\spo[8]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0A0A0C000C000)) 
    \spo[8]_INST_0_i_7 
       (.I0(\spo[31]_INST_0_i_17_n_0 ),
        .I1(\spo[25]_INST_0_i_21_n_0 ),
        .I2(a[7]),
        .I3(a[1]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[2]),
        .O(\spo[8]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hD000800050FF0000)) 
    \spo[8]_INST_0_i_8 
       (.I0(a[1]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[28]_INST_0_i_24_n_0 ),
        .I5(a[0]),
        .O(\spo[8]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h4400580040000000)) 
    \spo[8]_INST_0_i_9 
       (.I0(a[7]),
        .I1(a[2]),
        .I2(a[0]),
        .I3(\spo[31]_INST_0_i_29_n_0 ),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[8]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[9]_INST_0 
       (.I0(\spo[9]_INST_0_i_1_n_0 ),
        .I1(\spo[9]_INST_0_i_2_n_0 ),
        .I2(a[4]),
        .I3(\spo[9]_INST_0_i_3_n_0 ),
        .I4(a[3]),
        .I5(\spo[9]_INST_0_i_4_n_0 ),
        .O(spo[9]));
  LUT6 #(
    .INIT(64'h8F80FFFF8F800000)) 
    \spo[9]_INST_0_i_1 
       (.I0(\spo[9]_INST_0_i_5_n_0 ),
        .I1(a[7]),
        .I2(a[6]),
        .I3(\spo[9]_INST_0_i_6_n_0 ),
        .I4(a[5]),
        .I5(\spo[9]_INST_0_i_7_n_0 ),
        .O(\spo[9]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[9]_INST_0_i_10 
       (.I0(\spo[9]_INST_0_i_20_n_0 ),
        .I1(\spo[9]_INST_0_i_21_n_0 ),
        .I2(a[6]),
        .I3(\spo[9]_INST_0_i_22_n_0 ),
        .I4(a[7]),
        .I5(\spo[9]_INST_0_i_23_n_0 ),
        .O(\spo[9]_INST_0_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[9]_INST_0_i_11 
       (.I0(\spo[9]_INST_0_i_24_n_0 ),
        .I1(\spo[31]_INST_0_i_25_n_0 ),
        .I2(a[6]),
        .I3(\spo[9]_INST_0_i_25_n_0 ),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[9]_INST_0_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h0CFF0C000A000A00)) 
    \spo[9]_INST_0_i_12 
       (.I0(\spo[31]_INST_0_i_20_n_0 ),
        .I1(\spo[31]_INST_0_i_19_n_0 ),
        .I2(a[2]),
        .I3(a[7]),
        .I4(\spo[31]_INST_0_i_22_n_0 ),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h9000FFFF90000000)) 
    \spo[9]_INST_0_i_13 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(\spo[25]_INST_0_i_14_n_0 ),
        .I3(a[1]),
        .I4(a[7]),
        .I5(\spo[9]_INST_0_i_26_n_0 ),
        .O(\spo[9]_INST_0_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h3000BBBB30008888)) 
    \spo[9]_INST_0_i_14 
       (.I0(\spo[31]_INST_0_i_19_n_0 ),
        .I1(a[6]),
        .I2(\spo[9]_INST_0_i_27_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[9]_INST_0_i_28_n_0 ),
        .O(\spo[9]_INST_0_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00000009)) 
    \spo[9]_INST_0_i_15 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[9]_INST_0_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0000000C00000010)) 
    \spo[9]_INST_0_i_16 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[9]_INST_0_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h00030004)) 
    \spo[9]_INST_0_i_17 
       (.I0(a[9]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[9]_INST_0_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h0010000300000002)) 
    \spo[9]_INST_0_i_18 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00200004)) 
    \spo[9]_INST_0_i_19 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[9]_INST_0_i_19_n_0 ));
  LUT4 #(
    .INIT(16'h88B8)) 
    \spo[9]_INST_0_i_2 
       (.I0(\spo[9]_INST_0_i_8_n_0 ),
        .I1(a[5]),
        .I2(\spo[9]_INST_0_i_9_n_0 ),
        .I3(a[6]),
        .O(\spo[9]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \spo[9]_INST_0_i_20 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[9]_INST_0_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    \spo[9]_INST_0_i_21 
       (.I0(a[0]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[8]),
        .I4(a[2]),
        .O(\spo[9]_INST_0_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h00000A0000010500)) 
    \spo[9]_INST_0_i_22 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[0]),
        .O(\spo[9]_INST_0_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h0000000001010021)) 
    \spo[9]_INST_0_i_23 
       (.I0(a[2]),
        .I1(a[10]),
        .I2(a[9]),
        .I3(a[0]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h0000003000000006)) 
    \spo[9]_INST_0_i_24 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[8]),
        .I3(a[9]),
        .I4(a[10]),
        .I5(a[0]),
        .O(\spo[9]_INST_0_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000020200000900)) 
    \spo[9]_INST_0_i_25 
       (.I0(a[2]),
        .I1(a[0]),
        .I2(a[10]),
        .I3(a[9]),
        .I4(a[8]),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h000000D30000003C)) 
    \spo[9]_INST_0_i_26 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[0]),
        .I3(a[10]),
        .I4(a[9]),
        .I5(a[8]),
        .O(\spo[9]_INST_0_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h00100008)) 
    \spo[9]_INST_0_i_27 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .O(\spo[9]_INST_0_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0004001000020000)) 
    \spo[9]_INST_0_i_28 
       (.I0(a[2]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_28_n_0 ));
  MUXF7 \spo[9]_INST_0_i_3 
       (.I0(\spo[9]_INST_0_i_10_n_0 ),
        .I1(\spo[9]_INST_0_i_11_n_0 ),
        .O(\spo[9]_INST_0_i_3_n_0 ),
        .S(a[5]));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \spo[9]_INST_0_i_4 
       (.I0(\spo[9]_INST_0_i_12_n_0 ),
        .I1(a[6]),
        .I2(\spo[9]_INST_0_i_13_n_0 ),
        .I3(a[5]),
        .I4(\spo[9]_INST_0_i_14_n_0 ),
        .O(\spo[9]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040000)) 
    \spo[9]_INST_0_i_5 
       (.I0(a[1]),
        .I1(a[8]),
        .I2(a[9]),
        .I3(a[10]),
        .I4(a[0]),
        .I5(a[2]),
        .O(\spo[9]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFF0000000F4F0040)) 
    \spo[9]_INST_0_i_6 
       (.I0(a[0]),
        .I1(\spo[25]_INST_0_i_19_n_0 ),
        .I2(a[7]),
        .I3(a[2]),
        .I4(\spo[31]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA000A000CFC0C0C0)) 
    \spo[9]_INST_0_i_7 
       (.I0(\spo[9]_INST_0_i_15_n_0 ),
        .I1(\spo[9]_INST_0_i_16_n_0 ),
        .I2(a[6]),
        .I3(a[2]),
        .I4(\spo[9]_INST_0_i_17_n_0 ),
        .I5(a[7]),
        .O(\spo[9]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hB8883333B8880000)) 
    \spo[9]_INST_0_i_8 
       (.I0(\spo[9]_INST_0_i_18_n_0 ),
        .I1(a[6]),
        .I2(\spo[9]_INST_0_i_19_n_0 ),
        .I3(a[2]),
        .I4(a[7]),
        .I5(\spo[31]_INST_0_i_19_n_0 ),
        .O(\spo[9]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h00C500C008000800)) 
    \spo[9]_INST_0_i_9 
       (.I0(a[7]),
        .I1(\spo[25]_INST_0_i_14_n_0 ),
        .I2(a[2]),
        .I3(a[0]),
        .I4(\spo[25]_INST_0_i_19_n_0 ),
        .I5(a[1]),
        .O(\spo[9]_INST_0_i_9_n_0 ));
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

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
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
