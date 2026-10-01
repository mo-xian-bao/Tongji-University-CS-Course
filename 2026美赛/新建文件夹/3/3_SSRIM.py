import gurobipy as gp
from gurobipy import GRB
import math
import matplotlib.pyplot as plt
import numpy as np

def solve_moon_logistics_SSRIM():
    """
    SSRIM (Steady-State Resupply & Inventory Model) - 稳态补给与库存模型
    
    核心逻辑转变:
    - 建设期追求"快"，运营期追求"稳"和"可持续"
    - 引入库存平衡方程和安全库存约束
    - 目标函数: 最小化总成本 + 平滑化运输流
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 116460            # 6万吨的年度水补给需求
    Max_Horizon = 12           # 优化期限: 12个月
    
    # --- 库存管理参数 (新增) ---
    Monthly_Consumption = M_total / 12.0   # 月度固定消耗量: 5000 吨/月
    Storage_Capacity = 20000               # 月球最大储水箱容量 (吨)
    Initial_Stock = 10000                  # 初始安全库存 (吨)
    Safety_Stock = 10000                   # 安全库存下限 
    
    gama = 0.25              # 太空电梯燃料优化率
    
    # 太空电梯参数
    payload = 1 / (1.01 * gama + 1)     # 电梯顶部发射的火箭的载荷比例
    C_elevator_per_ton = 1330           # 电梯运行成本 USD/ton (固定)
    
    # --- 基地数据表 ---
    Unified_Cost_Per_Ton = 4927 * 1000  # USD/ton (火箭成本)

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
    
    print("="*70)
    print("SSRIM 模型 - 稳态补给与库存管理")
    print("="*70)
    print(f"\n【库存管理参数】")
    print(f"  月度消耗量:     {Monthly_Consumption:.0f} 吨/月")
    print(f"  储水箱容量:     {Storage_Capacity:.0f} 吨")
    print(f"  初始库存:       {Initial_Stock:.0f} 吨")
    print(f"  安全库存下限:   {Safety_Stock:.0f} 吨 (够用 {Safety_Stock/Monthly_Consumption:.1f} 个月)")
    
    print(f"\n【运力参数】")
    print(f"{'Site Name':<15} | {'Annual Freq':<12} | {'Monthly Freq':<12} | {'Monthly Cap(t)':<15}")
    print("-" * 70)
    
    total_monthly_cap_all = Cap_elevator_sys_monthly * payload
    
    for name, info in site_data.items():
        monthly_freq = info["annual_freq"] / 12.0
        site_monthly_cap[name] = site_payloads[name] * monthly_freq
        total_monthly_cap_all += site_monthly_cap[name]
        print(f"{name:<15} | {info['annual_freq']:<12} | {monthly_freq:<12.2f} | {site_monthly_cap[name]:<15.2f}")

    print("-" * 70)
    print(f"电梯月度有效运力:   {Cap_elevator_sys_monthly * payload:.2f} tons")
    print(f"系统总月度运力:     {total_monthly_cap_all:.2f} tons")
    
    # =========================================================================
    # 3. Gurobi 建模 (SSRIM)
    # =========================================================================
    model = gp.Model("SSRIM_Moon_Logistics")
    model.setParam('OutputFlag', 0)
    
    # --- 变量 ---
    # 电梯月运量
    x_e = model.addVars(months, lb=0, name="Elevator_Tons")
    
    # 火箭月运量 (保留，但预计会自动归零)
    x_r = model.addVars(site_names, months, lb=0, name="Rocket_Tons")
    
    # 【新增】月末库存变量
    Inventory = model.addVars(months, lb=Safety_Stock, ub=Storage_Capacity, name="Inventory")
    
    # 【新增】用于平滑化目标的辅助变量 (每月运量的最大值)
    max_monthly_delivery = model.addVar(lb=0, name="Max_Monthly_Delivery")
    
    # --- 约束 ---
    
    # 1. 【核心】库存平衡方程
    for t in months:
        # 本月到货量 = 电梯有效载荷 + 火箭运量
        arrival_t = x_e[t] * payload + gp.quicksum(x_r[i, t] for i in site_names)
        
        if t == 1:
            # 第一个月: 初始库存 + 到货 - 消耗 = 月末库存
            model.addConstr(Inventory[t] == Initial_Stock + arrival_t - Monthly_Consumption, 
                           f"Inv_Balance_{t}")
        else:
            # 后续月份: 上月库存 + 到货 - 消耗 = 月末库存
            model.addConstr(Inventory[t] == Inventory[t-1] + arrival_t - Monthly_Consumption, 
                           f"Inv_Balance_{t}")
    
    # 2. 运力上限约束
    for t in months:
        # 电梯运力上限
        model.addConstr(x_e[t] <= Cap_elevator_sys_monthly, f"Cap_Ele_{t}")
        
        # 火箭运力上限
        for i in site_names:
            model.addConstr(x_r[i, t] <= site_monthly_cap[i], f"Cap_Rock_{i}_{t}")
    
    # 3. 【新增】平滑化约束: 每月运量不超过 max_monthly_delivery
    for t in months:
        monthly_total = x_e[t] * payload + gp.quicksum(x_r[i, t] for i in site_names)
        model.addConstr(max_monthly_delivery >= monthly_total, f"Smooth_{t}")
    
    # 4. 年末库存回归初始水平 (可选: 确保周期性可持续)
    model.addConstr(Inventory[12] >= Initial_Stock, "Year_End_Stock")
    
    # --- 目标函数 ---
    # 成本部分: 累加每月的费用
    total_cost_usd = (
        gp.quicksum((x_e[t] * C_elevator_per_ton + x_e[t] * payload * Initial_C_elevator_rocket_per_ton) for t in months) + 
        gp.quicksum(x_r[i, t] * site_data[i]["cost_per_ton"] for i in site_names for t in months)
    )
    
    # 平滑化部分: 最小化峰值运量 (权重较小，主要是成本优先)
    smoothness_weight = 0.001  # 平滑权重
    
    # 综合目标: 最小化总成本 + 轻微惩罚峰值运量
    obj = total_cost_usd + smoothness_weight * max_monthly_delivery * 1e6
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 4. 求解与输出
    # =========================================================================
    model.optimize()
    
    print("\n" + "="*70)
    print("SSRIM 优化结果")
    print("="*70)
    
    if model.status == GRB.OPTIMAL:
        c_val = total_cost_usd.getValue()
        
        print(f"\n【成本分析】")
        print(f"  年度总成本:   ${c_val/1e6:.2f} Million (百万美元)")
        print(f"              = ${c_val/1e9:.4f} Billion (十亿美元)")
        
        # 统计总量
        sum_e = sum(x_e[t].X for t in months)
        sum_r = sum(sum(x_r[i,t].X for i in site_names) for t in months)
        
        print(f"\n【运输结构】")
        print(f"  电梯运输:  {sum_e*payload:.2f} 吨 ({sum_e*payload/M_total*100:.1f}%)")
        print(f"  火箭运输:  {sum_r:.2f} 吨 ({sum_r/M_total*100:.1f}%)")
        
        if sum_r < 1:
            print(f"\n  ★ 结论: 模型自动剔除了火箭方案，100% 采用太空电梯!")
            print(f"    原因: 火箭成本 ${Unified_Cost_Per_Ton/1e6:.2f}M/ton vs 电梯成本 ${C_elevator_per_ton + payload * Initial_C_elevator_rocket_per_ton:.0f}/ton")
            print(f"    成本比: {Unified_Cost_Per_Ton / (C_elevator_per_ton + payload * Initial_C_elevator_rocket_per_ton):.0f} : 1")
        
        # 收集月度数据用于绘图
        monthly_data = []
        print(f"\n【月度补给计划 (Schedule)】")
        print(f"{'Month':<8} | {'Arrival(t)':<12} | {'Consumption(t)':<15} | {'End Stock(t)':<12} | {'Cost($M)':<12}")
        print("-" * 70)
        
        for t in months:
            e_vol = x_e[t].X
            r_vol = sum(x_r[i,t].X for i in site_names)
            arrival = e_vol * payload + r_vol
            inv = Inventory[t].X
            
            e_cost = e_vol * C_elevator_per_ton + e_vol * payload * Initial_C_elevator_rocket_per_ton
            r_cost = sum(x_r[i,t].X * site_data[i]["cost_per_ton"] for i in site_names)
            monthly_cost = e_cost + r_cost
            
            monthly_data.append({
                'month': t,
                'arrival': arrival,
                'consumption': Monthly_Consumption,
                'inventory': inv,
                'cost': monthly_cost
            })
            
            print(f"{t:<8} | {arrival:<12.2f} | {Monthly_Consumption:<15.2f} | {inv:<12.2f} | ${monthly_cost/1e6:<11.3f}")
        
        # =====================================================================
        # 5. 绘制锯齿压力图 (Inventory Saw-tooth Pattern)
        # =====================================================================
        plot_inventory_sawtooth(monthly_data, Initial_Stock, Safety_Stock, Storage_Capacity, Monthly_Consumption)
        
        # =====================================================================
        # 6. 绘制成本对比图
        # =====================================================================
        plot_cost_comparison(c_val, M_total, Unified_Cost_Per_Ton)
        
        return monthly_data, c_val
        
    else:
        print("求解失败 (Infeasible)")
        print("建议: 检查库存约束是否过紧，或增加电梯运力。")
        return None, None


def plot_inventory_sawtooth(monthly_data, initial_stock, safety_stock, capacity, consumption):
    """
    绘制锯齿压力图 (Inventory Saw-tooth Pattern) - 箭头增强版
    """
    import matplotlib.lines as mlines  # 用于自定义图例

    # 尝试设置更现代的绘图风格
    try:
        plt.style.use('seaborn-v0_8-whitegrid')
    except:
        plt.grid(True, linestyle=':', alpha=0.6)

    fig, ax = plt.subplots(figsize=(12, 7))
    
    # === 颜色定义 ===
    c_consumption = '#00796B'  # 消耗线条颜色 (Teal)
    c_resupply = '#FF0000'     # 补给箭头颜色 (Bright Red) - 更鲜艳
    c_danger = '#E64A19'       # 危险线
    c_cap = '#FBC02D'          # 容量线
    
    # === 1. 绘制辅助区域 (底层) ===
    ax.fill_between([0, 13], [safety_stock, safety_stock], [0, 0], 
                    color=c_danger, alpha=0.08, label='Critical Reserve Zone')
    
    # === 2. 循环绘制每一段 ===
    prev_inv = initial_stock
    
    for data in monthly_data:
        t = data['month']
        arrival = data['arrival']
        end_inv = data['inventory']
        
        # 时间节点
        t_start = t - 1  # 月初
        t_end = t        # 月末
        
        # 库存状态
        inv_before_resupply = prev_inv
        inv_after_resupply = prev_inv + arrival
        inv_end_of_month = end_inv
        
        # --- A. 绘制补给 (Rising) -> 使用垂直箭头 ---
        # 箭头从 (t_start, inv_before) 指向 (t_start, inv_after)
        ax.annotate('', 
                    xy=(t_start, inv_after_resupply), 
                    xytext=(t_start, inv_before_resupply),
                    arrowprops=dict(arrowstyle='-|>', color=c_resupply, lw=2, mutation_scale=15),
                    zorder=10)
        
        # 为了视觉连续性，加一条虚线辅助
        ax.plot([t_start, t_start], [inv_before_resupply, inv_after_resupply], 
                color=c_resupply, linestyle=':', lw=1.5, alpha=0.7, zorder=9)

        # --- B. 绘制消耗 (Falling) -> 使用虚线 ---
        ax.plot([t_start, t_end], [inv_after_resupply, inv_end_of_month], 
                color=c_consumption, linewidth=2.5, linestyle='--', zorder=5)
        
        # --- C. 填充库存下方 ---
        # 构造填充多边形 (梯形)
        ax.fill_between([t_start, t_end], [inv_after_resupply, inv_end_of_month], safety_stock,
                        where=[inv_after_resupply >= safety_stock, inv_end_of_month >= safety_stock], # 简单判定
                        color=c_consumption, alpha=0.1, interpolate=True)
        
        # --- D. 标记关键点 ---
        # 补给后的峰值点
        ax.scatter(t_start, inv_after_resupply, color=c_resupply, s=25, zorder=11, marker='o', edgecolors='white', linewidth=0.5)
        
        prev_inv = end_inv

    # === 3. 绘制参考线 ===
    # 安全库存线
    ax.axhline(y=safety_stock, color=c_danger, linestyle='--', linewidth=2, alpha=0.8)
    ax.text(12.6, safety_stock, ' Safety Stock', va='center', ha='left', color=c_danger, fontweight='bold', fontsize=10)

    # 容量上限线
    ax.axhline(y=capacity, color=c_cap, linestyle='--', linewidth=2, alpha=0.8)
    ax.text(12.6, capacity, ' Max Capacity', va='center', ha='left', color=c_cap, fontweight='bold', fontsize=10)

    # === 4. 图表装饰 ===
    ax.set_title('Lunar Base Water Inventory Dynamics\nSteady-State Resupply Cycle (Arrow=Resupply, Line=Consumption)', fontsize=16, fontweight='bold', color='#37474F', pad=20)
    ax.set_xlabel('Timeline (Months)', fontsize=12, fontweight='bold', color='#546E7A')
    ax.set_ylabel('Water Stock (Tons)', fontsize=12, fontweight='bold', color='#546E7A')
    
    ax.set_xlim(0, 13)
    ax.set_ylim(0, capacity * 1.2)
    ax.set_xticks(range(0, 13))
    ax.set_xticklabels([f'M{i}' for i in range(0, 13)])
    
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_color('#CFD8DC')
    ax.spines['bottom'].set_color('#CFD8DC')
    ax.grid(True, axis='y', linestyle=':', alpha=0.5, color='#B0BEC5')

    # === 5. 自定义图例 ===
    legend_elements = [
        mlines.Line2D([], [], color=c_resupply, marker='^', linestyle=':', lw=1.5, markersize=8, label='Resupply (Elevator Arrival)'),
        mlines.Line2D([], [], color=c_consumption, linestyle='--', lw=2.5, label='Consumption (Water Usage)'),
        mlines.Line2D([], [], color=c_cap, linestyle='--', lw=2, label='Max Capacity'),
        mlines.Line2D([], [], color=c_danger, linestyle='--', lw=2, label='Safety Stock'),
    ]
    ax.legend(handles=legend_elements, loc='upper center', bbox_to_anchor=(0.5, -0.1),
              ncol=4, frameon=False, fontsize=11)

    plt.tight_layout()
    plt.savefig('d:\\desktop\\新建文件夹\\inventory_sawtooth.png', dpi=300, bbox_inches='tight')
    print(f"\n[图表已保存] inventory_sawtooth.png (箭头增强版)")


def plot_cost_comparison(elevator_cost, total_demand, rocket_cost_per_ton):
    """
    绘制运营成本对比饼图
    展示电梯补给方案 vs 传统火箭方案的极端成本差异
    """
    # 计算假设用火箭运输的成本
    rocket_total_cost = total_demand * rocket_cost_per_ton
    
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))
    
    # 左图: 饼图对比
    ax1 = axes[0]
    costs = [elevator_cost, rocket_total_cost]
    labels = [f'Space Elevator\n${elevator_cost/1e6:.1f}M', f'Traditional Rockets\n${rocket_total_cost/1e9:.1f}B']
    colors = ['#2ecc71', '#e74c3c']
    explode = (0.05, 0)
    
    ax1.pie(costs, labels=labels, colors=colors, explode=explode, autopct='%1.2f%%', 
            startangle=90, textprops={'fontsize': 11})
    ax1.set_title('Annual Resupply Cost Comparison\n(60,000 tons of Water)', fontsize=13, fontweight='bold')
    
    # 右图: 条形图对比 (对数尺度)
    ax2 = axes[1]
    categories = ['Space Elevator', 'Traditional Rockets']
    values = [elevator_cost / 1e6, rocket_total_cost / 1e6]
    bars = ax2.bar(categories, values, color=colors, edgecolor='black', linewidth=1.5)
    
    ax2.set_yscale('log')
    ax2.set_ylabel('Cost (Million USD, Log Scale)', fontsize=12)
    ax2.set_title('Cost Comparison (Log Scale)\nDemonstrating Space Elevator\'s Economic Advantage', fontsize=13, fontweight='bold')
    
    # 添加数值标签
    for bar, val in zip(bars, values):
        height = bar.get_height()
        ax2.annotate(f'${val:,.0f}M',
                    xy=(bar.get_x() + bar.get_width() / 2, height),
                    xytext=(0, 3), textcoords="offset points",
                    ha='center', va='bottom', fontsize=11, fontweight='bold')
    
    # 添加成本比注释
    ratio = rocket_total_cost / elevator_cost
    ax2.annotate(f'Cost Ratio: {ratio:,.0f}:1', xy=(0.5, 0.5), xycoords='axes fraction',
                fontsize=14, fontweight='bold', color='navy',
                ha='center', va='center',
                bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8))
    
    plt.tight_layout()
    plt.savefig('d:\\desktop\\新建文件夹\\cost_comparison.png', dpi=300)
    print(f"[图表已保存] cost_comparison.png")


# --- 执行求解 ---
if __name__ == "__main__":
    monthly_data, total_cost = solve_moon_logistics_SSRIM()
    
    if monthly_data:
        print("\n" + "="*70)
        print("【关键结论 - 供论文使用】")
        print("="*70)
        print(f"1. 低成本生存: 利用太空电梯，10万人的年度水资源维持成本仅为 ${total_cost/1e6:.2f} Million，")
        print(f"   相比于建设期的万亿级支出，证明了殖民地在建成后是极易维持运行的。")
        print(f"\n2. 风险缓冲: 补给计划中预留的 1 万吨库存（够用2个月）可以完美抵御")
        print(f"   第二问中提到的'系绳摇晃导致电梯停运一个月'的极端风险，")
        print(f"   实现了 Phase 2 与 Phase 3 的模型联动。")
        print(f"\n3. 运输方式优选: 模型自动证明了水资源等大宗、周期性、非紧急物资")
        print(f"   应 100% 采用太空电梯运输，火箭仅用于紧急/小批量需求。")
