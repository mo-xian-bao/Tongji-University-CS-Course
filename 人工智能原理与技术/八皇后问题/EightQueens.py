from kanren import run, eq, membero, var, goalify

# 定义棋盘大小，八皇后问题为8
N = 8

def is_diagonal_safe(queens: tuple):
    """检查皇后放置是否满足对角线约束（没有皇后在同一对角线上）"""
    for i in range(N):
        for j in range(i + 1, N):
            if i + queens[i] == j + queens[j] or i - queens[i] == j - queens[j]:
                # 皇后在同一对角线上，返回False
                return False
    return True

def generate_permutations(elements):
    """生成元素的所有排列"""
    if len(elements) == 0:
        yield ()
    else:
        for i in range(len(elements)):
            # 取出当前元素
            current = elements[i]
            # 剩余元素
            remaining = elements[:i] + elements[i+1:]
            # 对剩余元素生成排列，并在每个排列前加上当前元素
            for p in generate_permutations(remaining):
                yield (current,) + p

# 生成所有可能的排列，i表示第i行，queens[i]表示第i行皇后所在的列
all_permutations = tuple(generate_permutations(tuple(range(N))))

# 定义逻辑变量
queens = var("queens")

# 找到满足所有约束的解
solutions = run(
    0,  # 0表示找到所有解
    queens,
    membero(queens, all_permutations),  # queens必须是all_permutations中的一个元素
    (goalify(is_diagonal_safe), (queens,), True),  # 对角线检查必须返回True
)

print(f"八皇后问题的解: 共找到 {len(solutions)} 个解")
print("\n棋盘表示 (Q表示皇后，.表示空位):")

# 打印棋盘，Q表示皇后，.表示空位
def print_board(solution):
    """打印棋盘"""
    for i in range(N):
        row = ""
        for j in range(N):
            if solution[i] == j:
                row += "Q "
            else:
                row += ". "
        print(row)

# 打印所有解的棋盘
print(f"\n以下是所有 {len(solutions)} 个解:")
for i, solution in enumerate(solutions):
    print(f"\n解 #{i+1}:")
    print_board(solution)    
