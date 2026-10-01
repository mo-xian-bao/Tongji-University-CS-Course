#include <iostream>
#include <cstring>

using namespace std;

struct Stack {
	int* top;
	int* base;
	int size = 10;

	Stack() {  //构造函数
		top = new int[size];
		base = top;
	}

	void push(char c) {  //入栈
		if (top - base == size) {
			int* new_base = new int[size * 2];
			memcpy(new_base, base, size);
			delete[] base;
			base = new_base;
			top = base + size;
			size *= 2;
		}
		*(top++) = c;
	}

	int pop() {  //出栈
		if (top == base) {
			return -1;
		}
		return *(--top);
	}

	int top_element() {  //栈顶元素
		if (top == base) {
			return -1;
		}
		return *(top - 1);
	}

	bool empty() {  //判断栈是否为空
		return top == base;
	}
};

int main()
{
	char str[100000];

	while (cin >> str) {
		int max_len = 0,len = 0;
		int start_position = 0;

		if (str == NULL || str == "") {
			cout << "0 0";
			continue;
		}

		Stack s;
		char* p = str;

		for(int i = 0; i < strlen(str); i++) {
			if (s.empty()) {
				if (str[i] == '(') {
					s.push(i);
				}
				else if (str[i] == ')') {
					continue;
				}
			}
			else if (str[i] == '(') {
				s.push(i);
			}
			else if (str[i] == ')') {
				len=i-s.top_element()+1;
				if (len > max_len) {
					max_len = len;
					start_position = s.top_element();
				}
				s.pop();
			}
		}

		cout << max_len << " " << start_position << endl;  //输出结果
	}

	return 0;
}