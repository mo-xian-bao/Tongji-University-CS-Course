.text
main:
    # 初始化数据
    addi $t1, $zero, 131072    # 被乘数
    addi $t2, $zero, 131072    # 乘数
    
    # 检查符号并记录
    slt $t8, $t1, $zero     # 如果被乘数<0，则$t8=1
    slt $t9, $t2, $zero     # 如果乘数<0，则$t9=1
    xor $s7, $t8, $t9       # 结果符号：$s7=1表示负，0表示正
    
    # 取绝对值
    bge $t1, $zero, skip_abs1
    sub $t1, $zero, $t1     # 如果被乘数<0，取反
skip_abs1:
    bge $t2, $zero, skip_abs2
    sub $t2, $zero, $t2     # 如果乘数<0，取反
skip_abs2:
    
    # 初始化乘法
    addi $t3, $zero, 0      # 部分积初始化为0
    addi $t4, $zero, 0      # 附加位初始化为0
    addi $t5, $zero, 32     # 计数器（32位乘法）
    
loop:
    # 检查最低两位（$t2[0]和附加位$t4）
    andi $t6, $t2, 1        # 取乘数最低位到$t6
    sll $t6, $t6, 1         # 左移1位，腾出空间给附加位
    or $t6, $t6, $t4        # 合并附加位到$t6的低位
    
    # 根据条件分支
    beq $t6, $zero, shift   # 00: 仅右移
    addi $t7, $zero, 3
    beq $t6, $t7, shift     # 11: 仅右移
    addi $t7, $zero, 1
    beq $t6, $t7, add_op    # 01: 加被乘数
    addi $t7, $zero, 2
    beq $t6, $t7, sub_op    # 10: 减被乘数
    
add_op:
    add $t3, $t3, $t1       # 部分积 += 被乘数
    j shift
    
sub_op:
    sub $t3, $t3, $t1       # 部分积 -= 被乘数

shift:
    # 保存乘数最低位到附加位
    andi $t4, $t2, 1        # $t4 = $t2[0]
    
    # 右移部分积，并提取其最低位
    andi $t0, $t3, 1        # 保存部分积最低位到$t0
    sra $t3, $t3, 1         # 部分积算术右移1位
    
    # 右移乘数，并将部分积的最低位插入其最高位
    srl $t2, $t2, 1         # 乘数逻辑右移1位
    sll $t0, $t0, 31        # 将部分积的最低位左移到最高位
    or $t2, $t2, $t0        # 合并到乘数
    
    # 更新计数器
    addi $t5, $t5, -1
    bne $t5, $zero, loop
    
    # 根据符号调整结果（结果在$t3:$t2中）
    beq $s7, $zero, end_program
    # 负结果：取补码
    nor $t3, $t3, $zero     # 先取反
    nor $t2, $t2, $zero     # 先取反
    addi $t2, $t2, 1        # 低位加1
    beq $t2, $zero, carry   # 如果低位为0，说明有进位
    j end_program
carry:
    addi $t3, $t3, 1        # 高位加1
    
end_program:
    # 最终结果在$t3:$t2中
    
    # 程序结束
    addi $v0, $zero, 10
    syscall
