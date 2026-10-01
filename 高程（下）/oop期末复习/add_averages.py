# 读取现有文件内容
with open('scores.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# 计算每行的平均值
averages = []
for line in lines:
    scores = [int(x) for x in line.strip().split()]
    avg = sum(scores) / len(scores)
    averages.append(f"{avg:.2f}")

# 将原内容和平均值写回文件
with open('scores.txt', 'w', encoding='utf-8') as f:
    # 写入原始分数
    for line in lines:
        f.write(line.strip() + '\n')
    # 写入平均值
    for avg in averages:
        f.write(avg + '\n') 