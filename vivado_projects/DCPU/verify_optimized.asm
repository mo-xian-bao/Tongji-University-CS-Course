# 延迟槽优化版本
.text
.globl main

# =========================================================
# 1. 异常处理程序 (ISR) - 位于 0x00400004
# =========================================================
# 假设程序加载基址是 0x00400000，那么第一条指令是 0x00400000
# 我们用一条跳转指令跳过 ISR，去执行 main
#    j main
#    nop

# 此时地址是 0x00400008，但异常入口是 0x00400004。
# 为了让 ISR 刚好在 0x00400004，我们需要调整布局。
# 
# 更简单的做法：
# 0x00400000: j main
# 0x00400004: j isr_handler  <-- 异常入口在这里
# ...

.org 0x00400000
    j main
    nop

.org 0x00400004
isr_handler:
    # 保护现场 (本例简单，只用了 k0，不需保护通用寄存器)
    
wait_loop:
    mfc0 $k0, $13       # 读取 Cause 寄存器
    nop
    nop
    nop
    andi $k0, $k0, 0x0400 # 检查第10位 (0x400) 是否为 1
    bne  $k0, $zero, wait_loop # 如果还是 1 (开关没拨回)，继续等
    nop

    # 恢复现场 (无)
    eret                # 返回主程序

# =========================================================
# 2. 主程序
# =========================================================
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
    beq   $t2, $zero, end
    sll   $t3, $t0, 2         # [ÑÓ³Ù²Û] offset=i*4

    addiu $t4, $t3, -4
    add   $t5, $s0, $t4
    lw    $t6, 0($t5)
    add   $t6, $t6, $t0
    add   $t5, $s0, $t3
    sw    $t6, 0($t5)

    add   $t5, $s1, $t4
    lw    $t7, 0($t5)
    addiu $t8, $zero, 3
    mult  $t0, $t8
    mflo  $t8
    add   $t7, $t7, $t8
    add   $t5, $s1, $t3
    sw    $t7, 0($t5)

    slti  $t2, $t0, 20
    bne   $t2, $zero, range1
    slti  $t2, $t0, 40        # [ÑÓ³Ù²Û]

    bne   $t2, $zero, range2
    add   $t8, $t6, $t7       # [ÑÓ³Ù²Û] c=a+b for range2

range3:
    mult  $t6, $t7
    mflo  $t8
    mult  $t8, $t7
    j     store_cd
    mflo  $t9                 # [ÑÓ³Ù²Û]

range1:
    add   $t8, $zero, $t6
    j     store_cd
    add   $t9, $zero, $t7     # [ÑÓ³Ù²Û]

range2:
    mult  $t6, $t8
    j     store_cd
    mflo  $t9                 # [ÑÓ³Ù²Û]

store_cd:
    add   $t5, $s2, $t3
    sw    $t8, 0($t5)
    add   $t5, $s3, $t3
    sw    $t9, 0($t5)
    j     loop
    addiu $t0, $t0, 1         # [ÑÓ³Ù²Û] i++

end:
    beq   $zero, $zero, end
    nop                       # ËÀÑ­»·ÓÃNOP¼´¿É
