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
#include "90-02-b2.h"
#include "../include/cmd_gmw_tools.h"
#include <cmath>
using namespace std;

int main()
{
	cct_setcolor();
	cct_cls();

	int row, col ;  //游戏区域行列数
	bool is_seprator = false;  //是否输入了行列数
	input_row_col_seprator(row, col,is_seprator);  //输入行列数
	int board[12][12] = { 0 };                //游戏区域的二维数组
	char temp[256];                    //状态栏显示内容
	CONSOLE_GRAPHICS_INFO G2048_CGI; //声明一个CGI变量

	const BLOCK_DISPLAY_INFO bdi_normal[] = {
		{BDI_VALUE_BLANK, -1, -1, NULL},  //0不显示，用空格填充即可
		{2, COLOR_HWHITE, COLOR_BLACK, NULL},
		{4, COLOR_HYELLOW, COLOR_BLACK, NULL},
		{8, COLOR_HRED, COLOR_BLACK, NULL},
		{16, COLOR_RED, COLOR_BLACK, NULL},
		{32, COLOR_HGREEN, COLOR_BLACK, NULL},
		{64, COLOR_YELLOW, COLOR_BLACK, NULL},
		{128, COLOR_CYAN, COLOR_BLACK, NULL},
		{256, COLOR_WHITE, COLOR_BLACK, NULL},
		{512, COLOR_HBLACK, COLOR_BLACK, NULL},
		{1024, COLOR_HPINK, COLOR_BLACK, NULL},
		{2048, COLOR_PINK, COLOR_BLACK, NULL},
		{4096, COLOR_YELLOW, COLOR_BLACK, NULL},
		{8192, COLOR_PINK, COLOR_BLACK, NULL},
		{16384, COLOR_HBLUE, COLOR_BLACK, NULL},
		{32768, COLOR_HCYAN, COLOR_BLACK, NULL},
		{65536, COLOR_HGREEN, COLOR_BLACK, NULL},
		{131072, COLOR_HPINK, COLOR_BLACK, NULL},  //如果开心，还可以继续加
		{BDI_VALUE_END, -1, -1, NULL} //判断结束条件为-999
	};

	/*用缺省值初始化（窗口背景黑/前景白，点阵16*8，上下左右无额外行列，上下状态栏均有，无行号/列标，框架线型为双线，色块宽度2/高度1/无小边框，颜色略）*/
	gmw_init(&G2048_CGI);
	gmw_set_color(&G2048_CGI, COLOR_BLACK, COLOR_WHITE);			//整个窗口颜色
	gmw_set_font(&G2048_CGI, "新宋体", 16);						//字体
	gmw_set_frame_style(&G2048_CGI, 10, 5, is_seprator);//游戏主区域风格：每个色块宽10高5，无分隔线【数字色块带边框，宽度为10(放最多6位数字)，高度为5(为了保持色块为方形)】
	gmw_set_ext_rowcol(&G2048_CGI, 2, 3, 4, 5);	//额外行列：上2下3，左4右5
	gmw_set_frame_color(&G2048_CGI, COLOR_WHITE, COLOR_BLACK);	//游戏主区域颜色
	gmw_set_block_border_switch(&G2048_CGI, true);				//小色块带边框
	gmw_set_rowno_switch(&G2048_CGI, false);		//不显示行号
	gmw_set_colno_switch(&G2048_CGI, false);		//不显示列标
	gmw_set_delay(&G2048_CGI, DELAY_OF_DRAW_FRAME, 0);
	gmw_set_delay(&G2048_CGI, DELAY_OF_BLOCK_MOVED, 0);
	gmw_set_delay(&G2048_CGI, DELAY_OF_DRAW_BLOCK, 0);

	initalize_board(board, row, col);                   //初始化游戏内部数组

	/* 按row/col的值重设游戏主区域行列 */
	gmw_set_rowcol(&G2048_CGI, row, col);

	/* 显示框架 */
	gmw_draw_frame(&G2048_CGI);

	/* 上状态栏显示内容 */
	sprintf(temp, "窗口大小：%d行 %d列", G2048_CGI.lines, G2048_CGI.cols);
	gmw_status_line(&G2048_CGI, TOP_STATUS_LINE, temp, "2048小游戏 ");

	cct_setcursor(CURSOR_INVISIBLE);  //隐藏光标

	//显示初始色块
	for (int i = 1; i <= row; i++) {
		for (int j = 1; j <= col; j++) {
			gmw_draw_block(&G2048_CGI, i-1, j-1, board[i][j], bdi_normal);
		}
	}

	//开始游戏
	int score = 0;  //记录分数
	while (!gameover_judge(board,row,col)) {  //游戏未结束
		int MX, MY, MAction, keycode1, keycode2;  //用于处理键盘和鼠标
		
		int event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);
		if (event == CCT_KEYBOARD_EVENT && keycode1 == 0xe0) {  //按下箭头键
			int direction ;  //方向：上=0，下=1，左=2，右=3
			switch (keycode2) {
			case 72:  //上
				direction = 0;
				break;
			case 80:  //下
				direction = 1;
				break;
			case 75:  //左
				direction = 2;
				break;
			case 77:  //右
				direction = 3;
				break;
			}
			if(move_block(&G2048_CGI, board,row,col, bdi_normal, direction,score))  //移动
				random_create_num_and_block(&G2048_CGI, board,row,col, bdi_normal);  //随机生成数字和色块

			//显示当前分数
			sprintf(temp, "当前分数：%d", score);
			gmw_status_line(&G2048_CGI, TOP_STATUS_LINE, temp, "2048小游戏 ");
		}
	}
	//游戏结束
	cct_setcursor(CURSOR_VISIBLE_NORMAL);  //显示光标
	gmw_status_line(&G2048_CGI, LOWER_STATUS_LINE, "按回车键退出","游戏结束！");

	huiche();
	return 0;
}
