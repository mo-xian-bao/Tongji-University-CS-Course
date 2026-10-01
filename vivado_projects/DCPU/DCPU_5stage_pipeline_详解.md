# DCPU：五级动态流水线 CPU（MIPS 子集）超详细实现讲解

> 目标：把你当成完全零基础的初学者，从“每个周期发生什么”讲到“每根 wire/reg 的意义与为什么这么连”，让你不仅能看懂，还能复现本项目。
>
> 工程核心源码位于：
> - 顶层 CPU：[DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v)
> - 模块清单目录：[DCPU.srcs/sources_1/new](DCPU.srcs/sources_1/new)

---

## 0. 先建立你脑海里的“整体图”

这个 CPU 是典型 **五级流水线**：

- IF：取指（Instruction Fetch）
- ID：译码/读寄存器（Instruction Decode / Register Fetch）
- EX：执行（Execution，ALU、移位、乘除法、形成地址等）
- MEM：访存（Memory Access）
- WB：写回（Write Back）

流水线的核心思想：

- **每个周期**，五个阶段“同时”处理五条不同的指令（像工厂流水线）。
- 为了让每级能并行工作，需要在级与级之间放 **流水线寄存器**（例如 IF/ID、ID/EX、EX/MEM、MEM/WB），把上一级产生的信号“锁存”给下一级。

在本工程中，流水线寄存器都直接写在 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v) 里，用一堆 `reg` 表示。

---

## 1. 你需要知道的“内存/地址约定”

### 1.1 指令存储器 IMEM 的地址映射

见 [DCPU.srcs/sources_1/new/IMEM.v](DCPU.srcs/sources_1/new/IMEM.v)

- CPU 复位后 `PC` 初始化为 `0x0040_0000`（见 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v) 的 PC 更新逻辑）。
- IMEM 的读地址不是用整个 PC，而是用：
  - `PC_addr = PC[12:2] - 0x00400000`

这表示：
- 指令按 4 字节对齐（PC[1:0] 被丢掉），一次取 32 位指令。
- IMEM 里第 0 条指令对应 PC=0x0040_0000。

### 1.2 数据存储器 DMEM 的地址空间

见 [DCPU.srcs/sources_1/new/DMEM.v](DCPU.srcs/sources_1/new/DMEM.v)

- DMEM 是一个 1024 字节空间（256 个 32 位字）：
  - `reg [31:0] mem [0:255];`
- 地址解析：
  - `word_addr = addr[9:2]`（选择第几个 32 位字）
  - `byte_off = addr[1:0]`（字内第几个字节）

支持的访存类型通过 `mem_op[2:0]` 区分：

- `000=LW`  读 32 位
- `001=LB`  读 8 位，符号扩展
- `010=LBU` 读 8 位，零扩展
- `011=LH`  读 16 位，符号扩展
- `100=LHU` 读 16 位，零扩展
- `101=SW`  写 32 位
- `110=SB`  写 8 位
- `111=SH`  写 16 位

---

## 2. CPU 整体工作逻辑（以“一个时钟周期”为单位）

这一节最重要：你要能回答“同一个时钟沿到来时，IF/ID/EX/MEM/WB 各自做什么”。

### 2.1 时钟沿到来前（组合逻辑阶段）

在一个周期中，**大部分计算是组合逻辑**，例如：

- IF：用当前 `PC` 通过 IMEM 组合读出 `IF_instr`
- ID：用 IF/ID 寄存器中的指令做译码；RegFile 组合读出 `ID_rs_data` / `ID_rt_data`
- EX：ALU 组合计算；MDU 在时钟逻辑里跑，但启动信号在组合域决定
- MEM：DMEM 的读是组合的（只要 `re=1`），写是时钟沿
- WB：写回数据 `WB_write_data` 是组合选择

这些组合结果会在 **下一个上升沿** 被写进流水线寄存器（reg）。

### 2.2 时钟上升沿到来时（状态更新阶段）

在 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v) 中，依次有：

1. PC 寄存器更新：
   - 若 `rst`，PC=0x0040_0000
   - 否则若 `!stall`，PC <= `PC_next`
   - 否则（stall）PC 保持

2. IF/ID 寄存器更新：
   - 若 `rst`，清为 NOP
   - 否则若 `!stall`，锁存 `PC` 与 `IF_instr`
   - 否则保持

