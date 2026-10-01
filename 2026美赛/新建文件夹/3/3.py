import gurobipy as gp
from gurobipy import GRB
import math

def solve_moon_logistics_monthly(alpha_weight=0.5):
    """
    月度规划版模型:
    1. 期限: 1年 (12个月)。
    2. 变量: 月运量。
    3. 动态因子: 去除 (成本、频次固定)。
    4. 目标: 在12个月内完成总需求，最小化成本和时间。
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    # 6万吨的年度水补给需求
    M_total = 60000            
    
    Max_Horizon = 12         # 优化期限: 12个月

    gama = 0.25              # 太空电梯燃料优化率
    
    # 太空电梯参数
    payload = 1 / (1.01 * gama + 1)     # 电梯顶部发射的火箭的载荷比例
    C_elevator_per_ton = 1330           # 电梯运行成本 USD/ton (固定)
    
    # --- 基地数据表 ---
    Unified_Cost_Per_Ton = 4927 * 1000  # USD/ton

    # 电梯火箭成本 (固定)
    Initial_C_elevator_rocket_per_ton = Unified_Cost_Per_Ton * gama
    
    # 容量转换: 年化 -> 月化
    Cap_elevator_sys_annual = 179000 * 3   # 53.7万吨/年
    Cap_elevator_sys_monthly = Cap_elevator_sys_annual / 12.0
    
    # 基地特定载荷 (Tons, 不变)
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

    # 基地基础数据 (初始频次为年化频次)
    # 假设这里的 initial_freq 是每年的发射次数
    site_data = {
        "French Guiana": {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 200}, 
        "India":         {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 200},
        "Texas":         {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 500}, 
        "Florida":       {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 500}, 
        "California":    {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 50},
        "Virginia":      {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 50},
        "China":         {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 200},
        "New Zealand":   {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 50},
        "Kazakhstan":    {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 200},
        "Alaska":        {"cost_per_ton": Unified_Cost_Per_Ton, "annual_freq": 50}   
    }
    site_names = list(site_data.keys())

    # =========================================================================
    # 2. 参数设定 (静态)
    # =========================================================================
    months = range(1, Max_Horizon + 1)
    
    # 存储每个基地的月运力上限
    site_monthly_cap = {}
    
    print(f"{'Site Name':<15} | {'Annual Freq':<12} | {'Monthly Freq':<12} | {'Monthly Cap(t)':<15}")
    print("-" * 70)
    
    total_monthly_cap_all = Cap_elevator_sys_monthly * payload # 电梯有效载荷预估
    
    for name, info in site_data.items():
        # 月频次 = 年频次 / 12
        monthly_freq = info["annual_freq"] / 12.0
        # 月运力 = 单次载荷 * 月频次
        site_monthly_cap[name] = site_payloads[name] * monthly_freq
        
        total_monthly_cap_all += site_monthly_cap[name]
        
        print(f"{name:<15} | {info['annual_freq']:<12} | {monthly_freq:<12.2f} | {site_monthly_cap[name]:<15.2f}")

    print("-" * 70)
    print(f"系统总月度运力(估算): {total_monthly_cap_all:.2f} tons")
    print(f"系统总年度运力(估算): {total_monthly_cap_all * 12:.2f} tons")
    print(f"目标总需求:        {M_total:.2f} tons")
    
    if M_total > total_monthly_cap_all * 12:
        print("\n[警告] 目标总需求超过了系统一年的理论总运力！模型可能无解。")

    # =========================================================================
    # 3. Gurobi 建模
    # =========================================================================
    model = gp.Model("Moon_Logistics_Monthly")
    model.setParam('OutputFlag', 0)
    
    # --- 变量 ---
    x_e = model.addVars(months, lb=0, name="Elevator_Tons")
    x_r = model.addVars(site_names, months, lb=0, name="Rocket_Tons")
    u = model.addVars(months, vtype=GRB.BINARY, name="Is_Active") # 1=当月还在运输
    
    # --- 约束 ---
    
    # 1. 总需求满足
    total_transport = gp.quicksum((x_e[t] * payload) for t in months) + \
                      gp.quicksum(x_r[i, t] for i in site_names for t in months)
    model.addConstr(total_transport >= M_total, "Demand_Constraint")
    
    # 2. 运力上限 (月度固定)
    for t in months:
        # 电梯
        model.addConstr(x_e[t] <= Cap_elevator_sys_monthly * u[t], f"Cap_Ele_{t}")
        
        # 火箭
        for i in site_names:
            model.addConstr(x_r[i, t] <= site_monthly_cap[i] * u[t], f"Cap_Rock_{i}_{t}")
            
    # 3. 时间连续性 (不能中间断档)
    for t in range(1, Max_Horizon):
        model.addConstr(u[t] >= u[t+1])
        
    # --- 目标函数 ---
    
    # 成本部分: 累加每月的费用
    total_cost_usd = (
        gp.quicksum((x_e[t] * C_elevator_per_ton + x_e[t] * payload * Initial_C_elevator_rocket_per_ton) for t in months) + 
        gp.quicksum(x_r[i, t] * site_data[i]["cost_per_ton"] for i in site_names for t in months)
    )
    
    # 时间部分: 活跃月数之和
    total_months_active = gp.quicksum(u[t] for t in months)
    
    # 归一化修正: 
    # 对于 6万吨需求，总成本预计在 700亿-3000亿 USD 之间。
    # 使用 1e11 (1000亿) 作为归一化分母，使得 Cost Term 约为 0.7 - 3.0
    # 时间 Term (Months/12) 约为 0.1 - 1.0
    # 这样两者量级接近，alpha 权重才能正常发挥作用。
    obj = alpha_weight * (total_cost_usd / 1e11) + (1 - alpha_weight) * (total_months_active / 12.0)
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 4. 求解与输出
    # =========================================================================
    model.optimize()
    
    print("\n" + "="*40)
    print(f"优化结果 (Alpha={alpha_weight})")
    print("="*40)
    
    if model.status == GRB.OPTIMAL:
        t_val = total_months_active.getValue()
        c_val = total_cost_usd.getValue()
        
        print(f"1. 完工时间: {t_val:.0f} 个月")
        print(f"2. 总成本:   ${c_val/1e9:.3f} Billion (十亿美元)")
        
        # 统计总量
        sum_e = sum(x_e[t].X for t in months)
        sum_r = sum(sum(x_r[i,t].X for i in site_names) for t in months)
        
        print(f"3. 运输结构: 电梯 {sum_e*payload/1e6:.4f} M tons | 火箭 {sum_r/1e6:.4f} M tons")
        
        print(f"\n4. 基地使用策略 (按总运量排序):")
        usage_stats = []
        for i in site_names:
            total_mass = sum(x_r[i, t].X for t in months)
            p_load = site_payloads[i]
            usage_stats.append((i, total_mass, p_load))
            
        usage_stats.sort(key=lambda x: x[1], reverse=True)
        
        print(f"{'Site Name':<15} | {'Payload(t)':<12} | {'Total Mass(t)':<15} ")
        print("-" * 50)
        for name, mass, payload1 in usage_stats:
            if mass > 0.01:
                print(f"{name:<15} | {payload1:<12.1f} | {mass:<15.2f} ")
                
        print("\n5. 每月运量与成本汇总:")
        print(f"{'Month':<10} | {'Rocket Vol(t)':<15} | {'Elevator Vol(t)':<18} | {'Rocket Cost($B)':<16} | {'Elevator Cost($B)':<16}")
        print("-" * 80)

        for t in range(1, int(t_val) + 1):
            # 运量
            r_vol_t = sum(x_r[i,t].X for i in site_names)
            e_vol_t = x_e[t].X
            e_effective_payload = e_vol_t * payload 
            
            # 成本
            r_cost_t = sum(x_r[i,t].X * site_data[i]["cost_per_ton"] for i in site_names)
            e_cost_t = (e_vol_t * C_elevator_per_ton) + (e_effective_payload * Initial_C_elevator_rocket_per_ton)

            print(f"{t:<10} | {r_vol_t:<15.2f} | {e_effective_payload:<18.2f} | ${r_cost_t/1e9:<15.3f} | ${e_cost_t/1e9:<15.3f}")
    else:
        print("求解失败 (Infeasible)")
        print("建议: 减小 M_total 或增加基地/电梯运力参数。")

# --- 执行求解 ---
# 调节 alpha_weight: 
# 0.9 = 极其省钱 (可能会拖久一点)
# 0.1 = 极其赶时间 (不惜一切代价)
# 0.5 = 平衡
solve_moon_logistics_monthly(alpha_weight=0.5)