#include <algorithm>
#include <iostream>
#include <queue>
#include <set>
#include <vector>

using namespace std;

// 使用深度优先搜索（DFS）遍历图，获取连通分量
void dfs(int v, const vector<vector<int>>& adj, vector<bool>& visited,
         vector<int>& component) {
    visited[v] = true;             // 标记当前节点已访问
    component.push_back(v);        // 将当前节点加入连通分量
    for (int neighbor : adj[v]) {  // 遍历当前节点的邻居
        if (!visited[neighbor]) {  // 邻居未访问过
            dfs(neighbor, adj, visited, component);  // 递归调用
        }
    }
}

// 使用广度优先搜索（BFS）遍历图，获取连通分量
void bfs(int start, const vector<vector<int>>& adj, vector<bool>& visited,
         vector<int>& component) {
    queue<int> q;   // 队列
    q.push(start);  // 入队
    visited[start] = true;
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        component.push_back(v);
        for (int neighbor : adj[v]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
}

// 查找图中的所有连通分量，使用深度优先搜索（DFS）
vector<vector<int>> findConnectedComponents(const vector<vector<int>>& adj,
                                            int n) {
    vector<vector<int>> components;
    vector<bool> visited(n, false);
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            vector<int> component;            // 连通分量
            dfs(i, adj, visited, component);  // 深度优先搜索
            components.push_back(component);  // 将连通分量加入结果集
        }
    }
    return components;
}

// 查找图中的所有连通分量，使用广度优先搜索（BFS）
vector<vector<int>> findConnectedComponentsBFS(const vector<vector<int>>& adj,
                                               int n) {
    vector<vector<int>> components;
    vector<bool> visited(n, false);
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            vector<int> component;            // 连通分量
            bfs(i, adj, visited, component);  // 广度优先搜索
            components.push_back(component);  // 将连通分量加入结果集
        }
    }
    return components;
}

int main() {
    int n, m;
    cin >> n >> m;

    vector<vector<int>> adj(n);  // 邻接矩阵
    set<pair<int, int>> edges;   // 边集合

    // Read edges
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        if (u != v && edges.find({min(u, v), max(u, v)}) == edges.end()) {
            adj[u].push_back(v);
            adj[v].push_back(u);
            edges.insert({min(u, v), max(u, v)});
        }
    }

    // Sort adjacency lists to ensure we visit the smallest numbered vertex
    // first
    for (int i = 0; i < n; i++) {
        sort(adj[i].begin(), adj[i].end());
    }

    // Find connected components using DFS
    vector<vector<int>> componentsDFS = findConnectedComponents(adj, n);

    // Find connected components using BFS
    vector<vector<int>> componentsBFS = findConnectedComponentsBFS(adj, n);

    // Output results
    // Output DFS results
    for (const auto& component : componentsDFS) {
        cout << "{";
        for (size_t i = 0; i < component.size(); i++) {
            cout << component[i];
            if (i < component.size() - 1) {
                cout << " ";
            }
        }
        cout << "}";
    }
    cout << endl;

    // Output BFS results
    for (const auto& component : componentsBFS) {
        cout << "{";
        for (size_t i = 0; i < component.size(); i++) {
            cout << component[i];
            if (i < component.size() - 1) {
                cout << " ";
            }
        }
        cout << "}";
    }
    cout << endl;

    return 0;
}