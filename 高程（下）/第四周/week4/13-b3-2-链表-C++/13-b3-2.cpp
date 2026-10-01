/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

struct student {
	int no; //学号，不考虑 0 开头 
	char name[9]; //姓名，最长 4 个汉字（无生僻字，均为双字节 GB 汉字） 
	int score; //成绩，不考虑小数点 
	struct student* next;
};

int main()
{
	struct student* p, * head, * q;
	ifstream fin;

	fin.open("list.txt", ios::in);
	if (!fin.is_open()) {
		cout << "文件打开失败" << endl;
		return -1;
	}

	head = NULL;
	p = NULL;

	while (1) {
		q = new(nothrow)student;
		if (q == NULL) {
			cout<<"内存分配失败"<<endl;
			return -1;
		}

		fin>>q->no>>q->name>>q->score;
		if (q->no == 9999999) {
			delete q;
			break;
		}

		q->next = NULL;

		if (head == NULL) {
			head = q;
		}
		else {
			p->next = q;
		}
		p = q;
	}

	fin.close();

	p = head;
	while (p != NULL) {
		cout << p->no << " " << setw(8)<<left << p->name << " " << setw(3)<<right << p->score << endl;
		q = p;
		p = p->next;
		delete q;
	}

	return 0;
}