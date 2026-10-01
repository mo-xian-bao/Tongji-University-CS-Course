#define _CRT_SECURE_NO_WARNINGS
#include <cstring>
#include <iostream>

using namespace std;

const int MAX_N = 100001;

/// @brief 实现一个动态栈，支持基本的栈操作
struct Stack {
    int *data;
    int top;
    int size = 10;

    /// @brief 构造函数，初始化栈
    Stack() : top(-1), size(1) {
        data = new int[size];  // 初始化数据数组
    }

    /// @brief 压入元素到栈顶
    /// @param value 要压入栈的值
    void push(int value) {
        if (top == size - 1) {
            // 如果栈满，重新分配内存
            int *newData = new int[size * 2];
            memcpy(newData, data, size * sizeof(int));
            delete[] data;
            data = newData;
            size *= 2;
        }
        data[++top] = value;  // 压入栈顶
    }

    /// @brief 弹出栈顶元素
    void pop() {
        if (top != -1) {
            top--;  // 弹出栈顶
        }
    }

    /// @brief 返回栈顶元素
    /// @return 栈顶的值
    int peek() {
        return data[top];  // 返回栈顶元素
    }

    /// @brief 判断栈是否为空
    /// @return 如果栈为空则返回true，否则返回false
    bool isEmpty() {
        return top == -1;  // 判断栈是否为空
    }
};

// 主函数，程序的入口点
int main() {
    char *s = new char[MAX_N];
    while (cin >> s) {  // 读取输入字符串

        if (s == NULL || strlen(s) == 0) {
            // 如果没有输入，输出0 0
            cout << "0 0" << endl;
            return 0;
        }

        int n = strlen(s);
        Stack stack;     // 创建栈实例
        stack.push(-1);  // 初始化栈，放入-1

        int maxLen = 0;
        int startPos = 0;

        // 遍历输入字符串，计算有效的括号长度
        for (int i = 0; i < n; i++) {
            if (s[i] == '(') {
                // 如果是左括号，压入索引
                stack.push(i);
            } else if (s[i] == ')') {
                // 如果是右括号，弹出栈顶
                stack.pop();

                if (stack.isEmpty()) {
                    // 如果栈空，压入当前索引
                    stack.push(i);
                } else {
                    // 计算当前有效长度
                    int currentLen = i - stack.peek();
                    if (currentLen > maxLen) {
                        maxLen = currentLen;
                        startPos = stack.peek() + 1;
                    }
                }
            } else {
                ;  // 如果是其他字符，跳过
            }
        }

        // 输出最长有效括号的长度和起始位置
        cout << maxLen << " " << startPos << endl;
    }
    delete[] s;  // 释放动态分配的内存
    return 0;    // 返回程序执行状态
}