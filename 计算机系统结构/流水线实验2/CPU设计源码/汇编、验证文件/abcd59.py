# 计算数组 A, B, C, D 的值

# 初始化
A = [0] * 60
B = [0] * 60
C = [0] * 60
D = [0] * 60

# 初始值
A[0] = 0
B[0] = 1

# 计算 A[i] 和 B[i]
for i in range(1, 60):
    A[i] = A[i-1] + i
    B[i] = B[i-1] + 3 * i

# 计算 C[i] 和 D[i]
for i in range(60):
    if 0 <= i <= 19:
        C[i] = A[i]
        D[i] = B[i]
    elif 20 <= i <= 39:
        C[i] = A[i] + B[i]
        D[i] = A[i] * C[i]
    else:  # 40 <= i <= 59
        C[i] = A[i] * B[i]
        D[i] = C[i] * B[i]

# 输出结果
print(f"A[59] = {A[59]} (0x{A[59]:X})")
print(f"B[59] = {B[59]} (0x{B[59]:X})")
print(f"C[59] = {C[59]} (0x{C[59]:X})")
print(f"D[59] = {D[59]} (0x{D[59]:X})")
