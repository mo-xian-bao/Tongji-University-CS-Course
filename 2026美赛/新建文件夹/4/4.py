# -*- coding: utf-8 -*-
"""
月球物流优化模型 - 包含确定性模型和随机弹性恢复模型
"""

import sys
import io

# 设置标准输出为UTF-8编码（解决Windows命令行编码问题）
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

import gurobipy as gp
from gurobipy import GRB
import math
import numpy as np
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple
from enum import Enum

# =============================================================================
# MODEL 2: 随机弹性与恢复模型 - 风险参数定义
# =============================================================================

# -------------------------------------------------------------------------
# 1. 基础风险概率参数
# -------------------------------------------------------------------------

# 火箭发射失败率 (每次发射)
# 后果: 失败时当次货运物资 (site_payloads) 彻底灭失，成本已支出不可追回
rocket_fail_prob = 0.02  # 2% per launch

# 电梯机械故障率 (每年)
# 后果: 故障时当年度电梯运力 (Cap_elevator_sys) 完全受限 (降为0或大幅下降)
elevator_mech_fail_prob = 0.05  # 5% per year

# 系绳摇晃导致的停运概率 (每年)
# 后果: 发生时电梯当年度运力下降 50%
tether_sway_prob = 0.10  # 10% per year
tether_sway_capacity_reduction = 0.50  # 50% capacity reduction when sway occurs


# -------------------------------------------------------------------------
# 2. 风险事件类型枚举
# -------------------------------------------------------------------------

class RiskEventType(Enum):
    """风险事件类型"""
    ROCKET_LAUNCH_FAILURE = "rocket_launch_failure"      # 火箭发射失败
    ELEVATOR_MECHANICAL_FAILURE = "elevator_mech_failure" # 电梯机械故障
    TETHER_SWAY_DISRUPTION = "tether_sway_disruption"    # 系绳摇晃停运


# -------------------------------------------------------------------------
# 3. 风险场景数据结构
# -------------------------------------------------------------------------

@dataclass
class RocketFailureEvent:
    """火箭发射失败事件"""
    year: int                    # 发生年份
    site_name: str               # 发射基地名称
    payload_lost: float          # 灭失的货物量 (吨)
    cost_lost: float             # 已支出但损失的成本 (USD)
    
    
@dataclass 
class ElevatorFailureEvent:
    """电梯机械故障事件"""
    year: int                    # 发生年份
    duration_days: int = 365     # 故障持续天数 (默认全年)
    capacity_available: float = 0.0  # 可用运力比例 (0表示完全停运)


@dataclass
class TetherSwayEvent:
    """系绳摇晃停运事件"""
    year: int                    # 发生年份
    capacity_reduction: float    # 运力下降比例 (默认0.5即50%)
    

@dataclass
class RiskScenario:
    """
    风险场景: 存储一个完整的风险场景实例
    
    每个场景包含:
    - 场景ID和概率
    - 该场景下发生的所有风险事件列表
    - 对运力和成本的影响计算结果
    """
    scenario_id: int                                     # 场景唯一标识
    probability: float                                   # 该场景发生的概率
    
    # 各类风险事件列表
    rocket_failures: List[RocketFailureEvent] = field(default_factory=list)
    elevator_failures: List[ElevatorFailureEvent] = field(default_factory=list)
    tether_sway_events: List[TetherSwayEvent] = field(default_factory=list)
    
    # 影响汇总
    total_payload_lost: float = 0.0          # 总灭失货物量 (吨)
    total_cost_lost: float = 0.0             # 总损失成本 (USD)
    elevator_capacity_factor: Dict[int, float] = field(default_factory=dict)  # 每年电梯可用运力系数
    
    def compute_impacts(self, years: range, base_elevator_capacity: float):
        """计算该场景对运输能力的综合影响"""
        # 初始化每年电梯运力系数为1.0
        self.elevator_capacity_factor = {t: 1.0 for t in years}
        
        # 处理电梯机械故障影响
        for event in self.elevator_failures:
            self.elevator_capacity_factor[event.year] *= event.capacity_available
            
        # 处理系绳摇晃影响 
        for event in self.tether_sway_events:
            self.elevator_capacity_factor[event.year] *= (1.0 - event.capacity_reduction)
            
        # 汇总火箭失败损失
        self.total_payload_lost = sum(e.payload_lost for e in self.rocket_failures)
        self.total_cost_lost = sum(e.cost_lost for e in self.rocket_failures)


@dataclass
class RiskScenarioSet:
    """
    风险场景集合: 用于两阶段随机规划
    
    存储多个风险场景及其概率分布，支持期望值计算和场景采样
    """
    scenarios: List[RiskScenario] = field(default_factory=list)
    
    def add_scenario(self, scenario: RiskScenario):
        """添加一个风险场景"""
        self.scenarios.append(scenario)
        
    def get_num_scenarios(self) -> int:
        """获取场景数量"""
        return len(self.scenarios)
    
    def validate_probabilities(self) -> bool:
        """验证概率之和是否为1"""
        total_prob = sum(s.probability for s in self.scenarios)
        return abs(total_prob - 1.0) < 1e-6
    
    def normalize_probabilities(self):
        """归一化概率"""
        total_prob = sum(s.probability for s in self.scenarios)
        if total_prob > 0:
            for s in self.scenarios:
                s.probability /= total_prob


# -------------------------------------------------------------------------
# 4. 场景生成辅助函数
# -------------------------------------------------------------------------

def generate_risk_scenarios(
    years: range,
    site_names: List[str],
    site_payloads: Dict[str, float],
    site_costs: Dict[str, float],
    num_scenarios: int = 100,
    seed: Optional[int] = 42
) -> RiskScenarioSet:
    """
    使用蒙特卡洛方法生成风险场景集合
    
    参数:
        years: 规划年份范围
        site_names: 发射基地名称列表
        site_payloads: 各基地载荷量 (吨)
        site_costs: 各基地发射成本 (USD/ton)
        num_scenarios: 生成场景数量
        seed: 随机种子 (用于可复现性)
    
    返回:
        RiskScenarioSet: 包含所有生成场景的集合
    """
    if seed is not None:
        np.random.seed(seed)
    
    scenario_set = RiskScenarioSet()
    
    for s_id in range(num_scenarios):
        scenario = RiskScenario(
            scenario_id=s_id,
            probability=1.0 / num_scenarios  # 等概率场景
        )
        
        for t in years:
            # 模拟电梯机械故障
            if np.random.random() < elevator_mech_fail_prob:
                scenario.elevator_failures.append(
                    ElevatorFailureEvent(year=t, capacity_available=0.0)
                )
            # 模拟系绳摇晃 (仅当没有完全故障时才考虑)
            elif np.random.random() < tether_sway_prob:
                scenario.tether_sway_events.append(
                    TetherSwayEvent(year=t, capacity_reduction=tether_sway_capacity_reduction)
                )
            
            # 模拟各基地火箭发射失败 (简化: 假设每年每基地有多次发射)
            for site in site_names:
                # 假设根据运力计算年发射次数 (这里简化为固定检查)
                if np.random.random() < rocket_fail_prob:
                    scenario.rocket_failures.append(
                        RocketFailureEvent(
                            year=t,
                            site_name=site,
                            payload_lost=site_payloads.get(site, 0.0),
                            cost_lost=site_payloads.get(site, 0.0) * site_costs.get(site, 0.0)
                        )
                    )
        
        scenario_set.add_scenario(scenario)
    
    return scenario_set


