import pandas as pd
import numpy as np
import os

# 读取数据集
df = pd.read_csv('dataset/CC GENERAL.csv')

print("数据集基本信息：")
print(f"数据形状：{df.shape}")
print("\n列名：")
print(df.columns.tolist())
print("\n前5行数据：")
print(df.head())
print("\n数据类型：")
print(df.dtypes)
print("\n缺失值统计：")
print(df.isnull().sum())