/* 计拔 2351520 毛星博 */
#include <iostream>
#include <cstring>
#include <iomanip>
#include <fstream>
using namespace std;

int usage(const char* const procname)
{
	cout << "Usage : " << procname << " --check 文件名 | --convert { wtol|ltow } 源文件名 目标文件名" << endl;
	cout << "        " << procname << " --check a.txt" << endl;
	cout << "        " << procname << " --convert wtol a.win.txt a.linux.txt" << endl;
	cout << "        " << procname << " --convert ltow a.linux.txt a.win.txt" << endl;
	return 0;
}

int check(ifstream& file)
{
	int W = 0, L = 0;
	char c;

	while (file.get(c)) {
		if (c == 0x0A) {
			file.seekg(-2, ios::cur);
			file.get(c);
			if (c == 0x0D)
				W++;
			else
				L++;
			file.seekg(2, ios::cur);
		}
	}

	/*cout << W << " " << L << endl;*/
	if (W > 0 && L == 0)
		return 1;  // Windows
	else if (W == 0 && L > 0)
		return 2;  // Linux
	else
		return 0;   // 无法识别	
}

int main(int argc, char* argv[])
{
	if (argc == 3) {
		if (strcmp(argv[1], "--check") == 0) {
			ifstream in(argv[2], ios::binary);
			if (!in) {
				cout << "输入文件" << argv[2] << "打开失败!" << endl;
				return -1;
			}

			int status = check(in);

			if(status==1)
				cout<<"Windows格式"<<endl;
			else if(status==2)
				cout<<"Linux格式"<<endl;
			else
				cout<<"文件格式无法识别"<<endl;

			in.close();
		}
		else {
			return usage(argv[0]);
		}
	}
	else if (argc == 5) {
		if (strcmp(argv[1], "--convert") != 0) {
			return usage(argv[0]);
		}
		
		if (strcmp(argv[2], "wtol") == 0) {  //Windows转Linux,将最后的 0D0A 转为 0A 即可
			ifstream in0(argv[3], ios::binary);
			if (!in0) {
				cout << "输入文件" << argv[3] << "打开失败!" << endl;
				return -1;
			}
			if (check(in0) != 1) {
				cout<<"文件格式无法识别" << endl;
				in0.close();
				return -1;
			}

			ofstream out(argv[4], ios::binary);
			if (!out) {
				cout << "输出文件" << argv[4] << "打开失败!" << endl;
				return -1;
			}

			ifstream in(argv[3], ios::binary);

			char c;
			int count = 0;
			while (in.get(c)) {
				if (c == 0x0D) {
					in.get(c);
					if(c==0x0A){
						count++;
						out.put(0x0A);
					}
					else{
						in.seekg(-1, ios::cur);
						out.put(0x0D);
					}
				}
				else {
					out.put(c);
				}
			}
			cout<<"转换完成，去除"<<count<<"个0x0D"<<endl;

			in.close();
			out.close();
		}
		else if (strcmp(argv[2], "ltow") == 0) {  //Linux转Windows,将 0A 转为 0D0A 即可
			ifstream in0(argv[3], ios::binary);
			if (!in0) {
				cout << "输入文件" << argv[3] << "打开失败!" << endl;
				return -1;
			}
			if (check(in0) != 2) {
				cout<<"文件格式无法识别" << endl;
				in0.close();
				return -1;
			}

			ofstream out(argv[4], ios::binary);
			if (!out) {
				cout << "输出文件" << argv[4] << "打开失败!" << endl;
				return -1;
			}

			ifstream in(argv[3], ios::binary);

			char c;
			int count = 0;
			while (in.get(c)) {
				if (c == 0x0A) {
					count++;
					out.put(0x0D);
					out.put(0x0A);
				}
				else {
					out.put(c);
				}
			}
			cout<<"转换完成，加入"<<count<<"个0x0D"<<endl;

			in.close();
			out.close();
		}
		else {
			return usage(argv[0]);
		}
	}
	else {
		return usage(argv[0]);
	}

	return 0;
}