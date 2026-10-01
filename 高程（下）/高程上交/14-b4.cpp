/* 计拔 2351520 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cstring>
using namespace std;

int usage(const char* const procname)
{
	cout << "Usage: " << procname << " [-l 大小] [-n 数量] [-t] IP地址" << endl;
	cout << "       " <<  "==================================" << endl;
	cout << "       " <<  " 参数 附加参数 范围        默认值" << endl;
	cout << "       " <<  "==================================" << endl;
	cout << "       " <<  " -l   1        [32..64000] 64" << endl;
	cout << "       " << " -n   1        [1..1024]   4" << endl;
	cout << "       " << " -t   0        [0..1]      0" << endl;
	cout << "       " << "==================================" << endl;
	return 0;
}

bool test_ip(const char* ip)
{
	int n = 0;
	int x = 0;
	int num;
	char c[10];
	for (int i = 0; i <= (int)strlen(ip); i++) {
		if (ip[i] == '.'|| ip[i] == '\0') {
			n++;
			strncpy(c, ip + x , i - x);
			c[i - x] = '\0';
			if(strlen(c) == 0)
				return false;
			num = atoi(c);
			if (num < 0 || num > 255) {
				return false;
			}
			x = i+1;
		}
	}
	if(n!= 4)
		return false;
	return true;
}

int main(int argc, char* argv[])
{
	if (argc < 2) {
		return usage(argv[0]);
	}

	const char* ip = argv[argc - 1];
	bool is_t = false;
	int L = 64;
	int N = 4;

	if (test_ip(ip) == false) {
		cout << "IP地址错误" << endl;
		return -1;
	}

	for (int i = 1; i < argc - 1; i++) {
		if (argv[i][0] == '-') {
			if (strcmp(argv[i], "-l") == 0) {
				if (i + 2 >= argc || argv[i + 1][0] == '-') {
					cout << "参数-l没有后续参数" << endl;
					return -1;
				}
				L = atoi(argv[i + 1]);
				if (L < 32 || L > 64000) {
					L = 64;
				}
				i++;
			}
			else if (strcmp(argv[i], "-n") == 0) {
				if (i + 2 >= argc || argv[i + 1][0] == '-') {
					cout << "参数-n没有后续参数" << endl;
					return -1;
				}
				N = atoi(argv[i + 1]);
				if (N < 1 || N > 1024) {
					N = 4;
				}
				i++;
			}
			else if (strcmp(argv[i], "-t") == 0) {
				is_t = true;
			}
			else {
				cout << "参数" << argv[i] << "不存在" << endl;
				return -1;
			}
		}
		else {
			cout << "参数" << argv[i] << "不是以-开头的合法参数" << endl;
			return -1;
		}
	}

	cout<<"参数检查通过"<<endl;
	cout << "-l 参数：" << L << endl;
	cout << "-n 参数：" << N << endl;	
	cout << "-t 参数：" << is_t << endl;
	cout << "IP地址：" << ip << endl;

	return 0;
}