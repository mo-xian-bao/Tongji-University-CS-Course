import random
import os
import time

class Student:
    def __init__(self, student_id, name, chinese_score, math_score, english_score):
        self.student_id = student_id
        self.name = name
        self.chinese_score = int(chinese_score)
        self.math_score = int(math_score)
        self.english_score = int(english_score)
        self.total_score = self.chinese_score + self.math_score + self.english_score
        self.rank = 0

    def __repr__(self):
        return f"Student({self.student_id}, {self.name}, C:{self.chinese_score}, M:{self.math_score}, E:{self.english_score}, Total:{self.total_score}, Rank:{self.rank})"

    def scores_equal(self, other_student):
        """比较当前学生与另一个学生的所有成绩是否完全相同（用于排名）"""
        return (self.total_score == other_student.total_score and
                self.chinese_score == other_student.chinese_score and
                self.math_score == other_student.math_score and
                self.english_score == other_student.english_score)

def generate_score(mean=110, std_dev=20, min_score=0, max_score=150):
    """生成一个在[min_score, max_score]范围内的整数分数，模拟正态分布。"""
    score = random.gauss(mean, std_dev) # 生成正态分布的随机数
    score = round(score) # 四舍五入成整数
    score = max(min_score, min(max_score, score)) # 确保分数在[min_score, max_score]范围内
    return int(score) 

def generate_student_data(num_students, filename="student_scores.txt"):
    """生成学生数据并写入文件。"""
    # 确保目标目录存在
    directory = os.path.dirname(filename)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)

    with open(filename, "w", encoding="utf-8") as f:
        f.write("考号,姓名,语文,数学,英语\n") # 表头
        for i in range(num_students):
            student_id = f"S{str(i+1).zfill(4)}"
            name = f"学生{i+1}" 

            chinese = generate_score()
            math = generate_score()
            english = generate_score()
            
            f.write(f"{student_id},{name},{chinese},{math},{english}\n")
    print(f"{num_students} 名学生数据已生成并写入 '{filename}'")

def read_student_data(filename="student_scores.txt"):
    """从文件读取学生数据。"""
    students = []
    if not os.path.exists(filename):
        print(f"错误: 数据文件 '{filename}' 未找到。请先生成数据。")
        return students

    with open(filename, "r", encoding="utf-8") as f:
        lines = f.readlines()
        if len(lines) <= 1: # 至少要有表头和一行数据
            print(f"文件 '{filename}' 为空或只有表头。")
            return students

        # 跳过表头
        for line_number, line in enumerate(lines[1:], start=2):
            parts = line.strip().split(',')
            student_id, name, chinese_str, math_str, english_str = parts
            chinese = int(chinese_str)
            math = int(math_str)
            english = int(english_str)
            students.append(Student(student_id, name, chinese, math, english))

    return students

def partition(arr, low, high, key_func):
    """快速排序的划分函数。"""
    pivot = arr[low]
    pivot_value = key_func(pivot)

    while low < high:
        while key_func(arr[high]) <= pivot_value and low < high:
            high -= 1
        arr[low] = arr[high]
        while key_func(arr[low]) >= pivot_value and low < high:
            low += 1
        arr[high] = arr[low]

    arr[low] = pivot
    return low

def quick_sort(arr, low, high, key_func):
    """快速排序算法实现。"""
    if low < high:
        pi = partition(arr, low, high, key_func)
        quick_sort(arr, low, pi - 1, key_func)
        quick_sort(arr, pi + 1, high, key_func)
    return arr

def get_top_m_students_with_min_heap(all_students, m, key_func_select):
    # 找最大的 m 个学生，使用小顶堆，自定义实现
    # 时间复杂度 O(n log m)，空间复杂度 O(m)
    min_heap = []
    for student in all_students:
        if len(min_heap) < m:
            min_heap.append(student)
            k = len(min_heap) - 1
            while k > 0:
                parent = (k - 1) // 2
                if key_func_select(min_heap[k]) < key_func_select(min_heap[parent]):
                    min_heap[k], min_heap[parent] = min_heap[parent], min_heap[k]
                    k = parent
                else:
                    break
        else:
            if key_func_select(student) > key_func_select(min_heap[0]):
                min_heap[0] = student
                k = 0
                while True:
                    left_child = 2 * k + 1
                    right_child = 2 * k + 2
                    smallest = k
                    if left_child < m and key_func_select(min_heap[left_child]) < key_func_select(min_heap[smallest]):
                        smallest = left_child
                    if right_child < m and key_func_select(min_heap[right_child]) < key_func_select(min_heap[smallest]):
                        smallest = right_child
                    if smallest == k:
                        break
                    min_heap[k], min_heap[smallest] = min_heap[smallest], min_heap[k]
                    k = smallest

    return min_heap


