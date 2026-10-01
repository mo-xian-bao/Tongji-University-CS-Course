/* 2351520 计拔 毛星博 */
#include <iostream>
#include <cstring>
#include <conio.h>
#include <Windows.h>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
using namespace std;

char all_menu(int mode, char menu[][100])  //整合菜单函数
{
	char choice;
	int length = 0;

	//求菜单的长度，用于确定横线的长度
	for (int i = 0; menu[i][0] != '\0'; i++) {
		if (length <= (int)strlen(menu[i])) {
			length = strlen(menu[i]);
		}
	}

	for (int i = 0; i < length; i++) {
		cout << "-";
	}
	cout << endl;
	for (int i = 0; menu[i][0] != '\0'; i++) {
		cout << menu[i] << endl;
	}
	for (int i = 0; i < length; i++) {
		cout << "-";
	}
	cout << endl;
	cout << "[请选择:]";

	//模式一：选项为数字，支持汉诺塔、彩球
	if (mode == 1) {
		while (1) {
			choice = _getch();
			if (choice != '1' && choice != '2' && choice != '3' && choice != '4' && choice != '5'
				&& choice != '0' && choice != '6' && choice != '7' && choice != '8' && choice != '9') {
				continue;
			}
			else {
				cout << choice << endl;
				cout << endl;
				cout << endl;
				return choice;
			}
		}
	}
	//模式二：选项为大小写字母，支持消灭星星
	else if (mode == 2) {
		while (1) {
			choice = _getch();
			if (choice != 'A' && choice != 'a' && choice != 'B' && choice != 'b' && choice != 'C' && choice != 'c' && choice != 'D' && choice != 'd'
				&& choice != 'E' && choice != 'e' && choice != 'F' && choice != 'f' && choice != 'G' && choice != 'g' && choice != 'Q' && choice != 'q') {
				continue;
			}
			else {
				cout << choice << endl;
				cout << endl;
				cout << endl;
				return choice;
			}
		}
	}
	else {
		return '0';
	}
}

void shuru(int mode, int& hang, int& lie) //输入行列数(模式2为彩球，模式3为星星)
{
	char c;
	int min, max;
	if (mode == 2) {
		min = 5;
		max = 9;
	}
	else if (mode == 3) {
		min = 8;
		max = 10;
	}

	while (6) {
		cout << "请输入行数(" << min << "-" << max << ")：" << endl;
		cin >> hang;
		if (cin.fail() || (hang > max || hang < min)) {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
		}
		else {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
			break;
		}
	}
	while (6) {
		cout << "请输入列数(" << min << "-" << max << ")：" << endl;
		cin >> lie;
		if (cin.fail() || (lie > max || lie < min)) {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
		}
		else {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
			break;
		}
	}
}

void print_shuzu(int mode, int hang, int lie, int& x, int& y, int shuzu[10][10]) //输出数组并返回第一个数的位置,模式一：打印内部数组,模式二：打印结果数组（非0位置输出*号）
{
	cout << "  | ";
	for (int i = 0; i < lie; i++) {
		cout << " " << i << " ";
	}
	cout << endl;
	cout << "--+-";
	for (int i = 1; i <= lie; i++) {
		cout << "---";
	}
	cout << endl;
	cct_getxy(x, y);
	x += 5;
	for (int i = 0; i < hang; i++) {
		cout << (char)('A' + i) << " | ";
		for (int j = 0; j < lie; j++) {
			if (mode == 1) {  //模式一：打印内部数组
				cout << " " << shuzu[i][j] << " ";
			}
			else if (mode == 2) {  //模式二：打印结果数组（非0位置输出*号）
				if (shuzu[i][j] > 0)
					cout << " * ";
				else
					cout << " 0 ";
			}
		}
		cout << endl;
	}
	cout << endl;
}

void wait_for_return() //输入end返回菜单
{
	int x, y;
	char a[5] = { 0 }/*, c*/;

	/*cin.clear();
	while ((c = cin.get()) != '\n' && c != EOF);*/

	cout << "本小题结束，请输入End继续...";
	cct_getxy(x, y);
	while (1) {
		cct_gotoxy(x, y);
		cout << "    ";
		cct_gotoxy(x, y);
		fgets(a, 5, stdin);
		if (_strnicmp(a, "End", 3) != 0) {
			cct_gotoxy(0, y + 1);
			cout << "输入错误，请重新输入";
		}
		else
			break;
	}
}

