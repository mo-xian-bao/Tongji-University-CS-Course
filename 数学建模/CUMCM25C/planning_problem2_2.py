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
ALPHA = 0.80  # 目标平均达标率

def main():
    """
    主函数：为每个BMI类别，寻找满足平均达标率>=ALPHA的最早时点T。
    """
    if not os.path.exists(INPUT_FILE):
        print(f"错误: 输入文件 '{INPUT_FILE}' 不存在。")
        return

    print(f"--- 开始求解最早达标孕周 (目标平均达标率 >= {ALPHA}) ---")

    # 定义离散的孕周搜索空间，T将按从小到大的顺序被测试
    possible_Ts = np.arange(10, 25.1, 0.1)

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

        # 2. *** 核心修改：按时间顺序搜索，找到第一个满足条件的T ***
        print(f"正在按时间顺序搜索，寻找平均达标率首次达到 {ALPHA} 的时点...")
        
        optimal_T = None

        # 遍历所有可能的T值
        for T in possible_Ts:
            T_rounded = round(T, 1)
            
            # 预测该组所有孕妇在T时的生存概率 S(T) (即未达标概率)
            survival_probs_at_t = cph.predict_survival_function(survival_df[COVARIATES], times=[T_rounded])
            
            # s_t_series 包含了每个孕妇的未达标概率
            s_t_series = survival_probs_at_t.iloc[0]
            
            # 计算达标概率 P(T) = 1 - S(T)
            p_t_series = 1 - s_t_series
            
            # 计算组内的平均达标率
            avg_p_t = p_t_series.mean()
            
            print(f"  当 T = {T_rounded:.1f} 时, 平均达标率 = {avg_p_t:.4f}")
            
            # 检查是否满足条件
            if avg_p_t >= ALPHA:
                optimal_T = T_rounded
                print(f"  >>> 条件满足！已找到最早时点。")
                break # 找到第一个满足条件的T，立即停止搜索

        # 3. 输出结果
        print("\n--- 求解结果 ---")
        if optimal_T is not None:
            print(f"为使平均达标率达到 {ALPHA}，最早应在 {optimal_T:.1f} 周进行检测。")
        else:
            print(f"在 25.0 周内，该组的平均达标率未能达到 {ALPHA}。")

if __name__ == "__main__":
    main()
