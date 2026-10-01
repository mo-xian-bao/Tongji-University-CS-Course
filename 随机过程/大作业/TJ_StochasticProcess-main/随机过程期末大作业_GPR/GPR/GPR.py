import pandas as pd
import numpy as np
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern, WhiteKernel, ConstantKernel
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

# 读取数据
data1 = pd.read_csv('NVIDIA.csv', parse_dates=['Date'], index_col='Date')
# 检查数据是否已经是按日期升序排列
if not data1.index.is_monotonic_increasing:
    # 如果不是升序排列，则进行排序
    data1 = data1.sort_index(ascending=True)
# 去除 'Close/Last' 列中的货币符号并转换为浮点数
data1['Close/Last'] = data1['Close/Last'].str.replace(r'[^\d.]', '', regex=True).astype(float)
stock1 = data1.iloc[:, 1].values  # 假设第二列是收盘价

# 定义训练集和测试集
'''trainX = np.arange(1, 1186).reshape(-1, 1)
testX = np.arange(1186, 1228).reshape(-1, 1)
trainY = stock1[:1185]
testYreal = stock1[1185:1227]'''

# 创建时间索引
time_index = np.arange(1, len(stock1) + 1).reshape(-1, 1)
# 按8:2比例划分训练集和测试集
trainX, testX, trainY, testYreal = train_test_split(time_index, stock1, test_size=0.15, shuffle=False)

# 标准化数据
scaler = StandardScaler()
trainY_scaled = scaler.fit_transform(trainY.reshape(-1, 1)).ravel()

# GPR模型
kernel = ConstantKernel() * Matern(length_scale=1.0, nu=1.5) + WhiteKernel(noise_level=1)
gprMdl = GaussianProcessRegressor(kernel=kernel, n_restarts_optimizer=10, alpha=0.1, normalize_y=True)
gprMdl.fit(trainX, trainY_scaled)

# 预测
testYpd_scaled, sigma = gprMdl.predict(testX, return_std=True)
testYpd = scaler.inverse_transform(testYpd_scaled.reshape(-1, 1)).ravel()
Lower = scaler.inverse_transform((testYpd_scaled - 1.96 * sigma).reshape(-1, 1)).ravel()
Upper = scaler.inverse_transform((testYpd_scaled + 1.96 * sigma).reshape(-1, 1)).ravel()

# 计算误差
erravg = np.mean(np.abs(testYpd - testYreal) / testYreal)
print(f'平均绝对误差为: {erravg}')

# 计算测试集实际值在上下限的概率
y3 = (testYreal > Lower) & (testYreal < Upper)
errarea = np.mean(y3)
print(f'实际值在预测上下限区间的概率为: {errarea}')


# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用黑体
plt.rcParams['axes.unicode_minus'] = False    # 解决负号 '-' 显示为方块的问题
# 作图
plt.figure(figsize=(14, 7))
plt.plot(trainX, trainY, 'b', label='Train')
plt.plot(testX, testYreal, 'g', label='Test Real')
plt.plot(testX, testYpd, 'm', label='Test Predicted')
plt.fill_between(testX.ravel(), Lower, Upper, color=[0.93333, 0.83529, 0.82353], alpha=0.5, label='Uncertainty')
plt.xlabel('时间/天')
plt.ylabel('收盘价格/美元')
plt.legend()
plt.show()