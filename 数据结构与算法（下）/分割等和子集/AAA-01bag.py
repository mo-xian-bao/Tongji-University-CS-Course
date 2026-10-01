def knapsack_01(weights, values, capacity):
    """
    解决01背包问题
    
    参数:
    weights -- 物品重量列表
    values -- 物品价值列表
    capacity -- 背包容量
    
    返回:
    最大价值
    """
    n = len(weights)  # 物品数量
    
    # 创建二维dp数组，dp[i][j]表示考虑前i个物品，背包容量为j时能获得的最大价值
    dp = [[0 for _ in range(capacity + 1)] for _ in range(n + 1)]
    
    # 动态规划过程
    for i in range(1, n + 1):
        for j in range(1, capacity + 1):
            if j >= weights[i-1]:  # 如果当前背包容量能放下第i个物品
                # 取放入或不放入的最大值
                dp[i][j] = max(dp[i-1][j], dp[i-1][j-weights[i-1]] + values[i-1])
            else:  # 放不下，只能选择不放
                dp[i][j] = dp[i-1][j]
    
    # 回溯找出选择的物品
    selected_items = []
    i, j = n, capacity
    
    while i > 0 and j > 0:
        if dp[i][j] != dp[i-1][j]:  # 说明选择了第i个物品
            selected_items.append(i-1)  # 因为物品索引从0开始
            j -= weights[i-1]  # 减去当前物品的重量
        i -= 1
    
    # 反转列表，使物品按照原来的顺序排列
    selected_items.reverse()
    
    return dp[n][capacity], selected_items

# 测试代码
if __name__ == "__main__":
    # 示例：3个物品
    weights = [1, 2, 3]  # 物品重量
    values = [6, 10, 12]  # 物品价值
    capacity = 5  # 背包容量
    
    max_value, selected_items = knapsack_01(weights, values, capacity)
    
    print(f"背包能装下的最大价值为: {max_value}")
    print(f"选择的物品索引: {selected_items}")
    print(f"选择的物品重量: {[weights[i] for i in selected_items]}")
    print(f"选择的物品价值: {[values[i] for i in selected_items]}")
    print(f"总重量: {sum(weights[i] for i in selected_items)}")
    print(f"总价值: {sum(values[i] for i in selected_items)}")
    
    # 打印DP表格
    print("\nDP表格:")
    weights = [1, 2, 3]  # 物品重量
    values = [6, 10, 12]  # 物品价值
    capacity = 5  # 背包容量
    n = len(weights)
    
    dp = [[0 for _ in range(capacity + 1)] for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for j in range(1, capacity + 1):
            if j >= weights[i-1]:
                dp[i][j] = max(dp[i-1][j], dp[i-1][j-weights[i-1]] + values[i-1])
            else:
                dp[i][j] = dp[i-1][j]
    
    # 打印表头
    print("  ", end="")
    for j in range(capacity + 1):
        print(f"{j:2d}", end=" ")
    print()
    
    # 打印DP表格内容
    for i in range(n + 1):
        print(f"{i:2d}", end=" ")
        for j in range(capacity + 1):
            print(f"{dp[i][j]:2d}", end=" ")
        print()