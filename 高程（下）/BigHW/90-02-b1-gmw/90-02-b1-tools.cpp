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

void draw_star_normal(const CONSOLE_GRAPHICS_INFO* const pCGI,int shuju[10][10])
{
	for (int i = 0; i < pCGI->row_num; i++) {
		for (int j = 0; j < pCGI->col_num; j++) {
			gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
		}
	}
}

 static void draw_star_selected_related(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int jieguo[10][10], int row_seleted, int col_seleted)
{
	for (int i = 0; i < pCGI->row_num; i++) {
		for (int j = 0; j < pCGI->col_num; j++) {
			if (jieguo[i][j] > 0 && i == row_seleted && j == col_seleted) {
				gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_selected);
			}
			else if (jieguo[i][j] > 0) {
				gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_related);
			}
		}
	}
}

void clear_star(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int jieguo[10][10])
{
	for (int i = 0; i < pCGI->row_num; i++) {
		for (int j = 0; j < pCGI->col_num; j++) {
			if (jieguo[i][j] > 0) {
				gmw_draw_block(pCGI, i, j, 0, bdi_normal);
				shuju[i][j] = 0;
			}
		}
	}
}

void move_star(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10])
{
	int distance;
	for (int i = 0; i < pCGI->col_num; i++) {  //遍历列
		for (int j = pCGI->row_num - 1; j >= 0; j--) {  //遍历行
			if (shuju[j][i] != 0) {  //如果该位置有数字
				distance = 0;
				for (int k = j + 1; k < pCGI->row_num; k++) {
					if (shuju[k][i] == 0)
						distance++;
				}
				if (distance > 0) {  //如果有空位可以移动
					gmw_move_block(pCGI, j, i, shuju[j][i], 0, bdi_normal, UP_TO_DOWN, distance);
					shuju[j + distance][i] = shuju[j][i];
					shuju[j][i] = 0;
				}
			}
		}
	}
	for (int j0 = 0; j0 < pCGI->col_num - 1; j0++) {
		int count1 = 0;
		for (int i = 0; i < pCGI->row_num; i++) {
			count1 += shuju[i][j0];
		}
		if (count1 == 0) {
			int count2 = 0;
			int j1;
			for (j1 = j0 + 1; j1 < pCGI->col_num - 1; j1++) {
				for (int i = 0; i < pCGI->row_num; i++) {
					count2 += shuju[i][j1];
				}
				if (count2 != 0) {
					break;
				}
			}
			for (int i = 0; i < pCGI->row_num; i++) {
				if (shuju[i][j1] != 0) {
					gmw_move_block(pCGI, i, j1, shuju[i][j1], 0, bdi_normal, RIGHT_TO_LEFT, j1 - j0);
					shuju[i][j0] = shuju[i][j1];
					shuju[i][j1] = 0;
				}
			}
		}
	}
}

bool detect_game_finished(int hang, int lie, int shuju[10][10])  //判断游戏是否结束（即是否还存在可消除区域）
{
	for (int i = 0; i < hang - 1; i++) {
		for (int j = 0; j < lie; j++) {
			if (shuju[i][j] != 0) {
				if (shuju[i][j] == shuju[i + 1][j]) {
					return true;
				}
			}
		}
	}
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie - 1; j++) {
			if (shuju[i][j] != 0) {
				if (shuju[i][j] == shuju[i][j + 1]) {
					return true;
				}
			}
		}
	}
	return false;
}

