open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
reset_run synth_1
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
close_project
exit
