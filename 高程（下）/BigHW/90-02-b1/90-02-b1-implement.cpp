/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <conio.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-02-b1.h"
#include <cmath>
using namespace std;

void choice_A()
{
	int x, y; //储存数组起始位置
	int find_hang, find_lie; //从0开始储存
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score = 0;
	char c;
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	cout << endl;
	cout << "当前数组：" << endl;
	print_shuzu(1, hang, lie, x, y, shuju);

	cout << "请以字母 + 数字形式[例：c2]输入矩阵坐标：";
	cct_getxy(x, y);
	while (6) {
		cin >> shuru_chazhao;
		if (shuru_chazhao[0] >= 'A' && shuru_chazhao[0] <= ('A' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
			cout << "输入为" << (char)shuru_chazhao[0] << "行" << shuru_chazhao[1] << "列             " << endl;
			find_hang = shuru_chazhao[0] - 'A';
			find_lie = shuru_chazhao[1] - '0';
		}
		else if (shuru_chazhao[0] >= 'a' && shuru_chazhao[0] <= ('a' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
			cout << "输入为" << (char)(shuru_chazhao[0] - 32) << "行" << shuru_chazhao[1] << "列              " << endl;
			find_hang = shuru_chazhao[0] - 'a';
			find_lie = shuru_chazhao[1] - '0';
		}
		else {
			cout << "输入错误，请重新输入！";
			cct_gotoxy(x, y);
			cout << "                ";
			cct_gotoxy(x, y);
			continue;
		}

		bool flag = chazhao_jieguo(find_hang, find_lie, hang, lie, shuju, jieguo);

		if (!flag) {
			cout << "输入的矩阵坐标位置处无连续相同值，请重新输入！" << endl;
			cct_getxy(x, y);
		}
		else {
			cout << endl;
			cout << "查找结果数组为：" << endl;
			print_shuzu(2, hang, lie, x, y, jieguo);
			break;
		}
	}

	cout << "当前数组(高亮标识)：" << endl;
	print_shuzu(1, hang, lie, x, y, shuju);
	highlight(1, hang, lie, shuju, jieguo, x, y);

	cin.clear();
	while ((c = cin.get()) != '\n' && c != EOF);
	cct_gotoxy(0, y + hang + 3);
	wait_for_return();
}

void choice_B()
{
	int x, y; //储存数组起始位置
	int find_hang, find_lie; //从0开始储存
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score = 0;
	char option;
	char c;
	int once_score;
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	cout << endl;
	cout << "当前数组：" << endl;
	print_shuzu(1, hang, lie, x, y, shuju);

	cout << "请以字母 + 数字形式[例：c2]输入矩阵坐标：";
	cct_getxy(x, y);
	while (6) {
		cin >> shuru_chazhao;
		if (shuru_chazhao[0] >= 'A' && shuru_chazhao[0] <= ('A' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
			cout << "输入为" << (char)shuru_chazhao[0] << "行" << shuru_chazhao[1] << "列             " << endl;
			find_hang = shuru_chazhao[0] - 'A';
			find_lie = shuru_chazhao[1] - '0';
		}
		else if (shuru_chazhao[0] >= 'a' && shuru_chazhao[0] <= ('a' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
			cout << "输入为" << (char)(shuru_chazhao[0] - 32) << "行" << shuru_chazhao[1] << "列              " << endl;
			find_hang = shuru_chazhao[0] - 'a';
			find_lie = shuru_chazhao[1] - '0';
		}
		else {
			cout << "输入错误，请重新输入！";
			cct_gotoxy(x, y);
			cout << "                ";
			cct_gotoxy(x, y);
			continue;
		}

		bool flag = chazhao_jieguo(find_hang, find_lie, hang, lie, shuju, jieguo);

		if (!flag) {
			cout << "输入的矩阵坐标位置处无连续相同值，请重新输入！" << endl;
			cct_getxy(x, y);
		}
		else {
			cout << endl;
			cout << "查找结果数组为：" << endl;
			print_shuzu(2, hang, lie, x, y, jieguo);
			break;
		}
	}

	while (6) {

		cct_gotoxy(0, y + hang + 2);
		cout << "请确认是否把" << (char)(find_hang + 'A') << find_lie << "及周围相同的项消除(Y/N/Q):";

		cin.clear();
		while ((c = cin.get()) != '\n' && c != EOF);
		option = _getch();
		if (option == 'Y' || option == 'y') {
			cct_gotoxy(0, y + hang + 4);
			cout << "相同值归并后的数组(高亮标识)：" << endl;
			once_score = shuzu_zhiling(hang, lie, shuju, jieguo);
			once_score = once_score * once_score * 5;
			total_score += once_score;
			print_shuzu(1, hang, lie, x, y, shuju);
			highlight(2, hang, lie, shuju, jieguo, x, y);

			cct_gotoxy(0, y + hang + 2);
			cout << "本次得分：" << once_score << " 总得分：" << total_score;

			cct_gotoxy(0, y + hang + 4);
			cout << "按回车键进行数组下落操作...";
			huiche();

			cct_gotoxy(0, y + hang + 6);
			cout << "下落后的数组：" << endl;
			MOVE(2, shuju, hang, lie);
			print_shuzu(1, hang, lie, x, y, shuju);
			highlight(2, hang, lie, shuju, jieguo, x, y);
			break;
		}
		else if (option == 'N' || option == 'n' || option == 'Q' || option == 'q') {
			break;
		}
		else {
			continue;
		}
	}

	cct_gotoxy(0, y + hang + 3);
	wait_for_return();
}

void choice_C()
{
	int x, y; //储存数组起始位置
	int find_hang, find_lie; //从0开始储存
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score = 0;
	char option;
	char c;
	int once_score;
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	while (detect_game_finished(hang, lie, shuju)) {
		cout << endl;
		cout << "当前数组：" << endl;
		print_shuzu(1, hang, lie, x, y, shuju);

		cout << "请以字母 + 数字形式[例：c2]输入矩阵坐标：";
		cct_getxy(x, y);
		while (6) {
			cin >> shuru_chazhao;
			if (shuru_chazhao[0] >= 'A' && shuru_chazhao[0] <= ('A' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
				cout << "输入为" << (char)shuru_chazhao[0] << "行" << shuru_chazhao[1] << "列             " << endl;
				find_hang = shuru_chazhao[0] - 'A';
				find_lie = shuru_chazhao[1] - '0';
			}
			else if (shuru_chazhao[0] >= 'a' && shuru_chazhao[0] <= ('a' + hang - 1) && shuru_chazhao[1] >= '0' && shuru_chazhao[1] <= '0' + lie - 1) {
				cout << "输入为" << (char)(shuru_chazhao[0] - 32) << "行" << shuru_chazhao[1] << "列              " << endl;
				find_hang = shuru_chazhao[0] - 'a';
				find_lie = shuru_chazhao[1] - '0';
			}
			else {
				cout << "输入错误，请重新输入！";
				cct_gotoxy(x, y);
				cout << "                ";
				cct_gotoxy(x, y);
				continue;
			}

			bool flag = chazhao_jieguo(find_hang, find_lie, hang, lie, shuju, jieguo);

			if (!flag) {
				cout << "输入的矩阵坐标位置处无连续相同值，请重新输入！" << endl;
				cct_getxy(x, y);
			}
			else {
				cout << endl;
				cout << "查找结果数组为：" << endl;
				print_shuzu(2, hang, lie, x, y, jieguo);
				break;
			}
		}

		cct_gotoxy(0, y + hang + 2);
		cout << "请确认是否把" << (char)(find_hang + 'A') << find_lie << "及周围相同的项消除(Y/N/Q):";

		cin.clear();
		while ((c = cin.get()) != '\n' && c != EOF);
		while (6) {
			option = _getch();
			if (option == 'Y' || option == 'y' || option == 'N' || option == 'n' || option == 'Q' || option == 'q') {
				break;
			}
		}
		if (option == 'Y' || option == 'y') {
			cct_gotoxy(0, y + hang + 4);
			cout << "相同值归并后的数组(高亮标识)：" << endl;
			once_score = shuzu_zhiling(hang, lie, shuju, jieguo);
			once_score = once_score * once_score * 5;
			total_score += once_score;
			print_shuzu(1, hang, lie, x, y, shuju);
			highlight(2, hang, lie, shuju, jieguo, x, y);

			cct_gotoxy(0, y + hang + 2);
			cout << "本次得分：" << once_score << " 总得分：" << total_score;

			cct_gotoxy(0, y + hang + 4);
			cout << "按回车键进行数组下落操作...";
			huiche();

			cct_gotoxy(0, y + hang + 6);
			cout << "下落后的数组：" << endl;
			MOVE(24, shuju, hang, lie);
			print_shuzu(1, hang, lie, x, y, shuju);
			highlight(2, hang, lie, shuju, jieguo, x, y);

			cct_gotoxy(0, y + hang + 2);
			cout << "本次消除结束，按回车键继续新一次的消除... ";
			huiche();
		}
		else if (option == 'N' || option == 'n') {
			continue;
		}
		else if (option == 'Q' || option == 'q') {
			break;
		}
	}

	cin.clear();
	while ((c = cin.get()) != '\n' && c != EOF);
	cct_gotoxy(0, y + hang + 3);
	wait_for_return();
}

void choice_D()
{
	int x = 0, y = 0; //储存数组起始位置
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score = 0;
	int qishi_x, qishi_y;
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	cct_setconsoleborder(7 + 6 * lie, 8 + 3 * hang);
	cct_cls();

	/*cct_gotoxy(0, 0);
	cout << "屏幕当前设置为：" << 8 + 3 * hang << "行" << 7 + 6 * lie << "列";*/
	sprintf_s(zhuangtailan, "屏幕当前设置为：%d行%d列", 8 + 3 * hang, 7 + 6 * lie);
	print_zhuangtailan(0, 0, zhuangtailan);
	/*zhuangtailan(0,0,5, "屏幕当前设置为：",0,7,char(8 + 3 * hang),"行",0,7, char(7 + 6 * lie),0,7, "列",0,7);*/
	paint_frame(hang, lie, shuju, 0, 1, 1, 3, 6);
	//paint_tuxing(hang, lie, shuju, 0, 1, 2, 3, 6, "★");

	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			qishi_x = 4 + j * 6;
			qishi_y = 3 + i * 3;
			edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
			Sleep(1);
		}
	}

	/*cct_gotoxy(0, 3 * hang + 4);
	cout << "箭头键/鼠标移动，回车键/单击左键选择并结束";*/\
	sprintf_s(zhuangtailan, "箭头键/鼠标移动，回车键/单击左键选择并结束");
	print_zhuangtailan(0, 3 * hang + 4, zhuangtailan);

	cct_setcursor(3); //隐藏光标
	cct_enable_mouse(); //允许鼠标操作
	keyboard_and_mouse(hang, lie, shuju, 3 * hang + 4, 0);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, y + hang * 3 + 5);
	wait_for_return();
}

void choice_E()
{
	int x = 0, y = 0; //储存数组起始位置
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score = 0;
	int qishi_x, qishi_y;
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	cct_setconsoleborder(5 + 8 * lie, 7 + 4 * hang);
	cct_cls();

	/*cct_gotoxy(0, 0);
	cout << "屏幕当前设置为：" << 7 + 4 * hang << "行" << 5 + 8 * lie << "列";*/
	sprintf_s(zhuangtailan, "屏幕当前设置为：%d行%d列", 7 + 4 * hang, 5 + 8 * lie);
	print_zhuangtailan(0, 0, zhuangtailan);
	paint_frame(hang, lie, shuju, 1, 1, 1, 3, 6);
	//paint_tuxing(hang, lie, shuju, 1, 1, 2, 3, 6, "★");

	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			qishi_x = 4 + j * 8;
			qishi_y = 3 + i * 4;
			edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
			Sleep(1);
		}
	}

	/*cct_gotoxy(0, 4 * hang + 3);
	cout << "箭头键/鼠标移动，回车键/单击左键选择并结束";*/
	sprintf_s(zhuangtailan, "箭头键/鼠标移动，回车键/单击左键选择并结束");
	print_zhuangtailan(0, 4 * hang + 3, zhuangtailan);

	cct_setcursor(3); //隐藏光标
	cct_enable_mouse(); //允许鼠标操作
	keyboard_and_mouse(hang, lie, shuju, 4 * hang + 3, 1);

	cct_setcursor(2); //恢复光标
	cct_gotoxy(0, y + hang * 4 + 5);
	wait_for_return();
}

