"""
全样本回测（Full Sample Backtest）- 10年完整回测
验证模型的长期稳定性
"""
import warnings
warnings.filterwarnings('ignore')

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.preprocessing import StandardScaler
from tqdm import tqdm

from data_loader import download_stock_prices
from kernels_config import kernels_dict

plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'Arial Unicode MS']
plt.rcParams['axes.unicode_minus'] = False


def run_full_backtest(prices, kernel, window_size=30, n_restarts=0):
    """
    全样本回测：从第window_size天开始，一直跑到最后一天
    
    Parameters:
        prices: 收盘价 Series
        kernel: sklearn 核函数对象
        window_size: 训练窗口长度
        n_restarts: 优化器重启次数
    
    Returns:
        results_df: 预测结果DataFrame
    """
    n = len(prices)
    total_predictions = n - window_size
    
    print(f"全样本回测: 窗口={window_size}, 预测天数={total_predictions}")
    
    results = []
    
    # 关键：从第window_size天开始，一直跑到最后一天
    for i in tqdm(range(window_size, n), desc="10年回测"):
        # 取过去 window_size 天的收盘价
        input_seq = prices.iloc[i - window_size:i].values.reshape(-1, 1)
        
        # 局部归一化
        scaler = StandardScaler()
        input_scaled = scaler.fit_transform(input_seq).ravel()
        
        # 构建训练集
        X_train = np.arange(window_size).reshape(-1, 1)
        y_train = input_scaled
        
        # 训练GPR
        gpr = GaussianProcessRegressor(
            kernel=kernel,
            n_restarts_optimizer=n_restarts,
            random_state=42,
            normalize_y=False
        )
        gpr.fit(X_train, y_train)
        
        # 预测
        X_test = np.array([[window_size]])
        y_pred_scaled, y_std_scaled = gpr.predict(X_test, return_std=True)
        
        # 还原价格
        y_pred = y_pred_scaled[0] * scaler.scale_[0] + scaler.mean_[0]
        y_std = y_std_scaled[0] * scaler.scale_[0]
        y_true = prices.iloc[i]
        
        results.append({
            'Date': prices.index[i],
            'True_Price': y_true,
            'Pred_Price': y_pred,
            'Pred_Std': y_std,
            'Lower_Bound': y_pred - 1.96 * y_std,
            'Upper_Bound': y_pred + 1.96 * y_std
        })
    
    results_df = pd.DataFrame(results)
    results_df.set_index('Date', inplace=True)
    
    return results_df


def evaluate_predictions(results_df):
    """计算评估指标"""
    y_true = results_df['True_Price'].values
    y_pred = results_df['Pred_Price'].values
    lower = results_df['Lower_Bound'].values
    upper = results_df['Upper_Bound'].values
    
    rmse = np.sqrt(((y_true - y_pred) ** 2).mean())
    mae = np.abs(y_true - y_pred).mean()
    mape = (np.abs(y_true - y_pred) / y_true).mean() * 100
    coverage = ((y_true >= lower) & (y_true <= upper)).mean()
    
    return {'RMSE': rmse, 'MAE': mae, 'MAPE': mape, 'Coverage': coverage}


def plot_10year_prediction(results_df, ticker, kernel_name, save_path=None):
    """
    绘制10年预测全景图
    """
    fig, ax = plt.subplots(figsize=(16, 8))
    
    dates = results_df.index
    y_true = results_df['True_Price']
    y_pred = results_df['Pred_Price']
    lower = results_df['Lower_Bound']
    upper = results_df['Upper_Bound']
    
    # 真实价格
    ax.plot(dates, y_true, 'b-', linewidth=0.5, label='真实价格', alpha=0.8)
    
    # 预测价格
    ax.plot(dates, y_pred, 'r-', linewidth=0.5, label='预测价格', alpha=0.8)
    
    # 95%置信区间
    ax.fill_between(dates, lower, upper, alpha=0.2, color='red', label='95%置信区间')
    
    # 计算指标
    metrics = evaluate_predictions(results_df)
    
    ax.set_title(f'{ticker} 10年全样本回测 ({kernel_name})\n'
                 f'MAPE: {metrics["MAPE"]:.2f}%, RMSE: ${metrics["RMSE"]:.2f}, '
                 f'Coverage: {metrics["Coverage"]:.1%}', fontsize=14)
    ax.set_xlabel('日期', fontsize=12)
    ax.set_ylabel('价格 (USD)', fontsize=12)
    ax.legend(loc='upper left', fontsize=10)
    ax.grid(True, alpha=0.3)
    
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches='tight')
        print(f"图片已保存: {save_path}")
    
    plt.show()


