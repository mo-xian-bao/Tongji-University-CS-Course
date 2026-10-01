import matplotlib.pyplot as plt
import numpy as np
import math

# 设置字体以支持中文和负号显示
plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False
# 启用 LaTeX 风格的数学公式渲染 (可选，如果没有安装 LaTeX 可能会回退，但这行通常能提升数学符号效果)
# plt.rcParams['text.usetex'] = True 

# ==============================================================================
# 1. 方案一：发射场纬度与运载能力衰减曲线
# ==============================================================================
def plot_latitude_decay():
    # 数据准备
    latitudes = np.linspace(0, 90, 200)
    base_payload = 150
    # 公式: Payload = 150 * (1 - 0.005 * |Lat|)
    payloads = base_payload * (1 - 0.005 * latitudes)

    # 10个发射场的具体数据 (名称, 实际纬度)
    sites = [
        ("French Guiana", 5.2, 146.3),
        ("India", 13.7, 140.3),
        ("Texas", 26.0, 130.5),
        ("Florida", 28.5, 129.0),
        ("California", 34.6, 124.5),
        ("Virginia", 37.8, 122.3),
        ("China", 39.0, 120.8), 
        ("New Zealand", 39.2, 120.8),
        ("Kazakhstan", 46.0, 115.5),
        ("Alaska", 57.4, 107.3)
    ]

    fig, ax = plt.subplots(figsize=(10, 6), layout='constrained')
    
    # 绘制主衰减曲线
    ax.plot(latitudes, payloads, color='#1f77b4', linewidth=3, label='Theoretical Decay: $150 \\times (1 - 0.005 \\times |Lat|)$')
    
    # 标注区域颜色 (可选)
    ax.fill_between(latitudes, payloads, 0, color='#1f77b4', alpha=0.1)

    # =========================================================
    # 显式定义的对齐和偏移量配置 (手动微调区域)
    # 格式: "Name": (x_offset, y_offset, ha_alignment)
    # x/y 单位是 points, ha 是 'center'/'left'/'right'
    # =========================================================
    offset_config = {
        "French Guiana": (15, 5, 'left'),
        "India":         (15, 5, 'left'),
        "Texas":         (-15, -15, 'right'), # 向左下放
        "Florida":       (15, 15, 'left'),    # 向右上放
        "California":    (-15, -15, 'right'), # 向左下放
        "Virginia":      (-35, 5, 'right'),   # 向左拉远
        "China":         (0, 20, 'center'),   # 向上顶
        "New Zealand":   (35, -5, 'left'),    # 向右拉远
        "Kazakhstan":    (15, 5, 'left'),
        "Alaska":        (15, 5, 'left')
    }

    # 绘制关键点
    for name, lat, pay in sites:
        # 散点: 放大, 黑边
        ax.scatter(lat, pay, color='red', s=150, zorder=10, edgecolors='black', linewidth=2)
        
        # 获取配置，默认值 (0, 15, center)
        (off_x, off_y, ha) = offset_config.get(name, (0, 15, 'center'))
        
        ax.annotate(name, (lat, pay), xytext=(off_x, off_y), textcoords='offset points', 
                    ha=ha, fontsize=10, color='black', fontweight='bold', zorder=15)

    ax.set_xlim(0, 90)
    ax.set_ylim(80, 160)
    ax.set_xlabel('Latitude ($^\circ$)', fontsize=12, fontweight='bold')
    ax.set_ylabel('Payload Capacity (Tons)', fontsize=12, fontweight='bold')
    # ax.set_title('Effect of Latitude on Launch Capacity', fontsize=14, pad=15) # 去掉标题
    ax.grid(True, linestyle='--', alpha=0.5)
    ax.legend(loc='lower left', fontsize=11)
    
    # 保存
    plt.savefig('4/analysis_1_latitude_decay.png', dpi=300)
    print("生成完成: 4/analysis_1_latitude_decay.png")


