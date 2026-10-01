import tkinter as tk
from tkinter import messagebox
import heapq # 用于优先队列
import time
import math

# 网格尺寸
ROWS = 9
COLS = 8

# 起点和终点坐标 (行, 列)
START_POS = (2, 3)
END_POS = (4, 7)

# 网格定义 (0: 可通行, 1: 障碍物)
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
    "visited": "orange", # 已访问节点
    "queued": "lightgray",  # 待访问节点
    "path": "green",        # 最短路径
}

# Tkinter 可视化参数
CELL_SIZE = 40          # 每个格子的像素大小
DELAY_MS = 100          # 动画延迟
TEXT_COLOR = "black"     # 文本颜色
path = []                # 储存最终路径

def update_cell(canvas, row, col, color):
    """更新画布上指定格子的颜色"""
    x1 = col * CELL_SIZE
    y1 = row * CELL_SIZE
    x2 = x1 + CELL_SIZE
    y2 = y1 + CELL_SIZE
    canvas.create_rectangle(x1, y1, x2, y2, fill=color, outline="black", tags=f"cell_{row}_{col}")

def update_cell_with_text(canvas, row, col, color, text):
    """更新画布上指定格子的颜色并在中心绘制文本"""
    update_cell(canvas, row, col, color)
    x_center = col * CELL_SIZE + CELL_SIZE / 2
    y_center = row * CELL_SIZE + CELL_SIZE / 2
    canvas.create_text(x_center, y_center, text=str(text), fill=TEXT_COLOR, tags=f"text_{row}_{col}")

def draw_grid(canvas, grid, start_pos, end_pos):
    """绘制初始网格状态"""
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
    """执行 A* 搜索并可视化过程 (包含路径回溯)"""
    global path 
    rows, cols = len(grid_data), len(grid_data[0])

    open_set_heap = [(0, start)]
    open_set_hash = {start} # 用于检查节点是否在 open_set_heap 中
    parent = {start: None} # 起点的父节点设为 None
    # g_socre 储存从起点到当前节点的实际代价
    g_score = { (r, c): float('inf') for r in range(rows) for c in range(cols) }
    g_score[start] = 0
    # f_score 储存从起点到当前节点实际代价加上启发式估计的总代价
    f_score = { (r, c): float('inf') for r in range(rows) for c in range(cols) }
    f_score[start] = heuristic(start, end)

    path_found = False

    while open_set_heap:
        # 从 open_set_heap 中弹出当前 f_score 最小的节点
        current_f, current_pos = heapq.heappop(open_set_heap)
        # 如果当前节点不在 open_set_hash 中，说明已经访问过，跳过
        if current_pos not in open_set_hash:
            continue
        # 从 open_set_hash 中移除当前节点
        open_set_hash.remove(current_pos)

        current_row, current_col = current_pos

        # 已访问节点涂色
        if current_pos != start and current_pos != end:
            update_cell_with_text(canvas, current_row, current_col, COLORS['visited'], g_score[current_pos])
            root_window.update_idletasks()
            root_window.after(DELAY_MS)

        # 找到终点，执行回溯
        if current_pos == end:
            path_found = True

            path_len = 0
            temp_current = end # 从终点开始回溯

            while temp_current is not None:
                path.insert(0, temp_current) # 头插
                parent_node = parent.get(temp_current)

                if parent_node is not None: # 只要不是起点就有父节点过来的一步
                    path_len += 1
                    # 可视化路径节点 (绿色), 并显示 g_score
                    if temp_current != end and temp_current != start: # 不覆盖起点和终点原始颜色
                        g_val = g_score.get(temp_current, '?')
                        update_cell_with_text(canvas, temp_current[0], temp_current[1], COLORS['path'], g_val)
                        root_window.update_idletasks()
                        root_window.after(DELAY_MS)
                        
                temp_current = parent_node # 移动到父节点

            messagebox.showinfo("完成", f"已找到最优路径！长度为: {path_len}")
            break

        # 扩展
        for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            new_row, new_col = current_row + dr, current_col + dc
            neighbor = (new_row, new_col)

            if 0 <= new_row < rows and 0 <= new_col < cols and grid_data[new_row][new_col] == 0:
                tentative_g_score = g_score[current_pos] + 1

                if tentative_g_score < g_score[neighbor]:
                    parent[neighbor] = current_pos
                    g_score[neighbor] = tentative_g_score
                    f_score[neighbor] = tentative_g_score + heuristic(neighbor, end)

                    if neighbor not in open_set_hash:
                        heapq.heappush(open_set_heap, (f_score[neighbor], neighbor))
                        open_set_hash.add(neighbor)

                        # 待扩展节点涂色
                        if neighbor != end:
                            update_cell(canvas, new_row, new_col, COLORS['queued'])
                            root_window.update_idletasks()
                            root_window.after(DELAY_MS)

    if not path_found:
        print("未找到路径!")
        messagebox.showinfo("结果", "无法从起点到达终点。")

# --- 主程序入口 ---
if __name__ == "__main__":
    for i in range(3):
        root = tk.Tk()
        if i == 0:
            root.title("机器人寻径避障")
        else:
            root.title("机器人寻径避障" + "复杂随机路径" + str(i))

        canvas_width = COLS * CELL_SIZE
        canvas_height = ROWS * CELL_SIZE

        # 创建画布
        canvas = tk.Canvas(root, width=canvas_width, height=canvas_height, borderwidth=0, highlightthickness=0)
        canvas.pack(pady=10, padx=10)

        # 绘制初始网格
        draw_grid(canvas, GRID, START_POS, END_POS)

        # 创建启动按钮
        start_button = tk.Button(root, text="开始寻路", command=lambda: astar(GRID, START_POS, END_POS, canvas, root))
        start_button.pack(pady=10)

        # 启动 Tkinter 主事件循环
        root.mainloop()

        # 在 Tkinter 窗口关闭后打印路径
        print("path:", path) 