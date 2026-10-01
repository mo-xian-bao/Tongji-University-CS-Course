"""
数据加载与预处理模块 - 直接预测收盘价
"""
import warnings
warnings.filterwarnings('ignore')

import numpy as np
import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt

plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'Arial Unicode MS']
plt.rcParams['axes.unicode_minus'] = False


def download_stock_prices(tickers, start="2010-01-01", end="2020-12-31"):
    """
    下载股票收盘价数据
    
    Parameters:
        tickers: 股票代码列表
        start: 开始日期
        end: 结束日期
    
    Returns:
        prices_df: DataFrame，列为股票代码，值为收盘价
    """
    print("=" * 60)
    print("下载股票收盘价数据")
    print("=" * 60)
    
    all_prices = {}
    
    for ticker in tickers:
        print(f"正在下载 {ticker}...")
        try:
            data = yf.download(ticker, start=start, end=end, progress=False)
            
            # 处理多级列索引
            if isinstance(data.columns, pd.MultiIndex):
                data.columns = data.columns.get_level_values(0)
            
            # 只保留收盘价
            close_prices = data['Close'].dropna()
            all_prices[ticker] = close_prices
            print(f"  {ticker}: {len(close_prices)} 条记录")
            print(f"  价格范围: ${close_prices.min():.2f} - ${close_prices.max():.2f}")
            
        except Exception as e:
            print(f"  下载 {ticker} 失败: {e}")
    
    # 合并为DataFrame
    prices_df = pd.DataFrame(all_prices)
    prices_df = prices_df.dropna()
    
    print(f"\n合并后数据: {len(prices_df)} 条记录")
    print(f"时间范围: {prices_df.index[0]} 至 {prices_df.index[-1]}")
    
    return prices_df


def plot_stock_prices(prices_df, save_path="stock_prices.png"):
    """
    绘制5只股票的收盘价走势图
    """
    fig, axes = plt.subplots(2, 3, figsize=(15, 10))
    axes = axes.ravel()
    
    colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']
    
    for idx, (ticker, color) in enumerate(zip(prices_df.columns, colors)):
        ax = axes[idx]
        prices = prices_df[ticker]
        
        ax.plot(prices.index, prices.values, color=color, linewidth=1)
        ax.set_title(f'{ticker} 收盘价走势', fontsize=12)
        ax.set_xlabel('日期')
        ax.set_ylabel('价格 (USD)')
        ax.grid(True, alpha=0.3)
        
        # 添加统计信息
        stats_text = f'均值: ${prices.mean():.2f}\n最高: ${prices.max():.2f}\n最低: ${prices.min():.2f}'
        ax.text(0.02, 0.98, stats_text, transform=ax.transAxes, fontsize=9,
                verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    # 隐藏第6个子图
    axes[5].axis('off')
    
    plt.tight_layout()
    plt.savefig(save_path, dpi=150, bbox_inches='tight')
    plt.show()
    print(f"图片已保存: {save_path}")


if __name__ == "__main__":
    # 下载数据
    tickers = ['MSFT', 'ORCL', 'SBUX', 'EA', 'ADBE']
    prices_df = download_stock_prices(tickers, start="2010-01-01", end="2020-12-31")
    
    # 绘制走势图
    plot_stock_prices(prices_df)
    
    # 保存数据
    prices_df.to_csv("stock_prices.csv")
    print("\n数据已保存: stock_prices.csv")