# ==============================================================================
# 2. 方案二：技术学习曲线预测 (Cost Learning Curve)
# ==============================================================================
def plot_learning_curve():
    years = np.arange(2020, 2051)
    # 假设基准成本 (2020年): Falcon Heavy 约为 1500 $/kg (仅作参考的归一化基数)
    # 或者为了配合题目中的 4927 $/kg (2026年倒推回2020)
    c_base = 9032
    decay_rate = 0.02
    
    # 主要预测曲线
    costs = c_base * np.exp(-decay_rate * (years - 2020))
    
    # 乐观与悲观估计 (置信区间)
    costs_optimistic = c_base * np.exp(-0.025 * (years - 2020))
    costs_pessimistic = c_base * np.exp(-0.012 * (years - 2020))

    fig, ax = plt.subplots(figsize=(10, 6), layout='constrained')

    # 绘制渐变阴影区间 (Confidence Interval Gradient Simulation)
    # 通过叠加多层 fill_between 实现
    n_layers = 50
    for i in range(n_layers):
        # 因子从 1.0 (最宽) 到 0.0 (中心)
        factor = (n_layers - i) / n_layers 
        
        # 线性插值计算当前层的边界
        upper = costs + (costs_pessimistic - costs) * factor
        lower = costs - (costs - costs_optimistic) * factor
        
        # 每一层非常淡，叠加起来形成中心深、边缘浅的效果
        ax.fill_between(years, lower, upper, color='#ff7f0e', alpha=0.015, linewidth=0)
    
    # 额外加一个极淡的轮廓，界定边界
    ax.fill_between(years, costs_optimistic, costs_pessimistic, color='#ff7f0e', alpha=0.05, label='Confidence Interval')
    
    # 绘制主曲线
    ax.plot(years, costs, color='#d62728', linewidth=3, label="Projected Cost (-2% per year)")
    
    # 标注当前点 (2020/2025) 和 目标点 (2050)
    ax.scatter([2020, 2050], [costs[0], costs[-1]], color='black', zorder=5, s=50)
    ax.text(2020.5, costs[0], f"Current: ${int(costs[0])}/kg", verticalalignment='bottom', fontweight='bold')
    ax.text(2050, costs[-1]+100, f"2050 Est: ${int(costs[-1])}/kg", horizontalalignment='center', fontweight='bold')

    ax.set_xlim(2020, 2050)
    ax.set_xlabel('Year', fontsize=12, fontweight='bold')
    ax.set_ylabel('Unit Transportation Cost ($/kg)', fontsize=12, fontweight='bold')
    # ax.set_title('Cost Learning Curve Prediction (Wright\'s Law)', fontsize=14, pad=15) # 去掉标题
    ax.grid(True, linestyle='--', alpha=0.5)
    ax.legend(fontsize=14)

    plt.savefig('4/analysis_2_cost_curve.png', dpi=300)
    print("生成完成: 4/analysis_2_cost_curve.png")


# ==============================================================================
# 3. 方案三：环境影响因子的构成雷达图
# ==============================================================================
def plot_radar_chart():
    # 维度定义
    categories = ['Atmospheric\nPollution', 'Resource\nDepletion', 'Debris\nRisk', 'Local\nEcology']
    N = len(categories)

    # “传统重型火箭”的归一化得分 (假设数据)
    values = [0.85, 0.90, 0.70, 0.60]
    
    # 闭合曲线
    values += values[:1]
    
    # 角度计算
    angles = [n / float(N) * 2 * math.pi for n in range(N)]
    angles += angles[:1]

    fig, ax = plt.subplots(figsize=(8, 8), subplot_kw={'projection': 'polar'})

    # 绘制数据
    ax.plot(angles, values, color='#2ca02c', linewidth=2, linestyle='solid', label='Heavy Rocket Impact')
    ax.fill(angles, values, color='#2ca02c', alpha=0.25)
    
    # 对比数据 (例如：太空电梯或理想绿色方案，可选)
    # values_green = [0.2, 0.4, 0.1, 0.3]
    # values_green += values_green[:1]
    # ax.plot(angles, values_green, color='#1f77b4', linewidth=1, linestyle='--', label='Green Target')
    # ax.fill(angles, values_green, color='#1f77b4', alpha=0.1)

    # 调整刻度标签
    plt.xticks(angles[:-1], categories, fontsize=11, fontweight='bold')
    
    # 设置Y轴范围和标签
    ax.set_rlabel_position(30)
    plt.yticks([0.2, 0.4, 0.6, 0.8, 1.0], ["0.2", "0.4", "0.6", "0.8", "1.0"], color="grey", size=8)
    plt.ylim(0, 1.0)
    
    # plt.title('Environmental Impact Dimensions (Normalized)', fontsize=15, y=1.05) # 去掉标题
    plt.legend(loc='lower right', bbox_to_anchor=(1.2, 0.1))
    
    plt.savefig('4/analysis_3_radar_chart.png', dpi=300)
    print("生成完成: 4/analysis_3_radar_chart.png")

if __name__ == "__main__":
    plot_latitude_decay()
    plot_learning_curve()
    plot_radar_chart()
