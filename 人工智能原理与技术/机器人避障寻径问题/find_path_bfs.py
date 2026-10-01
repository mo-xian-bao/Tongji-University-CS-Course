# -*- coding: utf-8 -*-
import tkinter as tk
from tkinter import messagebox
from collections import deque
import time

# 场景图参数
ROWS = 9 # 行数 
COLS = 8 # 列数
START_POS = (2, 3) # 起点坐标
END_POS = (4, 7) # 终点坐标
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
DELAY_MS = 100           # 动画延迟（毫秒）
TEXT_COLOR = "black"     # 文本颜色
path = []                # 储存最终路径

def update_cell(canvas, row, col, color):
    """更新画布上指定格子的颜色"""
    x1 = col * CELL_SIZE
    y1 = row * CELL_SIZE
    x2 = x1 + CELL_SIZE
    y2 = y1 + CELL_SIZE
    canvas.create_rectangle(x1, y1, x2, y2, fill=color, outline="black")

def update_cell_with_text(canvas, row, col, color, text):
    """更新画布上指定格子的颜色并在中心绘制文本"""
    update_cell(canvas, row, col, color)
    # 计算中心点坐标
    x_center = col * CELL_SIZE + CELL_SIZE / 2
    y_center = row * CELL_SIZE + CELL_SIZE / 2
    # 绘制文本
    canvas.create_text(x_center, y_center, text=str(text), fill=TEXT_COLOR)


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


# BFS 算法与可视化
def bfs(grid_data, start, end, canvas):
    rows, cols = len(grid_data), len(grid_data[0]) # 网格的行数和列数
    # 队列存储 (row, col, distance)
    queue = deque([(start[0], start[1], 0)])
    visited = {start}                # 存储已访问节点位置 (row, col)
    parent = {start: None}           # 字典方式存储路径，key=子节点, value=父节点
    distances = {start: 0}           # 存储距离 { (row, col): distance }

    path_found = False

    while queue:
        current_row, current_col, current_distance = queue.popleft()
        current_pos = (current_row, current_col)

        # 将当前处理的节点标记为 'visited' (浅蓝色) 并显示距离
        if current_pos != start and current_pos != end:
            update_cell_with_text(canvas, current_row, current_col, COLORS['visited'], current_distance)
            root.update_idletasks()
            root.after(DELAY_MS) 

        # 检查是否到达终点
        if current_pos == end:
            path_found = True
            break # 找到终点，跳出循环

        # 探索邻居节点 (上, 下, 左, 右)
        for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            new_row, new_col = current_row + dr, current_col + dc
            neighbor = (new_row, new_col)

            # 检查边界条件
            if 0 <= new_row < rows and 0 <= new_col < cols:
                # 检查是否可通行且未被访问
                if grid_data[new_row][new_col] == 0 and neighbor not in visited:
                    visited.add(neighbor)
                    parent[neighbor] = current_pos # 记录父节点
                    new_distance = current_distance + 1
                    distances[neighbor] = new_distance # 记录距离
                    queue.append((new_row, new_col, new_distance)) # 加入队列

                    # 可视化：将新加入队列的节点标记为 'queued' (灰色)
                    if neighbor != end:
                         update_cell(canvas, new_row, new_col, COLORS['queued']) # 仅更新颜色，不加文字
                         root.update_idletasks() # 处理挂起的UI事件
                         root.after(DELAY_MS)

    # 循环结束，说明要么找到路径
    if path_found:
        # 从终点开始回溯
        path_node = end
        while path_node != None:
            path.insert(0, path_node)
            r, c = path_node
            # 可视化：将路径节点标记为 'path' (绿色)
            if path_node != end and path_node != start:
                update_cell_with_text(canvas, r, c, COLORS['path'], distances.get(path_node, '?'))
                root.update_idletasks()
                root.after(DELAY_MS)
            # 移动到父节点
            path_node = parent.get(path_node)

        update_cell_with_text(canvas, end[0], end[1], COLORS['end'], distances.get(end, 'E'))
        canvas.update()
        messagebox.showinfo("找到路径!", f"已找到最短路径！长度为: {distances.get(end, '未知')}")
    # 要么队列为空即无路径
    else:
        messagebox.showinfo("未找到路径!", "无法从起点到达终点。")

# --- 主程序入口 ---
if __name__ == "__main__":
    root = tk.Tk()
    root.title("机器人寻径避障")

    canvas_width = COLS * CELL_SIZE
    canvas_height = ROWS * CELL_SIZE

    # 创建画布
    canvas = tk.Canvas(root, width=canvas_width, height=canvas_height, borderwidth=0, highlightthickness=0)
    canvas.pack(pady=10, padx=10)

    # 绘制初始网格
    draw_grid(canvas, GRID, START_POS, END_POS)

    # 创建启动按钮
    start_button = tk.Button(root, text="开始寻路", command=lambda: bfs(GRID, START_POS, END_POS, canvas))
    start_button.pack(pady=10)

    # 启动 Tkinter 主事件循环
    root.mainloop()
    
    # 打印路径
    print("path:", path)

