import pandas as pd

# 定义输入和输出文件路径
input_csv_path = r'c:\Users\Myltw\Desktop\machine learning\regression\cleaned_taxi_trip_pricing.csv'
output_csv_path = r'c:\Users\Myltw\Desktop\machine learning\regression\encoded_taxi_trip_pricing.csv'

# 读取数据
try:
    df = pd.read_csv(input_csv_path)
    print("成功读取文件: cleaned_taxi_trip_pricing.csv")
except FileNotFoundError:
    print(f"错误: 文件未找到 at {input_csv_path}")
    exit()

# 定义需要进行独热编码的类别列
categorical_columns = [
    'Time_of_Day',
    'Day_of_Week',
    'Traffic_Conditions',
    'Weather'
]

# 检查列是否存在
for col in categorical_columns:
    if col not in df.columns:
        print(f"错误: 列 '{col}' 在CSV文件中未找到。")
        exit()

# 执行独热编码
df_encoded = pd.get_dummies(df, columns=categorical_columns, prefix=categorical_columns)

# 保存处理后的数据到新文件
df_encoded.to_csv(output_csv_path, index=False)

print(f"独热编码完成。结果已保存到: {output_csv_path}")
print("\n处理后数据的前5行:")
print(df_encoded.head())
print("\n新的列名:")
print(df_encoded.columns.tolist())