void choice_F()
{
	int x = 0, y = 0; //储存数组起始位置
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score;
	int once_score;
	int qishi_x, qishi_y;
	bool tuichu = true;  //tuichu对一次性的F菜单没什么用
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	total_score = 0;

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 5 + 1;
		}
	}

	cct_setconsoleborder(7 + 6 * lie, 8 + 3 * hang);
	cct_cls();

	/*cct_gotoxy(0, 0);
	cout << "屏幕当前设置为：" << 8 + 3 * hang << "行" << 7 + 6 * lie << "列";*/
	sprintf_s(zhuangtailan, "屏幕当前设置为：%d行%d列", 8 + 3 * hang, 7 + 6 * lie);
	print_zhuangtailan(0, 0, zhuangtailan);
	paint_frame(hang, lie, shuju, 0, 1, 1, 3, 6);

	/*cct_gotoxy(0, 4 * hang + 3);
	cout << "箭头键/鼠标移动，回车键/单击左键选择并结束";*/
	sprintf_s(zhuangtailan, "箭头键/鼠标移动，回车键/单击左键选择并结束");
	print_zhuangtailan(0, 4 * hang + 3, zhuangtailan);

	cct_setcursor(3); //隐藏光标
	cct_enable_mouse(); //允许鼠标操作

	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			qishi_x = 4 + j * 6;
			qishi_y = 3 + i * 3;
			edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
			Sleep(1);
		}
	}

	keyboard_and_mouse_full(hang, lie, shuju, jieguo, 3 * hang + 4, 0, tuichu);

	once_score = 0;
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			if (jieguo[i][j] > 0) {
				qishi_x = 4 + j * 6;
				qishi_y = 3 + i * 3;
				edit_tuxing(jieguo[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 0);
				jieguo[i][j] = 0;
				shuju[i][j] = 0;
				once_score++;
			}
		}
	}
	once_score = once_score * once_score * 5;
	total_score += once_score;
	/*cct_gotoxy(0, 0);
	cout << "本次得分：" << once_score << "  总得分:" << total_score << "                                ";*/
	sprintf_s(zhuangtailan, "本次得分：%d  总得分:%d                                ", once_score, total_score);
	print_zhuangtailan(0, 0, zhuangtailan);

	/*cct_gotoxy(0, hang * 3 + 4);
	cout << "合成完成，回车键/单击左键下落                                            ";*/
	sprintf_s(zhuangtailan, "合成完成，回车键/单击左键下落                                            ");
	print_zhuangtailan(0, hang * 3 + 4, zhuangtailan);

	mouse_leftclick_or_keyboard_Enter_or_C(1);

	MOVE(DOWN_LEFT, shuju, hang, lie, 1, 3, 6, "★", 1, 0, 2);
	cct_setcolor(0, COLOR_HYELLOW);
	/*cct_gotoxy(0, hang * 3 + 4);
	cout << "本次合成结束，按C/单击左键继续一次新的合成!                                ";*/
	sprintf_s(zhuangtailan, "本次合成结束，按C/单击左键继续一次新的合成!                                ");
	print_zhuangtailan(0, hang * 3 + 4, zhuangtailan);

	mouse_leftclick_or_keyboard_Enter_or_C(2);

	cct_setcursor(2); //恢复光标
	cct_setcolor();
	cct_gotoxy(0, hang * 3 + 6);
	wait_for_return();
}

