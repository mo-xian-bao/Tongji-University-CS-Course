open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
open_run impl_1
report_timing_summary -file D:/vivado_projects/EP1-89Inst/timing_after_fix.rpt
close_project
exit
