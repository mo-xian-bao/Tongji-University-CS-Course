# -*- coding: utf-8 -*-
"""
月球物流模型 - 场景对比分析脚本

分析不同风险参数下的优化结果:
1. base: 基准风险
2. high_rocket_risk: 高火箭失败率
3. high_sway_risk: 高系绳摇晃率
4. extreme_risk: 极端风险

通过调用主模块的鲁棒优化函数，将风险参数整合进约束条件
"""

import sys
import os
import numpy as np
from dataclasses import dataclass
from typing import List, Dict, Optional
import time

# 设置 matplotlib 非交互模式
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# 读取主模块
print("正在加载主模块 (2/2.py)...")
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
# 尝试在当前目录或父目录寻找 2.py
possible_paths = [
    os.path.join(current_dir, '2.py'),
    os.path.join(parent_dir, '2', '2.py'),
    '2/2.py'
]

loaded = False
for path in possible_paths:
    if os.path.exists(path):
        with open(path, encoding='utf-8') as f:
            code = f.read()
            # 移除平台检查导致的阻塞 (如果存在)
            code = code.replace("if sys.platform == 'win32':", "if False:")
            code_parts = code.split('if __name__ == "__main__":')
            exec(compile(code_parts[0], '<string>', 'exec'), globals())
        print(f"模块加载完成: {path}\n")
        loaded = True
        break

if not loaded:
    print("错误: 找不到 2/2.py 模块，请检查路径。")
    sys.exit(1)


# =============================================================================
# 场景定义
# =============================================================================

@dataclass
class RiskScenario:
    """风险场景定义"""
    name: str                    # 场景名称
    display_name: str            # 显示名称
    rocket_fail_prob: float      # 火箭发射失败率
    elevator_sway_prob: float    # 系绳摇晃概率


@dataclass
class ScenarioResult:
    """场景分析结果"""
    scenario: RiskScenario
    
    # 优化结果
    completion_years: int        # 完工时间 (年)
    total_cost: float            # 总成本 (USD)
    
    # 运量分布
    elevator_volume: float       # 电梯运量 (吨)
    rocket_volume: float         # 火箭运量 (吨)
    total_volume: float          # 总运量 (吨)
    elevator_percent: float      # 电梯占比 (%)
    rocket_percent: float        # 火箭占比 (%)
    
    # 风险约束参数
    elevator_capacity_factor: float  # 电梯有效运力系数
    rocket_capacity_factor: float    # 火箭有效运力系数
    
    # 求解状态
    status: str                  # 求解状态


# 定义场景列表
SCENARIO_LIST = [
    RiskScenario(
        name="best",
        display_name="Best (最优)",
        rocket_fail_prob=0.00,
        elevator_sway_prob=0.00
    ),
    RiskScenario(
        name="base",
        display_name="Base (基准)",
        rocket_fail_prob=0.01,
        elevator_sway_prob=0.05
    ),
    RiskScenario(
        name="high_rocket_risk",
        display_name="High Rocket (高火箭风险)",
        rocket_fail_prob=0.10,
        elevator_sway_prob=0.05
    ),
    RiskScenario(
        name="high_sway_risk",
        display_name="High Sway (高摇晃风险)",
        rocket_fail_prob=0.01,
        elevator_sway_prob=0.30
    ),
    RiskScenario(
        name="extreme_risk",
        display_name="Extreme (极端风险)",
        rocket_fail_prob=0.10,
        elevator_sway_prob=0.30
    )
]


# =============================================================================
# 带风险约束的优化求解函数
# =============================================================================

