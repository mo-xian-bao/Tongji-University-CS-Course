#include <iostream>
#include <stack>
#include <string>
using namespace std;

// 定义树节点
struct TreeNode {
    char value;
    TreeNode* lchild;
    TreeNode* rchild;

    TreeNode(char val)
        : value(val), lchild(nullptr), rchild(nullptr) {}  // 构造函数
};

// 定义栈节点
struct StackNode {
    TreeNode* treeNode;
    StackNode* next;

    StackNode(TreeNode* node) : treeNode(node), next(nullptr) {}
};

// 自定义栈
class Stack {
   public:
    StackNode* topNode;  // 栈顶节点指针

    Stack() : topNode(nullptr) {}  // 构造函数

    // 入栈操作
    void push(TreeNode* node) {
        StackNode* newNode = new StackNode(node);
        newNode->next = topNode;
        topNode = newNode;
    }

    // 出栈操作
    TreeNode* pop() {
        if (topNode == nullptr) {
            return nullptr;
        }
        StackNode* nodeToPop = topNode;
        topNode = topNode->next;
        TreeNode* poppedNode = nodeToPop->treeNode;
        delete nodeToPop;  // 释放内存
        return poppedNode;
    }

    // 判断栈是否为空
    bool isEmpty() { return topNode == nullptr; }
};

// 根据栈操作构建二叉树
TreeNode* buildTree(int count)  // count = 2n
{
    struct VisitNode {
        TreeNode* node;
        bool visited;

        VisitNode(TreeNode* node) : node(node), visited(false) {}
    };

    stack<VisitNode*> nodeStack;  // 节点栈
    string operation;
    char value;
    TreeNode* root = nullptr;
    VisitNode* current = nullptr;

    for (int i = 0; i < count; i++) {
        cin >> operation;
        if (operation == "push") {
            // 提取节点值
            cin >> value;
            TreeNode* newNode = new TreeNode(value);
            if (root == nullptr) {
                root = newNode;  // 根节点为空，则将当前节点设置为根节点
                current = new VisitNode(root);  // 记录当前节点
            }

            else {
                // 如果栈不为空，设置为当前节点的左或右子节点
                if (current->visited == false)
                    current->node->lchild = newNode;
                else
                    current->node->rchild = newNode;
            }
            nodeStack.push(new VisitNode(newNode));  // 将当前节点推入栈中
            current = nodeStack.top();  // 将当前节点设置为新节点
        } else if (operation == "pop") {
            current = nodeStack.top();  // 弹出栈顶节点
            nodeStack.pop();            // 弹出栈顶节点
            current->visited = true;    // 标记当前节点已访问
        }
    }

    return root;  // 返回构建好的树的根节点
}

// 后序遍历
void postOrderTraversal(TreeNode* node) {
    if (node == nullptr) return;
    postOrderTraversal(node->lchild);
    postOrderTraversal(node->rchild);
    cout << node->value;  // 先访问左子树，再访问右子树，最后访问节点本身
}

// 前序遍历
void preOrderTraversal(TreeNode* node) {
    if (node == nullptr) return;
    cout << node->value;  // 先访问节点本身，再访问左子树，最后访问右子树
    preOrderTraversal(node->lchild);
    preOrderTraversal(node->rchild);
}

// 中序遍历
void inOrderTraversal(TreeNode* node) {
    if (node == nullptr) return;
    inOrderTraversal(node->lchild);
    cout << node->value;  // 先访问左子树，再访问节点本身，最后访问右子树
    inOrderTraversal(node->rchild);
}

int main() {
    int n;
    cin >> n;
    TreeNode* root = buildTree(2 * n);
    postOrderTraversal(root);
    cout << endl;
    inOrderTraversal(root);

    return 0;
}