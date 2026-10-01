#include <cstring>  // 使用memset
#include <iostream>
#include <vector>

using namespace std;

const int MAXN = 1000;   // 假设最大节点数
const int MAX_LOG = 10;  // log2(1000)约为10

vector<int> tree[MAXN + 1];     // 用于存储树的邻接表表示
int parent[MAXN + 1][MAX_LOG];  // parent[i][j]表示i节点的第2^j个祖先
int depth[MAXN + 1];            // 存储每个节点的深度
bool isChild[MAXN +
             1];  // isChild[i]表示i是否为某个节点的孩子, 用于判断是否为根节点

// 深度优先搜索函数，用于填充父节点信息和计算节点深度
void dfs(int node, int par) {
    parent[node][0] = par;  // 父节点
    for (int i = 1; i < MAX_LOG; ++i) {
        if (parent[node][i - 1] != -1)  // 如果父节点存在
            parent[node][i] =
                parent[parent[node][i - 1]]
                      [i - 1];  // 则第i个祖先为父节点的第i-1个祖先
        else
            parent[node][i] = -1;
    }

    for (int child : tree[node]) {       // 遍历子节点
        depth[child] = depth[node] + 1;  // 计算子节点的深度
        dfs(child, node);                // 递归处理子节点
    }
}

// 求解两个节点的最近公共祖先（LCA）
// 时间复杂度为 O(log n)
int lca(int u, int v) {
    if (u == v) return u;  // 如果两个节点相同，直接返回

    if (depth[u] < depth[v]) swap(u, v);  // 确保u的深度小于v的深度

    int diff = depth[u] - depth[v];         // 计算深度差
    if (diff > 0) u = parent[u][diff - 1];  // 向上跳v层

    if (u == v) return u;  // 如果u和v相同，说明祖先为v本身

    for (int i = MAX_LOG - 1; i >= 0; --i) {  // 向上跳不同层
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
        memset(isChild, false, sizeof(isChild));

        for (int i = 0; i < N - 1; ++i) {
            int a, b;
            cin >> a >> b;
            isChild[b] = true;
            tree[a].push_back(b);
        }

        // 选择根节点
        int root = 1;
        for (int i = 2; i <= N; i++) {
            if (!isChild[i]) {
                root = i;
                break;
            }
        }
        depth[root] = 0;
        dfs(root, -1);  // 计算深度和祖先

        for (int i = 0; i < M; ++i) {
            int x, y;
            cin >> x >> y;
            cout << lca(x, y) << endl;
        }
    }
    return 0;
}
