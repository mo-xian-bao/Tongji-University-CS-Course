import pandas as pd

# 加载数据集
try:
    df = pd.read_csv('taxi_trip_pricing.csv')
except FileNotFoundError:
    print("错误：'taxi_trip_pricing.csv' 文件未找到。请确保文件与脚本在同一目录下。")
    exit()

# 1. 删除 'Trip_Distance_km' 和 'Trip_Price' 列中存在缺失值的行
df.dropna(subset=['Trip_Distance_km', 'Trip_Price'], inplace=True)

# 2. 对指定分类列的缺失值用众数填充
categorical_cols = ['Time_of_Day', 'Day_of_Week', 'Traffic_Conditions', 'Weather']
for col in categorical_cols:
    mode_value = df[col].mode()[0]
    df[col].fillna(mode_value, inplace=True)

# 3. 对其余数值列的缺失值用中位数填充
# 首先确定哪些是需要填充的数值列
all_columns = df.columns.tolist()
processed_cols = ['Trip_Distance_km', 'Trip_Price'] + categorical_cols
numerical_cols_to_fill = [col for col in all_columns if col not in processed_cols and df[col].isnull().any()]

for col in numerical_cols_to_fill:
    if pd.api.types.is_numeric_dtype(df[col]):
        median_value = df[col].median()
        df[col].fillna(median_value, inplace=True)

# 显示处理后数据的基本信息和缺失值统计，以验证处理结果
print("数据预处理完成。")
print("\n处理后各列缺失值数量:")
print(df.isnull().sum())

print("\n处理后数据集的前5行:")
print(df.head())

# 将清理后的数据保存到新文件
output_filename = 'cleaned_taxi_trip_pricing.csv'
df.to_csv(output_filename, index=False)

print(f"\n已将处理后的数据保存到 '{output_filename}'")
