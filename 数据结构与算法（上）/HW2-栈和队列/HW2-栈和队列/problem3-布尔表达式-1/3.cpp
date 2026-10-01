#include <cstring>
#include <iostream>
#include <string>

using namespace std;

struct Operater {  // 操作符的栈
    char *base;
    char *top;
    int size = 10;

    Operater() {
        base = new char[size];
        top = base;
    }

    void push(char c) {
        if (top - base >= size) {
            char *newbase = new char[size * 2];
            memcpy(newbase, base, size);
            delete[] base;
            base = newbase;
            size *= 2;
        }
        *top = c;
        top++;
    }

    char pop() {
        if (top == base) return '\0';  // Return `\0` if stack is empty
        top--;
        return *top;
    }

    char peek() {
        if (top == base) return '\0';  // Return `\0` if stack is empty
        return *(top - 1);             // Corrected to peek at the top element
    }
};

struct Stack {  // 操作数的栈
    bool *base;
    bool *top;
    int size = 10;

    Stack() {
        base = new bool[size];
        top = base;
    }

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

    bool pop() {
        if (top == base) return false;  // Return false if stack is empty
        top--;
        return *top;
    }

    bool peek() {
        if (top == base) return false;  // Return false if stack is empty
        return *(top - 1);              // Fixed to peek at the top element
    }
};

int priority(char c) {  // 操作符优先级
    if (c == '|') return 1;
    if (c == '&') return 2;
    if (c == '!') return 3;
    return 0;
}

int main() {
    string str;
    int n = 0;
    while (getline(cin, str)) {
        n++;
        int len = str.length();
        Operater op;
        Stack num;

        for (int i = 0; i < len; i++) {
            if (str[i] == 'V' || str[i] == 'F') {
                num.push(str[i] == 'V' ? true : false);
            } else if (str[i] == '!') {
                while (str[i + 1] == ' ')  // 省略空格
                    i++;
                if (str[i + 1] == '(')
                    op.push('!');
                else if (str[i + 1] == 'V' || str[i + 1] == 'F') {
                    num.push(str[i + 1] == 'V' ? false : true);
                    i++;
                } else if (str[i + 1] == '!') {
                    i++;
                }
            } else if (str[i] == '(') {
                op.push(str[i]);
            } else if (str[i] == '|' || str[i] == '&') {
                while (priority(str[i]) <= priority(op.peek()) &&
                       op.peek() != '\0' && op.peek() != '(') {
                    bool b2 = num.pop();
                    bool b1 = num.pop();
                    bool res = (op.pop() == '|') ? (b1 || b2) : (b1 && b2);
                    num.push(res);
                }
                op.push(str[i]);
            } else if (str[i] == ')') {
                while (op.peek() != '\0' && op.peek() != '(') {
                    bool b2 = num.pop();
                    bool b1 = num.pop();
                    bool res = (op.pop() == '|') ? (b1 || b2) : (b1 && b2);
                    num.push(res);
                }
                op.pop();  // Pop the '('
                if (op.peek() == '!') {
                    bool b = num.pop();
                    num.push(!b);
                    op.pop();
                }
            }
        }

        while (op.peek() != '\0') {
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