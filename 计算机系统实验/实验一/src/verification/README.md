# 离板验证方法

不下板时，最稳妥的方法是先做模块级自检仿真，再做整机联调。

当前这个目录提供了两类可直接运行的自检：

- `IMEM_sim.v` + `program_smoke.hex` + `tb_dcpu_smoke.v`：提供一个不依赖板级 IP 的仿真取指环境，用于跑 DCPU 端到端冒烟测试。
- `program_branch.hex` + `tb_dcpu_branch.v`：按分支类别组织的小程序，检查分支确实跳过了不该执行的写寄存器指令。
- `program_trap.hex` + `tb_dcpu_trap.v`：按异常类别组织的小程序，检查 trap 进入后寄存器和 CP0 状态。
- `program_llsc.hex` + `tb_dcpu_llsc.v`：检查 LLbit、SC 成功写回和存储结果。
- `program_unaligned.hex` + `tb_dcpu_unaligned.v`：检查 LWL/LWR/SWL/SWR 的端到端结果。
- `tb_forward_unit.v`：检查 ID/EX 两级数据前推是否按优先级选择正确来源。
- `tb_hazard_unit.v`：检查 load-use 冒险、branch hazard 和 branch_taken 判定是否正确。
- `tb_alu_trap_compare.v`：检查 ALU 上用于 trap 判定的 `sub/slt/sltu` 结果是否正确。
- `tb_controller_decode.v`：检查控制器对新增 trap 指令、`nop`、`ssnop`、`sync`、`pref` 的译码是否正确。
- `tb_dmem_ops.v`：检查 `lb/ll`、`lwl`、`lwr`、`swl`、`swr` 的读写语义是否符合当前代码实现。
- `tb_cp0_exception.v`：检查 CP0 在 trap 异常进入、`eret` 返回、异常屏蔽下的寄存器更新行为。

## 为什么先做模块级验证

你当前工程里的 `IMEM.v` 依赖 `dist_mem_gen_0` 这个 IP，所以直接仿真整机 `DCPU.v` 之前，通常还需要额外准备 IP 仿真模型或替换成可仿真的存储器模型。

模块级验证不依赖板子，也不依赖这个 IP，优点是：

- 改一条指令就能马上验证，不用反复下板。
- 出错时定位快，能直接知道是译码错、ALU 比较错，还是 DMEM 语义错。
- 可以做成自检，跑完就给 PASS/FAIL。

## 运行方法

如果 ModelSim 直接在当前中文路径下运行报错，优先使用本目录自带的 PowerShell 脚本。它会临时把工程映射到一个纯 ASCII 盘符，再调用 `vlog/vsim`。

```powershell
.\run_modelsim.ps1
```

如果你想手动运行 `do` 文件，也建议先把工程映射到一个临时盘符后，再进入对应目录执行。

## 直接运行 do 文件

在 ModelSim 命令行里进入本目录后执行：

```tcl
do run.do
```

如果你想单独跑某一个测试，也可以用：

```tcl
vlib work
vlog IMEM_sim.v ../ALU.v ../Controller.v ../CP0.v ../DCPU.v ../DMEM.v ../ForwardUnit.v ../HazardUnit.v ../MDU.v ../RegFile.v tb_dcpu_smoke.v tb_dcpu_branch.v tb_dcpu_trap.v tb_dcpu_llsc.v tb_dcpu_unaligned.v
vsim -c work.tb_dcpu_smoke -do "run -all; quit -f"
```

```tcl
vsim -c work.tb_dcpu_branch +PROGRAM=program_branch.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_trap +PROGRAM=program_trap.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_llsc +PROGRAM=program_llsc.hex -do "run -all; quit -f"
vsim -c work.tb_dcpu_unaligned +PROGRAM=program_unaligned.hex -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../ForwardUnit.v tb_forward_unit.v
vsim -c work.tb_forward_unit -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../HazardUnit.v tb_hazard_unit.v
vsim -c work.tb_hazard_unit -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../ALU.v tb_alu_trap_compare.v
vsim -c work.tb_alu_trap_compare -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../Controller.v tb_controller_decode.v
vsim -c work.tb_controller_decode -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../DMEM.v tb_dmem_ops.v
vsim -c work.tb_dmem_ops -do "run -all; quit -f"
```

```tcl
vlib work
vlog ../CP0.v tb_cp0_exception.v
vsim -c work.tb_cp0_exception -do "run -all; quit -f"
```

## 下一步建议

如果你要继续提高把握，可以按这个顺序补验证：

1. 把 `program_smoke.hex` 扩成多组小程序，例如分支跳转、异常进入、LL/SC、LWL/LWR 专项程序。
2. 如果要跑老师整段汇编，再做一个把汇编转成仿真 ROM 初始化文件的流程。
3. 如果后续继续加指令，就同步给 verification 目录补对应自检，保持一条指令一条验证闭环。