def solve_with_risk_constraints(
    scenario: RiskScenario,
    alpha_weight: float = 0.5,
    verbose: bool = True
) -> ScenarioResult:
    """
    使用主模块的鲁棒优化函数求解带风险约束的优化问题
    
    将故障率整合进约束条件:
    - 电梯实际运力 = 理论运力 * elevator_capacity_factor
    - 火箭实际运力 = 理论运力 * rocket_capacity_factor
    """
    
    if verbose:
        print(f"\n{'='*60}")
        print(f"场景: {scenario.display_name}")
        print(f"{'='*60}")
        print(f"  火箭失败率: {scenario.rocket_fail_prob*100:.1f}%")
        print(f"  电梯摇晃率: {scenario.elevator_sway_prob*100:.1f}%")
    
    # 计算风险折减系数
    rocket_capacity_factor = 1.0 - scenario.rocket_fail_prob
    
    # 电梯有效运力系数:
    # = (1 - mech_fail) * ((1 - sway_prob) + sway_prob * (1 - reduction))
    elevator_mech_fail = 0.05  # 固定机械故障率
    sway_reduction = 0.50       # 摇晃时运力下降比例
    prob_no_mech_fail = 1.0 - elevator_mech_fail
    prob_normal = 1.0 - scenario.elevator_sway_prob
    prob_sway_partial = scenario.elevator_sway_prob * (1.0 - sway_reduction)
    elevator_capacity_factor = prob_no_mech_fail * (prob_normal + prob_sway_partial)
    
    if verbose:
        print(f"  火箭有效运力系数: {rocket_capacity_factor:.4f}")
        print(f"  电梯有效运力系数: {elevator_capacity_factor:.4f}")
    
    # 使用主模块的鲁棒优化函数
    # 设置 safety_buffer=1.0 (无额外冗余)，但应用折减系数
    try:
        solution = solve_robust_moon_logistics(
            alpha_weight=alpha_weight,
            safety_buffer=1.0,  # 不增加额外目标冗余
            rocket_capacity_discount=rocket_capacity_factor,
            elevator_capacity_discount=elevator_capacity_factor,
            return_solution=True,
            verbose=False
        )
        
        if solution.get('model_status') == 'optimal':
            t_val = solution['planned_years']
            c_val = solution['total_cost']
            
            # 计算运量分布 (从解中提取)
            x_e = solution['x_e_values']
            x_r = solution['x_r_values']
            payload_ratio = solution['payload_ratio']
            
            elevator_vol = sum(x_e[t] * payload_ratio for t in x_e.keys())
            rocket_vol = sum(x_r[k] for k in x_r.keys())
            total_vol = elevator_vol + rocket_vol
            
            elevator_pct = elevator_vol / total_vol * 100 if total_vol > 0 else 0
            rocket_pct = rocket_vol / total_vol * 100 if total_vol > 0 else 0
            
            if verbose:
                print(f"\n  【优化结果】")
                print(f"  完工时间: {t_val} 年")
                print(f"  总成本: ${c_val/1e12:.3f} Trillion")
                print(f"  运输结构:")
                print(f"    - 电梯: {elevator_vol/1e6:.2f} M吨 ({elevator_pct:.1f}%)")
                print(f"    - 火箭: {rocket_vol/1e6:.2f} M吨 ({rocket_pct:.1f}%)")
            
            result = ScenarioResult(
                scenario=scenario,
                completion_years=t_val,
                total_cost=c_val,
                elevator_volume=elevator_vol,
                rocket_volume=rocket_vol,
                total_volume=total_vol,
                elevator_percent=elevator_pct,
                rocket_percent=rocket_pct,
                elevator_capacity_factor=elevator_capacity_factor,
                rocket_capacity_factor=rocket_capacity_factor,
                status="optimal"
            )
        else:
            if verbose:
                print(f"  求解失败")
            result = ScenarioResult(
                scenario=scenario,
                completion_years=0, total_cost=0,
                elevator_volume=0, rocket_volume=0, total_volume=0,
                elevator_percent=0, rocket_percent=0,
                elevator_capacity_factor=elevator_capacity_factor,
                rocket_capacity_factor=rocket_capacity_factor,
                status="failed"
            )
    except Exception as e:
        if verbose:
            print(f"  求解出错: {e}")
        result = ScenarioResult(
            scenario=scenario,
            completion_years=0, total_cost=0,
            elevator_volume=0, rocket_volume=0, total_volume=0,
            elevator_percent=0, rocket_percent=0,
            elevator_capacity_factor=elevator_capacity_factor,
            rocket_capacity_factor=rocket_capacity_factor,
            status="error"
        )
    
    return result


# =============================================================================
# 场景对比分析
# =============================================================================

