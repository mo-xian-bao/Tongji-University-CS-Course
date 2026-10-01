/**
 * @file    template.cpp
 * @name    p138模板程序
 * @date    2022-11-20
 */

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <stack>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

/********************************/
/*     以下是你需要提交的代码     */
/********************************/
class Solution {
   public:
    int solve(std::vector<vector<std::string>> &old_chart,
              std::vector<std::vector<std::string>> &new_chart) {
        int n = old_chart.size();
        int m = old_chart[0].size();
        int res = 0;
        unordered_map<string, pair<int, int>> target_pos;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                target_pos[new_chart[i][j]] = make_pair(i, j);
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                while (old_chart[i][j] != new_chart[i][j]) {
                    pair<int, int> pos = target_pos[old_chart[i][j]];
                    int x = pos.first;
                    int y = pos.second;
                    string temp = old_chart[i][j];
                    old_chart[i][j] = old_chart[x][y];
                    old_chart[x][y] = temp;
                    res++;
                }
            }
        }
        return res;
    }
};
/********************************/
/*     以上是你需要提交的代码     */
/********************************/

int main() {
    int n, m;
    std::cin >> n >> m;
    std::vector<std::vector<std::string>> old_chart(n, std::vector<std::string>(m));  //原先的座位表
    std::vector<std::vector<std::string>> new_chart(n, std::vector<std::string>(m));  //目标座位表

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            std::cin >> old_chart[i][j];
        }
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            std::cin >> new_chart[i][j];
        }
    }

    Solution s;
    std::cout << s.solve(old_chart, new_chart) << std::endl;
    return true;
}
