set_property PACKAGE_PIN D8 [get_ports {B[3]}]
set_property PACKAGE_PIN D7 [get_ports {B[2]}]
set_property PACKAGE_PIN C7 [get_ports {B[1]}]
set_property PACKAGE_PIN B7 [get_ports {B[0]}]
set_property PACKAGE_PIN A6 [get_ports {G[3]}]
set_property PACKAGE_PIN B6 [get_ports {G[2]}]
set_property PACKAGE_PIN A5 [get_ports {G[1]}]
set_property PACKAGE_PIN C6 [get_ports {G[0]}]
set_property PACKAGE_PIN A4 [get_ports {R[3]}]
set_property PACKAGE_PIN C5 [get_ports {R[2]}]
set_property PACKAGE_PIN B4 [get_ports {R[1]}]
set_property PACKAGE_PIN A3 [get_ports {R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports {G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {G[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {G[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports {G[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R[0]}]

set_property PACKAGE_PIN M17 [get_ports key_left]
set_property PACKAGE_PIN E3 [get_ports clk]
set_property PACKAGE_PIN H17 [get_ports game_over]
set_property PACKAGE_PIN B11 [get_ports hsync]
set_property PACKAGE_PIN B12 [get_ports vsync]
set_property PACKAGE_PIN M18 [get_ports key_down]
set_property PACKAGE_PIN P17 [get_ports key_right]
set_property PACKAGE_PIN P18 [get_ports key_up]
set_property PACKAGE_PIN J15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports game_over]
set_property IOSTANDARD LVCMOS33 [get_ports key_down]
set_property IOSTANDARD LVCMOS33 [get_ports key_left]
set_property IOSTANDARD LVCMOS33 [get_ports key_up]
set_property IOSTANDARD LVCMOS33 [get_ports key_right]

set_property PACKAGE_PIN N17 [get_ports skill_key]

set_property IOSTANDARD LVCMOS33 [get_ports skill_key]

set_property PACKAGE_PIN D17 [get_ports audio_out]
set_property PACKAGE_PIN E17 [get_ports audio_sd]
set_property IOSTANDARD LVCMOS33 [get_ports audio_out]
set_property IOSTANDARD LVCMOS33 [get_ports audio_sd]

# 修改时序约束
create_clock -period 10.000 -name sys_clk [get_ports clk]

# 为输入端口设置延迟
set_input_delay -clock sys_clk -max 2.000 [get_ports {rst_n key_* skill_key}]

# 为输出端口设置延迟
set_output_delay -clock sys_clk -max 2.000 [get_ports {hsync vsync R* G* B* game_over game_win audio_*}]

# 设置错误恢复时间
set_clock_uncertainty 0.500 [get_clocks *]

# 在文件末尾添加 game_win 的约束
set_property PACKAGE_PIN K15 [get_ports game_win]
set_property IOSTANDARD LVCMOS33 [get_ports game_win]
