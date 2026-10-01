# 交叉验证使用指南

## 目标

通过对比MARS和Vivado的仿真结果，验证自定义CPU的正确性。

## 文件说明

1. **cross_verify.asm** - MARS标准MIPS版本
2. **cross_verify_pcpu.asm** - 自定义CPU版本  
3. **cross_verify_pcpu.coe** - COE文件（已生成）
4. **assembler.py** - 汇编器

## 步骤1：在MARS中运行

1. 打开MARS，加载 `cross_verify.asm`
2. 点击 **Run → Assemble (F3)**
3. 点击 **Run → Go (F5)**
4. 程序运行完成后，查看 **Data Segment** 窗口
5. 找到 `result_array` 的地址（通常是0x10010000）
6. 记录地址+0到+60（共16个字）的值

### 预期MARS结果：

```
地址 +0:  0  1  1  2  3  5  8  13
地址+20: 21 34 88 150 50 15 255 240
```

## 步骤2：在Vivado中运行

### 2.1 加载COE文件到IMEM

1. 在Vivado中打开项目
2. Sources → IP Sources → dist_mem_gen_0
3. 右键 → **Re-customize IP**
4. 在 "COE File" 选项中，浏览并选择 `cross_verify_pcpu.coe`
5. 点击 **OK** 
6. 右键 IP → **Generate Output Products**
7. 等待生成完成

### 2.2 使用测试bench

使用`PCPU_tb_minimal.v`进行测试：

```verilog
// 在仿真结束后查看内存
$display("MEM[0-9]: %d %d %d %d %d %d %d %d %d %d",
         uut.dmem.mem[0], uut.dmem.mem[1], uut.dmem.mem[2],
         uut.dmem.mem[3], uut.dmem.mem[4], uut.dmem.mem[5],
         uut.dmem.mem[6], uut.dmem.mem[7], uut.dmem.mem[8],
         uut.dmem.mem[9]);
```

### 2.3 运行仿真

1. 右键 `PCPU_tb_minimal.v` → **Set as Top**
2. **Flow → Run Simulation → Run Behavioral Simulation**
3. 运行完成后查看TCL Console输出

## 步骤3：对比结果

### 手动对比

对比MARS Data Segment和Vivado仿真输出：

| 地址偏移 | 说明   | MARS | Vivado | 状态 |
| -------- | ------ | ---- | ------ | ---- |
| 0        | fib(0) | 0    | ?      |      |
| 4        | fib(1) | 1    | ?      |      |
| 8        | fib(2) | 1    | ?      |      |
| 12       | fib(3) | 2    | ?      |      |
| 16       | fib(4) | 3    | ?      |      |
| 20       | fib(5) | 5    | ?      |      |
| 24       | fib(6) | 8    | ?      |      |
| 28       | fib(7) | 13   | ?      |      |
| 32       | fib(8) | 21   | ?      |      |
| 36       | fib(9) | 34   | ?      |      |
| 40       | sum    | 88   | ?      |      |
| 44       | add    | 150  | ?      |      |
| 48       | sub    | 50   | ?      |      |
| 52       | and    | 15   | ?      |      |
| 56       | or     | 255  | ?      |      |
| 60       | xor    | 240  | ?      |      |

## 测试程序说明

### 测试1：斐波那契数列
- 计算前10项：0, 1, 1, 2, 3, 5, 8, 13, 21, 34
- 存储在MEM[0]到MEM[36]

### 测试2：求和
- 计算所有斐波那契数的和：88
- 存储在MEM[40]

### 测试3：算术运算
- 100 + 50 = 150 → MEM[44]
- 100 - 50 = 50 → MEM[48]

### 测试4：逻辑运算
- 255 & 15 = 15 → MEM[52]
- 255 | 15 = 255 → MEM[56]
- 255 ^ 15 = 240 → MEM[60]

## 常见问题

### Q1: MARS中找不到result_array？
A: 在Data Segment窗口，滚动到数据段起始地址（0x10010000），你的数据就在那里。

### Q2: Vivado仿真链接失败？
A: 确保IP核已经生成Output Products。

### Q3: 结果不匹配怎么办？
A: 
1. 检查COE文件是否正确加载
2. 查看波形，单步调试
3. 检查特定指令的实现

## 快速命令

```powershell
# 生成COE
python assembler.py cross_verify_pcpu.asm cross_verify_pcpu.coe

# 查看生成的机器码
Get-Content cross_verify_pcpu.coe
```

## 预期结果

如果CPU实现正确，所有16个测试点都应该匹配！✓
