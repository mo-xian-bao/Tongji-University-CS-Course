from typing import List

class Solution:
    def findMinimumTime(self, tasks: List[List[int]]) -> int:
        # 按结束时间排序
        tasks.sort(key=lambda x: x[1])

        current_time = 0

        #标记数组
        total_end_time = tasks[-1][1]
        mark = [0] * (total_end_time + 1)

        for task in tasks:
            start_time = task[0]
            end_time = task[1]
            duration = task[2]
            for i in range(start_time, end_time + 1):
                if mark[i] == 1:
                    duration -= 1
            
            i = 0
            while duration > 0:
                if mark[end_time - i] == 0:  # 只标记未被标记的时间点
                    mark[end_time - i] = 1
                    duration -= 1
                i += 1
        
        for i in range(total_end_time + 1):
            if mark[i] == 1:
                current_time += 1

        return current_time

if __name__ == "__main__":
    tasks1 = [[1,18,5],[3,15,1]]
    solution = Solution()
    print(solution.findMinimumTime(tasks1))
    tasks2 = [[1,3,2],[2,5,3],[5,6,2]]
    print(solution.findMinimumTime(tasks2))

