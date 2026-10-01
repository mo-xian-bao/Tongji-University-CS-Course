#include "btree.h"
#include <iostream>

using namespace std; 

// ====================================================================
// BTreeNode 类方法实现
// ====================================================================

// 构造函数
BTreeNode::BTreeNode(bool is_leaf_flag) {
    this->is_leaf = is_leaf_flag;

    // 为关键字和子节点指针分配内存
    keys = new int[m];              // 最多m个关键字
    children = new BTreeNode*[m+1]; // 最多m+1个子节点

    n = 0; // 一开始没有关键字

    // 把所有子节点指针设为null
    for (int i = 0; i <= m; i++) {
        children[i] = nullptr;
    }
}

// 判断节点是否满了
bool BTreeNode::isOverflow() {
    return n >= m; // 关键字数量达到m就算满了
}

// 判断节点关键字是否太少
bool BTreeNode::isUnderflow() {
    if (is_leaf) {
        return n < 1; // 叶子节点至少要有1个关键字
    } else {
        return n < 1; // 内部节点至少要有1个关键字
    }
}

// 中序遍历子树
void BTreeNode::traverse() {
    int i;
    for (i = 0; i < n; i++) {
        // 不是叶子节点的话，先遍历左边的子树
        if (!is_leaf) {
            children[i]->traverse();
        }
        // 输出当前关键字
        cout << " " << keys[i];
    }

    // 处理最右边的子节点
    if (!is_leaf) {
        children[i]->traverse();
    }
}

// 按层次打印树结构
void BTreeNode::printTree(int level) {
    // 根据层次打印缩进
    for (int i = 0; i < level; i++) {
        cout << "  ";
    }
    
    // 打印节点中的所有关键字
    cout << "[";
    for (int i = 0; i < n; i++) {
        cout << keys[i];
        if (i < n - 1) cout << ",";
    }
    cout << "]";
    
    if (is_leaf) {
        cout << " (叶子)";
    }
    cout << endl;
    
    // 如果有子节点，递归打印
    if (!is_leaf) {
        for (int i = 0; i <= n; i++) {
            if (children[i] != nullptr) {
                children[i]->printTree(level + 1);
            }
        }
    }
}

// 插入关键字
void BTreeNode::insert(int k) {
    if (is_leaf) {
        // 叶子节点：找到合适位置直接插入
        int i = n - 1;
        while (i >= 0 && keys[i] > k) {
            keys[i + 1] = keys[i];
            i--;
        }
        keys[i + 1] = k;
        n++;
    } else {
        // 内部节点：找到应该插入哪个子树
        int i = 0;
        while (i < n && k > keys[i]) {
            i++;
        }
        children[i]->insert(k);
        
        // 插入后看看子节点有没有满
        if (children[i]->isOverflow()) {
            splitChild(i);
        }
    }
}

// 分裂子节点
void BTreeNode::splitChild(int child_index) {
    BTreeNode* full_child = children[child_index];
    
    // 新建一个节点
    BTreeNode* new_node = new BTreeNode(full_child->is_leaf);
    
    // 3阶B树中，满节点有3个关键字[0,1,2]
    // 分裂策略：keys[0]留在原节点，keys[1]上移到父节点，keys[2]放到新节点
    
    // 把中间的关键字提升到父节点
    int mid_key = full_child->keys[1];
    
    // 新节点拿到右半边
    new_node->keys[0] = full_child->keys[2];
    new_node->n = 1;
    
    // 如果不是叶子节点，子节点指针也要分配
    if (!full_child->is_leaf) {
        new_node->children[0] = full_child->children[2];
        new_node->children[1] = full_child->children[3];
    }
    
    // 原节点只保留左半边
    full_child->n = 1; // 只留keys[0]
    
    // 在父节点中给新上移的关键字腾位置
    for (int j = n; j > child_index; j--) {
        keys[j] = keys[j-1];
        children[j+1] = children[j];
    }
    
    // 把中间关键字和新节点插入父节点
    keys[child_index] = mid_key;
    children[child_index + 1] = new_node;
    n++;
}

// 查找关键字
BTreeNode* BTreeNode::search(int k) {
    // 在当前节点找第一个>=k的关键字
    int i = 0;
    while (i < n && k > keys[i]) {
        i++;
    }

    // 2. 如果找到了等于k的关键字，查找成功，返回当前节点
    if (i < n && keys[i] == k) {
        return this;
    }

    // 3. 如果没找到，并且当前是叶节点，说明树中不存在该关键字
    if (is_leaf) {
        return nullptr;
    }

    // 4. 如果没找到且不是叶节点，则递归地到合适的子节点中继续查找
    return children[i]->search(k);
}

