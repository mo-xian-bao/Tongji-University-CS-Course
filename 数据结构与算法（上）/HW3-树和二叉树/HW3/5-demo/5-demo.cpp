#include <cstring>  // 使用memset
#include <iostream>
#include <vector>

using namespace std;

const int MAXN = 1000;   // 假设最大节点数
const int MAX_LOG = 10;  // log2(1000)约为10

vector<int> tree[MAXN + 1];
int parent[MAXN + 1][MAX_LOG];  // parent[i][j]表示i节点的第2^j个祖先
int depth[MAXN + 1];

void dfs(int node, int par) {
    parent[node][0] = par;  // 父节点
    for (int i = 1; i < MAX_LOG; ++i) {
        if (parent[node][i - 1] != -1)
            parent[node][i] = parent[parent[node][i - 1]][i - 1];
        else
            parent[node][i] = -1;
    }

    for (int child : tree[node]) {
        if (child != par) {
            depth[child] = depth[node] + 1;
            dfs(child, node);
        }
    }
}

int lca(int u, int v) {
    if (u == v) 
        return u;  // 如果两个节点相同，直接返回

    if (depth[u] < depth[v]) 
        swap(u, v);

    int diff = depth[u] - depth[v];
    for (int i = 0; i < MAX_LOG; ++i)
        if ((diff >> i) & 1) u = parent[u][i];

    if (u == v) 
        return u;

    for (int i = MAX_LOG - 1; i >= 0; --i) {
        if (parent[u][i] != parent[v][i]) {
            u = parent[u][i];
            v = parent[v][i];
        }
    }
    return parent[u][0];
}

int main() {
    int T;
    cin >> T;
    while (T--) {
        int N, M;
        cin >> N >> M;

        // 初始化
        for (int i = 1; i <= N; ++i) {
            tree[i].clear();
        }
        memset(parent, -1, sizeof(parent));
        memset(depth, 0, sizeof(depth));

        int root=0;
        for (int i = 0; i < N - 1; ++i) {
            int a, b;
            cin >> a >> b;
            if (i == 0)
                root = a;
            tree[a].push_back(b);
            tree[b].push_back(a);  // 无向边
        }

        // 选择根节点
        depth[root] = 0;
        dfs(root, -1);   // 计算深度和祖先,第一层祖先为自己

        for (int i = 0; i < M; ++i) {
            int x, y;
            cin >> x >> y;
            cout << "LCA of " << x << " and " << y << " is " << lca(x, y)
                 << endl;
        }
    }
    return 0;
}
