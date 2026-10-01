from typing import List
import heapq

class Solution:
    def smallestRange(self, nums: List[List[int]]) -> List[int]:
        # 使用最小堆存储 (value, list_index, element_index_in_list)
        min_heap = []
        # 当前范围的最大值
        current_max = float('-inf')

        # 初始化：将每个列表的第一个元素加入堆，并更新当前最大值
        for i in range(len(nums)):
            # 如果列表非空，则将第一个元素加入堆
            if nums[i]:
                heapq.heappush(min_heap, (nums[i][0], i, 0))
                current_max = max(current_max, nums[i][0])

        # 记录找到的最小范围和对应的左右边界
        smallest_range_diff = float('inf')
        range_start, range_end = -1, -1

        # 当堆中包含来自所有列表的元素时，继续循环
        while len(min_heap) == len(nums):
            # 取出堆中的最小元素 (当前范围的最小值)
            min_val, list_idx, elem_idx = heapq.heappop(min_heap)

            # 更新最小范围
            if current_max - min_val < smallest_range_diff:
                smallest_range_diff = current_max - min_val
                range_start = min_val
                range_end = current_max

            # 找到下一个元素：当前最小元素所在列表的下一个元素
            next_elem_idx = elem_idx + 1

            # 如果当前列表还有下一个元素，则将其加入堆并更新当前最大值
            if next_elem_idx < len(nums[list_idx]):
                next_val = nums[list_idx][next_elem_idx]
                heapq.heappush(min_heap, (next_val, list_idx, next_elem_idx))
                current_max = max(current_max, next_val)
            else:
                # 如果当前列表没有下一个元素，则循环结束
                break

        return [range_start, range_end]
                
if __name__ == "__main__":
    nums = [[4,10,15,24,26], [0,9,12,20], [5,18,22,30]]
    print(Solution().smallestRange(nums))
                
