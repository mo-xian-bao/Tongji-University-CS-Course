import gurobipy as gp
from gurobipy import GRB
import math
import numpy as np

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

# 归一化参考值
# [修正] 对齐 1-2.py 的量纲逻辑
REF_COST = 1e12      # 1 Trillion USD (Cost部分保持 /1e12)
REF_TIME = 1.0       # [关键修正] 设为1.0 (不缩小时间)，直接使用"年"作为惩罚值，与 1-2.py 保持一致
REF_ENV = 20e6       # [调整] 20 Million. Env总量约 1500M-3000M。除以20M后约为 75-150，与Cost(60)和Time(110)量级匹配

def solve_moon_logistics_final_optimized(alpha_weight=0.35, beta_weight=0.35, gamma_weight=0.30, return_solution=False):
    """
    最终优化版模型 (用户定制版) - 增加环境影响目标 (Question 4 Extension)
    
    三目标优化:
    Obj = alpha * (Cost/Ref_Cost) + beta * (Time/Ref_Time) + gamma * (Env/Ref_Env)
    
    参数:
        alpha_weight: 成本权重
        beta_weight: 时间权重  
        gamma_weight: 环境权重
        return_solution: 是否返回详细解数据
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 166        # [恢复] 166年以适应 License 限制 (PuLP可对应144年，故166够用)

    gama = 0.25              # 太空电梯燃料优化率
    
    # 太空电梯参数
    payload=1 / (1.01 * gama + 1)     #电梯顶部发射的火箭的载荷比例
    C_elevator_per_ton = 1330       # $1.33/kg = $1330/ton (电梯本身运行成本，不仅随时间变)
    
    # --- 基地数据表 ---
    # 统一成本: 4000 USD/kg = 4,927,000 USD/ton
    Unified_Cost_Per_Ton = 4927 * 1000

    # [修改] 定义电梯火箭初始成本
    Initial_C_elevator_rocket_per_ton = Unified_Cost_Per_Ton * gama     # $1.035M/ton
    
    Cap_elevator_sys = 179000 * 3   # 53.7万吨/年
    
    # --- 动态因子设定 ---
    # 1. 成本下降: 每年降低 1% (规模效应 + 学习曲线)
    # [修改] 这个衰减率将同时应用于基准火箭成本 和 电梯火箭成本
    Cost_Decay_Rate = 0.02 
    Cost_Min_Floor  = 0.2  # 最低降至初始值的 20%
    
    # 2. 频次增长: 每十年按比例增长
    Freq_Growth_Per_Decade = 0.15  # 每十年增长 10%


    
    # 基地特定载荷 (Tons) - 固定不随时间改变
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

    # 基地基础数据
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
    # [新增] 计算各基地单次发射环境代价
    # =========================================================================
    env_impact_per_launch = {}
    for name in site_names:
        sens = SITE_SENSITIVITY.get(name, 1.0)
        # 环境代价 = 大气 + 资源 + 碎片 + (本地 * 敏感度)
        env_cost = BASE_ATM + BASE_RES + BASE_DEBRIS + (BASE_LOCAL * sens)
        env_impact_per_launch[name] = env_cost

    # =========================================================================
    # 2. 预计算动态参数 (Pre-calculation)
    # =========================================================================
    years = range(1, Max_Horizon + 1)
    
    # 存储每年、每个基地的具体参数
    dyn_cap_per_site = {}   # {year: {site: capacity_tons}}
    dyn_cost_per_site = {}  # {year: {site: cost_per_ton}}
    
    # [新增] 存储每年的电梯火箭成本
    dyn_cost_elevator_rocket = {} # {year: cost_per_ton}
    
    print(f"{'Year':<5} | {'Cost Factor':<15} | {'Freq Mult':<15}")
    print("-" * 60)
    
    for t in years:
        # A. 计算当年的因子
        # 成本因子: 指数衰减 (保留)
        cost_factor = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate * (t-1)))
         
        # 频次因子: 每十年阶梯增长 (保留)
        decade_idx = (t - 1) // 10
        freq_multiplier = (1 + Freq_Growth_Per_Decade) ** decade_idx
        
        if t % 10 == 1:
            print(f"{t:<5} | {cost_factor:<15.2f} | {freq_multiplier:<15.2f}")
            
        dyn_cap_per_site[t] = {}
        dyn_cost_per_site[t] = {}
        
        # [修改] 计算当年电梯顶端发射火箭的动态成本
        dyn_cost_elevator_rocket[t] = Initial_C_elevator_rocket_per_ton * cost_factor
        
        for name, info in site_data.items():
            # 1. 载荷 = 固定值 (不随时间改变)
            current_payload = site_payloads[name]
            
            # 2. 动态频次 = 初始频次 * 频次增长因子
            current_freq = info["initial_freq"] * freq_multiplier
            
            # 3. 计算当年该基地总运力上限 (Tons)
            dyn_cap_per_site[t][name] = current_payload * current_freq
            
            # 4. 动态成本 = 统一初始成本 * 成本因子
            dyn_cost_per_site[t][name] = info["cost_per_ton"] * cost_factor

    # =========================================================================
    # 3. Gurobi 建模
    # =========================================================================
    model = gp.Model("Moon_Logistics_Optimized")
    model.setParam('OutputFlag', 0)
    model.setParam('MIPGap', 0) # 强制全局最优
    # model.setParam('Presolve', 0) # Optional: 关闭预处理以防误删
    
    # --- 变量 ---
    x_e = model.addVars(years, lb=0, name="Elevator_Tons")
    x_r = model.addVars(site_names, years, lb=0, name="Rocket_Tons")
    u = model.addVars(years, vtype=GRB.BINARY, name="Is_Active") # 1=当年还在建设/运输
    
    # --- 约束 ---
    
    # 1. 总需求满足
    total_transport = gp.quicksum((x_e[t] * payload) for t in years) + \
                      gp.quicksum(x_r[i, t] for i in site_names for t in years)
    model.addConstr(total_transport >= M_total, "Demand_Constraint")
    
    # 2. 运力上限 (动态)
    for t in years:
        # 电梯 (假设稳定)
        model.addConstr(x_e[t] <= Cap_elevator_sys * u[t], f"Cap_Ele_{t}")
        
        # 火箭 (使用动态计算的上限)
        for i in site_names:
            model.addConstr(x_r[i, t] <= dyn_cap_per_site[t][i] * u[t], f"Cap_Rock_{i}_{t}")
            
    # 3. 时间连续性 (不能中间断档)
    for t in range(1, Max_Horizon):
        model.addConstr(u[t] >= u[t+1])
        
    # --- [修改] 多目标构建 ---
    
    # Objective 1: Cost ($ Trillion)
    total_cost_usd = (
        gp.quicksum((x_e[t] * C_elevator_per_ton + x_e[t] * payload * dyn_cost_elevator_rocket[t]) for t in years) + 
        gp.quicksum(x_r[i, t] * dyn_cost_per_site[t][i] for i in site_names for t in years)
    )
    
    # Objective 2: Time (Years)
    total_years = gp.quicksum(u[t] for t in years)
    
    # Objective 3: Environment (Impact Points)
    # 总发射次数 * 单次环境代价
    total_env_impact = gp.quicksum(
        (x_r[i, t] / site_payloads[i]) * env_impact_per_launch[i] 
        for i in site_names for t in years
    )
    
    # 综合目标函数 (Weighted Normalized Sum)
    obj = alpha_weight * (total_cost_usd / REF_COST) + \
          beta_weight * (total_years / REF_TIME) + \
          gamma_weight * (total_env_impact / REF_ENV)
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 4. 求解与输出
    # =========================================================================
    model.optimize()
    
    solution_data = {}
    
    if model.status == GRB.OPTIMAL:
        t_val = total_years.getValue()
        c_val = total_cost_usd.getValue()
        e_val = total_env_impact.getValue()
        
        print("\n" + "="*60)
        print(f"优化结果 (Alpha={alpha_weight}, Beta={beta_weight}, Gamma={gamma_weight})")
        print("="*60)
        
        # [新增] 调试输出详细目标函数分量
        cost_score = alpha_weight * (c_val / REF_COST)
        time_score = beta_weight * (t_val / REF_TIME)
        env_score  = gamma_weight * (e_val / REF_ENV)
        total_obj  = cost_score + time_score + env_score
        print(f"DEBUG: Obj = {total_obj:.4f} (Cost={cost_score:.4f}, Time={time_score:.4f}, Env={env_score:.4f})")
        
        print(f"1. 完工时间: {t_val:.0f} 年")
        print(f"2. 总成本:   ${c_val/1e12:.3f} Trillion (万亿美元)")
        # 假设 1 Impact Point ~= 500 t CO2e (估算值用于展示)
        co2_est_mt = (e_val * 500) / 1e6
        print(f"3. 环境代价: {e_val/1e6:.2f} M Pts (EII) | ~{co2_est_mt:.2f} Mt CO2e")
        
        # 统计总量
        sum_e = sum(x_e[t].X for t in years)
        sum_r = sum(sum(x_r[i,t].X for i in site_names) for t in years)
        
        print(f"4. 运输结构: 电梯 {sum_e*payload/1e6:.2f} M tons | 火箭 {sum_r/1e6:.2f} M tons")
        
        print("\n5. 基地使用与环境敏感度分析:")
        usage_stats = []
        for i in site_names:
            total_mass = sum(x_r[i, t].X for t in years)
            site_env_imp = sum((x_r[i, t].X / site_payloads[i]) * env_impact_per_launch[i] for t in years)
            
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
        
        print(f"{'Site Name':<15} | {'Mass(Mt)':<10} | {'Env(kPts)':<10} | {'Sens.':<8}")
        print("-" * 60)
        for s in usage_stats:
            if s["mass"] > 0.01: 
                print(f"{s['name']:<15} | {s['mass']/1e6:<10.2f} | {s['env']/1e3:<10.0f} | {s['sens']:<8.1f}")
                
        # 保存详细时间序列数据用于绘图
        yearly_data = []
        initial_cost = Initial_C_elevator_rocket_per_ton
        
        for t in range(1, int(t_val) + 1):
             # 成本计算逻辑复用
            r_cost_t = sum(x_r[i,t].X * dyn_cost_per_site[t][i] for i in site_names)
            
            e_vol_t = x_e[t].X
            e_effective_payload = e_vol_t * payload 
            cost_factor_now = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate*(t-1)))
            ele_rock_unit_cost = initial_cost * cost_factor_now
            e_cost_t = (e_vol_t * C_elevator_per_ton) + (e_effective_payload * ele_rock_unit_cost)
            
            # 环境
            r_env_t = sum((x_r[i, t].X / site_payloads[i]) * env_impact_per_launch[i] for i in site_names)
            
            yearly_data.append({
                "year": t,
                "rocket_mass": sum(x_r[i,t].X for i in site_names),
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
        print("求解失败 (可能时间限制 Max_Horizon 太短，建议增加)")
        solution_data = {"status": "Fail"}
        
    return solution_data

# =========================================================================


if __name__ == "__main__":
    # 1. 生成 Pareto 前沿数据 (运行多个权重组合)
    print("Generating Pareto Frontier Data...")
    pareto_results = []
    
    # 权重生成策略
    weights = []
    # [对比验证]
    # 场景 A: 也就是 1-2.py 的逻辑，不考虑环境 (Gamma=0)，只权衡 Cost/Time。预期结果 ~116-118年。
    weights.append((0.5, 0.5, 0.0))
    
    # 场景 B: 用户提到的场景。
    weights.append((0.5, 0.5, 0.25))

    for idx, (a, b, c) in enumerate(weights):
        print(f"Running scenario {idx+1}/{len(weights)}: a={a:.2f}, b={b:.2f}, c={c:.2f}")
        res = solve_moon_logistics_final_optimized(a, b, c)
        if res['status'] == 'Optimal':
            pareto_results.append(res)
        
    print("\nAll tasks completed.")
