#include <cstring>
#include <iostream>
#include <stack>
using namespace std;

#define OK 1
#define ERROR 0

#define STACK_INIT_SIZE 100000
#define STACKINCREMENT 10

typedef int Status;
typedef int TElemType;

// 二叉树节点结构体
typedef struct BiTNode {
    TElemType data;            // 节点存储的数据
    BiTNode *lchild, *rchild;  // 左右子树指针
}* BiTree;

// 顺序栈模板结构体
template <class SElemType>
struct SqStack {
   private:
    SElemType* base;  // 栈底指针
    SElemType* top;   // 栈顶指针
    int stacksize;    // 栈的大小

   public:
    SqStack();                 // 构造空栈
    ~SqStack();                // 销毁已有的栈
    Status Pop(SElemType& e);  // 弹出栈顶元素
    Status Push(SElemType e);  // 新元素入栈
};

/**
 * 创建一棵二叉树并计算最大深度。
 * @param str 输入的描述字符串，其中'd'表示向下移动，'u'表示向上移动。
 * @param maxdepth 用于记录树的最大深度。
 * @return 返回树的根节点。
 */
BiTree createBiTree(string str, int& maxdepth) {
    int depth1 = 0;
    maxdepth = 0;

    struct VisitNode {
        BiTree node;
        bool flag;

        VisitNode(BiTree node) : node(node), flag(false) {}
    };

    stack<VisitNode*> stack;

    BiTree root = NULL;
    BiTree p = new (nothrow) BiTNode;
    if (!p) exit(-1);
    p->lchild = p->rchild = NULL;

    root = p;
    VisitNode* cur = new (nothrow) VisitNode(p);
    stack.push(cur);

    for (unsigned int i = 0; i < str.length(); i++) {
        if (str[i] == 'd') {
            depth1++;
            maxdepth = max(maxdepth, depth1);

            p = new (nothrow) BiTNode;
            if (!p) exit(-1);
            p->lchild = p->rchild = NULL;

            if (cur->flag == false)
                cur->node->lchild = p;
            else
                cur->node->rchild = p;

            cur = new (nothrow) VisitNode(p);
            stack.push(cur);
        } else if (str[i] == 'u') {
            depth1--;
            cur = stack.top();
            stack.pop();
            cur->flag = true;
        }
    }
    return root;
}

void Getdepth(BiTree T, int& depth2) {
    if (T == NULL) {
        depth2 = 0;
        return;
    }
    int depth1 = 0, depth3 = 0;
    Getdepth(T->lchild, depth1);
    Getdepth(T->rchild, depth3);
    depth2 = max(depth1, depth3) + 1;
}

int main() {
    string str;
    int i = 0;
    int depth1 = 0, depth2 = 0;
    BiTree T;
    while (1) {
        i++;
        cin >> str;
        if (str == "#") break;
        T = createBiTree(str, depth1);
        Getdepth(T, depth2);
        cout << "Tree " << i << ": " << depth1 << " => " << depth2 - 1 << endl;
    }

    return 0;
}

template <class SElemType>
SqStack<SElemType>::SqStack() {
    base = new (nothrow) SElemType[STACK_INIT_SIZE];
    if (!base) {
        exit(-1);
    }
    top = base;
    stacksize = STACK_INIT_SIZE;
}

template <class SElemType>
SqStack<SElemType>::~SqStack() {
    if (base) delete base;
    stacksize = 0;
}

template <class SElemType>
Status SqStack<SElemType>::Pop(SElemType& e) {
    if (top == base) return ERROR;
    e = *(--top);
    return OK;
}

template <class SElemType>
Status SqStack<SElemType>::Push(SElemType e) {
    if (top - base >= stacksize) {
        SElemType* newbase =
            new (nothrow) SElemType[stacksize + STACKINCREMENT];
        if (!newbase) exit(-1);
        memcpy(newbase, base, sizeof(SElemType) * stacksize);
        delete base;
        base = newbase;
        top = base + stacksize;
        stacksize += STACKINCREMENT;
    }
    *top = e;
    top++;
    return OK;
}