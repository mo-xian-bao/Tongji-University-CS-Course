import numpy as np
import pandas as pd

def EntropyTopsis(data, indicator_type):
    """
    使用熵权法和TOPSIS进行多属性决策的函数。

    参数:
    data (pd.DataFrame): 原始数据矩阵。
                         行代表评价对象 (样本), 
                         列代表评价指标。
    indicator_type (list): 指标类型列表。
                           每个元素对应一列指标，
                           'pos' 表示正向指标 (越大越好),
                           'neg' 表示负向指标 (越小越好)。
                           例如: ['pos', 'neg', 'pos']

    返回:
    pd.DataFrame: 包含每个评价对象的得分和排名的DataFrame。
    """
    
    # 转换为numpy数组进行计算
    X = data.values
    m, n = X.shape # 获取样本数和指标数

    # 第一部分：熵权法计算权重

    # 1. 数据标准化
    Z = np.empty((m, n)) # 创建标准化后的数据矩阵
    for j in range(n):
        col = X[:, j]
        min_val = np.min(col)
        max_val = np.max(col)
        
        # 避免分母为0
        if max_val == min_val:
            Z[:, j] = 0.5 # 如果一列值全部相等，则标准化为0.5
            continue
        
        # 提前处理数据，确保indicator_type中只有pos和neg
        if indicator_type[j] == 'pos':
            Z[:, j] = (col - min_val) / (max_val - min_val)
        elif indicator_type[j] == 'neg':
            Z[:, j] = (max_val - col) / (max_val - min_val)

    # 2. 计算信息熵
    epsilon = 1e-10 # 加上一个极小值以避免 log(0) 的错误
    P = Z / (Z.sum(axis=0) + epsilon)
    
    # 计算每个指标的信息熵 E
    E = - (1 / np.log(m)) * np.sum(P * np.log(P + epsilon), axis=0)

    # 3. 计算权重
    # 计算信息熵冗余度 (差异系数)
    D = 1 - E
    # 计算最终权重 W
    W = D / D.sum()

    # 第二部分：TOPSIS 算法排序
    
    # 1. 向量归一化和加权
    # 向量归一化
    Z_topsis = X / np.sqrt(np.sum(X**2, axis=0))
    # 加权
    V = Z_topsis * W

    # 2. 确定正理想解和负理想解
    V_plus = np.zeros(n)
    V_minus = np.zeros(n)
    for j in range(n):
        col = V[:, j]
        if indicator_type[j] == 'pos':
            V_plus[j] = np.max(col)
            V_minus[j] = np.min(col)
        else: # 'neg'
            V_plus[j] = np.min(col)
            V_minus[j] = np.max(col)

    # 3. 计算距离
    S_plus = np.linalg.norm(V - V_plus, axis=1)
    S_minus = np.linalg.norm(V - V_minus, axis=1)

    # 4. 计算相对贴近度 (综合得分)
    C = S_minus / (S_plus + S_minus)

    # 5. 结果封装和排序
    result = pd.DataFrame(index=data.index, columns=['Score'])
    result['Score'] = C

    result['Rank'] = result['Score'].rank(ascending=False, method='min').astype(int)
    
    return result.sort_values(by='Rank')

# ================================================================
# 使用示例 (Example Usage)
# ================================================================
if __name__ == '__main__':
    # 1. 准备数据
    # 假设我们有4个供应商，需要评估他们的3个指标：
    # 指标1: 产品质量 (越高越好, 'pos')
    # 指标2: 交货延迟 (越低越好, 'neg')
    # 指标3: 价格 (越低越好, 'neg')
    
    sample_data = pd.DataFrame({
        '产品质量(分)': [95, 92, 98, 88],
        '交货延迟(天)': [3, 5, 2, 8],
        '价格(元)': [100, 105, 110, 98]
    }, index=['供应商A', '供应商B', '供应商C', '供应商D'])

    # 2. 定义指标类型
    indicator_types = ['pos', 'neg', 'neg']

    # 3. 调用函数进行评估
    print("原始数据:")
    print(sample_data)
    print("\n" + "="*30 + "\n")
    
    final_ranking = EntropyTopsis(sample_data, indicator_types)

    # 4. 输出结果
    print("评估结果:")
    print(final_ranking)