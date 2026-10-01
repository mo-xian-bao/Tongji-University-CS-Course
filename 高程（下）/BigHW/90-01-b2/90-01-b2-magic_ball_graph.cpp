/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <cstring>
#include <Windows.h>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-01-b2-magic_ball.h"
#include <conio.h>
#include <ctime>
#include <cmath>
using namespace std;

void mark(int shuju[10][10], int tishi[144][4], int hang, int lie, int t) //标记出可交换项
{
	for (int i = 0; i < hang; i++) { //标记前先重置图形
		for (int j = 0; j < lie; j++) {
			cct_setcolor(shuju[i][j] + 1, 0);
			cct_gotoxy(2 + j * 4, 2 + i * 2);
			cout << "〇";
		}
	}
	for (int t0 = 0; t0 < t; t0++) {
		cct_setcolor(shuju[tishi[t0][0]][tishi[t0][1]] + 1, 0);
		cct_gotoxy(2 + tishi[t0][1] * 4, 2 + tishi[t0][0] * 2);
		cout << "◎";
		cct_setcolor(shuju[tishi[t0][2]][tishi[t0][3]] + 1, 0);
		cct_gotoxy(2 + tishi[t0][3] * 4, 2 + tishi[t0][2] * 2);
		cout << "◎";
	}
	cct_setcolor(0, 7);
}

void paint_frame(int shuju[10][10], int hang, int lie, int mode) //画出框架，mode参数决定有无分隔线
{
	cct_cls();
	if (mode == 1) { //无分隔线
		//cct_setfontsize(0,100);
		cct_setcolor(15, 0);
		cct_gotoxy(0, 1);
		cout << "╔";
		for (int j = 0; j < lie; j++) {
			cout << "═";
			Sleep(10);
		}
		cout << "╗";
		for (int i = 0; i < hang; i++) {
			cct_gotoxy(0, 2 + i);
			cout << "║";
			Sleep(10);
			cct_gotoxy(2 + lie * 2, 2 + i);
			cout << "║";
		}
		cct_gotoxy(0, 2 + hang);
		cout << "╚";
		for (int j = 0; j < lie; j++) {
			cout << "═";
			Sleep(10);
		}
		cout << "╝";
		cct_setcolor(0, 7);
	}
	else if (mode == 2) { //有分隔线
		cct_setcolor(15, 0);
		cct_gotoxy(0, 1);
		cout << "╔";
		for (int j = 0; j < lie - 1; j++) {
			cout << "═╦";
			Sleep(10);
		}
		cout << "═╗" << endl;
		for (int i = 0; i < hang - 1; i++) {
			cout << "║";
			for (int j = 0; j < lie; j++) {
				cout << "  ║";
				Sleep(10);
			}
			cout << endl;
			cout << "╠";
			for (int j = 0; j < lie - 1; j++) {
				cout << "═╬";
				Sleep(10);
			}
			cout << "═╣" << endl;
		}
		cout << "║";
		for (int j = 0; j < lie; j++) {
			cout << "  ║";
			Sleep(10);
		}
		cout << endl;
		cout << "╚";
		for (int j = 0; j < lie - 1; j++) {
			cout << "═╩";
			Sleep(10);
		}
		cout << "═╝" << endl;
		cct_setcolor(0, 7);
	}
}

void paint_ball(int shuju[10][10], int hang, int lie, int mode) //画球，mode参数决定有无分隔线
{
	if (mode == 1) {
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				cct_setcolor(shuju[i][j] + 1, 0);
				cct_gotoxy(2 + j * 2, 2 + i);
				cout << "〇";
				Sleep(10);
			}
		}
		cct_setcolor(0, 7);
	}
	else if (mode == 2) {
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				cct_setcolor(shuju[i][j] + 1, 0);
				cct_gotoxy(2 + j * 4, 2 + i * 2);
				cout << "〇";
				Sleep(10);
			}
		}
		cct_setcolor(0, 7);
	}
}

