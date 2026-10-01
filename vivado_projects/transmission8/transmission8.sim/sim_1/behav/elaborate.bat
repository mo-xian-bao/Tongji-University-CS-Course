@echo off
set xv_path=D:\\Xlinix\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 6b0487dbdc87405da94befdff5f4db04 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot transmission8_tb_behav xil_defaultlib.transmission8_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
