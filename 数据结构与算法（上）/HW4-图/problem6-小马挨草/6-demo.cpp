#include <iostream>
#include <limits>
#include <queue>
#include <vector>

using namespace std;

const int INF = numeric_limits<int>::max();

struct Edge {
    int to, weight;
    Edge(int t, int w) : to(t), weight(w) {}
};

void dijkstra(int start, const vector<vector<Edge>>& graph, vector<int>& dist) {
    int n = graph.size();
    dist.assign(n, INF);
    dist[start] = 0;
    priority_queue<pair<int, int>, vector<pair<int, int>>,
                   greater<pair<int, int>>>
        pq;
    pq.push({0, start});

    while (!pq.empty()) {
        int d = pq.top().first;
        int u = pq.top().second;
        pq.pop();

        if (d > dist[u]) continue;

        for (const Edge& edge : graph[u]) {
            int v = edge.to;
            int w = edge.weight;
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.push({dist[v], v});
            }
        }
    }
}

int main() {
    int N, M;
    cin >> N >> M;
    vector<vector<Edge>> graph(N + 1);

    for (int i = 0; i < M; ++i) {
        int x, y, w;
        cin >> x >> y >> w;
        graph[x].emplace_back(y, w);
        graph[y].emplace_back(x, w);
    }

    int H, R;
    cin >> H >> R;
    vector<int> grassPoints(H);
    for (int i = 0; i < H; ++i) {
        cin >> grassPoints[i];
    }

    vector<pair<int, int>> ponies(R);
    for (int i = 0; i < R; ++i) {
        cin >> ponies[i].first >> ponies[i].second;
    }

    for (int i = 0; i < R; ++i) {
        int start = ponies[i].first;
        int end = ponies[i].second;
        vector<int> distStart, distEnd;

        dijkstra(start, graph, distStart);
        dijkstra(end, graph, distEnd);

        int minDistance = INF;
        for (int grass : grassPoints) {
            if (distStart[grass] != INF && distEnd[grass] != INF) {
                minDistance =
                    min(minDistance, distStart[grass] + distEnd[grass]);
            }
        }

        cout << minDistance << endl;
    }

    return 0;
}
