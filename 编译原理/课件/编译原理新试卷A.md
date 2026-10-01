# 编译原理新试卷 A

## 一、判断题（每小题 1 分，共 10 分）

1. 编译程序的前端主要与源语言有关，后端主要与目标机器有关。
2. 正规文法描述的语言一定可以用有限自动机识别。
3. 若某文法是二义文法，则该文法一定不是 `LL(1)` 文法。
4. 在自底向上分析中，句柄一定是当前规范句型中最左边的短语。
5. 消除文法左递归后，文法所描述的语言不变。
6. `FIRST` 集和 `FOLLOW` 集只在构造自顶向下分析器时才有作用。
7. 语义分析阶段可以检查变量是否先声明后使用。
8. 局部公共子表达式删除只能在基本块内部进行，不能跨越基本块。
9. 在短路求值的布尔表达式翻译中，真假出口通常通过回填技术确定。
10. 一个文法若不存在移进-规约冲突和规约-规约冲突，则可直接断定它是 `LR(0)` 文法。

## 二、选择题（每小题 2 分，共 20 分）

1. 词法分析器输出的通常是_____。

   - (A) 语法树
   - (B) 单词符号序列
   - (C) 四元式序列
   - (D) 目标代码序列

2. 若文法 `G` 是 `LL(1)` 文法，则对任意非终结符 `A` 的两个不同候选式 `α` 和 `β`，必须满足_____。

   - (A) `FIRST(α) ∩ FIRST(β) = ∅`
   - (B) `FIRST(α) = FIRST(β)`
   - (C) `FOLLOW(A) = ∅`
   - (D) `FIRST(A) ∩ FOLLOW(A) = ∅`

3. 下列哪一种中间表示最适合直接表示三地址语句？

   - (A) 语法树
   - (B) 符号表
   - (C) 四元式
   - (D) 正规式

4. 对正规式 `(a|b)*abb`，下列字符串中属于其表示语言的是_____。

   - (A) `ab`
   - (B) `aabb`
   - (C) `abba`
   - (D) `bbb`

5. 在活动记录中，保存调用过程返回后继续执行位置的信息通常是_____。

   - (A) 返回地址
   - (B) 静态链
   - (C) 动态链
   - (D) 临时变量区

6. 对表达式 `a+b*c`，若 `*` 的优先级高于 `+`，其逆波兰式为_____。

   - (A) `ab+c*`
   - (B) `abc*+`
   - (C) `abc+*`
   - (D) `a*b+c`

7. 在 `LR` 分析表中，`ACTION[i, a] = sj` 表示_____。

   - (A) 用第 `j` 个产生式规约
   - (B) 接受输入串
   - (C) 移进终结符 `a` 并转入状态 `j`
   - (D) 转到非终结符 `a` 对应的状态 `j`

8. 若一个基本块出口处变量 `x` 是活跃的，表示_____。

   - (A) `x` 在该基本块中一定被定值
   - (B) `x` 的当前值在后继基本块中可能被引用
   - (C) `x` 一定是临时变量
   - (D) `x` 一定可以分配到寄存器

9. 下列优化中属于循环优化的是_____。

   - (A) 常量合并
   - (B) 公共子表达式删除
   - (C) 循环不变式外提
   - (D) 语法制导翻译

10. 对主程序调用 `P(a, a)`，若第一个形参按传地址，第二个形参按传值结果，执行结果最可能受影响的是_____。

```pascal
a := 2;
P(a, a);
write(a);

procedure P(x, y);
begin
    x := x + 3;
    y := y * 2;
end
```

   - (A) 只与实参初值有关，与参数传递方式无关
   - (B) 与形参赋值顺序和结果回传有关
   - (C) 一定输出 2
   - (D) 一定输出 10

## 三、构造等价的确定型有穷自动机并最小化（10 分）

为正规式 `(a|b)*ba` 构造等价的确定型有穷自动机并最小化，要求给出详细过程。

## 四、文法分析题（15 分）

对下面的文法 `G`：

```text
S → b | Λ | [T]
T → T;S | S
```

1. 令非终结符的排序为 `T、S`，按此次排序消去文法 `G` 的左递归。（4 分）
2. 经改写后的文法是否是 `LL(1)` 的？请说明理由。（4 分）
3. 若是 `LL(1)` 文法，请构造它的预测分析表。（4 分）
4. 使用所构造的预测分析表，给出输入串 `[b;Λ]#` 的分析过程。（3 分）

预测分析表表头：

|      | b | Λ | [ | ] | ; | # |
| ---- | - | - | - | - | - | - |
| S    |   |   |   |   |   |   |
| T    |   |   |   |   |   |   |
| T'   |   |   |   |   |   |   |

## 五、循环优化题（13 分）

以下程序是某程序的最内循环：

```text
S := 0
K := 1
L1: T := M * 2
    U := T + K
    S := S + U
    If K = 100 goto L2
    K := K + 1
    goto L1
L2:
```

1. 划分基本块，并给每个基本块一个序号。（4 分）
2. 画出该代码的控制流图，每个基本块就用（1）的序号表示。（4 分）
3. 对其进行循环优化，给出优化后的流图表示。（5 分）

## 六、目标代码生成题（8 分）

对以下某基本块的中间代码序列 `G`：

```text
T := A + B
U := C - D
V := T * U
X := V + T
Y := X - U
```

假设可用寄存器为 `R0` 和 `R1`，设 `X` 和 `Y` 是基本块出口的活跃变量。

1. 给出附加在每个中间代码上的待用与活跃信息。（4 分）
2. 用简单代码生成算法生成其目标代码。（4 分）

## 七、四元式序列题（12 分）

按照下述给出的翻译模式，写出

```text
while (i<j) do
if C and D then x:=p+q else x:=p-q
```

的四元式序列，约定四元式序列的起始标号为 `200`。（12 分）

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
E → T - T | T / T
T → c | d
```

1. 列出该文法拓广文法的所有 `LR(0)` 项目。（2 分）
2. 构造该文法的 `LR(0)` 项目集规范族及识别活前缀的 `DFA`。（3 分）
3. 构造该文法的 `LR(0)` 分析表。（3 分）
4. 判断该文法是否是 `LR(0)` 文法，并说明理由。（2 分）
5. 使用所构造的 `LR(0)` 分析表，给出输入串 `c-d#` 的分析过程。（2 分）

分析表表头：

| 状态 | - | / | c | d | # | E | T |
| ---- | - | - | - | - | - | - | - |
| 0    |   |   |   |   |   |   |   |

## 九、运行时存储空间组织题（10 分）

考虑如下 Pascal 风格的嵌套过程结构：

```text
program P;
var a: integer;

procedure Q;
var b: integer;
    procedure R;
    var c: integer;
    begin
        { 执行点 X }
    end;
begin
    R;
end;

procedure S;
var d: integer;
begin
    Q;
end;

begin
    S;
end.
```

设主程序 `P` 的层次为 0，在 `P` 中定义的过程层次为 1，依此类推。程序运行到 `R` 中的执行点 `X` 时，调用序列为 `P → S → Q → R`。

1. 写出此时运行栈中活动记录从栈底到栈顶的次序。（2 分）
2. 分别指出各活动记录的动态链和静态链指向哪个活动记录。（4 分）
3. 写出执行点 `X` 处 `DISPLAY` 表各层应保存的活动记录地址。（2 分）
4. 在 `R` 中引用变量 `a、b、c、d` 时，哪些可通过 `DISPLAY` 表直接访问？分别说明其所在层次；哪些不能按词法作用域直接访问？（2 分）