// 删除关键字k
void BTreeNode::remove(int k) {
    // 在当前节点中查找关键字k的位置
    int i = 0;
    while (i < n && keys[i] < k) {
        i++;
    }
    
    if (i < n && keys[i] == k) {
        // 找到了关键字k
        if (is_leaf) {
            // 情况1：关键字在叶节点中，直接删除
            for (int j = i; j < n - 1; j++) {
                keys[j] = keys[j + 1];
            }
            n--;
        } else {
            // 情况2：关键字在内部节点中，用左子树最大关键字替换
            int max_key = children[i]->getMaxKey();
            keys[i] = max_key;
            children[i]->remove(max_key);
            
            // 检查子节点是否下溢
            if (children[i]->isUnderflow()) {
                fixUnderflow(i);
            }
        }
    } else {
        // 关键字不在当前节点中
        if (is_leaf) {
            // 如果是叶节点且没找到，说明关键字不存在
            return;
        }
        
        // 递归到子节点中删除
        children[i]->remove(k);
        
        // 检查子节点是否下溢
        if (children[i]->isUnderflow()) {
            fixUnderflow(i);
        }
    }
}

// 获取以该节点为根的子树中的最大关键字
int BTreeNode::getMaxKey() {
    if (is_leaf) {
        return keys[n - 1];
    } else {
        return children[n]->getMaxKey();
    }
}

// 从兄弟节点借关键字
void BTreeNode::borrowFromSibling(int index, bool isLeftSibling) {
    BTreeNode* child = children[index];
    
    if (isLeftSibling) {
        // 从左兄弟借
        BTreeNode* leftSibling = children[index - 1];
        
        // 将父节点的关键字下移到child
        for (int i = child->n; i > 0; i--) {
            child->keys[i] = child->keys[i - 1];
        }
        child->keys[0] = keys[index - 1];
        
        // 如果不是叶节点，还要移动子节点指针
        if (!child->is_leaf) {
            for (int i = child->n + 1; i > 0; i--) {
                child->children[i] = child->children[i - 1];
            }
            child->children[0] = leftSibling->children[leftSibling->n];
        }
        
        // 将左兄弟的最大关键字上移到父节点
        keys[index - 1] = leftSibling->keys[leftSibling->n - 1];
        
        child->n++;
        leftSibling->n--;
    } else {
        // 从右兄弟借
        BTreeNode* rightSibling = children[index + 1];
        
        // 将父节点的关键字下移到child
        child->keys[child->n] = keys[index];
        
        // 如果不是叶节点，还要移动子节点指针
        if (!child->is_leaf) {
            child->children[child->n + 1] = rightSibling->children[0];
        }
        
        // 将右兄弟的最小关键字上移到父节点
        keys[index] = rightSibling->keys[0];
        
        // 在右兄弟中删除已移动的关键字和指针
        for (int i = 0; i < rightSibling->n - 1; i++) {
            rightSibling->keys[i] = rightSibling->keys[i + 1];
        }
        if (!rightSibling->is_leaf) {
            for (int i = 0; i < rightSibling->n; i++) {
                rightSibling->children[i] = rightSibling->children[i + 1];
            }
        }
        
        child->n++;
        rightSibling->n--;
    }
}

// 与兄弟节点合并
void BTreeNode::mergeWithSibling(int index) {
    BTreeNode* child = children[index];
    BTreeNode* sibling;
    bool mergeWithLeft = (index > 0);
    
    if (mergeWithLeft) {
        // 与左兄弟合并
        sibling = children[index - 1];
        
        // 将父节点的关键字下移到左兄弟
        sibling->keys[sibling->n] = keys[index - 1];
        sibling->n++;
        
        // 将child的所有关键字移到左兄弟
        for (int i = 0; i < child->n; i++) {
            sibling->keys[sibling->n] = child->keys[i];
            sibling->n++;
        }
        
        // 如果不是叶节点，还要移动子节点指针
        if (!child->is_leaf) {
            int start_pos = sibling->n - child->n;
            for (int i = 0; i <= child->n; i++) {
                sibling->children[start_pos + i] = child->children[i];
            }
        }
        
        // 在父节点中删除已下移的关键字和child指针
        for (int i = index - 1; i < n - 1; i++) {
            keys[i] = keys[i + 1];
        }
        for (int i = index; i < n; i++) {
            children[i] = children[i + 1];
        }
        
        delete child;
        n--;
    } else {
        // 与右兄弟合并
        sibling = children[index + 1];
        
        // 将父节点的关键字下移到child
        child->keys[child->n] = keys[index];
        child->n++;
        
        // 将右兄弟的所有关键字移到child
        for (int i = 0; i < sibling->n; i++) {
            child->keys[child->n] = sibling->keys[i];
            child->n++;
        }
        
        // 如果不是叶节点，还要移动子节点指针
        if (!child->is_leaf) {
            int start_pos = child->n - sibling->n;
            for (int i = 0; i <= sibling->n; i++) {
                child->children[start_pos + i] = sibling->children[i];
            }
        }
        
        // 在父节点中删除已下移的关键字和sibling指针
        for (int i = index; i < n - 1; i++) {
            keys[i] = keys[i + 1];
        }
        for (int i = index + 1; i < n; i++) {
            children[i] = children[i + 1];
        }
        
        delete sibling;
        n--;
    }
}

