import gurobipy as gp
from gurobipy import GRB
import math

def solve_moon_logistics_final_optimized(alpha_weight=0.5):
    """
    最终优化版模型 (用户定制版):
    1. 载荷: 各基地固定，不随时间变化。
    2. 成本: 火箭基准成本和电梯火箭成本初始固定，随时间衰减。
    3. 频次: 随时间爬坡 (每十年增长)。
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 166         # 优化年限 (预计30-40年完工，设50留余量)

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
        
    # --- 目标函数 ---
    
    # 成本部分: 累加每年的费用
    # [修改] 使用动态计算的 dyn_cost_elevator_rocket[t]
    total_cost_usd = (
        gp.quicksum((x_e[t] * C_elevator_per_ton + x_e[t] * payload * dyn_cost_elevator_rocket[t]) for t in years) + 
        gp.quicksum(x_r[i, t] * dyn_cost_per_site[t][i] for i in site_names for t in years)
    )
    
    # 时间部分: 活跃年数之和
    total_years = gp.quicksum(u[t] for t in years)
    
    # 归一化: 成本单位转换为 "Trillion USD" (万亿美元) 以便与 "Years" 在数量级上接近
    obj = alpha_weight * (total_cost_usd / 1e12) + (1 - alpha_weight) * total_years
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 4. 求解与输出
    # =========================================================================
    model.optimize()
    
    print("\n" + "="*40)
    print(f"优化结果 (Alpha={alpha_weight})")
    print("="*40)
    
    if model.status == GRB.OPTIMAL:
        t_val = total_years.getValue()
        c_val = total_cost_usd.getValue()
        
        print(f"1. 完工时间: {t_val:.0f} 年")
        print(f"2. 总成本:   ${c_val/1e12:.3f} Trillion (万亿美元)")
        
        # 统计总量
        sum_e = sum(x_e[t].X for t in years)
        sum_r = sum(sum(x_r[i,t].X for i in site_names) for t in years)
        
        print(f"3. 运输结构: 电梯 {sum_e*payload/1e6:.2f} M tons | 火箭 {sum_r/1e6:.2f} M tons")
        
        print("\n4. 基地使用策略 (按总运量排序):")
        usage_stats = []
        for i in site_names:
            total_mass = sum(x_r[i, t].X for t in years)

            # 记录该基地的固定载荷，用于展示
            p_load = site_payloads[i]
            usage_stats.append((i, total_mass,p_load))
            
        usage_stats.sort(key=lambda x: x[1], reverse=True)
        
        print(f"{'Site Name':<15} | {'Payload(t)':<12} | {'Total Mass(Mt)':<15} ")
        print("-" * 50)
        for name, mass, payload1 in usage_stats:
            if mass > 0.01: # 只显示有实际贡献的
                print(f"{name:<15} | {payload1:<12.1f} | {mass/1e6:<15.2f} ")
                
        # 简要时间轴分析 (每10年汇总)
        print("\n5. 时间段运量与成本汇总 (每10年):")
        
        # 定义时间段: 1-10, 11-20, ...
        intervals = []
        start_year = 1
        while start_year <= t_val:
            end_year = min(start_year + 9, int(t_val))
            intervals.append((start_year, end_year))
            start_year += 10
            
        initial_cost = Initial_C_elevator_rocket_per_ton
        
        print(f"{'Period':<15} | {'Rocket Vol(Mt)':<15} | {'Elevator Vol(Mt)':<18} | {'Rocket Cost($B)':<16} | {'Elevator Cost($B)':<16}")
        print("-" * 90)

        for t_start, t_end in intervals:
            # 初始化该时间段的累加器
            period_r_vol = 0
            period_e_payload = 0
            period_r_cost = 0
            period_e_cost = 0
            
            for t in range(t_start, t_end + 1):
                # 1. 运量累加
                period_r_vol += sum(x_r[i,t].X for i in site_names)
                
                e_vol_t = x_e[t].X
                # [关键修正] 确保 payload 是比例因子 (0.867)，不是吨数
                # 电梯有效载荷 = 电梯总挂载重 * 有效载荷比
                e_effective_payload = e_vol_t * payload 
                period_e_payload += e_effective_payload
                
                # 2. 成本累加
                period_r_cost += sum(x_r[i,t].X * dyn_cost_per_site[t][i] for i in site_names)
                
                # 电梯端火箭动态成本
                cost_factor_now = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate*(t-1)))
                ele_rock_unit_cost = initial_cost * cost_factor_now
                
                # [关键修正] 成本计算
                # 电梯总成本 = (挂载重 * 提升单价) + (有效载荷 * 火箭单价) 
                # 注意: C_elevator_per_ton 是按挂载重计费，还是按有效载荷？通常是按挂载重。
                curr_e_cost = (e_vol_t * C_elevator_per_ton) + (e_effective_payload * ele_rock_unit_cost)
                period_e_cost += curr_e_cost

            # [输出] 1 Mt = 1e6 Tons, 1 B = 1e9 USD
            print(f"{f'Year {t_start}-{t_end}':<15} | {period_r_vol/1e6:<15.2f} | {period_e_payload/1e6:<18.2f} | ${period_r_cost/1e9:<15.2f} | ${period_e_cost/1e9:<15.2f}")
    else:
        print("求解失败 (可能时间限制 Max_Horizon 太短，建议增加)")

# --- 执行求解 ---
# 调节 alpha_weight: 
# 0.9 = 极其省钱 (可能会拖久一点)
# 0.1 = 极其赶时间 (不惜一切代价)
# 0.5 = 平衡
solve_moon_logistics_final_optimized(alpha_weight=0.5)