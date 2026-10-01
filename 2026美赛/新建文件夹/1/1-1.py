import pulp
import math

def solve_moon_logistics_rocket_only_pulp(alpha_weight=0.5):
    """
    使用 PuLP (CBC Solver) 求解纯火箭模型
    修改:
    1. 载荷: 固定值 (不随时间增长)，差异化 Payload。
    2. 成本: 统一初始值 $3,282/kg，随时间衰减。
    """

    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 200        # 优化年限

    # 动态因子
    Cost_Decay_Rate = 0.01
    Cost_Min_Floor  = 0.2
    
    # [修改] 频次增长保持不变，但载荷不再增长
    Freq_Growth_Per_Decade = 0.20
    
    # [修改] 统一初始成本
    Unified_Cost_Per_Ton = 4927 * 1000 

    # [修改] 载荷固定值 (Tons)
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
    
    # 频次数据 (保持之前的差异化设定)
    site_freqs = {
        "French Guiana": 200,
        "India":         200,
        "Texas":         500,
        "Florida":       500,
        "California":    50,
        "Virginia":      50,
        "China":         200,
        "New Zealand":   50,
        "Kazakhstan":    200,
        "Alaska":        50 
    }
    
    site_names = list(site_payloads.keys())

    # =========================================================================
    # 2. 预计算参数
    # =========================================================================
    years = list(range(1, Max_Horizon + 1))
    dyn_cap_per_site = {}
    dyn_cost_per_site = {}

    print("正在预计算参数...")
    for t in years:
        # A. 计算当年的因子
        # 成本因子: 指数衰减 (保留)
        cost_factor = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate * (t-1)))
        
        # 频次因子: 阶梯增长 (保留)
        decade_idx = (t - 1) // 10
        freq_multiplier = (1 + Freq_Growth_Per_Decade) ** decade_idx

        dyn_cap_per_site[t] = {}
        dyn_cost_per_site[t] = {}

        for name in site_names:
            # 1. 动态载荷 = 固定值 (不增长)
            current_payload = site_payloads[name]
            
            # 2. 动态频次 = 初始频次 * 频次增长因子
            current_freq = site_freqs[name] * freq_multiplier
            
            # 3. 计算当年该基地总运力上限 (Tons)
            dyn_cap_per_site[t][name] = current_payload * current_freq
            
            # 4. 动态成本 = 统一初始成本 * 成本因子
            dyn_cost_per_site[t][name] = Unified_Cost_Per_Ton * cost_factor

    # =========================================================================
    # 3. PuLP 建模
    # =========================================================================
    print("正在构建模型 (PuLP)...")
    prob = pulp.LpProblem("Moon_Logistics_Rocket_Only", pulp.LpMinimize)

    # --- 变量 ---
    x_r = pulp.LpVariable.dicts("Rocket_Tons", (site_names, years), lowBound=0, cat='Continuous')
    u = pulp.LpVariable.dicts("Is_Active", years, cat='Binary')

    # --- 约束 ---
    
    # 1. 总需求
    prob += pulp.lpSum([x_r[i][t] for i in site_names for t in years]) >= M_total, "Total_Demand"

    # 2. 运力上限
    for t in years:
        for i in site_names:
            prob += x_r[i][t] <= dyn_cap_per_site[t][i] * u[t], f"Cap_{i}_{t}"

    # 3. 时间连续性
    for t in range(1, Max_Horizon):
        prob += u[t] >= u[t+1], f"Continuity_{t}"

    # --- 目标函数 ---
    
    # 成本项: 总花费 (美元)
    total_cost_usd = pulp.lpSum([x_r[i][t] * dyn_cost_per_site[t][i] for i in site_names for t in years])
    
    # 时间项: 总年数
    total_years = pulp.lpSum([u[t] for t in years])

    # 归一化: Cost (Trillion) vs Time (Years)
    cost_in_trillions = total_cost_usd / 1e12
    time_in_years = total_years
    
    beta_weight = 1.0 - alpha_weight
    
    prob += alpha_weight * cost_in_trillions + beta_weight * time_in_years, "Objective"

    # =========================================================================
    # 4. 求解
    # =========================================================================
    print(f"开始求解... (Alpha={alpha_weight})")
    prob.solve(pulp.PULP_CBC_CMD(msg=0)) 

    print("\n" + "="*40)
    print(f"PuLP 优化结果 (纯火箭, 固定载荷, 统一成本)")
    print("="*40)
    
    if pulp.LpStatus[prob.status] == "Optimal":
        final_years = sum(u[t].varValue for t in years)
        final_cost = sum(x_r[i][t].varValue * dyn_cost_per_site[t][i] for i in site_names for t in years)
        total_mass = sum(x_r[i][t].varValue for i in site_names for t in years)

        print(f"1. 完工时间: {final_years:.0f} 年")
        print(f"2. 总成本:   ${final_cost/1e12:.3f} Trillion")
        print(f"3. 运输总量: {total_mass/1e6:.2f} M tons")

        print("\n4. 基地使用策略:")
        usage_stats = []
        for i in site_names:
            m = sum(x_r[i][t].varValue for t in years)
            if m > 1e-4:
                # 计算平均成本
                cost_part = sum(x_r[i][t].varValue * dyn_cost_per_site[t][i] for t in years)
                avg_c = cost_part / m
                usage_stats.append((i, m, avg_c))
        
        usage_stats.sort(key=lambda x: x[1], reverse=True)
        
        print(f"{'Site Name':<15} | {'Mass(Mt)':<10} | {'Avg Cost($/t)':<15}")
        print("-" * 45)
        for name, mass, cost in usage_stats:
            print(f"{name:<15} | {mass/1e6:<10.2f} | ${cost:<.0f}")

    else:
        print("无解 (可能 Horizon 太短)")

if __name__ == "__main__":
    solve_moon_logistics_rocket_only_pulp(alpha_weight=0)