3. ID/EX 寄存器更新：
   - 若 `rst`，全部清零
   - 否则若 `stall || exc_occur`：插入气泡（把关键控制信号清 0）
   - 否则：把 ID 阶段的各类数据与控制信号锁存进去

4. EX/MEM 寄存器更新：
   - 若 `rst`，清零
   - 否则：锁存 EX 结果、rt 数据、控制等

5. MEM/WB 寄存器更新：
   - 若 `rst`，清零
   - 否则：锁存 MEM 的数据、EX/MEM 的结果与控制等

6. RegFile 写回：
   - 在 [DCPU.srcs/sources_1/new/RegFile.v](DCPU.srcs/sources_1/new/RegFile.v) 中，写回发生在上升沿：`if (we && Rdc != 0) regs[Rdc] <= Rd;`

---

## 3. “控制通路”与“数据通路”分开理解

- **数据通路**：数据怎么流（PC、指令、寄存器数据、ALU 结果、内存数据）。
- **控制通路**：每条指令要做什么（RegWrite、MemRead、ALUSrc、MemToReg、Branch、Jump…）。

本项目的控制生成主要由：

- 指令译码与控制信号生成：[DCPU.srcs/sources_1/new/Controller.v](DCPU.srcs/sources_1/new/Controller.v)
- 冒险检测与分支判断（决定 stall、branch_taken）：[DCPU.srcs/sources_1/new/HazardUnit.v](DCPU.srcs/sources_1/new/HazardUnit.v)
- 数据前推（解决 RAW 冒险）：[DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)

---

## 4. 顶层模块关系

### 4.1 仿真顶层 top

见 [DCPU.srcs/sources_1/new/top.v](DCPU.srcs/sources_1/new/top.v)

- `top` 只是把 `clk/rst/intr` 接到 `DCPU`，并把 `PC_out/instr_out` 输出出来。

### 4.2 Testbench

见 [DCPU.srcs/sources_1/new/DCPU_tb.v](DCPU.srcs/sources_1/new/DCPU_tb.v)

- 产生时钟、复位，并监视 PC/指令。
- 注意：仿真时间目前只跑 `#2000`（2us），如果你的程序更长，可能要加大。

---

## 5. DCPU.v：按流水级“拆开讲”

这部分是整份文档的核心。

### 5.1 IF 级（取指）

见 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v)

**关键寄存器/信号：**

- `reg [31:0] PC`：程序计数器
- `PC_plus_4 = PC + 4`：顺序执行的下一条
- `IF_instr`：IMEM 取出的指令（组合读）

**IMEM 的连接：**

- `.PC(PC)` 输入当前 PC
- `.Instr(IF_instr)` 输出当前指令

**你要记住：**

- IF 阶段唯一“状态”就是 PC。
- IF 的输出（指令、PC）要给 ID 用，因此必须进入 IF/ID 寄存器。

### 5.2 IF/ID 流水线寄存器

在 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v) 里：

- `reg [31:0] IF_ID_PC`：保存 IF 阶段的 PC
- `reg [31:0] IF_ID_instr`：保存 IF 阶段取到的指令

**更新规则：**

- `rst`：清为 NOP
- `stall`：保持（不让流水线往前走）
- 否则：`IF_ID_PC <= PC; IF_ID_instr <= IF_instr;`

> 重要：本工程没有对 branch/jump 做 IF/ID flush，而是采用“延迟槽”策略（下一节详说）。

### 5.3 ID 级（译码 + 读寄存器 + 早期分支判断）

**ID 级输入来自 IF/ID：**

- `IF_ID_instr`：当前要译码的指令
- `IF_ID_PC`：当前指令的 PC

#### 5.3.1 指令字段拆分（Controller 输出）

见 [DCPU.srcs/sources_1/new/Controller.v](DCPU.srcs/sources_1/new/Controller.v)

Controller 把 `instr[31:0]` 拆为：

- `opcode = instr[31:26]`
- `rs = instr[25:21]`
- `rt = instr[20:16]`
- `rd = instr[15:11]`
- `shamt = instr[10:6]`
- `funct = instr[5:0]`
- `imm = instr[15:0]`
- `addr = instr[25:0]`

并输出两种扩展：

- `imm_sign_ext = {{16{imm[15]}}, imm}`
- `imm_zero_ext = {16'b0, imm}`

