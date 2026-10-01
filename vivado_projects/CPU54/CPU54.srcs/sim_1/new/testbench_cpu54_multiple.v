`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:45:04 03/18/2014
// Design Name:   decoder
// Module Name:   C:/Users/Wong/Desktop/tb/tb2/decoder/decoder_tb.v
// Project Name:  decoder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module _246tb_ex7_tb;

	// Inputs
	reg clk_in;
	reg reset;

	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	sccomp_dataflow uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.inst(inst),
		.pc(pc)
	);

	integer file_output;
	//integer flag;
	reg [31:0] pc_pre;
	reg [31:0] inst_pre;
	//reg [31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;
	
	
	
initial begin
		file_output = $fopen("_246tb_ex7_result.txt");	
		// Initialize Inputs
		clk_in = 0;
		reset = 1;
        //pc初始值32'h00400000
        //inst初始值32'h08100004
		pc_pre = 32'h44436040; 
		inst_pre = 32'h88807704;
		

		// Wait 200 ns for global reset to finish
		#225;
        reset = 0;		
		
		
	end
   
	always begin		
	#50;	
	clk_in = ~clk_in;
	if(clk_in == 1'b1 && reset == 0) begin	
			if(pc_pre != pc)
			begin
			$fdisplay(file_output, "pc: %h", pc);	
			$fdisplay(file_output, "instr: %h", inst);
//                        $fdisplay(file_output, "M5_sel: %h", _246tb_ex7_tb.uut.sccpu.M5);
//                        $fdisplay(file_output, "exception: %h", _246tb_ex7_tb.uut.sccpu.exception);
//                        $fdisplay(file_output, "eret: %h", _246tb_ex7_tb.uut.sccpu.eret);
//                        $fdisplay(file_output, "cp0_exc_addr: %h", _246tb_ex7_tb.uut.sccpu.cp0_exc_addr);
//                        $fdisplay(file_output, "jump_addr: %h", _246tb_ex7_tb.uut.sccpu.jump_addr);
//                        $fdisplay(file_output, "branch_addr: %h", _246tb_ex7_tb.uut.sccpu.branch_addr);
			$fdisplay(file_output, "regfile0: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[0]);
			$fdisplay(file_output, "regfile1: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[1]);
			$fdisplay(file_output, "regfile2: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[2]);
			$fdisplay(file_output, "regfile3: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[3]);
			$fdisplay(file_output, "regfile4: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[4]);
			$fdisplay(file_output, "regfile5: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[5]);
			$fdisplay(file_output, "regfile6: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[6]);
			$fdisplay(file_output, "regfile7: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[7]);
			$fdisplay(file_output, "regfile8: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[8]);
			$fdisplay(file_output, "regfile9: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[9]);
			$fdisplay(file_output, "regfile10: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[10]);
			$fdisplay(file_output, "regfile11: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[11]);
			$fdisplay(file_output, "regfile12: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[12]);
			$fdisplay(file_output, "regfile13: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[13]);
			$fdisplay(file_output, "regfile14: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[14]);
			$fdisplay(file_output, "regfile15: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[15]);
			$fdisplay(file_output, "regfile16: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[16]);
			$fdisplay(file_output, "regfile17: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[17]);
			$fdisplay(file_output, "regfile18: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[18]);
			$fdisplay(file_output, "regfile19: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[19]);
			$fdisplay(file_output, "regfile20: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[20]);
			$fdisplay(file_output, "regfile21: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[21]);
			$fdisplay(file_output, "regfile22: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[22]);
			$fdisplay(file_output, "regfile23: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[23]);
			$fdisplay(file_output, "regfile24: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[24]);
			$fdisplay(file_output, "regfile25: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[25]);
			$fdisplay(file_output, "regfile26: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[26]);
			$fdisplay(file_output, "regfile27: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[27]);
			$fdisplay(file_output, "regfile28: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[28]);
			$fdisplay(file_output, "regfile29: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[29]);
			$fdisplay(file_output, "regfile30: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[30]);
			$fdisplay(file_output, "regfile31: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[31]);
//			              $fdisplay(file_output, "MDU_HI: %h", _246tb_ex7_tb.uut.sccpu.mdu_inst.HI);
//                        $fdisplay(file_output, "MDU_LO: %h", _246tb_ex7_tb.uut.sccpu.mdu_inst.LO);
//                        $fdisplay(file_output, "HI_reg: %h", _246tb_ex7_tb.uut.sccpu.hi_reg);
//                        $fdisplay(file_output, "LO_reg: %h", _246tb_ex7_tb.uut.sccpu.lo_reg);
//                        $fdisplay(file_output, "MDU_busy: %h", _246tb_ex7_tb.uut.sccpu.MDU_busy);
//                        $fdisplay(file_output, "HI_w: %h", _246tb_ex7_tb.uut.sccpu.HI_w);
//                        $fdisplay(file_output, "LO_w: %h", _246tb_ex7_tb.uut.sccpu.LO_w);
//                        $fdisplay(file_output, "MDU_start: %h", _246tb_ex7_tb.uut.sccpu.MDU_start);
//            $fdisplay(file_output, "--- CP0 Debug Info ---");
//			$fdisplay(file_output, "CP0_reg12_status: %h", _246tb_ex7_tb.uut.sccpu.cp0_inst.cp0_regs[12]);
//			$fdisplay(file_output, "CP0_reg13_cause: %h", _246tb_ex7_tb.uut.sccpu.cp0_inst.cp0_regs[13]);
//			$fdisplay(file_output, "CP0_reg14_epc: %h", _246tb_ex7_tb.uut.sccpu.cp0_inst.cp0_regs[14]);
//			$fdisplay(file_output, "mfc0_signal: %h", _246tb_ex7_tb.uut.mfc0);
//			$fdisplay(file_output, "mtc0_signal: %h", _246tb_ex7_tb.uut.mtc0);
//			$fdisplay(file_output, "cp0_rdata: %h", _246tb_ex7_tb.uut.sccpu.cp0_rdata);
//			$fdisplay(file_output, "--- Control Signals ---");
//			$fdisplay(file_output, "CU_state: %h", _246tb_ex7_tb.uut.cu_inst.state);
//			$fdisplay(file_output, "Reg_in: %h", _246tb_ex7_tb.uut.Reg_in);
//			$fdisplay(file_output, "M2: %h", _246tb_ex7_tb.uut.M2);
//			$fdisplay(file_output, "M4: %h", _246tb_ex7_tb.uut.M4);
//			$fdisplay(file_output, "M4_out: %h", _246tb_ex7_tb.uut.sccpu.m4_out);
//			$fdisplay(file_output, "reg_dst: %h", _246tb_ex7_tb.uut.sccpu.reg_dst);
//			$fdisplay(file_output, "exception_signal: %h", _246tb_ex7_tb.uut.exception);
//			$fdisplay(file_output, "---------------------");
			pc_pre = pc;
			inst_pre = inst;
		end
		
	end
	end
endmodule
