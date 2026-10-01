#include <iostream>
#include<cstring>
using namespace std;

typedef int Status;
typedef int ElemType;
ElemType MAX;  // 定义最大值
#define FULL 4
#define EMPTY -1
#define OK 1


struct Stack {       // 基础栈结构
    ElemType* base;  // 栈底指针
    ElemType* top;   // 栈顶指针
    int stacksize;   // 栈大小

    Stack() ;   // 构造函数
    ~Stack() ;  // 析构函数

    Status Push(ElemType elem);      // 入栈
    Status Pop(ElemType& elem);      // 出栈
    Status PeekTop(ElemType& elem);  // 获取栈顶元素
    bool StackEmpty();               // 判断栈是否为空
    bool StackFull();  // 判断栈是否已满
};

class Stack_pro {   // 带最大值的栈
   private:
    Stack value, max_value;  // 栈和最大值栈

   public:
    Status Push(ElemType elem) ;          // 入栈
    Status Pop(ElemType& elem) ;          // 出栈
    Status PeekTop(ElemType& elem) ;       // 获取栈顶元素
    Status GetMaxValue(ElemType& elem) ;  // 获取栈中最大值
    bool StackEmpty() ;                   // 判断栈是否为空
    bool StackFull() ;                    // 判断栈是否已满
};

class Stack_pro_max {
   private:
    Stack_pro a,b;
    int num=0;  // 队列中元素个数
   public:
    Status EnQueue(ElemType elem) ;       // 入队
    Status DeQueue(ElemType& elem) ;      // 出队
    Status GetMaxValue(ElemType& elem) ;  // 获取队列中最大值
    bool QueueEmpty() ;                   // 判断队列是否为空
};


int main()
{
    cin>>MAX;
    Stack_pro_max q;
    string cmd;

    while (cin >> cmd) {
        if (cmd == "enqueue") {
            ElemType elem;
            cin >> elem;
            if (q.EnQueue(elem) == FULL) {
                cout << "Queue is Full" << endl;
            }
        }
        else if (cmd == "dequeue") {
            ElemType elem;
            if (q.DeQueue(elem) == EMPTY) {
                cout << "Queue is Empty" << endl;
                continue;
            }
            cout << elem << endl;
        } 
        else if (cmd == "max"){
            ElemType elem =0x80000000;
            if (q.GetMaxValue(elem) == EMPTY) {
                cout << "Queue is Empty" << endl;
                continue;
            }
            cout << elem << endl;
        } 
        else if (cmd == "quit") {
            break;
        }
        else {
            break;
        }
    }

    // 输出队列中元素
    while (!q.QueueEmpty()) {
        ElemType elem;
        q.DeQueue(elem);
        cout << elem ;
        if (!q.QueueEmpty()) {
            cout << " ";
        }
    }
    cout << endl;

    return 0;
}

//下面是具体函数实现
// 基础栈类的构造函数
Stack::Stack() {
    base = new ElemType[MAX];
    top = base;
    stacksize = MAX;
}

// 基础栈类的析构函数
Stack::~Stack() {
    delete[] base;
    stacksize = 0;
}

// 检查栈是否为空
bool Stack::StackEmpty() { return (top == base); }

// 检查栈是否已满
bool Stack::StackFull() { return (top == base + stacksize); }

// 将元素压入栈中
Status Stack::Push(ElemType elem) {
    if (StackFull()) {
        return FULL;
    }
    *top++ = elem;
    return OK;
}

// 弹出栈顶元素
Status Stack::Pop(ElemType& elem) {
    if (StackEmpty()) {
        return EMPTY;
    }
    elem = *--top;
    return OK;
}

// 获取栈顶元素但不弹出
Status Stack::PeekTop(ElemType& elem) {
    if (StackEmpty()) {
        return EMPTY;
    }
    elem = *(top-1);
    return OK;
}

// 带最大值栈类的弹出操作
Status Stack_pro::Pop(ElemType& elem) {
    ElemType temp;
    if (value.StackEmpty()) {
        return EMPTY;
    }
    value.Pop(elem);
    max_value.PeekTop(temp);
    if (elem == temp) {
        max_value.Pop(temp);
    }
    return OK;
}

// 带最大值栈类获取栈顶元素但不弹出
Status Stack_pro::PeekTop(ElemType& elem) {
    if (value.StackEmpty()) {
        return EMPTY;
    }
    value.PeekTop(elem);
    return OK;
}

// 带最大值栈类获取当前最大值
Status Stack_pro::GetMaxValue(ElemType& elem) {
    if (max_value.StackEmpty()) {
        return EMPTY;
    }
    max_value.PeekTop(elem);
    return OK;
}

// 带最大值栈类的压入操作
Status Stack_pro::Push(ElemType elem) {
    ElemType temp;
    max_value.PeekTop(temp);

    if (value.Push(elem) == FULL) {
        return FULL;
    }
    if (max_value.StackEmpty() || elem >= temp) {
        max_value.Push(elem);
    }
    return OK;
}

// 检查带最大值栈是否为空
bool Stack_pro::StackEmpty() { return value.StackEmpty(); }

// 检查带最大值栈是否已满
bool Stack_pro::StackFull() { return value.StackFull(); }

// 栈队列类获取最大值的方法
Status Stack_pro_max::GetMaxValue(ElemType& elem) {
    elem = 0X80000000;
    if (num <= 0) {
        return EMPTY;
    }
    ElemType temp=0X80000000;
    if (!b.StackEmpty()) {
        b.GetMaxValue(elem);
    }
    if (!a.StackEmpty()) {
        a.GetMaxValue(temp);
        elem = (elem > temp) ? elem : temp;
    }
    return OK;
}

// 检查栈队列是否为空
bool Stack_pro_max::QueueEmpty() { return (num <= 0); }

// 栈队列的出队操作
Status Stack_pro_max::DeQueue(ElemType& elem) {
    if (num <= 0) {
        return EMPTY;
    }
    if (b.StackEmpty()) {
        ElemType temp;
        //将栈 a 的所有元素弹出并压入栈 b
        while (!a.StackEmpty()) {
                    a.Pop(temp);
                    b.Push(temp);
        }
    }
    b.Pop(elem);
    num--;
    return OK;
}

// 栈队列的入队操作
Status Stack_pro_max::EnQueue(ElemType elem) {
    if (num >= MAX) {
        return FULL;
    }
    a.Push(elem);
    num++;
    return OK;
}