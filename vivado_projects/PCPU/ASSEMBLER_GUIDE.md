# MIPS汇编器使用指南

## 功能说明

这个汇编器可以将**MIPS标准格式**的汇编程序转换为您的自定义CPU的COE文件。

## 支持的指令格式

### 1. R型指令 (寄存器-寄存器运算)

```assembly
# 算术/逻辑运算: operation $rd, $rs, $rt
add  $s0, $t0, $t1      # $s0 = $t0 + $t1
sub  $s1, $t0, $t1      # $s1 = $t0 - $t1
and  $s2, $t0, $t1      # $s2 = $t0 & $t1
or   $s3, $t0, $t1      # $s3 = $t0 | $t1
xor  $s4, $t0, $t1      # $s4 = $t0 ^ $t1

# 移位运算: operation $rd, $rt, shamt
sll  $s0, $t0, 2        # $s0 = $t0 << 2
srl  $s1, $t0, 2        # $s1 = $t0 >> 2 (逻辑右移)
sra  $s2, $t0, 2        # $s2 = $t0 >> 2 (算术右移)

# 比较运算: cmp $rs, $rt
cmp  $t0, $t1           # 比较 $t0 和 $t1

# 伪指令
move $t0, $t1           # $t0 = $t1 (实际为 add $t0, $t1, $zero)
```

### 2. I型指令 (立即数运算)

```assembly
# 立即数加法: addi $rt, $rs, imm
addi $t0, $zero, 100    # $t0 = 0 + 100 = 100
addi $t1, $t0, -5       # $t1 = $t0 - 5

# 内存访问: lw/sw $rt, offset($rs)
lw   $t0, 0($sp)        # $t0 = MEM[$sp + 0]
lw   $t1, 4($sp)        # $t1 = MEM[$sp + 4]
sw   $t0, 8($sp)        # MEM[$sp + 8] = $t0
sw   $t1, 12($s0)       # MEM[$s0 + 12] = $t1

# 分支指令: beq/blt $rs, $rt, label
beq  $t0, $t1, equal    # if ($t0 == $t1) goto equal
blt  $t0, $t1, less     # if ($t0 < $t1) goto less
```

### 3. J型指令 (跳转)

```assembly
# 无条件跳转: j label
j    main               # 跳转到 main 标签
```

### 4. 特殊指令

```assembly
nop                     # 空操作
halt                    # 停机
```

## 支持的寄存器名称

### 数字形式 ($0-$31)
```assembly
$0, $1, $2, ..., $31
```

### MIPS标准别名
| 别名    | 编号 | 用途       | 别名    | 编号  | 用途       |
| ------- | ---- | ---------- | ------- | ----- | ---------- |
| $zero   | 0    | 常量0      | $s0-$s7 | 16-23 | 保存寄存器 |
| $at     | 1    | 汇编器临时 | $t8-$t9 | 24-25 | 临时寄存器 |
| $v0-$v1 | 2-3  | 返回值     | $k0-$k1 | 26-27 | 内核保留   |
| $a0-$a3 | 4-7  | 函数参数   | $gp     | 28    | 全局指针   |
| $t0-$t7 | 8-15 | 临时寄存器 | $sp     | 29    | 栈指针     |
|         |      |            | $fp     | 30    | 帧指针     |
|         |      |            | $ra     | 31    | 返回地址   |

**两种形式等价:**
```assembly
addi $8, $0, 10         # 数字形式
addi $t0, $zero, 10     # 别名形式 (推荐使用，更清晰)
```

## 标签和注释

### 标签定义
```assembly
main:                   # 标签后跟冒号
    addi $t0, $zero, 1
    
loop:
    addi $t0, $t0, 1
    beq  $t0, $t1, done
    j    loop
    
done:
    halt
```

### 注释
```assembly
# 这是注释 (推荐使用 #)
; 这也是注释 (也支持分号)
addi $t0, $zero, 10     # 行尾注释
```

## 完整示例

### 示例1: 简单的加法程序
```assembly
# 计算 a + b + c
main:
    addi $t0, $zero, 10     # a = 10
    addi $t1, $zero, 20     # b = 20
    addi $t2, $zero, 30     # c = 30
    
    add  $s0, $t0, $t1      # sum = a + b
    add  $s0, $s0, $t2      # sum = sum + c
    
    halt
```

### 示例2: 循环求和 (1+2+...+10)
```assembly
# 计算 sum = 1 + 2 + ... + n
main:
    addi $t0, $zero, 10     # n = 10
    addi $t1, $zero, 0      # i = 0
    addi $s0, $zero, 0      # sum = 0
    
loop:
    addi $t1, $t1, 1        # i++
    add  $s0, $s0, $t1      # sum += i
    blt  $t1, $t0, loop     # if (i < n) goto loop
    
    halt
```

