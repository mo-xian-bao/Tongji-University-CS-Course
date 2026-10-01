#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

// 边的结构体
struct Edge {
    int u, v, weight;
};

// 并查集
class UnionFind {
   public:
    UnionFind(int n) {
        parent.resize(n);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    int find(int u) {
        if (parent[u] != u) {
            parent[u] = find(parent[u]);  // 路径压缩
        }
        return parent[u];
    }

    void unionSets(int u, int v) {
        int rootU = find(u);
        int rootV = find(v);
        if (rootU != rootV) {
            parent[rootU] = rootV;  // 合并
        }
    }

   private:
    vector<int> parent;
};

// Kruskal算法求最小生成树
int kruskal(int n, vector<Edge>& edges) {
    UnionFind uf(n);
    sort(edges.begin(), edges.end(),
         [](Edge a, Edge b) { return a.weight < b.weight; });  // 按权重排序

    int totalWeight = 0;
    for (const Edge& edge : edges) {
        if (uf.find(edge.u) != uf.find(edge.v)) {
            uf.unionSets(edge.u, edge.v);
            totalWeight += edge.weight;
        }
    }
    return totalWeight;
}

int main() {
    int n;  // 村庄数量
    cin >> n;

    vector<vector<int>> G(n, vector<int>(n));
    vector<Edge> edges;  // 用于存储所有边

    // 读取距离矩阵
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cin >> G[i][j];
            if (i < j) {  // 只存储一半的矩阵
                edges.push_back({i, j, G[i][j]});
            }
        }
    }

    int m;  // 已经修路的村庄数量
    cin >> m;
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        u--;
        v--;                         // 转换为0-index
        edges.push_back({u, v, 0});  // 已经修路的边权重为0
    }

    int ans = kruskal(n, edges);  // 计算最小生成树的权值
    cout << ans << endl;

    return 0;
}