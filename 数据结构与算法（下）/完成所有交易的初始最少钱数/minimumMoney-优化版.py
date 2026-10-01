from typing import List

class Solution:
    def minimumMoney(self, transactions: List[List[int]]) -> int:
        res = 0
        max_cost = 0
        max_cashback = 0
        for i in range(len(transactions)):
            if transactions[i][0] > transactions[i][1]:
                res += transactions[i][0] - transactions[i][1]
                max_cashback = max(max_cashback, transactions[i][1])
            else:
                max_cost = max(max_cost, transactions[i][0])
        return res + max(max_cost, max_cashback)

if __name__ == "__main__":
    transactions = [[7,2],[0,10],[5,0],[4,1],[5,8],[5,9]]
    print(Solution().minimumMoney(transactions))
