#include <algorithm>
#include <cstring>
#include <iostream>
#include <limits>
#include <queue>
#include <stack>
#include <vector>
using namespace std;

#define MAXN 1005  // 最大顶点数
const int INF = numeric_limits<int>::max();

// 数据结构定义
struct Edge {
    int dest;    // 目的顶点
    int weight;  // 边的权值
    Edge(int _dest, int _weight) : dest(_dest), weight(_weight) {}  // 构造函数
};
vector<Edge> G[MAXN];  // 邻接表
int dist[MAXN][MAXN];  // dist[i][j] 表示从i到j的最短路径

// Dijkstra算法求最短路径
void dijkstra(int start) {
    fill(dist[start], dist[start] + MAXN, INF);  // 初始化dist数组
    priority_queue<pair<int, int>, vector<pair<int, int>>,
                   greater<pair<int, int>>>
        pq;                  // 优先队列
    pq.push({0, start});     // 初始源点到源点的距离为0
    dist[start][start] = 0;  // 初始源点到源点的距离为0

    while (!pq.empty()) {
        int u = pq.top().second;  // 取出当前最小距离的顶点
        int d = pq.top().first;   // 取出当前最小距离
        pq.pop();                 // 弹出当前顶点

        if (d > dist[start][u]) continue;  // 如果距离大于当前最短距离，则跳过

        for (int i = 0; i < G[u].size(); i++) {
            int v = G[u][i].dest;    // 遍历u的邻居
            int w = G[u][i].weight;  // 遍历u的邻居的权值
            if (dist[start][u] + w <
                dist[start][v]) {  // 如果经过u的距离更短，则更新距离
                dist[start][v] = dist[start][u] + w;  // 更新距离
                pq.push({dist[start][v], v});         // 加入优先队列
            }
        }
    }
}

int main() {
    int N, M;  // 顶点数，边数
    cin >> N >> M;
    for (int i = 0; i < M; i++) {
        int u, v, w;
        cin >> u >> v >> w;
        G[u].push_back(Edge(v, w));
        G[v].push_back(Edge(u, w));  // 无向图，加一条反向边
    }

    int H, R;  // 草地数,小马数
    cin >> H >> R;
    vector<int> grass;  // 草地数组
    for (int i = 0; i < H; i++) {
        int x;
        cin >> x;
        grass.push_back(x);
    }

    vector<pair<int, int>> house( R);  // 每个小马的初始位置和目标位置(需要求能经过草地的最短路径)
    for (int i = 0; i < R; i++) {
        int x, y;
        cin >> x >> y;
        house[i] = make_pair(x, y);
    }

    for (int i = 0; i < MAXN; i++) {
        if (!G[i].empty()) {
            dijkstra(i);
        }
    }

    for (int i = 0; i < R; i++) {
        int x = house[i].first;
        int y = house[i].second;
        int ans = INF;
        for (int j = 0; j < H; j++) {
            ans = min(ans, dist[x][grass[j]] + dist[grass[j]][y]);
        }
        cout << ans << endl;
    }

    return 0;
}