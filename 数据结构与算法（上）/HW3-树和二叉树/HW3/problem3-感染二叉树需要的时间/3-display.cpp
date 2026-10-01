// 实现广度优先搜索算法，用于在二叉树中查找节点，并计算感染时间
int BFS(vector<BiTree> nodes, int start) {
    queue<BiTree> q;  // 创建一个队列 q

    q.push(nodes[start]);  // 将节点 nodes[start] 入队 q

    int time = -1;  // 初始化时间 time 为 -1

    // 当队列 q 不为空时
    while (!q.empty()) {
        // 获取当前层的节点数 currentLevelSize = q 的大小
        int currentLevelSize = q.size();

        // 对于从 0 到 currentLevelSize - 1 的每一个索引 i
        for (int i = 0; i < currentLevelSize; i++) {
            // 取出队头节点 node = q 的队首元素并出队
            BiTree node = q.front();
            q.pop();

            // 如果 node 未被访问
            if (node->visited == false) {
                // 标记 node 为已访问
                node->visited = true;

                // 如果 node 的左子节点存在且未被访问
                if (node->lchild != nullptr && node->lchild->visited == false) {
                    // 将 node 的左子节点入队 q
                    q.push(node->lchild);
                }

                // 如果 node 的右子节点存在且未被访问
                if (node->rchild != nullptr && node->rchild->visited == false) {
                    // 将 node 的右子节点入队 q
                    q.push(node->rchild);
                }

                // 如果 node 的父节点存在且未被访问
                if (node->parent != nullptr && node->parent->visited == false) {
                    // 将 node 的父节点入队 q
                    q.push(node->parent);
                }
            }
        }
        // 增加时间 time
        time++;
    }
    // 返回时间 time
    return time;
}