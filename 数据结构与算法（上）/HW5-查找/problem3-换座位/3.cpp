#include <unordered_map>
#include <vector>

using namespace std;

class Solution {
   public:
    int solve(std::vector<vector<std::string>> &old_chart, std::vector<std::vector<std::string>> &new_chart) {
        int n = old_chart.size(); 
        int m = old_chart[0].size();
        int res = 0;
        unordered_map<string, pair<int, int>> target_pos;  //记录每位同学的目标座位
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                target_pos[new_chart[i][j]] = make_pair(i, j);  //记录目标座位
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                while (old_chart[i][j] != new_chart[i][j]) {  //如果当前同学的位置与目标位置不同
                    pair<int, int> pos = target_pos[old_chart[i][j]];  //记录当前位置同学的目标座位
                    int x = pos.first;
                    int y = pos.second;
                    //将当前同学换到目标座位
                    string temp = old_chart[i][j]; 
                    old_chart[i][j] = old_chart[x][y];
                    old_chart[x][y] = temp;
                    res++;  //换座位次数+1
                }
            }
        }
        return res;
    }
};