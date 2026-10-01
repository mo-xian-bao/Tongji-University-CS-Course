open_project D:/vivado_projects/EP1-89Inst/EP1-89Inst.xpr
add_files -fileset sim_1 D:/vivado_projects/EP1-89Inst/tb/tb_top_board.v
set_property top tb_top_board [get_filesets sim_1]
update_compile_order -fileset sim_1
set env(LIBRARY_PATH) ""
launch_simulation -simset sim_1 -mode behavioral
exit
