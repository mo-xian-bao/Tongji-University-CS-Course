import pandas as pd
from lifelines import CoxPHFitter
import numpy as np
import os

# --- 配置 ---
INPUT_FILE = "D:\\desktop\\CUMCM25C\\代码\\根据改进决策树(3类)的分类.xlsx"
SHEET_NAMES = ["BMI小于等于31.82", "BMI在31.82到33.85", "BMI大于33.85"]
COVARIATES = ["年龄", "孕妇BMI"]
DURATION_COL = "检测孕周"
EVENT_COL = "是否达标"

# --- 延迟风险函数 R(T) ---
def delay_risk_function(T):
    """
    根据题目描述“早期风险低、中期风险高、晚期风险极高”
    定义的分段风险函数。
    """
    # 风险值可以根据实际意义进行调整，这里用作相对大小的示例
    if T <= 12:
        return 1.0  # 早期发现（12周以内），风险较低
    elif 13 <= T <= 27:
        return 5.0  # 中期发现（13-27周），风险高
    else:  # T >= 28
        return 10.0 # 晚期发现（28周以后），风险极高


def calculate_total_risk(T, cph_model, group_data):
    """
    计算在给定孕周T时，整个群体的平均总风险。
    这是我们要优化的目标函数。
    """
    individuals_covariates = group_data[COVARIATES]
    
    # --- 新增：计算该组的平均BMI ---
    avg_bmi_for_group = group_data["孕妇BMI"].mean()
    
    # 预测每个孕妇在 T 和 T+2 时的生存概率 S(t) (即未达标概率)
    survival_probs = cph_model.predict_survival_function(individuals_covariates, times=[T, T + 2])
    survival_probs = survival_probs.T
    
    s_t = survival_probs[T]
    #print(f"\n--- T={T} 时的生存概率 (未达标概率) ---s(t)={s_t.mean():.4f}")

    s_t_plus_2 = survival_probs[T + 2]
    
    p_t = 1 - s_t

    # --- 修改：调用风险函数时传入平均BMI ---
    individual_risks = p_t * delay_risk_function(T) + s_t * delay_risk_function(T + 2)
    
    return individual_risks.mean()


def main():
    """
    主函数：为每个BMI类别求解最佳NIPT时点T。
    """
    if not os.path.exists(INPUT_FILE):
        print(f"错误: 输入文件 '{INPUT_FILE}' 不存在。")
        return

    print("--- 开始求解最佳NIPT检测时点 ---")

    # 定义离散的孕周搜索空间
    possible_Ts = np.arange(10, 24.5, 0.1)

    for sheet_name in SHEET_NAMES:
        print(f"\n--- 正在处理类别: {sheet_name} ---")
        
        try:
            df = pd.read_excel(INPUT_FILE, sheet_name=sheet_name)
        except ValueError:
            print(f"警告: 未找到名为 '{sheet_name}' 的Sheet，已跳过。")
            continue

        # 1. 准备数据并拟合Cox模型
        survival_df = df.groupby('孕妇代码').agg(
            duration=(DURATION_COL, 'max'),
            event=(EVENT_COL, 'max'),
            年龄=(COVARIATES[0], 'mean'),
            孕妇BMI=(COVARIATES[1], 'mean')
        ).reset_index()

        cph = CoxPHFitter()
        cph.fit(survival_df, duration_col='duration', event_col='event', formula="年龄 + 孕妇BMI")
        print("Cox模型拟合完成。")

        # 2. *** 核心修改：使用暴力遍历法求解 ***
        print(f"正在遍历 {len(possible_Ts)} 个可能的孕周时点以寻找最优解...")
        
        best_T = None
        min_risk = float('inf') # 初始化最小风险为一个极大值

        # 遍历所有可能的T值
        for T in possible_Ts:
            current_risk = calculate_total_risk(T, cph, survival_df)
            
            # 新增：打印每一步的目标函数值
            print(f"  当 T = {T:.1f} 时, 目标函数值 (平均风险) = {current_risk:.6f}")
            
            # 如果当前风险更小，则更新最优解
            if current_risk < min_risk:
                min_risk = current_risk
                best_T = T
        
        # 3. 输出结果
        if best_T is not None:
            print("\n--- 优化结果 ---")
            print(f"最佳NIPT检测时点 (T): {best_T:.1f} 周")
            # 修改：使用更明确的描述
            print(f"最终优化的目标函数值 (最小平均风险): {min_risk:.6f}")
        else:
            print("\n错误: 未能找到最优解。")

if __name__ == "__main__":
    main()
