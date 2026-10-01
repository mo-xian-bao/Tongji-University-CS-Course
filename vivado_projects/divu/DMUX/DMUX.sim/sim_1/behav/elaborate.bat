@echo off
set xv_path=D:\\Xlinix\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 5a76e15b75004ec0b3349a1c2a832a26 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot DMUX_tb_behav xil_defaultlib.DMUX_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
