open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
set env(LIBRARY_PATH) ""
set_property top tb_top_board [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
run all
close_sim
exit