void popstar_keyboard_mouse(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10],int jieguo[10][10],int& old_mrow, int& old_mcol,bool& tuichu)
{
	int maction, mrow, mcol;
	int selected_mrow = -1, selected_mcol = -1; //记录选中的位置
	int keycode1, keycode2;
	int ret;
	char status_line[100] = { 0 }; //用于状态栏显示

	gmw_draw_block(pCGI, old_mrow, old_mcol, shuju[old_mrow][old_mcol], bdi_selected);  //初始化s所在位置
    //下状态栏提示
	sprintf(status_line, "[当前键盘]%c行%d列", 'A' + old_mrow, old_mcol);
	gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);

	while (true) {
		ret = gmw_read_keyboard_and_mouse(pCGI, maction, mrow, mcol, keycode1, keycode2);

		if (ret == CCT_KEYBOARD_EVENT) {
			if (keycode1 == 0xe0) {
				if(old_mrow != -1 && old_mcol != -1)
					gmw_draw_block(pCGI, old_mrow, old_mcol, shuju[old_mrow][old_mcol], bdi_normal);   //恢复上一次移动位置色块的显示

				mrow = old_mrow;
				mcol = old_mcol;
				if (keycode2 == KB_ARROW_UP) {
					mrow = (mrow + pCGI->row_num - 1) % pCGI->row_num;
					while (shuju[mrow][mcol] == 0) {
						mrow = (mrow + pCGI->row_num - 1) % pCGI->row_num;
					}
				}
				else if (keycode2 == KB_ARROW_DOWN) {
					mrow = (mrow + 1) % pCGI->row_num;
					while (shuju[mrow][mcol] == 0) {
						mrow = (mrow + 1) % pCGI->row_num;
					}
				}
				else if (keycode2 == KB_ARROW_LEFT) {
					mcol = (mcol + pCGI->col_num - 1) % pCGI->col_num;
					while (shuju[mrow][mcol] == 0) {
						mcol = (mcol + pCGI->col_num - 1) % pCGI->col_num;
					}
				}
				else if (keycode2 == KB_ARROW_RIGHT) {
					mcol = (mcol + 1) % pCGI->col_num;
					while (shuju[mrow][mcol] == 0) {
						mcol = (mcol + 1) % pCGI->col_num;
					}
				}
				gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_selected);

				//下状态栏提示
				sprintf(status_line, "[当前键盘]%c行%d列", 'A' + mrow, mcol);
				gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);

				old_mrow = mrow;
				old_mcol = mcol;
			}
			else if (keycode1 == 0x0d) {  //按下回车键
				bool is_related = chazhao_jieguo(mrow, mcol, pCGI->row_num, pCGI->col_num, shuju, jieguo);
				if (is_related) {
					selected_mrow = mrow;
					selected_mcol = mcol;
					//下状态栏提示
					draw_star_selected_related(pCGI, shuju,jieguo, selected_mrow, selected_mcol);
					sprintf(status_line, "选中了%c行%d列", 'A' + selected_mrow, selected_mcol);
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);
					break;
				}
				else {  //无关联项
					selected_mrow = -1;
					selected_mcol = -1;

					//下状态栏提示
					sprintf(status_line, "箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束");
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line, "周围无相同值! ");
					continue;  //继续等待用户操作
				}
			}
			else if (keycode1 == 81 || keycode1 == 113) {
				tuichu = true;
				return;
			}
		}
		else if (ret == CCT_MOUSE_EVENT) {
			if (maction == MOUSE_ONLY_MOVED) {  //鼠标移动
				gmw_draw_block(pCGI, old_mrow, old_mcol, shuju[old_mrow][old_mcol], bdi_normal);   //恢复上一次移动位置色块的显示
				gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_selected);

				//下状态栏提示
				sprintf(status_line, "[当前鼠标]%c行%d列", 'A' + mrow, mcol);
				gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);

				old_mrow = mrow;
				old_mcol = mcol;
			}
			else if (maction == MOUSE_LEFT_BUTTON_CLICK) {  //鼠标左键单击
				bool is_related = chazhao_jieguo(mrow, mcol, pCGI->row_num, pCGI->col_num, shuju, jieguo);
				if (is_related) {
					selected_mrow = mrow;
					selected_mcol = mcol;
					//下状态栏提示
					draw_star_selected_related(pCGI, shuju, jieguo, selected_mrow, selected_mcol);
					sprintf(status_line, "选中了%c行%d列", 'A' + selected_mrow, selected_mcol);
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);
					break;
				}
				else {  //无关联项
					selected_mrow = -1;
					selected_mcol = -1;

					//下状态栏提示
					sprintf(status_line, "箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束");
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line, "周围无相同值! ");
					continue;  //继续等待用户操作
				}
			}
			else if (maction == MOUSE_RIGHT_BUTTON_CLICK) {  //鼠标右键单击
				tuichu = true;
				return;
			}
		}
	}
	if (selected_mrow != -1 && selected_mcol != -1) {  //有选中位置
		while (true) {
			ret = gmw_read_keyboard_and_mouse(pCGI, maction, mrow, mcol, keycode1, keycode2);   //等待用户操作
			if (ret == CCT_KEYBOARD_EVENT) {
				if (keycode1 == 0x0d) {//按下回车键,试图消除关联项
					old_mrow=pCGI->row_num - 1;
					old_mcol=0;
					return; 
				}
				else if (keycode1 == 0xe0) {  //按下箭头键
					for (int i = 0; i < pCGI->row_num; i++)  //恢复上一次移动位置色块的显示
						for (int j = 0; j < pCGI->col_num; j++)
							if (jieguo[i][j] > 0)
								if (jieguo[i][j] > 0) {
									gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
									jieguo[i][j] = 0;
								} 
					selected_mrow = -1;
					selected_mcol = -1;

					if (keycode2 == KB_ARROW_UP) {
						mrow = (mrow + pCGI->row_num - 1) % pCGI->row_num;
						while (shuju[mrow][mcol] == 0)
							mrow = (mrow + pCGI->row_num - 1) % pCGI->row_num;
					}
					else if (keycode2 == KB_ARROW_DOWN) {
						mrow = (mrow + 1) % pCGI->row_num;
						while (shuju[mrow][mcol] == 0) 
							mrow = (mrow + 1) % pCGI->row_num;
					}
					else if (keycode2 == KB_ARROW_LEFT) {
						mcol = (mcol + pCGI->col_num - 1) % pCGI->col_num;
						while (shuju[mrow][mcol] == 0) 
							mcol = (mcol + pCGI->col_num - 1) % pCGI->col_num;
					}
					else if (keycode2 == KB_ARROW_RIGHT) {
						mcol = (mcol + 1) % pCGI->col_num;
						while (shuju[mrow][mcol] == 0) 
							mcol = (mcol + 1) % pCGI->col_num;
					}
					gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_selected);

					//下状态栏提示
					sprintf(status_line, "[当前键盘]%c行%d列", 'A' + mrow, mcol);
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);

					old_mrow = mrow;
					old_mcol = mcol;

					break;
				}
				else if (maction == MOUSE_RIGHT_BUTTON_CLICK) {  //鼠标右键单击
					tuichu = true;
					return;
				}
			}
			else if (ret == CCT_MOUSE_EVENT) {
				if (maction == MOUSE_LEFT_BUTTON_CLICK) {  //鼠标左键单击
					return;
				}
				else if (maction == MOUSE_ONLY_MOVED) {  //鼠标移动
					for (int i = 0; i < pCGI->row_num; i++) 
						for (int j = 0; j < pCGI->col_num; j++)
							if (jieguo[i][j] > 0) {
								gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
								jieguo[i][j] = 0;
							}
					selected_mrow = -1;
					selected_mcol = -1;

					//下状态栏提示
					sprintf(status_line, "[当前鼠标]%c行%d列", 'A' + mrow, mcol);
					gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line);

					old_mrow = mrow;
					old_mcol = mcol;
					break;
				}
				else if (maction == MOUSE_RIGHT_BUTTON_CLICK) {  //鼠标右键单击
					tuichu = true;
					return;
				}
			}
		}
	}
}

