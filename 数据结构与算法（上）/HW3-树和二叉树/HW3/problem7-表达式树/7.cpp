#include <cmath>
#include <cstring>
#include <iostream>
#include <stack>
#include <string>
#include <vector>

using namespace std;

// 定义树节点结构体
struct TreeNode {
    char val; // 节点值
    TreeNode* left; // 左子节点指针
    TreeNode* right; // 右子节点指针
    int depth; // 节点深度
    int start; // 节点起始位置
 
    // 构造函数
    TreeNode(char x) : val(x), left(NULL), right(NULL), depth(0), start(0) {}
};

int priority(char op) {
    if (op == '+' || op == '-') {
        return 1;
    } else if (op == '*' || op == '/') {
        return 2;
    } else {
        return 0;
    }
}

string Inserve_Polish(string exp) {
    stack<char> st;
    string res;
    for (int i = 0; i < exp.length(); i++) {
        if (exp[i] == '(') {
            st.push(exp[i]);
        } else if (exp[i] == ')') {
            while (st.top() != '(') {
                res += st.top();
                st.pop();
            }
            st.pop();
        } else if (priority(exp[i]) > 0) {
            while (!st.empty() && priority(exp[i]) <= priority(st.top())) {
                res += st.top();
                st.pop();
            }
            st.push(exp[i]);
        } else {
            res += exp[i];
        }
    }
    while (!st.empty()) {
        res += st.top();
        st.pop();
    }
    return res;
}

TreeNode* BuildTree(string exp) {
    stack<TreeNode*> operands;
    stack<char> operators;

    for (int i = 0; i < exp.length(); i++) {
        if (exp[i] == '(') {
            operators.push(exp[i]);
        } else if (exp[i] >= 'a' && exp[i] <= 'z') {
            operands.push(new TreeNode(exp[i]));
        } else if (exp[i] == ')') {
            while (operators.top() != '(') {
                TreeNode* right = operands.top();
                operands.pop();
                TreeNode* left = operands.top();
                operands.pop();
                char op = operators.top();
                operators.pop();
                TreeNode* node = new TreeNode(op);
                node->left = left;
                node->right = right;
                operands.push(node);
            }
            operators.pop();
        } else if (priority(exp[i]) > 0) {
            while (!operators.empty() && operators.top() != '(' &&
                   priority(exp[i]) <= priority(operators.top())) {
                TreeNode* right = operands.top();
                operands.pop();
                TreeNode* left = operands.top();
                operands.pop();
                char op = operators.top();
                operators.pop();
                TreeNode* node = new TreeNode(op);
                node->left = left;
                node->right = right;
                operands.push(node);
            }
            operators.push(exp[i]);
        }
    }

    while (!operators.empty()) {
        TreeNode* right = operands.top();
        operands.pop();
        TreeNode* left = operands.top();
        operands.pop();
        char op = operators.top();
        operators.pop();
        TreeNode* node = new TreeNode(op);
        node->left = left;
        node->right = right;
        operands.push(node);
    }

    return operands.top();
}

int max_depth = 0;
void SetDepth(TreeNode* node) {
    if (node == NULL) {
        return;
    }
    max_depth = max(max_depth, node->depth);

    if (node->left) {
        node->left->depth = node->depth + 1;
        SetDepth(node->left);
    }
    if (node->right) {
        node->right->depth = node->depth + 1;
        SetDepth(node->right);
    }
}

void SetStart(TreeNode* node) {
    if (node->left == nullptr && node->right == nullptr) {
        return;
    }

    if (node->left) {
        node->left->start = node->start - pow(2, max_depth - node->left->depth);
        SetStart(node->left);
    }
    if (node->right) {
        node->right->start =
            node->start + pow(2, max_depth - node->right->depth);
        SetStart(node->right);
    }
}

void SetGraph(TreeNode* node, char graph[][1000]) {
    if (node == NULL) {
        return;
    }

    graph[node->depth * 2][node->start - 1] = node->val;

    if (node->left) {
        graph[node->depth * 2 + 1][node->start - 2] = '/';
        graph[node->depth * 2 + 1][node->start] = '\\';
        SetGraph(node->left, graph);
        SetGraph(node->right, graph);
    }
}

// 计算给定的逆波兰表达式并返回结果
int Calculate(string inserve_polish, int val[]) {
    stack<int> operands;
 
    for (char c : inserve_polish) {
        if (c >= 'a' && c <= 'z') {
            operands.push(val[c - 'a']);  //变量对应的值入栈
        } else {
            int right = operands.top();  //右操作数
            operands.pop();
            int left = operands.top();  //左操作数
            operands.pop();
            switch (c) {  //运算符号
                case '+':
                    operands.push(left + right);  //计算结果入栈
                    break;
                case '-':
                    operands.push(left - right);
                    break;
                case '*':
                    operands.push(left * right);
                    break;
                case '/':
                    operands.push(left / right);
                    break;
                default:
                    break;
            }
        }
    }
 
    return operands.top();
}

int main() {
    string exp;
    string inserve_polish;
    int n;
    int val[26];
    int res;
    char c;
    TreeNode* root;
    char graph[100][1000];

    cin >> exp;
    cin >> n;
    for (int i = 0; i < n; i++) {
        cin >> c;
        cin >> val[c - 'a'];
    }

    inserve_polish = Inserve_Polish(exp);
    cout << inserve_polish << endl;

    root = BuildTree(exp);
    SetDepth(root);

    root->start = pow(2, max_depth);
    SetStart(root);

    /*cout << max_depth << endl;*/
    memset(graph, 0, sizeof(graph));
    SetGraph(root, graph);

    for (int i = 0; i < max_depth * 2 + 1; i++) {
        for (int j = pow(2, max_depth + 1); j >= 0; j--) {
            if (graph[i][j] != 0) {
                for (int k = j - 1; k >= 0; k--) {
                    if (graph[i][k] == 0) {
                        graph[i][k] = ' ';
                    }
                }
                break;
            }
        }
    }

    for (int i = 0; i < max_depth * 2 + 1; i++) {
        cout << graph[i] << endl;
    }

    res = Calculate(inserve_polish, val);
    cout << res << endl;

    return 0;
}