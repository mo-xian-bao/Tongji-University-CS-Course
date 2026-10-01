import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# 添加以下两行代码来设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 指定默认字体
plt.rcParams['axes.unicode_minus'] = False  # 解决保存图像是负号'-'显示为方块的问题

from sklearn.model_selection import StratifiedKFold, cross_validate
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier # 1. 导入 XGBoost
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix, ConfusionMatrixDisplay
from sklearn.impute import SimpleImputer
from imblearn.over_sampling import SMOTE
from imblearn.pipeline import Pipeline as ImbPipeline # 1. 导入 imblearn 的 Pipeline

df = pd.read_excel("问题四数据.xlsx")
df['染色体的非整倍体标注'] = np.where(df['染色体的非整倍体'].isnull(), 0, 1)

 #数据清洗：过滤 'X染色体的Z值'
print(f"\n清洗前的数据量: {df.shape[0]} 行")
df = df[(df['X染色体的Z值'] >= -3) & (df['X染色体的Z值'] <= 3)]
print(f"清洗后的数据量: {df.shape[0]} 行")

# 1. 定义自变量和因变量
features = [
    '孕妇BMI', 'GC含量', '原始读段数', '在参考基因组上比对的比例', 
    '重复读段的比例', '唯一比对的读段数', '13号染色体的Z值', 
    '18号染色体的Z值', '21号染色体的Z值', 'X染色体的Z值', 'X染色体浓度', 
    '13号染色体的GC含量', '18号染色体的GC含量', '21号染色体的GC含量', 
    '被过滤掉读段数的比例'
]
# features = [
#     'X染色体浓度',
#     '13号染色体的GC含量', '18号染色体的GC含量', '21号染色体的GC含量'
# ]
target = '染色体的非整倍体标注'

X = df[features]
y = df[target]

print("\n自变量 (X) 的形状:", X.shape)
print("因变量 (y) 的形状:", y.shape)
print("\n类别分布:")
print(y.value_counts())


# 2. 定义模型和预处理流程
# 我们将预处理步骤（填充、SMOTE、标准化）和分类器本身打包进一个 Pipeline
# 这样做可以确保在交叉验证的每一折中，预处理都只在训练数据上进行，避免数据泄露

models = {
    "逻辑回归": LogisticRegression(random_state=42, max_iter=1000),
    "支持向量机": SVC(random_state=42, probability=True), # probability=True 用于后续可能绘制ROC曲线
    "决策树": DecisionTreeClassifier(random_state=42),
    "随机森林": RandomForestClassifier(random_state=42),
    "XGBoost": XGBClassifier(random_state=42, use_label_encoder=False, eval_metric='logloss') # 2. 新增 XGBoost 模型
}

results = {}

# 定义交叉验证策略
k = 5 # 设置折数
cv_strategy = StratifiedKFold(n_splits=k, shuffle=True, random_state=42)

# 定义需要计算的指标
scoring_metrics = ['accuracy', 'precision', 'recall', 'f1']

# 3. 执行交叉验证
for name, model in models.items():
    print(f"\n正在对模型进行 {k}-折交叉验证: {name}...")
    
    # 创建包含完整预处理流程和模型的 Pipeline
    pipeline = ImbPipeline(steps=[
        ('imputer', SimpleImputer(strategy='mean')),
        ('smote', SMOTE(random_state=42)),
        ('scaler', StandardScaler()),
        ('classifier', model)
    ])
    
    # 使用 cross_validate 执行交叉验证
    cv_results = cross_validate(pipeline, X, y, cv=cv_strategy, scoring=scoring_metrics)
    
    # 存储平均结果
    results[name] = {
        "准确率": np.mean(cv_results['test_accuracy']),
        "精确率": np.mean(cv_results['test_precision']),
        "召回率": np.mean(cv_results['test_recall']),
        "F1 Score": np.mean(cv_results['test_f1'])
    }
    print(f"{name} 交叉验证完成。")

# 4. 结果对比
results_df = pd.DataFrame(results).T
print("\n" + "="*50)
print(f"{k}-折交叉验证平均性能对比")
print("="*50)
print(results_df)

# 5. 可视化结果
results_df.T.plot(kind='bar', figsize=(14, 8), rot=0)
plt.title(f'各模型 {k}-折交叉验证性能对比', fontsize=16)
plt.ylabel('分数')
plt.xlabel('性能指标')
plt.ylim(0, 1.1)
plt.legend(title='模型')
plt.tight_layout()
plt.show()

# 6. 新增：绘制交叉验证的ROC曲线和计算AUC
from sklearn.metrics import roc_curve, auc

plt.figure(figsize=(10, 8))

