"""
GPR对比实验 - 复现参考文献中的两种预测模式
Static Split vs Rolling Window
"""
import warnings
warnings.filterwarnings('ignore')

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.gaussian_process.kernels import (
    RBF, Matern, RationalQuadratic, ExpSineSquared,
    WhiteKernel, ConstantKernel as C
)
from tqdm import tqdm

from data_loader import download_stock_prices

plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'Arial Unicode MS']
plt.rcParams['axes.unicode_minus'] = False

# 模型定义
kernels_dict = {
    'Model_A_RBF': C(1.0) * RBF(1.0) + WhiteKernel(1e-5),
    'Model_B_Matern': C(1.0) * Matern(length_scale=1.0, nu=1.5) + WhiteKernel(1e-5),
    'Model_C_Structural': C(1.0) * Matern(length_scale=1.0, nu=1.5) + \
                          C(1.0) * RationalQuadratic(length_scale=1.0, alpha=0.1) + \
                          WhiteKernel(1e-5),
    'Model_D_QuasiPeriodic': C(1.0) * RationalQuadratic(length_scale=1.0, alpha=0.1) * \
                              ExpSineSquared(length_scale=1.0, periodicity=30.0) + \
                              WhiteKernel(1e-5)
}


def run_static_split(prices, kernel, train_size=200):
    """
    静态切分模式：一次性训练，一次性预测
    """
    n = len(prices)
    
    # 切分数据
    train_prices = prices.iloc[:train_size].values.reshape(-1, 1)
    test_prices = prices.iloc[train_size:].values
    
    # 归一化
    scaler = StandardScaler()
    train_scaled = scaler.fit_transform(train_prices).ravel()
    
    # 构建训练集
    X_train = np.arange(train_size).reshape(-1, 1)
    y_train = train_scaled
    
    # 训练GPR
    gpr = GaussianProcessRegressor(kernel=kernel, n_restarts_optimizer=0, random_state=42)
    gpr.fit(X_train, y_train)
    
    # 预测测试集
    test_size = n - train_size
    X_test = np.arange(train_size, n).reshape(-1, 1)
    y_pred_scaled, y_std_scaled = gpr.predict(X_test, return_std=True)
    
    # 还原价格
    y_pred = y_pred_scaled * scaler.scale_[0] + scaler.mean_[0]
    y_std = y_std_scaled * scaler.scale_[0]
    
    return {
        'train_dates': prices.index[:train_size],
        'test_dates': prices.index[train_size:],
        'train_prices': prices.iloc[:train_size].values,
        'test_prices': test_prices,
        'pred_prices': y_pred,
        'pred_std': y_std,
        'lower': y_pred - 1.96 * y_std,
        'upper': y_pred + 1.96 * y_std
    }


def run_rolling_window(prices, kernel, window_size=30):
    """
    滑动窗口模式：逐步预测
    """
    n = len(prices)
    results = []
    
    for i in range(window_size, n):
        # 取窗口内数据
        input_seq = prices.iloc[i - window_size:i].values.reshape(-1, 1)
        
        # 局部归一化
        scaler = StandardScaler()
        input_scaled = scaler.fit_transform(input_seq).ravel()
        
        # 训练
        X_train = np.arange(window_size).reshape(-1, 1)
        gpr = GaussianProcessRegressor(kernel=kernel, n_restarts_optimizer=0, random_state=42)
        gpr.fit(X_train, input_scaled)
        
        # 预测
        X_test = np.array([[window_size]])
        y_pred_scaled, y_std_scaled = gpr.predict(X_test, return_std=True)
        
        # 还原
        y_pred = y_pred_scaled[0] * scaler.scale_[0] + scaler.mean_[0]
        y_std = y_std_scaled[0] * scaler.scale_[0]
        
        results.append({
            'date': prices.index[i],
            'true': prices.iloc[i],
            'pred': y_pred,
            'std': y_std
        })
    
    df = pd.DataFrame(results)
    return {
        'dates': df['date'].values,
        'true_prices': df['true'].values,
        'pred_prices': df['pred'].values,
        'pred_std': df['std'].values,
        'lower': df['pred'].values - 1.96 * df['std'].values,
        'upper': df['pred'].values + 1.96 * df['std'].values
    }


def calc_metrics(y_true, y_pred, lower, upper):
    """计算MAPE和Coverage"""
    mape = (np.abs(y_true - y_pred) / y_true).mean() * 100
    coverage = ((y_true >= lower) & (y_true <= upper)).mean()
    return mape, coverage