DCPU 中再用 `ID_sign_ext` 决定到底用哪一种：

- `ID_imm_ext = ID_sign_ext ? ID_imm_sign_ext : ID_imm_zero_ext`

#### 5.3.2 RegFile：读两个寄存器

见 [DCPU.srcs/sources_1/new/RegFile.v](DCPU.srcs/sources_1/new/RegFile.v)

- 读端口是组合读：
  - `Rs = regs[Rsc]`（本项目用 `Rsc=ID_rs`）
  - `Rt = regs[Rtc]`（本项目用 `Rtc=ID_rt`）

在 DCPU 中：

- `ID_rs_data`：读到的 rs
- `ID_rt_data`：读到的 rt

#### 5.3.3 ID 级前推：让分支比较用“最新值”

见 [DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)

输出：

- `ID_rs_data_fwd`
- `ID_rt_data_fwd`

它们会被冒险单元用于分支比较。

> 为什么要 ID 前推？
>
> 因为分支在 ID 阶段判断（早期分支），如果 rs/rt 刚被前面的指令写回但还没进 RegFile，就会比较到旧值。

#### 5.3.4 分支/跳转目标计算

在 DCPU 中：

- `branch_target = IF_ID_PC + 4 + (ID_imm_ext << 2)`
- `jump_target   = {IF_ID_PC[31:28], ID_addr, 2'b00}`

#### 5.3.5 HazardUnit：决定 stall 与 branch_taken

见 [DCPU.srcs/sources_1/new/HazardUnit.v](DCPU.srcs/sources_1/new/HazardUnit.v)

它做四类事：

1) **Load-Use 冒险**

- 若 EX 阶段是 load（`ID_EX_mem_read=1`），并且它要写的寄存器等于当前 ID 阶段要读的 `rs/rt`，则必须 stall。

2) **MDU 冒险（乘除法忙）**

- MDU 是多周期。
- HazardUnit 认为当 `MDU_busy` 或者 `ID_EX_is_mdu_op`（表示“刚启动 MDU”的那条指令）为真时，MDU “真忙”。
- 若 ID 阶段现在又遇到 MDU 指令或 mfhi/mflo，就 stall。

3) **分支数据冒险**

- 分支在 ID 判断，如果分支依赖的数据还在 ID/EX 里产生，或 EX/MEM 的 load 还没拿到数据，也要 stall。

4) **分支条件判断（早期）**

- 用 `ID_rs_data_fwd` / `ID_rt_data_fwd` 做比较，输出 `branch_taken`。

### 5.4 ID/EX 流水线寄存器

这是非常重要的“信号打包点”：把 ID 产生的所有东西传给 EX。

在 DCPU 中，相关寄存器包括：

- 数据类：
  - `ID_EX_PC`
  - `ID_EX_rs_data`, `ID_EX_rt_data`
  - `ID_EX_imm_ext`
  - `ID_EX_rs`, `ID_EX_rt`, `ID_EX_rd`
  - `ID_EX_shamt`
  - `ID_EX_opcode`, `ID_EX_funct`

- 控制类：
  - `ID_EX_reg_write`
  - `ID_EX_mem_read`, `ID_EX_mem_write`, `ID_EX_mem_to_reg`
  - `ID_EX_alu_src`
  - `ID_EX_alu_op`
  - `ID_EX_write_reg`

- 移位/MDU/HI-LO/链接：
  - `ID_EX_is_shift`, `ID_EX_is_shift_v`
  - `ID_EX_is_mdu_op`, `ID_EX_mdu_op`
  - `ID_EX_is_mfhi`, `ID_EX_is_mflo`, `ID_EX_is_mthi`, `ID_EX_is_mtlo`
  - `ID_EX_is_link`

- CP0/异常：
  - `ID_EX_is_mfc0`, `ID_EX_is_mtc0`, `ID_EX_is_eret`
  - `ID_EX_is_syscall`, `ID_EX_is_break`, `ID_EX_is_teq`

**气泡插入（bubble / NOP）**

当：

- `stall == 1` 或 `exc_occur == 1`

DCPU 不会让 ID/EX 继续装载真实指令，而是把关键控制清零：

- `ID_EX_reg_write <= 0`
- `ID_EX_mem_read <= 0`
- `ID_EX_mem_write <= 0`
- `ID_EX_write_reg <= 0`
- 以及 MDU/CP0/异常相关控制清 0

