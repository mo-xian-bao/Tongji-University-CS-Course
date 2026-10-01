#include <algorithm>
#include <cmath>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <queue>
#include <stack>
#include <vector>

using namespace std;

class Solution {
   public:
    // 求最早开始时间
    int Ve(int n, vector<vector<int>>& reCondition, vector<int>& ve,
           vector<int>& time) {
        for (int i = 0; i < n; i++) {
            ve[i] = 0;  // 最早开始时间初始化为0
        }
        vector<int> indegree(n, 0);  // 入度初始化为0
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < reCondition[i].size(); j++) {
                indegree[reCondition[i][j]]++;  // 计算每个课程的入度
            }
        }
        queue<int> q;  // 队列
        for (int i = 0; i < n; i++) {
            if (indegree[i] == 0) {  // 如果入度为0，则将其加入队列
                q.push(i);
            }
        }
        while (!q.empty()) {  // 队列不为空
            int u = q.front();
            q.pop();
            for (int i = 0; i < reCondition[u].size();
                 i++) {  // 遍历u的后修课程
                int v = reCondition[u][i];
                indegree[v]--;           // 入度减1
                if (indegree[v] == 0) {  // 如果入度为0，则将其加入队列
                    q.push(v);
                }
                if (ve[v] < ve[u] + time[u]) {
                    // 如果v的最早开始时间小于u的最早开始时间加上u的持续时间，则更新v的最早开始时间
                    ve[v] = ve[u] + time[u];
                }
            }
        }
        return *max_element(ve.begin(), ve.end());  // 返回最早开始时间
    }

    // 求最晚开始时间
    void Vl(int n, vector<vector<int>>& Condition, vector<int>& vl,
            vector<int>& time, int maxVe) {
        vector<int> outdegree(n, 0);  // 出度初始化为0
        vl.assign(n, maxVe);  // 最晚开始时间初始化为最大的最早开始时间
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < Condition[i].size(); j++) {
                outdegree[Condition[i][j]]++;  // 计算每个课程的出度
            }
        }
        stack<int> s;  // 栈
        for (int i = 0; i < n; i++) {
            if (outdegree[i] == 0) {  // 如果出度为0，则将其加入栈
                s.push(i);
            }
        }
        while (!s.empty()) {  // 栈不为空
            int u = s.top();
            s.pop();
            for (int i = 0; i < Condition[u].size(); i++) {  // 遍历u的先修课程
                int v = Condition[u][i];
                outdegree[v]--;           // 出度减1
                if (outdegree[v] == 0) {  // 如果出度为0，则将其加入栈
                    s.push(v);
                }
                if (vl[v] > vl[u] - time[v]) {
                    // 如果v的最晚开始时间大于u的最晚开始时间减去u的持续时间，则更新v的最晚开始时间
                    vl[v] = vl[u] - time[v];
                }
            }
        }
    }
};

int main() {
    Solution s;

    int n;  // 课程数
    cin >> n;

    vector<vector<int>> Condition(n);    // 课程的先修课程
    vector<vector<int>> reCondition(n);  // 课程的后修课程
    vector<int> ve(n, 0);                // 最早开始时间
    vector<int> vl(n, 0);                // 最晚开始时间
    vector<int> time(n);                 // 课程持续时间

    for (int i = 0; i < n; i++) {
        cin >> time[i];
        int m;
        cin >> m;
        for (int j = 0; j < m; j++) {
            int k;
            cin >> k;
            Condition[i].push_back(k - 1);
            reCondition[k - 1].push_back(i);
        }
    }

    int maxVe = s.Ve(n, reCondition, ve, time);  // 求最早开始时间
    s.Vl(n, Condition, vl, time, maxVe);         // 求最晚开始时间

    // 求每门课的最早完成时间
    for (int i = 0; i < n; i++) {
        cout << ve[i] + time[i] << " ";
        cout << (vl[i] - ve[i] > 0 ? 0 : 1) << endl;
    }

    return 0;
}