def create_deterministic_scenario(years: range) -> RiskScenario:
    """
    创建无风险的确定性场景 (用于对比分析)
    """
    scenario = RiskScenario(
        scenario_id=0,
        probability=1.0
    )
    scenario.elevator_capacity_factor = {t: 1.0 for t in years}
    return scenario


# -------------------------------------------------------------------------
# 5. 风险参数汇总显示
# -------------------------------------------------------------------------

def print_risk_parameters():
    """打印当前风险参数配置"""
    print("\n" + "=" * 60)
    print("MODEL 2: 随机弹性与恢复模型 - 风险参数配置")
    print("=" * 60)
    print(f"  • 火箭发射失败率:        {rocket_fail_prob * 100:.1f}% (每次发射)")
    print(f"  • 电梯机械故障率:        {elevator_mech_fail_prob * 100:.1f}% (每年)")
    print(f"  • 系绳摇晃停运概率:      {tether_sway_prob * 100:.1f}% (每年)")
    print(f"  • 系绳摇晃运力下降:      {tether_sway_capacity_reduction * 100:.1f}%")
    print("-" * 60)
    print("故障后果说明:")
    print("  • 火箭失败: 当次货运物资彻底灭失，成本已支出不可追回")
    print("  • 电梯故障: 当年度电梯运力 (Cap_elevator_sys) 完全停运")
    print("  • 系绳摇晃: 当年度电梯运力下降 50%")
    print("=" * 60 + "\n")


# =============================================================================
# MODEL 2: 蒙特卡洛风险模拟
# =============================================================================

@dataclass
class SimulationResult:
    """单次模拟结果"""
    simulation_id: int
    
    # 运输结果
    planned_total: float              # 计划总运量 (吨)
    actual_delivered: float           # 实际交付量 (吨)
    payload_lost: float               # 损失的载荷 (吨)
    shortfall: float                  # 物资缺口 (吨) = max(0, 需求 - 实际交付)
    
    # 成本结果  
    planned_cost: float               # 计划总成本 (USD)
    wasted_cost: float                # 浪费的成本 (因故障损失) (USD)
    
    # 时间结果
    planned_years: int                # 计划工期 (年)
    actual_years: int                 # 实际完成工期 (年), 如未完成则为Max_Horizon
    delay_years: int                  # 延误年数
    
    # 状态
    is_successful: bool               # 是否成功达标 (交付 >= 1亿吨)


@dataclass
class SimulationSummary:
    """模拟汇总统计"""
    num_simulations: int
    
    # 物资损耗统计
    avg_payload_lost: float           # 平均物资损耗 (吨)
    max_payload_lost: float           # 最大物资损耗 (吨)
    min_payload_lost: float           # 最小物资损耗 (吨)
    std_payload_lost: float           # 物资损耗标准差
    
    # 物资缺口统计
    avg_shortfall: float              # 平均物资缺口 (吨)
    max_shortfall: float              # 最大物资缺口 (吨)
    
    # 成本统计
    avg_wasted_cost: float            # 平均浪费成本 (USD)
    max_wasted_cost: float            # 最大浪费成本 (USD)
    
    # 工期统计
    avg_delay: float                  # 平均延误 (年)
    max_delay: int                    # 最大延误 (年)
    
    # 成功率
    success_rate: float               # 成功率 (0-1)
    failure_rate: float               # 失败率 (未达标率)
    
    # 分位数统计
    percentile_95_shortfall: float    # 95分位缺口
    percentile_99_shortfall: float    # 99分位缺口
    
    # 原始结果列表
    all_results: List[SimulationResult] = field(default_factory=list)


