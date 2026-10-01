#include <cstring>
#include <iostream>
using namespace std;

// 定义树节点结构体
struct TreeNode {
    char value;        // 节点值
    TreeNode* lchild;  // 左子节点指针
    TreeNode* rchild;  // 右子节点指针

    // 构造函数
    TreeNode(char val) : value(val), lchild(nullptr), rchild(nullptr) {}
};

// 通过前序和中序创建二叉树
bool Error;
TreeNode* createTree(char* preorder, char* inorder, int preorderSize,
                     int inorderSize) {
    if (preorderSize == 0 || inorderSize == 0) {
        return nullptr;
    }

    TreeNode* root = new TreeNode(preorder[0]);  // 创建根节点
    // 寻找根节点在中序遍历中的位置
    int index = 0, i;
    for (i = 0; i < inorderSize; i++) {
        if (inorder[i] == root->value) {
            index = i;
            break;
        }
    }
    if (i == inorderSize) {  // 根节点不存在于中序遍历中, 输入错误
        Error = true;
        return nullptr;
    }

    // 递归创建左右子树
    root->lchild = createTree(preorder + 1, inorder, preorderSize - 1, index);
    root->rchild =
        createTree(preorder + index + 1, inorder + index + 1,
                   preorderSize - index - 1, inorderSize - index - 1);

    return root;  // 返回根节点
}

// 后序遍历二叉树
void postorderTraversal(TreeNode* root) {
    if (root == nullptr) return;

    postorderTraversal(root->lchild);
    postorderTraversal(root->rchild);
    cout << root->value;
}

int main() {
    char preorder[1000], inorder[1000];
    while (cin >> preorder >> inorder) {
        Error = false;
        int preorderSize = strlen(preorder);
        int inorderSize = strlen(inorder);
        TreeNode* root =
            createTree(preorder, inorder, preorderSize, inorderSize);
        if (Error) {
            cout << "Error" << endl;
            continue;
        }
        postorderTraversal(root);
        cout << endl;
    }
    return 0;
}