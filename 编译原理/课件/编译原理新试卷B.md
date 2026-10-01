# 编译原理新试卷 B

## 一、判断题（每小题 1 分，共 10 分）

1. 解释程序和编译程序都需要分析源程序，但二者生成和执行目标代码的方式不同。
2. 对同一个正规语言，可能存在多个等价的 `DFA`。
3. 一个 `DFA` 的最小化结果在状态命名意义下不一定唯一。
4. 若文法没有左递归，则它一定是 `LL(1)` 文法。
5. 算符优先分析法不能处理含有相邻非终结符的产生式右部。
6. 符号表中通常保存标识符的名字、类型、作用域和存储分配等信息。
7. 静态链用于在运行时访问非局部变量。
8. 四元式、三元式和间接三元式都可用于表示中间代码。
9. 活跃变量分析是一种自顶向下的语法分析方法。
10. `LR(0)` 项目中的圆点位置表示分析过程中已识别和待识别的部分。

## 二、选择题（每小题 2 分，共 20 分）

1. 下列哪项通常不属于词法分析阶段的任务？

   - (A) 删除空白和注释
   - (B) 识别标识符和关键字
   - (C) 建立单词符号
   - (D) 判断表达式类型是否匹配

2. 若 `A → α | β`，且 `α` 可推出空串，则构造预测分析表时需要考虑_____。

   - (A) `FOLLOW(A)`
   - (B) `FOLLOW(α)`
   - (C) `FIRST(A)`
   - (D) `GOTO(A)`

3. 在规范规约中，每一步规约的对象是当前规范句型的_____。

   - (A) 最左短语
   - (B) 最右短语
   - (C) 句柄
   - (D) 任意短语

4. 下列关于二义性的说法正确的是_____。

   - (A) 二义文法一定不能生成程序设计语言
   - (B) 一个句子有两棵不同语法树时，文法是二义的
   - (C) 消除左递归一定能消除二义性
   - (D) 正规文法一定是二义文法

5. 表达式 `(a-b)*(c+d)` 的逆波兰式为_____。

   - (A) `ab-cd+*`
   - (B) `ab-c*d+`
   - (C) `abc+-d*`
   - (D) `a-bc+d*`

6. 在简单代码生成算法中，待用信息主要用于_____。

   - (A) 判断源程序是否有语法错误
   - (B) 决定寄存器内容是否需要保存
   - (C) 构造正规式
   - (D) 建立预测分析表

7. 在运行时存储组织中，过程调用嵌套所形成的活动记录通常保存在_____。

   - (A) 代码区
   - (B) 常量区
   - (C) 栈区
   - (D) 符号表文件

8. 下列哪一项是公共子表达式？

```text
t1 := a + b
t2 := c + d
t3 := a + b
```

   - (A) `c + d`
   - (B) `a + b`
   - (C) `t1 + t2`
   - (D) `t2 + t3`

9. 在 `SLR(1)` 分析表构造中，归约动作通常依据_____填写。

   - (A) 项目中圆点后的终结符
   - (B) 产生式左部非终结符的 `FOLLOW` 集
   - (C) 所有终结符的 `FIRST` 集
   - (D) 状态编号的大小

10. 已知过程 `P(x,y)` 中先执行 `x := x + 1`，再执行 `y := x + y`。若调用 `P(a,a)`，参数均为传地址，且调用前 `a=5`，调用后 `a` 为_____。

   - (A) 5
   - (B) 6
   - (C) 11
   - (D) 12

## 三、构造等价的确定型有穷自动机并最小化（10 分）

为正规式 `(0|1)*01` 构造等价的确定型有穷自动机并最小化，要求给出详细过程。

## 四、文法分析题（15 分）

对下面的文法 `G`：

```text
S → c | Λ | {T}
T → T:S | S
```

1. 令非终结符的排序为 `T、S`，按此次排序消去文法 `G` 的左递归。（4 分）
2. 经改写后的文法是否是 `LL(1)` 的？请说明理由。（4 分）
3. 若是 `LL(1)` 文法，请构造它的预测分析表。（4 分）
4. 使用所构造的预测分析表，给出输入串 `{c:Λ}#` 的分析过程。（3 分）

预测分析表表头：

|      | c | Λ | { | } | : | # |
| ---- | - | - | - | - | - | - |
| S    |   |   |   |   |   |   |
| T    |   |   |   |   |   |   |
| T'   |   |   |   |   |   |   |

## 五、循环优化题（13 分）

以下程序是某程序的最内循环：

```text
P := 0
N := 1
L1: Q := R - 5
    H := Q * N
    P := P + H
    If N = 64 goto L2
    N := N + 1
    goto L1
L2:
```