void xialuo_graph(int shuju[10][10], int panduan[54][4], int hang, int lie, int& score) //数组和图形同步下落，用于菜单8/9，同时累计分数
{
	for (int h = 0; panduan[h][2] > 2; h++) { //将数组可消除项置零+图形爆炸¤
		if (panduan[h][3] == 1) {
			for (int j = panduan[h][1]; j < panduan[h][1] + panduan[h][2]; j++) {
				if (shuju[panduan[h][0]][j] == 0) {
					continue;
				}
				cct_setcolor(shuju[panduan[h][0]][j] + 1, 0);
				for (int m = 0; m < 4; m++) {
					cct_gotoxy(2 + j * 4, 2 + panduan[h][0] * 2);
					cout << "〇";
					Sleep(25);
					cct_gotoxy(2 + j * 4, 2 + panduan[h][0] * 2);
					cout << "¤";
					Sleep(25);
				}
				Sleep(25);
				cct_setcolor(15, 15);
				cct_gotoxy(2 + j * 4, 2 + panduan[h][0] * 2);
				cout << "  ";
				cct_setcolor(0, 7);
				shuju[panduan[h][0]][j] = 0;
			}
		}
		else if (panduan[h][3] == 2) {
			for (int i = panduan[h][0]; i < panduan[h][0] + panduan[h][2]; i++) {
				if (shuju[i][panduan[h][1]] == 0) {
					continue;
				}
				cct_setcolor(shuju[i][panduan[h][1]] + 1, 0);
				for (int m = 0; m < 4; m++) {
					cct_gotoxy(2 + panduan[h][1] * 4, 2 + i * 2);
					cout << "〇";
					Sleep(25);
					cct_gotoxy(2 + panduan[h][1] * 4, 2 + i * 2);
					cout << "¤";
					Sleep(25);
				}
				Sleep(25);
				cct_setcolor(15, 15);
				cct_gotoxy(2 + panduan[h][1] * 4, 2 + i * 2);
				cout << "  ";
				cct_setcolor(0, 7);
				shuju[i][panduan[h][1]] = 0;
			}
		}
	}
	for (int i = 0; i < hang; i++) { //累计单次消除分数
		for (int j = 0; j < lie; j++) {
			if (shuju[i][j] == 0) {
				score++;
			}
		}
	}

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
					cct_setcolor(15, 15);
					cct_gotoxy(2 + j * 4, 2 + k * 2);
					cout << "  ";
					cct_setcolor(shuju[k][j] + 1, 0);
					cct_gotoxy(2 + j * 4, 2 + k * 2 + 1);
					cout << "〇";
					Sleep(40);
					cct_setcolor(15, 0);
					cct_gotoxy(2 + j * 4, 2 + k * 2 + 1);
					cout << "═";
					cct_setcolor(shuju[k][j] + 1, 0);
					cct_gotoxy(2 + j * 4, 2 + k * 2 + 2);
					cout << "〇";
					Sleep(40);
					shuju[k][j] = 0;
				}
			}
		}
	}
	cct_setcolor(0, 7);
}

