/* 计拔 2351520 毛星博 */
#include <iostream>
#include <cstring>
#include <iomanip>
using namespace std;

void print_on_off_switch(short on_off_switch);
int stricmp_my(const char* s1, const char* s2);

int main()
{
	short on_off_switch = 0;
	char a;
	char b[10];

	cout<<"初始状态："<<hex  <<"0x" << setfill('0') << setw(4) <<on_off_switch<<endl;
	print_on_off_switch(on_off_switch);

	while (true) {
		cout<<"请以(\"A On /J Off\"形式输入，输入\"Q on/off\"退出)"<<endl;
		cin>>a>>b;

		if (a == 'Q' || a == 'q') {
			break;
		}

		if ((a >= 'A' && a <= 'J') || (a >= 'a' && a <= 'j')) {
			if (stricmp_my(b, "on") == 0) {
				on_off_switch |= (1 << (a - 'a'>0? a - 'a' : a - 'A'));
			}
			else if (stricmp_my(b, "off") == 0) {
				on_off_switch &= ~(1 << (a - 'a'>0? a - 'a' : a - 'A'));
			}
			else {
				continue;
			}
			cout<<"当前状态："<<hex<<"0x" << setfill('0') << setw(4) <<on_off_switch<<endl;
			print_on_off_switch(on_off_switch);
		}
		else {
			continue;
		}
	}
}

void print_on_off_switch(short on_off_switch)  //从低位开始打印10位
{
	for (int i = 0; i < 10; i++) {
		cout << char('A' + i) << "   ";
	}
	cout << endl;

	for (int i = 0; i < 10; i++) {
		if ((on_off_switch >> i) & 1) {
			cout<<"ON  "; 
		}
		else {
			cout<<"OFF ";
		}
	}
	cout << endl;
	cout << endl;
}

int stricmp_my(const char* s1, const char* s2) {
	while (*s1 && *s2) {
		char c1 = (*s1 >= 'A' && *s1 <= 'Z') ? *s1 + 32 : *s1;
		char c2 = (*s2 >= 'A' && *s2 <= 'Z') ? *s2 + 32 : *s2;
		if (c1 != c2) {
			return (unsigned char)c1 - (unsigned char)c2; 
		}
		s1++;
		s2++;
	}
	return (unsigned char)(*s1) - (unsigned char)(*s2); 
}