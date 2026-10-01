from kanren import run, eq, var, Relation, facts

# 创建逻辑变量
x = var()

# 使用eq关系，查询满足x=5的x值
result = run(1, x, eq(x, 5))
print(result)  # 输出: (5,)


