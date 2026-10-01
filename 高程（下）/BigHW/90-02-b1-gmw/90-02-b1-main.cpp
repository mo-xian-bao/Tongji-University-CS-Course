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
#include "90-02-b1.h"
#include "../include/cmd_gmw_tools.h"
#include <cmath>
using namespace std;

int main()
{
	cct_setfontsize("新宋体", 16);
	cct_setconsoleborder(120, 40, 120, 9000);
	cct_setcolor();
	cct_cls();

	CONSOLE_GRAPHICS_INFO Gpopstar_CGI; //声明一个CGI变量
	char shuru_chazhao[10] = { 0 }; //读取的为显示的行标号（a，b等）;读取的为显示的列标号（从0开始）
	int hang, lie;
	int shuju[10][10] = { 0 };
	int jieguo[10][10] = { 0 };
	int total_score;
	int once_score;
	bool tuichu = false; 
	char temp[256]; //状态栏
	srand(static_cast<unsigned int>(time(0)));

	shuru(3, hang, lie);

	/*用缺省值初始化（窗口背景黑/前景白，新宋体16*8，上下左右无额外行列，上下状态栏均有，无行号/列标，框架线型为双线，色块宽度2/高度1/无小边框，颜色略）*/
	gmw_init(&Gpopstar_CGI);
	gmw_set_color(&Gpopstar_CGI, COLOR_BLACK, COLOR_WHITE);			//整个窗口颜色
	gmw_set_frame_style(&Gpopstar_CGI, 6, 3, true);//游戏主区域风格：每个色块宽6高3，有分隔线
	gmw_set_frame_default_linetype(&Gpopstar_CGI, 2);	
	gmw_set_frame_color(&Gpopstar_CGI, COLOR_HWHITE, COLOR_BLACK);	//游戏主区域颜色
	gmw_set_block_border_switch(&Gpopstar_CGI, true);				//色块带边框
	gmw_set_rowno_switch(&Gpopstar_CGI, true);		//显示行号
	gmw_set_colno_switch(&Gpopstar_CGI, true);		//显示列标
	gmw_set_delay(&Gpopstar_CGI, DELAY_OF_BLOCK_MOVED, 0);
	gmw_set_delay(&Gpopstar_CGI, DELAY_OF_DRAW_BLOCK, 0);
	gmw_set_delay(&Gpopstar_CGI, BLOCK_MOVED_DELAY_MS, 15);
	gmw_set_rowcol(&Gpopstar_CGI, hang, lie);		//设置行列数

	cct_setcursor(CURSOR_INVISIBLE);

	while (true) {
		total_score = 0;

		//初始化内部数组
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				shuju[i][j] = rand() % 5 + 1;
			}
		}

		/* 上状态栏显示内容 */
		sprintf(temp, "屏幕大小：%d行%d列，当前分数：%d", Gpopstar_CGI.lines, Gpopstar_CGI.cols, total_score);
		gmw_status_line(&Gpopstar_CGI, TOP_STATUS_LINE, temp);

		//画框架
		gmw_draw_frame(&Gpopstar_CGI);

		//画色块
		draw_star_normal(&Gpopstar_CGI, shuju);

		//下状态栏显示内容
		sprintf(temp, "箭头键/鼠标移动，回车键/单击左键选择并结束");
		gmw_status_line(&Gpopstar_CGI, LOWER_STATUS_LINE, temp);

		//游戏主循环
		int old_mrow = Gpopstar_CGI.row_num - 1, old_mcol = 0;
		while (detect_game_finished(hang, lie, shuju)) {
			popstar_keyboard_mouse(&Gpopstar_CGI, shuju, jieguo, old_mrow, old_mcol,tuichu);

			if (tuichu)
				break;

			//消除色块
			clear_star(&Gpopstar_CGI, shuju, jieguo);

			//计算分数
			once_score = 0;
			for (int i = 0; i < hang; i++) {
				for (int j = 0; j < lie; j++) {
					if (jieguo[i][j] > 0) {
						gmw_draw_block(&Gpopstar_CGI, i, j, 0, bdi_normal);
						jieguo[i][j] = 0;
						once_score++;
					}
				}
			}
			once_score = once_score * once_score * 5;
			total_score += once_score;
			//下状态栏显示内容
			sprintf(temp, "本次得分:%d  总得分:%d", once_score, total_score);
			gmw_status_line(&Gpopstar_CGI, TOP_STATUS_LINE, temp);

			//色块下落
			move_star(&Gpopstar_CGI, shuju);
		}
		if (tuichu)
			break;

		//游戏结束，显示游戏结果
		int count = 0;
		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (shuju[i][j] > 0) {
					count++;
				}
			}
		}
		once_score = count>10?0:count*180;
		sprintf(temp, "剩余%d个星星，无可消除项，本关结束！", count);
		gmw_status_line(&Gpopstar_CGI, LOWER_STATUS_LINE, "回车继续下一关...", temp);
		sprintf(temp, "奖励得分：%d  ", once_score);
		char temp2[256];
		sprintf(temp2, "本关结束，总得分：%d", total_score);
		gmw_status_line(&Gpopstar_CGI, TOP_STATUS_LINE, temp2, temp);
		huiche();
	}

	return 0;
}