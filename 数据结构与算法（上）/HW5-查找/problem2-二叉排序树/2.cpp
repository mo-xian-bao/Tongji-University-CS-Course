#include <iostream>
#include <vector>

using namespace std;

struct TreeNode {
    int val; // 节点值
    int num;  // 相同值节点的数量
    TreeNode* left;  // 左子树指针
    TreeNode* right; // 右子树指针
    TreeNode(int x) : val(x), num(1), left(NULL), right(NULL) {} // 构造函数
};

void Insert_BST(TreeNode*& root, int val) {  // 插入节点
    TreeNode *p, *q;
    if (root == nullptr) {
        root = new TreeNode(val);
        return;
    } else {
        p = root;
        while (p != nullptr) {
            q = p;
            if (val < p->val)
                p = p->left;
            else if (val > p->val)
                p = p->right;
            else {
                p->num++;
                return;
            }
        }
        if (val < q->val)
            q->left = new TreeNode(val);
        else
            q->right = new TreeNode(val);
    }
}

bool delete_node(TreeNode*& p);

int Delete_BST(TreeNode*& T, int val) {  // 删除节点
    if (T == nullptr) return false;  // 待删除节点不存在，返回false
    if (val == T->val) return delete_node(T);  // 找到待删除节点
    if (val < T->val)  // 如果待删除节点在左子树中
        return Delete_BST(T->left, val);  // 则递归左子树
    else  // 如果待删除节点在右子树中
        return Delete_BST(T->right, val);  // 则递归右子树
}

bool delete_node(TreeNode*& p) {
    if (p->num > 1) {  // 待删除节点有多个相同值节点
        p->num--;
        return true;
    }

    TreeNode *q, *s;
    if (p->right ==
        nullptr) {  // 待删除节点没有右子树，将左子树直接挂到待删除节点的位置
        q = p;
        p = p->left;
        delete q;
    } else if (
        p->left ==
        nullptr) {  // 待删除节点没有左子树，将右子树直接挂到待删除节点的位置
        q = p;
        p = p->right;
        delete q;
    } else {  // 待删除节点有左右子树，找到左子树中的最大值，替换待删除节点的值，并删除最大值节点
        q = p;
        s = p->left;
        while (s->right != nullptr) {  // 找到左子树中的最大值
            q = s;
            s = s->right;
        }
        p->val = s->val;  // 替换待删除节点的值
        p->num = s->num;
        if (q == p)
            q->left = s->left;
        else
            q->right = s->left;
        delete s;
    }
    return true;
}

int Count_BST(TreeNode* T, int val) {
    if (T == nullptr) return 0;
    if (T->val == val) return T->num;
    if (val < T->val)
        return Count_BST(T->left, val);
    else
        return Count_BST(T->right, val);
}

int Get_Min(TreeNode* T) {
    if (T == nullptr) return -1;
    while (T->left != nullptr) T = T->left;
    return T->val;
}

int Get_Pre(TreeNode* T, int val) {
    if (T == nullptr) return -1;  // 检查树是否为空

    TreeNode *p = T, *predecessor = nullptr;

    while (p) {
        if (p->val == val) {
            // 找到了节点
            if (p->left != nullptr) {
                // 如果左子树存在，找到左子树中的最大值
                predecessor = p->left;
                while (predecessor->right != nullptr) {
                    predecessor = predecessor->right;
                }
                return predecessor->val;
            } else {
                // 如果没有左子树，返回前一个节点
                return predecessor ? predecessor->val : -1;
            }
        } else if (val < p->val) {
            p = p->left;
        } else {
            // 更新前驱节点
            predecessor = p;
            p = p->right;
        }
    }

    // 如果没有找到，返回-1
    return predecessor ? predecessor->val : -1;
}

int main() {
    int n;
    cin >> n;
    TreeNode* root = nullptr;
    for (int i = 0; i < n; i++) {
        int operation;
        cin >> operation;
        switch (operation) {
            case 1:
                int val;
                cin >> val;
                Insert_BST(root, val);
                break;
            case 2:
                int val2;
                cin >> val2;
                if (!Delete_BST(root, val2)) cout << "None" << endl;
                break;
            case 3:
                int val3;
                cin >> val3;
                cout << Count_BST(root, val3) << endl;
                break;
            case 4:
                cout << Get_Min(root) << endl;
                break;
            case 5:
                int val4;
                cin >> val4;
                if (Get_Pre(root, val4) == -1)
                    cout << "None" << endl;
                else
                    cout << Get_Pre(root, val4) << endl;
                break;
            default:
                break;
        }
    }
    return 0;
}