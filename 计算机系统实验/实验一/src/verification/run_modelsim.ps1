$ErrorActionPreference = 'Stop'

$workspacePath = Split-Path -Parent $PSScriptRoot
$driveName = 'V:'

try {
    $existing = Get-PSDrive -Name 'V' -ErrorAction SilentlyContinue
    if ($existing) {
        subst $driveName /d | Out-Null
    }

    subst $driveName $workspacePath | Out-Null
    Set-Location "$driveName\verification"

    if (Test-Path work) {
        Remove-Item -Recurse -Force work
    }

    vlib work

    vlog IMEM_sim.v ..\ALU.v ..\Controller.v ..\CP0.v ..\DCPU.v ..\DMEM.v ..\ForwardUnit.v ..\HazardUnit.v ..\MDU.v ..\RegFile.v tb_dcpu_smoke.v tb_dcpu_branch.v tb_dcpu_trap.v tb_dcpu_llsc.v tb_dcpu_unaligned.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dcpu_smoke -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dcpu_branch +PROGRAM=program_branch.hex -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dcpu_trap +PROGRAM=program_trap.hex -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dcpu_llsc +PROGRAM=program_llsc.hex -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dcpu_unaligned +PROGRAM=program_unaligned.hex -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\ForwardUnit.v tb_forward_unit.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_forward_unit -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\HazardUnit.v tb_hazard_unit.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_hazard_unit -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\ALU.v tb_alu_trap_compare.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_alu_trap_compare -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\Controller.v tb_controller_decode.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_controller_decode -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\DMEM.v tb_dmem_ops.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_dmem_ops -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vlog ..\CP0.v tb_cp0_exception.v
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    vsim -c work.tb_cp0_exception -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
    Set-Location $PSScriptRoot
    subst $driveName /d | Out-Null
}