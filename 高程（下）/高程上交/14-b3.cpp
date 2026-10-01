/* 计拔 2351520 毛星博 */
#include <iostream>
#include <cstring>
using namespace std;

int usage(const char* const procname)
{
	cout << "Usage: " << procname << " 要检查的学号/all 匹配学号/all 源程序名/all 相似度阀值(60-100) 输出(filename/screen)" << endl << endl;
	cout << "e.g. : " << procname << " 2159999 2159998 all       80 screen" << endl;
	cout << "       " << procname << " 2159999 all     14-b1.cpp 75 result.txt" << endl;
	cout << "       " << procname << " all     all     14-b2.cpp 80 check.dat" << endl;
	cout << "       " << procname << " all     all     all       85 screen" << endl;

	return 0;
}

int main(int argc, char* argv[])
{
	if (argc < 6) {
		return usage(argv[0]);
	}

	const char* checkID = argv[1];
	const char* matchID = argv[2];
	const char* sourceFile = argv[3];
	int similarity = atoi(argv[4]);
	const char* output = argv[5];

	if(strcmp(checkID, "all") != 0) {
		if (strlen(checkID) != 7) {
			cout << "要检查的学号不是7位" << endl;
			return -1;
		}
		else{
			for(int i = 0; i < 7; i++) {
				if(isdigit(checkID[i]) == 0){
					cout << "要检查的学号不是7位数字" << endl;
					return -1;
				}
			}
		}
	}

	if(strcmp(matchID, "all") != 0) {
		if(strcmp(checkID, "all") == 0){
			cout << "检查学号是all，匹配学号必须是all" << endl;
			return -1;
		}
		if (strlen(matchID) != 7) {
			cout << "要匹配的学号不是7位" << endl;
			return -1;
		}
		else{
			for(int i = 0; i < 7; i++) {
				if(isdigit(matchID[i]) == 0){
					cout << "要匹配的学号不是7位数字" << endl;
					return -1;
				}
			}
		}
	}

	if(strcmp(sourceFile, "all") != 0) {
		if (strlen(sourceFile) > 32) {
			cout << "源程序文件名超过了32字节" << endl;
			return -1;
		}
	}

	if (similarity < 60 || similarity > 100) {
		similarity = 80;
	}

	if (strlen(output) > 32) {
		cout << "输出结果文件名超过了32字节" << endl;
		return -1;
	}

	cout<<"参数检查通过"<<endl;
	cout<<"检查学号："<<checkID<<endl;
	cout<<"匹配学号："<<matchID<<endl;
	cout<<"源文件名："<<sourceFile<<endl;
	cout<<"匹配阈值："<<similarity<<endl;
	cout<<"输出目标："<<output<<endl;

	return 0;
}