# Run simulation in GUI and keep the waveform window open.
# Usage in Vivado Tcl Console:
#   cd D:/desktop/???????/???/src/vivado_sim
#   source run_tb_keep_open.tcl

set env(LIBRARY_PATH) ""
set_property top tb_top_board [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral

# Add some key signals to waveform if not already present.
catch {add_wave -position end sim:/tb_top_board/clk}
catch {add_wave -position end sim:/tb_top_board/rst}
catch {add_wave -position end sim:/tb_top_board/switch}
catch {add_wave -position end sim:/tb_top_board/dut/pc_value}
catch {add_wave -position end sim:/tb_top_board/dut/instr_value}
catch {add_wave -position end sim:/tb_top_board/wave_dmem_10010000}
catch {add_wave -position end sim:/tb_top_board/wave_display_word}

# Run and keep simulation open (no close_sim / no exit).
run all

puts "TB finished. Waveform window stays open for inspection."