// 修复子节点的下溢
void BTreeNode::fixUnderflow(int child_index) {
    BTreeNode* child = children[child_index];
    
    // 检查左兄弟是否可以借关键字
    if (child_index > 0 && children[child_index - 1]->n > 1) {
        borrowFromSibling(child_index, true);
        return;
    }
    
    // 检查右兄弟是否可以借关键字
    if (child_index < n && children[child_index + 1]->n > 1) {
        borrowFromSibling(child_index, false);
        return;
    }
    
    // 无法借关键字，需要合并
    mergeWithSibling(child_index);
}

// ====================================================================
// BTree 类的函数实现
// ====================================================================

// BTree的构造函数
BTree::BTree() {
    root = nullptr; // 初始化为空树
}

// 遍历整棵树
void BTree::traverse() {
    if (root != nullptr) {
        root->traverse();
    }
    cout << endl;
}

// 打印整棵树的结构
void BTree::printTree() {
    if (root != nullptr) {
        cout << "B-Tree Structure:" << endl;
        root->printTree(0);
    } else {
        cout << "Tree is empty" << endl;
    }
}

// 查找关键字k
BTreeNode* BTree::search(int k) {
    // 如果树为空，直接返回null；否则从根节点开始搜索
    return (root == nullptr) ? nullptr : root->search(k);
}

// 插入一个关键字到B树中
void BTree::insert(int k) {
    if (root == nullptr) {
        root = new BTreeNode(true);
        root->keys[0] = k;
        root->n = 1;
        return;
    }
    
    // 直接插入
    root->insert(k);
    
    // 检查根节点是否溢出
    if (root->isOverflow()) {
        // 创建新根
        BTreeNode* new_root = new BTreeNode(false);
        new_root->children[0] = root;
        new_root->splitChild(0);
        root = new_root;
    }
}

// 删除一个关键字
void BTree::remove(int k) {
    if (root == nullptr) {
        return;
    }
    
    // 检查关键字是否存在
    if (search(k) == nullptr) {
        return;
    }
    
    // 从根节点开始删除
    root->remove(k);
    
    // 检查根节点是否变为空
    if (root->n == 0) {
        BTreeNode* old_root = root;
        if (root->is_leaf) {
            // 如果根节点是叶节点且为空，整棵树变为空
            root = nullptr;
        } else {
            // 如果根节点是内部节点且为空，将其唯一的子节点作为新根
            root = root->children[0];
        }
        delete old_root;
    }
}

// 清空整棵树
void BTree::clear() {
    if (root != nullptr) {
        clearNode(root);
        root = nullptr;
    }
}

// 递归清空节点
void BTree::clearNode(BTreeNode* node) {
    if (node != nullptr) {
        if (!node->is_leaf) {
            for (int i = 0; i <= node->n; i++) {
                clearNode(node->children[i]);
            }
        }
        delete node;
    }
}

// 获取遍历字符串
QString BTree::getTraversalString() const {
    if (root == nullptr) {
        return "";
    }
    
    QString result;
    getTraversalStringHelper(root, result);
    return result.trimmed();
}

// 遍历辅助函数
void BTree::getTraversalStringHelper(BTreeNode* node, QString& result) const {
    if (node == nullptr) return;
    
    int i;
    for (i = 0; i < node->n; i++) {
        // 如果不是叶节点，先递归遍历左侧的子树
        if (!node->is_leaf) {
            getTraversalStringHelper(node->children[i], result);
        }
        // 然后添加当前节点的关键字
        result += QString::number(node->keys[i]) + " ";
    }
    
    // 处理最后一个子节点（第n个子节点）
    if (!node->is_leaf) {
        getTraversalStringHelper(node->children[i], result);
    }
}