# ============================================================================
# 鸡蛋掉落二分查找 - MARS标准MIPS版本
# ============================================================================
# 这是为MARS模拟器修改的版本，与drop_eggs.asm的逻辑完全相同
# 但使用标准MIPS指令集
# ============================================================================

.data
    # Output strings (English to avoid encoding issues in MARS)
    msg_start:    .asciiz "Start test: Total floors: 100, Secret threshold: 37\n\n"
    msg_result:   .asciiz "\nTest finished. Threshold found: "
    msg_up:       .asciiz "\nStatistics -> Move up: "
    msg_down:     .asciiz ", Move down: "
    msg_broken:   .asciiz ", Broken eggs: "
    msg_last:     .asciiz "\nLast egg drop result: ["
    msg_broken2:  .asciiz "Broken"
    msg_survived: .asciiz "Survived"
    msg_bracket:  .asciiz "]\n"
    msg_cost1:    .asciiz "\nCost 1 (Resource-scarce period)  : "
    msg_cost2:    .asciiz "\nCost 2 (Labor-abundant period)   : "
    newline:      .asciiz "\n"

.text
.globl main

main:
    # 打印开始信息
    li $v0, 4
    la $a0, msg_start
    syscall

    # --- 初始化阶段 ---
    li $s0, 37              # $s0 = 37 (SECRET_THRESHOLD)
    li $s1, 100             # $s1 = 100 (TOTAL_FLOORS)
    li $s2, 0               # $s2 = 0 (low)
    move $s3, $s1           # $s3 = 100 (high = TOTAL_FLOORS)
    li $s4, 0               # $s4 = 0 (current_floor)
    li $s5, 0               # $s5 = 0 (m_up)
    li $s6, 0               # $s6 = 0 (n_down)
    li $s7, 0               # $s7 = 0 (h_broken)
    li $t8, -1              # $t8 = -1 (last_drop_broken)

# --- 主循环: while (low <= high) ---
LOOP_START:
    # 检查循环条件: if (high < low) goto LOOP_END
    # 自定义CPU: BN $s3, $s2, LOOP_END
    # MARS标准: slt $t9, $s3, $s2 (如果high<low则$t9=1)
    slt $t9, $s3, $s2
    bne $t9, $zero, LOOP_END

    # 特殊检查: if (low == 0 && high == 0) break
    # 自定义CPU: BZ $s2, $zero, CHECK_HIGH_ZERO
    # MARS标准: beq $s2, $zero, CHECK_HIGH_ZERO
    bne $s2, $zero, NORMAL_LOOP
    beq $s3, $zero, LOOP_END

NORMAL_LOOP:
    # mid = (low + high + 1) / 2
    add $t0, $s2, $s3       # $t0 = low + high
    addi $t0, $t0, 1        # $t0 = low + high + 1
    sra $t0, $t0, 1         # $t0 = mid (算术右移)

    # 计算移动成本
    # if (current_floor < mid) goto MOVE_UP
    # 自定义CPU: BN $s4, $t0, MOVE_UP
    # MARS标准: slt $t9, $s4, $t0
    slt $t9, $s4, $t0
    bne $t9, $zero, MOVE_UP

MOVE_DOWN:
    sub $t1, $s4, $t0       # $t1 = current_floor - mid
    add $s6, $s6, $t1       # n_down += $t1
    j UPDATE_FLOOR

MOVE_UP:
    sub $t1, $t0, $s4       # $t1 = mid - current_floor
    add $s5, $s5, $t1       # m_up += $t1

UPDATE_FLOOR:
    move $s4, $t0           # current_floor = mid

    # --- 核心测试 ---
    # if (SECRET_THRESHOLD < current_floor) goto EGG_BROKEN
    # 自定义CPU: BN $s0, $s4, EGG_BROKEN
    # MARS标准: slt $t9, $s0, $s4
    slt $t9, $s0, $s4
    bne $t9, $zero, EGG_BROKEN

EGG_SURVIVED:
    # 鸡蛋没破
    addi $s2, $t0, 1        # low = mid + 1
    li $t8, 0               # last_drop_broken = 0
    j LOOP_START

EGG_BROKEN:
    # 鸡蛋破了
    addi $s7, $s7, 1        # h_broken++
    addi $s3, $t0, -1       # high = mid - 1
    li $t8, 1               # last_drop_broken = 1
    j LOOP_START

LOOP_END:
    # --- 计算成本，使用寄存器保存结果 ---
    # 成本1: f1 = m*2 + n*1 + h*4，保存在 $t2
    sll $t0, $s5, 1         # $t0 = m * 2
    sll $t1, $s7, 2         # $t1 = h * 4
    add $t2, $t0, $s6       # $t2 = (m*2) + n
    add $t2, $t2, $t1       # $t2 = f1

    # 成本2: f2 = m*4 + n*1 + h*2，保存在 $t3
    sll $t0, $s5, 2         # $t0 = m * 4
    sll $t1, $s7, 1         # $t1 = h * 2
    add $t3, $t0, $s6       # $t3 = (m*4) + n
    add $t3, $t3, $t1       # $t3 = f2

    # --- 打印结果 ---
    # 打印"测试结束"
    li $v0, 4
    la $a0, msg_result
    syscall
    
    # 打印测得耐摔值
    li $v0, 1
    move $a0, $s3
    syscall

    # 打印"最后一次状态"
    li $v0, 4
    la $a0, msg_last
    syscall
    
    beq $t8, 1, print_broken
    li $v0, 4
    la $a0, msg_survived
    syscall
    j after_last
print_broken:
    li $v0, 4
    la $a0, msg_broken2
    syscall
after_last:
    li $v0, 4
    la $a0, msg_bracket
    syscall

    # 打印"上楼"
    li $v0, 4
    la $a0, msg_up
    syscall
    li $v0, 1
    move $a0, $s5
    syscall

    # 打印"下楼"
    li $v0, 4
    la $a0, msg_down
    syscall
    li $v0, 1
    move $a0, $s6
    syscall

    # 打印"破蛋总数"
    li $v0, 4
    la $a0, msg_broken
    syscall
    li $v0, 1
    move $a0, $s7
    syscall

    # 打印"成本1"
    li $v0, 4
    la $a0, msg_cost1
    syscall
    li $v0, 1
    move $a0, $t2
    syscall

    # 打印"成本2"
    li $v0, 4
    la $a0, msg_cost2
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    # 打印换行
    li $v0, 4
    la $a0, newline
    syscall

    # 退出程序
    li $v0, 10
    syscall
