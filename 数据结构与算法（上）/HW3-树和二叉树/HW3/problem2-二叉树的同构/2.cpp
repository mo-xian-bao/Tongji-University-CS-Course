#include <algorithm>
#include <cstring>  // 使用memset
#include <iostream>
#include <vector>

using namespace std;

const int MAXN = 20000;  // 定义最大节点数

vector<int> tree1[MAXN];  // 用于存储树1的邻接表
vector<int> tree2[MAXN];  // 用于存储树2的邻接表
char value1[MAXN];        // 存储树1节点的值
char value2[MAXN];        // 存储树2节点的值
bool isChild1[MAXN];      // 标记树1的节点是否为子节点
bool isChild2[MAXN];      // 标记树2的节点是否为子节点

// 计算树的深度
int GetDepth(int root, int index) {
    int maxDepth = 0;
    if (index == 1) {
        if (tree1[root].empty()) {
            return 0;
        }

        for (int i = 0; i < tree1[root].size(); i++) {
            int child = tree1[root][i];
            int childDepth = GetDepth(child, index);
            if (childDepth > maxDepth) {
                maxDepth = childDepth;
            }
        }
    } else if (index == 2) {
        if (tree2[root].empty()) {
            return 0;
        }

        for (int i = 0; i < tree2[root].size(); i++) {
            int child = tree2[root][i];
            int childDepth = GetDepth(child, index);
            if (childDepth > maxDepth) {
                maxDepth = childDepth;
            }
        }
    }
    return maxDepth + 1;
}

bool Isomorphic(int root1, int root2)  // 判断两棵树是否同构
{
    // 给容器中子节点排序
    vector<int> child1(tree1[root1].begin(), tree1[root1].end());
    vector<int> child2(tree2[root2].begin(), tree2[root2].end());
    sort(child1.begin(), child1.end());
    sort(child2.begin(), child2.end());

    // 判断根节点是否相同
    if (value1[root1] != value2[root2]) {
        // cout<<"e1"<<endl;
        return false;
    }

    // 判断子树是否相同
    if (child1.size() != child2.size()) {
        // cout<<"e2"<<endl;
        return false;
    }
    for (int i = 0; i < child1.size(); i++) {
        if (value1[child1[i]] != value2[child2[i]]) {
            // cout<<"e3"<<endl;
            return false;
        }
    }

    // 递归判断子树是否同构
    for (int i = 0; i < child1.size(); i++) {
        if (Isomorphic(child1[i], child2[i]) == false) {
            // cout<<"e4"<<endl;
            return false;
        }
    }
    return true;
}

int main() {
    int n1, n2;  // 两颗树的结点数
    char val;
    string left, right;
    int root1 = -1, root2 = -1;

    memset(value1, 0, sizeof(value1));
    memset(value2, 0, sizeof(value2));
    memset(isChild1, false, sizeof(isChild1));
    memset(isChild2, false, sizeof(isChild2));
    for (int i = 0; i < MAXN; i++) {
        tree1[i].clear();
        tree2[i].clear();
    }

    cin >> n1;
    for (int i = 0; i < n1; i++) {
        cin >> val;
        value1[i] = val;

        cin >> left >> right;
        if (left != "-") {
            tree1[i].push_back(atoi(left.c_str()));
            isChild1[atoi(left.c_str())] = true;
        }
        if (right != "-") {
            tree1[i].push_back(atoi(right.c_str()));
            isChild1[atoi(right.c_str())] = true;
        }
    }
    for (int i = 0; i < n1; i++) {
        if (isChild1[i] == false) {
            root1 = i;
            break;
        }
    }

    cin >> n2;
    for (int i = 0; i < n2; i++) {
        cin >> val;
        value2[i] = val;

        cin >> left >> right;
        if (left != "-") {
            tree2[i].push_back(atoi(left.c_str()));
            isChild2[atoi(left.c_str())] = true;
        }
        if (right != "-") {
            tree2[i].push_back(atoi(right.c_str()));
            isChild2[atoi(right.c_str())] = true;
        }
    }
    for (int i = 0; i < n2; i++) {
        if (isChild2[i] == false) {
            root2 = i;
            break;
        }
    }

    // 打印容器
    // for (int i = 0; i < n1; i++) {
    //     cout << i << " " << value1[i] << " " << tree1[i].size() << " ";
    //     for (int j = 0; j < tree1[i].size(); j++) {
    //         cout << tree1[i][j] << " ";
    //     }
    //     cout << endl;
    // }
    // for (int i = 0; i < n2; i++) {
    //     cout << i << " " << value2[i] << " " << tree2[i].size() << " ";
    //     for (int j = 0; j < tree2[i].size(); j++) {
    //         cout << tree2[i][j] << " ";
    //     }
    //     cout << endl;
    // }
    // cout << "root1: " << root1 << endl;
    // cout << "root2: " << root2 << endl;

    if (Isomorphic(root1, root2))
        cout << "Yes" << endl;
    else
        cout << "No" << endl;

    cout << GetDepth(root1, 1) + 1 << endl;
    cout << GetDepth(root2, 2) + 1 << endl;

    return 0;
}