void choice_G()
{
	int x = 0, y = 0; //储存数组起始位置
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score;
	int once_score;
	int qishi_x, qishi_y;
	bool tuichu = false;
	char zhuangtailan[100] = { 0 };
	srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(3, hang, lie);

	while (6) {
		total_score = 0;

		//初始化内部数组
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				shuju[i][j] = rand() % 5 + 1;
			}
		}

		cct_setconsoleborder(5 + 8 * lie, 7 + 4 * hang);
		cct_cls();

		/*cct_gotoxy(0, 0);
		cout << "屏幕当前设置为：" << 7 + 4 * hang << "行" << 5 + 8 * lie << "列";*/
		sprintf_s(zhuangtailan, "屏幕当前设置为：%d行%d列", 7 + 4 * hang, 5 + 8 * lie);
		print_zhuangtailan(0, 0, zhuangtailan);
		paint_frame(hang, lie, shuju, 1, 1, 1, 3, 6);
		//paint_tuxing(hang, lie, shuju, 1, 1, 2, 3, 6, "★");

		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				qishi_x = 4 + j * 8;
				qishi_y = 3 + i * 4;
				edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
				Sleep(1);
			}
		}

		/*cct_gotoxy(0, 4 * hang + 3);
		cout << "箭头键/鼠标移动，回车键/单击左键选择并结束";*/
		sprintf_s(zhuangtailan, "箭头键/鼠标移动，回车键/单击左键选择并结束");
		print_zhuangtailan(0, 4 * hang + 3, zhuangtailan);

		cct_setcursor(3); //隐藏光标
		cct_enable_mouse(); //允许鼠标操作

		while (detect_game_finished(hang, lie, shuju)) {
			keyboard_and_mouse_full(hang, lie, shuju, jieguo, 4 * hang + 3, 1, tuichu);

			if (tuichu)
				break;

			once_score = 0;
			for (int i = 0; i < hang; i++) {
				for (int j = 0; j < lie; j++) {
					if (jieguo[i][j] > 0) {
						qishi_x = 4 + j * 8;
						qishi_y = 3 + i * 4;
						edit_tuxing(jieguo[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 0);
						jieguo[i][j] = 0;
						shuju[i][j] = 0;
						once_score++;
					}
				}
			}
			once_score = once_score * once_score * 5;
			total_score += once_score;

			/*cct_gotoxy(0, 0);
			cout << "本次得分：" << once_score << "  总得分:" << total_score << "                                ";*/
			sprintf_s(zhuangtailan, "本次得分：%d  总得分:%d                                ", once_score, total_score);
			print_zhuangtailan(0, 0, zhuangtailan);

			MOVE(DOWN_LEFT, shuju, hang, lie, 1, 3, 6, "★", 1, 1, 2);
		}

		if (tuichu)
			break;

		/*bool tuichu = detect_game_finished(hang, lie, shuju);*/

		int count = 0;
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (shuju[i][j] > 0) {
					count++;
				}
			}
		}

		once_score = (count >= 10) ? 0 : 180 * (10 - count);
		total_score += once_score;
		/*cct_gotoxy(0, 0);
		cout << "奖励得分：" << once_score << "  总得分:" << total_score << "                                ";*/
		sprintf_s(zhuangtailan, "奖励得分：%d  总得分:%d                                ", once_score, total_score);
		print_zhuangtailan(0, 0, zhuangtailan);

		cct_setcursor(2); //恢复光标
		cct_gotoxy(0, y + hang * 4 + 3);

		/*cct_setcolor(0, COLOR_HYELLOW);
		cout << "剩余" << count << "个星星，无可消除项，本关结束！！！";
		cct_setcolor();
		cout << "回车继续下一关";*/
		sprintf_s(zhuangtailan, "剩余%d个星星，无可消除项，本关结束! 回车继续下一关", count);
		print_zhuangtailan(0, y + hang * 4 + 3, zhuangtailan);
		huiche();
	}
	//print_shuzu(1, hang, lie, x, y, shuju);
	//huiche();
	cct_gotoxy(0, hang * 4 + 5);
	wait_for_return();
}