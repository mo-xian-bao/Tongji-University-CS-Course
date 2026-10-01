#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    int trainWays(int num) 
    {
        vector<int> memo(num+1,0);
        return recursive(num,memo);
    }
private:
    int recursive(int num,vector<int>& memo)
    {
        if(num<=1)
            return 1;

        if(memo[num]>0)
            return memo[num];
        
        memo[num]=(recursive(num-1,memo)+recursive(num-2,memo))%1000000007;

        return memo[num];
    }
};

int main() {
    int num;
    cout << "请输入平台的格子数量: ";
    cin >> num;
    
    Solution solution;
    int ways = solution.trainWays(num);
    
    cout << ways;
    
    return 0;
}
