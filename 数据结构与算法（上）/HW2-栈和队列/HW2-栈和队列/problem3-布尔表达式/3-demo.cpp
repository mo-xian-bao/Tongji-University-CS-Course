#include <cstring>
#include <iostream>

using namespace std;

/// @brief 操作符的栈结构体
struct Operater {   // 操作符的栈
    char *base;     // 栈底指针
    char *top;      // 栈顶指针
    int size = 10;  // 栈的初始大小

    /// @brief 构造函数，初始化栈
    Operater() {
        base = new char[size];  // 分配初始内存
        top = base;             // 初始化栈顶指针
    }

    /// @brief 压栈操作，将字符压入栈中
    /// @param c 要压入栈中的字符
    void push(char c) {
        if (top - base >= size) {  // 如果栈满，扩展栈大小
            char *newbase = new char[size * 2];
            memcpy(newbase, base, size);
            delete[] base;
            base = newbase;
            size *= 2;  // 更新栈的大小
        }
        *top = c;  // 将字符存入栈顶
        top++;     // 更新栈顶指针
    }

    /// @brief 弹栈操作，从栈中弹出字符
    /// @return 弹出的字符，如果栈为空则返回'\0'
    char pop() {
        if (top == base) return '\0';  // Return `\0` if stack is empty
        top--;
        return *top;  // 返回栈顶的字符
    }

    /// @brief 查看栈顶元素，但不弹出
    /// @return 栈顶字符，如果栈为空则返回'\0'
    char peek() {
        if (top == base) return '\0';  // Return `\0` if stack is empty
        return *(top - 1);             // Corrected to peek at the top element
    }
};

/// @brief
// 操作数的栈
struct Stack {
    bool *base;
    bool *top;
    int size = 10;

    // 构造函数，初始化栈
    Stack() {
        base = new bool[size];
        top = base;
    }

    // 将元素压入栈中
    void push(bool c) {
        if (top - base >= size) {
            bool *newbase = new bool[size * 2];
            memcpy(newbase, base,
                   size * sizeof(bool));  // Correction to copy correct size
            delete[] base;
            base = newbase;
            size *= 2;
        }
        *top = c;
        top++;
    }

    // 从栈中弹出元素
    bool pop() {
        if (top == base) return false;  // Return false if stack is empty
        top--;
        return *top;
    }

    // 查看栈顶元素
    bool peek() {
        if (top == base) return false;  // Return false if stack is empty
        return *(top - 1);              // Fixed to peek at the top element
    }
};

// 该函数用于返回给定操作符的优先级
int priority(char c) {  // 操作符优先级
    if (c == '|') return 1;
    if (c == '&') return 2;
    if (c == '!') return 3;
    return 0;
}

int main() {
    string str;
    int n = 0;
    // 用于计算布尔表达式的值
    // 通过解析输入的字符串，并利用栈来处理操作符和数值
    // 支持的操作符包括与、或和取反
    while (getline(cin, str)) {
        n++;
        int len = str.length();
        Operater op;  // 操作符栈
        Stack num;    // 数值栈

        for (int i = 0; i < len; i++) {
            if (str[i] == 'V' || str[i] == 'F') {        // 数值
                num.push(str[i] == 'V' ? true : false);  // 存入数值栈
            } else if (str[i] == '!') {                  // 取反
                while (str[i + 1] == ' ')                // 省略空格
                    i++;
                if (str[i + 1] == '(')  // 如果后一个字符是'('，则取反操作入栈
                    op.push(str[i]);
                else if (str[i + 1] == 'V' || str[i + 1] == 'F') {  // 取反数值
                    num.push(str[i + 1] == 'V' ? false : true);
                    i++;
                }
            } else if (str[i] == '(') {  // 左括号直接入栈
                op.push(str[i]);
            } else if (str[i] == '|' || str[i] == '&') {
                while (
                    priority(str[i]) <= priority(op.peek()) &&
                    op.peek() != '\0' &&
                    op.peek() !=
                        '(') {  // 栈顶操作符优先级大于当前操作符，或栈顶是左括号，则弹出栈顶操作符
                    bool b2 = num.pop();
                    bool b1 = num.pop();
                    bool res = (op.pop() == '|') ? (b1 || b2)
                                                 : (b1 && b2);  // 计算操作符
                    num.push(res);
                }
                op.push(str[i]);
            } else if (str[i] == ')') {  // 右括号，弹出栈顶操作符直到遇到左括号
                while (op.peek() != '\0' && op.peek() != '(') {
                    bool b2 = num.pop();
                    bool b1 = num.pop();
                    bool res = (op.pop() == '|') ? (b1 || b2) : (b1 && b2);
                    num.push(res);
                }
                op.pop();                // 弹出 '('
                if (op.peek() == '!') {  // 如果是取反，则计算取反
                    bool b = num.pop();
                    num.push(!b);
                    op.pop();
                }
            }
        }

        while (op.peek() != '\0') {  // 弹出剩余操作符
            bool b1 = num.pop();
            bool b2 = num.pop();
            bool res = false;
            if (op.peek() == '|')
                res = b1 || b2;
            else if (op.peek() == '&')
                res = b1 && b2;
            else {
                res = !b1;
                num.push(b2);
            }
            num.push(res);
            op.pop();
        }
        cout << "Expression " << n << ": " << (num.pop() == 1 ? "V" : "F")
             << endl;
    }
    return 0;
}