1. 划分基本块，并给每个基本块一个序号。（4 分）
2. 画出该代码的控制流图，每个基本块就用（1）的序号表示。（4 分）
3. 对其进行循环优化，给出优化后的流图表示。（5 分）

## 六、目标代码生成题（8 分）

对以下某基本块的中间代码序列 `G`：

```text
T := M - N
U := P + Q
V := T + U
W := V - T
Z := W + U
```

假设可用寄存器为 `R0` 和 `R1`，设 `W` 和 `Z` 是基本块出口的活跃变量。

1. 给出附加在每个中间代码上的待用与活跃信息。（4 分）
2. 用简单代码生成算法生成其目标代码。（4 分）

## 七、四元式序列题（12 分）

按照下述给出的翻译模式，写出

```text
while (m<=n) do
if E or F then r:=s*t else r:=s+t
```

的四元式序列，约定四元式序列的起始标号为 `300`。（12 分）

产生式与语义规则：

```text
E → E1 or M E2
{ backpatch(E1.falselist, M.quad);
  E.truelist := merge(E1.truelist, E2.truelist);
  E.falselist := E2.falselist }

E → E1 and M E2
{ backpatch(E1.truelist, M.quad);
  E.truelist := E2.truelist;
  E.falselist := merge(E1.falselist, E2.falselist) }

E → (E1)
{ E.truelist := E1.truelist;
  E.falselist := E1.falselist }

E → id1 relop id2
{ E.truelist := makelist(nextquad);
  E.falselist := makelist(nextquad + 1);
  emit('j' relop.op, id1.place, id2.place, '0');
  emit('j', '-', '-', '0') }

E → id
{ E.truelist := makelist(nextquad);
  E.falselist := makelist(nextquad + 1);
  emit('jnz', id.place, '-', '0');
  emit('j', '-', '-', '0') }

S → if E then M1 S1 N else M2 S2
{ backpatch(E.truelist, M1.quad);
  backpatch(E.falselist, M2.quad);
  S.nextlist := merge(S1.nextlist, N.nextlist, S2.nextlist) }

S → while M1 E do M2 S1
{ backpatch(S1.nextlist, M1.quad);
  backpatch(E.truelist, M2.quad);
  S.nextlist := E.falselist;
  emit('j', '-', '-', M1.quad) }

S → id := E
{ emit(':=', E.place, '-', id.place) }

E → E1 op E2
{ E.place := newtemp;
  emit(op, E1.place, E2.place, E.place) }

M → ε
{ M.quad := nextquad }

N → ε
{ N.nextlist := makelist(nextquad);
  emit('j', '-', '-', '0') }
```

## 八、LR(0) 分析题（12 分）

考虑文法：

```text
E → F + F | F - F
F → x | y
```

1. 列出该文法拓广文法的所有 `LR(0)` 项目。（2 分）
2. 构造该文法的 `LR(0)` 项目集规范族及识别活前缀的 `DFA`。（3 分）
3. 构造该文法的 `LR(0)` 分析表。（3 分）
4. 判断该文法是否是 `LR(0)` 文法，并说明理由。（2 分）
5. 使用所构造的 `LR(0)` 分析表，给出输入串 `x+y#` 的分析过程。（2 分）

分析表表头：

| 状态 | + | - | x | y | # | E | F |
| ---- | - | - | - | - | - | - | - |
| 0    |   |   |   |   |   |   |   |

## 九、运行时存储空间组织题（10 分）

考虑如下 Pascal 风格的嵌套过程结构：

```text
program M;
var g: integer;

procedure A;
var a: integer;
    procedure B;
    var b: integer;
    begin
        if b > 0 then B;
        { 执行点 Y }
    end;
begin
    B;
end;

procedure C;
var c: integer;
begin
    A;
end;

begin
    C;
end.
```

设主程序 `M` 的层次为 0，在 `M` 中定义的过程层次为 1，依此类推。程序运行到第二次递归调用的 `B` 中的执行点 `Y` 时，调用序列为 `M → C → A → B₁ → B₂`，其中 `B₂` 表示第二个、也是当前最新的 `B` 活动。

1. 写出此时运行栈中活动记录从栈底到栈顶的次序。（2 分）
2. 分别指出各活动记录的动态链和静态链指向哪个活动记录。（4 分）
3. 写出执行点 `Y` 处 `DISPLAY` 表各层应保存的活动记录地址。（2 分）
4. 在 `B₂` 中引用变量 `g、a、b、c` 时，哪些可通过 `DISPLAY` 表直接访问？分别说明其所在层次；哪些不能按词法作用域直接访问？（2 分）
