#include <algorithm>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

// 拓扑排序
bool topo(int k, int num, vector<pair<int, int>>& Conditions, vector<int>& list) {
    vector<int> indegree(k, 0);  // 储存每个顶点的入度
    vector<vector<int>> edg(k);  // 储存每个顶点的出边
    for (auto& p : Conditions) {
        indegree[p.second]++;  // 入度+1
        edg[p.first].push_back(p.second); 
    }
    queue<int> q;
    for (int i = 0; i < k; i++) {
        if (indegree[i] == 0) q.push(i); // 入度为0的顶点入队列
    }
    int cnt = 0;
    while (!q.empty()) {
        int u = q.front();   // 取出队首顶点
        q.pop();
        list[cnt++] = u;   // 加入拓扑排序序列
        for (int v : edg[u]) {  // 遍历u的出边
            indegree[v]--;
            if (indegree[v] == 0) q.push(v); // 入度为0的顶点入队列
        }
    }
    if (cnt != k) return false; // 有环，无法拓扑排序
    return true;
}
// 构造矩阵
void buildMatrix(int k, vector<vector<int>>& matrix, vector<int>& rowlist, vector<int>& collist) {
    for (int i = 0; i < k; i++) {
        int row, col;
        for (int j = 0; j < k; j++) {
            if (i == rowlist[j]) {  // 找到行i在矩阵中的位置
                row = j;
                break;
            }
        }
        for (int j = 0; j < k; j++) {
            if (i == collist[j]) {  // 找到列i在矩阵中的位置
                col = j;
                break;
            }
        }
        matrix[row][col] = i + 1;
    }
}

int main() {
    int k, n, m;
    cin >> k >> n >> m;

    vector<pair<int, int>> rowConditions(n);           // 行条件
    vector<pair<int, int>> colConditions(m);           // 列条件
    vector<vector<int>> matrix(k, vector<int>(k, 0));  // 矩阵
    vector<int> rowlist(k);                            // 行拓扑排序
    vector<int> collist(k);                            // 列拓扑排序

    for (int i = 0; i < n; i++) {
        int u, v;
        cin >> u >> v;
        rowConditions[i] = make_pair(u - 1, v - 1);
    }
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        colConditions[i] = make_pair(u - 1, v - 1);
    }

    if (!topo(k, n, rowConditions, rowlist) ||
        !topo(k, m, colConditions, collist)) {
        cout << "-1" << endl;
    } else {
        buildMatrix(k, matrix, rowlist, collist);
        for (int i = 0; i < k; i++) {
            for (int j = 0; j < k; j++) {
                cout << matrix[i][j] << " ";
            }
            cout << endl;
        }
    }

    return 0;
}