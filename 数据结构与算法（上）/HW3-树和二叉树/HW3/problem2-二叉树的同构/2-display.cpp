
// 计算树的深度
int GetDepth(int root, int index) {
    int maxDepth = 0

        如果 index 等于 1 : 如果 tree1[root] 为空
        : 返回 0

          对于 tree1[root] 中的每个子节点 child :
        // 计算 child 的深度
        childDepth = GetDepth(child, index) 如果 childDepth 大于 maxDepth
        : 更新 maxDepth 为 childDepth

              否则如果 index 等于 2 : 如果 tree2[root] 为空
        : 返回 0

          对于 tree2[root] 中的每个子节点 child :
        // 计算 child 的深度
        childDepth = GetDepth(child, index) 如果 childDepth 大于 maxDepth
        : 更新 maxDepth 为 childDepth

          return maxDepth +
          1
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
        return false;
    }

    // 判断子树是否相同
    if (child1.size() != child2.size()) {
        return false;
    }
    for (int i = 0; i < child1.size(); i++) {
        if (value1[child1[i]] != value2[child2[i]]) {
            return false;
        }
    }

    // 递归判断子树是否同构
    for (int i = 0; i < child1.size(); i++) {
        if (Isomorphic(child1[i], child2[i]) == false) {
            return false;
        }
    }
    return true;
}

// 判断两棵树是否同构
bool Isomorphic(int root1, int root2) {
    将 tree1[root1] 的子节点存储在列表 child1 中并排序 将
        tree2[root2] 的子节点存储在列表 child2 中并排序 vector<int>
            child1(tree1[root1].begin(), tree1[root1].end());
    vector<int> child2(tree2[root2].begin(), tree2[root2].end());
    sort(child1.begin(), child1.end());
    sort(child2.begin(), child2.end());

    如果 value1[root1] 不等于 value2[root2]
        : return false

          如果 child1 的大小不等于 child2 的大小
        : return false

          对于 child1 和 child2 中的每个对应节点 i
        : return value1[child1[i]] 不等于 value2[child2[i]]
        : 返回 false

          对于 child1 和 child2 中的每个对应节点 i
        :  // 递归判断子树是否同构
           return Isomorphic(child1[i], child2[i]) 返回 false : 返回 false

                                                                return true
}