def plot_comparison(stock, model_name, static_results, rolling_results, save_path):
    """
    绘制对比图：上下两个子图
    """
    fig, axes = plt.subplots(2, 1, figsize=(14, 10))
    
    # ========== 子图1: Static Split ==========
    ax1 = axes[0]
    
    # 训练集真实值 - 蓝色
    ax1.plot(static_results['train_dates'], static_results['train_prices'],
             'b-', linewidth=1.5, label='Training Data')
    
    # 测试集真实值 - 绿色
    ax1.plot(static_results['test_dates'], static_results['test_prices'],
             'g-', linewidth=1.5, label='Test Data (True)')
    
    # 测试集预测值 - 紫红色
    ax1.plot(static_results['test_dates'], static_results['pred_prices'],
             'm-', linewidth=1.5, label='Prediction')
    
    # 置信区间 - 浅粉色
    ax1.fill_between(static_results['test_dates'],
                     static_results['lower'], static_results['upper'],
                     alpha=0.3, color='pink', label='95% CI')
    
    # 计算指标
    mape1, cov1 = calc_metrics(static_results['test_prices'],
                                static_results['pred_prices'],
                                static_results['lower'],
                                static_results['upper'])
    
    ax1.set_title(f'{stock} - {model_name} - Static Split (Global Features)', fontsize=12)
    ax1.set_xlabel('Date')
    ax1.set_ylabel('Price (USD)')
    ax1.legend(loc='upper left')
    ax1.grid(True, alpha=0.3)
    ax1.text(0.02, 0.02, f'MAPE: {mape1:.2f}%  |  Coverage: {cov1:.1%}',
             transform=ax1.transAxes, fontsize=10,
             bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    # ========== 子图2: Rolling Window ==========
    ax2 = axes[1]
    
    # 真实值 - 蓝色
    ax2.plot(rolling_results['dates'], rolling_results['true_prices'],
             'b-', linewidth=1.5, label='True Price')
    
    # 预测值 - 紫红色
    ax2.plot(rolling_results['dates'], rolling_results['pred_prices'],
             'm-', linewidth=1.5, label='Prediction')
    
    # 置信区间 - 浅粉色
    ax2.fill_between(rolling_results['dates'],
                     rolling_results['lower'], rolling_results['upper'],
                     alpha=0.3, color='pink', label='95% CI')
    
    # 计算指标
    mape2, cov2 = calc_metrics(rolling_results['true_prices'],
                                rolling_results['pred_prices'],
                                rolling_results['lower'],
                                rolling_results['upper'])
    
    ax2.set_title(f'{stock} - {model_name} - Sliding Window (Rolling Update)', fontsize=12)
    ax2.set_xlabel('Date')
    ax2.set_ylabel('Price (USD)')
    ax2.legend(loc='upper left')
    ax2.grid(True, alpha=0.3)
    ax2.text(0.02, 0.02, f'MAPE: {mape2:.2f}%  |  Coverage: {cov2:.1%}',
             transform=ax2.transAxes, fontsize=10,
             bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    plt.tight_layout()
    plt.savefig(save_path, dpi=150, bbox_inches='tight')
    plt.close()
    
    return mape1, cov1, mape2, cov2


def run_comparison_experiment():
    """
    运行完整对比实验
    """
    print("=" * 70)
    print("GPR对比实验 - Static Split vs Rolling Window")
    print("=" * 70)
    
    # 配置
    tickers = ['MSFT', 'ORCL', 'SBUX', 'EA', 'ADBE']
    model_names = list(kernels_dict.keys())
    test_days = 252  # 最近1年
    train_size = 200  # Static模式训练集大小
    window_size = 30  # Rolling模式窗口大小
    
    # 创建输出目录
    os.makedirs('plots', exist_ok=True)
    
    print(f"股票: {tickers}")
    print(f"模型: {model_names}")
    print(f"测试天数: {test_days}")
    print("=" * 70)
    
    # 下载数据
    print("\n[步骤1] 下载股票数据...")
    prices_df = download_stock_prices(tickers, start="2010-01-01", end="2020-12-31")
    
    # 结果汇总
    results_list = []
    total_tasks = len(tickers) * len(model_names)
    current_task = 0
    
    print("\n[步骤2] 生成对比图...")
    
    for ticker in tickers:
        # 截取最后252天
        prices = prices_df[ticker].tail(test_days)
        
        for model_name in model_names:
            current_task += 1
            print(f"\n[{current_task}/{total_tasks}] {ticker} - {model_name}")
            
            kernel = kernels_dict[model_name]
            
            try:
                # 运行Static Split
                print("    Running Static Split...")
                static_results = run_static_split(prices, kernel, train_size=train_size)
                
                # 运行Rolling Window
                print("    Running Rolling Window...")
                rolling_results = run_rolling_window(prices, kernel, window_size=window_size)
                
                # 绘图并保存
                save_path = f'plots/{ticker}_{model_name}_Comparison.png'
                mape1, cov1, mape2, cov2 = plot_comparison(
                    ticker, model_name, static_results, rolling_results, save_path
                )
                
                # 记录结果
                results_list.append({
                    'Ticker': ticker,
                    'Model': model_name,
                    'Static_MAPE': mape1,
                    'Static_Coverage': cov1,
                    'Rolling_MAPE': mape2,
                    'Rolling_Coverage': cov2
                })
                
                print(f"    Static:  MAPE={mape1:.2f}%, Coverage={cov1:.1%}")
                print(f"    Rolling: MAPE={mape2:.2f}%, Coverage={cov2:.1%}")
                print(f"    Saved: {save_path}")
                
            except Exception as e:
                print(f"    错误: {e}")
    
    # 汇总结果
    print("\n" + "=" * 70)
    print("实验完成！")
    print("=" * 70)
    
    results_df = pd.DataFrame(results_list)
    
    print("\n【MAPE对比汇总表】\n")
    print(results_df.to_string(index=False))
    
    # 保存CSV
    results_df.to_csv('comparison_results.csv', index=False, encoding='utf-8-sig')
    print("\n结果已保存到 comparison_results.csv")
    print(f"图片已保存到 plots/ 目录 (共{total_tasks}张)")
    
    # 按模型分组统计
    print("\n【按模型分组的平均MAPE】")
    model_summary = results_df.groupby('Model').agg({
        'Static_MAPE': 'mean',
        'Rolling_MAPE': 'mean'
    }).round(2)
    print(model_summary)
    
    return results_df


if __name__ == "__main__":
    results_df = run_comparison_experiment()
