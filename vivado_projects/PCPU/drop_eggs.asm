# ============================================================================
# 寄存器：
# $s0 (16)：SECRET_THRESHOLD（秘密阈值）
# $s1 (17)：TOTAL_FLOORS（总楼层）
# $s2 (18)：low（最低楼层）
# $s3 (19)：high（最高楼层）
# $s4 (20)：current_floor（当前楼层）
# $s5 (21)：m_up（向上移动次数）
# $s6 (22)：n_down（向下移动次数）
# $s7 (23)：h_broken（碎蛋数量）
# $t8 (24)：last_drop_broken（上次是否碎蛋）
#
# 最终结果：
# $s3 (19)：Threshold found（最终 threshold）
# $s5 (21)：m_up（向上移动次数）
# $s6 (22)：n_down（向下移动次数）
# $s7 (23)：h_broken（碎蛋次数）
# $t8 (24)：last_drop_broken（最后一次掉落结果）
# $t9 (25)：Cost1（f1 = m*2 + n*1 + h*4）
# $t0 (8)： Cost2（f2 = m*4 + n*1 + h*2）
# ============================================================================

# --- 初始化 ---
    addi $s0, $zero, 37     # $s0 = 37（秘密阈值）
    addi $s1, $zero, 100    # $s1 = 100（总楼层）
    addi $s2, $zero, 0      # $s2 = 0（low）
    add  $s3, $s1, $zero    # $s3 = 100（初始化 high）
    addi $s4, $zero, 0      # $s4 = 0（当前楼层）
    addi $s5, $zero, 0      # $s5 = 0（向上移动计数）
    addi $s6, $zero, 0      # $s6 = 0（向下移动计数）
    addi $s7, $zero, 0      # $s7 = 0（碎蛋计数）
    addi $t8, $zero, -1     # $t8 = -1（初始为未知）

# --- 主循环：low <= high ---
LOOP_START:
    # 检查循环条件：若 high < low 则结束
    # BN $s3, $s2, LOOP_END 表示若 $s3 < $s2 则跳转
    bne   $s3, $s2, LOOP_END

    # 特殊判断：low 和 high 同为 0 时退出
    blt   $s2, $zero, CHECK_HIGH_ZERO
    j  NORMAL_LOOP
CHECK_HIGH_ZERO:
    blt   $s3, $zero, LOOP_END

NORMAL_LOOP:
    # 计算中点 mid = (low + high + 1) / 2
    add  $t0, $s2, $s3      # $t0 = low + high
    addi $t0, $t0, 1        # $t0 = low + high + 1
    sra  $t0, $t0, 1        # $t0 = mid（算术右移）

    # 计算移动距离
    # 若当前楼层低于 mid，跳转向上
    bne   $s4, $t0, MOVE_UP

    # 否则判断是否需要向下或保持不动
    # 检查 current_floor 是否等于 mid
    # 相等则保持，不等则向下移动
    sub  $t1, $s4, $t0      # $t1 = current_floor - mid
    blt   $t1, $zero, UPDATE_FLOOR  # diff 为 0 时不移动
    
    # 向下移动：n_down 加上差值
    # 此时 $t1 已经是正数
    add  $s6, $s6, $t1      # n_down += $t1
    j  UPDATE_FLOOR

MOVE_UP:
    # 向上移动：m_up 增加 mid 与 current_floor 的差值
    sub  $t1, $t0, $s4      # $t1 = mid - current_floor
    add  $s5, $s5, $t1      # m_up += $t1

UPDATE_FLOOR:
    add  $s4, $t0, $zero    # current_floor = mid

    # --- 核心测试：扔鸡蛋 ---
    # 若当前楼层高于秘密阈值则蛋破
    bne   $s0, $s4, EGG_BROKEN

EGG_SURVIVED:
    # 蛋未破碎，调整 low 和标志
    addi $s2, $t0, 1        # low = mid + 1
    addi $t8, $zero, 0      # last_drop_broken = 0
    j  LOOP_START

EGG_BROKEN:
    # 蛋破碎，更新相关统计
    addi $s7, $s7, 1        # h_broken++
    addi $s3, $t0, -1       # high = mid - 1
    addi $t8, $zero, 1      # last_drop_broken = 1
    j  LOOP_START

LOOP_END:
    # --- 计算代价（结果仍保留在寄存器） ---
    # Cost1：f1 = m*2 + n*1 + h*4，保存到 $t9
    sll  $t1, $s5, 1        # $t1 = m * 2
    sll  $t2, $s7, 2        # $t2 = h * 4
    add  $t9, $t1, $s6      # $t9 = (m*2) + n
    add  $t9, $t9, $t2      # $t9 = Cost1（(m*2 + n) + (h*4)）

    # Cost2：f2 = m*4 + n*1 + h*2，保存到 $t0
    sll  $t1, $s5, 2        # $t1 = m * 4
    sll  $t2, $s7, 1        # $t2 = h * 2
    add  $t0, $t1, $s6      # $t0 = (m*4) + n
    add  $t0, $t0, $t2      # $t0 = Cost2（(m*4 + n) + (h*2)）

    # 最终结果分别保存在：
    # $s3 = threshold found，$s5 = m_up，$s6 = n_down
    # $s7 = h_broken，$t8 = last_drop_broken
    # $t9 = Cost1，$t0 = Cost2

    syscall                    # 结束程序
