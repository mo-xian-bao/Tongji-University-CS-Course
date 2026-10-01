#include "btree.h"
#include <iostream>

using namespace std;

void printMenu() {
    cout << "\n================ B树菜单 ================" << endl;
    cout << "1. 插入关键字" << endl;
    cout << "2. 删除关键字" << endl;
    cout << "3. 查找关键字" << endl;
    cout << "4. 遍历B树 (中序)" << endl;
    cout << "5. 显示B树结构" << endl;
    cout << "6. 插入测试数据" << endl;
    cout << "7. 清空B树" << endl;
    cout << "0. 退出程序" << endl;
    cout << "=======================================" << endl;
    cout << "请选择操作 (0-7): ";
}

void insertTestData(BTree& tree) {
    int keys[] = {10, 20, 5, 6, 12, 30, 7, 17};
    int n = sizeof(keys) / sizeof(keys[0]);
    
    cout << "正在插入测试数据:";
    for (int i = 0; i < n; i++) {
        cout << " " << keys[i];
        tree.insert(keys[i]);
    }
    cout << endl;
    cout << "测试数据插入完成！" << endl;
}

int main() {
    BTree tree;
    int choice, key;
    
    cout << "欢迎使用B树数据结构演示程序！" << endl;
    cout << "当前B树阶数: 3 (最多2个关键字，最多3个子节点)" << endl;
    
    while (true) {
        printMenu();
        cin >> choice;
        
        switch (choice) {
            case 1: // 插入关键字
                cout << "请输入要插入的关键字: ";
                cin >> key;
                tree.insert(key);
                cout << "关键字 " << key << " 插入成功！" << endl;
                cout << "当前B树结构:" << endl;
                tree.printTree();
                break;
                
            case 2: // 删除关键字
                cout << "请输入要删除的关键字: ";
                cin >> key;
                tree.remove(key);
                cout << "当前B树结构:" << endl;
                tree.printTree();
                break;
                
            case 3: // 搜索关键字
                cout << "请输入要查找的关键字: ";
                cin >> key;
                {
                    BTreeNode* result = tree.search(key);
                    if (result != nullptr) {
                        cout << "关键字 " << key << " 在B树中找到了！" << endl;
                    } else {
                        cout << "关键字 " << key << " 在B树中未找到。" << endl;
                    }
                }
                break;
                
            case 4: // 遍历B树
                cout << "B树中序遍历结果: ";
                tree.traverse();
                break;
                
            case 5: // 显示B树结构
                cout << "当前B树结构:" << endl;
                tree.printTree();
                break;
                
            case 6: // 插入测试数据
                insertTestData(tree);
                cout << "当前B树结构:" << endl;
                tree.printTree();
                break;
                
            case 7: // 清空B树
                tree.clear();
                break;
                
            case 0: // 退出程序
                cout << "感谢使用，再见！" << endl;
                return 0;
                
            default:
                cout << "无效选择，请重新输入！" << endl;
                break;
        }
        
        // 暂停等待用户继续
        cout << "\n按回车键继续...";
        cin.ignore(); // 清空输入缓冲区
        cin.get();    // 等待用户按回车
    }
    
    return 0;
}