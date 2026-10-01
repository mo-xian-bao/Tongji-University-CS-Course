import pulp
import math
import matplotlib.pyplot as plt
import numpy as np

def solve_model(alpha_weight):
    """
    运行优化模型 (使用 PuLP 求解器) 并返回 (完工时间, 总成本)
    """
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 150         # 优化年限
    
    # 太空电梯参数
    payload_ratio = 0.5
    C_elevator_per_ton = 1330       
    Initial_C_elevator_rocket_per_ton = 1035000     
    Cap_elevator_sys = 179000 * 3   
    
    # --- 动态因子设定 ---
    Cost_Decay_Rate = 0.02 
    Cost_Min_Floor  = 0.2  
    Freq_Growth_Per_Decade = 0.15  

    # --- 基地数据 ---
    Unified_Cost_Per_Ton = 4000 * 1000
    site_payloads = {
        "French Guiana": 146.3, "India": 140.3, "Texas": 130.5, "Florida": 129.0,
        "California": 124.5, "Virginia": 122.3, "China": 120.8, "New Zealand": 120.8,
        "Kazakhstan": 115.5, "Alaska": 107.3
    }
    site_data = {
        "French Guiana": {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 200}, 
        "India":         {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 200},
        "Texas":         {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 500}, 
        "Florida":       {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 500}, 
        "California":    {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 50},
        "Virginia":      {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 50},
        "China":         {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 200},
        "New Zealand":   {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 50},
        "Kazakhstan":    {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 200},
        "Alaska":        {"cost_per_ton": Unified_Cost_Per_Ton, "initial_freq": 50}   
    }
    site_names = list(site_data.keys())

    # =========================================================================
    # 2. 预计算
    # =========================================================================
    years = range(1, Max_Horizon + 1)
    dyn_cap_per_site = {}   
    dyn_cost_per_site = {}  
    dyn_cost_elevator_rocket = {} 
    
    for t in years:
        cost_factor = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate * (t-1)))
        decade_idx = (t - 1) // 10
        freq_multiplier = (1 + Freq_Growth_Per_Decade) ** decade_idx
        
        dyn_cap_per_site[t] = {}
        dyn_cost_per_site[t] = {}
        dyn_cost_elevator_rocket[t] = Initial_C_elevator_rocket_per_ton * cost_factor
        
        for name, info in site_data.items():
            current_payload = site_payloads[name]
            current_freq = info["initial_freq"] * freq_multiplier
            dyn_cap_per_site[t][name] = current_payload * current_freq
            dyn_cost_per_site[t][name] = info["cost_per_ton"] * cost_factor

    # =========================================================================
    # 3. PuLP 建模
    # =========================================================================
    prob = pulp.LpProblem("Pareto_Analysis", pulp.LpMinimize)
    
    # --- 变量 ---
    x_e = pulp.LpVariable.dicts("Elevator_Tons", years, lowBound=0)
    x_r = pulp.LpVariable.dicts("Rocket_Tons", (site_names, years), lowBound=0)
    u = pulp.LpVariable.dicts("Is_Active", years, cat=pulp.LpBinary)
    
    # --- 约束 ---
    # 1. 总需求满足 (注意：Payload_ratio 仅作用于电梯)
    prob += pulp.lpSum(x_e[t] * payload_ratio for t in years) + \
            pulp.lpSum(x_r[i][t] for i in site_names for t in years) >= M_total, "Demand_Constraint"
    
    # 2. 运力上限 (带有二进制开关)
    for t in years:
        prob += x_e[t] <= Cap_elevator_sys * u[t], f"Cap_Ele_{t}"
        for i in site_names:
            prob += x_r[i][t] <= dyn_cap_per_site[t][i] * u[t], f"Cap_Rock_{i}_{t}"
            
    # 3. 时间连续性 (必须从前向后活跃)
    for t in range(1, Max_Horizon):
        prob += u[t] >= u[t+1], f"Continuity_{t}"
        
    # --- 目标函数 ---
    total_cost_usd = pulp.lpSum(x_e[t] * (C_elevator_per_ton + payload_ratio * dyn_cost_elevator_rocket[t]) for t in years) + \
                     pulp.lpSum(x_r[i][t] * dyn_cost_per_site[t][i] for i in site_names for t in years)
    
    total_years_val = pulp.lpSum(u[t] for t in years)
    
    # 归一化后的复合目标
    prob += alpha_weight * (total_cost_usd / 1e12) + (1 - alpha_weight) * total_years_val
    
    # --- 求解 ---
    # 使用默认的 CBC 求解器，msg=0 关闭求解过程的日志打印
    prob.solve(pulp.PULP_CBC_CMD(msg=0))
    
    if pulp.LpStatus[prob.status] == 'Optimal':
        return pulp.value(total_years_val), pulp.value(total_cost_usd) / 1e12
    else:
        return None, None