def simulate_risk_scenarios(
    x_e_values: Dict[int, float],
    x_r_values: Dict[tuple, float],
    site_names: List[str],
    site_payloads: Dict[str, float],
    dyn_cost_per_site: Dict[int, Dict[str, float]],
    dyn_cost_elevator_rocket: Dict[int, float],
    C_elevator_per_ton: float,
    payload_ratio: float,
    planned_years: int,
    M_total: float = 1e8,
    N: int = 1000,
    seed: Optional[int] = 42,
    verbose: bool = True
) -> SimulationSummary:
    """
    蒙特卡洛风险模拟函数
    
    接收 Model 1 的最优解作为输入，模拟随机风险对项目的影响。
    
    参数:
        x_e_values: 电梯每年运量 {year: tons}
        x_r_values: 火箭每年每基地运量 {(site, year): tons}
        site_names: 发射基地名称列表
        site_payloads: 各基地单次载荷量 {site: tons}
        dyn_cost_per_site: 各年各基地动态成本 {year: {site: cost_per_ton}}
        dyn_cost_elevator_rocket: 各年电梯端火箭成本 {year: cost_per_ton}
        C_elevator_per_ton: 电梯运行成本 (USD/ton)
        payload_ratio: 电梯有效载荷比例
        planned_years: 计划工期
        M_total: 目标总需求 (吨)
        N: 模拟次数 (默认1000)
        seed: 随机种子
        verbose: 是否打印详细输出
        
    返回:
        SimulationSummary: 模拟结果汇总统计
    """
    if seed is not None:
        np.random.seed(seed)
    
    years = range(1, planned_years + 1)
    all_results: List[SimulationResult] = []
    
    if verbose:
        print("\n" + "=" * 70)
        print("蒙特卡洛风险模拟 (N = {})".format(N))
        print("=" * 70)
        print(f"计划工期: {planned_years} 年 | 目标需求: {M_total/1e6:.0f} 百万吨")
        print("-" * 70)
    
    for sim_id in range(N):
        # =====================================================================
        # 初始化本次模拟的累积变量
        # =====================================================================
        total_delivered = 0.0          # 实际成功交付的总量
        total_payload_lost = 0.0       # 损失的载荷总量
        total_wasted_cost = 0.0        # 浪费的成本
        
        # 计算计划总量（无风险时的期望交付量）
        planned_total = (sum(x_e_values.get(t, 0) * payload_ratio for t in years) + 
                        sum(x_r_values.get((site, t), 0) for site in site_names for t in years))
        
        # 计算计划总成本
        planned_cost = 0.0
        for t in years:
            # 电梯成本
            e_vol = x_e_values.get(t, 0)
            planned_cost += e_vol * C_elevator_per_ton
            planned_cost += e_vol * payload_ratio * dyn_cost_elevator_rocket.get(t, 0)
            # 火箭成本
            for site in site_names:
                r_vol = x_r_values.get((site, t), 0)
                planned_cost += r_vol * dyn_cost_per_site.get(t, {}).get(site, 0)
        
        # =====================================================================
        # 逐年模拟
        # =====================================================================
        for t in years:
            # -----------------------------------------------------------------
            # 1. 模拟电梯系统风险
            # -----------------------------------------------------------------
            elevator_capacity_factor = 1.0
            
            # 电梯机械故障检测
            if np.random.random() < elevator_mech_fail_prob:
                # 完全故障：当年电梯运力为0
                elevator_capacity_factor = 0.0
            elif np.random.random() < tether_sway_prob:
                # 系绳摇晃：运力下降50%
                elevator_capacity_factor = 1.0 - tether_sway_capacity_reduction
            
            # 计算电梯实际有效交付
            planned_elevator_delivery = x_e_values.get(t, 0) * payload_ratio
            actual_elevator_delivery = planned_elevator_delivery * elevator_capacity_factor
            elevator_loss = planned_elevator_delivery - actual_elevator_delivery
            
            total_delivered += actual_elevator_delivery
            total_payload_lost += elevator_loss
            
            # 电梯损失的成本（已支付但未能交付的部分）
            if elevator_loss > 0:
                # 电梯运行成本已支付，火箭成本按损失比例计算
                loss_ratio = elevator_loss / max(planned_elevator_delivery, 1e-9)
                wasted_elevator_cost = (x_e_values.get(t, 0) * loss_ratio * C_elevator_per_ton +
                                       elevator_loss * dyn_cost_elevator_rocket.get(t, 0))
                total_wasted_cost += wasted_elevator_cost
            
            # -----------------------------------------------------------------
            # 2. 模拟各发射基地火箭风险
            # -----------------------------------------------------------------
            for site in site_names:
                planned_rocket_delivery = x_r_values.get((site, t), 0)
                
                if planned_rocket_delivery <= 0:
                    continue
                
                # 计算该基地当年的发射次数（基于载荷量）
                launches_per_year = planned_rocket_delivery / site_payloads.get(site, 1)
                
                # 每次发射独立判断是否失败
                # 使用二项分布模拟失败次数
                num_launches = max(1, int(np.ceil(launches_per_year)))
                failed_launches = np.random.binomial(num_launches, rocket_fail_prob)
                
                # 计算失败比例
                failure_ratio = failed_launches / num_launches if num_launches > 0 else 0
                
                # 计算实际交付和损失
                rocket_loss = planned_rocket_delivery * failure_ratio
                actual_rocket_delivery = planned_rocket_delivery - rocket_loss
                
                total_delivered += actual_rocket_delivery
                total_payload_lost += rocket_loss
                
                # 火箭损失的成本（货物灭失但成本已支出）
                if rocket_loss > 0:
                    wasted_rocket_cost = rocket_loss * dyn_cost_per_site.get(t, {}).get(site, 0)
                    total_wasted_cost += wasted_rocket_cost
        
        # =====================================================================
        # 计算本次模拟结果
        # =====================================================================
        shortfall = max(0, M_total - total_delivered)
        is_successful = (total_delivered >= M_total)
        
        # 计算实际工期（如果有缺口，假设需要额外年份补充）
        if is_successful:
            actual_years = planned_years
            delay_years = 0
        else:
            # 估算需要多少额外年份（基于平均年运量）
            avg_annual_delivery = total_delivered / planned_years if planned_years > 0 else 1
            extra_years_needed = int(np.ceil(shortfall / max(avg_annual_delivery, 1)))
            actual_years = planned_years + extra_years_needed
            delay_years = extra_years_needed
        
        # 创建结果记录
        result = SimulationResult(
            simulation_id=sim_id,
            planned_total=planned_total,
            actual_delivered=total_delivered,
            payload_lost=total_payload_lost,
            shortfall=shortfall,
            planned_cost=planned_cost,
            wasted_cost=total_wasted_cost,
            planned_years=planned_years,
            actual_years=actual_years,
            delay_years=delay_years,
            is_successful=is_successful
        )
        all_results.append(result)
        
        # 进度显示
        if verbose and (sim_id + 1) % 200 == 0:
            print(f"  已完成 {sim_id + 1}/{N} 次模拟...")
    
    # =========================================================================
    # 统计汇总
    # =========================================================================
    payload_losses = [r.payload_lost for r in all_results]
    shortfalls = [r.shortfall for r in all_results]
    wasted_costs = [r.wasted_cost for r in all_results]
    delays = [r.delay_years for r in all_results]
    successes = [r.is_successful for r in all_results]
    
    summary = SimulationSummary(
        num_simulations=N,
        
        # 物资损耗统计
        avg_payload_lost=np.mean(payload_losses),
        max_payload_lost=np.max(payload_losses),
        min_payload_lost=np.min(payload_losses),
        std_payload_lost=np.std(payload_losses),
        
        # 物资缺口统计
        avg_shortfall=np.mean(shortfalls),
        max_shortfall=np.max(shortfalls),
        
        # 成本统计
        avg_wasted_cost=np.mean(wasted_costs),
        max_wasted_cost=np.max(wasted_costs),
        
        # 工期统计
        avg_delay=np.mean(delays),
        max_delay=int(np.max(delays)),
        
        # 成功率
        success_rate=np.mean(successes),
        failure_rate=1.0 - np.mean(successes),
        
        # 分位数
        percentile_95_shortfall=np.percentile(shortfalls, 95),
        percentile_99_shortfall=np.percentile(shortfalls, 99),
        
        all_results=all_results
    )
    
    # =========================================================================
    # 打印结果
    # =========================================================================
    if verbose:
        print("\n" + "=" * 70)
        print("蒙特卡洛模拟结果汇总")
        print("=" * 70)
        
        print("\n【物资损耗统计】")
        print(f"  • 平均物资损耗:  {summary.avg_payload_lost/1e6:.3f} 百万吨")
        print(f"  • 最大物资损耗:  {summary.max_payload_lost/1e6:.3f} 百万吨")
        print(f"  • 最小物资损耗:  {summary.min_payload_lost/1e6:.3f} 百万吨")
        print(f"  • 损耗标准差:    {summary.std_payload_lost/1e6:.3f} 百万吨")
        
        print("\n【物资缺口统计】")
        print(f"  • 平均物资缺口:  {summary.avg_shortfall/1e6:.3f} 百万吨")
        print(f"  • 最大物资缺口:  {summary.max_shortfall/1e6:.3f} 百万吨")
        print(f"  • 95分位缺口:    {summary.percentile_95_shortfall/1e6:.3f} 百万吨")
        print(f"  • 99分位缺口:    {summary.percentile_99_shortfall/1e6:.3f} 百万吨")
        
        print("\n【成本损失统计】")
        print(f"  • 平均浪费成本:  ${summary.avg_wasted_cost/1e9:.2f} 十亿美元")
        print(f"  • 最大浪费成本:  ${summary.max_wasted_cost/1e9:.2f} 十亿美元")
        
        print("\n【工期影响统计】")
        print(f"  • 平均延误:      {summary.avg_delay:.1f} 年")
        print(f"  • 最大延误:      {summary.max_delay} 年")
        
        print("\n【项目成功率】")
        print(f"  • 成功率:        {summary.success_rate*100:.1f}%")
        print(f"  • 失败率(未达标): {summary.failure_rate*100:.1f}%")
        
        print("=" * 70 + "\n")
    
    return summary


