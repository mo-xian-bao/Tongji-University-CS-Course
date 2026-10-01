import heapq
from typing import List

class Solution:
    def scheduleCourse(self, courses: List[List[int]]) -> int:
        # 按截止日期 (lastDay) 升序排序课程
        courses.sort(key=lambda x: x[1])

        # 使用一个最大堆来存储已选课程的持续时间
        taken_courses_durations_max_heap = []
        current_time = 0

        for duration, last_day in courses:
            # 尝试选修当前课程
            current_time += duration
            heapq.heappush(taken_courses_durations_max_heap, -duration) # 存入负值

            # 如果当前总耗时超过了这门课的截止日期
            if current_time > last_day:
                # 放弃耗时最长的那门课
                longest_duration_taken = -heapq.heappop(taken_courses_durations_max_heap)
                current_time -= longest_duration_taken
        
        # 最终最大堆中的元素数量就是可以选修的最多课程数
        return len(taken_courses_durations_max_heap)

if __name__ == '__main__':
    solver = Solution()

    courses1 = [[100, 200], [200, 1300], [1000, 1250], [2000, 3200]]
    print(f"输入: {courses1}, 输出: {solver.scheduleCourse(courses1)}")
