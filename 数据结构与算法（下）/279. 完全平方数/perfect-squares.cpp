#include <iostream>
#include <vector>
#include <cmath>
#include <climits>
using namespace std;

class Solution {
public:
    int numSquares(int n) {
        vector<int> dp(n + 1);
        for (int i = 1; i <= n; i++){
            if(is_perfect_square(i)){
                dp[i] = 1;
            }
            else{
                int m = INT_MAX;
                for (int j = 1; j*j<i;j++){
                    m = min(m, dp[i-j*j]+1);
                }
                dp[i] = m;
            }
        }
        return dp[n];
    }
private:
    bool is_perfect_square(int k)
    {
        int m = sqrt(k);
        return k == m * m;
    }
};

int main()
{
    Solution s;
    cout << s.numSquares(12);

    return 0;
}