#include <iostream>
using namespace std;

// template<int N>
// void fun(char (&a)[N])
// {
//     cout<<sizeof(a)<<endl;
// }
 
int main()
{
    // 方式1：使用栈内存（不需要delete）
    int a;
    int* p1 = &a;
    // 使用p1...
    // 不需要delete p1
    
    // 方式2：使用堆内存（需要delete）
    int* p2 = new int;
    // 使用p2...
    delete p2;  // 只有new分配的内存才能delete
    
    return 0;
}