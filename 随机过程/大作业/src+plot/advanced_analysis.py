"""
进阶分析：涨跌分类能力 & 预测步长衰减
针对 MSFT 股票和 Model_C_Structural 模型
"""
import warnings
warnings.filterwarnings('ignore')

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.gaussian_process.kernels import (
    Matern, RationalQuadratic, WhiteKernel, ConstantKernel as C
)
from tqdm import tqdm

from data_loader import download_stock_prices

plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'Arial Unicode MS']
plt.rcParams['axes.unicode_minus'] = False

# Model C: Structural (Matern + RQ)
kernel_model_c = C(1.0) * Matern(length_scale=1.0, nu=1.5) + \
                 C(1.0) * RationalQuadratic(length_scale=1.0, alpha=0.1) + \
                 WhiteKernel(1e-5)


def run_rolling_prediction(prices, kernel, window_size=30, pred_step=1):
    """
    滑动窗口预测，支持不同预测步长
    
    Parameters:
        prices: 价格Series
        kernel: 核函数
        window_size: 窗口大小
        pred_step: 预测步长 (1=明天, 5=一周后)
    """
    n = len(prices)
    results = []
    
    for i in tqdm(range(window_size, n - pred_step + 1), desc=f"Step={pred_step}"):
        # 取窗口内数据
        input_seq = prices.iloc[i - window_size:i].values.reshape(-1, 1)
        
        # 局部归一化
        scaler = StandardScaler()
        input_scaled = scaler.fit_transform(input_seq).ravel()
        
        # 训练
        X_train = np.arange(window_size).reshape(-1, 1)
        gpr = GaussianProcessRegressor(kernel=kernel, n_restarts_optimizer=0, random_state=42)
        gpr.fit(X_train, input_scaled)
        
        # 预测 (关键：pred_step控制预测多远)
        X_test = np.array([[window_size + pred_step - 1]])
        y_pred_scaled, y_std_scaled = gpr.predict(X_test, return_std=True)
        
        # 还原
        y_pred = y_pred_scaled[0] * scaler.scale_[0] + scaler.mean_[0]
        y_std = y_std_scaled[0] * scaler.scale_[0]
        
        # 真实值是 i + pred_step - 1 位置
        target_idx = i + pred_step - 1
        if target_idx < n:
            results.append({
                'date': prices.index[target_idx],
                'prev_price': prices.iloc[i - 1],  # 昨日价格
                'true_price': prices.iloc[target_idx],
                'pred_price': y_pred,
                'pred_std': y_std
            })
    
    return pd.DataFrame(results)


