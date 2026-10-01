#include <bits/stdc++.h>
using namespace std;

class Solution {
    public:
        vector<vector<string>> partition(string s) {
            path.clear();
            res.clear();
            backtrack(s);
            return res;
        }
    private:
        vector<string> path;
        vector<vector<string>> res;
        void backtrack(string s)
        {
            if(s.size()==0){
                res.push_back(path);
                return;
            }
            for (int i = 0; i < s.size();i++){
                if(is_palindrome(s.substr(0,i+1))){
                    path.push_back(s.substr(0, i + 1));
                    backtrack(s.substr(i + 1));
                    path.pop_back();
                }
            }
        }
        bool is_palindrome(string s)
        {
            string _s = s;
            reverse(_s.begin(), _s.end());
            return s == _s;
        }
};

int main()
{
    Solution s;
    vector<vector<string>> res = s.partition("aab");
    for(auto& v : res) {
        for(auto& str : v) {
            cout << str << " ";
        }
        cout << endl;
    }

    return 0;
}