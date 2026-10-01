/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

struct student {
	int no;			//学号，不考虑 0 开头 
	char name[9];   //姓名，最长 4 个汉字（无生僻字，均为双字节 GB 汉字） 
	int score;		//成绩，不考虑小数点 
	int rank;		//名次 
};

int main()
{
	int n;
	student* p;
	ifstream fin;

	fin.open("student.txt", ios::in);
	if (!fin.is_open()) {
		cout << "文件打开失败" << endl;
		return -1;
	}

	fin >> n;
	p = new(nothrow)student[n];
	if (p == NULL) {
		cout << "内存分配失败" << endl;
		return -1;
	}

	for (int i = 0; i < n; i++) {
		fin >> p[i].no >> p[i].name >> p[i].score;
	}
	fin.close();

	//先按成绩冒泡排序
	for (int i = 0; i < n - 1; i++) {
		for (int j = 0; j < n - i - 1; j++) {
			if (p[j].score < p[j + 1].score) {
				struct student temp = p[j];
				p[j] = p[j + 1];
				p[j + 1] = temp;
			}
			else if (p[j].score == p[j + 1].score) {
				if (p[j].no > p[j + 1].no) {
					struct student temp = p[j];
					p[j] = p[j + 1];
					p[j + 1] = temp;
				}
			}
		}
	}

	//赋值名次
	p[0].rank = 1;
	for (int i = 1; i < n; i++) {
		if (p[i].score == p[i - 1].score) {
			p[i].rank = p[i - 1].rank;
		}
		else {
			p[i].rank = i + 1;
		}
	}

	//输出结果
	for (int i = 0; i < n; i++) {
		cout << p[i].no << " " << p[i].name << " "  << p[i].score << " "  << p[i].rank << endl;
	}

	delete[] p;
	return 0;
}