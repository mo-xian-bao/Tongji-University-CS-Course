import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import seaborn as sns

# --- 字体 & 主题 ---
mpl.rcParams['font.sans-serif'] = ['SimHei']
mpl.rcParams['axes.unicode_minus'] = False
sns.set_theme(style='whitegrid')

# 1. 读取四个附件
df1 = pd.read_excel(r'附件1.xlsx', engine='openpyxl')  # 单品编码、单品名称、分类编码、分类名称
df2 = pd.read_excel(r'附件2.xlsx', engine='openpyxl')  # 销售日期、扫码销售时间、单品编码、销量(千克)、销售单价(元/千克)、...
df3 = pd.read_excel(r'附件3.xlsx', engine='openpyxl')  # 日期、单品编码、批发价格
df4 = pd.read_excel(r'附件4.xlsx', engine='openpyxl')  # 单品编码、单品名称、损耗率

# 2. 预处理 & 过滤花叶类
df = pd.merge(
    df2,
    df1[['单品编码','分类编码','分类名称']],
    on='单品编码', how='left'
)
df = df[df['分类名称'] == '花叶类']

# 3. 合并批发价、损耗率
df3.columns = df3.columns.str.strip()
df3 = df3.rename(columns={'日期': '销售日期','批发价格(元/千克)':'批发价格'})  

# 清理并打印 df4 列名
df4.columns = df4.columns.str.strip()
df4 = df4.rename(columns={'损耗率(%)': '损耗率'})

# 合并批发价格
df = pd.merge(
    df,
    df3[['单品编码', '销售日期', '批发价格']],
    on=['单品编码', '销售日期'],
    how='left'
)

# 合并损耗率（按分类编码对应小分类编码）
df = pd.merge(
    df,
    df4[['单品编码', '损耗率']],
    on='单品编码',
    how='left'
)

# 4. 计算成本加成定价
df['成本加成价'] = (df['销售单价(元/千克)'] - df['批发价格']) * (1 + df['损耗率'])

# 5. 计算日维度：日销售量 & 日均成本加成价
daily = df.groupby('销售日期').agg(
    日销售量=('销量(千克)','sum'),
    日均加成价=('成本加成价','mean')
).reset_index()

# 6. 绘图
fig, ax = plt.subplots(figsize=(10, 6))

# 原始散点
ax.scatter(
    daily['日均加成价'],
    daily['日销售量'],
    color='gray',
    alpha=0.5,
    label='原始数据'
)

# 分段求均值（建议分成 20 段）
daily['价段'] = pd.cut(daily['日均加成价'], bins=20)
grp = daily.groupby('价段').agg(
    加成价均值=('日均加成价','mean'),
    销量均值=('日销售量','mean')
).dropna()

# 绘制分段均值蓝线
ax.plot(
    grp['加成价均值'],
    grp['销量均值'],
    color='blue',
    marker='o',
    linewidth=2,
    label='分段均值趋势'
)

ax.set_title('花叶类蔬菜：日销售量 vs 成本加成定价')
ax.set_xlabel('日均成本加成价 (元/千克)')
ax.set_ylabel('日销售量 (千克)')
ax.legend()
plt.tight_layout()