def run_scenario_comparison(
    scenarios: List[RiskScenario] = None,
    alpha_weight: float = 0.5,
    verbose: bool = True
) -> List[ScenarioResult]:
    """运行场景对比分析"""
    if scenarios is None:
        scenarios = SCENARIO_LIST
    
    results = []
    
    print("\n" + "=" * 70)
    print("月球物流模型 - 场景对比分析")
    print("=" * 70)
    print(f"Alpha 权重: {alpha_weight}")
    print(f"场景数量: {len(scenarios)}")
    print("=" * 70)
    
    for scenario in scenarios:
        result = solve_with_risk_constraints(
            scenario=scenario,
            alpha_weight=alpha_weight,
            verbose=verbose
        )
        results.append(result)
    
    return results


def print_comparison_table(results: List[ScenarioResult]):
    """打印场景对比表格"""
    
    print("\n" + "=" * 100)
    print("场景对比结果汇总")
    print("=" * 100)
    
    # 表头
    header = f"{'Scenario':<20} | {'Years':>6} | {'Cost($T)':>10} | {'Elev(Mt)':>9} | {'Rock(Mt)':>9} | {'Elev%':>6}"
    print(header)
    print("-" * 100)
    
    base_result = results[0] if results else None
    
    for r in results:
        if r.status != "optimal":
            print(f"{r.scenario.display_name:<20} | {'FAILED':>6} |")
            continue
        
        if base_result and base_result.status == "optimal" and r != base_result:
            years_diff = r.completion_years - base_result.completion_years
            cost_diff = (r.total_cost - base_result.total_cost) / base_result.total_cost * 100
            diff_str = f" ({years_diff:+d}y, {cost_diff:+.1f}%)"
        else:
            diff_str = " (BASE)"
        
        row = (f"{r.scenario.display_name:<20} | "
               f"{r.completion_years:>6} | "
               f"{r.total_cost/1e12:>10.3f} | "
               f"{r.elevator_volume/1e6:>9.2f} | "
               f"{r.rocket_volume/1e6:>9.2f} | "
               f"{r.elevator_percent:>5.1f}%")
        print(row + diff_str)
    
    print("=" * 100)
    
    # 风险参数表
    print("\n" + "-" * 70)
    print("Risk Parameters")
    print("-" * 70)
    print(f"{'Scenario':<20} | {'Rocket Fail':>12} | {'Sway Rate':>12} | {'Elev Factor':>12}")
    print("-" * 70)
    for r in results:
        s = r.scenario
        print(f"{s.display_name:<20} | {s.rocket_fail_prob*100:>11.0f}% | {s.elevator_sway_prob*100:>11.0f}% | {r.elevator_capacity_factor:>12.4f}")
    print("-" * 70)


