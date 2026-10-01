open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
open_run synth_1
report_utilization -hierarchical -hierarchical_percentages -file D:/vivado_projects/EP1-89Inst/hier_util_after_fix.rpt
report_utilization -file D:/vivado_projects/EP1-89Inst/util_after_fix.rpt
close_project
exit
