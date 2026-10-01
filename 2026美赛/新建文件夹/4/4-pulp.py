import pulp
import math
import numpy as np
import matplotlib.pyplot as plt

# 设置matplotlib中文显示
plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False

# =============================================================================
# 环境影响参数定义 (Question 4 Extension)
# =============================================================================

# 基础环境代价 (单位: 影响点数/次发射)
BASE_ATM = 4000      # 大气层破坏
BASE_RES = 2200      # 资源/能源消耗
BASE_DEBRIS = 500    # 空间碎片风险 (已含权重)
BASE_LOCAL = 500     # 本地生态干扰

# 基地生态敏感度系数
SITE_SENSITIVITY = {
    "Florida": 1.5, "French Guiana": 1.5,      # 湿地/雨林 (高敏感)
    "Texas": 0.8, "Kazakhstan": 0.8, "China": 0.8,  # 荒漠/内陆 (低敏感)
    "India": 1.0, "California": 1.0, "Virginia": 1.0, 
    "New Zealand": 1.0, "Alaska": 1.0           # 标准
}

# 归一化参考值 - [修改] 调整基准值以对齐 1-2.py 量纲
REF_COST = 1e12      # 1 Trillion USD (Cost部分保持 /1e12)
REF_TIME = 1.0       # [关键修正] 设为1.0 (不缩小时间)，直接使用"年"作为惩罚值
REF_ENV = 20e6       # [调整] 20 Million. Env总量约 1500M-3000M。除以20M后约为 75-150，与Cost(60)和Time(110)量级匹配

