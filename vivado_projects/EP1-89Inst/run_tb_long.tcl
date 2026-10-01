open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
set env(LIBRARY_PATH) ""
set_property top tb_top_board [get_filesets sim_1]
launch_simulation -simset sim_1 -mode behavioral
run 20 us
close_sim
exit
