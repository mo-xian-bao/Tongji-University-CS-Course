import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import r2_score, mean_squared_error
import seaborn as sns

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 读取Excel文件
try:
    df = pd.read_excel(r"D:\desktop\CUMCM25C\代码\问题一数据.xlsx")
    print("成功读取Excel文件")
except FileNotFoundError:
    print("错误：找不到文件 问题一数据.xlsx，请确保文件在当前目录下")
    exit()
except Exception as e:
    print(f"读取Excel文件时出错：{e}")
    exit()

print("数据概览:")
print(df.head())
print(f"\n数据形状: {df.shape}")
print(f"\n数据列名: {df.columns.tolist()}")
print(f"\n数据统计信息:")
print(df.describe())

# 检查数据列名，自动识别列名
column_mapping = {}
for col in df.columns:
    col_lower = col.lower()
    if '年龄' in col or 'age' in col_lower:
        column_mapping['年龄'] = col
    elif '孕周' in col or 'week' in col_lower or '检测' in col:
        column_mapping['孕周'] = col
    elif 'bmi' in col_lower or 'BMI' in col:
        column_mapping['BMI'] = col
    elif 'y染色体' in col or 'Y染色体' in col or 'y' in col_lower and '染色体' in col:
        column_mapping['Y染色体'] = col

print(f"\n识别的列名映射: {column_mapping}")

# 确保必要的列都被识别
required_cols = ['年龄', '孕周', 'BMI', 'Y染色体']
missing_cols = [col for col in required_cols if col not in column_mapping]

if missing_cols:
    print(f"警告：未能识别以下列: {missing_cols}")
    print("请检查Excel文件的列名，或手动指定列名")
    # 如果无法自动识别，让用户知道当前的列名
    print(f"Excel文件中的列名: {df.columns.tolist()}")
    exit()
else:
    print("所有必要的列都已成功识别")

# 定义多项式回归函数
def polynomial_regression_analysis(x, y, x_name, degree_range=(1, 5)):
    """
    对给定的x和y进行多项式回归分析
    """
    results = {}
    
    for degree in range(degree_range[0], degree_range[1] + 1):
        # 创建多项式特征
        poly_features = PolynomialFeatures(degree=degree)
        X_poly = poly_features.fit_transform(x.values.reshape(-1, 1))
        
        # 拟合模型
        model = LinearRegression()
        model.fit(X_poly, y)
        
        # 预测
        y_pred = model.predict(X_poly)
        
        # 计算评估指标
        r2 = r2_score(y, y_pred)
        mse = mean_squared_error(y, y_pred)
        
        results[degree] = {
            'model': model,
            'poly_features': poly_features,
            'r2': r2,
            'mse': mse,
            'y_pred': y_pred
        }
    
    return results

# 分别对三个自变量进行多项式回归分析
variables = ['年龄', '孕周', 'BMI']
y = df[column_mapping['Y染色体']]

# 存储所有结果
all_results = {}

for var in variables:
    x = df[column_mapping[var]]
    results = polynomial_regression_analysis(x, y, var)
    all_results[var] = results
    
    print(f"\n{var}的多项式回归结果:")
    for degree, result in results.items():
        print(f"  {degree}次多项式: R² = {result['r2']:.4f}, MSE = {result['mse']:.6f}")

# 可视化函数
def plot_polynomial_regression(x, y, results, x_name, best_degree=None):
    """
    绘制多项式回归结果
    """
    if best_degree is None:
        # 选择R²最高的模型
        best_degree = max(results.keys(), key=lambda k: results[k]['r2'])
    
    # 创建图形
    plt.figure(figsize=(15, 10))
    
    # 子图1: 原始数据和不同次数的拟合曲线
    plt.subplot(2, 2, 1)
    plt.scatter(x, y, alpha=0.7, color='blue', label='原始数据')
    
    # 生成平滑的预测曲线
    x_smooth = np.linspace(x.min(), x.max(), 100)
    colors = ['red', 'green', 'orange', 'purple', 'brown']
    
    for i, (degree, result) in enumerate(results.items()):
        if i < len(colors):
            X_smooth = result['poly_features'].transform(x_smooth.reshape(-1, 1))
            y_smooth = result['model'].predict(X_smooth)
            plt.plot(x_smooth, y_smooth, color=colors[i], 
                    label=f'{degree}次多项式 (R²={result["r2"]:.3f})')
    
    plt.xlabel(x_name)
    plt.ylabel('Y染色体浓度')
    plt.title(f'{x_name}与Y染色体浓度的多项式回归')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 子图2: 最佳模型的残差图
    plt.subplot(2, 2, 2)
    best_result = results[best_degree]
    residuals = y - best_result['y_pred']
    plt.scatter(best_result['y_pred'], residuals, alpha=0.7)
    plt.axhline(y=0, color='red', linestyle='--')
    plt.xlabel('预测值')
    plt.ylabel('残差')
    plt.title(f'最佳模型残差图 ({best_degree}次多项式)')
    plt.grid(True, alpha=0.3)
    
    # 子图3: R²和MSE随多项式次数的变化
    plt.subplot(2, 2, 3)
    degrees = list(results.keys())
    r2_values = [results[d]['r2'] for d in degrees]
    mse_values = [results[d]['mse'] for d in degrees]
    
    ax1 = plt.gca()
    ax1.plot(degrees, r2_values, 'bo-', label='R²', color='blue')
    ax1.set_xlabel('多项式次数')
    ax1.set_ylabel('R²', color='blue')
    ax1.tick_params(axis='y', labelcolor='blue')
    
    ax2 = ax1.twinx()
    ax2.plot(degrees, mse_values, 'ro-', label='MSE', color='red')
    ax2.set_ylabel('MSE', color='red')
    ax2.tick_params(axis='y', labelcolor='red')
    
    plt.title('模型性能随多项式次数变化')
    plt.grid(True, alpha=0.3)
    
    # 子图4: 预测值vs实际值
    plt.subplot(2, 2, 4)
    plt.scatter(y, best_result['y_pred'], alpha=0.7)
    plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--', label='完美预测线')
    plt.xlabel('实际值')
    plt.ylabel('预测值')
    plt.title(f'预测值vs实际值 ({best_degree}次多项式)')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.show()
    
    return best_degree