# 循环遍历每个模型
for name, model in models.items():
    print(f"\n正在为模型绘制ROC曲线: {name}...")
    
    # 创建与之前交叉验证中完全相同的Pipeline
    pipeline = ImbPipeline(steps=[
        ('imputer', SimpleImputer(strategy='mean')),
        ('smote', SMOTE(random_state=42)),
        ('scaler', StandardScaler()),
        ('classifier', model)
    ])
    
    tprs = []
    aucs = []
    mean_fpr = np.linspace(0, 1, 100)
    
    # 手动循环交叉验证的每一折
    for train_index, test_index in cv_strategy.split(X, y):
        X_train, X_test = X.iloc[train_index], X.iloc[test_index]
        y_train, y_test = y.iloc[train_index], y.iloc[test_index]
        
        # 在训练数据上拟合pipeline
        pipeline.fit(X_train, y_train)
        
        # 获取在测试集上的预测概率
        probas_ = pipeline.predict_proba(X_test)
        
        # 计算ROC曲线和AUC
        fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1])
        tprs.append(np.interp(mean_fpr, fpr, tpr))
        tprs[-1][0] = 0.0
        roc_auc = auc(fpr, tpr)
        aucs.append(roc_auc)

    # 绘制对角线
    plt.plot([0, 1], [0, 1], linestyle='--', lw=2, color='r', label='随机猜测', alpha=.8)

    # 计算平均TPR和AUC
    mean_tpr = np.mean(tprs, axis=0)
    mean_tpr[-1] = 1.0
    mean_auc = auc(mean_fpr, mean_tpr)
    std_auc = np.std(aucs)
    
    # 绘制平均ROC曲线
    plt.plot(mean_fpr, mean_tpr,
             label=f'{name} (平均 AUC = {mean_auc:.2f} $\\pm$ {std_auc:.2f})',
             lw=2, alpha=.8)

    # 绘制置信区间（标准差范围）
    std_tpr = np.std(tprs, axis=0)
    tprs_upper = np.minimum(mean_tpr + std_tpr, 1)
    tprs_lower = np.maximum(mean_tpr - std_tpr, 0)
    plt.fill_between(mean_fpr, tprs_lower, tprs_upper, alpha=.2)

# 设置图表属性
plt.xlim([-0.05, 1.05])
plt.ylim([-0.05, 1.05])
plt.xlabel('假阳性率 (False Positive Rate)')
plt.ylabel('真阳性率 (True Positive Rate)')
plt.title(f'各模型 {k}-折交叉验证 ROC 曲线', fontsize=16)
plt.legend(loc="lower right")
plt.grid(alpha=0.3)
plt.show()


# 7. 新增：基于交叉验证的预测生成混淆矩阵
from sklearn.model_selection import cross_val_predict

print("\n" + "="*50)
print("生成基于交叉验证的混淆矩阵")
print("="*50)

fig, axes = plt.subplots(2, 3, figsize=(18, 10)) # 3. 调整子图布局为 2x3 以容纳5个模型
axes = axes.ravel()

for i, (name, model) in enumerate(models.items()):
    print(f"正在为模型获取交叉验证预测: {name}...")
    
    # 创建与之前完全相同的Pipeline
    pipeline = ImbPipeline(steps=[
        ('imputer', SimpleImputer(strategy='mean')),
        ('smote', SMOTE(random_state=42)),
        ('scaler', StandardScaler()),
        ('classifier', model)
    ])
    
    # 使用 cross_val_predict 获取每一折验证集的预测结果
    y_pred = cross_val_predict(pipeline, X, y, cv=cv_strategy)
    
    # 计算并绘制混淆矩阵
    cm = confusion_matrix(y, y_pred)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=[0, 1])
    disp.plot(ax=axes[i], cmap=plt.cm.Blues)
    axes[i].set_title(f"{name} 混淆矩阵")

# 4. 隐藏多余的子图
for i in range(len(models), len(axes)):
    fig.delaxes(axes[i])

plt.suptitle("各模型基于交叉验证的混淆矩阵对比", fontsize=16)
plt.tight_layout(rect=[0, 0, 1, 0.96])
plt.show()

# 8. 新增：逻辑斯蒂回归模型可解释性分析
print("\n" + "="*50)
print("逻辑斯蒂回归模型可解释性分析")
print("="*50)

# 1. 创建并训练一个最终的逻辑斯蒂回归 Pipeline
# 我们需要在全部数据上训练一次，以获得用于解释的最终系数
final_lr_pipeline = ImbPipeline(steps=[
    ('imputer', SimpleImputer(strategy='mean')),
    ('smote', SMOTE(random_state=42)),
    ('scaler', StandardScaler()),
    ('classifier', LogisticRegression(random_state=42, max_iter=1000))
])

print("正在全部数据上训练最终的逻辑斯蒂回归模型...")
final_lr_pipeline.fit(X, y)
print("模型训练完成。")

# 2. 提取系数和特征名
# 从Pipeline中提取训练好的分类器
lr_model = final_lr_pipeline.named_steps['classifier']
# 获取系数
coefficients = lr_model.coef_[0]
# 获取特征名
feature_names = X.columns

# 3. 创建一个包含特征名和对应系数的DataFrame
feature_importance_df = pd.DataFrame({
    '特征': feature_names,
    '系数': coefficients
})

# 4. 根据系数的绝对值进行排序，以判断重要性
feature_importance_df['重要性（绝对值）'] = feature_importance_df['系数'].abs()
feature_importance_df = feature_importance_df.sort_values(by='重要性（绝对值）', ascending=False)

print("\n各特征的系数与重要性排序：")
print(feature_importance_df)

# 5. 可视化特征重要性
plt.figure(figsize=(12, 8))
plt.barh(feature_importance_df['特征'], feature_importance_df['系数'])
plt.xlabel('系数大小 (标准化后)')
plt.ylabel('特征')
plt.title('逻辑斯蒂回归模型各特征的系数')
plt.grid(axis='x', linestyle='--', alpha=0.6)
plt.tight_layout()
plt.show()

# 9. 新增：写出最终的逻辑斯蒂回归方程
print("\n" + "="*50)
print("最终逻辑斯蒂回归方程的组成部分")
print("="*50)

# 从训练好的Pipeline中提取截距
intercept = final_lr_pipeline.named_steps['classifier'].intercept_[0]

print(f"截距 (β₀): {intercept:.4f}\n")
print("各特征的系数 (βᵢ):")
# 打印之前计算好的系数，以便于组合方程
# 使用 set_index 以便更容易地将特征名与系数对应起来
print(feature_importance_df.set_index('特征')[['系数']])