### 示例3: 斐波那契数列
```assembly
# 计算斐波那契数列前10项
main:
    addi $t0, $zero, 0      # fib[0] = 0
    addi $t1, $zero, 1      # fib[1] = 1
    addi $t2, $zero, 10     # n = 10
    addi $t3, $zero, 2      # i = 2
    
    # 存储前两项
    sw   $t0, 0($sp)        # MEM[sp+0] = fib[0]
    sw   $t1, 4($sp)        # MEM[sp+4] = fib[1]
    
fib_loop:
    add  $t4, $t0, $t1      # fib[i] = fib[i-1] + fib[i-2]
    
    # 存储当前项
    sll  $t5, $t3, 2        # offset = i * 4
    add  $t6, $sp, $t5      # address = sp + offset
    sw   $t4, 0($t6)        # MEM[address] = fib[i]
    
    # 更新
    move $t0, $t1           # fib[i-2] = fib[i-1]
    move $t1, $t4           # fib[i-1] = fib[i]
    addi $t3, $t3, 1        # i++
    
    blt  $t3, $t2, fib_loop # if (i < n) goto fib_loop
    
    halt
```

## 使用方法

### 命令行
```powershell
# 基本用法
python assembler.py input.asm

# 指定输出文件
python assembler.py input.asm output.coe

# 查看帮助
python assembler.py
```

### 输出
```
============================================================
Assembling: test_mips.asm
============================================================

[Labels]
  main                 -> PC =    0 (0x00000000)
  loop                 -> PC =    4 (0x00000004)
  done                 -> PC =    8 (0x00000008)

[Output]
  COE file: test_mips.coe
  Total instructions: 9
============================================================
Assembly completed successfully!
```

## 注意事项

### 1. 指令限制
您的CPU只支持16条指令，汇编器会拒绝不支持的指令:
```assembly
mul  $t0, $t1, $t2      # ❌ 不支持 (会显示警告)
div  $t0, $t1, $t2      # ❌ 不支持 (会显示警告)
```

### 2. 立即数范围
立即数是16位有符号数，范围: -32768 到 32767
```assembly
addi $t0, $zero, 32767  # ✓ 正确
addi $t0, $zero, 32768  # ❌ 超出范围
```

### 3. 分支偏移
分支指令的偏移是相对于PC+1的:
- 正偏移: 向后跳转
- 负偏移: 向前跳转
- 偏移范围: -32768 到 32767 条指令

### 4. 内存对齐
访存指令通常需要4字节对齐:
```assembly
lw  $t0, 0($sp)         # ✓ 对齐
lw  $t0, 4($sp)         # ✓ 对齐
lw  $t0, 2($sp)         # ⚠ 未对齐，可能出错
```

### 5. 寄存器$zero
寄存器$0 ($zero)永远是0，写入无效:
```assembly
addi $zero, $zero, 100  # ✓ 语法正确，但$zero仍为0
```

## 指令映射表

| MIPS标准   | 自定义CPU | 操作码 | 说明       |
| ---------- | --------- | ------ | ---------- |
| add        | ADD       | 0x02   | 加法       |
| sub        | SUB       | 0x03   | 减法       |
| and        | AND       | 0x04   | 按位与     |
| or         | OR        | 0x05   | 按位或     |
| xor        | XOR       | 0x06   | 按位异或   |
| sll        | SLL       | 0x07   | 逻辑左移   |
| srl        | SRL       | 0x08   | 逻辑右移   |
| sra        | SRA       | 0x09   | 算术右移   |
| addi/addiu | ADDI      | 0x0D   | 立即数加法 |
| lw         | LOAD      | 0x0B   | 加载字     |
| sw         | STORE     | 0x0C   | 存储字     |
| beq        | BZ        | 0x0E   | 相等分支   |
| blt        | BN        | 0x0F   | 小于分支   |
| j          | JMP       | 0x10   | 无条件跳转 |
| nop        | NOP       | 0x00   | 空操作     |
| -          | HALT      | 0x01   | 停机       |
| -          | CMP       | 0x0A   | 比较       |

## 常见错误

### 错误1: 立即数格式错误
```assembly
addi $t0, 10, $zero     # ❌ 错误: 参数顺序错误
addi $t0, $zero, 10     # ✓ 正确
```

### 错误2: 访存格式错误
```assembly
lw  $t0, $sp, 0         # ❌ 错误: 格式不对
lw  $t0, 0($sp)         # ✓ 正确
```

### 错误3: 标签未定义
```assembly
beq $t0, $t1, undefined # ⚠ 警告: 标签undefined未定义
```

### 错误4: 寄存器名错误
```assembly
addi $r0, $zero, 10     # ❌ 错误: 没有$r0寄存器
addi $t0, $zero, 10     # ✓ 正确
```

## 调试技巧

1. **查看生成的COE文件**: 确认机器码是否正确
2. **检查标签地址**: 确保跳转目标正确
3. **手工验证**: 对关键指令进行手工编码验证
4. **使用注释**: 大量使用注释说明每条指令的作用

## 高级技巧

### 技巧1: 利用$zero寄存器
```assembly
move $t0, $t1           # 等价于 add $t0, $t1, $zero
addi $t0, $zero, 0      # 清零 $t0
```

### 技巧2: 快速乘除(2的幂)
```assembly
sll  $t0, $t1, 3        # $t0 = $t1 * 8
srl  $t0, $t1, 2        # $t0 = $t1 / 4 (无符号)
```

### 技巧3: 条件执行
```assembly
    beq  $t0, $zero, skip   # if ($t0 == 0) skip next
    addi $s0, $s0, 1        # 只在 $t0 != 0 时执行
skip:
    # 继续
```

## 支持与反馈

如有问题或建议，请参考指令参考手册或查看CPU设计文档。