def main():
    print("Starting Pareto Frontier analysis...")
    alphas = [i/20 for i in range(1, 20)] # 0.05 to 0.95, step 0.05
    results = []
    
    print(f"{'Alpha':<10} | {'Time (Years)':<15} | {'Cost (Trillion)'}")
    print("-" * 45)

    for alpha in alphas:
        t, c = solve_model(alpha)
        if t is not None:
            results.append((alpha, t, c))
            print(f"{alpha:<10.2f} | {t:<15.2f} | {c:.4f}")
    
    if not results:
        print("No solutions found.")
        return

    # Unpack results
    alpha_vals, times, costs = zip(*results)
    
    # Plotting
    plt.figure(figsize=(12, 6), dpi=300)
    
    # 1. 创建渐变折线
    from matplotlib.collections import LineCollection
    
    # 将点对转换为线段
    points = np.array([times, costs]).T.reshape(-1, 1, 2)
    segments = np.concatenate([points[:-1], points[1:]], axis=1)
    
    # 创建 LineCollection，设置 cmap 为 'gnuplot2' (深紫到浅黄的经典渐变)
    # 或者使用 'plasma' 或自定义
    norm = plt.Normalize(0, len(segments))
    lc = LineCollection(segments, cmap='gnuplot2', norm=norm, linewidth=4, alpha=0.9, zorder=2)
    lc.set_array(np.arange(len(segments)))
    
    ax = plt.gca()
    ax.add_collection(lc)
    
    # 绘制散点（端点），颜色与线段同步，确保 zorder 高于线条
    scatter = plt.scatter(times, costs, c=np.arange(len(times)), cmap='gnuplot2', 
                         s=70, zorder=4, edgecolors='white', linewidth=0.8)
    
    # 标注每个点的 Alpha 值 (加强型防重叠与布局优化)
    last_labeled_y = 999.0
    last_labeled_x = -999.0
    
    for i, txt in enumerate(alpha_vals):
        curr_x, curr_y = times[i], costs[i]
        
        # 逻辑：左侧点垂直分布密，检查 Y 距离；右侧点水平分布密，检查 X 距离
        y_dist = abs(curr_y - last_labeled_y)
        x_dist = abs(curr_x - last_labeled_x)
        
        # 关键点标记：起点、终点、推荐点
        is_critical = (i == 0 or i == len(alpha_vals) - 1 or abs(txt - 0.55) < 0.01)
        
        # 只有距离够远或者是关键点才标注
        if is_critical or y_dist > 4.0 or x_dist > 15.0:
            if i == 0:
                # 起始点标签
                plt.annotate(f"$\\alpha={txt}$", (curr_x, curr_y), xytext=(8, 6), 
                             textcoords='offset points', fontweight='bold', fontsize=9)
            elif i == len(alpha_vals) - 1:
                # 最后一个点：标签往右移，且微调高度避免被切边
                plt.annotate(f"$\\alpha={txt}$", (curr_x, curr_y), xytext=(7, -10), 
                             textcoords='offset points', fontweight='bold', va='bottom', fontsize=9)
            elif curr_x < 110:
                # 左侧陡峭区：标签向右偏移更多，防止堆叠在折线上
                plt.annotate(f"$\\alpha={txt}$", (curr_x, curr_y), xytext=(12, 2), 
                             textcoords='offset points', fontsize=9)
            else:
                # 普通中间点
                plt.annotate(f"$\\alpha={txt}$", (curr_x, curr_y), xytext=(7, 5), 
                             textcoords='offset points', fontsize=9)
            
            last_labeled_y = curr_y
            last_labeled_x = curr_x
            
    # Highlight "Recommended" Elbow point
    mid_idx = len(results) // 2
    rec_time, rec_cost = times[mid_idx], costs[mid_idx]
    
    # 五角星置于最顶层 (zorder=5)
    plt.plot(rec_time, rec_cost, 'r*', markersize=18, label='Recommended (Balanced)', zorder=5, markeredgecolor='white')
    
    plt.title('Pareto Frontier: Cost vs. Time Trade-off', fontsize=16, fontweight='bold', pad=15)
    plt.xlabel('Completion Time (Years)', fontsize=12)
    plt.ylabel('Total Cost (Trillion USD)', fontsize=12)
    plt.grid(True, which="both", ls="--", alpha=0.3)
    
    # 丰富右上角的图注 (Legend)
    from matplotlib.lines import Line2D
    legend_elements = [
        Line2D([0], [0], color='#440154', lw=4, label=r'Priority: Speed (Low $\alpha$)'),
        Line2D([0], [0], color='#fde725', lw=4, label=r'Priority: Economy (High $\alpha$)'),
        Line2D([0], [0], marker='*', color='w', label='Optimal Balance',
               markerfacecolor='r', markersize=15, markeredgecolor='white'),
    ]
    plt.legend(handles=legend_elements, loc='upper right', frameon=True, shadow=True, title="Decision Strategies")
    
    # 强制绘制最后一个点，防止被遮挡或切除
    plt.scatter([times[-1]], [costs[-1]], color='#fde725', s=80, zorder=10, edgecolors="#ffffff", linewidth=1.2)
    
    # 设置坐标轴范围
    plt.xlim(left=min(times)-5, right=155)
    
    # Add arrow for interpretation
    plt.annotate('Faster but Expensive', xy=(min(times), max(costs)), xytext=(min(times)+15, max(costs)-5),
             arrowprops=dict(facecolor='#00D2FC', edgecolor='none', shrink=0.05, width=3),
             fontsize=10, fontweight='bold', color='#009EFA')
             
    plt.annotate('Slower but Cheaper', xy=(max(times), min(costs)), xytext=(max(times)-20, min(costs)+18),
             arrowprops=dict(facecolor='#00D2FC', edgecolor='none', shrink=0.05, width=3),
             fontsize=10, fontweight='bold', color='#009EFA')

    output_path = 'd:\\desktop\\新建文件夹\\pareto_frontier.png'
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f"\nPlot saved to {output_path}")

if __name__ == "__main__":
    main()