def plot_scenario_comparison(
    results: List[ScenarioResult],
    save_path: str = '2/scenario_comparison.png'
):
    """绘制场景对比可视化图表 - 使用指定配色与渐变效果"""
    
    plt.style.use('seaborn-v0_8-muted')
    fig, axes = plt.subplots(2, 2, figsize=(14, 11))
    fig.patch.set_facecolor('#fdfdfd')
    
    fig.suptitle('Logistics Optimization: Scenario Contrast Analysis', 
                 fontsize=20, fontweight='bold', y=0.98, color='#2c3e50')
    
    # 指定颜色
    color_main = '#FDA5FF'  # Light Pink
    color_sub = '#37BEAC'   # Teal
    
    def draw_grad_bar(ax, x_pos, height, width, bottom=0, color_hex='#000000', label=None, alpha=1.0):
        if height <= 0: return
        n_steps = 50
        # Create a local colormap from the color to a slightly lighter/darker version
        from matplotlib.colors import LinearSegmentedColormap, hex2color
        rgb = hex2color(color_hex)
        # Gradient from 70% brightness to 100% brightness of the color
        cdict = {'red':   [(0, rgb[0]*0.7, rgb[0]*0.7), (1, rgb[0], rgb[0])],
                 'green': [(0, rgb[1]*0.7, rgb[1]*0.7), (1, rgb[1], rgb[1])],
                 'blue':  [(0, rgb[2]*0.7, rgb[2]*0.7), (1, rgb[2], rgb[2])]}
        my_cm = LinearSegmentedColormap('v_grad', cdict)
        
        step_h = height / n_steps
        for i in range(n_steps):
            c = my_cm(i / n_steps)
            ax.bar(x_pos, step_h, width, bottom=bottom + i*step_h, color=c, 
                   edgecolor=c, linewidth=0, alpha=alpha)
        # Border
        return ax.bar(x_pos, height, width, bottom=bottom, fill=False, edgecolor=color_hex, 
                      linewidth=0.8, label=label)

    valid_results = [r for r in results if r.status == "optimal"]
    display_names = [r.scenario.display_name.split(' (')[0] for r in valid_results]
    x = np.arange(len(display_names))
    width = 0.55
    bw = 0.3
    
    # Subplot 1: Mix %
    ax1 = axes[0, 0]
    ax1.set_facecolor('#ffffff')
    e_pcts = [r.elevator_percent for r in valid_results]
    r_pcts = [r.rocket_percent for r in valid_results]
    
    for i in x:
        draw_grad_bar(ax1, i, e_pcts[i], width, 0, color_main)
        draw_grad_bar(ax1, i, r_pcts[i], width, e_pcts[i], color_sub)
        ax1.text(i, e_pcts[i]/2, f'{e_pcts[i]:.0f}%', ha='center', va='center', color='white', fontweight='bold')
        ax1.text(i, e_pcts[i] + r_pcts[i]/2, f'{r_pcts[i]:.0f}%', ha='center', va='center', color='#2c3e50', fontweight='bold')
    
    ax1.set_ylabel('Mix Proportion (%)', fontweight='bold')
    ax1.set_title('Transport Strategy Mix', fontweight='bold', pad=15)
    ax1.set_xticks(x)
    ax1.set_xticklabels(display_names, rotation=15, ha='right')
    
    # Subplot 2: Volumes
    ax2 = axes[0, 1]
    ax2.set_facecolor('#ffffff')
    e_vols = [r.elevator_volume/1e6 for r in valid_results]
    r_vols = [r.rocket_volume/1e6 for r in valid_results]
    
    for i in x:
        draw_grad_bar(ax2, i, e_vols[i], width, 0, color_main)
        draw_grad_bar(ax2, i, r_vols[i], width, e_vols[i], color_sub)
        total = e_vols[i] + r_vols[i]
        ax2.text(i, total + 1.5, f'{total:.0f}M', ha='center', fontweight='bold')
        
    ax2.set_ylabel('Throughput (Million Tons)', fontweight='bold')
    ax2.set_title('Delivered Capacity by Mode', fontweight='bold', pad=15)
    ax2.set_xticks(x)
    ax2.set_xticklabels(display_names, rotation=15, ha='right')

    # Subplot 3: Economics
    ax3 = axes[1, 0]
    ax3_t = ax3.twinx()
    costs = [r.total_cost/1e12 for r in valid_results]
    years = [r.completion_years for r in valid_results]
    
    for i in x:
        draw_grad_bar(ax3, i - bw/2, costs[i], bw, 0, color_main)
        draw_grad_bar(ax3_t, i + bw/2, years[i], bw, 0, color_sub)
        ax3.text(i - bw/2, costs[i] + 1, f'${costs[i]:.1f}T', ha='center', va='bottom', fontsize=9, color=color_main, fontweight='bold')
        ax3_t.text(i + bw/2, years[i] + 2, f'{years[i]}y', ha='center', va='bottom', fontsize=9, color='#cc8c14', fontweight='bold')
        
    ax3.set_ylabel('Budget ($ Trillion)', fontweight='bold', color=color_main)
    ax3_t.set_ylabel('Time (Years)', fontweight='bold', color='#cc8c14')
    ax3.set_title('Economic & Temporal Efficiency', fontweight='bold', pad=15)
    ax3.set_xticks(x)
    ax3.set_xticklabels(display_names, rotation=15, ha='right')

    # Subplot 4: Factors
    ax4 = axes[1, 1]
    e_fs = [r.elevator_capacity_factor for r in valid_results]
    r_fs = [r.rocket_capacity_factor for r in valid_results]
    
    for i in x:
        draw_grad_bar(ax4, i - bw/2, e_fs[i], bw, 0, color_main)
        draw_grad_bar(ax4, i + bw/2, r_fs[i], bw, 0, color_sub)
        ax4.text(i - bw/2, e_fs[i] + 0.01, f'{e_fs[i]:.2f}', ha='center', va='bottom', fontsize=9, color=color_main)
        ax4.text(i + bw/2, r_fs[i] + 0.01, f'{r_fs[i]:.2f}', ha='center', va='bottom', fontsize=9, color='#cc8c14')
        
    ax4.set_ylabel('Reliability Factor', fontweight='bold')
    ax4.set_title('Risk-Adjusted Capacity Factors', fontweight='bold', pad=15)
    ax4.set_xticks(x)
    ax4.set_xticklabels(display_names, rotation=15, ha='right')
    ax4.set_ylim(0, 1.2)
    
    # Legend Elements
    from matplotlib.patches import Patch
    leg_el = [Patch(facecolor=color_main, label='Space Elevator / Cost'),
              Patch(facecolor=color_sub, label='Rocket Fleet / Time')]
    fig.legend(handles=leg_el, loc='lower center', ncol=2, frameon=False, fontsize=12)
    
    plt.tight_layout(rect=[0, 0.07, 1, 0.95])
    plt.savefig(save_path, dpi=200, bbox_inches='tight')
    print(f"\nFigure saved to: {save_path}")
    return fig


