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

void draw_magicball_normal(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal)
{
    for (int i = 0; i < row; i++)
        for (int j = 0; j < col; j++) {
            gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
        }
}

void draw_magicball_prompt(const CONSOLE_GRAPHICS_INFO* const pCGI,int jieguo[10][10], int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_prompt)
{
    for (int i = 0; i < row; i++)
        for (int j = 0; j < col; j++) {
            if (jieguo[i][j] != 0)
                gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_prompt);
        }
}

void draw_magicball_selected(const CONSOLE_GRAPHICS_INFO* const pCGI, int jieguo[10][10],int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_selected, const BLOCK_DISPLAY_INFO* const bdi_normal)
{
    for (int i = 0; i < row; i++)
        for (int j = 0; j < col; j++) {
            if (jieguo[i][j] != 0)
                gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_selected);
            else
                gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
        }
}

void draw_magicball_exploded(const CONSOLE_GRAPHICS_INFO* const pCGI, int jieguo[10][10], int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal, const BLOCK_DISPLAY_INFO* const bdi_exploded,int& score)
{
    for (int k = 0; k < 5; k++) {
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                if (jieguo[i][j] != 0) {
                    gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_exploded);
                }
            }
        }
        Sleep(50);
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                if (jieguo[i][j] != 0) {
                    gmw_draw_block(pCGI, i, j, 0, bdi_normal);
                }
            }
        }
        Sleep(50);
    }
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            if (jieguo[i][j] != 0)
                shuju[i][j] = 0;
        }
    }
    //累计分数
    for (int i = 0; i < row; i++) { 
        for (int j = 0; j < col; j++) {
            if (shuju[i][j] == 0) {
                score++;
            }
        }
    }
}

void move_magicball(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal) //默认向下移动
{
    int distance;
    for (int i = 0; i < col; i++) {  //遍历列
        for (int j = row-1; j >= 0; j--) {  //遍历行
            if (shuju[j][i] != 0) {  //如果该位置有数字
                distance = 0;
                for (int k = j + 1; k < row; k++) { 
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
}

void generate_magicball(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal)
{
    srand((unsigned int)time(0));   //随机数种子
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            if (shuju[i][j] == 0) {
                shuju[i][j] = rand() % 9 + 1;  //生成1-10之间的随机数
                gmw_draw_block(pCGI, i, j, shuju[i][j], bdi_normal);
                Sleep(100);
            }
        }
    }
}

void magicball_mouse(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int tishi[144][4], int hang, int lie, int t, bool& tuichu,const BLOCK_DISPLAY_INFO* bdi_selected_highlight, const BLOCK_DISPLAY_INFO* bdi_normal, const BLOCK_DISPLAY_INFO* bdi_prompt)
{
    int maction, mrow, mcol;
    int old_mrow=-1, old_mcol=-1; //记录选中的位置
    int keycode1, keycode2;
    int ret;
    int m; //处理交换
    char status_line[100]= { 0 }; //用于状态栏显示

    while (true) {
        ret = gmw_read_keyboard_and_mouse(pCGI, maction, mrow, mcol, keycode1, keycode2);
        if (ret == CCT_MOUSE_EVENT) {
            if (maction == MOUSE_LEFT_BUTTON_CLICK) {  //左键单击
                bool flag = false;
                for (int i = 0; i < t; i++) {
                    if (tishi[i][0] == mrow && tishi[i][1] == mcol || tishi[i][2] == mrow && tishi[i][3] == mcol) {  //选中可交换项
                        flag = true;
                    }
                }
                if (flag) {  //选中可交换项
                    if (old_mrow != -1 && old_mcol != -1) {  //之前有选中项
                        if (mrow == old_mrow && mcol == old_mcol) {  //若两次选中的项相同
                            gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_prompt);
                            old_mrow = -1;
                            old_mcol = -1;
                        }
                        else {
                            //若两次选中的可以交换
                            for (int i = 0; i < t; i++) {
                                if (tishi[i][0] == old_mrow && tishi[i][1] == old_mcol && tishi[i][2] == mrow && tishi[i][3] == mcol || tishi[i][0] == mrow && tishi[i][1] == mcol && tishi[i][2] == old_mrow && tishi[i][3] == old_mcol) {
                                    gmw_draw_block(pCGI, old_mrow, old_mcol, shuju[mrow][mcol], bdi_normal);
                                    gmw_draw_block(pCGI, mrow, mcol, shuju[old_mrow][old_mcol], bdi_normal);
                                    m = shuju[old_mrow][old_mcol];
                                    shuju[old_mrow][old_mcol] = shuju[mrow][mcol];
                                    shuju[mrow][mcol] = m;
                                    return;
                                }
                            }
                            //若两次选中的项不能交换
                            gmw_draw_block(pCGI, old_mrow, old_mcol, shuju[old_mrow][old_mcol], bdi_prompt);
                            gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_selected_highlight);
                            old_mrow = mrow;
                            old_mcol = mcol;
                            continue;
                        }
                    }
                    else {  //之前无选中项
                        old_mrow = mrow;
                        old_mcol = mcol;
                        gmw_draw_block(pCGI, mrow, mcol, shuju[mrow][mcol], bdi_selected_highlight);
                    }
                }
                else {  //未选中可交换项
                    sprintf(status_line, "%c行%d列", mrow + 'A', mcol);
                    gmw_status_line(pCGI, LOWER_STATUS_LINE, status_line, " 不能选择  ");
                }
            }
            else if (maction == MOUSE_RIGHT_BUTTON_CLICK) {  //右键单击
                tuichu = true;
                return;
            }
        }
    }
}

