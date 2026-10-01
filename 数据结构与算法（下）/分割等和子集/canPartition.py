class Solution:
    def canPartition(self, nums: List[int]) -> bool:
        # nums为物品的重量和价值
        sum = 0
        for num in nums:
            sum += num
        if sum % 2!= 0:
            return False
        target = sum // 2 # 目标值,看做背包的容量
        # dp[i][j] 表示：，考虑前i个元素，背包容量为j时，最大的价值
        dp = [[0]*(target+1) for _ in range(len(nums)+1)]
        # 填表
        for i in range(1, len(nums)+1):
            for j in range(1, target+1):
                if j < nums[i-1]:
                    dp[i][j] = dp[i-1][j]
                else:
                    dp[i][j] = max(dp[i-1][j], dp[i-1][j-nums[i-1]]+nums[i-1])
        return dp[len(nums)][target] == target # 考虑所有元素，背包容量为target时，是否能达到目标值