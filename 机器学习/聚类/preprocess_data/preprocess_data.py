import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.impute import SimpleImputer
import os

def preprocess_credit_card_data():
    """
    预处理信用卡数据集（仅处理缺失值和异常值，不进行标准化）
    """
    # 读取数据
    input_path = 'dataset/CC GENERAL.csv'
    output_path = 'dataset/CC_GENERAL_cleaned.csv'

    df = pd.read_csv(input_path)

    print(f"原始数据形状: {df.shape}")
    print(f"原始列名: {df.columns.tolist()}")

    # 1. 删除不必要的列
    # 删除CUST_ID（客户ID）列，它对聚类没有意义
    if 'CUST_ID' in df.columns:
        df = df.drop('CUST_ID', axis=1)

    # 2. 处理缺失值
    print("\n缺失值统计:")
    print(df.isnull().sum())

    # 检查是否有缺失值
    if df.isnull().sum().sum() > 0:
        # 使用中位数填充数值型特征的缺失值
        numerical_cols = df.select_dtypes(include=[np.number]).columns
        imputer = SimpleImputer(strategy='median')
        df[numerical_cols] = imputer.fit_transform(df[numerical_cols])

    # 3. 处理异常值
    # 使用IQR方法检测并处理异常值
    def handle_outliers(df, column):
        Q1 = df[column].quantile(0.25)
        Q3 = df[column].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        # 将异常值替换为边界值
        df[column] = np.where(df[column] < lower_bound, lower_bound, df[column])
        df[column] = np.where(df[column] > upper_bound, upper_bound, df[column])
        return df

    numerical_cols = df.select_dtypes(include=[np.number]).columns
    for col in numerical_cols:
        df = handle_outliers(df, col)

    # 4. 保存处理后的数据（仅清洁数据，不进行标准化）
    df.to_csv(output_path, index=False)

    print(f"\n数据清洗完成!")
    print(f"处理后数据形状: {df.shape}")
    print(f"处理后数据列名: {df.columns.tolist()}")
    print(f"数据已保存到: {output_path}")

    # 输出一些统计信息
    print("\n处理后数据统计信息:")
    print(df.describe())

    return df

def standardize_data(df):
    """
    对数据进行标准化（Z-score标准化）
    """
    from sklearn.preprocessing import StandardScaler

    scaler = StandardScaler()
    df_standardized = pd.DataFrame(scaler.fit_transform(df), columns=df.columns)
    df_standardized.to_csv('dataset/CC_GENERAL_standardized.csv', index=False)

    print(f"\n标准化数据已保存到: dataset/CC_GENERAL_standardized.csv")
    print(f"标准化后数据形状: {df_standardized.shape}")
    print("\n标准化后数据统计信息:")
    print(df_standardized.describe())

    return df_standardized

def normalize_data(df):
    """
    对数据进行归一化（MinMax归一化）
    """
    from sklearn.preprocessing import MinMaxScaler

    minmax_scaler = MinMaxScaler()
    df_normalized = pd.DataFrame(minmax_scaler.fit_transform(df), columns=df.columns)
    df_normalized.to_csv('dataset/CC_GENERAL_normalized.csv', index=False)

    print(f"\n归一化数据已保存到: dataset/CC_GENERAL_normalized.csv")
    print(f"归一化后数据形状: {df_normalized.shape}")
    print("\n归一化后数据统计信息:")
    print(df_normalized.describe())

    return df_normalized

if __name__ == "__main__":
    # 执行主要预处理（仅清洁数据）
    preprocessed_data = preprocess_credit_card_data()

    # 执行标准化和归一化
    standardize_data(preprocessed_data)
    normalize_data(preprocessed_data)