void mouse(int shuju[10][10], int tishi[144][4], int hang, int lie, int t) //菜单项8处理鼠标事件
{
	int MX, MY, MAction, keycode1, keycode2; //用于处理鼠标
	int event;
	char zhuangtailan[100] = {0};

	while (1) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);
		bool flag = false;
		if (event == CCT_MOUSE_EVENT) {
			if (((MX <= 3 + 4 * (lie - 1)) && (MX % 4 == 2 || MX % 4 == 3)) && ((MY > 0) && (MY <= 2 + (hang - 1) * 2) && (MY % 2 == 0)))
				flag = true;

			cct_gotoxy(0, 2 + hang * 2);
			// 打印鼠标的实时位置
			if (flag)
			{
				/*cout << "[当前光标]" << char(MY / 2 + 64) << " 行 " << (MX) / 4 + 1 << " 列";*/
				sprintf_s(zhuangtailan, "[当前光标] %c 行 %d 列               ", char(MY / 2 + 64), (MX) / 4 + 1);
				print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
			}
			else
				/*cout << "[当前光标] " << "位置非法";*/
				print_zhuangtailan(0, 2 + hang * 2, "[当前光标] 位置非法            ");


			// 检查鼠标按键事件
			bool flag2 = false;
			if (MAction == 0x0002) {
				for (int t0 = 0; t0 < t; t0++) {
					if ((MX == tishi[t0][1] * 4 + 2 || MX == tishi[t0][1] * 4 + 3) && (MY == tishi[t0][0] * 2 + 2)) {
						flag2 = true;
						break;
					}
					else if ((MX == tishi[t0][3] * 4 + 2 || MX == tishi[t0][3] * 4 + 3) && (MY == tishi[t0][2] * 2 + 2)) {
						flag2 = true;
						break;
					}
				}

				cct_gotoxy(0, 2 + hang * 2);
				if (flag2) {
					/*cout << "当前选择  " << char(MY / 2 + 64) << " 行 " << (MX) / 4 + 1 << " 列";*/
					sprintf_s(zhuangtailan, "当前选择  %c 行 %d 列                ", char(MY / 2 + 64), (MX) / 4 + 1);
					print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
					/*cct_setcolor(shuju[MY / 2 - 1][MX / 4] , 15);
					cct_gotoxy(2 + (MX / 4) * 4, 2 + (MY / 2 - 1) * 2);
					cout << "◎";*/
					edit_tuxing(shuju[MY / 2 - 1][MX / 4], 2 + (MX / 4) * 4, 2 + (MY / 2 - 1) * 2, 0, 1, 2, "◎", 2);
					cct_setcolor(0, 7);
					Sleep(1000);
					break;
				}
				else {
					/*cout << "不能选择  " << char(MY / 2 + 64) << " 行 " << (MX) / 4 + 1 << " 列";*/
					sprintf_s(zhuangtailan, "不能选择  %c 行 %d 列                ", char(MY / 2 + 64), (MX) / 4 + 1);
					print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
				}
			}
			else if (MAction == 0x0008 && flag) {
				break;
			}
		}
		cout.flush();
	}
}

