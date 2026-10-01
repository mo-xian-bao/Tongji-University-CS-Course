open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
set_property -name xsim.elaborate.xelab.more_options -value "-mt off -v 1" -objects [get_filesets sim_1]
launch_simulation -simset sim_1 -mode behavioral
exit