这就等于向 EX 注入一条 NOP（不会写寄存器/不会访存/不会触发特殊行为），从而给流水线“喘口气”。

### 5.5 EX 级（执行/计算）

EX 级主要做：

- ALU 运算
- 移位（立即数移位或变量移位）
- MDU（乘除法）启动与 HI/LO 写入
- mfhi/mflo 读取 HI/LO
- 链接指令（jal/jalr）生成返回地址

#### 5.5.1 EX 级前推（最关键的 RAW 解决手段）

见 [DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)

输出：

- `EX_rs_data_fwd`
- `EX_rt_data_fwd`

在 DCPU 的 ALU/MDU 输入中都用到了前推后的数据。

> 为什么 EX 前推要从 EX/MEM 和 MEM/WB 两处来？
>
> - EX/MEM：上一条指令刚算完（通常是 ALU 结果），还没写回。
> - MEM/WB：再前一条指令的结果准备写回，也可能比 RegFile 更新更“新”。

#### 5.5.2 ALU 输入选择（包含移位特殊处理）

在 DCPU 中：

- `EX_alu_input_a` 的选择：
  - 如果 `ID_EX_is_shift`（如 sll/srl/sra 的立即移位）：A 取 `shamt`
  - 如果 `ID_EX_is_shift_v`（变量移位 sllv/srlv/srav）：A 取 `rs[4:0]`
  - 否则：A 取 `EX_rs_data_fwd`

- `EX_alu_input_b` 的选择：
  - 若 `ID_EX_alu_src`：B 取 `ID_EX_imm_ext`
  - 否则：B 取 `EX_rt_data_fwd`

并且 ALU 例化时对移位做了一个特别的 `b` 选择：

- `.b(ID_EX_is_shift_v ? EX_rt_data_fwd : EX_alu_input_b)`

这表示变量移位时：

- 位移量来自 `a`
- 被移位的数据来自 `rt`

#### 5.5.3 ALU 模块本身

见 [DCPU.srcs/sources_1/new/ALU.v](DCPU.srcs/sources_1/new/ALU.v)

输入：

- `a`, `b`：两个操作数
- `aluc[3:0]`：操作码

输出：

- `r`：运算结果
- `zero/carry/negative/overflow`：标志

ALU 支持：add/addiu/sub/subu/and/or/xor/nor/slt/sltu/sll/srl/sra/lui/clz 等。

#### 5.5.4 MDU（乘除法单元）与 HI/LO

见 [DCPU.srcs/sources_1/new/MDU.v](DCPU.srcs/sources_1/new/MDU.v)

- MDU 是一个简单状态机，启动后 busy 拉高，经过若干周期后输出 HI/LO 并拉低 busy。
- DCPU 通过：
  - `start = ID_EX_is_mdu_op && !MDU_busy`

来启动一次运算。

DCPU 内部有：

- `HI_reg`、`LO_reg`：真实的 HI/LO 寄存器
- `MDU_busy_prev`：用于检测 `busy` 的下降沿

当检测到 busy 从 1 变 0 时：

- `HI_reg <= MDU_HI`
- `LO_reg <= MDU_LO`

另外，mthi/mtlo 会直接写 HI_reg/LO_reg。

mfhi/mflo 在 EX 级通过 `EX_result` 选择输出。

#### 5.5.5 EX 级最终结果选择 EX_result

DCPU 用一个多路选择得到 EX/MEM 要锁存的结果：

- mfhi：输出 HI_reg
- mflo：输出 LO_reg
- link：输出 `ID_EX_PC + 8`（典型 MIPS 约定：jal 写回的是“延迟槽之后”的地址）
- 否则：输出 ALU 结果

### 5.6 EX/MEM 流水线寄存器

把 EX 的计算结果与控制传给 MEM。

关键寄存器：

- `EX_MEM_alu_result`：其实是 EX_result（可能是 ALU/HI/LO/link）
- `EX_MEM_rt_data`：用于 store 写内存的数据（已前推）
- `EX_MEM_PC`：当前指令 PC（用于异常 EPC 记录）
- `EX_MEM_write_reg`：要写回的寄存器号
- `EX_MEM_reg_write / mem_read / mem_write / mem_to_reg`：控制
- `EX_MEM_opcode`：用于在 MEM 阶段决定 mem_op
- `EX_MEM_is_mfc0 / is_mtc0 / is_eret / is_syscall / is_break / is_teq`：CP0/异常相关
- `EX_MEM_rd`：给 CP0 的寄存器索引（注意：这里用的是 `ID_EX_rd`）

