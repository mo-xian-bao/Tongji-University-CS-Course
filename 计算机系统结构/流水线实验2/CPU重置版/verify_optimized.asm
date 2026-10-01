.text
.globl main

main:
    addiu $s0, $zero, 0
    addiu $s1, $zero, 256
    addiu $s2, $zero, 512
    addiu $s3, $zero, 768
    sw    $zero, 0($s0)
    addiu $t2, $zero, 1
    sw    $t2, 0($s1)
    addiu $t0, $zero, 1
    addiu $t1, $zero, 60

loop:
    slt   $t2, $t0, $t1
    sll   $t3, $t0, 2         # [优化] 填充slt->beq的气泡
    beq   $t2, $zero, end
    addiu $t4, $t3, -4        # [延迟槽] 计算i-1的偏移量

    # [优化] 交错加载A[i-1]和B[i-1]，避免lw->use气泡
    add   $t5, $s0, $t4       # A[i-1]地址
    lw    $t6, 0($t5)         # Load A[i-1]
    add   $t5, $s1, $t4       # B[i-1]地址
    lw    $t7, 0($t5)         # Load B[i-1]

    # [优化] 提前计算分支条件，避免后面的ALU->Branch气泡
    slti  $k0, $t0, 20
    slti  $k1, $t0, 40

    # 计算 A[i] = A[i-1] + i
    add   $t6, $t6, $t0       # 此时距离lw $t6已有足够间隔
    add   $t5, $s0, $t3       # A[i]地址
    sw    $t6, 0($t5)
    addiu $gp, $t6, 0

    # 计算 B[i] = B[i-1] + 3*i
    addiu $t8, $zero, 3
    mult  $t0, $t8
    mflo  $t8                 # 3*i
    add   $t7, $t7, $t8       # 此时距离lw $t7已有足够间隔
    add   $t5, $s1, $t3       # B[i]地址
    sw    $t7, 0($t5)
    addiu $gp, $t7, 0

    # 分支逻辑优化
    bne   $k0, $zero, range1
    add   $t8, $t6, $t7       # [延迟槽] 预计算 c = a + b (range2需要)

    bne   $k1, $zero, range2_entry
    mult  $t6, $t8            # [延迟槽] 预计算 range2 的乘法 (单周期MDU)

    # range3 (Fallthrough)
    # c = a * b * b
    mult  $t6, $t7
    mflo  $t8
    mult  $t8, $t7
    j     store_cd
    mflo  $t9                 # [延迟槽]

range1:
    add   $t8, $zero, $t6
    j     store_cd
    add   $t9, $zero, $t7     # [延迟槽]

range2_entry:
    # range2 的乘法已经在 bne 的延迟槽中启动
    j     store_cd
    mflo  $t9                 # [延迟槽] 读取乘法结果

store_cd:
    addiu $gp, $t8, 0
    addiu $gp, $t9, 0
    add   $t5, $s2, $t3
    sw    $t8, 0($t5)
    add   $t5, $s3, $t3
    sw    $t9, 0($t5)
    
    j     loop
    addiu $t0, $t0, 1         # [延迟槽] i++

end:
    beq   $zero, $zero, end
    nop                       # 死循环