def analyze_scenario_impact(results: List[ScenarioResult]):
    """分析各场景的影响"""
    
    print("\n" + "=" * 70)
    print("Scenario Impact Analysis / 场景影响分析")
    print("=" * 70)
    
    base = results[0] if results and results[0].status == "optimal" else None
    
    if not base:
        print("Base scenario failed, cannot compare")
        return
    
    print(f"\n[Base Scenario]: {base.scenario.display_name}")
    print(f"  Duration: {base.completion_years} years")
    print(f"  Cost: ${base.total_cost/1e12:.3f} Trillion")
    print(f"  Elevator %: {base.elevator_percent:.1f}%")
    
    for r in results[1:]:
        if r.status != "optimal":
            continue
        
        print(f"\n[{r.scenario.display_name}]")
        
        years_diff = r.completion_years - base.completion_years
        years_pct = years_diff / base.completion_years * 100
        print(f"  Duration change: {years_diff:+d} years ({years_pct:+.1f}%)")
        
        cost_diff = r.total_cost - base.total_cost
        cost_pct = cost_diff / base.total_cost * 100
        print(f"  Cost change: ${cost_diff/1e12:+.3f}T ({cost_pct:+.1f}%)")
        
        elevator_pct_diff = r.elevator_percent - base.elevator_percent
        print(f"  Elevator % change: {elevator_pct_diff:+.1f} pts ({base.elevator_percent:.1f}% -> {r.elevator_percent:.1f}%)")
        
        # 分析原因
        if r.scenario.rocket_fail_prob > base.scenario.rocket_fail_prob:
            if elevator_pct_diff > 0:
                print(f"  -> Higher rocket failure => More elevator usage")
        
        if r.scenario.elevator_sway_prob > base.scenario.elevator_sway_prob:
            if elevator_pct_diff < 0:
                print(f"  -> Higher sway risk => More rocket usage")
    
    print("\n" + "=" * 70)



# =============================================================================
# 主执行
# =============================================================================

if __name__ == "__main__":
    print("\n" + "=" * 70)
    print("Moon Logistics Model - Scenario Comparison (Real Solver Data)")
    print("月球物流模型 - 场景对比分析 (真实模型计算)")
    print("=" * 70)
    
    # 使用真实求解器
    alpha = 0.5
    results = run_scenario_comparison(alpha_weight=alpha)
    
    # 打印对比表格
    print_comparison_table(results)
    
    # 绘制可视化图表
    plot_scenario_comparison(results, save_path='2/scenario_comparison.png')
    
    # 分析影响
    analyze_scenario_impact(results)
    
    print("\n分析完成!")
