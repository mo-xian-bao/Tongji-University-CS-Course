# MIPS Assembly for Algorithm Verification
# 
# int a[60], b[60], c[60], d[60];
# a[0]=0;
# b[0]=1;
# for i=1 to 59:
#   a[i] = a[i-1] + i;
#   b[i] = b[i-1] + 3*i;
#   if (0 <= i <= 19):
#     c[i] = a[i]; d[i] = b[i];
#   else if (20 <= i <= 39):
#     c[i] = a[i] + b[i]; d[i] = a[i] * c[i];
#   else:
#     c[i] = a[i] * b[i]; d[i] = c[i] * b[i];

.text
.globl main

main:
    # --- 初始化基地址 (Base Addresses) ---
    # a[] -> 0
    # b[] -> 256 (0x100)
    # c[] -> 512 (0x200)
    # d[] -> 768 (0x300)
    # 注意：这里使用绝对偏移量，对应DMEM的物理地址
    addiu $s0, $zero, 0       # $s0 = base_a
    addiu $s1, $zero, 256     # $s1 = base_b
    addiu $s2, $zero, 512     # $s2 = base_c
    addiu $s3, $zero, 768     # $s3 = base_d

    # --- 初始化 a[0]=0, b[0]=1 ---
    sw    $zero, 0($s0)       # a[0] = 0
    
    addiu $t2, $zero, 1
    sw    $t2,   0($s1)       # b[0] = 1

    # --- 循环初始化 ---
    addiu $t0, $zero, 1       # i = 1
    addiu $t1, $zero, 60      # limit = 60

loop:
    # Check loop condition: i < 60
    slt   $t2, $t0, $t1       # if i < 60 then $t2 = 1
    beq   $t2, $zero, end     # if $t2 == 0 then goto end

    # offset = i * 4
    sll   $t3, $t0, 2         # $t3 = i << 2

    # --- Calc a[i] = a[i-1] + i ---
    addiu $t4, $t3, -4        # prev_offset = offset - 4
    
    add   $t5, $s0, $t4       # addr of a[i-1]
    lw    $t6, 0($t5)         # load a[i-1]
    add   $t6, $t6, $t0       # val = a[i-1] + i
    
    add   $t5, $s0, $t3       # addr of a[i]
    sw    $t6, 0($t5)         # store a[i]
    # $t6 holds a[i]

    # --- Calc b[i] = b[i-1] + 3*i ---
    add   $t5, $s1, $t4       # addr of b[i-1]
    lw    $t7, 0($t5)         # load b[i-1]
    
    addiu $t8, $zero, 3
    mult  $t0, $t8            # i * 3
    mflo  $t8                 # 3*i
    
    add   $t7, $t7, $t8       # val = b[i-1] + 3*i
    
    add   $t5, $s1, $t3       # addr of b[i]
    sw    $t7, 0($t5)         # store b[i]
    # $t7 holds b[i]

    # --- Calc c[i] and d[i] ---
    slti  $t2, $t0, 20        # i < 20?
    bne   $t2, $zero, range1

    slti  $t2, $t0, 40        # i < 40?
    bne   $t2, $zero, range2
    
    j     range3              # else (40 <= i < 60)

range1: # 0 <= i <= 19
    # c[i] = a[i]
    # d[i] = b[i]
    add   $t8, $zero, $t6     # c = a[i]
    add   $t9, $zero, $t7     # d = b[i]
    j     store_cd

range2: # 20 <= i <= 39
    # c[i] = a[i] + b[i]
    # d[i] = a[i] * c[i]
    add   $t8, $t6, $t7       # c = a[i] + b[i]
    
    mult  $t6, $t8            # a[i] * c[i]
    mflo  $t9                 # d
    j     store_cd

range3: # 40 <= i <= 59
    # c[i] = a[i] * b[i]
    # d[i] = c[i] * b[i]
    mult  $t6, $t7            # a[i] * b[i]
    mflo  $t8                 # c
    
    mult  $t8, $t7            # c[i] * b[i]
    mflo  $t9                 # d
    j     store_cd

store_cd:
    # Store c[i]
    add   $t5, $s2, $t3       # addr c[i]
    sw    $t8, 0($t5)
    
    # Store d[i]
    add   $t5, $s3, $t3       # addr d[i]
    sw    $t9, 0($t5)

    # i++
    addiu $t0, $t0, 1
    j     loop

end:
    # Infinite loop to stop
    beq   $zero, $zero, end
