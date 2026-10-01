import pandas as pd
import numpy as np
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# ---ElasticNet定义---
class MyElasticNet:
    """
    使用梯度下降的 Elastic Net 回归模型。
    """
    def __init__(self, alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=None):
        self.alpha = alpha  # 正则化总强度
        self.l1_ratio = l1_ratio  # L1正则化比例
        self.learning_rate = learning_rate  # 学习率
        self.n_iterations = n_iterations  # 迭代次数
        self.random_state = random_state
        self.weights_ = None  # 权重
        self.intercept_ = None  # 偏置

    def train(self, X, y):
        """
        训练模型。
        X: 特征矩阵 (n_samples, n_features)
        y: 目标向量 (n_samples,)
        """
        n_samples, n_features = X.shape
        
        # 初始化权重和偏置
        if self.random_state:
            np.random.seed(self.random_state)
        self.weights_ = np.zeros(n_features)
        self.intercept_ = 0

        # 梯度下降
        for _ in range(self.n_iterations):
            #计算预测值
            y_pred = np.dot(X, self.weights_) + self.intercept_

            #计算梯度
            #MSE部分的梯度
            dw_mse = (1 / n_samples) * np.dot(X.T, (y_pred - y))
            db_mse = (1 / n_samples) * np.sum(y_pred - y)

            #L1正则化项的梯度 (subgradient)
            dw_l1 = self.alpha * self.l1_ratio * np.sign(self.weights_)
            
            #L2正则化项的梯度
            dw_l2 = self.alpha * (1 - self.l1_ratio) * self.weights_

            #组合梯度
            dw = dw_mse + dw_l1 + dw_l2
            db = db_mse  #偏置项通常不参与正则化

            #更新权重和偏置
            self.weights_ -= self.learning_rate * dw
            self.intercept_ -= self.learning_rate * db
            
        return self

    def predict(self, X):
        """
        使用训练好的模型进行预测。
        """
        return np.dot(X, self.weights_) + self.intercept_


# --- 1. 加载数据 ---
file_path = "encoded_taxi_trip_pricing.csv"

df = pd.read_csv(file_path)

# --- 2. 准备数据 ---
# 定义特征 (X) 和目标 (y)
X = df.drop('Trip_Price', axis=1)
y = df['Trip_Price']

# 特征缩放
# 对于像Elastic Net这样的正则化模型，特征缩放非常重要
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# --- 3. 设置模型和交叉验证 ---
# 初始化我们手写的Elastic Net模型
model = MyElasticNet(alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=42)

# 设置K折交叉验证
# n_splits=5 表示5折交叉验证
# shuffle=True 表示在分割前打乱数据
# random_state 确保每次运行结果可复现
n_splits = 5
kf = KFold(n_splits=n_splits, shuffle=True, random_state=42)

# 用于存储每折分数的列表
mse_scores = []
mae_scores = []
r2_scores = []

print(f"\n开始使用 {n_splits}-折交叉验证进行训练和评估...")

# --- 4. 执行交叉验证 ---
fold_no = 1
for train_index, test_index in kf.split(X_scaled):
    # 分割数据为当前折的训练集和测试集
    X_train, X_test = X_scaled[train_index], X_scaled[test_index]
    y_train, y_test = y.iloc[train_index], y.iloc[test_index]
    
    # 训练模型
    model.train(X_train, y_train.values) # 使用 .values 将pandas Series转为numpy array
    
    # 在测试集上进行预测
    y_pred = model.predict(X_test)
    
    # 计算评估指标
    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    # 保存分数
    mse_scores.append(mse)
    mae_scores.append(mae)
    r2_scores.append(r2)
    
    print(f"  Fold {fold_no}: MSE = {mse:.4f}, MAE = {mae:.4f}, R² = {r2:.4f}")
    fold_no += 1

# --- 5. 显示最终评估结果 ---
print("\n交叉验证完成。")
print("="*30)
print("平均评估分数:")
print(f"  平均均方误差 (MSE): {np.mean(mse_scores):.4f} (+/- {np.std(mse_scores):.4f})")
print(f"  平均绝对误差 (MAE): {np.mean(mae_scores):.4f} (+/- {np.std(mae_scores):.4f})")
print(f"  平均 R² 分数: {np.mean(r2_scores):.4f} (+/- {np.std(r2_scores):.4f})")
print("="*30)

# 你也可以在所有数据上重新训练模型以用于最终部署
#print("\n在完整数据集上重新训练最终模型...")
#final_model = MyElasticNet(alpha=0.1, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000, random_state=42)
#final_model.train(X_scaled, y.values)