def analyze_risk_distribution(summary: SimulationSummary):
    """
    分析风险分布并提供风险评估报告
    """
    print("\n" + "=" * 70)
    print("风险分布分析报告")
    print("=" * 70)
    
    # 风险等级分类
    results = summary.all_results
    
    low_risk = [r for r in results if r.shortfall == 0]
    medium_risk = [r for r in results if 0 < r.shortfall <= 5e6]  # 0-500万吨缺口
    high_risk = [r for r in results if 5e6 < r.shortfall <= 20e6]  # 500万-2000万吨缺口
    critical_risk = [r for r in results if r.shortfall > 20e6]  # >2000万吨缺口
    
    print("\n【风险等级分布】")
    print(f"  • 低风险 (无缺口):     {len(low_risk):>4} 次 ({len(low_risk)/len(results)*100:.1f}%)")
    print(f"  • 中风险 (≤500万吨):   {len(medium_risk):>4} 次 ({len(medium_risk)/len(results)*100:.1f}%)")
    print(f"  • 高风险 (≤2000万吨):  {len(high_risk):>4} 次 ({len(high_risk)/len(results)*100:.1f}%)")
    print(f"  • 极端风险 (>2000万吨): {len(critical_risk):>4} 次 ({len(critical_risk)/len(results)*100:.1f}%)")
    
    # 延误分布
    print("\n【延误分布】")
    no_delay = [r for r in results if r.delay_years == 0]
    short_delay = [r for r in results if 0 < r.delay_years <= 2]
    medium_delay = [r for r in results if 2 < r.delay_years <= 5]
    long_delay = [r for r in results if r.delay_years > 5]
    
    print(f"  • 无延误:       {len(no_delay):>4} 次 ({len(no_delay)/len(results)*100:.1f}%)")
    print(f"  • 轻度 (1-2年): {len(short_delay):>4} 次 ({len(short_delay)/len(results)*100:.1f}%)")
    print(f"  • 中度 (3-5年): {len(medium_delay):>4} 次 ({len(medium_delay)/len(results)*100:.1f}%)")
    print(f"  • 严重 (>5年):  {len(long_delay):>4} 次 ({len(long_delay)/len(results)*100:.1f}%)")
    
    print("=" * 70 + "\n")


# =============================================================================
# 可视化分析函数
# =============================================================================

def simulate_with_yearly_tracking(
    x_e_values: Dict[int, float],
    x_r_values: Dict[tuple, float],
    site_names: List[str],
    site_payloads: Dict[str, float],
    payload_ratio: float,
    planned_years: int,
    N: int = 1000,
    seed: Optional[int] = 42
) -> Tuple[List[float], Dict[int, List[float]]]:
    """
    带年度跟踪的蒙特卡洛模拟，用于绘制累计损失趋势
    
    返回:
        actual_deliveries: 每次模拟的最终实际交付量列表
        yearly_losses: 每年的损失量列表 {year: [loss_sim1, loss_sim2, ...]}
    """
    if seed is not None:
        np.random.seed(seed)
    
    years = range(1, planned_years + 1)
    actual_deliveries = []
    yearly_losses = {t: [] for t in years}
    
    for sim_id in range(N):
        total_delivered = 0.0
        sim_yearly_loss = {t: 0.0 for t in years}
        
        for t in years:
            # 电梯风险
            elevator_capacity_factor = 1.0
            if np.random.random() < elevator_mech_fail_prob:
                elevator_capacity_factor = 0.0
            elif np.random.random() < tether_sway_prob:
                elevator_capacity_factor = 1.0 - tether_sway_capacity_reduction
            
            planned_elevator = x_e_values.get(t, 0) * payload_ratio
            actual_elevator = planned_elevator * elevator_capacity_factor
            elevator_loss = planned_elevator - actual_elevator
            
            total_delivered += actual_elevator
            sim_yearly_loss[t] += elevator_loss
            
            # 火箭风险
            for site in site_names:
                planned_rocket = x_r_values.get((site, t), 0)
                if planned_rocket <= 0:
                    continue
                    
                launches = max(1, int(np.ceil(planned_rocket / site_payloads.get(site, 1))))
                failed = np.random.binomial(launches, rocket_fail_prob)
                failure_ratio = failed / launches if launches > 0 else 0
                
                rocket_loss = planned_rocket * failure_ratio
                actual_rocket = planned_rocket - rocket_loss
                
                total_delivered += actual_rocket
                sim_yearly_loss[t] += rocket_loss
        
        actual_deliveries.append(total_delivered)
        for t in years:
            yearly_losses[t].append(sim_yearly_loss[t])
    
    return actual_deliveries, yearly_losses





# =============================================================================
# 原始确定性模型 (Model 1) - 修改为返回最优解
# =============================================================================

