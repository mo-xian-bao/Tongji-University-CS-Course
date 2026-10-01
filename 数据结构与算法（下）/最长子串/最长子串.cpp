#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    int longestSubstring(string s, int k) {
        int n=s.length();
        if (n==0 || n<k)
            return 0;
        if (k==1)
            return n;
        
        unordered_map<char,int> count;
        for(char& c:s){
            count[c]++;
        }

        bool flag = true;
        for (auto& pair:count){
            if (pair.second<k){
                flag = false;
                break;
            }
        }

        if (flag == true)
            return n;

        int res = 0;
        int start = 0;
        for(int i = 0; i < n; i++){
            if (count[s[i]] < k) {
                res = max(res, longestSubstring(s.substr(start, i - start), k));
                start = i + 1;
            }
        }

        //处理最后一个子串！！
        if (start < n) {
            res = max(res, longestSubstring(s.substr(start), k));
        }

        return res;
    }
};

// 测试代码
int main() {
    Solution solution;
    string s;
    int k;
    
    cout << "请输入字符串 s: ";
    cin >> s;
    cout << "请输入整数 k: ";
    cin >> k;
    cout << "输出：" << solution.longestSubstring(s, k) << endl;
    
    return 0;
}