void mouse_full(int shuju[10][10], int tishi[144][4], int hang, int lie, int t, bool& tuichu) //菜单项9处理鼠标事件
{
	int MX, MY, MAction, keycode1, keycode2; //用于处理鼠标
	int event;
	int hang_old = -1, lie_old = -1; //记录选中可选项后的位置
	int m; //处理交换
	char zhuangtailan[100] = { 0 };

	while (1) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);
		bool flag = false;
		if (event == CCT_MOUSE_EVENT) {
			if (((MX <= 3 + 4 * (lie - 1)) && (MX % 4 == 2 || MX % 4 == 3)) && ((MY > 0) && (MY <= 2 + (hang - 1) * 2) && (MY % 2 == 0)))
				flag = true;

			cct_gotoxy(0, 2 + hang * 2);
			// 打印鼠标的实时位置
			if (flag) {
				/*cout << "[当前光标]" << char(MY / 2 + 64) << " 行 " << (MX) / 4 + 1 << " 列";*/
				sprintf_s(zhuangtailan, "[当前光标] %c 行 %d 列           ", char(MY / 2 + 64), (MX) / 4 + 1);
				print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
			}
				
			else {
                //cout << "[当前光标] " << "位置非法";
                print_zhuangtailan(0, 2 + hang * 2, "[当前光标] 位置非法                   ");
			}
				
			// 检查鼠标按键事件
			bool flag2 = false;
			if (MAction == 0x0002) { //点击左键
				for (int t0 = 0; t0 < t; t0++) {
					if ((MX == tishi[t0][1] * 4 + 2 || MX == tishi[t0][1] * 4 + 3) && (MY == tishi[t0][0] * 2 + 2)) {
						flag2 = true;
						break;
					}
					else if ((MX == tishi[t0][3] * 4 + 2 || MX == tishi[t0][3] * 4 + 3) && (MY == tishi[t0][2] * 2 + 2)) {
						flag2 = true;
						break;
					}
				}

				cct_gotoxy(0, 2 + hang * 2);
				if (flag2) {
					sprintf_s(zhuangtailan, "当前选择  %c 行 %d 列                  ", char(MY / 2 + 64), (MX) / 4 + 1);
					print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
					if (hang_old == -1) { //未选择可交换项时
						hang_old = MY / 2 - 1; //从0开始
						lie_old = MX / 4; //从0开始
						/*cct_setcolor(shuju[hang_old][lie_old], 15);
						cct_gotoxy(2 + (lie_old) * 4, 2 + hang_old * 2);
						cout << "◎";
						cct_setcolor(0, 7);*/
						edit_tuxing(shuju[hang_old][lie_old], 2 + (lie_old) * 4, 2 + hang_old * 2, 0, 1, 2, "◎", 2);
					}
					else { //已选择可交换项
						if ((lie_old == MX / 4) && (hang_old == MY / 2 - 1)) { //再选同一个
							/*cct_setcolor(shuju[hang_old][lie_old], 0);
							cct_gotoxy(2 + (lie_old) * 4, 2 + hang_old * 2);
							cout << "◎";*/
							edit_tuxing(shuju[hang_old][lie_old], 2 + (lie_old) * 4, 2 + hang_old * 2, 0, 1, 2, "◎", 1);
							hang_old = -1;
							lie_old = -1;
							cct_setcolor(0, 7);
						}
						else {
							for (int t0 = 0; t0 < t; t0++) {
								//选到匹配的可交换项
								if (((tishi[t0][0] == hang_old) && (tishi[t0][1] == lie_old) && (tishi[t0][2] == MY / 2 - 1) && (tishi[t0][3] == MX / 4))
								   || ((tishi[t0][2] == hang_old) && (tishi[t0][3] == lie_old) && (tishi[t0][0] == MY / 2 - 1) && (tishi[t0][1] == MX / 4))) {
									/*cct_setcolor(shuju[hang_old][lie_old] , 0);
									cct_gotoxy(2 + (MX / 4) * 4, 2 + (MY / 2 - 1) * 2);
									cout << "◎";*/
									edit_tuxing(shuju[hang_old][lie_old], 2 + (MX / 4) * 4, 2 + (MY / 2 - 1) * 2, 0, 1, 2, "◎", 1);
									/*cct_setcolor(shuju[MY / 2 - 1][MX / 4] , 0);
									cct_gotoxy(2 + (lie_old) * 4, 2 + (hang_old) * 2);
									cout << "◎";*/
									edit_tuxing(shuju[MY / 2 - 1][MX / 4], 2 + (lie_old) * 4, 2 + (hang_old) * 2, 0, 1, 2, "◎", 1);
									m = shuju[hang_old][lie_old];
									shuju[hang_old][lie_old] = shuju[MY / 2 - 1][MX / 4];
									shuju[MY / 2 - 1][MX / 4] = m;
									cct_setcolor(0, 7);
									return;
								}
							}
							for (int t0 = 0; t0 < t; t0++) {
								//选到另一组的可交换项
								if (((tishi[t0][2] == MY / 2 - 1) && (tishi[t0][3] == MX / 4)) || ((tishi[t0][0] == MY / 2 - 1) && (tishi[t0][1] == MX / 4))) {
									if (((hang_old == (MY / 2 - 1)) && (abs(lie_old - (MX / 4)) == 1)) || ((lie_old == (MX / 4)) && (abs(hang_old - (MY / 2 - 1)) == 1))) {
										/*cct_setcolor(shuju[hang_old][lie_old], 0);
										cct_gotoxy(2 + (lie_old) * 4, 2 + hang_old * 2);
										cout << "◎";
										cct_setcolor(0, 7);*/
									edit_tuxing(shuju[hang_old][lie_old], 2 + (lie_old) * 4, 2 + hang_old * 2, 0, 1, 2, "◎", 1);
										/*cct_gotoxy(0, 2 + hang * 2);
										cout << "不能交换 " << char(MY / 2 + 64) << "行" << (MX) / 4 + 1 << "列" << " <=> " << char(hang_old + 65) << "行" << lie_old + 1 << "列";*/
										sprintf_s(zhuangtailan, "不能交换 %c行%d列 <=> %c行%d列           ", char(hang_old + 65), lie_old + 1, char(MY / 2 + 64), (MX) / 4 + 1);
										print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
										Sleep(500);
										cct_gotoxy(0, 2 + hang * 2);
										cout << "                            ";
										hang_old = -1; //从0开始
										lie_old = -1; //从0开始
										break;
									}
									else {
										/*cct_setcolor(shuju[hang_old][lie_old], 0);
										cct_gotoxy(2 + (lie_old) * 4, 2 + hang_old * 2);
										cout << "◎";*/
										edit_tuxing(shuju[hang_old][lie_old], 2 + (lie_old) * 4, 2 + hang_old * 2, 0, 1, 2, "◎", 1);
										hang_old = MY / 2 - 1; //从0开始
										lie_old = MX / 4; //从0开始
										/*cct_setcolor(shuju[hang_old][lie_old], 15);
										cct_gotoxy(2 + (lie_old) * 4, 2 + hang_old * 2);
										cout << "◎";
										cct_setcolor(0, 7);*/
										edit_tuxing(shuju[hang_old][lie_old], 2 + (lie_old) * 4, 2 + hang_old * 2, 0, 1, 2, "◎", 2);
										break;
									}
								}
							}
						}
					}
				}
				else {
					/*cout << "不能选择  " << char(MY / 2 + 64) << " 行 " << (MX) / 4 + 1 << " 列";*/
					sprintf_s(zhuangtailan, "不能选择  %c 行 %d 列                  ", char(MY / 2 + 64), (MX) / 4 + 1);
					print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
				}
			}
			else if (MAction == 0x0008 && flag) {
				tuichu = true;
				break;
			}
		}
		cout.flush();
	}
}