def solve_moon_logistics_final_optimized(alpha_weight=0.4, beta_weight=0.4, gamma_weight=0.2, return_solution=False):
    """
    最终优化版模型 (用户定制版) - 增加环境影响目标 (Objective 4 Extension)
    
    目标函数:
    Obj = alpha * (Cost/Ref_Cost) + beta * (Time/Ref_Time) + gamma * (Env/Ref_Env)
    """
    
    # =========================================================================
    # 1. 核心参数定义
    # =========================================================================
    M_total = 1e8            # 总需求: 1亿吨
    Max_Horizon = 166         # 优化年限
    
    # 太空电梯参数
    payload=0.50 #电梯顶部发射的火箭的载荷比例
    C_elevator_per_ton = 1330       # $1330/ton
    Initial_C_elevator_rocket_per_ton = 1035000     # $1.035M/ton
    Cap_elevator_sys = 179000 * 3   # 53.7万吨/年
    
    # --- 动态因子设定 ---
    Cost_Decay_Rate = 0.02 
    Cost_Min_Floor  = 0.2  
    Freq_Growth_Per_Decade = 0.15 

    # --- 基地数据表 ---
    Unified_Cost_Per_Ton = 4000 * 1000
    
    # 基地特定载荷
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

    # =========================================================================
    # [新增] 环境影响参数定义
    # =========================================================================
    
    # 1. 基础环境代价 (单位: 影响点数/次)
    base_atm = 4000     # 大气层破坏
    base_res = 2200     # 资源消耗
    base_debris = 500   # 空间碎片 (risk-weighted)
    base_local = 500    # 本地生态干扰
    
    # 2. 基地敏感度系数
    site_sensitivity = {
        "Florida": 1.5, "French Guiana": 1.5,  # 湿地/雨林 (高敏感)
        "Texas": 0.8, "Kazakhstan": 0.8, "China": 0.8, # 荒漠/内陆 (低敏感)
        "India": 1.0, "California": 1.0, "Virginia": 1.0, 
        "New Zealand": 1.0, "Alaska": 1.0      # 标准
    }
    
    # 3. 计算各基地单次发射环境代价 Cost_env
    env_impact_per_launch = {}
    for name in site_names:
        sens = site_sensitivity.get(name, 1.0)
        # 环境代价 = 大气 + 资源 + 碎片 + (本地 * 敏感度)
        env_cost = base_atm + base_res + base_debris + (base_local * sens)
        env_impact_per_launch[name] = env_cost

    # =========================================================================
    # 2. 预计算动态参数
    # =========================================================================
    years = range(1, Max_Horizon + 1)
    
    dyn_cap_per_site = {}
    dyn_cost_per_site = {}
    dyn_cost_elevator_rocket = {}
    
    print(f"{'Year':<5} | {'Cost Factor':<15} | {'Freq Mult':<15}")
    print("-" * 60)
    
    for t in years:
        cost_factor = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate * (t-1)))
        decade_idx = (t - 1) // 10
        freq_multiplier = (1 + Freq_Growth_Per_Decade) ** decade_idx
        
        if t % 10 == 1:
            print(f"{t:<5} | {cost_factor:<15.2f} | {freq_multiplier:<15.2f}")
            
        dyn_cap_per_site[t] = {}
        dyn_cost_per_site[t] = {}
        
        dyn_cost_elevator_rocket[t] = Initial_C_elevator_rocket_per_ton * cost_factor
        
        for name, info in site_data.items():
            current_payload = site_payloads[name]
            current_freq = info["initial_freq"] * freq_multiplier
            dyn_cap_per_site[t][name] = current_payload * current_freq
            dyn_cost_per_site[t][name] = info["cost_per_ton"] * cost_factor

    # =========================================================================
    # 3. Gurobi 建模
    # =========================================================================
    model = gp.Model("Moon_Logistics_Eco_Optimized")
    model.setParam('OutputFlag', 0)
    
    # --- 变量 ---
    x_e = model.addVars(years, lb=0, name="Elevator_Tons")
    x_r = model.addVars(site_names, years, lb=0, name="Rocket_Tons")
    u = model.addVars(years, vtype=GRB.BINARY, name="Is_Active") 
    
    # --- 约束 ---
    
    # 1. 总需求满足
    total_transport = gp.quicksum((x_e[t] * payload) for t in years) + \
                      gp.quicksum(x_r[i, t] for i in site_names for t in years)
    model.addConstr(total_transport >= M_total, "Demand_Constraint")
    
    # 2. 运力上限
    for t in years:
        model.addConstr(x_e[t] <= Cap_elevator_sys * u[t], f"Cap_Ele_{t}")
        for i in site_names:
            model.addConstr(x_r[i, t] <= dyn_cap_per_site[t][i] * u[t], f"Cap_Rock_{i}_{t}")
            
    # 3. 时间连续性
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
    # 逻辑: 总发射次数 * 单次环境代价
    # 发射次数 = 运量 / 载荷
    total_env_impact = gp.quicksum(
        (x_r[i, t] / site_payloads[i]) * env_impact_per_launch[i] 
        for i in site_names for t in years
    )
    
    # 归一化参考值
    Ref_Cost = 1e12          # 1 Trillion
    Ref_Time = 100.0         # 100 Years
    Ref_Env  = 5.6e9         # ~5.6 Billion (Estimated Max Impact)
    
    # 综合目标函数 (Weighted Normalized Sum)
    # alpha + beta + gamma SHOULD be 1.0 theoretically, but user provides weights.
    
    obj = alpha_weight * (total_cost_usd / Ref_Cost) + \
          beta_weight * (total_years / Ref_Time) + \
          gamma_weight * (total_env_impact / Ref_Env)
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 4. 求解与输出
    # =========================================================================
    model.optimize()
    
    print("\n" + "="*70)
    print(f"优化结果 (Alpha={alpha_weight}, Beta={beta_weight}, Gamma={gamma_weight})")
    print("="*70)
    
    if model.status == GRB.OPTIMAL:
        t_val = total_years.getValue()
        c_val = total_cost_usd.getValue()
        e_val = total_env_impact.getValue()
        
        print(f"1. 完工时间: {t_val:.0f} 年")
        print(f"2. 总成本:   ${c_val/1e12:.3f} Trillion (万亿美元)")
        print(f"   (Cost Norm: {c_val/Ref_Cost:.4f}, Time Norm: {t_val/Ref_Time:.4f})")
        
        # --- 环境影响输出 ---
        print(f"\n3. 环境影响评估 (Environmental Impact):")
        print(f"   • 总环境影响指数 (EII): {e_val:.2e}")
        print(f"   • 相对环境代价:         {e_val/Ref_Env*100:.2f}% (of Max Worst-Case)")
        
        # 等效CO2估算 (假设 1 impact point ≈ 100 ton CO2e 只是个假设转换，
        # 或者直接把 Total Env 视为某种当量。提示说'输出等效二氧化碳'，需要转换因子
        # 根据题目常见的假设: 
        # 重型火箭发射 CO2e 约为 300-400 tons per launch. 
        # 我们这里的 Cost_env 约 7150 (4000+2200+500+500*0.8)
        # 比例关系: CO2e_tons ≈ (env_score / 20) roughly? 
        # 为了严谨，我们直接输出 EII 作为指标，若需 CO2，可以假设 1发射 ≈ 500t CO2e
        # Total Launches = e_val / avg_cost_per_launch
        # 让我们简单用一个线性系数: 1 Impact Point ≈ 0.1 Ton CO2e (Hypothesis) => 7000 pts = 700t
        co2_conversion = 0.05
        print(f"   • 等效碳排放 (CO2e):    {e_val * co2_conversion / 1e6:.2f} Million Tons (Est.)")
        
        # 统计总量
        sum_e = sum(x_e[t].X for t in years)
        sum_r_total = sum(sum(x_r[i,t].X for i in site_names) for t in years)
        
        print(f"\n4. 运输结构:")
        print(f"   • 电梯运输: {sum_e*payload/1e6:.2f} M tons ({(sum_e*payload)/(sum_e*payload+sum_r_total)*100:.1f}%)")
        print(f"   • 火箭运输: {sum_r_total/1e6:.2f} M tons")
        
        # --- 基地发射分布与环境分析 ---
        print("\n5. 基地发射分布与环境优化分析:")
        print(f"{'Site Name':<15} | {'Sensitivity':<11} | {'Env Cost/L':<10} | {'Launches':<10} | {'Total Mass(Mt)':<15}")
        print("-" * 80)
        
        usage_stats = []
        for i in site_names:
            total_mass = sum(x_r[i, t].X for t in years)
            launches = total_mass / site_payloads[i]
            sens = site_sensitivity.get(i, 1.0)
            e_cost = env_impact_per_launch[i]
            usage_stats.append((i, total_mass, launches, sens, e_cost))
            
        # 按发射次数排序
        usage_stats.sort(key=lambda x: x[1], reverse=True)
        
        for name, mass, n_launch, sens, e_cost in usage_stats:
            if mass > 0.01:
                print(f"{name:<15} | {sens:<11.1f} | {e_cost:<10.0f} | {n_launch:<10.0f} | {mass/1e6:<15.2f}")
        
        print("-" * 80)
        print("★ 策略分析: ")
        # 简单的自动分析
        site_map = {x[0]: x[2] for x in usage_stats} # name -> launches
        tex_l = site_map.get('Texas', 0)
        flo_l = site_map.get('Florida', 0)
        
        if tex_l > flo_l:
            print(f"  > 观察到各基地发射偏好发生转移: 低敏感区域 (如 Texas) 的发射比例显著高于高敏感区域 (如 Florida)。")
            print(f"  > Texas (Sens=0.8) 发射了 {tex_l:.0f} 次，而 Florida (Sens=1.5) 发射了 {flo_l:.0f} 次。")
        else:
            print(f"  > 模型仍在平衡成本与环境，尚未完全放弃高敏感区域。")

        # 简要时间轴分析 (每10年汇总)
        print("\n6. 时间段运量与成本汇总 (每10年):")
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
            period_r_vol = 0
            period_e_payload = 0
            period_r_cost = 0
            period_e_cost = 0
            
            for t in range(t_start, t_end + 1):
                period_r_vol += sum(x_r[i,t].X for i in site_names)
                e_vol_t = x_e[t].X
                e_effective_payload = e_vol_t * payload 
                period_e_payload += e_effective_payload
                period_r_cost += sum(x_r[i,t].X * dyn_cost_per_site[t][i] for i in site_names)
                cost_factor_now = max(Cost_Min_Floor, math.exp(-Cost_Decay_Rate*(t-1)))
                ele_rock_unit_cost = initial_cost * cost_factor_now
                curr_e_cost = (e_vol_t * C_elevator_per_ton) + (e_effective_payload * ele_rock_unit_cost)
                period_e_cost += curr_e_cost

            print(f"{f'Year {t_start}-{t_end}':<15} | {period_r_vol/1e6:<15.2f} | {period_e_payload/1e6:<18.2f} | ${period_r_cost/1e9:<15.2f} | ${period_e_cost/1e9:<15.2f}")
        
        if return_solution:
            solution_data = {
                'x_e_values': {t: x_e[t].X for t in years},
                'x_r_values': {(i, t): x_r[i, t].X for i in site_names for t in years},
                'site_names': site_names,
                'site_payloads': site_payloads,
                'dyn_cost_per_site': dyn_cost_per_site,
                'dyn_cost_elevator_rocket': dyn_cost_elevator_rocket,
                'C_elevator_per_ton': C_elevator_per_ton,
                'payload_ratio': payload,
                'total_env_impact': e_val,
                'total_cost': c_val,
                'planned_years': int(t_val),
                'M_total': M_total,
                'model_status': 'optimal'
            }
            return solution_data
            
    else:
        print("求解失败 (Infeasible)")
        if return_solution:
            return {'model_status': 'failed'}