### 5.7 MEM 级（访存 + CP0 异常）

#### 5.7.1 DMEM 访问

DCPU 中用 `EX_MEM_opcode` 转成 `mem_op`，再驱动 DMEM：

- `.addr(EX_MEM_alu_result)`：地址来自 EX 计算（例如 base+offset）
- `.data_in(EX_MEM_rt_data)`：store 写入数据
- `.we(EX_MEM_mem_write)`
- `.re(EX_MEM_mem_read)`
- `.data_out(MEM_read_data)`

#### 5.7.2 CP0（精确异常）

见 [DCPU.srcs/sources_1/new/CP0.v](DCPU.srcs/sources_1/new/CP0.v)

DCPU 里把异常定义成：

- `EX_MEM_is_syscall` 或 `EX_MEM_is_break` 或
- `EX_MEM_is_teq && (EX_MEM_alu_result == 0)`

并给出 `cause` 编码：

- syscall -> 8
- break   -> 9
- teq     -> 13

CP0 的行为要点：

- exception 触发时保存 EPC（这里写 `pc + 4`）
- status 左移 5 位“压栈”并关闭中断（简化实现）
- eret 时 status 右移恢复

> 注意：DCPU 的 PC_next 在异常发生时直接跳 `0x00400004`，eret 时跳 `CP0_exc_addr`。

### 5.8 MEM/WB 流水线寄存器

把：

- `EX_MEM_alu_result`
- `MEM_read_data`
- `CP0_rdata`

锁存到：

- `MEM_WB_alu_result`
- `MEM_WB_mem_data`
- `MEM_WB_cp0_data`

并锁存写回控制：

- `MEM_WB_write_reg`
- `MEM_WB_reg_write`
- `MEM_WB_mem_to_reg`
- `MEM_WB_is_mfc0`

### 5.9 WB 级（写回）

写回数据由一个三选一决定：

- 若是 mfc0：写回 CP0 读数据
- 否则若 mem_to_reg：写回内存读数据
- 否则：写回 ALU/EX_result

最后写入 RegFile：

- `we = MEM_WB_reg_write`
- `Rdc = MEM_WB_write_reg`
- `Rd = WB_write_data`

---

## 6. “动态流水线”的关键：冒险处理策略

你要能说清楚三件事：

1) 为什么会有冒险
2) 这个项目怎么检测
3) 这个项目怎么解决

### 6.1 数据冒险（RAW）

典型场景：

- 指令1：`add $t0, $t1, $t2`（结果写 $t0）
- 指令2：`sub $t3, $t0, $t4`（马上就读 $t0）

如果没有前推：

- 指令2 在 EX 级需要 $t0，但指令1 还没写回 RegFile。

解决：

- ForwardUnit 从 EX/MEM 或 MEM/WB 把“最新结果”送回 EX 的输入。

见 [DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)

### 6.2 Load-Use 冒险（必须 stall 的经典情况）

场景：

- 指令1：`lw $t0, 0($t1)`
- 指令2：`add $t2, $t0, $t3`

原因：

- lw 的数据要到 MEM 阶段才从 DMEM 出来。
- 指令2 的 EX 阶段用数据时，lw 的数据还不存在（前推也没用）。

解决：

- HazardUnit 检测到 `ID_EX_mem_read` 且 `ID_EX_write_reg` 等于 ID 的 rs/rt，就 stall。

### 6.3 分支冒险（ID 早期判断 + 延迟槽）

这个项目的分支策略可以这样理解：

- 分支是否成立：在 ID 阶段用前推后的数据判断
- PC_next：在同一周期组合算出
- 真正更新 PC：在下一个上升沿

因此：

- 分支指令在 ID 阶段时，IF 阶段已经取到了顺序下一条（PC+4）的指令
- 下一周期，这条顺序指令进入 ID（它就是“延迟槽指令”）
- 同时 PC 已经跳到分支目标（如果 branch_taken=1）

> 所以：这套实现天然符合“分支有一个延迟槽”。

为了让分支比较正确：

