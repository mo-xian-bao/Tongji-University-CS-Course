/**
 * 创建一棵二叉树并计算最大深度。
 * @param str 输入的描述字符串，其中'd'表示向下移动，'u'表示向上移动。
 * @param maxdepth 用于记录树的最大深度。
 * @return 返回树的根节点。
 */
BiTree createBiTree(string str, int& maxdepth) {
    // 初始化当前深度和最大深度
    int depth1 = 0;
    maxdepth = 0;

    // 定义一个访问节点结构，用于标记节点是否已访问
    struct VisitNode {
        BiTree node;
        bool flag;
        // 构造函数初始化节点和访问标记
        VisitNode(BiTree node) : node(node), flag(false) {}
    };

    // 使用栈来辅助构建二叉树
    stack<VisitNode*> stack;
    BiTree root = NULL;
    // 创建根节点
    BiTree p = new (nothrow) BiTNode;
    if (!p) exit(-1);  // 如果分配失败，则退出
    p->lchild = p->rchild = NULL;
    root = p;  // 将根节点赋值给 root

    // 创建当前访问节点，并将其压入栈中
    VisitNode* cur = new (nothrow) VisitNode(p);
    stack.push(cur);

    // 遍历输入字符串
    for (unsigned int i = 0; i < str.length(); i++) {
        if (str[i] == 'd') {  // 若字符为 'd'，表示向下进入子节点
            depth1++;         // 增加当前深度
            maxdepth = max(maxdepth, depth1);  // 更新最大深度
            // 创建新的树节点
            p = new (nothrow) BiTNode;
            if (!p) exit(-1);  // 如果分配失败，则退出
            p->lchild = p->rchild = NULL;

            // 根据标记决定将新节点作为左子节点或右子节点
            if (cur->flag == false)
                cur->node->lchild = p;
            else
                cur->node->rchild = p;

            // 创建新的访问节点，并压入栈中
            cur = new (nothrow) VisitNode(p);
            stack.push(cur);
        } else if (str[i] == 'u') {  // 若字符为 'u'，表示向上返回父节点
            depth1--;                // 减少当前深度
            cur = stack.top();  // 获取栈顶元素
            stack.pop();        // 弹出栈顶元素
            cur->flag = true;   // 标记为已访问
        }
    }

    // 返回构建的二叉树的根节点
    return root;
}