void huiche() //回车等待
{
	char c;
	while (1) {
		c = _getch();
		if (c == '\r') {
			break;
		}
	}
}

void MOVE(int mode, int shuju[10][10], int hang, int lie, int frame_shixin_or_kongxin,int sekuai_shu, 
	       int sekuai_heng, const char* neirong, int biaohao, int fenge,int tuxing_shixin_or_kongxin) //移动函数
{
	int qishi_x, qishi_y;
	char frame_kongxin[100] = "╔═╗║╚╝╦╠╬╣╩";
	char frame_shixin[100] = "┏━┓┃┗┛┳┣╋┫┻";
	char* frame_zhonglei;

	if (biaohao == 1) {
		qishi_x = 4;
		qishi_y = 3;
	}
	else if (biaohao == 0) {
		qishi_x = 2;
		qishi_y = 2;
	}

	//参数决定边框是实心的还是空心的
	if (frame_shixin_or_kongxin == 1) {
		frame_zhonglei = frame_shixin;
	}
	else {
		frame_zhonglei = frame_kongxin;
	}

	if (mode == DOWN||mode==DOWN_LEFT) {  //表示下落
		for (int j = 0; j < lie; j++) {
			for (int i = hang - 1; i > 0; i--) {
				if (shuju[i][j] == 0) {
					int k;
					for (k = i; shuju[k][j] == 0; k--) {
						if (k == -1) {
							break;
						}
					}
					if (k == -1) {
						break;
					}
					for (; k < i; k++) {
						shuju[k + 1][j] = shuju[k][j];
						if (fenge == 1) {
							for (int r = 0; r < (sekuai_shu + 1); r++) {
								edit_tuxing(shuju[k][j], qishi_x + j * (sekuai_heng + 2), qishi_y + k * (sekuai_shu + 1) + r, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 0);
								edit_tuxing(shuju[k][j], qishi_x + j * (sekuai_heng + 2), qishi_y + k * (sekuai_shu + 1) + r + 1, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 1);
								Sleep(10);
							}
							cct_gotoxy(qishi_x + j * (sekuai_heng + 2), qishi_y + k * (sekuai_shu + 1) + sekuai_shu);
							cct_setcolor(15, 0);
							for (int r = 0; r < sekuai_heng / 2; r++) {
								cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
							}
							Sleep(10);
						}
						else {
							for (int r = 0; r < sekuai_shu; r++) {
								edit_tuxing(shuju[k][j], qishi_x + j * sekuai_heng, qishi_y + k * sekuai_shu + r, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 0);
								edit_tuxing(shuju[k][j], qishi_x + j * sekuai_heng, qishi_y + k * sekuai_shu + r + 1, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 1);
								Sleep(10);
							}
							Sleep(10);
						}
						shuju[k][j] = 0;
					}
				}
			}
		}
	}

	if (mode == DOWN_LEFT) {
		for (int j0 = 0;j0<lie-1; j0++) {
			int count1 = 0;
			for (int i = 0; i < hang; i++) {
				count1 += shuju[i][j0];
			}
			if (count1 == 0) {
				int count2 = 0;
				int j1;
				for (j1 = j0+1; j1 < lie-1; j1++) {
					for (int i = 0; i < hang; i++) {
						count2 += shuju[i][j1];
					}
					if (count2 != 0) {
						break;
					}
				}
				for (int j = j1 - 1; j >= j0; j--) {
					for (int i = 0; i < hang; i++) {
						if (shuju[i][j + 1] != 0) {
							if (fenge == 1) {
								for (int k = 0; k < 2 + sekuai_heng; k++) {
									edit_tuxing(shuju[i][j + 1], qishi_x + (j + 1) * 8 - k, qishi_y + i * 4, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 0);
									edit_tuxing(shuju[i][j + 1], qishi_x + (j + 1) * 8 - k - 1, qishi_y + i * 4, tuxing_shixin_or_kongxin, sekuai_shu, sekuai_heng, neirong, 1);
									Sleep(1);
								}
								cct_setcolor(15, 0);
								for (int r = 0; r < sekuai_shu; r++) {
									cct_gotoxy(qishi_x + (j + 1) * 8 - 2, qishi_y + i * 4 + r);
									cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
								}
								Sleep(1);
							}
							shuju[i][j] = shuju[i][j + 1];
							shuju[i][j + 1] = 0;
						}
					}
				}
			}
		}
	}
	cct_setcolor();
}

