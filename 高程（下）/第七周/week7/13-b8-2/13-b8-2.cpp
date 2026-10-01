/* 计拔 2351520 毛星博 */
#include <iostream>
#include <cstdio>  
/* --如果某编译器有需要，此处允许按条件编译的格式加入头文件 --*/

using namespace std;

int main()
{
	char a[80];
	
#if defined(__linux__)       //Linux
	fgets(a, 80, stdin); //不需要处理最后的回车
#elif defined(_MSC_VER)       //VS2022
	gets_s(a);
#elif defined(__GNUC__)  //DevC++
	gets(a);
#endif

	cout << a << endl;
	return 0;
}