bool chazhao_jieguo(int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10])
{
	int count = 0;

	//每次重置结果数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			jieguo[i][j] = 0;
		}
	}

	//查找并存入结果数组
	find(find_hang, find_lie, find_hang, find_lie, hang, lie, shuju, jieguo);

	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			count += jieguo[i][j];
		}
	}

	return count > 1;
}

void find(int x, int y, int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10])
{
	// 判断当前坐标是否在边界内
	if (x < 0 || x >= hang || y < 0 || y >= lie) {
		return;
	}
	//cout << "fuck1" << endl;

	// 判断当前点是否已经被访问过或数字不匹配
	if (jieguo[x][y] != 0 || shuju[x][y] != shuju[find_hang][find_lie]) {
		return;
	}
	//cout << "fuck2" << endl;

	// 记录当前点
	jieguo[x][y] = 1;
	//cout << "fuck3" << endl;

	// 递归搜索四个方向
	find(x + 1, y, find_hang, find_lie, hang, lie, shuju, jieguo); // 下
	find(x - 1, y, find_hang, find_lie, hang, lie, shuju, jieguo); // 上
	find(x, y + 1, find_hang, find_lie, hang, lie, shuju, jieguo); // 右
	find(x, y - 1, find_hang, find_lie, hang, lie, shuju, jieguo); // 左
}