void highlight(int mode, int hang, int lie, int shuju[10][10], int jieguo[10][10], int x, int y) //标记函数，对数组进行各种标记操作(在已打印的原数组基础上修改)
{
	//模式一：根据结果函数对数组原值修改为高亮标记
	if (mode == 1) {
		cct_setcolor(14, 4);
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] > 0) {
					cct_gotoxy(x + j * 3, y + i);
					cout << shuju[i][j];
				}
			}
		}
		cct_setcolor(0, 7);
	}

	//模式二：对数组0项标记高亮
	else if (mode == 2) {
		cct_setcolor(14, 4);
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (shuju[i][j] == 0) {
					cct_gotoxy(x + j * 3, y + i);
					cout << shuju[i][j];
				}
			}
		}
		cct_setcolor(0, 7);
	}

	//模式3：标亮并对0填充新的值
	else if (mode == 3) {
		cct_setcolor(14, 1);
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (shuju[i][j] == 0) {
					cct_gotoxy(x + j * 3, y + i);
					shuju[i][j] = rand() % 9 + 1;
					cout << shuju[i][j];
				}
			}
		}
		cct_setcolor(0, 7);
	}
}

int shuzu_zhiling(int hang, int lie, int shuju[10][10], int jieguo[10][10])  //根据结果数组对数组可消除项置零，并清空结果数组
{
	int count = 0;
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (jieguo[i][j] > 0) {
				shuju[i][j] = 0;
				jieguo[i][j] = 0;
				count++;
			}
		}
	}
	return count;
}

