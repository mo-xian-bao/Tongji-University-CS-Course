import pandas as pd
from lifelines import KaplanMeierFitter  # *** 核心修改：导入KaplanMeierFitter ***
import numpy as np
import os

# --- 配置 ---
INPUT_FILE = "依据BMI的决策树分类结果.xlsx"
SHEET_NAMES = ["BMI分类_1", "BMI分类_2", "BMI分类_3"]

DURATION_COL = "检测孕周"
EVENT_COL = "是否达标"
GROUP_COL = "孕妇代码"
ALPHA = 0.9  # 目标平均达标率

def main():
    """
    主函数：为每个BMI类别，使用Kaplan-Meier模型寻找满足群体达标率>=ALPHA的最早时点T。
    """
    if not os.path.exists(INPUT_FILE):
        print(f"错误: 输入文件 '{INPUT_FILE}' 不存在。")
        return

    print(f"--- 开始求解最早达标孕周 (目标群体达标率 >= {ALPHA}) ---")

    # 定义离散的孕周搜索空间
    possible_Ts = np.arange(10, 25.1, 0.1)

    for sheet_name in SHEET_NAMES:
        print(f"\n--- 正在处理类别: {sheet_name} ---")
        
        try:
            df = pd.read_excel(INPUT_FILE, sheet_name=sheet_name)
        except ValueError:
            print(f"警告: 未找到名为 '{sheet_name}' 的Sheet，已跳过。")
            continue

        # 1. 准备生存分析数据 (与之前逻辑相同)
        print("正在为生存分析准备数据 (使用首次达标时间)...")
        df_clean = df.dropna(subset=[EVENT_COL]).copy()
        
        df_event = df_clean[df_clean[EVENT_COL] == 1]
        df_censored = df_clean[df_clean[EVENT_COL] == 0]

        if not df_event.empty:
            first_event_times = df_event.loc[df_event.groupby(GROUP_COL)[DURATION_COL].idxmin()].copy()
            first_event_times['event'] = 1
        else:
            first_event_times = pd.DataFrame()

        censored_ids = set(df_censored[GROUP_COL]) - set(df_event[GROUP_COL])
        if censored_ids:
            df_censored_only = df_censored[df_censored[GROUP_COL].isin(censored_ids)]
            last_censor_times = df_censored_only.loc[df_censored_only.groupby(GROUP_COL)[DURATION_COL].idxmax()].copy()
            last_censor_times['event'] = 0
        else:
            last_censor_times = pd.DataFrame()

        # 定义需要保留的原始列
        cols_to_keep = [GROUP_COL, DURATION_COL]

        survival_df = pd.concat([
            first_event_times[cols_to_keep + ['event']],
            last_censor_times[cols_to_keep + ['event']]
        ]).reset_index(drop=True)
        
        survival_df = survival_df.rename(columns={DURATION_COL: 'duration'})

        # *** 核心修改：使用KaplanMeierFitter代替CoxPHFitter ***
        kmf = KaplanMeierFitter()
        # 拟合模型，不再需要formula或协变量
        kmf.fit(survival_df['duration'], event_observed=survival_df['event'])
        print("Kaplan-Meier模型拟合完成。")

        # 2. 按时间顺序搜索，找到第一个满足条件的T
        print(f"正在按时间顺序搜索，寻找群体达标率首次达到 {ALPHA} 的时点...")
        
        optimal_T = None

        # 遍历所有可能的T值
        for T in possible_Ts:
            T_rounded = round(T, 1)
            
            # *** 核心修改：预测整个群体的生存概率 S(T) (即未达标概率) ***
            # kmf.predict(T) 直接返回一个标量值
            survival_prob_at_t = kmf.predict(T_rounded)
            
            # 计算群体达标概率 P(T) = 1 - S(T)
            p_t = 1 - survival_prob_at_t
            
            print(f"  当 T = {T_rounded:.1f} 时, 群体达标率 = {p_t:.4f}")
            
            # 检查是否满足条件
            if p_t >= ALPHA:
                optimal_T = T_rounded
                print(f"  >>> 条件满足！已找到最早时点。")
                break # 找到第一个满足条件的T，立即停止搜索

        # 3. 输出结果
        print("\n--- 求解结果 ---")
        if optimal_T is not None:
            print(f"为使群体达标率达到 {ALPHA}，最早应在 {optimal_T:.1f} 周进行检测。")
        else:
            print(f"在 25.0 周内，该组的群体达标率未能达到 {ALPHA}。")

if __name__ == "__main__":
    main()
