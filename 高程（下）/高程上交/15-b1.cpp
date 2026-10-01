/* 计拔 2351520 毛星博 */
#include <iostream>
#include <cstring>
#include <iomanip>
#include <fstream>
using namespace std;

int usage(const char* const procname)
{
	cout << "Usage : " << procname << " --infile 原始文件 [ --outfile hex格式文件 ]" << endl;
	cout << "        " << procname << " --infile a.docx" << endl;
	cout << "        " << procname << " --infile a.docx --outfile a.hex" << endl;
	return 0;
}

void infile_to_outfile(fstream& in, fstream& out)
{
	unsigned char c;
	char ch[17] = { 0 };
	int i = 0;
	
	while ((c = in.get()) != EOF&&!in.eof()) {
		if (i % 16 == 0)
			out << setw(8) << setfill('0') << hex << in.tellg() - streamoff(1) << "  ";
		if (i % 16 == 8)
			out << "- ";
		out << setw(2) << setfill('0') << hex << (int)c << " ";
		ch[i % 16] = c;
		if (i % 16 == 15) {
			out << "    ";
			//输出这一行的16个字符
			for (int j = 0; j < 16; j++) {
				if (ch[j] >= 33 && ch[j] <= 126)
					out << ch[j];
				else
					out << ".";
				ch[j] = 0;
			}
			out << endl;
		}
		i++;
	}
	//输出最后一行不满16个字符的部分
	if (i % 16 != 0) {
		for (int j = i % 16; j < 16; j++) {
			out << "   ";
			if (j == 7)
				out << "  ";
		}
		out << "    ";
		//输出这一行的剩余部分
		for (int j = 0; j < i % 16; j++) {
			if (ch[j] >= 33 && ch[j] <= 126)
				out << ch[j];
			else
				out << ".";
			ch[j] = 0;
		}
		out << endl;
	}
}

int main(int argc, char* argv[])
{
	unsigned char c;
	char ch[17] = { 0 };
	int i=0;

	if (argc == 3) {  
		if (strcmp(argv[1], "--infile")==0) {
			fstream in(argv[2], ios::in | ios::binary);
			if (!in) {
				cout<<"输入文件"<<argv[2]<<"打开失败!"<<endl;
				return -1;
			}
			while ((c = in.get()) != EOF && !in.eof()) {
				if (i % 16 == 0) 
					cout << setw(8) << setfill('0') << hex << in.tellg()- streamoff(1) << "  "; 
				if (i % 16 == 8)
					cout << "- ";
				cout << setw(2) << setfill('0') << hex << (int)c << " ";
				ch[i % 16] = c;
				
				if (i % 16 == 15) {
					cout << "    ";
					//输出这一行的16个字符
					for (int j = 0; j < 16; j++) {
						if(ch[j]>=33 && ch[j]<=126)
							cout << ch[j];
						else
							cout << ".";
						ch[j] = 0;
					}
					cout << endl;
				}
				i++;
			}
			//输出最后一行不满16个字符的部分
			if (i % 16!= 0) {
				for (int j = i % 16; j < 16; j++) {
					cout << "   ";
					if (j == 7)
						cout << "  ";
				}
				cout << "    ";
				//输出这一行的剩余部分
				for (int j = 0; j < i % 16; j++) {
					if (ch[j] >= 33 && ch[j] <= 126)
						cout << ch[j] ;
					else
						cout << ".";
					ch[j] = 0;
				}
				cout << endl;
			}
			in.close();
		}
		else {
			return usage(argv[0]);
		}
	}

	else if (argc == 5) {
		if (strcmp(argv[1], "--infile")==0 && strcmp(argv[3], "--outfile")==0) {
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
			infile_to_outfile(in, out);
			in.close();
			out.close();
		}
		else if (strcmp(argv[1], "--outfile") == 0 && strcmp(argv[3], "--infile") == 0) {
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
			infile_to_outfile(in, out);
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