import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import seaborn as sns

# --- ElasticNet定义 (从 Elastic_net.py 复制) ---
class MyElasticNet:
    """
    使用梯度下降的 Elastic Net 回归模型。
    """
    def __init__(self, alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=None):
        self.alpha = alpha
        self.l1_ratio = l1_ratio
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.random_state = random_state
        self.weights_ = None
        self.intercept_ = None

    def train(self, X, y):
        """
        训练模型。
        """
        n_samples, n_features = X.shape
        if self.random_state:
            np.random.seed(self.random_state)
        self.weights_ = np.zeros(n_features)
        self.intercept_ = 0

        for _ in range(self.n_iterations):
            y_pred = np.dot(X, self.weights_) + self.intercept_
            dw_mse = (1 / n_samples) * np.dot(X.T, (y_pred - y))
            db_mse = (1 / n_samples) * np.sum(y_pred - y)
            dw_l1 = self.alpha * self.l1_ratio * np.sign(self.weights_)
            dw_l2 = self.alpha * (1 - self.l1_ratio) * self.weights_
            dw = dw_mse + dw_l1 + dw_l2
            db = db_mse
            self.weights_ -= self.learning_rate * dw
            self.intercept_ -= self.learning_rate * db
        return self

    def predict(self, X):
        """
        使用训练好的模型进行预测。
        """
        return np.dot(X, self.weights_) + self.intercept_

# --- 1. 加载和准备数据 ---
file_path = "encoded_taxi_trip_pricing.csv"

df = pd.read_csv(file_path)

X = df.drop('Trip_Price', axis=1)
y = df['Trip_Price']

# 特征缩放
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# --- 2. 训练最终模型以获取特征重要性 ---
print("在完整数据集上训练模型以进行可视化...")
final_model = MyElasticNet(alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=42)
final_model.train(X_scaled, y.values)
print("模型训练完成。")

# --- 3. 可视化 1: 特征重要性 ---
feature_names = X.columns
coefficients = final_model.weights_

# 创建一个包含特征名和对应系数的DataFrame
coef_df = pd.DataFrame({'Feature': feature_names, 'Coefficient': coefficients})
coef_df = coef_df.sort_values(by='Coefficient', ascending=False)

plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

plt.figure(figsize=(12, 8))
sns.barplot(x='Coefficient', y='Feature', data=coef_df, hue='Feature', palette='viridis', legend=False)
plt.title('模型特征重要性 (系数)', fontsize=16)
plt.xlabel('系数大小', fontsize=14)
plt.ylabel('特征', fontsize=14)
plt.yticks(fontsize=12) 
plt.xticks(fontsize=12) 
plt.grid(axis='x', linestyle='--', alpha=0.7)
plt.tight_layout() # 调整布局以防止标签重叠
plt.savefig('Elastic_net_feature_importance.png',dpi=600)

# --- 4. 为散点图准备数据：分割训练集和测试集 ---
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# 在训练集上训练一个新模型实例
viz_model = MyElasticNet(alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=42)
viz_model.train(X_train, y_train.values)

# 在测试集上进行预测
y_pred = viz_model.predict(X_test)


# --- 5. 可视化 2: 实际值 vs. 预测值 ---
plt.figure(figsize=(10, 6))
plt.scatter(y_test, y_pred, alpha=0.6, edgecolors='w',color="#03b903")
plt.plot([y.min(), y.max()], [y.min(), y.max()], "#54bfe9", lw=2, linestyle='--') # 添加 y=x 参考线
plt.title('实际值 vs. 预测值', fontsize=16)
plt.xlabel('实际价格 (Actual Price)', fontsize=12)
plt.ylabel('预测价格 (Predicted Price)', fontsize=12)

plt.grid(True)
plt.tight_layout()
plt.savefig('Elastic_net_actual_vs_predicted.png',dpi=600)

# --- 6. 可视化 3: 残差图 ---
residuals = y_test - y_pred

plt.figure(figsize=(10, 6))
plt.scatter(y_pred, residuals, alpha=0.6, edgecolors='w',color="#f06e23")
plt.axhline(y=0, color="#0495a8", linestyle='--', lw=2) # 添加 y=0 参考线
plt.title('残差图 (Residuals Plot)', fontsize=16)
plt.xlabel('预测价格 (Predicted Price)', fontsize=12)
plt.ylabel('残差 (Residuals)', fontsize=12)
plt.grid(True)
plt.tight_layout()
plt.savefig('Elastic_net_residuals_plot.png',dpi=600)