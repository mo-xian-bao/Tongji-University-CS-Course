import numpy as np
import pandas as pd
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import matplotlib.pyplot as plt
import seaborn as sns  # 确保已经导入 seaborn

# 读取数据
data = pd.read_csv('encoded_taxi_trip_pricing.csv')

# 将布尔列转换为0和1
bool_columns = ['Time_of_Day_Afternoon', 'Time_of_Day_Evening', 'Time_of_Day_Morning', 
               'Time_of_Day_Night', 'Day_of_Week_Weekday', 'Day_of_Week_Weekend',
               'Traffic_Conditions_High', 'Traffic_Conditions_Low', 'Traffic_Conditions_Medium',
               'Weather_Clear', 'Weather_Rain', 'Weather_Snow']

for col in bool_columns:
    data[col] = data[col].astype(int)

# 分离特征和目标变量
X = data.drop('Trip_Price', axis=1)
y = data['Trip_Price']

# 数据标准化
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 手动定义Ridge回归损失函数
def ridge_loss(w, X, y, alpha):
    """
    Ridge回归损失函数
    w: 权重向量 (包括偏置项)
    X: 特征矩阵
    y: 目标变量
    alpha: 正则化参数
    """
    n = len(y)
    predictions = X.dot(w)
    mse_loss = np.sum((predictions - y) ** 2) / (2 * n)
    regularization = (alpha / 2) * np.sum(w[1:] ** 2)  # 不对偏置项进行正则化
    return mse_loss + regularization

# 手动定义梯度计算
def ridge_gradient(w, X, y, alpha):
    """
    Ridge回归梯度计算
    """
    n = len(y)
    predictions = X.dot(w)
    error = predictions - y
    
    # 计算梯度
    gradient = X.T.dot(error) / n
    # 添加正则化项梯度 (不对偏置项正则化)
    gradient[1:] += alpha * w[1:] / n
    
    return gradient

# 梯度下降优化
def gradient_descent(X, y, alpha, learning_rate=0.01, max_iter=1000, tol=1e-6):
    """
    使用梯度下降优化Ridge回归
    """
    n_samples, n_features = X.shape
    # 添加偏置项
    X_with_bias = np.column_stack([np.ones(n_samples), X])
    
    # 初始化权重
    w = np.zeros(n_features + 1)
    
    losses = []
    
    for i in range(max_iter):
        # 计算梯度
        grad = ridge_gradient(w, X_with_bias, y, alpha)
        
        # 更新权重
        w_new = w - learning_rate * grad
        
        # 计算损失
        current_loss = ridge_loss(w, X_with_bias, y, alpha)
        losses.append(current_loss)
        
        # 检查收敛
        if np.linalg.norm(w_new - w) < tol:
            print(f"收敛于第 {i+1} 次迭代")
            break
            
        w = w_new
        
        if i % 100 == 0:
            print(f"迭代 {i}, 损失: {current_loss:.6f}")
    
    return w, losses

# K折交叉验证进行参数选择
def kfold_ridge_cv(X, y, alphas, k=5):
    """
    K折交叉验证选择最佳alpha参数
    """
    kf = KFold(n_splits=k, shuffle=True, random_state=42)
    results = {}
    
    for alpha in alphas:
        mse_scores = []
        mae_scores = []
        
        for train_idx, val_idx in kf.split(X):
            X_train, X_val = X[train_idx], X[val_idx]
            y_train, y_val = y[train_idx], y[val_idx]
            
            # 训练模型
            w, _ = gradient_descent(X_train, y_train, alpha, learning_rate=0.01, max_iter=1000)
            
            # 预测
            X_val_with_bias = np.column_stack([np.ones(len(X_val)), X_val])
            y_pred = X_val_with_bias.dot(w)
            
            # 计算指标
            mse = mean_squared_error(y_val, y_pred)
            mae = mean_absolute_error(y_val, y_pred)
            
            mse_scores.append(mse)
            mae_scores.append(mae)
        
        results[alpha] = {
            'mean_mse': np.mean(mse_scores),
            'std_mse': np.std(mse_scores),
            'mean_mae': np.mean(mae_scores),
            'std_mae': np.std(mae_scores)
        }
        
        print(f"Alpha: {alpha:.4f}, MSE: {np.mean(mse_scores):.4f} ± {np.std(mse_scores):.4f}, "
              f"MAE: {np.mean(mae_scores):.4f} ± {np.std(mae_scores):.4f}")
    
    return results