void choice_4()
{
	int x, y; //数组起始位置
	int hang, lie;
	int shuju[10][10] = { 0 };
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 6 + hang);
	cct_setfontsize("新宋体", 32);

	paint_frame(hang, lie, shuju, 0, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {  //无分隔表示
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 2 * j, 2 + i, 2, 1, 2, "〇", 1);
			Sleep(10);
		}
	}

	/*cct_gotoxy(0, 0);
	cout << "屏幕：" << 6 + hang << "行" << 40 << "列";*/
	sprintf_s(zhuangtailan, "屏幕：%d行%d列", 6 + hang, 40);
	print_zhuangtailan(0, 0, zhuangtailan);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 3 + hang);
	wait_for_return();
}

void choice_5()
{
	int x, y; //数组起始位置
	int hang, lie;
	int shuju[10][10] = { 0 };
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 14 + hang);
	cct_setfontsize("新宋体", 32);

	paint_frame(hang, lie, shuju, 1, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + 2 * i, 0, 1, 2, "〇", 1);
			Sleep(10);
		}
	}

	/*cct_gotoxy(0, 0);
	cout << "屏幕：" << 14 + hang << "行" << 40 << "列";*/
	sprintf_s(zhuangtailan, "屏幕：%d行%d列", 14 + hang, 40);
	print_zhuangtailan(0, 0, zhuangtailan);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 2 + hang * 2);
	wait_for_return();
}

void choice_6()
{
	int x, y; //数组起始位置
	int hang, lie;
	bool flag;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 6 + hang);
	cct_setfontsize("新宋体", 32);

	paint_frame(hang, lie, shuju, 0, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {  //无分隔表示
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 2 * j, 2 + i, 2, 1, 2, "〇", 1);
			Sleep(10);
		}
	}
	
	flag = can_disappear(shuju, jieguo);

	//把可消除项标为实心(无边框)
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (jieguo[i][j] != 0) {
				edit_tuxing(shuju[i][j], 2 + 2 * j, 2 +  i,0,1,2, "●",1);
				Sleep(10);
			}
		}
	}

	/*cct_gotoxy(0, 0);
	cout << "屏幕：" << 6 + hang << "行" << 40 << "列" << (flag ? "（已标出初始可消除项）" : "（未找到初始可消除项）");*/
	sprintf_s(zhuangtailan, "屏幕：%d行%d列%s", 6 + hang, 40, (flag ? "（已标出初始可消除项）" : "（未找到初始可消除项）"));
	print_zhuangtailan(0, 0, zhuangtailan);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 3 + hang);
	wait_for_return();
}

