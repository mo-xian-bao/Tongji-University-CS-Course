#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

class Solution {
   public:
    vector<int> maxSubsequence( vector<int>& nums, vector<int>& queries) {  
        // 输入数组nums和查询数组queries，返回查询数组queries的答案
        int n = nums.size();
        int m = queries.size();
        sort(nums.begin(), nums.end());  // 排序nums
        vector<int> sum(n, 0);           // 数组sum，记录nums的前缀和
        sum[0] = nums[0];
        for (int i = 1; i < n; i++) {  // 计算前缀和
            sum[i] = sum[i - 1] + nums[i];
        }
        vector<int> res(m, -1);  // 数组res，记录查询数组queries的答案
        for (int i = 0; i < m; i++) {
            int l = 0, r = n - 1, mid;
            while (l <= r) {  // 二分查找
                mid = (l + r) / 2;
                if (sum[mid] == queries[i]) {  // 找到queries[i]的位置
                    res[i] = mid + 1;          // 记录答案
                    break;
                } else if (sum[mid] < queries[i]) {  // 右半边
                    l = mid + 1;
                } else {  // 左半边
                    r = mid - 1;
                }
            }
            if (res[i] == -1)
                res[i] = l;  // 若queries[i]不在nums中，则返回nums的最小位置
        }
        return res;
    }
};

int main() {
    int n, m;  // 两个整数n和m，分别表示数组nums和queries的长度
    cin >> n >> m;
    vector<int> nums(n);     // 数组nums的元素
    vector<int> queries(m);  // 数组queries的元素
    for (int i = 0; i < n; i++) {
        cin >> nums[i];
    }
    for (int i = 0; i < m; i++) {
        cin >> queries[i];
    }

    Solution sol;
    vector<int> res = sol.maxSubsequence(nums, queries);
    for (int i = 0; i < m; i++) {
        cout << res[i] << " ";
    }
    cout << endl;

    return 0;
}