import tkinter as tk
from tkinter import messagebox
import heapq # 用于优先队列
import time
import math
import random

# --- 默认参数 ---
DEFAULT_ROWS = 9
DEFAULT_COLS = 8
DEFAULT_START_POS = (2, 3)
DEFAULT_END_POS = (4, 7)

# 预定义网格 (用于第一次运行)
GRID = [
    [0, 0, 0, 0, 0, 0, 0, 0], # Row 0
    [0, 1, 1, 1, 1, 0, 0, 0], # Row 1
    [0, 1, 0, 0, 1, 0, 0, 0], # Row 2 (S at 2,3)
    [0, 1, 0, 0, 1, 0, 0, 0], # Row 3
    [0, 0, 0, 0, 1, 0, 0, 0], # Row 4 (E at 4,7)
    [0, 0, 0, 0, 1, 0, 0, 0], # Row 5
    [0, 0, 0, 0, 1, 0, 0, 0], # Row 6
    [0, 1, 1, 1, 1, 0, 0, 0], # Row 7
    [0, 0, 0, 0, 0, 0, 0, 0], # Row 8
]

# 颜色定义
COLORS = {
    "free": "white",        # 可通行区域
    "obstacle": "blue",       # 障碍物
    "start": "red",         # 起点
    "end": "yellow",          # 终点
    "visited": "orange",      # 已访问节点
    "queued": "lightgray",    # 待访问节点
    "path": "green",        # 最短路径
}

# Tkinter 可视化参数
CELL_SIZE = 30          
DELAY_MS = 50           # 动画延迟
TEXT_COLOR = "black"     # 文本颜色
path = []                # 储存最终路径

# --- 函数：生成随机网格 ---
def generate_random_grid(rows, cols, obstacle_density=0.3, start=DEFAULT_START_POS, end=DEFAULT_END_POS):
    """生成一个具有随机障碍物的网格 (不保证起点终点可达或有解)"""
    grid = [[0 for _ in range(cols)] for _ in range(rows)] # 初始化全为 0
    for r in range(rows):
        for c in range(cols):
            # 根据密度随机放置障碍物
            if random.random() < obstacle_density and (r, c) != start and (r, c) != end:
                grid[r][c] = 1 # 1 表示障碍物
    return grid

# --- 辅助函数 ---
def update_cell(canvas, row, col, color):
    """更新画布上指定格子的颜色"""
    x1 = col * CELL_SIZE
    y1 = row * CELL_SIZE
    x2 = x1 + CELL_SIZE
    y2 = y1 + CELL_SIZE
    canvas.delete(f"cell_{row}_{col}")
    canvas.create_rectangle(x1, y1, x2, y2, fill=color, outline="black", tags=(f"cell_{row}_{col}", "cell"))

def update_cell_with_text(canvas, row, col, color, text):
    """更新画布上指定格子的颜色并在中心绘制文本"""
    update_cell(canvas, row, col, color)
    x_center = col * CELL_SIZE + CELL_SIZE / 2
    y_center = row * CELL_SIZE + CELL_SIZE / 2
    canvas.delete(f"text_{row}_{col}")
    canvas.create_text(x_center, y_center, text=str(text), fill=TEXT_COLOR, tags=(f"text_{row}_{col}", "text"))

def draw_grid(canvas, grid, start_pos, end_pos):
    """绘制初始网格状态"""
    canvas.delete("cell")
    canvas.delete("text")

    rows, cols = len(grid), len(grid[0])
    for r in range(rows):
        for c in range(cols):
            pos = (r, c)
            if pos == start_pos:
                update_cell_with_text(canvas, r, c, COLORS['start'], "S")
            elif pos == end_pos:
                update_cell_with_text(canvas, r, c, COLORS['end'], "E")
            else:
                update_cell(canvas, r, c, COLORS['free'] if grid[r][c] == 0 else COLORS['obstacle'])

# --- A* 算法函数 ---
def heuristic(pos1, pos2):
    """计算曼哈顿距离作为启发式函数 H"""
    r1, c1 = pos1
    r2, c2 = pos2
    return abs(r1 - r2) + abs(c1 - c2)

