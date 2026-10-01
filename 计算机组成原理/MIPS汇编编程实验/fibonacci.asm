.text
main:
	# 初始化F0和F1，设置项数n
	addi $2,$zero,0
	addi $3,$zero,1
	addi $4,$zero,10
	
	#如果n=0
	beq $4,$zero,case_zero
	
	#如果n=1
	addi $s0,$zero,1
	beq $4,$s0,case_one
	
	#else
	addi $t1,$4,-1 #t1寄存器中存放需要计算的次数，初始化为n-1
	j fib_loop
	
fib_loop:
	add $t2,$2,$3 #计算下一项的值，临时存放在t2
	addi $2,$3,0 #寄存器3挪到2
	addi $3,$t2,0 #寄存器t2挪到3
	addi $t1,$t1,-1 #计数器递减
	
	slt $t3,$zero,$t1 #如果$t1>0，$t3置1，否则置0
	bne $t3,$zero,fib_loop
	
	add $1,$3,0
	j end_program

case_zero:
	#n=0的情况
	addi $1,$zero,0
	j end_program
	
case_one:
	#n=1的情况
	addi $1,$3,0
	j end_program
	
end_program:
	addi $v0, $zero, 10
        syscall
