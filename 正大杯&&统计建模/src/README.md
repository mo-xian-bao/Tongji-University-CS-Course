# SEM分析框架使用说明

## 安装依赖

```bash
pip install -r requirements.txt
```

## 快速开始

### 1. 运行示例程序

```bash
python sem_analysis.py
```

这将运行两个示例：
- 示例1：基础SEM模型（满意度→忠诚度）
- 示例2：中介效应模型（X→M→Y）

### 2. 使用自己的数据

```python
from sem_analysis import SEMAnalysis

# 创建分析对象
sem = SEMAnalysis()

# 加载数据
sem.load_data('your_data.xlsx')

# 数据探索
sem.explore_data()

# 定义模型
model_spec = """
# 测量模型
Factor1 =~ var1 + var2 + var3
Factor2 =~ var4 + var5 + var6

# 结构模型
Factor2 ~ Factor1
"""

sem.define_model(model_spec)

# 拟合模型
sem.fit_model()

# 查看结果
sem.show_results()

# 保存结果
sem.save_results('my_results.xlsx')
```

## 模型定义语法

### 测量模型（CFA）
```
潜变量 =~ 观测变量1 + 观测变量2 + 观测变量3
```

### 结构模型（路径分析）
```
因变量 ~ 自变量1 + 自变量2
```

### 协方差
```
变量1 ~~ 变量2
```

### 固定参数
```
潜变量 =~ 1*观测变量1 + 观测变量2
```

## 常见模型类型

### 1. 基础SEM模型
```python
model = """
Satisfaction =~ sat1 + sat2 + sat3
Quality =~ qual1 + qual2 + qual3
Loyalty =~ loy1 + loy2 + loy3

Loyalty ~ Satisfaction + Quality
"""
```

### 2. 中介效应模型
```python
model = """
X =~ x1 + x2
M =~ m1 + m2
Y =~ y1 + y2

M ~ X
Y ~ X + M
"""
```

### 3. 调节效应模型
```python
# 需要先创建交互项
data['x_m_interaction'] = data['x'] * data['m']

model = """
Y =~ y1 + y2
Y ~ x + m + x_m_interaction
"""
```

## 拟合指标解读

| 指标 | 可接受 | 良好 | 说明 |
|------|--------|------|------|
| CFI | >0.90 | >0.95 | 比较拟合指数 |
| TLI | >0.90 | >0.95 | Tucker-Lewis指数 |
| RMSEA | <0.08 | <0.05 | 近似误差均方根 |
| SRMR | <0.08 | <0.05 | 标准化残差均方根 |

## 输出文件

- `correlation_matrix.png`: 变量相关系数热力图
- `path_diagram.png`: 模型路径图
- `sem_results.xlsx`: 详细分析结果（包含参数估计、拟合指标、描述统计）

## 注意事项

1. **样本量要求**：建议至少200个样本
2. **数据质量**：检查缺失值和异常值
3. **模型识别**：确保模型可识别（自由度≥0）
4. **理论基础**：模型应基于理论假设，不要纯数据驱动
5. **多重共线性**：检查自变量间的相关性

## 常见问题

### Q: 模型不收敛怎么办？
A: 
- 检查数据质量
- 简化模型
- 标准化变量
- 增加样本量

### Q: 拟合指标不理想怎么办？
A:
- 检查修正指数（Modification Indices）
- 考虑添加误差协方差
- 重新审视理论模型
- 删除不显著的路径

### Q: 如何报告SEM结果？
A: 应包括：
- 样本描述
- 模型拟合指标
- 路径系数及显著性
- 路径图
- R²值
