.text
main:
	#$2-$6存放排序的数据
	addi $2, $zero, 6
    addi $3, $zero, 6
    addi $4, $zero, 6
   	addi $5, $zero, 6
    addi $6, $zero, 6

# 第一轮比较
round1_cmp1:
    slt $t0, $3, $2 # 如果$3 < $2，则$t0=1
    beq $t0, $zero, round1_cmp2 # 如果不需要交换，跳过
    # $3>=$2,交换二者的值
    add $t1, $3, $zero
    add $3, $2, $zero
    add $2, $t1, $zero
    
round1_cmp2:
    slt $t0, $4, $3
    beq $t0, $zero, round1_cmp3
    add $t1, $4, $zero
    add $4, $3, $zero
    add $3, $t1, $zero
    
round1_cmp3:
    slt $t0, $5, $4
    beq $t0, $zero, round1_cmp4
    add $t1, $5, $zero
    add $5, $4, $zero
    add $4, $t1, $zero
    
round1_cmp4:
    slt $t0, $6, $5
    beq $t0, $zero, round2_cmp1
    add $t1, $6, $zero
    add $6, $5, $zero
    add $5, $t1, $zero
    
# 第二轮比较
round2_cmp1:
    slt $t0, $3, $2
    beq $t0, $zero, round2_cmp2
    add $t1, $3, $zero
    add $3, $2, $zero
    add $2, $t1, $zero
    
round2_cmp2:
    slt $t0, $4, $3
    beq $t0, $zero, round2_cmp3
    add $t1, $4, $zero
    add $4, $3, $zero
    add $3, $t1, $zero
    
round2_cmp3:
    slt $t0, $5, $4
    beq $t0, $zero, round3_cmp1
    add $t1, $5, $zero
    add $5, $4, $zero
    add $4, $t1, $zero
    
# 第三轮比较
round3_cmp1:
    slt $t0, $3, $2
    beq $t0, $zero, round3_cmp2
    add $t1, $3, $zero
    add $3, $2, $zero
    add $2, $t1, $zero
    
round3_cmp2:
    slt $t0, $4, $3
    beq $t0, $zero, round4_cmp1
    add $t1, $4, $zero
    add $4, $3, $zero
    add $3, $t1, $zero
    
# 第四轮比较
round4_cmp1:
    slt $t0, $3, $2
    beq $t0, $zero, end_program
    add $t1, $3, $zero
    add $3, $2, $zero
    add $2, $t1, $zero
    
end_program:
    #addi $v0, $zero, 10
    #syscall
