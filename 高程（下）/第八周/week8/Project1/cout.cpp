#include <iostream>
using namespace std;

int main()
{
	char ch[20];
	cin.get(ch, 20, '/');  //指针停留在'/'处
	cout << "The first part is:" << ch << endl;
	cin.ignore();          //跳过'/'
	cin.get(ch, 20, '/');  //从'/'后取，非空
	cout << "The second part is:" << ch << endl;
	return 0;
}
