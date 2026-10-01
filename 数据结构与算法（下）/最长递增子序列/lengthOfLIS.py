class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        if not nums: # 空列表
            return 0
        dp = [1] * len(nums) # dp[i]表示以nums[i]结尾的最长递增子序列的长度
        for i in range(1, len(nums)):
            for j in range(i):
                if nums[i] > nums[j]:
                    dp[i] = max(dp[i], dp[j] + 1)
        return max(dp) # 返回最长递增子序列的长度 