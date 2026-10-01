vlib work

vlog IMEM_sim.v ../ALU.v ../Controller.v ../CP0.v ../DCPU.v ../DMEM.v ../ForwardUnit.v ../HazardUnit.v ../MDU.v ../RegFile.v tb_dcpu_smoke.v tb_dcpu_branch.v tb_dcpu_trap.v tb_dcpu_llsc.v tb_dcpu_unaligned.v
vsim -c work.tb_dcpu_smoke -do "run -all; quit -f"
vsim -c work.tb_dcpu_branch +PROGRAM=program_branch.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_trap +PROGRAM=program_trap.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_llsc +PROGRAM=program_llsc.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_unaligned +PROGRAM=program_unaligned.hex -do "run -all; quit -f"

vlog ../ForwardUnit.v tb_forward_unit.v
vsim -c work.tb_forward_unit -do "run -all; quit -f"

vlog ../HazardUnit.v tb_hazard_unit.v
vsim -c work.tb_hazard_unit -do "run -all; quit -f"

vlog ../ALU.v tb_alu_trap_compare.v
vsim -c work.tb_alu_trap_compare -do "run -all; quit -f"

vlog ../Controller.v tb_controller_decode.v
vsim -c work.tb_controller_decode -do "run -all; quit -f"

vlog ../DMEM.v tb_dmem_ops.v
vsim -c work.tb_dmem_ops -do "run -all; quit -f"

vlog ../CP0.v tb_cp0_exception.v
vsim -c work.tb_cp0_exception -do "run -all; quit -f"

quit -f