def task1_confusion_matrix(prices, kernel, window_size=30):
    """
    任务1：涨跌分类与混淆矩阵
    """
    print("\n" + "=" * 60)
    print("任务1：涨跌分类与混淆矩阵 (Directional Analysis)")
    print("=" * 60)
    
    # 运行Step=1预测
    results = run_rolling_prediction(prices, kernel, window_size, pred_step=1)
    
    # 计算涨跌标签
    # 真实涨跌: Sign(True_Price_t - True_Price_t-1)
    # 预测涨跌: Sign(Pred_Price_t - True_Price_t-1)
    results['true_direction'] = np.sign(results['true_price'] - results['prev_price'])
    results['pred_direction'] = np.sign(results['pred_price'] - results['prev_price'])
    
    # 转换为分类标签 (1=涨, 0=跌, 忽略0)
    # 过滤掉真实涨跌为0的情况
    results_filtered = results[results['true_direction'] != 0].copy()
    
    y_true = (results_filtered['true_direction'] > 0).astype(int)  # 1=涨, 0=跌
    y_pred = (results_filtered['pred_direction'] > 0).astype(int)
    
    # ========== 图1：混淆矩阵热力图 ==========
    cm = confusion_matrix(y_true, y_pred)
    
    fig1, ax1 = plt.subplots(figsize=(8, 6))
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', ax=ax1,
                xticklabels=['预测跌', '预测涨'],
                yticklabels=['实际跌', '实际涨'])
    
    ax1.set_title('MSFT - Model_C_Structural\n涨跌预测混淆矩阵', fontsize=14)
    ax1.set_xlabel('预测方向', fontsize=12)
    ax1.set_ylabel('实际方向', fontsize=12)
    
    tn, fp, fn, tp = cm.ravel()
    stats_text = f'TP={tp}, FP={fp}\nTN={tn}, FN={fn}'
    ax1.text(1.3, 0.5, stats_text, transform=ax1.transAxes, fontsize=11,
            verticalalignment='center',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    plt.tight_layout()
    plt.savefig('MSFT_Confusion_Matrix.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("图片已保存: MSFT_Confusion_Matrix.png")
    
    # ========== 图2：价格走势 + 涨跌柱状图 ==========
    fig2, axes = plt.subplots(2, 1, figsize=(14, 8), gridspec_kw={'height_ratios': [2, 1]})
    
    # 上图：股票价格走势
    ax_price = axes[0]
    ax_price.plot(range(len(prices)), prices.values, 'b-', linewidth=1, label='股票价格')
    ax_price.set_ylabel('价格/美元', fontsize=11)
    ax_price.set_xlabel('时间/天', fontsize=11)
    ax_price.legend(loc='upper left')
    ax_price.grid(True, alpha=0.3)
    ax_price.set_title('MSFT 股票价格与涨跌预测对比', fontsize=14)
    
    # 下图：涨跌预测柱状图
    ax_dir = axes[1]
    
    # 准备数据：将涨跌转换为0/1
    n_results = len(results)
    x_indices = np.arange(n_results)
    
    # 真实涨跌 (1=涨, 0=跌)
    true_up = (results['true_direction'] > 0).astype(int).values
    # 预测涨跌
    pred_up = (results['pred_direction'] > 0).astype(int).values
    
    # 绘制柱状图
    bar_width = 0.4
    ax_dir.bar(x_indices - bar_width/2, true_up, width=bar_width, color='green', 
               alpha=0.7, label='实际涨跌')
    ax_dir.bar(x_indices + bar_width/2, pred_up, width=bar_width, color='magenta', 
               alpha=0.7, label='预测涨跌')
    
    ax_dir.set_ylabel('涨跌预测（1:上涨, 0:下跌）', fontsize=11)
    ax_dir.set_xlabel('时间/天', fontsize=11)
    ax_dir.set_ylim(-0.1, 1.1)
    ax_dir.set_yticks([0, 1])
    ax_dir.legend(loc='upper right')
    ax_dir.grid(True, alpha=0.3, axis='y')
    
    plt.tight_layout()
    plt.savefig('MSFT_Direction_Comparison.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("图片已保存: MSFT_Direction_Comparison.png")
    
    # 打印分类报告
    print("\n【Classification Report】")
    print(classification_report(y_true, y_pred, target_names=['跌', '涨']))
    
    # 方向准确率
    accuracy = (y_true == y_pred).mean()
    print(f"方向准确率 (Directional Accuracy): {accuracy:.2%}")
    
    return results


def task2_step_analysis(prices, kernel, window_size=30):
    """
    任务2：预测步长衰减分析
    对比 Step=1 和 Step=5 的性能
    """
    print("\n" + "=" * 60)
    print("任务2：预测步长衰减分析 (Forecast Horizon Analysis)")
    print("=" * 60)
    
    # 运行Step=1预测
    print("\n运行 Step=1 预测...")
    results_step1 = run_rolling_prediction(prices, kernel, window_size, pred_step=1)
    
    # 运行Step=5预测
    print("\n运行 Step=5 预测...")
    results_step5 = run_rolling_prediction(prices, kernel, window_size, pred_step=5)
    
    # 计算指标
    def calc_metrics(df):
        mape = (np.abs(df['true_price'] - df['pred_price']) / df['true_price']).mean() * 100
        lower = df['pred_price'] - 1.96 * df['pred_std']
        upper = df['pred_price'] + 1.96 * df['pred_std']
        coverage = ((df['true_price'] >= lower) & (df['true_price'] <= upper)).mean()
        return mape, coverage
    
    mape1, cov1 = calc_metrics(results_step1)
    mape5, cov5 = calc_metrics(results_step5)
    
    print(f"\n【Step=1 (预测明天)】")
    print(f"  MAPE: {mape1:.2f}%")
    print(f"  Coverage: {cov1:.2%}")
    
    print(f"\n【Step=5 (预测一周后)】")
    print(f"  MAPE: {mape5:.2f}%")
    print(f"  Coverage: {cov5:.2%}")
    
    print(f"\n【衰减分析】")
    print(f"  MAPE增加: {mape5 - mape1:+.2f}%")
    print(f"  Coverage变化: {(cov5 - cov1)*100:+.2f}%")
    
    # 绘制对比图
    fig, axes = plt.subplots(2, 1, figsize=(14, 10))
    
    # 子图1：预测曲线对比
    ax1 = axes[0]
    
    # 对齐日期（取交集）
    common_dates = set(results_step1['date']) & set(results_step5['date'])
    r1 = results_step1[results_step1['date'].isin(common_dates)].sort_values('date')
    r5 = results_step5[results_step5['date'].isin(common_dates)].sort_values('date')
    
    ax1.plot(r1['date'], r1['true_price'], 'b-', linewidth=1.5, label='真实价格')
    ax1.plot(r1['date'], r1['pred_price'], 'g-', linewidth=1, alpha=0.8, label='Step=1 预测')
    ax1.plot(r5['date'], r5['pred_price'], 'r--', linewidth=1, alpha=0.8, label='Step=5 预测')
    
    ax1.set_title('MSFT - Model_C_Structural: 预测步长对比', fontsize=14)
    ax1.set_xlabel('日期')
    ax1.set_ylabel('价格 (USD)')
    ax1.legend(loc='upper left')
    ax1.grid(True, alpha=0.3)
    
    # 子图2：逐日MAPE对比
    ax2 = axes[1]
    
    # 计算逐日误差
    r1['abs_error'] = np.abs(r1['true_price'] - r1['pred_price']) / r1['true_price'] * 100
    r5['abs_error'] = np.abs(r5['true_price'] - r5['pred_price']) / r5['true_price'] * 100
    
    # 使用滚动平均平滑
    window = 20
    r1['mape_smooth'] = r1['abs_error'].rolling(window, min_periods=1).mean()
    r5['mape_smooth'] = r5['abs_error'].rolling(window, min_periods=1).mean()
    
    ax2.plot(r1['date'], r1['mape_smooth'], 'g-', linewidth=1.5, label=f'Step=1 (Avg MAPE={mape1:.2f}%)')
    ax2.plot(r5['date'], r5['mape_smooth'], 'r-', linewidth=1.5, label=f'Step=5 (Avg MAPE={mape5:.2f}%)')
    
    ax2.set_title('预测误差随时间变化 (20日滚动平均)', fontsize=14)
    ax2.set_xlabel('日期')
    ax2.set_ylabel('MAPE (%)')
    ax2.legend(loc='upper left')
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(0, max(r5['mape_smooth'].max() * 1.2, 10))
    
    plt.tight_layout()
    plt.savefig('MSFT_Step_Analysis.png', dpi=150, bbox_inches='tight')
    plt.show()
    print("\n图片已保存: MSFT_Step_Analysis.png")
    
    return {
        'step1': {'mape': mape1, 'coverage': cov1},
        'step5': {'mape': mape5, 'coverage': cov5}
    }


def run_advanced_analysis():
    """
    运行进阶分析
    """
    print("=" * 70)
    print("进阶分析：MSFT - Model_C_Structural")
    print("=" * 70)
    
    # 下载数据
    print("\n下载MSFT数据...")
    prices_df = download_stock_prices(['MSFT'], start="2010-01-01", end="2020-12-31")
    
    # 截取最后252天
    prices = prices_df['MSFT'].tail(252)
    print(f"分析数据: {len(prices)} 天")
    print(f"时间范围: {prices.index[0]} 至 {prices.index[-1]}")
    
    # 任务1：混淆矩阵
    task1_confusion_matrix(prices, kernel_model_c, window_size=30)
    
    # 任务2：步长分析
    task2_step_analysis(prices, kernel_model_c, window_size=30)
    
    print("\n" + "=" * 70)
    print("进阶分析完成！")
    print("=" * 70)


if __name__ == "__main__":
    run_advanced_analysis()
