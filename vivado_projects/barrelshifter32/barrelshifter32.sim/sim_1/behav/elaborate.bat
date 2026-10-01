@echo off
set xv_path=D:\\Xlinix\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 23738ab1ee0e4a95b641caea09d08ea9 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot barrelshifter32_tb_behav xil_defaultlib.barrelshifter32_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
