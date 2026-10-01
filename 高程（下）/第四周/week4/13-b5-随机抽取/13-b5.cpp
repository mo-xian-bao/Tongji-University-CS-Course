/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <ctime>
#include <fstream>
using namespace std;

struct student {
	int no;
	char name[12];
	char school[9];
};

int main()
{
	srand(unsigned int(time(0)));

	int m, n; //m为报名总人数，n为录取人数
	ifstream fin;
	ofstream fout;
	int index = 0;
	bool flag = true;

	fin.open("stulist.txt", ios::in);
	if (!fin.is_open()) {
		cout << "文件打开失败" << endl;
		return -1;
	}
	fin >> n >> m;

	student* p = new(nothrow)student[m];
	student* q = new(nothrow)student[n];
	if (p == NULL) {
		cout << "空间申请失败" << endl;
		return -1;
	}
	if (q == NULL) {
		cout << "空间申请失败" << endl;
		return -1;
	}

	//从文件中读入所有报名学生的信息
	for (int i = 0; i < m; i++) {
		fin >> p[i].no >> p[i].name >> p[i].school;
	}

	fin.close();

	//随机抽取n名学生录取
	for (int i = 0; i < n; i++) {
		index = rand() % m;
		flag = true;
		for (int j = 0; j < i; j++) {
			if (p[index].no == q[j].no)
				flag = false;
		}
		if (flag) {
			q[i] = p[index];
		}
		else {
			i--;
		}
	}

	//输出到result文件
	fout.open("result.txt", ios::out);
	if (!fout.is_open()) {
		cout << "文件打开失败" << endl;
		return -1;
	}

	for (int i = 0; i < n; i++) {
		fout << q[i].no << " " <<q[i].name << " " << q[i].school << endl;
	}

	fout.close();
	delete[] p;
	delete[] q;
	cout << "已抽取名单，请前往result.txt查看" << endl;
	return 0;
}