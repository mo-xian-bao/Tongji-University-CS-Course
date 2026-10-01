import functools
from typing import List

class Solution:
    def compare(self, item1, item2):
        a,b = item1
        c,d = item2
        if a == c and b == d:
            return 0
        
        con1 = a > b and c <= d
        con2 = a > b and c > d and b < d
        con3 = a <= b and c <= d and a > c
        
        if con1 or con2 or con3:
            return -1
        else:
            return 1
        
    def minimumMoney(self, transactions: List[List[int]]) -> int:
        transactions.sort(key=functools.cmp_to_key(self.compare))
        # print(transactions)
        res = 0
        for i in range(len(transactions)):
            if transactions[i][0] > transactions[i][1]:
                res += transactions[i][0] - transactions[i][1]
                if i == len(transactions) - 1:
                    res += transactions[i][1]
            else:
                if i == 0:
                    res += transactions[i][0]
                    break
                else:
                    res += max(transactions[i][0], transactions[i-1][1])
                    break
        return res


if __name__ == "__main__":
    transactions = [[7,2],[0,10],[5,0],[4,1],[5,8],[5,9]]
    print(Solution().minimumMoney(transactions))