# A* 算法
def astar(grid_data, start, end, canvas, root_window):
    """执行 A* 搜索并可视化过程"""
    global path
    path.clear()

    rows, cols = len(grid_data), len(grid_data[0])

    open_set_heap = [(0, start)] # 优先队列，存储待扩展节点
    open_set_hash = {start} # 集合，存储已扩展节点
    parent = {start: None} # 字典，存储每个节点的父节点
    g_score = { (r, c): float('inf') for r in range(rows) for c in range(cols) } # 字典，存储每个节点到起点的距离
    g_score[start] = 0 # 起点到起点的距离为0
    f_score = { (r, c): float('inf') for r in range(rows) for c in range(cols) } # 字典，存储每个节点到终点的距离
    f_score[start] = heuristic(start, end) # 起点到终点的距离

    path_found = False
    
    while open_set_heap:
        current_f, current_pos = heapq.heappop(open_set_heap) # 从优先队列中取出f值最小的节点
        if current_pos not in open_set_hash:
            continue # 如果当前节点不在已扩展节点集合中，则跳过
        open_set_hash.remove(current_pos) # 从已扩展节点集合中移除当前节点

        current_row, current_col = current_pos

        # 已访问节点涂色并显示与起点的距离
        if current_pos != start and current_pos != end:
            update_cell_with_text(canvas, current_row, current_col, COLORS['visited'], g_score[current_pos])
            root_window.update_idletasks()
            root_window.after(DELAY_MS)

        # 找到终点，执行回溯
        if current_pos == end:
            path_found = True
            path_len = 0
            temp_current = end

            while temp_current is not None: # 从终点开始回溯
                path.insert(0, temp_current) # 将当前节点插入路径列表的开头
                parent_node = parent.get(temp_current) # 获取当前节点的父节点
                if parent_node is not None: # 如果父节点存在
                    path_len += 1 # 路径长度加1
                    if temp_current != end and temp_current != start: # 如果当前节点不是终点或起点
                        g_val = g_score.get(temp_current, '?') # 获取当前节点到起点的距离
                        update_cell_with_text(canvas, temp_current[0], temp_current[1], COLORS['path'], g_val) # 更新当前节点的颜色为路径颜色，并显示距离
                        root_window.update_idletasks()
                        root_window.after(DELAY_MS)
                temp_current = parent_node # 更新当前节点为父节点

            messagebox.showinfo("完成", f"已找到最优路径！长度为: {path_len}")
            break

        # 扩展
        for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            new_row, new_col = current_row + dr, current_col + dc # 计算邻居节点的坐标
            neighbor = (new_row, new_col)

            if 0 <= new_row < rows and 0 <= new_col < cols and grid_data[new_row][new_col] == 0:
                tentative_g_score = g_score[current_pos] + 1 # 计算邻居节点到起点的距离
                if tentative_g_score < g_score[neighbor]:
                    parent[neighbor] = current_pos # 更新邻居节点的父节点为当前节点
                    g_score[neighbor] = tentative_g_score # 更新邻居节点到起点的距离
                    f_score[neighbor] = tentative_g_score + heuristic(neighbor, end) # 计算邻居节点到终点的距离
                    if neighbor not in open_set_hash: # 如果邻居节点不在待扩展节点集合中
                        heapq.heappush(open_set_heap, (f_score[neighbor], neighbor)) # 将邻居节点加入优先队列
                        open_set_hash.add(neighbor) # 将邻居节点加入已扩展节点集合
                        # 待扩展节点涂色
                        if neighbor != end:
                            update_cell(canvas, new_row, new_col, COLORS['queued'])
                            root_window.update_idletasks()
                            root_window.after(DELAY_MS // 2)

    if not path_found:
        print("未找到路径!")
        messagebox.showinfo("结果", "无法从起点到达终点。")

# --- 主程序入口 ---
if __name__ == "__main__":
    for i in range(3):
        current_rows = DEFAULT_ROWS
        current_cols = DEFAULT_COLS
        current_start_pos = DEFAULT_START_POS
        current_end_pos = DEFAULT_END_POS
        current_grid = GRID
        title_suffix = " (预定义地图)"

        if i > 0: # 第二次和第三次循环使用随机参数
            # 随机确定尺寸
            current_rows = random.randint(20, 30)
            current_cols = random.randint(20, 30)

            # 随机确定起点和终点，确保不重复且在界内
            while True:
                r_start = random.randint(0, current_rows - 1)
                c_start = random.randint(0, current_cols - 1)
                current_start_pos = (r_start, c_start)

                r_end = random.randint(0, current_rows - 1)
                c_end = random.randint(0, current_cols - 1)
                current_end_pos = (r_end, c_end)

                if heuristic(current_start_pos, current_end_pos) > 10:
                    break 

            # 生成随机网格
            density = 0.3
            current_grid = generate_random_grid(current_rows, current_cols, density, current_start_pos, current_end_pos)

            # 确保起点和终点是可通行的
            current_grid[current_start_pos[0]][current_start_pos[1]] = 0
            current_grid[current_end_pos[0]][current_end_pos[1]] = 0

            title_suffix = f" (随机地图 {i}, {current_rows}x{current_cols}, S:{current_start_pos}, E:{current_end_pos}, 密度 {density:.2f})"

        # --- 创建 Tkinter 窗口和组件 ---
        root = tk.Tk()
        root.title("机器人寻径避障" + title_suffix)

        # 根据当前尺寸计算画布大小
        canvas_width = current_cols * CELL_SIZE
        canvas_height = current_rows * CELL_SIZE

        canvas = tk.Canvas(root, width=canvas_width, height=canvas_height, borderwidth=0, highlightthickness=0)
        canvas.pack(pady=10, padx=10)

        # 绘制当前网格
        draw_grid(canvas, current_grid, current_start_pos, current_end_pos)

        # 创建启动按钮，使用 lambda 的默认参数捕获当前迭代的参数
        start_button = tk.Button(root, text="开始寻路", command=lambda grid=current_grid, start=current_start_pos, end=current_end_pos, r=root, c=canvas: astar(grid, start, end, c, r))
        start_button.pack(pady=10)

        # 启动 Tkinter 主事件循环
        root.mainloop()

        # 在 Tkinter 窗口关闭后打印路径
        print("path:", path)