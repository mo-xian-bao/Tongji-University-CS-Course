import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

plt.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "Arial Unicode MS"]
plt.rcParams["axes.unicode_minus"] = False

class LassoRegression:
    """使用次梯度方法实现 Lasso 回归"""

    def __init__(self, alpha: float = 0.1, learning_rate: float = 0.01, max_iter: int = 1000, tol: float = 1e-5, random_state: int | None = None):
        if alpha < 0:
            raise ValueError("正则化强度 alpha 必须为非负数")
        self.alpha = alpha
        self.learning_rate = learning_rate
        self.max_iter = max_iter
        self.tol = tol
        self.random_state = random_state
        self.weights_: np.ndarray | None = None
        self.bias_: float | None = None
        self.loss_history_: list[float] = []

    def _compute_loss(self, X: np.ndarray, y: np.ndarray) -> float:
        """计算 Lasso 损失函数的值"""
        n_samples = X.shape[0]
        predictions = self.predict(X)
        residual = y - predictions
        # 均方误差项
        mse_term = (0.5 / n_samples) * np.dot(residual, residual)
        # L1 正则项
        l1_term = self.alpha * np.sum(np.abs(self.weights_))
        return mse_term + l1_term

    def fit(self, X: np.ndarray, y: np.ndarray) -> "LassoRegression":
        """使用次梯度方法训练模型"""
        n_samples, n_features = X.shape
        rng = np.random.default_rng(self.random_state)

        # 1. 初始化参数
        self.weights_ = rng.normal(0, 0.01, size=n_features)
        self.bias_ = 0.0
        self.loss_history_.clear()

        # 2. 开始迭代
        for iteration in range(self.max_iter):
            weights_old = self.weights_.copy()

            # 计算当前预测和残差
            predictions = self.predict(X)
            residual = predictions - y

            # 3. 计算次梯度
            # 均方误差部分的梯度
            grad_mse_weights = (1 / n_samples) * X.T @ residual
            grad_mse_bias = (1 / n_samples) * np.sum(residual)

            # L1 正则项的次梯度
            #   - 如果 w_j > 0, 次梯度是 1
            #   - 如果 w_j < 0, 次梯度是 -1
            #   - 如果 w_j = 0, 次梯度是 [-1, 1] 区间内的任意值。np.sign(0) 返回 0，是该区间的一个有效选择。
            subgrad_l1 = np.sign(self.weights_)

            # 组合得到 Lasso 损失函数的完整次梯度
            subgrad_weights = grad_mse_weights + self.alpha * subgrad_l1
            subgrad_bias = grad_mse_bias  # 偏置项没有正则化

            # 4. 更新参数（沿着次梯度的反方向移动）
            self.weights_ -= self.learning_rate * subgrad_weights
            self.bias_ -= self.learning_rate * subgrad_bias

            # 记录损失并检查收敛
            loss = self._compute_loss(X, y)
            self.loss_history_.append(loss)

            if np.max(np.abs(self.weights_ - weights_old)) < self.tol:
                print(f"模型在第 {iteration + 1} 次迭代时收敛")
                break

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        if self.weights_ is None or self.bias_ is None:
            raise RuntimeError("模型尚未完成训练")
        return X @ self.weights_ + self.bias_

def load_dataset(csv_path: Path) -> tuple[np.ndarray, np.ndarray, list[str]]:
    df = pd.read_csv(csv_path)

    # 将字符串形式的布尔值转换为整数
    for column in df.columns:
        if df[column].dtype == object:
            df[column] = df[column].map({"True": 1, "False": 0})

    y = df["Trip_Price"].to_numpy(dtype=float)
    feature_columns = [col for col in df.columns if col != "Trip_Price"]
    X = df[feature_columns].to_numpy(dtype=float)
    return X, y, feature_columns

def plot_results(model: LassoRegression, loss_history: list[float], y_true: np.ndarray, y_pred: np.ndarray, output_dir: Path | None = None) -> None:
    plt.figure(figsize=(10, 6))
    plt.scatter(y_true, y_pred, alpha=0.6, edgecolors='w', color="#03b903")
    
    # 添加 y=x 参考线
    min_val = min(y_true.min(), y_pred.min())
    max_val = max(y_true.max(), y_pred.max())
    plt.plot([min_val, max_val], [min_val, max_val], "#54bfe9", lw=2, linestyle='--')
    
    plt.title('实际值 vs. 预测值', fontsize=16)
    plt.xlabel('实际价格 (Actual Price)', fontsize=12)
    plt.ylabel('预测价格 (Predicted Price)', fontsize=12)
    plt.grid(True)
    plt.tight_layout()

    if output_dir:
        output_dir.mkdir(parents=True, exist_ok=True)
        plot_path = output_dir / "actual_vs_predicted.png"
        plt.savefig(plot_path, dpi=600)
        print(f"图像已保存至：{plot_path}")

    plt.show()

def plot_feature_importance(feature_names: list[str], weights: np.ndarray, top_n: int = 15, output_dir: Path | None = None) -> None:
    """绘制特征权重重要性图"""
    # 创建 DataFrame 并按系数绝对值排序
    coef_df = pd.DataFrame({
        'Feature': feature_names,
        'Coefficient': weights
    })
    coef_df['Abs_Coefficient'] = np.abs(coef_df['Coefficient'])
    coef_df = coef_df.nlargest(top_n, 'Abs_Coefficient')
    coef_df = coef_df.sort_values('Coefficient', ascending=False)
    
    plt.figure(figsize=(12, 8))
    sns.barplot(x='Coefficient', y='Feature', data=coef_df, hue='Feature', palette='viridis', legend=False)
    
    plt.yticks(range(len(coef_df)), coef_df['Feature'], fontsize=12)
    plt.xlabel('系数大小', fontsize=14)
    plt.ylabel('特征', fontsize=14)
    plt.title('模型特征重要性 (系数)', fontsize=16)
    plt.xticks(fontsize=12)
    plt.grid(axis='x', linestyle='--', alpha=0.7)
    plt.tight_layout()
    
    if output_dir:
        output_dir.mkdir(parents=True, exist_ok=True)
        plot_path = output_dir / "feature_importance.png"
        plt.savefig(plot_path, dpi=600)
        print(f"特征重要性图已保存至：{plot_path}")
    
    plt.show()

