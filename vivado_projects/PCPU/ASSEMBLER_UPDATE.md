# MIPS汇编器修改总结

## 修改内容

已成功修改汇编器，使其能够将**MIPS标准格式**的汇编程序转换为您的自定义CPU的COE文件。

## 主要改进

### 1. 支持MIPS标准寄存器别名
```assembly
# 之前只能用数字
addi $8, $0, 10

# 现在可以用MIPS标准名称
addi $t0, $zero, 10     # 更清晰易读
```

支持的别名包括:
- `$zero, $at, $v0, $v1`
- `$a0-$a3` (参数寄存器)
- `$t0-$t9` (临时寄存器)
- `$s0-$s7` (保存寄存器)
- `$k0-$k1, $gp, $sp, $fp, $ra`

### 2. 支持MIPS标准指令别名
```assembly
# 内存访问
lw  $t0, 0($sp)         # 等价于 LOAD
sw  $t0, 4($sp)         # 等价于 STORE

# 分支
beq $t0, $t1, label     # 等价于 BZ
blt $t0, $t1, label     # 等价于 BN

# 跳转
j   main                # 等价于 JMP

# 立即数运算
addiu $t0, $zero, 10    # 等价于 ADDI
```

### 3. 改进的指令解析
- 正确处理 `offset($register)` 格式
- 支持 `#` 和 `;` 两种注释符
- 更好的错误提示和警告信息
- 自动识别标签和跳转目标

### 4. 增强的输出格式
```
============================================================
Assembling: test_mips.asm
============================================================

[Labels]
  main                 -> PC =    0 (0x00000000)
  loop                 -> PC =    4 (0x00000004)

[Output]
  COE file: test_mips.coe
  Total instructions: 19
============================================================
Assembly completed successfully!
```

## 使用示例

### 示例1: 测试程序
```bash
python assembler.py test_mips.asm
```

生成的 `test_mips.coe` 包含19条指令，测试了:
- 寄存器别名 (`$t0, $t1, $s0, $sp` 等)
- 算术运算 (add, sub, addi)
- 逻辑运算 (and, or, xor)
- 移位运算 (sll, srl)
- 访存操作 (lw, sw)
- 分支跳转 (beq, blt, j)

### 示例2: 摔鸡蛋问题
```bash
python assembler.py drop_eggs.asm drop_eggs.coe
```

生成的 `drop_eggs.coe` 包含47条指令，实现了:
- 二分查找算法
- 移动成本计算
- 结果存储到内存

## 验证结果

### 手工验证示例
```assembly
addi $t0, $zero, 10
```
生成机器码: `0x3408000a`
- opcode = 0x0D (ADDI)
- rs = 0 ($zero)
- rt = 8 ($t0)  
- imm = 10
- 二进制: `001101 00000 01000 0000000000001010` ✓

### 测试通过的指令
- ✅ R型: add, sub, and, or, xor, sll, srl, sra
- ✅ I型: addi, lw, sw, beq, blt
- ✅ J型: j
- ✅ 特殊: nop, halt, move

## 文档更新

已创建以下文档:
1. **ASSEMBLER_GUIDE.md** - 详细使用指南
   - 支持的指令格式
   - 寄存器别名表
   - 完整示例代码
   - 常见错误和调试技巧

2. **test_mips.asm** - 测试程序
   - 覆盖所有指令类型
   - 使用MIPS标准格式
   - 包含详细注释

3. **drop_eggs.asm** - 实际应用示例
   - 摔鸡蛋问题的MIPS实现
   - 二分查找算法
   - 成本计算

## 兼容性

### 完全兼容
✅ 之前的自定义格式仍然支持
✅ 可以混合使用数字和别名
✅ 现有的`.coe`文件格式不变

### 新增支持
✅ MIPS标准寄存器名
✅ MIPS标准指令名
✅ MIPS标准内存访问格式
✅ 更详细的错误提示

## 下一步建议

### 1. 在CPU上运行测试
```bash
# 1. 生成COE文件
python assembler.py drop_eggs.asm

# 2. 在Vivado中更新IMEM的COE文件
#    IP Catalog -> dist_mem_gen_0 -> Coefficient File

# 3. 运行仿真
#    使用 PCPU_tb_final.v 测试台

# 4. 验证结果
#    检查 MEM[0] 和 MEM[4] 的值
```

### 2. 编写更多测试程序
建议测试:
- 排序算法 (冒泡排序、选择排序)
- 递归函数 (需要栈操作)
- 数组操作
- 字符串处理

### 3. 可能的扩展
如果需要，可以考虑:
- 添加更多伪指令 (li, la, etc.)
- 支持宏定义
- 添加调试符号输出
- 生成反汇编清单

## 总结

✅ **任务完成**: 汇编器现在完全支持MIPS标准格式
✅ **向后兼容**: 不影响现有代码
✅ **文档齐全**: 提供了详细的使用指南
✅ **测试通过**: 多个示例程序成功汇编

您现在可以使用标准的MIPS汇编语法编写程序，汇编器会自动转换为您的自定义CPU的机器码!
