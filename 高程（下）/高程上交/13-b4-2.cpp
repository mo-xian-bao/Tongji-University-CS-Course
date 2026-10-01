/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstring>
using namespace std;

struct student {
	int* no; //学号，不考虑 0 开头 
	char* name; //姓名，无生僻字，均为双字节 GB 汉字 
	int* score; //成绩，不考虑小数点 
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
			cout << "内存分配失败" << endl;
			return -1;
		}

		q->no=new(nothrow)int;
		q->score=new(nothrow)int;

		if (q->no == NULL || q->score == NULL) {
			cout << "内存分配失败" << endl;
			return -1;
		}

		fin >> *(q->no);

		char nameBuffer[100];
		fin>>nameBuffer;
		q->name = new(nothrow)char[strlen(nameBuffer) + 1];
		if (q->name == NULL) {
			cout << "内存分配失败" << endl;
			return -1;
		}
		strcpy(q->name, nameBuffer);

		fin >> *(q->score);

		if (*(q->no) == 9999999) {
			delete q->no;
			delete[] q->name;
			delete q->score;
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
		cout << *(p->no) << " "  << p->name << " " <<  *(p->score) << endl;
		q = p;
		p = p->next;
		delete q->no;
		delete[] q->name;
		delete q->score;
		delete q;
	}

	return 0;
}