def plot_residuals(y_true: np.ndarray, y_pred: np.ndarray, output_dir: Path | None = None) -> None:
    """绘制残差分析图"""
    residuals = y_true - y_pred
    
    plt.figure(figsize=(10, 6))
    plt.scatter(y_pred, residuals, alpha=0.6, edgecolors='w', color="#f06e23")
    plt.axhline(y=0, color="#0495a8", linestyle='--', lw=2)
    
    plt.xlabel('预测价格 (Predicted Price)', fontsize=12)
    plt.ylabel('残差 (Residuals)', fontsize=12)
    plt.title('残差图 (Residuals Plot)', fontsize=16)
    plt.grid(True)
    plt.tight_layout()
    
    if output_dir:
        output_dir.mkdir(parents=True, exist_ok=True)
        plot_path = output_dir / "residuals_plot.png"
        plt.savefig(plot_path, dpi=600)
        print(f"残差分析图已保存至：{plot_path}")
    
    plt.show()

def cross_validate(model: LassoRegression, X: np.ndarray, y: np.ndarray, k: int = 5, random_state: int | None = None):
    """使用 scikit-learn 的 KFold 执行 k 折交叉验证"""
    mse_scores, mae_scores, r2_scores = [], [], []
    
    # 初始化 KFold
    kf = KFold(n_splits=k, shuffle=True, random_state=random_state)

    print(f"\n开始 {k} 折交叉验证...")
    
    for fold, (train_indices, val_indices) in enumerate(kf.split(X)):
        X_train, X_val = X[train_indices], X[val_indices]
        y_train, y_val = y[train_indices], y[val_indices]

        # 每次交叉验证都重新训练模型
        # 创建一个新的模型实例以确保从头开始训练
        current_model = LassoRegression(
            alpha=model.alpha,
            learning_rate=model.learning_rate,
            max_iter=model.max_iter,
            tol=model.tol,
            random_state=model.random_state
        )
        current_model.fit(X_train, y_train)
        
        y_pred = current_model.predict(X_val)
        
        mse = mean_squared_error(y_val, y_pred)
        mae = mean_absolute_error(y_val, y_pred)
        r2 = r2_score(y_val, y_pred)
        
        mse_scores.append(mse)
        mae_scores.append(mae)
        r2_scores.append(r2)
        
        print(f"  折 {fold + 1}/{k} - MSE: {mse:.4f}, MAE: {mae:.4f}, R^2: {r2:.4f}")

    print("\n交叉验证平均表现：")
    print(f"  平均 MSE: {np.mean(mse_scores):.4f} (标准差: {np.std(mse_scores):.4f})")
    print(f"  平均 MAE: {np.mean(mae_scores):.4f} (标准差: {np.std(mae_scores):.4f})")
    print(f"  平均 R^2: {np.mean(r2_scores):.4f} (标准差: {np.std(r2_scores):.4f})")
    
    return mse_scores, mae_scores, r2_scores

def main():
    data_path = Path("encoded_taxi_trip_pricing.csv")
    if not data_path.exists():
        raise FileNotFoundError(f"未在 {data_path.resolve()} 找到数据集文件")

    X, y, feature_names = load_dataset(data_path)
    print(f"数据集加载完成，共 {X.shape[0]} 条样本，{X.shape[1]} 个特征")

    # 标准化
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # 初始化模型
    model = LassoRegression(alpha=0.1, learning_rate=0.01, max_iter=1000, tol=1e-6, random_state=42)

    # 5 折交叉验证
    cross_validate(model, X_scaled, y, k=5, random_state=42)

    # 在完整数据集上重新训练模型
    print("\n在完整数据集上重新训练模型...")
    model.fit(X_scaled, y)

    # 在完整数据集上进行预测绘图
    y_pred_full = model.predict(X_scaled)

    final_mse = mean_squared_error(y, y_pred_full)
    final_mae = mean_absolute_error(y, y_pred_full)
    final_r2 = r2_score(y, y_pred_full)

    print("\n完整数据集上的最终模型表现：")
    print(f"  MSE: {final_mse:.4f}")
    print(f"  MAE: {final_mae:.4f}")
    print(f"  R^2: {final_r2:.4f}")

    # 查看学习到的权重
    weight_report = sorted(zip(feature_names, model.weights_), key=lambda x: -abs(x[1]))
    print("\n按权重绝对值排序的前 10 个特征：")
    for feature, weight in weight_report[:10]:
        print(f"  {feature:<35} {weight:> .6f}")

    output_dir = Path("outputs")
    
    # 预测值 vs 实际值 (使用完整数据集的结果)
    plot_results(model, model.loss_history_, y, y_pred_full, output_dir=output_dir)
    
    # 特征重要性可视化
    plot_feature_importance(feature_names, model.weights_, top_n=15, output_dir=output_dir)
    
    # 残差分析可视化 (使用完整数据集的结果)
    plot_residuals(y, y_pred_full, output_dir=output_dir)


if __name__ == "__main__":
    main()
