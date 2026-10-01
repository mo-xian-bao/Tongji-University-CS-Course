import pandas as pd
import os
from pathlib import Path

def split_csv_to_train_test(input_csv_path, train_ratio=0.8):
    """
    将CSV文件分割为训练集和测试集，并重新生成连续的Id列
    input_csv_path: 输入CSV文件的路径
    train_ratio: 训练集比例，默认0.8(80%)
    """
    
    try:
        # 读取CSV文件
        print(f"正在读取文件: {input_csv_path}")
        df = pd.read_csv(input_csv_path)
        
        # 检查数据是否为空
        if df.empty:
            print("错误：CSV文件为空！")
            return
        
        print(f"成功读取数据，共 {len(df)} 行")
        print(f"原始数据列: {list(df.columns)}")
        
        # 随机打乱数据
        df_shuffled = df.sample(frac=1, random_state=42).reset_index(drop=True)
        # 重新生成连续的Id列
        if 'Id' in df_shuffled.columns:
            df_shuffled = df_shuffled.drop(columns=['Id'])
        df_shuffled.index = df_shuffled.index + 1
        df_shuffled['Id'] = df_shuffled.index  # 列名改为大写Id
        cols = ['Id'] + [col for col in df_shuffled.columns if col != 'Id']
        df_shuffled = df_shuffled[cols]

        # 计算训练集大小
        train_size = int(len(df_shuffled) * train_ratio)
        
        # 分割数据
        train_df = df_shuffled[:train_size]
        test_df = df_shuffled[train_size:]
        
        print(f"训练集: {len(train_df)} 行 ({train_ratio*100}%)")
        print(f"测试集: {len(test_df)} 行 ({(1-train_ratio)*100}%)")
        
        # 创建dataset文件夹
        dataset_dir = Path("dataset")
        dataset_dir.mkdir(exist_ok=True)
        
        # 保存训练集和测试集
        train_path = dataset_dir / "train.csv"
        test_path = dataset_dir / "test.csv"
        
        # 指定NA作为空值标记
        train_df.to_csv(train_path, index=False, na_rep='NA')
        test_df.to_csv(test_path, index=False, na_rep='NA')  
        
        print(f"\n文件已成功生成：")
        print(f"训练集: {train_path}")
        print(f"测试集: {test_path}")
        
        
    except FileNotFoundError:
        print(f"错误：找不到文件 {input_csv_path}")
        print("请检查文件路径是否正确")
    except Exception as e:
        print(f"处理文件时出现错误: {e}")

def main():
    csv_file_path = "taxi_trip_pricing.csv" 
    split_csv_to_train_test(csv_file_path)

if __name__ == "__main__":
    main()