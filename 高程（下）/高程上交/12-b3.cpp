/* 2351520 计拔 毛星博 */
#include <iostream> 
using namespace std;
int main()
{
	int number;
	const char* month[] = { "January","February","March","April","May","June","July","August","September","October","November","December" };
	cout<<"请输入月份(1-12)"<<endl;
	cin >> number;
	if (number >= 1 && number <= 12 && cin.good()) 
		cout<<month[number-1]<<endl;
	else 
		cout<<"Invalid"<<endl;
	return 0;
}