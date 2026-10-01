"""
GPR批量实验脚本 - 对所有股票和核函数进行批量运行
"""
import warnings
warnings.filterwarnings('ignore')

import numpy as np
import pandas as pd

from data_loader import download_stock_prices
from kernels_config import kernels_dict
from gpr_price_prediction import run_price_prediction_gpr


def evaluate_predictions(results_df):
    """
    计算预测评估指标
    
    Parameters:
        results_df: 预测结果DataFrame
    
    Returns:
        metrics: 指标字典
    """
    y_true = results_df['True_Price'].values
    y_pred = results_df['Pred_Price'].values
    lower = results_df['Lower_Bound'].values
    upper = results_df['Upper_Bound'].values
    
    # RMSE
    rmse = np.sqrt(((y_true - y_pred) ** 2).mean())
    
    # MAE
    mae = np.abs(y_true - y_pred).mean()
    
    # MAPE (%)
    mape = (np.abs(y_true - y_pred) / y_true).mean() * 100
    
    # 95%置信区间覆盖率
    coverage = ((y_true >= lower) & (y_true <= upper)).mean()
    
    return {
        'RMSE': rmse,
        'MAE': mae,
        'MAPE': mape,
        'Coverage': coverage
    }


def run_batch_experiment():
    """
    批量运行所有股票和核函数的GPR预测实验
    """
    # 配置参数 (对应实验报告4.4节)
    tickers = ['MSFT', 'ORCL', 'SBUX', 'EA', 'ADBE']
    kernel_names = ['Model_A_RBF', 'Model_B_Matern', 'Model_C_Structural', 'Model_D_QuasiPeriodic']
    window_size = 30
    test_days = 252  # 最近一年
    
    print("=" * 70)
    print("GPR股票价格预测批量实验 (实验报告4.4节)")
    print("=" * 70)
    print(f"股票列表: {tickers}")
    print(f"核函数 (4个模型): {kernel_names}")
    print(f"窗口大小: {window_size}")
    print(f"测试天数: {test_days}")
    print("=" * 70)
    
    # 1. 下载所有股票数据
    print("\n[步骤1] 下载股票数据...")
    prices_df = download_stock_prices(tickers, start="2010-01-01", end="2020-12-31")
    
    # 2. 批量运行实验
    print("\n[步骤2] 批量运行GPR预测...")
    results_list = []
    total_tasks = len(tickers) * len(kernel_names)
    current_task = 0
    
    for ticker in tickers:
        prices = prices_df[ticker]
        
        for kernel_name in kernel_names:
            current_task += 1
            print(f"\n[{current_task}/{total_tasks}] {ticker} - {kernel_name}")
            
            kernel = kernels_dict[kernel_name]
            
            try:
                # 运行GPR预测
                pred_results = run_price_prediction_gpr(
                    prices=prices,
                    kernel=kernel,
                    window_size=window_size,
                    test_days=test_days,
                    n_restarts=0
                )
                
                # 计算评估指标
                metrics = evaluate_predictions(pred_results)
                
                # 记录结果
                result_row = {
                    'Ticker': ticker,
                    'Kernel': kernel_name,
                    'RMSE': metrics['RMSE'],
                    'MAE': metrics['MAE'],
                    'MAPE': metrics['MAPE'],
                    'Coverage': metrics['Coverage']
                }
                results_list.append(result_row)
                
                print(f"    RMSE: ${metrics['RMSE']:.4f}")
                print(f"    MAE: ${metrics['MAE']:.4f}")
                print(f"    MAPE: {metrics['MAPE']:.2f}%")
                print(f"    Coverage: {metrics['Coverage']:.2%}")
                
            except Exception as e:
                print(f"    错误: {e}")
                results_list.append({
                    'Ticker': ticker,
                    'Kernel': kernel_name,
                    'RMSE': np.nan,
                    'MAE': np.nan,
                    'MAPE': np.nan,
                    'Coverage': np.nan
                })
    
    # 3. 汇总结果
    print("\n" + "=" * 70)
    print("批量实验完成！")
    print("=" * 70)
    
    results_df = pd.DataFrame(results_list)
    
    # 格式化输出
    print("\n【最终结果汇总表】\n")
    print(results_df.to_string(index=False))
    
    # 保存到CSV
    results_df.to_csv('gpr_final_results.csv', index=False, encoding='utf-8-sig')
    print("\n结果已保存到 gpr_final_results.csv")
    
    # 按核函数分组统计
    print("\n【按核函数分组的平均指标】")
    kernel_summary = results_df.groupby('Kernel').agg({
        'RMSE': 'mean',
        'MAE': 'mean',
        'MAPE': 'mean',
        'Coverage': 'mean'
    }).round(4)
    print(kernel_summary)
    
    # 按股票分组统计
    print("\n【按股票分组的平均指标】")
    ticker_summary = results_df.groupby('Ticker').agg({
        'RMSE': 'mean',
        'MAE': 'mean',
        'MAPE': 'mean',
        'Coverage': 'mean'
    }).round(4)
    print(ticker_summary)
    
    return results_df


if __name__ == "__main__":
    results_df = run_batch_experiment()