bool can_disappear(int shuju[10][10], int jieguo[10][10]) //判断是否有可以消除的组，返回布尔值真或假
{
    bool flag = false;
    int h = 0;
    int panduan[100][4] = { 0 };

    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (shuju[i][j] != 0) {
                panduan[h][2] = 1;
                for (int k = 1; i + k < 9 && shuju[i + k][j] == shuju[i][j]; k++)
                    panduan[h][2]++;
                if (panduan[h][2] >= 3) {
                    panduan[h][3] = 2;
                    panduan[h][0] = i;
                    panduan[h][1] = j;
                    flag = true;
                    h++;
                }
            }
            if (shuju[i][j] != 0) {
                panduan[h][2] = 1;
                for (int k = 1; j + k < 9 && shuju[i][j + k] == shuju[i][j]; k++)
                    panduan[h][2]++;
                if (panduan[h][2] >= 3) {
                    panduan[h][3] = 1;
                    panduan[h][0] = i;
                    panduan[h][1] = j;
                    flag = true;
                    h++;
                }
            }
        }
    }

    panduan_to_jieguo(panduan, jieguo);

    return flag;
}

void panduan_to_jieguo(int panduan[][4], int jieguo[10][10])
{
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            jieguo[i][j] = 0;
        }
    }

    for (int h = 0; panduan[h][2] > 2; h++) {
        if (panduan[h][3] == 1) {
            for (int i = 0; i < panduan[h][2]; i++) {
                jieguo[panduan[h][0]][panduan[h][1] + i] = 1;
            }
        }
        else if (panduan[h][3] == 2) {
            for (int i = 0; i < panduan[h][2]; i++) {
                jieguo[panduan[h][0] + i][panduan[h][1]] = 1;
            }
        }
    }
}

void hint(int hang, int lie, int shuju[10][10], int tishi[144][4], int& t) //找出可交换项并存入jieguo数组
{
    int shuju_virtual[10][10] = { 0 };
    int jieguo_virtual[10][10] = { 0 };
    int exchange;

    //每次置零提示数组
    t = 0;
    for (int i = 0; i < 144; i++) {
        for (int j = 0; j < 4; j++) {
            tishi[i][j] = 0;
        }
    }

    for (int i = 0; i < hang; i++) { //模拟横向交换
        for (int j = 0; j < lie - 1; j++) {
            for (int i0 = 0; i0 < hang; i0++) {
                for (int j0 = 0; j0 < lie; j0++) {
                    shuju_virtual[i0][j0] = shuju[i0][j0];
                }
            }
            exchange = shuju_virtual[i][j];
            shuju_virtual[i][j] = shuju_virtual[i][j + 1];
            shuju_virtual[i][j + 1] = exchange;
            if (can_disappear(shuju_virtual, jieguo_virtual)) {
                tishi[t][0] = i;
                tishi[t][1] = j;
                tishi[t][2] = i;
                tishi[t][3] = j + 1;
                t++;
            }
        }
    }
    for (int i = 0; i < hang - 1; i++) { //模拟纵向交换
        for (int j = 0; j < lie; j++) {
            for (int i0 = 0; i0 < hang; i0++) {
                for (int j0 = 0; j0 < lie; j0++) {
                    shuju_virtual[i0][j0] = shuju[i0][j0];
                }
            }
            exchange = shuju_virtual[i][j];
            shuju_virtual[i][j] = shuju_virtual[i + 1][j];
            shuju_virtual[i + 1][j] = exchange;
            if (can_disappear(shuju_virtual, jieguo_virtual)) {
                tishi[t][0] = i;
                tishi[t][1] = j;
                tishi[t][2] = i + 1;
                tishi[t][3] = j;
                t++;
            }
        }
    }
}

void tishi_to_jieguo(int tishi[144][4], int t, int jieguo[10][10])
{
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            jieguo[i][j] = 0;
        }
    }

    for (int t0 = 0; t0 < t; t0++) {
        jieguo[tishi[t0][0]][tishi[t0][1]] = 1;
        jieguo[tishi[t0][2]][tishi[t0][3]] = 1;
    }
}