# =============================================================================
# MODEL 2.5: 鲁棒性增强优化模型 (Robust Optimization)
# =============================================================================

def solve_robust_moon_logistics(
    alpha_weight: float = 0.5,
    safety_buffer: float = 1.15,
    rocket_capacity_discount: Optional[float] = None,
    elevator_capacity_discount: Optional[float] = None,
    return_solution: bool = False,
    verbose: bool = True
):
    """
    鲁棒性增强的月球物流优化模型
    
    在原始 Model 1 的基础上，引入风险调整参数以确保在故障情况下仍能完成任务。
    
    参数:
        alpha_weight: 成本-时间权衡系数 (0.5 = 平衡)
        safety_buffer: 安全冗余系数 (例如 1.15 表示增加 15% 的运量目标)
        rocket_capacity_discount: 火箭运力折减系数 (None = 自动计算)
        elevator_capacity_discount: 电梯运力折减系数 (None = 自动计算)
        return_solution: 是否返回解数据
        verbose: 是否打印详细输出
        
    返回:
        如果 return_solution=True，返回解数据字典
    """
    
    # =========================================================================
    # 1. 计算风险折减系数 (如果未指定)
    # =========================================================================
    
    # 火箭运力折减: 考虑发射失败率
    if rocket_capacity_discount is None:
        rocket_capacity_discount = (1 - rocket_fail_prob)  # 默认: 1 - 0.02 = 0.98
    
    # 电梯运力折减: 考虑机械故障率和系绳摇晃
    # 期望可用率 = (1 - 完全故障率) * (完全正常概率 + 部分可用概率 * 可用比例)
    # 期望可用率 = (1 - 0.05) * (1 - 0.10 + 0.10 * 0.50) = 0.95 * 0.95 = 0.9025
    if elevator_capacity_discount is None:
        prob_no_mech_fail = 1 - elevator_mech_fail_prob  # 0.95
        prob_no_sway = 1 - tether_sway_prob  # 0.90
        prob_sway_partial = tether_sway_prob * (1 - tether_sway_capacity_reduction)  # 0.10 * 0.50 = 0.05
        elevator_capacity_discount = prob_no_mech_fail * (prob_no_sway + prob_sway_partial)
        # = 0.95 * (0.90 + 0.05) = 0.95 * 0.95 = 0.9025
    
    if verbose:
        print("\n" + "=" * 70)
        print("鲁棒优化模型参数设置")
        print("=" * 70)
        print(f"  • 安全冗余系数 (Safety Buffer):    {safety_buffer:.2f} ({(safety_buffer-1)*100:.0f}% 额外目标)")
        print(f"  • 火箭运力折减系数:                 {rocket_capacity_discount:.4f}")
        print(f"  • 电梯运力折减系数:                 {elevator_capacity_discount:.4f}")
        print("=" * 70)
    
    # =========================================================================
    # 2. 核心参数定义 (与 Model 1 保持一致)
    # =========================================================================
    M_total_base = 1e8            # 基础总需求: 1亿吨
    M_total = M_total_base * safety_buffer  # 风险调整后的需求目标
    Max_Horizon = 166             # 优化年限
    
    # 太空电梯参数
    payload = 0.50
    C_elevator_per_ton = 1330
    Initial_C_elevator_rocket_per_ton = 1035000
    
    Cap_elevator_sys = 179000 * 3   # 53.7万吨/年
    
    # 成本与频次动态因子
    Cost_Decay_Rate = 0.02 
    Cost_Min_Floor = 0.2
    Freq_Growth_Per_Decade = 0.15
    
    # 基地数据
    Unified_Cost_Per_Ton = 4000 * 1000
    
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

    # =========================================================================
    # 3. 预计算动态参数
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
    # 4. Gurobi 建模 (带鲁棒性增强)
    # =========================================================================
    model = gp.Model("Moon_Logistics_Robust")
    model.setParam('OutputFlag', 0)
    
    # --- 变量 ---
    x_e = model.addVars(years, lb=0, name="Elevator_Tons")
    x_r = model.addVars(site_names, years, lb=0, name="Rocket_Tons")
    u = model.addVars(years, vtype=GRB.BINARY, name="Is_Active")
    
    # --- 约束 ---
    
    # 1. 总需求满足 (使用安全冗余系数调整后的目标)
    total_transport = gp.quicksum((x_e[t] * payload) for t in years) + \
                      gp.quicksum(x_r[i, t] for i in site_names for t in years)
    model.addConstr(total_transport >= M_total, "Demand_Constraint_Robust")
    
    # 2. 运力上限 (应用折减系数)
    for t in years:
        # 电梯运力约束 (应用电梯折减系数)
        effective_elevator_cap = Cap_elevator_sys * elevator_capacity_discount
        model.addConstr(x_e[t] <= effective_elevator_cap * u[t], f"Cap_Ele_Robust_{t}")
        
        # 火箭运力约束 (应用火箭折减系数)
        for i in site_names:
            effective_rocket_cap = dyn_cap_per_site[t][i] * rocket_capacity_discount
            model.addConstr(x_r[i, t] <= effective_rocket_cap * u[t], f"Cap_Rock_Robust_{i}_{t}")
            
    # 3. 时间连续性
    for t in range(1, Max_Horizon):
        model.addConstr(u[t] >= u[t+1])
        
    # --- 目标函数 ---
    total_cost_usd = (
        gp.quicksum((x_e[t] * C_elevator_per_ton + x_e[t] * payload * dyn_cost_elevator_rocket[t]) for t in years) + 
        gp.quicksum(x_r[i, t] * dyn_cost_per_site[t][i] for i in site_names for t in years)
    )
    
    total_years = gp.quicksum(u[t] for t in years)
    
    obj = alpha_weight * (total_cost_usd / 1e12) + (1 - alpha_weight) * total_years
    model.setObjective(obj, GRB.MINIMIZE)
    
    # =========================================================================
    # 5. 求解与输出
    # =========================================================================
    model.optimize()
    
    if verbose:
        print("\n" + "=" * 40)
        print(f"鲁棒优化结果 (Alpha={alpha_weight})")
        print("=" * 40)
    
    if model.status == GRB.OPTIMAL:
        t_val = total_years.getValue()
        c_val = total_cost_usd.getValue()
        
        if verbose:
            print(f"1. 完工时间: {t_val:.0f} 年")
            print(f"2. 总成本:   ${c_val/1e12:.3f} Trillion (万亿美元)")
            
            sum_e = sum(x_e[t].X for t in years)
            sum_r = sum(sum(x_r[i,t].X for i in site_names) for t in years)
            
            print(f"3. 运输结构: 电梯 {sum_e*payload/1e6:.2f} M tons | 火箭 {sum_r/1e6:.2f} M tons")
            print(f"4. 目标运量: {M_total/1e6:.2f} M tons (含 {(safety_buffer-1)*100:.0f}% 安全冗余)")
        
        if return_solution:
            x_e_values = {t: x_e[t].X for t in years}
            x_r_values = {(i, t): x_r[i, t].X for i in site_names for t in years}
            
            solution_data = {
                'x_e_values': x_e_values,
                'x_r_values': x_r_values,
                'site_names': site_names,
                'site_payloads': site_payloads,
                'dyn_cost_per_site': dyn_cost_per_site,
                'dyn_cost_elevator_rocket': dyn_cost_elevator_rocket,
                'C_elevator_per_ton': C_elevator_per_ton,
                'payload_ratio': payload,
                'planned_years': int(t_val),
                'M_total': M_total_base,  # 返回原始目标（1亿吨）
                'M_total_robust': M_total,  # 返回调整后目标
                'total_cost': c_val,
                'safety_buffer': safety_buffer,
                'rocket_capacity_discount': rocket_capacity_discount,
                'elevator_capacity_discount': elevator_capacity_discount,
                'model_status': 'optimal'
            }
            return solution_data
    else:
        if verbose:
            print("求解失败 (可能时间限制 Max_Horizon 太短，建议增加)")
        if return_solution:
            return {'model_status': 'failed'}