# 为每个变量绘制图形
print("\n开始可视化分析...")
for var in variables:
    print(f"\n正在绘制{var}的多项式回归图...")
    best_deg = plot_polynomial_regression(df[column_mapping[var]], y, all_results[var], var)
    print(f"{var}的最佳多项式次数: {best_deg}")

# 生成综合比较图
def plot_comparison(df, all_results):
    """
    绘制三个变量的比较图
    """
    fig, axes = plt.subplots(2, 3, figsize=(18, 12))
    
    variables = ['年龄', '孕周', 'BMI']
    colors = ['blue', 'green', 'red']
    
    for i, var in enumerate(variables):
        x = df[column_mapping[var]]
        y = df[column_mapping['Y染色体']]
        results = all_results[var]
        
        # 选择最佳次数（R²最高）
        best_degree = max(results.keys(), key=lambda k: results[k]['r2'])
        best_result = results[best_degree]
        
        # 上排：散点图和拟合曲线
        axes[0, i].scatter(x, y, alpha=0.7, color=colors[i], label='原始数据')
        
        # 生成平滑的预测曲线
        x_smooth = np.linspace(x.min(), x.max(), 100)
        X_smooth = best_result['poly_features'].transform(x_smooth.reshape(-1, 1))
        y_smooth = best_result['model'].predict(X_smooth)
        axes[0, i].plot(x_smooth, y_smooth, color='red', linewidth=2,
                       label=f'{best_degree}次多项式\nR²={best_result["r2"]:.3f}')
        
        axes[0, i].set_xlabel(var)
        axes[0, i].set_ylabel('Y染色体浓度')
        axes[0, i].set_title(f'{var}与Y染色体浓度关系')
        axes[0, i].legend()
        axes[0, i].grid(True, alpha=0.3)
        
        # 下排：R²比较
        degrees = list(results.keys())
        r2_values = [results[d]['r2'] for d in degrees]
        axes[1, i].plot(degrees, r2_values, 'o-', color=colors[i], linewidth=2, markersize=8)
        axes[1, i].set_xlabel('多项式次数')
        axes[1, i].set_ylabel('R²')
        axes[1, i].set_title(f'{var}的R²随多项式次数变化')
        axes[1, i].grid(True, alpha=0.3)
        axes[1, i].set_ylim(0, 1)
    
    plt.tight_layout()
    plt.show()

# 生成综合报告
def generate_report(all_results):
    """
    生成分析报告
    """
    print("\n" + "="*80)
    print("多项式回归分析报告")
    print("="*80)
    
    variables = ['年龄', '孕周', 'BMI']
    
    for var in variables:
        results = all_results[var]
        best_degree = max(results.keys(), key=lambda k: results[k]['r2'])
        best_result = results[best_degree]
        
        print(f"\n{var}:")
        print(f"  最佳多项式次数: {best_degree}")
        print(f"  最高R²: {best_result['r2']:.4f}")
        print(f"  对应MSE: {best_result['mse']:.6f}")
        
        # 计算各次数模型的性能
        print(f"  各次数多项式性能:")
        for degree in sorted(results.keys()):
            r2 = results[degree]['r2']
            mse = results[degree]['mse']
            print(f"    {degree}次: R²={r2:.4f}, MSE={mse:.6f}")
    
    # 找出总体最佳变量
    best_var = None
    best_r2 = 0
    for var in variables:
        results = all_results[var]
        max_r2 = max(result['r2'] for result in results.values())
        if max_r2 > best_r2:
            best_r2 = max_r2
            best_var = var
    
    print(f"\n总结:")
    print(f"  最佳预测变量: {best_var}")
    print(f"  最高R²: {best_r2:.4f}")
    print(f"  这表明{best_var}对Y染色体浓度的预测能力最强")

# 执行综合分析
print("\n生成综合比较图...")
plot_comparison(df, all_results)

print("\n生成分析报告...")
generate_report(all_results)

# 保存最佳模型的预测结果
def save_predictions(df, all_results):
    """
    保存所有模型的预测结果
    """
    predictions_df = df.copy()
    
    for var in ['年龄', '孕周', 'BMI']:
        results = all_results[var]
        best_degree = max(results.keys(), key=lambda k: results[k]['r2'])
        best_result = results[best_degree]
        
        predictions_df[f'{var}_预测值'] = best_result['y_pred']
        predictions_df[f'{var}_残差'] = df[column_mapping['Y染色体']] - best_result['y_pred']
    
    return predictions_df

predictions_result = save_predictions(df, all_results)
print("\n预测结果预览:")
y_col = column_mapping['Y染色体']
print(predictions_result[[y_col, '年龄_预测值', '年龄_残差', 
                         '孕周_预测值', '孕周_残差', 
                         'BMI_预测值', 'BMI_残差']].head())

print("\n分析完成！")


