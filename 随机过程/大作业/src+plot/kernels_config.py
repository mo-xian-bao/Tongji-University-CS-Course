"""
GPR核函数配置 - 对应实验报告 4.4 节
"""
from sklearn.gaussian_process.kernels import (
    RBF,
    Matern,
    RationalQuadratic,
    ExpSineSquared,
    WhiteKernel,
    ConstantKernel as C
)

# 定义 4 个核函数
kernels_dict = {
    # 模型 A (基准): RBF (平滑)
    'Model_A_RBF': C(1.0) * RBF(length_scale=1.0) + WhiteKernel(noise_level=1e-5),
    
    # 模型 B (粗糙度): Matern 3/2 (随机游走特征)
    'Model_B_Matern': C(1.0) * Matern(length_scale=1.0, nu=1.5) + WhiteKernel(noise_level=1e-5),
    
    # 模型 C (结构化): Matern 3/2 + RQ (加法: 短期波动 + 长期趋势)
    'Model_C_Structural': C(1.0) * Matern(length_scale=1.0, nu=1.5) + \
                          C(1.0) * RationalQuadratic(length_scale=1.0, alpha=0.1) + \
                          WhiteKernel(noise_level=1e-5),
    
    # 模型 D (准周期): RQ * Periodic (乘法: 随时间演变的周期)
    'Model_D_QuasiPeriodic': C(1.0) * RationalQuadratic(length_scale=1.0, alpha=0.1) * \
                              ExpSineSquared(length_scale=1.0, periodicity=30.0) + \
                              WhiteKernel(noise_level=1e-5)
}

if __name__ == "__main__":
    print("核函数配置 (对应报告4.4节):")
    for name, kernel in kernels_dict.items():
        print(f"\n{name}: {kernel}")