- ID 阶段比较使用 `ID_rs_data_fwd` / `ID_rt_data_fwd`

为了避免分支比较用到“还没准备好的值”：

- HazardUnit 还会对 branch 的数据依赖做 stall

### 6.4 MDU 冒险（多周期结构冒险）

MDU 运算会占用多个周期。

- 当 MDU busy 时，再来 mult/div 或 mfhi/mflo 会出错
- HazardUnit 因此在 MDU 忙时 stall

---

## 7. PC 更新逻辑（优先级非常重要）

在 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v) 中：

PC_next 优先级（从高到低）：

1) 异常 `exc_occur`：跳到 `0x00400004`
2) eret `eret_occur`：跳到 `CP0_exc_addr`（EPC）
3) jr：`ID_rs_data_fwd`
4) jump：`jump_target`
5) branch_taken：`branch_target`
6) 默认：`PC_plus_4`

并且：

- `stall` 时 PC 不更新

---

## 8. 每个模块“逐端口/逐变量”说明（可复现级别）

这一节把你能看到的每个模块都按“输入/输出/内部关键变量/行为”讲清。

### 8.1 Controller：译码与控制信号生成

文件：[DCPU.srcs/sources_1/new/Controller.v](DCPU.srcs/sources_1/new/Controller.v)

**输入：**

- `instr[31:0]`：来自 IF/ID 的指令

**输出（分三类）：**

A. 字段拆分

- `opcode/funct/rs/rt/rd/shamt/imm/addr`
- `imm_sign_ext/imm_zero_ext`

B. 基本控制

- `reg_write`：是否写回通用寄存器
- `mem_read/mem_write`：是否访问数据存储器
- `mem_to_reg`：写回来自 MEM 还是 ALU
- `alu_src`：ALU 第二操作数来自立即数还是 rt
- `reg_dst`：写回寄存器号选择（rt/rd/$31）
- `alu_op`：ALU 操作码
- `write_reg`：最终写回寄存器号
- `sign_ext`：立即数扩展类型（符号/零）

C. 分支/跳转/特殊

- `is_branch/is_jump/is_jr/is_link`
- `branch_type`
- `is_shift/is_shift_v`
- `is_mdu_op/mdu_op`
- `is_mfhi/is_mflo/is_mthi/is_mtlo`
- `is_mfc0/is_mtc0/is_eret`
- `is_syscall/is_break/is_teq`

> 学习建议：你可以先把 `reg_write/mem_read/mem_write/mem_to_reg/alu_src/write_reg/alu_op` 看懂，就已经能“复现一个最小流水线 CPU”。

### 8.2 RegFile：32×32 通用寄存器堆

文件：[DCPU.srcs/sources_1/new/RegFile.v](DCPU.srcs/sources_1/new/RegFile.v)

- `regs[31:0]`：寄存器数组
- 异步读：组合输出 `Rs/Rt`
- 同步写：上升沿写入 `regs[Rdc] <= Rd`（且禁止写 $0）

### 8.3 ALU：算术逻辑单元

文件：[DCPU.srcs/sources_1/new/ALU.v](DCPU.srcs/sources_1/new/ALU.v)

- `aluc[3:0]` 决定具体运算
- 输出结果与标志位

### 8.4 IMEM：指令存储器（Vivado IP）

文件：[DCPU.srcs/sources_1/new/IMEM.v](DCPU.srcs/sources_1/new/IMEM.v)

- 将 PC 映射到 IP 的地址 `a`，输出 `spo` 为指令

### 8.5 DMEM：数据存储器

文件：[DCPU.srcs/sources_1/new/DMEM.v](DCPU.srcs/sources_1/new/DMEM.v)

- 读：组合逻辑，根据 mem_op 做截取/扩展
- 写：时序逻辑，根据 mem_op 做字节/半字写

### 8.6 ForwardUnit：数据前推

文件：[DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)

它做两套前推：

- ID 前推：给分支比较用
- EX 前推：给 ALU/MDU 用

**特别点：**

- ID 前推时，如果 EX/MEM 正在做 load（`EX_MEM_mem_read=1`），它不会从 EX/MEM 前推（因为此时 EX/MEM 还没有 load 数据）。

### 8.7 HazardUnit：冒险检测 + 分支判断