# 在独立测试集上评估模型
def evaluate_on_test_set(X_train, X_test, y_train, y_test, best_alpha):
    """
    在测试集上评估最终模型
    """
    # 训练最终模型
    w_final, losses = gradient_descent(X_train, y_train, best_alpha, 
                                    learning_rate=0.01, max_iter=1000)
    
    # 在测试集上预测
    X_test_with_bias = np.column_stack([np.ones(len(X_test)), X_test])
    y_pred = X_test_with_bias.dot(w_final)
    
    # 计算性能指标
    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    print(f"\n最终模型在测试集上的性能:")
    print(f"MSE: {mse:.4f}")
    print(f"MAE: {mae:.4f}")
    print(f"R²: {r2:.4f}")
    
    return y_pred, w_final, losses

# 主执行流程
def main():
    # 设置随机种子以确保可重复性
    np.random.seed(42)
    
    # 划分训练集和测试集 (80% 训练, 20% 测试)
    n_samples = len(X_scaled)
    n_train = int(0.8 * n_samples)
    
    indices = np.random.permutation(n_samples)
    train_idx, test_idx = indices[:n_train], indices[n_train:]
    
    X_train, X_test = X_scaled[train_idx], X_scaled[test_idx]
    y_train, y_test = y.values[train_idx], y.values[test_idx]
    
    print(f"训练集大小: {X_train.shape}")
    print(f"测试集大小: {X_test.shape}")
    
    # 定义要测试的alpha值范围
    alphas = [0.001, 0.01, 0.1, 1, 10, 100, 1000]
    
    print("开始K折交叉验证...")
    cv_results = kfold_ridge_cv(X_train, y_train, alphas, k=5)
    
    # 选择最佳alpha (基于最小MSE)
    best_alpha = min(cv_results.keys(), key=lambda x: cv_results[x]['mean_mse'])
    print(f"\n最佳alpha值: {best_alpha}")
    
    # 在测试集上评估最佳模型
    y_pred, final_weights, training_losses = evaluate_on_test_set(X_train, X_test, y_train, y_test, best_alpha)
    
    # 可视化 1: 特征重要性 
    feature_names = X.columns.tolist()
    coefficients = final_weights[1:]  # 排除偏置项
    
    importance_df = pd.DataFrame({
        'Feature': feature_names,
        'Coefficient': coefficients,
    }).sort_values('Coefficient', ascending=False)

    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False

    plt.figure(figsize=(12, 8))
    sns.barplot(x='Coefficient', y='Feature', data=importance_df, hue='Feature', palette='viridis', legend=False)
    plt.title('模型特征重要性 (系数)', fontsize=16)
    plt.xlabel('系数大小', fontsize=14)
    plt.ylabel('特征', fontsize=14)
    plt.yticks(fontsize=12) 
    plt.xticks(fontsize=12) 
    plt.grid(axis='x', linestyle='--', alpha=0.7)
    plt.tight_layout() # 调整布局以防止标签重叠
    plt.savefig('Ridge_feature_importance.png',dpi=600)

    # 可视化 2: 实际值 vs. 预测值
    plt.figure(figsize=(10, 6))
    plt.scatter(y_test, y_pred, alpha=0.6, edgecolors='w',color="#03b903")
    plt.plot([y.min(), y.max()], [y.min(), y.max()], "#54bfe9", lw=2, linestyle='--') # 添加 y=x 参考线
    plt.title('实际值 vs. 预测值', fontsize=16)
    plt.xlabel('实际价格 (Actual Price)', fontsize=12)
    plt.ylabel('预测价格 (Predicted Price)', fontsize=12)

    plt.grid(True)
    plt.tight_layout()
    plt.savefig('Ridge_actual_vs_predicted.png',dpi=600)

    # 可视化 3: 残差图
    residuals = y_test - y_pred

    plt.figure(figsize=(10, 6))
    plt.scatter(y_pred, residuals, alpha=0.6, edgecolors='w',color="#f06e23")
    plt.axhline(y=0, color="#0495a8", linestyle='--', lw=2) # 添加 y=0 参考线
    plt.title('残差图 (Residuals Plot)', fontsize=16)
    plt.xlabel('预测价格 (Predicted Price)', fontsize=12)
    plt.ylabel('残差 (Residuals)', fontsize=12)
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('Ridge_residuals_plot.png',dpi=600)

if __name__ == "__main__":
    main()