#include <cstring>
#include <iostream>
#include <queue>
#include <stack>
#include <vector>
using namespace std;

// 定义树结点元素类型
typedef int TElemType;

// 定义二叉树结点结构
typedef struct BiTreeNode {
    TElemType value;     // 树结点的值
    bool visited;        // 标记该结点是否被访问过
    BiTreeNode* lchild;  // 指向左子结点
    BiTreeNode* rchild;  // 指向右子结点
    BiTreeNode* parent;  // 指向父结点

    // 构造函数
    BiTreeNode(TElemType val)
        : value(val),
          lchild(nullptr),
          rchild(nullptr),
          parent(nullptr),
          visited(false) {}
}* BiTree;

// 创建二叉树的函数
vector<BiTree> CreateTree(int n) {
    vector<BiTree> nodes(n);  // 用于存储节点指针
    for (int i = 0; i < n; ++i) {
        nodes[i] = new BiTreeNode(i);  // 创建节点并初始化编号
    }

    for (int i = 0; i < n; ++i) {
        int left, right;
        cin >> left >> right;  // 输入左、右孩子编号

        if (left != -1) {
            nodes[i]->lchild = nodes[left];  // 将左孩子指向该节点
            nodes[left]->parent = nodes[i];  // 将该节点的父节点指向左孩子
        }
        if (right != -1) {
            nodes[i]->rchild = nodes[right];  // 将右孩子指向该节点
            nodes[right]->parent = nodes[i];  // 将该节点的父节点指向右孩子
        }
    }

    return nodes;  // 返回根节点
}

// 实现广度优先搜索算法，用于在二叉树中查找节点，并计算感染时间
int BFS(vector<BiTree> nodes, int start) {
    queue<BiTree> q;
    q.push(nodes[start]);
    int time = -1;

    while (!q.empty()) {
        int currentLevelSize = q.size();  // 当前层的节点数

        for (int i = 0; i < currentLevelSize; i++) {
            BiTree node = q.front();
            q.pop();

            if (node->visited == false) {
                node->visited = true;  // 标记 node 为已访问

                if (node->lchild != nullptr && node->lchild->visited == false) {
                    q.push(node->lchild);  // 如果 node
                                           // 的左子节点存在且未被访问,将node
                                           // 的左子节点入队 q
                }
                if (node->rchild != nullptr && node->rchild->visited == false) {
                    q.push(node->rchild);  // 如果 node
                                           // 的右子节点存在且未被访问,将node
                                           // 的右子节点入队 q
                }
                if (node->parent != nullptr && node->parent->visited == false) {
                    q.push(node->parent);  // 如果 node
                                           // 的父节点存在且未被访问,将node
                                           // 的父节点入队 q
                }
            }
        }
        time++;  // 每处理完一层，time自增
    }
    return time;
}

int main() {
    int n, start;
    cin >> n >> start;  // 输入树的结点数和起始搜索结点编号

    vector<BiTree> nodes = CreateTree(n);  // 创建二叉树

    // 输出二叉树结构
    // for (int i = 0; i < n; ++i) {
    //    cout << nodes[i]->value << " " << nodes[i]->visited << " "
    //         << (nodes[i]->lchild == nullptr ? -1 : nodes[i]->lchild->value)
    //        << " "
    //         << (nodes[i]->rchild == nullptr ? -1 : nodes[i]->rchild->value)
    //         << " "
    //         << (nodes[i]->parent == nullptr ? -1 : nodes[i]->parent->value)
    //         << endl;
    //}
    // cout << endl;

    int time = BFS(nodes, start);  // 计算感染需要的时间

    cout << time << endl;  // 输出感染需要的时间

    return 0;
}