文件：[DCPU.srcs/sources_1/new/HazardUnit.v](DCPU.srcs/sources_1/new/HazardUnit.v)

- 输出 `stall`：让 PC 与 IF/ID 保持、让 ID/EX 注入气泡
- 输出 `branch_taken`：决定 PC_next 是否选择 branch_target

### 8.8 MDU：乘除法单元

文件：[DCPU.srcs/sources_1/new/MDU.v](DCPU.srcs/sources_1/new/MDU.v)

- start 拉高时锁存输入并进入计算状态
- busy 表示正在计算
- 结束时输出 HI/LO，并拉低 busy

### 8.9 CP0（CPO）：简化异常协处理器

文件：[DCPU.srcs/sources_1/new/CP0.v](DCPU.srcs/sources_1/new/CP0.v)

- `cp0_regs[31:0]`：内部寄存器堆
- 12: Status，13: Cause，14: EPC
- exception 时：
  - EPC <= pc + 4
  - Cause.ExcCode <= cause
  - Status 左移 5 位（保存并关闭中断）
- eret 时：Status 右移 5 位恢复

---

## 9. 如何复现实验/项目（你按这个做就能跑起来）

### 9.1 指令初始化（COE）

工程根目录下有两个脚本：

- [gen_coe.py](gen_coe.py)
- [gen_coe_v2.py](gen_coe_v2.py)

它们会把内置汇编源码转成 `.coe` 初始化文件。

其中 v2 版本会在分支/跳转后自动插入 NOP，用于匹配“延迟槽/避免控制冒险”的简化处理方式。

### 9.2 验证用汇编程序

见 [verify_algorithm.asm](verify_algorithm.asm)

这份注释非常完整，你可以对照它理解：

- DMEM 的数组布局（a/b/c/d 在不同基地址）
- 每一段 range1/range2/range3 对应不同运算

### 9.3 仿真入口

- 仿真顶层是 [DCPU.srcs/sources_1/new/DCPU_tb.v](DCPU.srcs/sources_1/new/DCPU_tb.v)
- 它例化了 [DCPU.srcs/sources_1/new/top.v](DCPU.srcs/sources_1/new/top.v)
- top 再例化 [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v)

---

## 10. 初学者最容易卡住的点（你可以用它做自测）

1) 为什么 stall 时 PC 和 IF/ID 要保持？
- 因为你不希望“新指令继续进入流水线”，否则冒险仍会发生。

2) 为什么 stall 时要给 ID/EX 插入气泡？
- 因为 EX 级不应该继续执行“那条有问题的指令的后继指令”，气泡能让流水线空转一个周期等待数据。

3) 为什么 load-use 只能 stall，前推不行？
- 因为 load 的数据直到 MEM 级才出现，而下一条指令在 EX 级就需要它。

4) 为什么这个设计说用了延迟槽？
- 因为 branch_taken 在 ID 决定，PC 在下周期跳转，而顺序下一条已经被取出并进入 ID，天然成为延迟槽。

5) 为什么 link 写回是 `PC + 8`？
- MIPS 的 jal/jalr 在有延迟槽时，返回地址是“延迟槽之后”的地址。

---

## 11. 你下一步怎么学（建议路线）

建议你按这个顺序看代码：

1) [DCPU.srcs/sources_1/new/DCPU.v](DCPU.srcs/sources_1/new/DCPU.v)（抓总：看懂流水线寄存器与 PC_next）
2) [DCPU.srcs/sources_1/new/Controller.v](DCPU.srcs/sources_1/new/Controller.v)（看懂控制信号怎么生成）
3) [DCPU.srcs/sources_1/new/ForwardUnit.v](DCPU.srcs/sources_1/new/ForwardUnit.v)（看懂数据前推为什么这么选）
4) [DCPU.srcs/sources_1/new/HazardUnit.v](DCPU.srcs/sources_1/new/HazardUnit.v)（看懂 stall 的三类原因）
5) [DCPU.srcs/sources_1/new/DMEM.v](DCPU.srcs/sources_1/new/DMEM.v)（看懂 lb/lbu/lh/lhu 的截取与扩展）
6) [DCPU.srcs/sources_1/new/MDU.v](DCPU.srcs/sources_1/new/MDU.v) 与 [DCPU.srcs/sources_1/new/CP0.v](DCPU.srcs/sources_1/new/CP0.v)（最后看多周期与异常）

---

