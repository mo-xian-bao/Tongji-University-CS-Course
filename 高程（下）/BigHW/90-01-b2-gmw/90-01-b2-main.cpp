/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <stdio.h>  
#include <conio.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-01-b2.h"
#include "../include/cmd_gmw_tools.h"
#include <cmath>
using namespace std;

int main()
{
	cct_setfontsize("新宋体", 16);
	cct_setconsoleborder(120, 40, 120, 9000);
	cct_setcolor();
	cct_cls();

	int x, y; //数组起始位置
	int hang, lie , score = 0;
	//bool flag;
	int jieguo[10][10] = { 0 };
	int shuju[10][10] = { 0 }, tishi[144][4] = { 0 }, t = 0;
	CONSOLE_GRAPHICS_INFO Gmagicball_CGI; //声明一个CGI变量
	char temp[256]; //状态栏
	srand(static_cast<unsigned int>(time(0)));

	/* 定义1-9的数字用何种形式显示在界面上（正常状态） */
	const BLOCK_DISPLAY_INFO bdi_normal[] = {
		{BDI_VALUE_BLANK, -1, -1, "  "},  //0不显示，用空格填充即可
		{1, COLOR_HBLACK, -1, "〇"},
		{2, COLOR_YELLOW, -1, "〇"},
		{3, COLOR_HGREEN, -1, "〇"},
		{4, COLOR_HCYAN, -1, "〇"},
		{5, COLOR_HRED, -1, "〇"},
		{6, COLOR_HPINK, -1, "〇"},
		{7, COLOR_HYELLOW, -1, "〇"},
		{8, COLOR_CYAN, -1, "〇"},
		{9, COLOR_WHITE, -1, "〇"},
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};
	/* 定义1-9的数字用何种形式显示在界面上（选中状态） */
	const BLOCK_DISPLAY_INFO bdi_selected[] = {
		{BDI_VALUE_BLANK, -1, -1, "  "},  //空白
		{1, COLOR_HBLACK, -1, "●"},
		{2, COLOR_YELLOW, -1, "●"},
		{3, COLOR_HGREEN, -1, "●"},
		{4, COLOR_HCYAN, -1, "●"},
		{5, COLOR_HRED, -1, "●"},
		{6, COLOR_HPINK, -1, "●"},
		{7, COLOR_HYELLOW, -1, "●"},
		{8, COLOR_CYAN, -1, "●"},
		{9, COLOR_WHITE, -1, "●"},
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};
	/* 定义1-9的数字用何种形式显示在界面上（高亮选中状态） */
	const BLOCK_DISPLAY_INFO bdi_selected_highlight[] = {
		{BDI_VALUE_BLANK, -1, -1, "  "},  //空白
		{1, COLOR_HBLACK, COLOR_HWHITE, "◎"},
		{2, COLOR_YELLOW, COLOR_HWHITE, "◎"},
		{3, COLOR_HGREEN, COLOR_HWHITE, "◎"},
		{4, COLOR_HCYAN, COLOR_HWHITE, "◎"},
		{5, COLOR_HRED, COLOR_HWHITE, "◎"},
		{6, COLOR_HPINK,COLOR_HWHITE, "◎"},
		{7, COLOR_HYELLOW, COLOR_HWHITE, "◎"},
		{8, COLOR_CYAN, COLOR_HWHITE, "◎"},
		{9, COLOR_WHITE, COLOR_HWHITE, "◎"},
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};
	/* 定义1-9的数字用何种形式显示在界面上（可消除提示状态） */
	const BLOCK_DISPLAY_INFO bdi_prompt[] = {
		{BDI_VALUE_BLANK, -1, -1, "  "},  //空白
		{1, COLOR_HBLACK, -1, "◎"},
		{2, COLOR_YELLOW, -1, "◎"},
		{3, COLOR_HGREEN, -1, "◎"},
		{4, COLOR_HCYAN, -1, "◎"},
		{5, COLOR_HRED, -1, "◎"},
		{6, COLOR_HPINK, -1, "◎"},
		{7, COLOR_HYELLOW, -1, "◎"},
		{8, COLOR_CYAN, -1, "◎"},
		{9, COLOR_WHITE, -1, "◎"},
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};
	/* 定义1-9的数字用何种形式显示在界面上（爆炸/消除状态） */
	const BLOCK_DISPLAY_INFO bdi_exploded[] = {
		{BDI_VALUE_BLANK, -1, -1, "  "},  //空白
		{1, COLOR_HBLACK, -1, "¤"},
		{2, COLOR_YELLOW, -1, "¤"},
		{3, COLOR_HGREEN, -1, "¤"},
		{4, COLOR_HCYAN, -1, "¤"},
		{5, COLOR_HRED, -1, "¤"},
		{6, COLOR_HPINK, -1, "¤"},
		{7, COLOR_HYELLOW, -1, "¤"},
		{8, COLOR_CYAN, -1, "¤"},
		{9, COLOR_WHITE, -1, "¤"},
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};

	cct_setcolor();
	cct_cls();
	shuru(2, hang, lie);

	/*用缺省值初始化（窗口背景黑/前景白，新宋体16*8，上下左右无额外行列，上下状态栏均有，无行号/列标，框架线型为双线，色块宽度2/高度1/无小边框，颜色略）*/
	gmw_init(&Gmagicball_CGI);
	gmw_set_color(&Gmagicball_CGI, COLOR_BLACK, COLOR_WHITE);			//整个窗口颜色
	gmw_set_frame_style(&Gmagicball_CGI, 2, 1, true);//游戏主区域风格：每个色块宽2高1，有分隔线
	gmw_set_frame_color(&Gmagicball_CGI, COLOR_HWHITE, COLOR_BLACK);	//游戏主区域颜色
	gmw_set_block_border_switch(&Gmagicball_CGI, false);				//小色块不带边框
	gmw_set_rowno_switch(&Gmagicball_CGI, true);		//显示行号
	gmw_set_colno_switch(&Gmagicball_CGI, true);		//显示列标
	gmw_set_delay(&Gmagicball_CGI, DELAY_OF_BLOCK_MOVED, 0);
	gmw_set_delay(&Gmagicball_CGI, DELAY_OF_DRAW_BLOCK, 0);
	gmw_set_rowcol(&Gmagicball_CGI, hang, lie);		//设置行列数

	//初始化内部数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			shuju[i][j] = rand() % 9 + 1;
		}
	}
	//打印初始数组
	cout << endl;
	cout << "初始数组：" << endl;
	print_shuzu(1, hang, lie, x, y, shuju);

	cout << "按回车键显示图形...";
	huiche();
	gmw_set_font(&Gmagicball_CGI, "新宋体", 32);						//字体

	//画框架
	cct_setcursor(CURSOR_INVISIBLE);
	gmw_draw_frame(&Gmagicball_CGI);

	//画彩球
	draw_magicball_normal(&Gmagicball_CGI, shuju, hang, lie, bdi_normal);

	//消除初始可消除项
	while (can_disappear(shuju, jieguo)) {
		//把图形可消除项标为实心(有边框)
		draw_magicball_selected(&Gmagicball_CGI, jieguo, shuju,hang, lie, bdi_selected, bdi_normal);
		Sleep(500);

		//消除可消除项
		draw_magicball_exploded(&Gmagicball_CGI, jieguo,shuju, hang, lie, bdi_normal,bdi_exploded,score);

		//图形移动
		move_magicball(&Gmagicball_CGI, shuju, hang, lie, bdi_normal);

		//生成新的图形
		generate_magicball(&Gmagicball_CGI, shuju, hang, lie, bdi_normal);
	}

	/* 上状态栏显示内容 */
	score = 0;
	sprintf(temp, "屏幕大小：%d行%d列，当前分数：%d", Gmagicball_CGI.lines, Gmagicball_CGI.cols,score);
	gmw_status_line(&Gmagicball_CGI, TOP_STATUS_LINE, temp);

	//游戏主循环
	bool tuichu = false;
	while (true) {
		//可消除状态提示
		hint(hang, lie, shuju, tishi, t);
		tishi_to_jieguo(tishi, t, jieguo);
		draw_magicball_prompt(&Gmagicball_CGI,jieguo,shuju, hang, lie, bdi_prompt);
		if (t == 0) //没有可消除项
			break;

		cct_enable_mouse(); //允许鼠标操作
		magicball_mouse(&Gmagicball_CGI, shuju, tishi, hang, lie, t, tuichu, bdi_selected_highlight, bdi_normal, bdi_prompt);

		if (tuichu) //退出游戏
			break;

		//消除可消除项
		while (can_disappear(shuju, jieguo)) {
			//把图形可消除项标为实心(有边框)
			draw_magicball_selected(&Gmagicball_CGI, jieguo, shuju, hang, lie, bdi_selected, bdi_normal);
			Sleep(500);

			//消除可消除项
			draw_magicball_exploded(&Gmagicball_CGI, jieguo, shuju, hang, lie, bdi_normal, bdi_exploded, score);

			/* 上状态栏显示内容 */
			sprintf(temp, "屏幕大小：%d行%d列，当前分数：%d", Gmagicball_CGI.lines, Gmagicball_CGI.cols, score);
			gmw_status_line(&Gmagicball_CGI, TOP_STATUS_LINE, temp);

			//图形移动
			move_magicball(&Gmagicball_CGI, shuju, hang, lie, bdi_normal);

			//生成新的图形
			generate_magicball(&Gmagicball_CGI, shuju, hang, lie, bdi_normal);
		}
	}

	//游戏结束，下状态栏显示最终结果
	gmw_status_line(&Gmagicball_CGI, LOWER_STATUS_LINE, "按回车键退出...", "游戏结束！");

	huiche();
	return 0;
}