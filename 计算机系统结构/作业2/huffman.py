import heapq
from collections import defaultdict, Counter

class Node:
    """哈夫曼树的节点"""
    def __init__(self, char, freq, left=None, right=None):
        self.char = char
        self.freq = freq
        self.left = left
        self.right = right

    # 使节点对象可以通过 heapq 进行比较
    def __lt__(self, other):
        return self.freq < other.freq

def generate_huffman_codes(root, prefix="", code_dict=None):
    """
    通过递归遍历哈夫曼树来生成编码。
    左子树路径为 '0'，右子树路径为 '1'。
    """
    if code_dict is None:
        code_dict = {}
    if root.char is not None:
        code_dict[root.char] = prefix or "0" # 处理只有一个节点的情况
    if root.left is not None:
        generate_huffman_codes(root.left, prefix + "0", code_dict)
    if root.right is not None:
        generate_huffman_codes(root.right, prefix + "1", code_dict)
    return code_dict

def calculate_average_length(data, huffman_codes):
    """计算哈夫曼编码的平均码长"""
    total_length = 0.0
    for char, freq in data.items():
        total_length += freq * len(huffman_codes[char])
    return total_length

def huffman_coding(data):
    """
    主函数，接收一个包含字符及其频率的字典。
    返回：哈夫曼编码表，平均码长，以及树的根节点。
    """
    if len(data) == 0:
        return {}, 0.0, None
    
    priority_queue = [Node(char, freq) for char, freq in data.items()]
    heapq.heapify(priority_queue)

    if len(priority_queue) == 1:
        # 特殊情况：如果只有一个符号，直接返回根节点
        root = priority_queue[0]
        codes = {root.char: "0"}
        avg_length = calculate_average_length(data, codes)
        return codes, avg_length, root

    while len(priority_queue) > 1:
        left_child = heapq.heappop(priority_queue)
        right_child = heapq.heappop(priority_queue)
        merged_freq = left_child.freq + right_child.freq
        merged_node = Node(None, merged_freq, left_child, right_child)
        heapq.heappush(priority_queue, merged_node)

    root = priority_queue[0]
    huffman_codes = generate_huffman_codes(root)
    avg_length = calculate_average_length(data, huffman_codes)
    
    return huffman_codes, avg_length, root

# --- 新增的可视化函数 ---
def _visualize_tree_recursive(node, prefix, is_last):
    """递归辅助函数，用于打印树的结构"""
    if node is not None:
        # 打印当前节点信息
        # 叶子节点显示字符和频率，内部节点只显示频率总和
        if node.char is not None:
            node_label = f"['{node.char}' | Freq: {node.freq:.2f}]"
        else:
            node_label = f"(Sum: {node.freq:.2f})"
        
        # 打印连接符和节点标签
        print(prefix + ("└── " if is_last else "├── ") + node_label)
        
        # 为子节点准备新的前缀
        new_prefix = prefix + ("    " if is_last else "│   ")
        
        # 递归打印子节点（始终先打印左子树，再打印右子树）
        # 右子树是最后一个分支，所以 is_last=True
        _visualize_tree_recursive(node.left, new_prefix, False)
        _visualize_tree_recursive(node.right, new_prefix, True)

def visualize_huffman_tree(root):
    """可视化哈夫曼树的主函数"""
    if root is not None:
        print("--- 哈夫曼树结构图 ---")
        # 直接从根节点开始打印，初始前缀为空
        _visualize_tree_recursive(root, "", True)
    else:
        print("树为空，无法可视化。")

# --- 示例使用 ---
instruction_frequencies = {
    'I1 (0.15)': 0.15, 'I2 (0.15)': 0.15, 'I3 (0.14)': 0.14,
    'I4 (0.13)': 0.13, 'I5 (0.12)': 0.12, 'I6 (0.11)': 0.11,
    'I7 (0.04)': 0.04, 'I8 (0.04)': 0.04, 'I9 (0.03)': 0.03,
    'I10 (0.03)': 0.03, 'I11 (0.02)': 0.02, 'I12 (0.02)': 0.02,
    'I13 (0.01)': 0.01, 'I14 (0.01)': 0.01,
}

# 执行哈夫曼编码，并接收返回的树根节点
codes, avg_len, tree_root = huffman_coding(instruction_frequencies)

# --- 打印结果 ---
print("--- 哈夫曼编码表 ---")
sorted_codes = sorted(codes.items(), key=lambda item: (instruction_frequencies[item[0]], len(item[1])), reverse=True)
for char, code in sorted_codes:
    print(f"指令: {char:<12} | 频率: {instruction_frequencies[char]:.2f} | 编码: {code:<8} | 码长: {len(code)}")

print("\n--- 平均码长 ---")
print(f"计算得出的平均码长为: {avg_len:.4f}")

# 调用新的可视化函数来打印树
print("\n") # 添加一个换行符，使输出更清晰
visualize_huffman_tree(tree_root)