def compare_models(
    model1_solution: Dict,
    robust_solution: Dict,
    model1_simulation: Optional[SimulationSummary] = None,
    robust_simulation: Optional[SimulationSummary] = None
):
    """
    对比 Model 1 和鲁棒优化模型的结果
    
    参数:
        model1_solution: Model 1 的解数据
        robust_solution: 鲁棒模型的解数据
        model1_simulation: Model 1 的蒙特卡洛模拟结果 (可选)
        robust_simulation: 鲁棒模型的蒙特卡洛模拟结果 (可选)
    """
    print("\n" + "=" * 80)
    print("Model 1 vs. 鲁棒优化模型 对比分析")
    print("=" * 80)
    
    # 基础指标对比
    m1_years = model1_solution.get('planned_years', 0)
    m1_cost = model1_solution.get('total_cost', 0)
    
    rob_years = robust_solution.get('planned_years', 0)
    rob_cost = robust_solution.get('total_cost', 0)
    
    years_diff = rob_years - m1_years
    cost_diff = rob_cost - m1_cost
    years_pct = (years_diff / m1_years * 100) if m1_years > 0 else 0
    cost_pct = (cost_diff / m1_cost * 100) if m1_cost > 0 else 0
    
    print("\n【基础指标对比】")
    print(f"{'指标':<20} | {'Model 1':<20} | {'鲁棒模型':<20} | {'差异':<20}")
    print("-" * 80)
    print(f"{'完工时间 (年)':<20} | {m1_years:<20} | {rob_years:<20} | {years_diff:+.0f} ({years_pct:+.1f}%)")
    print(f"{'总成本 (万亿$)':<16} | ${m1_cost/1e12:<19.3f} | ${rob_cost/1e12:<19.3f} | ${cost_diff/1e12:+.3f} ({cost_pct:+.1f}%)")
    
    # 运量对比
    m1_e_total = sum(model1_solution.get('x_e_values', {}).values()) * model1_solution.get('payload_ratio', 0.5)
    m1_r_total = sum(model1_solution.get('x_r_values', {}).values())
    
    rob_e_total = sum(robust_solution.get('x_e_values', {}).values()) * robust_solution.get('payload_ratio', 0.5)
    rob_r_total = sum(robust_solution.get('x_r_values', {}).values())
    
    print("\n【运量结构对比】")
    print(f"{'运输方式':<20} | {'Model 1 (百万吨)':<20} | {'鲁棒模型 (百万吨)':<20} | {'增量 (%)':<20}")
    print("-" * 80)
    e_pct = ((rob_e_total - m1_e_total) / m1_e_total * 100) if m1_e_total > 0 else 0
    r_pct = ((rob_r_total - m1_r_total) / m1_r_total * 100) if m1_r_total > 0 else 0
    print(f"{'电梯运输':<20} | {m1_e_total/1e6:<20.2f} | {rob_e_total/1e6:<20.2f} | {e_pct:+.1f}%")
    print(f"{'火箭运输':<20} | {m1_r_total/1e6:<20.2f} | {rob_r_total/1e6:<20.2f} | {r_pct:+.1f}%")
    total_m1 = m1_e_total + m1_r_total
    total_rob = rob_e_total + rob_r_total
    total_pct = ((total_rob - total_m1) / total_m1 * 100) if total_m1 > 0 else 0
    print(f"{'总运量':<20} | {total_m1/1e6:<20.2f} | {total_rob/1e6:<20.2f} | {total_pct:+.1f}%")
    
    # 风险参数对比
    print("\n【鲁棒性参数】")
    print(f"  • 安全冗余系数:       {robust_solution.get('safety_buffer', 'N/A')}")
    print(f"  • 火箭运力折减系数:   {robust_solution.get('rocket_capacity_discount', 'N/A'):.4f}")
    print(f"  • 电梯运力折减系数:   {robust_solution.get('elevator_capacity_discount', 'N/A'):.4f}")
    
    # 如果有模拟结果，进行风险对比
    if model1_simulation and robust_simulation:
        print("\n【风险模拟对比】")
        print(f"{'风险指标':<25} | {'Model 1':<20} | {'鲁棒模型':<20} | {'改善':<15}")
        print("-" * 80)
        
        m1_fail = model1_simulation.failure_rate
        rob_fail = robust_simulation.failure_rate
        fail_improve = (m1_fail - rob_fail) / m1_fail * 100 if m1_fail > 0 else 0
        print(f"{'失败率':<25} | {m1_fail*100:.1f}%{'':<16} | {rob_fail*100:.1f}%{'':<16} | {fail_improve:+.1f}%")
        
        m1_shortfall = model1_simulation.avg_shortfall
        rob_shortfall = robust_simulation.avg_shortfall
        shortfall_improve = (m1_shortfall - rob_shortfall) / m1_shortfall * 100 if m1_shortfall > 0 else 0
        print(f"{'平均缺口 (百万吨)':<21} | {m1_shortfall/1e6:.2f}{'':<17} | {rob_shortfall/1e6:.2f}{'':<17} | {shortfall_improve:+.1f}%")
        
        m1_delay = model1_simulation.avg_delay
        rob_delay = robust_simulation.avg_delay
        delay_improve = (m1_delay - rob_delay) / m1_delay * 100 if m1_delay > 0 else 0
        print(f"{'平均延误 (年)':<23} | {m1_delay:.1f}{'':<18} | {rob_delay:.1f}{'':<18} | {delay_improve:+.1f}%")
        
        m1_success = model1_simulation.success_rate
        rob_success = robust_simulation.success_rate
        print(f"{'成功率':<25} | {m1_success*100:.1f}%{'':<16} | {rob_success*100:.1f}%{'':<16} | {(rob_success-m1_success)*100:+.1f}个百分点")
    
    # 投资回报分析
    print("\n【鲁棒性投资回报分析】")
    if cost_diff > 0:
        print(f"  鲁棒性成本溢价:   ${cost_diff/1e12:.3f} Trillion ({cost_pct:.1f}%)")
    if years_diff != 0:
        print(f"  工期变化:         {years_diff:+.0f} 年 ({years_pct:+.1f}%)")
    
    if model1_simulation and robust_simulation:
        # 计算风险价值 (VaR) 改善
        if m1_fail > 0 and rob_fail < m1_fail:
            failure_reduction = (m1_fail - rob_fail) * 100
            cost_per_failure_pct = cost_diff / (failure_reduction * 1e10) if failure_reduction > 0 else 0
            print(f"  失败率降低:       {failure_reduction:.1f}个百分点")
            print(f"  每降低1%失败率成本: ${cost_per_failure_pct:.2f} Billion")
    
    print("=" * 80 + "\n")


