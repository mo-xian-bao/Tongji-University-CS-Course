#include <iostream>
using namespace std;

int main(int argc, char *argv[])
{
    while(1)
    {
    	cout<<"Hello World!"<<endl;
    	system("sleep 2");
    }
    return 0;
}

// 这个程序执行时，用ctrl+c杀不死。 这是因为，ctrl+c 向所有前台进程发SIGINT信号，用SIGINT信号杀死这些进程。
// system( )函数执行期间忽略 SIGINT 和 SIGQUIT 信号。这是因为，system函数执行机制极为复杂，它会创建shell进程来执行参数字符串指定的命令。
// 详见 https://blog.csdn.net/DLUTBruceZhang/article/details/8630882