def solve_moon_logistics_pulp(alpha_weight=0.35, beta_weight=0.35, gamma_weight=0.30, return_solution=False):
    """
    使用PuLP求解器替代Gurobi
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 300         # 优化年限

    gama = 0.25              # 太空电梯燃料优化率
    
    # 太空电梯参数
    payload = 1 / (1.01 * gama + 1)     #电梯顶部发射的火箭的载荷比例
    C_elevator_per_ton = 1330       # $1.33/kg = $1330/ton
    
    # --- 基地数据表 ---
    Unified_Cost_Per_Ton = 4927 * 1000

    Initial_C_elevator_rocket_per_ton = Unified_Cost_Per_Ton * gama
    
    Cap_elevator_sys = 179000 * 3   # 53.7万吨/年
    
    Cost_Decay_Rate = 0.02 
    Cost_Min_Floor  = 0.2
    Freq_Growth_Per_Decade = 0.15

    site_payloads = {
        "French Guiana": 146.3,
        "India":         140.3,
        "Texas":         130.5,
        "Florida":       129.0,
        "California":    124.5,
        "Virginia":      122.3,
        "China":         120.8,
        "New Zealand":   120.8,
        "Kazakhstan":    115.5,
        "Alaska":        107.3
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

    env_impact_per_launch = {}
    for name in site_names:
        sens = SITE_SENSITIVITY.get(name, 1.0)
        env_cost = BASE_ATM + BASE_RES + BASE_DEBRIS + (BASE_LOCAL * sens)
        env_impact_per_launch[name] = env_cost

    # =========================================================================
    # Pre-calculation
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
    # PuLP 模型构建
    # =========================================================================
    model = pulp.LpProblem("Moon_Logistics_Optimized", pulp.LpMinimize)
    
    # 变量
    x_e = pulp.LpVariable.dicts("Elevator_Tons", years, lowBound=0)
    x_r = pulp.LpVariable.dicts("Rocket_Tons", (site_names, years), lowBound=0)
    u = pulp.LpVariable.dicts("Is_Active", years, cat='Binary')

    # 目标函数项
    # PuLP 不支持复杂的生成器表达式直接相加，最好先构建表达式对象
    
    cost_terms = []
    env_terms = []
    
    for t in years:
        # 电梯成本
        ele_cost_t = x_e[t] * C_elevator_per_ton + x_e[t] * payload * dyn_cost_elevator_rocket[t]
        cost_terms.append(ele_cost_t)
        
        for i in site_names:
            # 火箭成本
            rock_cost_t = x_r[i][t] * dyn_cost_per_site[t][i]
            cost_terms.append(rock_cost_t)
            
            # 环境影响
            env_impact_t = x_r[i][t] * (env_impact_per_launch[i] / site_payloads[i])
            env_terms.append(env_impact_t)

    total_cost_usd = pulp.lpSum(cost_terms)
    total_env_impact = pulp.lpSum(env_terms)
    total_years = pulp.lpSum([u[t] for t in years])

    # 综合目标函数 (Weighted Normalized Sum)
    model += (alpha_weight * (total_cost_usd / REF_COST) + 
              beta_weight * (total_years / REF_TIME) + 
              gamma_weight * (total_env_impact / REF_ENV))

    # 约束
    # 1. 总需求
    total_transport_terms = [x_e[t] * payload for t in years] + \
                            [x_r[i][t] for i in site_names for t in years]
    model += pulp.lpSum(total_transport_terms) >= M_total, "Demand_Constraint"

    # 2. 运力上限
    for t in years:
        model += x_e[t] <= Cap_elevator_sys * u[t], f"Cap_Ele_{t}"
        for i in site_names:
            model += x_r[i][t] <= dyn_cap_per_site[t][i] * u[t], f"Cap_Rock_{i}_{t}"

    # 3. 时间连续性
    for t in range(1, Max_Horizon):
        model += u[t] >= u[t+1], f"Continuity_{t}"

    # 求解
    # 使用 COIN-OR CBC 求解器 (PuLP 内置)
    # 增加 msg=0 关闭日志
    status = model.solve(pulp.PULP_CBC_CMD(msg=0))
    
    solution_data = {}
    
    if pulp.LpStatus[status] == 'Optimal':
        # 计算实际指标值
        t_val = pulp.value(total_years)
        c_val = pulp.value(total_cost_usd)
        e_val = pulp.value(total_env_impact)
        
        print("\n" + "="*60)
        print(f"PuLP 优化结果 (Alpha={alpha_weight}, Beta={beta_weight}, Gamma={gamma_weight})")
        print("="*60)
        print(f"1. 完工时间: {t_val:.0f} 年")
        print(f"2. 总成本:   ${c_val/1e12:.3f} Trillion (万亿美元)")
        print(f"3. 环境代价: {e_val/1e6:.2f} M Pts (EII)")
        
        sum_e = sum(pulp.value(x_e[t]) for t in years)
        sum_r_mass = sum(sum(pulp.value(x_r[i][t]) for i in site_names) for t in years)
        print(f"4. 运输结构: 电梯 {sum_e*payload/1e6:.2f} M tons | 火箭 {sum_r_mass/1e6:.2f} M tons")

        # 详细统计
        usage_stats = []
        for i in site_names:
            total_mass = sum(pulp.value(x_r[i][t]) for t in years)
            site_env_imp = sum((pulp.value(x_r[i][t]) / site_payloads[i]) * env_impact_per_launch[i] for t in years)
            
            p_load = site_payloads[i]
            sens = SITE_SENSITIVITY.get(i, 1.0)
            usage_stats.append({
                "name": i, 
                "mass": total_mass, 
                "payload": p_load, 
                "env": site_env_imp, 
                "sens": sens
            })
        
        usage_stats.sort(key=lambda x: x["mass"], reverse=True)
        
        # Yearly Data
        yearly_data = []
        initial_cost = Initial_C_elevator_rocket_per_ton
        
        for t in range(1, int(t_val) + 1):
            r_cost_t = sum(pulp.value(x_r[i][t]) * dyn_cost_per_site[t][i] for i in site_names)
            
            e_vol_t = pulp.value(x_e[t])
            e_effective_payload = e_vol_t * payload 
            cost_factor_now = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate*(t-1)))
            ele_rock_unit_cost = initial_cost * cost_factor_now
            e_cost_t = (e_vol_t * C_elevator_per_ton) + (e_effective_payload * ele_rock_unit_cost)
            
            r_env_t = sum((pulp.value(x_r[i][t]) / site_payloads[i]) * env_impact_per_launch[i] for i in site_names)
            
            yearly_data.append({
                "year": t,
                "rocket_mass": sum(pulp.value(x_r[i][t]) for i in site_names),
                "elevator_mass": e_effective_payload,
                "total_cost": r_cost_t + e_cost_t,
                "env_impact": r_env_t
            })

        solution_data = {
            "status": "Optimal",
            "time": t_val,
            "cost": c_val,
            "env": e_val,
            "site_stats": usage_stats,
            "yearly_stats": yearly_data,
            "weights": (alpha_weight, beta_weight, gamma_weight)
        }
    else:
        print("求解失败或未找到最优解")
        solution_data = {"status": pulp.LpStatus[status]}
        
    return solution_data

def plot_gamma_sensitivity(results):
    """
    绘制 Gamma 敏感度分析图 (帕累托前沿 + 趋势图)
    """
    if not results:
        print("无有效结果，无法绘图")
        return

    # 提取数据
    gammas = [r['weights'][2] for r in results]
    costs = [r['cost']/1e12 for r in results]   # Trillion USD
    times = [r['time'] for r in results]        # Years
    envs  = [r['env']/1e6 for r in results]     # Million Points

    fig = plt.figure(figsize=(14, 6))

    # [子图1] 成本 vs 时间 (颜色=Gamma) - 经典的帕累托权衡视图
    ax1 = fig.add_subplot(1, 2, 1)
    scatter = ax1.scatter(costs, times, c=gammas, cmap='viridis', s=100, edgecolors='k', zorder=10)
    
    # 连接点以显示趋势
    ax1.plot(costs, times, 'k--', alpha=0.3, zorder=1)
    
    ax1.set_xlabel('Total Cost (Trillion USD)', fontsize=12)
    ax1.set_ylabel('Completion Time (Years)', fontsize=12)
    ax1.set_title('Pareto Frontier: Cost vs Time\n(Color represents Env Weight Gamma)', fontsize=14)
    ax1.grid(True, linestyle='--', alpha=0.7)
    
    # 添加颜色条
    cbar = plt.colorbar(scatter, ax=ax1)
    cbar.set_label('Gamma (Environment Weight)', fontsize=10)

    # [子图2] 归一化指标随 Gamma 变化趋势
    ax2 = fig.add_subplot(1, 2, 2)
    
    # 为了在同一张图显示，进行简单归一化 (以此组数据的最大值为基准)
    max_c = max(costs) if costs else 1
    max_t = max(times) if times else 1
    max_e = max(envs) if envs else 1
    
    norm_c = [c/max_c for c in costs]
    norm_t = [t/max_t for t in times]
    norm_e = [e/max_e for e in envs]
    
    ax2.plot(gammas, norm_c, 'o-', color='#1f77b4', label=f'Cost (Max={max_c:.1f}T)', linewidth=2)
    ax2.plot(gammas, norm_t, 's-', color='#ff7f0e', label=f'Time (Max={max_t:.0f}y)', linewidth=2)
    ax2.plot(gammas, norm_e, '^--', color='#2ca02c', label=f'Env Impact (Max={max_e:.0f}M)', linewidth=2)
    
    ax2.set_xlabel('Gamma (Environment Weight)', fontsize=12)
    ax2.set_ylabel('Normalized Score (Relative to Max)', fontsize=12)
    ax2.set_title('Sensitivity Analysis: Objectives vs Gamma', fontsize=14)
    ax2.grid(True, linestyle='--', alpha=0.7)
    ax2.legend(fontsize=10)

    plt.tight_layout()
    output_path = '4/gamma_sensitivity_pareto.png'
    plt.savefig(output_path, dpi=300)
    print(f"\n[Success] 图表已保存至: {output_path}")

if __name__ == "__main__":
    print("Running PuLP Optimization with Gamma Sensitivity Analysis...")
    pareto_results = []
    
    # 生成权重序列: Gamma 从 0.0 到 0.9
    # Alpha = Beta = (1 - Gamma) / 2
    gamma_values = np.linspace(0, 0.9, 20) # 10个点
    
    weights_list = []
    for g in gamma_values:
        remaining = 1.0 - g
        a = remaining / 2
        b = remaining / 2
        weights_list.append((a, b, g))

    print(f"Total scenarios to run: {len(weights_list)}")

    for idx, (a, b, c) in enumerate(weights_list):
        print(f"\nProcessing Scenario {idx+1}/{len(weights_list)} | Alpha={a:.3f}, Beta={b:.3f}, Gamma={c:.3f}")
        res = solve_moon_logistics_pulp(a, b, c)
        if res['status'] == 'Optimal':
            pareto_results.append(res)
        
    print("\nAll optimization tasks completed.")
    
    # 绘制帕累托图
    plot_gamma_sensitivity(pareto_results)
