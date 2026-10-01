# —”≥Ÿ≤€”≈ªØ∞Ê±æ
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
    beq   $t2, $zero, end
    sll   $t3, $t0, 2         # [—”≥Ÿ≤€] offset=i*4

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
    slti  $t2, $t0, 40        # [—”≥Ÿ≤€]

    bne   $t2, $zero, range2
    add   $t8, $t6, $t7       # [—”≥Ÿ≤€] c=a+b for range2

range3:
    mult  $t6, $t7
    mflo  $t8
    mult  $t8, $t7
    j     store_cd
    mflo  $t9                 # [—”≥Ÿ≤€]

range1:
    add   $t8, $zero, $t6
    j     store_cd
    add   $t9, $zero, $t7     # [—”≥Ÿ≤€]

range2:
    mult  $t6, $t8
    j     store_cd
    mflo  $t9                 # [—”≥Ÿ≤€]

store_cd:
    add   $t5, $s2, $t3
    sw    $t8, 0($t5)
    add   $t5, $s3, $t3
    sw    $t9, 0($t5)
    j     loop
    addiu $t0, $t0, 1         # [—”≥Ÿ≤€] i++

end:
    beq   $zero, $zero, end
    nop                       # À¿—≠ª∑”√NOPº¥ø…
