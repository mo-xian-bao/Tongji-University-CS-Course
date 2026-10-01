/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <conio.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-01-b2-magic_ball.h"
#include <cmath>
using namespace std;

//void wait_for_return() //输入end返回菜单
//{
//	int x, y;
//	char a[5] = { 0 };
//
//	cout << "本小题结束，请输入End继续...";
//	cct_getxy(x, y);
//	while (1) {
//		cct_gotoxy(x, y);
//		cout << "    ";
//		cct_gotoxy(x, y);
//		fgets(a, 5, stdin);
//		if (_strnicmp(a, "End", 3) != 0) {
//			cct_gotoxy(0, y + 1);
//			cout << "输入错误，请重新输入";
//		}
//		else
//			break;
//	}
//}

//void lighten(int hang, int lie, int shuju[10][10], int panduan[54][4], int x, int y, int mode) //标记函数，mode参数对应6种模式
//{
//	if (mode == 1) { //标亮可消除项
//		cct_setcolor(14, 4);
//		for (int h = 0; panduan[h][2] > 2; h++) {
//			if (panduan[h][3] == 1) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_gotoxy(x + (panduan[h][1] + i) * 3, y + panduan[h][0]);
//					cout << shuju[panduan[h][0]][panduan[h][1] + i];
//				}
//			}
//			else if (panduan[h][3] == 2) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_gotoxy(x + (panduan[h][1]) * 3, y + panduan[h][0] + i);
//					cout << shuju[panduan[h][0] + i][panduan[h][1]];
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//	else if (mode == 2) { //标亮0项
//		cct_setcolor(14, 2);
//		for (int i = 0; i < hang; i++) {
//			for (int j = 0; j < lie; j++) {
//				cct_gotoxy(x + j * 3, y + i);
//				if (shuju[i][j] == 0) {
//					cout << shuju[i][j];
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//	else if (mode == 3) { //标亮并对0填充新的值
//		cct_setcolor(14, 1);
//		for (int i = 0; i < hang; i++) {
//			for (int j = 0; j < lie; j++) {
//				if (shuju[i][j] == 0) {
//					cct_gotoxy(x + j * 3, y + i);
//					shuju[i][j] = rand() % 9 + 1;
//					cout << shuju[i][j];
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//	else if (mode == 4) { //把可消除项标为实心
//		for (int h = 0; panduan[h][2] > 2; h++) {
//			if (panduan[h][3] == 1) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_setcolor(shuju[panduan[h][0]][panduan[h][1]] + 1, 0);
//					cct_gotoxy(2 + (panduan[h][1] + i) * 2, 2 + panduan[h][0]);
//					cout << "●";
//					Sleep(10);
//				}
//			}
//			else if (panduan[h][3] == 2) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_setcolor(shuju[panduan[h][0]][panduan[h][1]] + 1, 0);
//					cct_gotoxy(2 + panduan[h][1] * 2, 2 + (panduan[h][0] + i));
//					cout << "●";
//					Sleep(10);
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//	else if (mode == 5) { //把图形可消除项标为实心(有边框)
//		for (int h = 0; panduan[h][2] > 2; h++) {
//			if (panduan[h][3] == 1) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_setcolor(shuju[panduan[h][0]][panduan[h][1]] + 1, 0);
//					cct_gotoxy(2 + (panduan[h][1] + i) * 4, 2 + panduan[h][0] * 2);
//					cout << "●";
//					Sleep(10);
//				}
//			}
//			else if (panduan[h][3] == 2) {
//				for (int i = 0; i < panduan[h][2]; i++) {
//					cct_setcolor(shuju[panduan[h][0]][panduan[h][1]] + 1, 0);
//					cct_gotoxy(2 + panduan[h][1] * 4, 2 + (panduan[h][0] + i) * 2);
//					cout << "●";
//					Sleep(10);
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//	else if (mode == 6) { //数组和图形填充新值
//		for (int i = 0; i < hang; i++) {
//			for (int j = 0; j < lie; j++) {
//				if (shuju[i][j] == 0) {
//					shuju[i][j] = rand() % 9 + 1;
//					cct_setcolor(shuju[i][j] + 1, 0);
//					cct_gotoxy(2 + j * 4, 2 + i * 2);
//					cout << "〇";
//					Sleep(200);
//				}
//			}
//		}
//		cct_setcolor(0, 7);
//	}
//}

//void huiche() //回车等待，用于检查和调试
//{
//	char c;
//	while (1) {
//		c = _getch();
//		if (c == '\r') {
//			break;
//		}
//	}
//}

//void print_shuzu(int hang, int lie, int& x, int& y, int shuju[10][10]) //输出数组并返回第一个数的位置（已整合）
//{
//	cout << "  | ";
//	for (int i = 1; i <= lie; i++) {
//		cout << " " << i << " ";
//	}
//	cout << endl;
//	cout << "--+-";
//	for (int i = 1; i <= lie; i++) {
//		cout << "---";
//	}
//	cout << endl;
//	cct_getxy(x, y);
//	x += 5;
//	for (int i = 0; i < hang; i++) {
//		cout << (char)('A' + i) << " | ";
//		for (int j = 0; j < lie; j++) {
//			cout << " " << shuju[i][j] << " ";
//		}
//		cout << endl;
//	}
//	cout << endl;
//}

//void shuru(int mode,int& hang, int& lie) //输入行列数（已整合）
//{
//	char c;
//	int min, max;
//	while (6) {
//		cout << "请输入行数(5-9)：" << endl;
//		cin >> hang;
//		if (cin.fail() || (hang > 9 || hang < 5)) {
//			cin.clear();
//			while ((c = cin.get()) != '\n' && c != EOF);
//		}
//		else {
//			cin.clear();
//			while ((c = cin.get()) != '\n' && c != EOF);
//			break;
//		}
//	}
//	while (6) {
//		cout << "请输入列数(5-9)：" << endl;
//		cin >> lie;
//		if (cin.fail() || (lie > 9 || lie < 5)) {
//			cin.clear();
//			while ((c = cin.get()) != '\n' && c != EOF);
//		}
//		else {
//			cin.clear();
//			while ((c = cin.get()) != '\n' && c != EOF);
//			break;
//		}
//	}
//}