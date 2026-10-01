/* 计拔 2351520 毛星博 */
/* 2354366 徐华炫 2352841 刘佳鑫 2353599 冯灏然 2352035 曹劭杰 2354273 谢羽涵 */
#include <iostream>
#include <cstring>
#include <iomanip>
#include <fstream>
using namespace std;

int usage(const char* const procname)
{
	cout << "Usage : " << procname << " --infile hex格式文件 --outfile bin格式文件" << endl;
	cout << "        " << procname << " --infile a.hex --outfile a.bin" << endl;
	return 0;
}

int hex2int(char* c)
{
	int i = 0;
	for (int j = 0; j < 2; j++) {
		i <<= 4;
		if (c[j] >= '0' && c[j] <= '9') {
			i += c[j] - '0';
		}
		else if (c[j] >= 'a' && c[j] <= 'f') {
			i += c[j] - 'a' + 10;
		}
		else if (c[j] >= 'A' && c[j] <= 'F') {
			i += c[j] - 'A' + 10;
		}
		else {
			return -1;
		}
	}
	return i;
}

void infine_to_outfine(fstream& in, fstream& out)
{
	char str[30] = { 0 };
	char line[100]={0};
	int n = 0;

	while (in.getline(line, 100)) {
		n = 0;
		for (unsigned int j = 0; j < strlen(line); j++) {
			if (line[j] != ' ') {
				str[n]=line[j];
				n++;
			}
			else {
				while (line[j + 1]==' ')
					j++;
				str[n]='\0';
				if(strlen(str)==2)
					out<<char(hex2int(str));
				n = 0;
			}
		}
	}
}

int main(int argc, char* argv[])
{
	if (argc!= 5) {
		return usage(argv[0]);
	}

	if (strcmp(argv[1], "--infile") == 0 && strcmp(argv[3], "--outfile") == 0) {
		fstream in(argv[2], ios::in | ios::binary);
		if (!in) {
			cout << "输入文件" << argv[2] << "打开失败!" << endl;
			return -1;
		}

		fstream out(argv[4], ios::out | ios::binary);
		if (!out) {
			cout << "输出文件" << argv[4] << "打开失败!" << endl;
			return -1;
		}

		infine_to_outfine(in, out);

		in.close();
		out.close();
	}
	else if (strcmp(argv[3], "--infile") == 0 && strcmp(argv[1], "--outfile") == 0) {
		fstream in(argv[4], ios::in | ios::binary);
		if (!in) {
			cout << "输入文件" << argv[4] << "打开失败!" << endl;
			return -1;
		}

		fstream out(argv[2], ios::out | ios::binary);
		if (!out) {
			cout << "输出文件" << argv[2] << "打开失败!" << endl;
			return -1;
		}

		infine_to_outfine(in, out);

		in.close();
		out.close();
	}
	else {
		return usage(argv[0]);
	}

	return 0;
}

