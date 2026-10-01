from typing import List

class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        count = 1
        state = 0 # 0: 初始状态, 1: 上升, -1: 下降
        for i in range(1, len(nums)):
            if state == 0:
                if nums[i] > nums[i-1]:
                    state = 1
                    count += 1
                elif nums[i] < nums[i-1]:
                    state = -1
                    count += 1
            elif state == 1:
                if nums[i] < nums[i-1]:
                    state = -1
                    count += 1
            elif state == -1:
                if nums[i] > nums[i-1]:
                    state = 1
                    count += 1
        return count
    
if __name__ == "__main__":
    nums = [1,17,5,10,13,15,10,5,16,8]
    print(Solution().wiggleMaxLength(nums))
