#pragma once // 防止重复包含
#include <QString>

// B树节点类
class BTreeNode {
private:
    int *keys;         // 存储关键字的数组
    BTreeNode **children; // 子节点指针数组
    int n;             // 当前节点中关键字的个数
    bool is_leaf;      // 标记是否为叶子节点

    const int m = 3; // B树的阶数
    // 3阶B树：
    // 每个节点最多有2个关键字，3个子节点
    // 每个节点最少有1个关键字

public:
    BTreeNode(bool is_leaf_flag); // 构造函数

    bool isOverflow(); // 判断节点是否关键字过多
    bool isUnderflow(); // 判断节点是否关键字过少

    // 中序遍历
    void traverse();
    
    // 打印树形结构
    void printTree(int level = 0);

    // 插入关键字
    void insert(int k);

    // 分裂子节点
    void splitChild(int child_index);

    // 查找关键字
    BTreeNode* search(int k);

    // 删除关键字
    void remove(int k);
    
    // 找到子树中的最大关键字
    int getMaxKey();
    
    // 从兄弟节点借一个关键字
    void borrowFromSibling(int index, bool isLeftSibling);
    
    // 和兄弟节点合并
    void mergeWithSibling(int index);
    
    // 处理节点下溢的情况
    void fixUnderflow(int child_index);
    
    // 给界面用的接口
    int getKeyCount() const { return n; }
    int getKey(int index) const { return (index < n) ? keys[index] : -1; }
    bool isLeaf() const { return is_leaf; }
    BTreeNode* getChild(int index) const { return (index <= n && !is_leaf) ? children[index] : nullptr; }

    // 让BTree类可以访问私有成员
    friend class BTree;
};

// B树类
class BTree {
private:
    BTreeNode *root; // 根节点指针
    const int m = 3; // 阶数
    
    // 内部使用的辅助函数
    void clearNode(BTreeNode* node);
    void getTraversalStringHelper(BTreeNode* node, QString& result) const;

public:
    BTree(); // 构造函数

    // 遍历整棵树
    void traverse(); 
    
    // 打印树的结构
    void printTree();

    // 查找关键字
    BTreeNode* search(int k); 

    // 插入关键字
    void insert(int k); 
    
    // 删除关键字
    void remove(int k);
    
    // 清空树
    void clear();
    
    // 界面相关的方法
    bool isEmpty() const { return root == nullptr; }
    BTreeNode* getRoot() const { return root; }
    QString getTraversalString() const;
};