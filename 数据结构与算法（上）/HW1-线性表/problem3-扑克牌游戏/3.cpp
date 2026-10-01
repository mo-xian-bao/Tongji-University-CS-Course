#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

// 定义牌的结构
struct Card {
    string suit;
    string number;
};

// 定义双向链表节点
struct Node {
    Card card;
    Node* prev;
    Node* next;
    Node(Card c) : card(c), prev(nullptr), next(nullptr) {}
};
void appendCard(Node*& head, Node*& tail, Card c) {
    Node* newNode = new Node(c);
    if (!head) { // 如果牌堆为空
        head = tail = newNode;
    }
    else {
        tail->next = newNode;
        newNode->prev = tail;
        tail = newNode;
    }
}
void popCard(Node*& head, Node*& tail) {
    if (!head) {
        cout << "NULL" << endl;
        return;
    }
    // 打印牌的信息
    cout << head->card.suit << " " << head->card.number << endl;
    // 移除头节点
    Node* temp = head;
    head = head->next;
    if (head)
        head->prev = nullptr;
    else
        tail = nullptr; // 牌堆为空
    delete temp;
}
void revertDeck(Node*& head, Node*& tail) {
    if (!head) return;
    Node* current = head;
    while (current) {
        // 交换前后指针
        Node* temp = current->next;
        current->next = current->prev;
        current->prev = temp;
        current = temp;
    }
    // 交换头尾指针
    Node* temp = head;
    head = tail;
    tail = temp;
}
int getNumberValue(const string& num) {
    if (num == "A") return 1;
    if (num == "J") return 11;
    if (num == "Q") return 12;
    if (num == "K") return 13;
    return stoi(num);
}
void extractCards(Node*& head, Node*& tail, const string& suit) {
    // 首先收集所有指定花色的牌
    Card extracted[200];
    int count = 0;
    Node* current = head;
    while (current) {
        if (current->card.suit == suit) {
            extracted[count++] = current->card;
            // 移除当前节点
            Node* toDelete = current;
            if (current->prev)
                current->prev->next = current->next;
            else
                head = current->next;
            if (current->next)
                current->next->prev = current->prev;
            else
                tail = current->prev;
            current = current->next;
            delete toDelete;
        }
        else {
            current = current->next;
        }
    }
    if (count == 0) return;
    // 对提取的牌进行排序
    // 使用简单的插入排序
    for (int i = 1; i < count; ++i) {
        Card key = extracted[i];
        int j = i - 1;
        while (j >= 0 && getNumberValue(extracted[j].number) > getNumberValue(key.number)) {
            extracted[j + 1] = extracted[j];
            j--;
        }
        extracted[j + 1] = key;
    }
    // 将排序后的牌插入到牌堆顶部
    for (int i = count - 1; i >= 0; --i) {
        Node* newNode = new Node(extracted[i]);
        if (!head) {
            head = tail = newNode;
        }
        else {
            newNode->next = head;
            head->prev = newNode;
            head = newNode;
        }
    }
}
int main() {
    int n;
    cin >> n;
    // 牌堆初始化为空
    Node* head = nullptr;
    Node* tail = nullptr;
    for (int i = 0; i < n; i++) {
        string cmd;
        cin >> cmd;
        if (cmd == "Append") {
            string suit, number;
            cin >> suit >> number;
            Card c = { suit, number };
            appendCard(head, tail, c);
        }
        else if (cmd == "Pop") {
            popCard(head, tail);
        }
        else if (cmd == "Revert") {
            revertDeck(head, tail);
        }
        else if (cmd == "Extract") {
            string suit;
            cin >> suit;
            extractCards(head, tail, suit);
        }
    }
    // 最后输出牌堆中的牌
    if (!head) {
        cout << "NULL" << endl;
    }
    else {
        Node* current = head;
        while (current) {
            cout << current->card.suit << " " << current->card.number << endl;
            current = current->next;
        }
    }
    // 释放内存
    while (head) {
        Node* temp = head;
        head = head->next;
        delete temp;
    }
    return 0;
}

// 定义牌的结构  
struct Card {
    string suit;   // 牌的花色  
    string number; // 牌的数字  
};

// 定义双向链表节点  
struct Node {
    Card card;     // 节点持有的牌  
    Node* prev;    // 指向前一个节点的指针  
    Node* next;    // 指向下一个节点的指针  
    Node(Card c) : card(c), prev(nullptr), next(nullptr) {} // 构造函数  
};

/**
 * @brief          append操作：在牌堆末尾添加一张牌
 * @param head     牌堆的头指针
 * @param tail     牌堆的尾指针
 * @param c        要添加的牌
 */
void appendCard(Node*& head, Node*& tail, Card c) {
    Node* newNode = new Node(c); // 创建新节点  
    if (!head) {  // 如果牌堆为空  
        head = tail = newNode; // 头尾指针指向新节点  
    }
    else {
        tail->next = newNode; // 连接新节点  
        newNode->prev = tail;  // 设置新节点的前驱  
        tail = newNode;        // 更新尾指针  
    }
}

/**
 * @brief          pop操作：从牌堆中弹出并显示顶部的牌
 * @param head     牌堆的头指针
 * @param tail     牌堆的尾指针
 */
void popCard(Node*& head, Node*& tail) {
    if (!head) { // 如果牌堆为空  
        cout << "NULL" << endl;
        return;
    }
    // 打印牌的信息  
    cout << head->card.suit << " " << head->card.number << endl;
    // 移除头节点  
    Node* temp = head;
    head = head->next; // 更新头指针  
    if (head)
        head->prev = nullptr; // 更新新的头节点的前指针  
    else
        tail = nullptr; // 牌堆为空，更新尾指针  
    delete temp; // 释放去掉的节点  
}

/**
 * @brief          revert操作：翻转牌堆中的牌顺序
 * @param head     牌堆的头指针
 * @param tail     牌堆的尾指针
 */
void revertDeck(Node*& head, Node*& tail) {
    if (!head) return; // 如果牌堆为空，不做处理  
    Node* current = head;
    while (current) {
        // 交换前后指针  
        Node* temp = current->next;
        current->next = current->prev;
        current->prev = temp;
        current = temp;
    }
    // 交换头尾指针  
    Node* temp = head;
    head = tail;
    tail = temp;
}

/**
 * @brief          将牌的数字字符串转换为对应的整数值
 * @param num      牌的数字字符串
 * @return         对应的整数值
 */
int getNumberValue(const string& num) {
    if (num == "A") return 1;    // A为1  
    if (num == "J") return 11;   // J为11  
    if (num == "Q") return 12;   // Q为12  
    if (num == "K") return 13;   // K为13  
    return stoi(num);            // 其他情况返回数字  
}

/**
 * @brief          extract操作：提取指定花色的牌，并将其插入到牌堆顶部
 * @param head     牌堆的头指针
 * @param tail     牌堆的尾指针
 * @param suit     要提取的花色
 */
void extractCards(Node*& head, Node*& tail, const string& suit) {
    // 创建数组存储提取的牌  
    Card extracted[200];
    int count = 0; // 计数器  
    Node* current = head;
    // 收集所有指定花色的牌  
    while (current) {
        if (current->card.suit == suit) { // 找到指定花色的牌
            // 存储提取的牌  
            // 移除当前节点
        }
        else {
            current = current->next;
        }
    }
    if (count == 0) return; // 如果没有提取到牌，直接返回  
    // 对提取的牌进行插入排序
    }
    // 将排序后的牌插入到牌堆顶部
}

