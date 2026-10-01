   .set noat
   .set noreorder
   .set nomacro
   
    .org 0x0
   .text
   .align 4
   .global _start
_start:

# ####################   第一段   ##############################

   lui $1,0x1000
   ori $1,$1,0x0003
   ori $2,$0,0x80
   sb  $2,0x0($1)    # 向地址 0x10000003 写入 0x80
                     # 0x10000003 对应 UART 控制器的 Line Control Register

   lui $1,0x1000
   ori $1,$1,0x0001
   ori $2,$0,0x02
   sb  $2,0x0($1)    # 向地址 0x10000001 写入0x02，此时对应的是分频系数的高字节

   lui $1,0x1000
   ori $1,$1,0x0000
   ori $2,$0,0x8B
   sb  $2,0x0($1)    # 向地址 0x10000000 写入 0x8B，此时对应的是分频系数的低字节 

   lui $1,0x1000
   ori $1,$1,0x0003
   ori $2,$0,0x03
   sb  $2,0x0($1)    # 向地址 0x10000003 写入0x03
                     # 0x10000003 对应 UART 控制器的 Line Control Register
                     # 设置 LCR 为 0x03，表示 8 位数据位、没有奇偶校验位、1 位停止位

# ####################   第二段 GPIO 模块初始化  ##############################

   lui $1,0x2000
   ori $1,$1,0x0008
   lui $2,0xffff
   ori $2,$2,0xffff
   sw  $2,0x0($1)    # 使能所有 GPIO 输出端口

   lui $1,0x2000
   ori $1,$1,0x000c
   lui $2,0x0000
   ori $2,$2,0x0000
   sw  $2,0x0($1)    # 禁止 GPIO 输入中断

# #################   第三段 等待 SDRAM 初始化完毕   ###################

_waiting_sdram_init_done:
   lui $1,0x2000
   ori $1,$1,0x0000
   lw  $4,0x0($1)    # 获取 GPIO 的输入
   srl $4,$4,0x10
   
   andi $4,$4,0x0001 # 判断第 16 位是否为 1
   beq $4,$0,_waiting_sdram_init_done
   nop

# #################   第四段 显示启动开始字符串   ######################

   li $1,0x1
   la $2,_BootBeginInfoStr     # 启动开始字符串的地址
   la $3,_BootBeginInfoStrLen  # 启动开始字符串的长度
   lb $5,0x0($3)
1:
   lb $4,0x0($2)               # 启动开始字符串中的字符
   jal _print                  # 显示该字符
   addi $2,$2,0x1              # 指向下一个字符
   bne $5,$0,1b 
   subu $5,$5,$1

# ###############   第五段 获取 OS 的长度信息   ##################

   li $5,0x4
   lui $1,0x3000
   ori $1,$1,0x0300
   lw  $1,0x0($1)             # 获取 Flash 的 0x300 处存放的 OS 长度信息
                              # 保存到寄存器 $1
   nop   

# ###############   第六段 将 OS 复制到 SDRAM  ###################

   lui $2,0x0000              # 寄存器 $2 指向 SDRAM 地址空间
   lui $3,0x3000            
   ori $3,$3,0x0304           # 寄存器 $3 指向 Flash 中存放 OS 的地址
1:
   lw $4,0x0($3)              # 读取 OS 的内容
   nop
   sw $4,0x0($2)              # 复制到 SDRAM
   addi $2,$2,0x4
   addi $3,$3,0x4
   nop 
   bgez $1,1b                 # 寄存器 $1 存储的是长度信息，每复制一个字，该值减 4 
                              # 当该值为 0 时，表示复制完毕
   subu $1,$1,$5

# ###############   第七段 显示启动结束字符串   ########################

   li $1,0x1
   la $2,_BootEndInfoStr      # 启动结束字符串的地址
   la $3,_BootEndInfoStrLen   # 启动结束字符串的长度
   lb $5,0x0($3)
1:
   lb $4,0x0($2)
   jal _print
   addi $2,$2,0x1
   bne $5,$0,1b 
   sub $5,$5,$1

   jr $0
   nop 

# ####################   第八段 串口输出函数   #######################

_print:
   lui $6,0x1000
   ori $6,$6,0x0
   sb $4,0x0($6)
_waiting_transmit_done:
   lui $6,0x1000
   ori $6,$6,0x0005
   lb  $7,0x0($6)    # 获取 UART 控制器中 Line Status 寄存器的值

   andi $7,$7,0x20   # 检查 LS 寄存器的第 5bit “发送 FIFO 空标志”是否为 1
   beq $7,$0,_waiting_transmit_done
   nop
   jr $31            # 返回，寄存器 $31 存储的是链接地址
   nop

# ##################   第九段 一些预定义信息   #######################
   
   .data
_BootBeginInfoStr:
   .ascii "Loading OS into SDRAM...\n"
_BootBeginInfoStrLen:
   .byte 26
_BootEndInfoStr:
   .ascii "Load OS into SDRAM DONE!!!\n"
_BootEndInfoStrLen:
   .byte 28