def rank_students(students, key_func_for_sort):
    """对学生列表进行排序和排名。"""

    quick_sort(students, 0, len(students) - 1, key_func_for_sort)

    if not students:
        return

    # 分配排名
    current_rank_value = 1
    students[0].rank = current_rank_value
    for i in range(1, len(students)):
        if not students[i].scores_equal(students[i-1]):
            current_rank_value = i + 1
        students[i].rank = current_rank_value

def write_ranked_students_to_file(students, filename):
    """将排名后的学生列表写入文件，使用固定宽度对齐。"""

    directory = os.path.dirname(filename)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)

    with open(filename, "w", encoding="utf-8") as f:
        header_line = f"{'排名':<4}{'考号':<8}{'姓名':<12}{'总分':<4}{'语文':<4}{'数学':<4}{'英语'}\n"
        f.write(header_line)
        separator_line = "-" * (len(header_line.strip()) + 20) + "\n"
        f.write(separator_line)
        for s in students:
            line = f"{s.rank:<6}{s.student_id:<10}{s.name:<12}{s.total_score:<6}{s.chinese_score:<6}{s.math_score:<6}{s.english_score:<6}\n"
            f.write(line)
        print(f"排名结果已成功写入到文件: '{filename}'")

def main():
    output_dir = "student_system_output"
    os.makedirs(output_dir, exist_ok=True)
    print(f"所有输出文件将保存在目录: '{os.path.abspath(output_dir)}'")

    key_for_ranking_sort = lambda s: (s.total_score, s.chinese_score, s.math_score, s.english_score)

    print("\n请选择操作模式:")
    print("1. n较小 (1-50,000): 全部排序")
    print("2. n较大: 输入n和m, 求前m名考生")
    
    choice = input("请输入选项 (1 或 2): ")

    if choice == '1':
        print("\n--- 模式1: n较小，性能分析 ---")
        n_values = [1000, 5000, 10000, 20000, 30000, 40000, 50000]
        # n_values = [100, 200, 500] 
        recorded_times = []
        
        for n_val in n_values:
            print(f"\n处理 n = {n_val}...")
            data_filename = os.path.join(output_dir, f"student_scores_n{n_val}.txt")
            
            generate_student_data(n_val, data_filename)
            students_list = read_student_data(data_filename)

            start_time = time.time()
            # 调用 rank_students, 使用快速排序
            rank_students(students_list,  key_for_ranking_sort)
            end_time = time.time()
            duration = end_time - start_time
            recorded_times.append(duration)
            print(f"n={n_val} 的排序和排名耗时: {duration:.4f} 秒")
            # 排名结果写入文件
            ranked_output_filename = os.path.join(output_dir, f"ranked_students_n{n_val}.txt")
            write_ranked_students_to_file(students_list, ranked_output_filename)
               

        # 生成时间记录文件
        times_log_filename = os.path.join(output_dir, "sorting_times_log.txt")
        with open(times_log_filename, "w", encoding="utf-8") as log_f:
            log_f.write("N_Students,Sorting_Time_Seconds\n") # 表头
            for n_val, time_val in zip(n_values, recorded_times):
                log_f.write(f"{n_val},{time_val:.4f}\n")
        print(f"\n排序时间数据已保存到: '{times_log_filename}'")

    elif choice == '2':
        print("\n--- 模式2: n较大，查询前m名 ---")
        while True:
            try:
                n_large = int(input("请输入一个较大的学生总数 n (例如 100000): "))
                if n_large > 0:
                    break
                else:
                    print("n 必须为正整数。")
            except ValueError:
                print("无效输入，请输入一个数字。")
        
        while True:
            try:
                m_top = int(input(f"请输入需要查询的前 m 名学生数量 (m < {n_large}): "))
                if 0 < m_top < n_large:
                    break
                elif m_top >= n_large:
                    print(f"m ({m_top}) 必须远小于 n ({n_large})。")
                else:
                    print("m 必须为正整数。")
            except ValueError:
                print("无效输入，请输入一个数字。")

        data_filename = os.path.join(output_dir, f"student_scores_n{n_large}_large.txt")
        ranked_output_filename = os.path.join(output_dir, f"ranked_top_{m_top}_from_{n_large}.txt")

        print(f"\n为 {n_large} 名学生生成数据...")
        generate_student_data(n_large, data_filename)
        
        print("读取学生数据...")
        all_students = read_student_data(data_filename)

        print(f"从 {len(all_students)} 名学生中查找前 {m_top} 名")
            
        # 使用基于小顶堆的方法选出前 m 名候选学生
        top_m_candidates = get_top_m_students_with_min_heap(all_students, m_top, key_for_ranking_sort)
        rank_students(top_m_candidates,  key_for_ranking_sort)
    
        write_ranked_students_to_file(top_m_candidates, ranked_output_filename)
            
    else:
        print("无效选项。程序退出。")

if __name__ == "__main__":
    main() 