void paint_frame(int hang, int lie, int shuju[10][10], int fenge, int biaohao, int shixin_or_kongxin, int sekuai_shu, int sekuai_heng)  //画框架函数
{
	int qishi_x, qishi_y;
	char frame_kongxin[100] = "╔═╗║╚╝╦╠╬╣╩";
	char frame_shixin[100] = "┏━┓┃┗┛┳┣╋┫┻";
	char* frame_zhonglei;

	//参数决定边框是否有标号
	if (biaohao == 1) {
		if (fenge == 0) {
			for (int i = 0; i < hang; i++) {
				cct_gotoxy(0, 1 + 3 * (i + 1));
				cout << (char)('A' + i);
			}
			for (int j = 0; j < lie; j++) {
				cct_gotoxy(6 * (j + 1), 1);
				cout << j;
			}
		}
		else {
			cct_gotoxy(0, 1 + sekuai_shu);
			cout << 'A';
			for (int i = 1; i < hang; i++) {
				cct_gotoxy(0, 1 + sekuai_shu + (1 + sekuai_shu) * i);
				cout << (char)('A' + i);
			}
			cct_gotoxy(3 + sekuai_heng / 2, 1);
			cout << '0';
			for (int j = 1; j < lie; j++) {
				cct_gotoxy(3 + sekuai_heng / 2 + j * (sekuai_heng + 2), 1);
				cout << j;
			}
		}
		qishi_x = 2;
		qishi_y = 2;
	}
	else if (biaohao == 0) {
		qishi_x = 0;
		qishi_y = 1;
	}

	//参数决定边框是实心的还是空心的
	if (shixin_or_kongxin == 1) {
		frame_zhonglei = frame_shixin;
	}
	else {
		frame_zhonglei = frame_kongxin;
	}

	if (fenge == 0) {  //无分隔线
		//cct_setfontsize(0,100);
		cct_setcolor(15, 0);
		cct_gotoxy(qishi_x, qishi_y);
		cout << frame_zhonglei[0] << frame_zhonglei[1]<<" ";
		for (int j = 0; j < lie * sekuai_heng / 2; j++) {
			cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
		}
		Sleep(1);
		cout << frame_zhonglei[4] << frame_zhonglei[5]<<" ";

		for (int i = 0; i < hang * sekuai_shu; i++) {
			cct_gotoxy(qishi_x, qishi_y + 1 + i);
			cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
			Sleep(1);
			for (int j = 0; j < lie * sekuai_heng; j++) {
				cout << " ";
			}
			Sleep(1);
			cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
			Sleep(1);
		}

		cct_gotoxy(qishi_x, qishi_y + 1 + hang * sekuai_shu);
		cout << frame_zhonglei[8] << frame_zhonglei[9]<<" ";
		for (int j = 0; j < lie * sekuai_heng / 2; j++) {
			cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
		}
		Sleep(1);
		cout << frame_zhonglei[10] << frame_zhonglei[11]<<" ";
		cct_setcolor(0, 7);
	}

	else if (fenge == 1) {  //有分隔线
		cct_setcolor(15, 0);
		cct_gotoxy(qishi_x, qishi_y);
		cout << frame_zhonglei[0] << frame_zhonglei[1]<<" ";
		for (int j = 0; j < lie - 1; j++) {
			for (int k = 0; k < sekuai_heng / 2; k++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";Sleep(1);
			}
			Sleep(1);
			cout << frame_zhonglei[12] << frame_zhonglei[13]<<" ";
			Sleep(1);
		}
		for (int k = 0; k < sekuai_heng / 2; k++) {
			cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";Sleep(1);
		}
		Sleep(1);
		cout << frame_zhonglei[4] << frame_zhonglei[5]<<" ";

		for (int i = 0; i < hang - 1; i++) {
			for (int j = 0; j < sekuai_shu; j++) {
				cct_gotoxy(qishi_x, qishi_y + 1 + i * (sekuai_shu + 1) + j);
				cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
				Sleep(1);
				for (int m = 0; m < lie; m++) {
					for (int k = 0; k < sekuai_heng; k++) {
						cout << ' ';
					}
					Sleep(1);
					cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
					Sleep(1);
				}
			}
			cct_gotoxy(qishi_x, qishi_y + 1 + i * (sekuai_shu + 1) + sekuai_shu);
			cout << frame_zhonglei[14] << frame_zhonglei[15]<<" ";
			Sleep(1);
			for (int m = 0; m < lie - 1; m++) {
				for (int k = 0; k < sekuai_heng / 2; k++) {
					cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
				}
				Sleep(1);
				cout << frame_zhonglei[16] << frame_zhonglei[17]<<" ";
				Sleep(1);
			}
			for (int k = 0; k < sekuai_heng / 2; k++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			Sleep(1);
			cout << frame_zhonglei[18] << frame_zhonglei[19]<<" ";
			Sleep(1);
		}

		for (int j = 0; j < sekuai_shu; j++) {
			cct_gotoxy(qishi_x, qishi_y + 1 + (hang - 1) * (sekuai_shu + 1) + j);
			cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
			Sleep(1);
			for (int m = 0; m < lie; m++) {
				for (int k = 0; k < sekuai_heng; k++) {
					cout << ' ';
				}
				Sleep(1);
				cout << frame_zhonglei[6] << frame_zhonglei[7]<<" ";
				Sleep(1);
			}
		}

		cct_gotoxy(qishi_x, qishi_y + hang * (sekuai_shu + 1));
		cout << frame_zhonglei[8] << frame_zhonglei[9]<<" ";
		for (int j = 0; j < lie - 1; j++) {
			for (int k = 0; k < sekuai_heng / 2; k++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			Sleep(1);
			cout << frame_zhonglei[20] << frame_zhonglei[21]<<" ";
			Sleep(1);
		}
		for (int k = 0; k < sekuai_heng / 2; k++) {
			cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
		}
		Sleep(1);
		cout << frame_zhonglei[10] << frame_zhonglei[11]<<" " << endl;
		cct_setcolor(0, 7);
	}
}

void edit_tuxing(int shuzi, int x, int y, int shixin_or_kongxin, int sekuai_shu, int sekuai_heng, const char* neirong, int mode) //编辑图形函数
{
	if (shuzi == 0)
		return;

	char frame_kongxin[100] = "╔═╗║╚╝╦╠╬╣╩";
	char frame_shixin[100] = "┏━┓┃┗┛┳┣╋┫┻";
	char* frame_zhonglei;
	bool dan_or_duo = sekuai_shu > 1; //0表示色块为单个中文字符大小（1行2列），1表示大的

	if (shixin_or_kongxin == 1) {
		frame_zhonglei = frame_shixin;
	}
	else {
		frame_zhonglei = frame_kongxin;
	}

	if (!dan_or_duo) {  //0表示色块为单个中文字符大小（1行2列）
		/*cct_gotoxy(x, y);
		cct_setcolor(shuzi, 0);
		cout << neirong ;
		cct_setcolor();*/
		if (mode == 1) {  //1表示画正常图形
			cct_gotoxy(x, y);
			cct_setcolor(shuzi, 0);
			cout << neirong;
			cct_setcolor();
			Sleep(1);
		}
		else if (mode == 0) {  //0表示擦除图形
			cct_gotoxy(x, y);
			cct_setcolor(15, 0);
			for (int m = 0; m < sekuai_heng; m++) {
					cout << ' ';
			}
			Sleep(1);
		}
		else if (mode == 2) {  //2表示图形选中状态
			cct_gotoxy(x, y);
			cct_setcolor(shuzi, 15);
			cout << neirong;
			cct_setcolor();
			Sleep(1);
		}
		cct_setcolor(0, 7);
	}
	else {
		if (mode == 1) {  //1表示画正常图形
			cct_gotoxy(x,y);
			cct_setcolor(shuzi, 0);
			cout << frame_zhonglei[0] << frame_zhonglei[1]<<" ";
			for (int m = 0; m < (sekuai_heng - 4) / 2; m++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			cout << frame_zhonglei[4] << frame_zhonglei[5]<<" ";

			cct_gotoxy(x,y+1);
			cout << frame_zhonglei[6] << frame_zhonglei[7]<<" " << neirong << frame_zhonglei[6] << frame_zhonglei[7]<<" ";

			cct_gotoxy(x,y+2);
			cout << frame_zhonglei[8] << frame_zhonglei[9]<<" ";
			for (int m = 0; m < (sekuai_heng - 4) / 2; m++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			cout << frame_zhonglei[10] << frame_zhonglei[11]<<" ";
			//Sleep(1);
		}
		else if(mode==0){  //0表示擦除图形
			cct_setcolor(15, 0);
			for (int k = 0; k < sekuai_shu; k++) {
				cct_gotoxy(x, y+k);
				for (int m = 0; m < sekuai_heng; m++) {
					cout << ' ';
				}
			}
			//Sleep(1);
		}
		else if (mode == 2) {  //2表示图形选中状态
			cct_gotoxy(x, y);
			cct_setcolor(shuzi, 15);
			cout << frame_zhonglei[0] << frame_zhonglei[1]<<" ";
			for (int m = 0; m < (sekuai_heng - 4) / 2; m++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			cout << frame_zhonglei[4] << frame_zhonglei[5]<<" ";

			cct_gotoxy(x, y + 1);
			cout << frame_zhonglei[6] << frame_zhonglei[7]<<" " << neirong << frame_zhonglei[6] << frame_zhonglei[7]<<" ";

			cct_gotoxy(x, y + 2);
			cout << frame_zhonglei[8] << frame_zhonglei[9]<<" ";
			for (int m = 0; m < (sekuai_heng - 4) / 2; m++) {
				cout << frame_zhonglei[2] << frame_zhonglei[3]<<" ";
			}
			cout << frame_zhonglei[10] << frame_zhonglei[11]<<" ";
			//Sleep(1);
		}
	}
	cct_setcolor(0, 7);
}

void print_zhuangtailan(int x,int y,const char* str)
{
	bool flag = false;
	int j;
	cct_gotoxy(x, y);
	for (unsigned int i = 0; i < strlen(str); i++) {
		if (str[i] == '!') {
			j = i;
			flag = true;
			break;
		}
	}
	if (flag) {
		cct_setcolor(0,COLOR_HYELLOW);
		for (int i = 0; i <= j; i++) {
			cout << str[i];
		}
		cct_setcolor(0, 7);
		for (unsigned int i = j + 1; i < strlen(str); i++) {
			cout << str[i];
		}
	}
	else {
		cct_setcolor(0, 7);
		cout << str;
	}
}