void choice_7()
{
	int x, y; //数组起始位置
	int hang, lie, score = 0;
	//bool flag;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 14 + hang);
	cct_setfontsize("新宋体", 32);

	paint_frame(hang, lie, shuju, 1, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + 2 * i, 0, 1, 2, "〇", 1);
			Sleep(10);
		}
	}

	while (can_disappear(shuju, jieguo)) {
		//把图形可消除项标为实心(有边框)
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] != 0) {
					edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i*2, 0, 1, 2, "●", 1);
					Sleep(10);
				}
			}
		}

		/*cct_gotoxy(0, 2 + hang * 2);
		cout << "按回车进行消除及下落除0操作...";*/
		sprintf_s(zhuangtailan, "按回车进行消除及下落除0操作...");
		print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
		huiche();
		/*cct_gotoxy(0, 2 + hang * 2);
		cout << "                                ";*/
		print_zhuangtailan(0, 2 + hang * 2, "                                ");
		
		//数组和图形同步下落
		baozha(shuju, jieguo, hang, lie, score);
		MOVE(DOWN, shuju, hang, lie, 2, 1, 2, "〇", 0, 1, 0); 

		/*cct_gotoxy(0, 2 + hang * 2);
		cout << "按回车键进行新值填充...";*/
		sprintf_s(zhuangtailan, "按回车键进行新值填充...");
		print_zhuangtailan(0, 2 + hang * 2, zhuangtailan);
		huiche();
		tianchong(hang, lie, shuju);//数组和图形同时填充新的值
	}

	/*cct_gotoxy(0, 0);
	cout << "屏幕：" << 14 + hang << "行" << 40 << "列" << "（未找到初始可消除项）";*/
	sprintf_s(zhuangtailan, "屏幕：%d行%d列（未找到初始可消除项）", 14 + hang, 40);
	print_zhuangtailan(0, 0, zhuangtailan);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 2 + hang * 2);
	wait_for_return();
}

void choice_8()
{
	int x, y; //数组起始位置
	int hang, lie;
	int score = 0;
	//bool flag;
	int jieguo[10][10] = { 0 };
	int shuju[10][10] = { 0 }, tishi[144][4] = { 0 }, t = 0;
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 14 + hang);
	cct_setfontsize("新宋体", 32);
	
	paint_frame(hang, lie, shuju, 1, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + 2 * i, 0, 1, 2, "〇", 1);
			Sleep(10);
		}
	}

	while (can_disappear(shuju, jieguo)) {
		//把图形可消除项标为实心(有边框)
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] != 0) {
					edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "●", 1);
					Sleep(10);
				}
			}
		}
		cct_gotoxy(0, 2 + hang * 2);
		Sleep(500);
		cct_gotoxy(0, 2 + hang * 2);
		cout << "                                ";

		//数组和图形同步下落
		baozha(shuju, jieguo, hang, lie, score);
		MOVE(DOWN, shuju, hang, lie, 2, 1, 2, "〇", 0, 1, 0);

		cct_gotoxy(0, 2 + hang * 2);
		Sleep(500);
		tianchong(hang, lie, shuju);//数组和图形同时填充新的值
		Sleep(200);
	}

	//找出可交换项
	hint(hang, lie, shuju, tishi, t);
	tishi_to_jieguo(tishi, t, jieguo);
	//标出可交换项
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (jieguo[i][j] != 0) {
				edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "◎", 1);
				Sleep(10);
			}
		}
	}

	cct_setcursor(3); //隐藏光标
	/*cct_gotoxy(0, 0);
	cout << "屏幕：" << 14 + hang << "行" << 40 << "列" << "（右键退出）";*/
	sprintf_s(zhuangtailan, "屏幕：%d行%d列（右键退出）", 14 + hang, 40);
	print_zhuangtailan(0, 0, zhuangtailan);
	cct_enable_mouse(); //允许鼠标操作
	mouse(shuju, tishi, hang, lie, t);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 2 + hang * 2);
	wait_for_return();
}

