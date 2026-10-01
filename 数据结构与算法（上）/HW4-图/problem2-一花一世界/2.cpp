#include <iomanip>
#include <iostream>
#include <queue>
#include <vector>
using namespace std;
#define MAXN 2050

// 数据结构设计
vector<int> adj[MAXN];  // 邻接表
bool visited[MAXN];     // 访问标记

// 广度优先搜索,求距离不超过6的顶点数
int bfs(int start, int n) {
    int res = 0;  // 起始点
    int distance = 0;
    queue<int> q;
    q.push(start);
    visited[start] = true;

    // 层次化遍历
    while (!q.empty() && distance <= 6) {
        int levelSize = q.size();  // 当前层的节点数量
        for (int i = 0; i < levelSize; i++) {
            int v = q.front();
            q.pop();
            res++;  // 每处理一个顶点，结果计数加1
            for (int j : adj[v]) {
                if (!visited[j]) {
                    visited[j] = true;
                    q.push(j);
                }
            }
        }
        distance++;  // 处理完当前层后，再递增距离
    }
    return res;
}

int main() {
    // 输入节点数和边数
    int n, m;
    cin >> n >> m;

    // 输入邻接表
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);  // 无向图
    }

    for (int i = 0; i < n; i++) {
        fill(visited, visited + n + 1, false);  // 初始化访问标记
        int res = bfs(i + 1, n);
        float ratio =
            (float)res / n;  // 计算距离不超过6的顶点数占所有顶点数的比例
        cout << i + 1 << ": " << fixed << setprecision(2) << ratio * 100 << "%"
             << endl;
    }
    return 0;
}
