"""
结构方程模型（SEM）分析框架
Structural Equation Modeling Analysis Framework

这个脚本提供了完整的SEM分析流程，包括：
1. 数据准备和探索
2. 测量模型（CFA）
3. 结构模型（SEM）
4. 模型拟合评估
5. 结果可视化

依赖库安装：
pip install semopy pandas numpy matplotlib seaborn scipy
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from semopy import Model, calc_stats
import warnings
warnings.filterwarnings('ignore')

# 设置中文显示
plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei']
plt.rcParams['axes.unicode_minus'] = False


class SEMAnalysis:
    """SEM分析类"""
    
    def __init__(self, data=None):
        """
        初始化SEM分析
        
        Parameters:
        -----------
        data : pd.DataFrame, optional
            输入数据，如果为None则生成示例数据
        """
        self.data = data
        self.model = None
        self.fit_result = None
        
    def generate_sample_data(self, n_samples=300, seed=42):
        """
        生成示例数据
        
        Parameters:
        -----------
        n_samples : int
            样本数量
        seed : int
            随机种子
            
        Returns:
        --------
        pd.DataFrame
            生成的示例数据
        """
        np.random.seed(seed)
        
        # 模拟潜变量
        satisfaction = np.random.randn(n_samples)
        quality = np.random.randn(n_samples)
        loyalty = 0.6 * satisfaction + 0.4 * quality + np.random.randn(n_samples) * 0.5
        
        # 生成观测变量（带测量误差）
        data = pd.DataFrame({
            # 满意度的观测指标
            'sat1': satisfaction + np.random.randn(n_samples) * 0.3,
            'sat2': satisfaction + np.random.randn(n_samples) * 0.3,
            'sat3': satisfaction + np.random.randn(n_samples) * 0.3,
            
            # 质量的观测指标
            'qual1': quality + np.random.randn(n_samples) * 0.3,
            'qual2': quality + np.random.randn(n_samples) * 0.3,
            'qual3': quality + np.random.randn(n_samples) * 0.3,
            
            # 忠诚度的观测指标
            'loy1': loyalty + np.random.randn(n_samples) * 0.3,
            'loy2': loyalty + np.random.randn(n_samples) * 0.3,
            'loy3': loyalty + np.random.randn(n_samples) * 0.3,
        })
        
        self.data = data
        print(f"✓ 已生成 {n_samples} 个样本的示例数据")
        return data
    
    def load_data(self, filepath):
        """
        从文件加载数据
        
        Parameters:
        -----------
        filepath : str
            数据文件路径（支持csv, xlsx等）
        """
        if filepath.endswith('.csv'):
            self.data = pd.read_csv(filepath)
        elif filepath.endswith('.xlsx') or filepath.endswith('.xls'):
            self.data = pd.read_excel(filepath)
        else:
            raise ValueError("不支持的文件格式，请使用csv或xlsx文件")
        
        print(f"✓ 已加载数据，共 {len(self.data)} 行，{len(self.data.columns)} 列")
        return self.data
    
    def explore_data(self):
        """数据探索性分析"""
        if self.data is None:
            print("❌ 请先加载或生成数据")
            return
        
        print("\n" + "="*60)
        print("数据基本信息")
        print("="*60)
        print(f"样本数量: {len(self.data)}")
        print(f"变量数量: {len(self.data.columns)}")
        print(f"\n变量列表:\n{list(self.data.columns)}")
        
        print("\n" + "="*60)
        print("描述性统计")
        print("="*60)
        print(self.data.describe())
        
        print("\n" + "="*60)
        print("缺失值检查")
        print("="*60)
        missing = self.data.isnull().sum()
        if missing.sum() == 0:
            print("✓ 无缺失值")
        else:
            print(missing[missing > 0])
        
        # 相关系数矩阵
        print("\n" + "="*60)
        print("相关系数矩阵")
        print("="*60)
        corr_matrix = self.data.corr()
        print(corr_matrix.round(3))
        
        # 可视化相关系数矩阵
        plt.figure(figsize=(10, 8))
        sns.heatmap(corr_matrix, annot=True, fmt='.2f', cmap='coolwarm', 
                    center=0, square=True, linewidths=1)
        plt.title('变量相关系数热力图', fontsize=14, pad=20)
        plt.tight_layout()
        plt.savefig('correlation_matrix.png', dpi=300, bbox_inches='tight')
        print("\n✓ 相关系数热力图已保存为 correlation_matrix.png")
        plt.close()
    
    def define_model(self, model_spec):
        """
        定义SEM模型
        
        Parameters:
        -----------
        model_spec : str
            模型定义（使用lavaan语法）
            
        示例:
        -----
        model_spec = '''
        # 测量模型
        Satisfaction =~ sat1 + sat2 + sat3
        Quality =~ qual1 + qual2 + qual3
        Loyalty =~ loy1 + loy2 + loy3
        
        # 结构模型
        Loyalty ~ Satisfaction + Quality
        '''
        """
        self.model_spec = model_spec
        self.model = Model(model_spec)
        print("✓ 模型已定义")
        print("\n模型结构:")
        print(model_spec)
    
    def fit_model(self):
        """拟合模型"""
        if self.model is None:
            print("❌ 请先定义模型")
            return
        
        if self.data is None:
            print("❌ 请先加载或生成数据")
            return
        
        print("\n正在拟合模型...")
        self.fit_result = self.model.fit(self.data)
        print("✓ 模型拟合完成")
    
    def show_results(self):
        """显示模型结果"""
        if self.fit_result is None:
            print("❌ 请先拟合模型")
            return
        
        print("\n" + "="*60)
        print("参数估计结果")
        print("="*60)
        estimates = self.model.inspect()
        print(estimates.to_string())
        
        print("\n" + "="*60)
        print("模型拟合指标")
        print("="*60)
        
        # 使用calc_stats获取拟合指标
        stats = calc_stats(self.model)
        
        # 将stats转换为字典格式
        fit_indices = {}
        if isinstance(stats, pd.DataFrame):
            for col in stats.columns:
                fit_indices[col] = stats[col].iloc[0] if len(stats) > 0 else None
        
        # 格式化输出拟合指标
        def safe_print(label, key, format_str=".3f", note=""):
            value = fit_indices.get(key, None)
            if value is not None and not pd.isna(value):
                print(f"{label:20} {value:{format_str}}  {note}")
            else:
                print(f"{label:20} N/A  {note}")
        
        safe_print("χ² (Chi-square):", "chi2")
        safe_print("自由度 (df):", "DoF", ".0f")
        safe_print("p-value:", "chi2_pvalue")
        print()
        safe_print("CFI:", "CFI", note="(>0.90可接受, >0.95良好)")
        safe_print("TLI:", "TLI", note="(>0.90可接受)")
        safe_print("RMSEA:", "RMSEA", note="(<0.08可接受, <0.05良好)")
        safe_print("SRMR:", "SRMR", note="(<0.08良好)")
        safe_print("AIC:", "AIC")
        safe_print("BIC:", "BIC")
        
        # 评估模型拟合
        self._evaluate_fit(fit_indices)
        
        return estimates, fit_indices
    
    def _evaluate_fit(self, fit_indices):
        """评估模型拟合优度"""
        print("\n" + "="*60)
        print("模型拟合评估")
        print("="*60)
        
        cfi = fit_indices.get('CFI', fit_indices.get('cfi', None))
        tli = fit_indices.get('TLI', fit_indices.get('tli', None))
        rmsea = fit_indices.get('RMSEA', fit_indices.get('rmsea', None))
        srmr = fit_indices.get('SRMR', fit_indices.get('srmr', None))
        
        issues = []
        
        if cfi is not None and not pd.isna(cfi):
            if cfi < 0.90:
                issues.append("CFI < 0.90，模型拟合较差")
            elif cfi < 0.95:
                issues.append("CFI在0.90-0.95之间，模型拟合可接受")
            else:
                print("✓ CFI > 0.95，模型拟合良好")
        
        if tli is not None and not pd.isna(tli):
            if tli < 0.90:
                issues.append("TLI < 0.90，模型拟合较差")
            else:
                print("✓ TLI > 0.90，模型拟合可接受")
        
        if rmsea is not None and not pd.isna(rmsea):
            if rmsea > 0.08:
                issues.append("RMSEA > 0.08，模型拟合较差")
            elif rmsea > 0.05:
                issues.append("RMSEA在0.05-0.08之间，模型拟合可接受")
            else:
                print("✓ RMSEA < 0.05，模型拟合良好")
        
        if srmr is not None and not pd.isna(srmr):
            if srmr > 0.08:
                issues.append("SRMR > 0.08，模型拟合较差")
            else:
                print("✓ SRMR < 0.08，模型拟合良好")
        
        if issues:
            print("\n⚠ 需要注意的问题:")
            for issue in issues:
                print(f"  - {issue}")
    
    def plot_path_diagram(self, filename='path_diagram.png'):
        """
        绘制路径图
        
        Parameters:
        -----------
        filename : str
            保存的文件名
        """
        if self.model is None:
            print("❌ 请先定义并拟合模型")
            return
        
        try:
            from semopy import semplot
            semplot(self.model, filename)
            print(f"\n✓ 路径图已保存为 {filename}")
        except Exception as e:
            print(f"⚠ 路径图绘制失败: {e}")
            print("提示: 可能需要安装graphviz")
    
    def save_results(self, filename='sem_results.xlsx'):
        """
        保存结果到Excel
        
        Parameters:
        -----------
        filename : str
            保存的文件名
        """
        if self.fit_result is None:
            print("❌ 请先拟合模型")
            return
        
        with pd.ExcelWriter(filename, engine='openpyxl') as writer:
            # 参数估计
            estimates = self.model.inspect()
            estimates.to_excel(writer, sheet_name='参数估计', index=False)
            
            # 拟合指标
            stats = calc_stats(self.model)
            stats.to_excel(writer, sheet_name='拟合指标', index=False)
            
            # 原始数据描述
            self.data.describe().to_excel(writer, sheet_name='描述统计')
        
        print(f"\n✓ 结果已保存为 {filename}")


def example_basic_sem():
    """示例1: 基础SEM分析"""
    print("\n" + "="*60)
    print("示例1: 基础结构方程模型")
    print("="*60)
    
    # 创建分析对象
    sem = SEMAnalysis()
    
    # 生成示例数据
    sem.generate_sample_data(n_samples=300)
    
    # 数据探索
    sem.explore_data()
    
    # 定义模型
    model_spec = """
    # 测量模型（潜变量 =~ 观测变量）
    Satisfaction =~ sat1 + sat2 + sat3
    Quality =~ qual1 + qual2 + qual3
    Loyalty =~ loy1 + loy2 + loy3
    
    # 结构模型（因果关系）
    Loyalty ~ Satisfaction + Quality
    """
    
    sem.define_model(model_spec)
    
    # 拟合模型
    sem.fit_model()
    
    # 显示结果
    sem.show_results()
    
    # 绘制路径图
    sem.plot_path_diagram('example1_path_diagram.png')
    
    # 保存结果
    sem.save_results('example1_results.xlsx')
    
    return sem


def example_mediation_model():
    """示例2: 中介效应模型"""
    print("\n" + "="*60)
    print("示例2: 中介效应模型")
    print("="*60)
    
    sem = SEMAnalysis()
    
    # 生成包含中介变量的数据
    np.random.seed(42)
    n = 300
    
    # X -> M -> Y 的中介模型
    X = np.random.randn(n)
    M = 0.5 * X + np.random.randn(n) * 0.5  # 中介变量
    Y = 0.3 * X + 0.4 * M + np.random.randn(n) * 0.5  # 结果变量
    
    data = pd.DataFrame({
        'x1': X + np.random.randn(n) * 0.2,
        'x2': X + np.random.randn(n) * 0.2,
        'm1': M + np.random.randn(n) * 0.2,
        'm2': M + np.random.randn(n) * 0.2,
        'y1': Y + np.random.randn(n) * 0.2,
        'y2': Y + np.random.randn(n) * 0.2,
    })
    
    sem.data = data
    
    # 定义中介模型
    model_spec = """
    # 测量模型
    X =~ x1 + x2
    M =~ m1 + m2
    Y =~ y1 + y2
    
    # 结构模型（中介效应）
    M ~ X
    Y ~ X + M
    """
    
    sem.define_model(model_spec)
    sem.fit_model()
    sem.show_results()
    
    print("\n中介效应说明:")
    print("- 直接效应: X -> Y")
    print("- 间接效应: X -> M -> Y")
    print("- 总效应 = 直接效应 + 间接效应")
    
    return sem


def main():
    """主函数"""
    print("="*60)
    print("结构方程模型（SEM）分析框架")
    print("="*60)
    
    # 运行示例1
    sem1 = example_basic_sem()
    
    # 运行示例2
    sem2 = example_mediation_model()
    
    print("\n" + "="*60)
    print("分析完成！")
    print("="*60)
    print("\n生成的文件:")
    print("- correlation_matrix.png: 相关系数热力图")
    print("- example1_path_diagram.png: 路径图")
    print("- example1_results.xlsx: 详细结果")


if __name__ == "__main__":
    main()
