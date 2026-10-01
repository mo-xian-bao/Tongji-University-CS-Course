import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# 添加以下两行代码来设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 指定默认字体
plt.rcParams['axes.unicode_minus'] = False  # 解决保存图像是负号'-'显示为方块的问题

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix, ConfusionMatrixDisplay # 导入混淆矩阵相关工具
from sklearn.impute import SimpleImputer # 1. 导入 SimpleImputer

df = pd.read_excel(r"D:\desktop\CUMCM25C\问题四数据.xlsx")
df['染色体的非整倍体标注'] = np.where(df['染色体的非整倍体'].isnull(), 0, 1)
print("数据加载完成，前5行预览：")
print(df.head())

# 1. 定义自变量和因变量
# 注意：原始数据中有两个'GC含量'列，pandas会自动处理为 'GC含量' 和 'GC含量.1'
# 我们需要确保使用正确的列名
features = [
    '孕妇BMI', 'GC含量', '原始读段数', '在参考基因组上比对的比例', 
    '重复读段的比例', '唯一比对的读段数', '13号染色体的Z值', 
    '18号染色体的Z值', '21号染色体的Z值', 'X染色体的Z值', 'X染色体浓度', 
    '13号染色体的GC含量', '18号染色体的GC含量', '21号染色体的GC含量', 
    '被过滤掉读段数的比例'
]
target = '染色体的非整倍体标注'

X = df[features]
y = df[target]

print("\n自变量 (X) 的形状:", X.shape)
print("因变量 (y) 的形状:", y.shape)
print("\n类别分布:")
print(y.value_counts())


# 2. 数据预处理
# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42, stratify=y)

# 2.1 新增：处理缺失值，使用均值填充
imputer = SimpleImputer(strategy='mean')
X_train = imputer.fit_transform(X_train)
X_test = imputer.transform(X_test)

# 2.2 数据标准化
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

print("\n数据已划分为训练集和测试集，并完成缺失值填充和标准化。")

# 3. 初始化模型
# 通过设置 class_weight='balanced' 来处理样本不均衡问题
models = {
    "逻辑回归": LogisticRegression(random_state=42, max_iter=1000, class_weight='balanced'),
    "支持向量机": SVC(random_state=42, class_weight='balanced'),
    "决策树": DecisionTreeClassifier(random_state=42, class_weight='balanced'),
    "随机森林": RandomForestClassifier(random_state=42, class_weight='balanced')
}

# 4. 训练和评估模型
results = {}
all_predictions = {} # 新增：用于存储每个模型的预测结果

for name, model in models.items():
    print(f"\n正在训练模型: {name}...")
    # 训练模型
    model.fit(X_train_scaled, y_train)
    
    # 在测试集上进行预测
    y_pred = model.predict(X_test_scaled)
    all_predictions[name] = y_pred # 保存预测结果
    
    # 计算评估指标
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred)
    recall = recall_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred)
    
    # 存储结果
    results[name] = {
        "准确率": accuracy,
        "精确率": precision,
        "召回率": recall,
        "F1 Score": f1
    }
    print(f"{name} 评估完成。")

# 5. 结果对比
results_df = pd.DataFrame(results).T  # .T 用于转置，使模型名称为行索引
print("\n" + "="*50)
print("各模型性能对比")
print(results_df)

# 可视化所有模型性能指标（以指标为横坐标）
results_df.T.plot(kind='bar', figsize=(14, 8), rot=0)
plt.title('各模型性能指标对比', fontsize=16)
plt.ylabel('分数')
plt.xlabel('性能指标') # X轴标签改为性能指标
plt.ylim(0, 1.1) 
plt.legend(title='模型') # 图例标题改为模型
plt.tight_layout()
plt.show()

# 6. 新增：可视化混淆矩阵
fig, axes = plt.subplots(2, 2, figsize=(12, 10))
axes = axes.ravel() # 将2x2的子图数组展平，方便遍历

for i, (name, y_pred) in enumerate(all_predictions.items()):
    cm = confusion_matrix(y_test, y_pred)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=[0, 1])
    disp.plot(ax=axes[i], cmap=plt.cm.Blues)
    axes[i].set_title(f"{name} 混淆矩阵")

plt.suptitle("各模型混淆矩阵对比", fontsize=16)
plt.tight_layout(rect=[0, 0, 1, 0.96]) # 调整布局以适应主标题
plt.show()