void choice_9()
{
	int x, y; //数组起始位置
	int hang, lie, score = 0;
	//bool flag;
	int jieguo[10][10] = { 0 };
	int shuju[10][10] = { 0 }, tishi[144][4] = { 0 }, t = 0;
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}

	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1,hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	cct_setcursor(CURSOR_INVISIBLE);
	cct_setconsoleborder(40, 14 + hang);
	cct_setfontsize("新宋体", 32);

	paint_frame(hang, lie, shuju, 1, 0, 2, 1, 2);
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + 2 * i, 0, 1, 2, "〇", 1);
			Sleep(10);
		}
	}

	while (can_disappear(shuju, jieguo)) {
		//把图形可消除项标为实心(有边框)
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] != 0) {
					edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "●", 1);
					Sleep(10);
				}
			}
		}
		cct_gotoxy(0, 2 + hang * 2);
		Sleep(500);
		cct_gotoxy(0, 2 + hang * 2);
		cout << "                                ";

		//数组和图形同步下落
		baozha(shuju, jieguo, hang, lie, score);
		MOVE(DOWN, shuju, hang, lie, 2, 1, 2, "〇", 0, 1, 0);

		cct_gotoxy(0, 2 + hang * 2);
		Sleep(500);
		tianchong(hang, lie, shuju);//数组和图形同时填充新的值
		Sleep(200);
	}

	score = 0;
	bool tuichu = false; //判断右键退出事件
	while (1) {
		//找出可交换项
		hint(hang, lie, shuju, tishi, t);
		tishi_to_jieguo(tishi, t, jieguo);
		//标出可交换项
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] != 0) {
					edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "◎", 1);
				}
				else {
					edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "〇", 1);
				}
			}
		}

		if (t == 0)
			break;

		cct_setcursor(3); //隐藏光标
		/*cct_gotoxy(0, 0);
		cout << "屏幕：" << 14 + hang << "行" << 40 << "列" << "（当前分数：" << score << " 右键退出）";*/
		sprintf_s(zhuangtailan, "屏幕：%d行%d列（当前分数：%d 右键退出）", 14 + hang, 40, score);
		print_zhuangtailan(0, 0, zhuangtailan);
		cct_enable_mouse(); //允许鼠标操作
		mouse_full(shuju, tishi, hang, lie, t,tuichu);
		if (tuichu) {
			break;
		}
		while (can_disappear(shuju, jieguo)) {
			//把图形可消除项标为实心(有边框)
			for (int i = 0; i < hang; i++) {
				for (int j = 0; j < lie; j++) {
					if (jieguo[i][j] != 0) {
						edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + i * 2, 0, 1, 2, "●", 1);
						Sleep(10);
					}
				}
			}
			cct_gotoxy(0, 2 + hang * 2);
			Sleep(500);
			cct_gotoxy(0, 2 + hang * 2);
			cout << "                                ";

			//数组和图形同步下落
			baozha(shuju, jieguo, hang, lie, score);
			MOVE(DOWN, shuju, hang, lie, 2, 1, 2, "〇", 0, 1, 0);

			cct_gotoxy(0, 2 + hang * 2);
			Sleep(500);
			tianchong(hang, lie, shuju);//数组和图形同时填充新的值
			Sleep(200);
		}
	}

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, 2 + hang * 2);
	wait_for_return();
}

void baozha(int shuju[10][10], int jieguo[10][10], int hang, int lie, int& score)
{
	//将数组可消除项置零+图形爆炸¤
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (jieguo[i][j] != 0) {
				cct_setcolor(shuju[i][j], 0);
				for (int m = 0; m < 4; m++) {
					cct_gotoxy(2 + j * 4, 2 + i * 2);
					cout << "〇";
					Sleep(25);
					cct_gotoxy(2 + j * 4, 2 + i * 2);
					cout << "¤";
					Sleep(25);
				}
				Sleep(25);
				cct_setcolor(15, 15);
				cct_gotoxy(2 + j * 4, 2 + i * 2);
				cout << "  ";
				cct_setcolor(0, 7);
				shuju[i][j] = 0;
			}
		}
	}

	for (int i = 0; i < hang; i++) { //累计单次消除分数
		for (int j = 0; j < lie; j++) {
			if (shuju[i][j] == 0) {
				score++;
			}
		}
	}
}

void tianchong(int hang,int lie,int shuju[10][10])
{
	//数组和图形填充新值
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (shuju[i][j] == 0) {
				shuju[i][j] = rand() % 9 + 1;
				edit_tuxing(shuju[i][j], 2 + 4 * j, 2 + 2 * i, 0, 1, 2, "〇", 1);
				Sleep(200);
			}
		}
	}
	cct_setcolor(0, 7);
}