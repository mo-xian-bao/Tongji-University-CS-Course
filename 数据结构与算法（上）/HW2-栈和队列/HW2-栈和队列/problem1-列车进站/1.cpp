#include <cstring>
#include <iostream>

using namespace std;

/// @brief 代表一个栈的数据结构
struct Stack {
    char* base;      ///< 栈底指针
    char* top;       ///< 栈顶指针
    int stack_size;  ///< 栈的容量

    /// @brief 构造函数，初始化栈
    /// @param size 栈的大小
    Stack(int size) {
        base = new char[size];
        top = base;
        stack_size = size;
    }

    /// @brief 向栈中添加元素
    /// @param c 要添加的字符
    void push(char c) {
        if (top - base == stack_size) {
            cout << "stack overflow" << endl;
            return;
        }
        *top++ = c;
    }

    /// @brief 从栈中弹出元素
    /// @return 返回弹出的字符，如果栈为空则返回0
    char pop() {
        if (top == base) {
            return 0;
        }
        return *--top;
    }
};

// 判断栈的状态是否符合输入和输出字符串
void jugde_stack(Stack& stack, char* input_str, char* output_str) {
    char* p = input_str;
    char* q = output_str;

    while (*p != 0) {                  // 遍历输入字符串
        while (*p == *q && *p != 0) {  // 输入和输出匹配
            p++;
            q++;  // 跳过相同元素
        }
        if (*p == 0) {  // 输入字符串遍历完毕
            break;
        } else {
            char c = stack.pop();
            if (c == 0) {  // 栈为空
                stack.push(*p);
                p++;
            } else if (c != *q) {  // 栈顶元素和输出不匹配
                stack.push(c);
                stack.push(*p);
                p++;
            } else {
                q++;
            }
        }
    }
    while (*q != 0) {          // 遍历输出字符串
        char c = stack.pop();  // 弹出栈顶元素
        if (c != *q) {
            cout << "no" << endl;
            return;
        }
        q++;
    }
    cout << "yes" << endl;
    return;
}

int main() {
    char input_str[100];  // 入栈序列
    cin >> input_str;
    char output_str[100];

    while (cin >> output_str) {
        Stack stack(strlen(input_str));             // 初始化栈
        jugde_stack(stack, input_str, output_str);  // 判断出栈顺序是否正确
    }

    return 0;
}