# =============================================================================
# 主执行代码: 完整三阶段分析流程
# =============================================================================

if __name__ == "__main__":
    # =========================================================================
    # 第一步: 打印风险参数
    # =========================================================================
    print_risk_parameters()
    
    # =========================================================================
    # 第二步: 求解 Model 1 (确定性优化)
    # =========================================================================
    print("\n" + "=" * 70)
    print("第一阶段: Model 1 确定性优化求解")
    print("=" * 70)
    
    model1_solution = solve_moon_logistics_final_optimized(
        alpha_weight=0.35, 
        beta_weight=0.35, 
        gamma_weight=0.30, 
        return_solution=True
    )
    
    # =========================================================================
    # 第三步: 使用 Model 1 的解进行蒙特卡洛风险模拟
    # =========================================================================
    model1_simulation = None
    if model1_solution and model1_solution.get('model_status') == 'optimal':
        print("\n" + "=" * 70)
        print("第二阶段: Model 2 蒙特卡洛风险模拟 (基于 Model 1)")
        print("=" * 70)
        
        model1_simulation = simulate_risk_scenarios(
            x_e_values=model1_solution['x_e_values'],
            x_r_values=model1_solution['x_r_values'],
            site_names=model1_solution['site_names'],
            site_payloads=model1_solution['site_payloads'],
            dyn_cost_per_site=model1_solution['dyn_cost_per_site'],
            dyn_cost_elevator_rocket=model1_solution['dyn_cost_elevator_rocket'],
            C_elevator_per_ton=model1_solution['C_elevator_per_ton'],
            payload_ratio=model1_solution['payload_ratio'],
            planned_years=model1_solution['planned_years'],
            M_total=model1_solution['M_total'],
            N=1000,
            seed=42,
            verbose=True
        )
        
        analyze_risk_distribution(model1_simulation)
    
    # =========================================================================
    # 第四步: 求解鲁棒优化模型
    # =========================================================================
    print("\n" + "=" * 70)
    print("第三阶段: 鲁棒优化模型求解")
    print("=" * 70)
    
    # 根据 Model 1 的模拟结果确定安全冗余系数
    if model1_simulation:
        # 基于失败率自动调整安全冗余
        if model1_simulation.failure_rate < 0.10:
            safety_buffer = 1.10  # 10% 冗余
        elif model1_simulation.failure_rate < 0.30:
            safety_buffer = 1.15  # 15% 冗余
        elif model1_simulation.failure_rate < 0.50:
            safety_buffer = 1.20  # 20% 冗余
        else:
            safety_buffer = 1.25  # 25% 冗余
        print(f"\n基于 Model 1 模拟失败率 ({model1_simulation.failure_rate*100:.1f}%), 设置安全冗余系数为 {safety_buffer}")
    else:
        safety_buffer = 1.15  # 默认 15%
    
    robust_solution = solve_robust_moon_logistics(
        alpha_weight=0.5,
        safety_buffer=safety_buffer,
        return_solution=True,
        verbose=True
    )
    
    # =========================================================================
    # 第五步: 对鲁棒优化解进行风险模拟
    # =========================================================================
    robust_simulation = None
    if robust_solution and robust_solution.get('model_status') == 'optimal':
        print("\n" + "=" * 70)
        print("第四阶段: 蒙特卡洛风险模拟 (基于鲁棒优化解)")
        print("=" * 70)
        
        robust_simulation = simulate_risk_scenarios(
            x_e_values=robust_solution['x_e_values'],
            x_r_values=robust_solution['x_r_values'],
            site_names=robust_solution['site_names'],
            site_payloads=robust_solution['site_payloads'],
            dyn_cost_per_site=robust_solution['dyn_cost_per_site'],
            dyn_cost_elevator_rocket=robust_solution['dyn_cost_elevator_rocket'],
            C_elevator_per_ton=robust_solution['C_elevator_per_ton'],
            payload_ratio=robust_solution['payload_ratio'],
            planned_years=robust_solution['planned_years'],
            M_total=robust_solution['M_total'],  # 使用原始目标 (1亿吨)
            N=1000,
            seed=42,
            verbose=True
        )
        
        analyze_risk_distribution(robust_simulation)
    
    # =========================================================================
    # 第六步: 对比分析
    # =========================================================================
    if model1_solution and robust_solution:
        if model1_solution.get('model_status') == 'optimal' and robust_solution.get('model_status') == 'optimal':
            compare_models(
                model1_solution=model1_solution,
                robust_solution=robust_solution,
                model1_simulation=model1_simulation,
                robust_simulation=robust_simulation
            )
    
    # =========================================================================
    # 最终结论
    # =========================================================================
    print("\n" + "=" * 70)
    print("最终决策建议")
    print("=" * 70)
    
    if model1_simulation and robust_simulation:
        print(f"\n  【Model 1 确定性方案】")
        print(f"     工期: {model1_solution.get('planned_years', 'N/A')} 年")
        print(f"     成本: ${model1_solution.get('total_cost', 0)/1e12:.3f} Trillion")
        print(f"     风险: 失败率 {model1_simulation.failure_rate*100:.1f}%")
        
        print(f"\n  【鲁棒优化方案】")
        print(f"     工期: {robust_solution.get('planned_years', 'N/A')} 年")
        print(f"     成本: ${robust_solution.get('total_cost', 0)/1e12:.3f} Trillion")
        print(f"     风险: 失败率 {robust_simulation.failure_rate*100:.1f}%")
        
        cost_premium = (robust_solution.get('total_cost', 0) - model1_solution.get('total_cost', 0)) / 1e12
        risk_reduction = (model1_simulation.failure_rate - robust_simulation.failure_rate) * 100
        
        print(f"\n  【投资决策】")
        print(f"     额外投入 ${cost_premium:.3f} Trillion 可将失败率降低 {risk_reduction:.1f} 个百分点")
        
        if robust_simulation.failure_rate < 0.05:
            print(f"\n  ✓ 推荐采用鲁棒优化方案，风险已降至可接受水平")
        elif robust_simulation.failure_rate < 0.15:
            print(f"\n  ◐ 鲁棒方案风险适中，可考虑进一步增加安全冗余")
        else:
            print(f"\n  ✗ 鲁棒方案风险仍较高，建议重新评估项目可行性")
    
    print("=" * 70 + "\n")
    
