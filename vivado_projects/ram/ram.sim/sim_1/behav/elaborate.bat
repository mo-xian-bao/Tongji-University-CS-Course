@echo off
set xv_path=D:\\Xlinix\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto e440710bce5d42b5b04c31bf78311d9b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot ram_tb_behav xil_defaultlib.ram_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