def run_10year_backtest():
    """
    运行10年全样本回测
    """
    print("=" * 70)
    print("全样本回测（Full Sample Backtest）- 10年完整回测")
    print("=" * 70)
    
    # 配置参数
    # 如果只想跑MSFT，将下面这行改为: tickers = ['MSFT']
    tickers = ['MSFT']
    kernel_names = ['Model_C_Structural']
    window_size = 30
    n_restarts = 0  # 加快速度
    
    print(f"股票列表: {tickers}")
    print(f"模型: {kernel_names}")
    print(f"窗口大小: {window_size}")
    print(f"优化器重启: {n_restarts} (快速模式)")
    print("=" * 70)
    
    # 1. 下载数据
    print("\n[步骤1] 下载股票数据...")
    prices_df = download_stock_prices(tickers, start="2010-01-01", end="2020-12-31")
    
    # 2. 批量运行回测
    print("\n[步骤2] 运行10年全样本回测...")
    results_list = []
    total_tasks = len(tickers) * len(kernel_names)
    current_task = 0
    
    # 保存MSFT Model_C的结果用于绘图
    msft_model_c_results = None
    
    for ticker in tickers:
        prices = prices_df[ticker]
        
        for kernel_name in kernel_names:
            current_task += 1
            print(f"\n[{current_task}/{total_tasks}] {ticker} - {kernel_name}")
            
            kernel = kernels_dict[kernel_name]
            
            try:
                # 运行全样本回测
                pred_results = run_full_backtest(
                    prices=prices,
                    kernel=kernel,
                    window_size=window_size,
                    n_restarts=n_restarts
                )
                
                # 保存MSFT Model_C结果
                if ticker == 'MSFT' and kernel_name == 'Model_C_Structural':
                    msft_model_c_results = pred_results.copy()
                
                # 计算评估指标
                metrics = evaluate_predictions(pred_results)
                
                result_row = {
                    'Ticker': ticker,
                    'Kernel': kernel_name,
                    'Predictions': len(pred_results),
                    'RMSE': metrics['RMSE'],
                    'MAE': metrics['MAE'],
                    'MAPE': metrics['MAPE'],
                    'Coverage': metrics['Coverage']
                }
                results_list.append(result_row)
                
                print(f"    预测天数: {len(pred_results)}")
                print(f"    RMSE: ${metrics['RMSE']:.4f}")
                print(f"    MAPE: {metrics['MAPE']:.2f}%")
                print(f"    Coverage: {metrics['Coverage']:.2%}")
                
            except Exception as e:
                print(f"    错误: {e}")
                results_list.append({
                    'Ticker': ticker,
                    'Kernel': kernel_name,
                    'Predictions': 0,
                    'RMSE': np.nan,
                    'MAE': np.nan,
                    'MAPE': np.nan,
                    'Coverage': np.nan
                })
    
    # 3. 汇总结果
    print("\n" + "=" * 70)
    print("10年全样本回测完成！")
    print("=" * 70)
    
    results_df = pd.DataFrame(results_list)
    
    print("\n【最终结果汇总表】\n")
    print(results_df.to_string(index=False))
    
    # 保存CSV
    results_df.to_csv('10year_backtest_results.csv', index=False, encoding='utf-8-sig')
    print("\n结果已保存到 10year_backtest_results.csv")
    
    # 按核函数分组统计
    print("\n【按核函数分组的平均指标】")
    kernel_summary = results_df.groupby('Kernel').agg({
        'RMSE': 'mean',
        'MAE': 'mean',
        'MAPE': 'mean',
        'Coverage': 'mean'
    }).round(4)
    print(kernel_summary)
    
    # 4. 绘制MSFT Model_C的10年预测图
    if msft_model_c_results is not None:
        print("\n[步骤3] 绘制MSFT 10年预测全景图...")
        plot_10year_prediction(
            msft_model_c_results,
            'MSFT',
            'Model_C_Structural',
            save_path='MSFT_10year_prediction.png'
        )
    
    return results_df


if __name__ == "__main__":
    results_df = run_10year_backtest()
