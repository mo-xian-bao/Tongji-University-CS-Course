// 本题的本质为最小生成树
// 算法1：Prim算法，适用于稠密图
// 算法2：Kruskal算法，适用于稀疏图
// 本题使用Kruskal算法，时间复杂度O(ElogE)，E为边数，稀疏图时比Prim算法更快
#include <algorithm>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <queue>
#include <vector>

using namespace std;

// 数据结构设计
struct Edge {          // 边
    int u, v, weight;  // u -> v, weight w
    Edge(int u, int v, int w) : u(u), v(v), weight(w) {}
};

vector<vector<int>> G;  // 邻接矩阵
vector<Edge> E;         // 边集

// 并查集
class UnionFind {
   private:
    vector<int> parent;  // 父节点
   public:
    UnionFind(int n) : parent(n) {  // 初始化, 每个节点的父节点为自身
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    int find(int x) {  // 路径压缩
        if (parent[x] == x) {
            return x;
        }
        return find(parent[x]);  // 递归查找父节点
    }

    void unionSets(int x, int y) {  // 合并两个集合
        int px = find(x);
        int py = find(y);
        if (px != py) {
            parent[px] = py;  // 合并两个集合
        }
    }
};

// Kruskal算法求最小生成树
int kruskal(int n, vector<Edge>& edges) {
    UnionFind uf(n);
    sort(edges.begin(), edges.end(),
         [](Edge a, Edge b) { return a.weight < b.weight; });  // 按权重排序

    int totalWeight = 0;
    for (const Edge& edge : edges) {               // 遍历所有边
        if (uf.find(edge.u) != uf.find(edge.v)) {  // 若不属于同一集合
            uf.unionSets(edge.u, edge.v);          // 合并两个集合
            totalWeight += edge.weight;            // 加权重
        }
    }
    return totalWeight;
}

int main() {
    int n;  // 节点数
    cin >> n;
    G.resize(n, vector<int>(n));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cin >> G[i][j];
            if (i < j) {
                E.push_back(Edge(i, j, G[i][j]));  // 构造边集
            }
        }
    }

    int m;  // 已经修路的村庄数量
    cin >> m;
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;                   // 转换为0-index
        E.push_back({u - 1, v - 1, 0});  // 已经修路的边权重为0
    }

    int totalWeight = kruskal(n, E);
    cout << totalWeight << endl;

    return 0;
}