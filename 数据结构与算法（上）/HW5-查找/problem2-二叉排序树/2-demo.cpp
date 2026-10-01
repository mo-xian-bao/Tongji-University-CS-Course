#include <iostream>
using namespace std;

// 定义树节点结构
struct TreeNode {
    int val;
    int num;  // 相同值节点的数量
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), num(1), left(nullptr), right(nullptr) {}
};

// 插入节点到BST中
void Insert_BST(TreeNode*& root, int val) {
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

// 前向声明删除节点函数
bool delete_node(TreeNode*& p);

// 删除BST中的节点
bool Delete_BST(TreeNode*& T, int val) {  // 返回类型修改为bool
    if (T == nullptr) return false;
    if (val == T->val) return delete_node(T);
    if (val < T->val)
        return Delete_BST(T->left, val);
    else
        return Delete_BST(T->right, val);
}

// 删除具体节点的实现
bool delete_node(TreeNode*& p) {
    if (p->num > 1) {
        p->num--;
        return true;
    }
    TreeNode *q, *s;
    if (p->right == nullptr) {
        q = p;
        p = p->left;
        delete q;
    } else if (p->left == nullptr) {
        q = p;
        p = p->right;
        delete q;
    } else {
        q = p;
        s = p->left;
        while (s->right != nullptr) {
            q = s;
            s = s->right;
        }
        p->val = s->val;
        p->num = s->num;  // 更新重复计数
        if (q == p)
            q->left = s->left;
        else
            q->right = s->left;
        delete s;
    }
    return true;
}

// 计数BST中指定值的出现次数
int Count_BST(TreeNode* T, int val) {
    if (T == nullptr) return 0;
    if (T->val == val) return T->num;
    if (val < T->val)
        return Count_BST(T->left, val);
    else
        return Count_BST(T->right, val);
}

// 获取BST中的最小值
int Get_Min(TreeNode* T) {
    if (T == nullptr) return -1;
    while (T->left != nullptr) T = T->left;
    return T->val;
}

// 获取指定值的前驱
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
    // 如果没有找到，返回最后记录的前驱
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
            case 1: {  // 插入操作
                int val;
                cin >> val;
                Insert_BST(root, val);
                break;
            }
            case 2: {  // 删除操作
                int val2;
                cin >> val2;
                if (!Delete_BST(root, val2)) cout << "None" << endl;
                break;
            }
            case 3: {  // 计数操作
                int val3;
                cin >> val3;
                cout << Count_BST(root, val3) << endl;
                break;
            }
            case 4: {  // 获取最小值
                int min_val = Get_Min(root);
                if (min_val == -1)
                    cout << "None" << endl;
                else
                    cout << min_val << endl;
                break;
            }
            case 5: {  // 获取前驱
                int val4;
                cin >> val4;
                int pre = Get_Pre(root, val4);
                if (pre == -1)
                    cout << "None" << endl;
                else
                    cout << pre << endl;
                break;
            }
            default:
                break;
        }
    }

    return 0;
}
