"""
GPR滚动窗口价格预测模块
参考 Farrell 论文的实验设置
"""
import warnings
warnings.filterwarnings('ignore')

import numpy as np
import pandas as pd
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.preprocessing import StandardScaler
from tqdm import tqdm

from kernels_config import kernels_dict


def run_price_prediction_gpr(prices, kernel, window_size=30, test_days=252, n_restarts=0):
    """
    滚动窗口GPR价格预测
    
    Parameters:
        prices: 单只股票的收盘价 Series
        kernel: sklearn 核函数对象
        window_size: 训练窗口长度，默认30天
        test_days: 测试天数，默认252（最近一年）
        n_restarts: 优化器重启次数
    
    Returns:
        results_df: 包含真实价格、预测价格、置信区间的DataFrame
    """
    n = len(prices)
    
    if n < window_size + test_days:
        raise ValueError(f"数据长度({n})不足以进行测试")
    
    # 计算起始位置：只测试最后 test_days 天
    start_idx = n - test_days
    
    print(f"滚动窗口预测: 窗口={window_size}, 测试天数={test_days}")
    
    # 结果存储
    results = []
    
    for t in tqdm(range(start_idx, n), desc="GPR价格预测"):
        # 1. 取过去 window_size 天的收盘价
        input_seq = prices.iloc[t - window_size:t].values.reshape(-1, 1)
        
        # 2. 局部归一化 (关键步骤)
        scaler = StandardScaler()
        input_scaled = scaler.fit_transform(input_seq).ravel()
        
        # 3. 构建训练集 (自回归形式)
        X_train = np.arange(window_size).reshape(-1, 1)
        y_train = input_scaled
        
        # 4. 训练GPR模型
        gpr = GaussianProcessRegressor(
            kernel=kernel,
            n_restarts_optimizer=n_restarts,
            random_state=42,
            normalize_y=False  # 已手动归一化
        )
        gpr.fit(X_train, y_train)
        
        # 5. 预测下一个时间点
        X_test = np.array([[window_size]])
        y_pred_scaled, y_std_scaled = gpr.predict(X_test, return_std=True)
        
        # 6. 还原价格
        y_pred = y_pred_scaled[0] * scaler.scale_[0] + scaler.mean_[0]
        y_std = y_std_scaled[0] * scaler.scale_[0]
        
        # 真实价格
        y_true = prices.iloc[t]
        
        # 95%置信区间
        lower_bound = y_pred - 1.96 * y_std
        upper_bound = y_pred + 1.96 * y_std
        
        # 7. 保存结果
        results.append({
            'Date': prices.index[t],
            'True_Price': y_true,
            'Pred_Price': y_pred,
            'Pred_Std': y_std,
            'Lower_Bound': lower_bound,
            'Upper_Bound': upper_bound
        })
    
    results_df = pd.DataFrame(results)
    results_df.set_index('Date', inplace=True)
    
    return results_df


def test_single_stock():
    """
    测试单只股票的GPR价格预测
    """
    from data_loader import download_stock_prices
    
    print("=" * 60)
    print("测试GPR价格预测")
    print("=" * 60)
    
    # 下载MSFT数据
    tickers = ['MSFT']
    prices_df = download_stock_prices(tickers, start="2010-01-01", end="2020-12-31")
    msft_prices = prices_df['MSFT']
    
    # 使用RBF核进行测试（只测试50天以加快速度）
    print("\n运行GPR预测...")
    kernel = kernels_dict['Model_A_RBF']
    results = run_price_prediction_gpr(
        prices=msft_prices,
        kernel=kernel,
        window_size=30,
        test_days=50,  # 快速测试
        n_restarts=0
    )
    
    print("\n预测结果:")
    print(results.head(10))
    
    # 计算评估指标
    mse = ((results['True_Price'] - results['Pred_Price']) ** 2).mean()
    rmse = np.sqrt(mse)
    mae = (results['True_Price'] - results['Pred_Price']).abs().mean()
    mape = ((results['True_Price'] - results['Pred_Price']).abs() / results['True_Price']).mean() * 100
    
    print(f"\n评估指标:")
    print(f"  RMSE: ${rmse:.4f}")
    print(f"  MAE: ${mae:.4f}")
    print(f"  MAPE: {mape:.2f}%")
    
    # 检查置信区间覆盖率
    coverage = ((results['True_Price'] >= results['Lower_Bound']) & 
                (results['True_Price'] <= results['Upper_Bound'])).mean()
    print(f"  95%置信区间覆盖率: {coverage:.2%}")
    
    return results


if __name__ == "__main__":
    results = test_single_stock()
