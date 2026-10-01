/* 2351520 计拔 毛星博 */
#pragma once

#include "../include/cmd_gmw_tools.h"

bool can_disappear(int shuju[10][10], int jieguo[10][10]); //判断是否有可以消除的组，返回布尔值真或假
void panduan_to_jieguo(int panduan[][4], int jieguo[10][10]);
void draw_magicball_normal(const CONSOLE_GRAPHICS_INFO* const pCGI, int board[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal);
void draw_magicball_selected(const CONSOLE_GRAPHICS_INFO* const pCGI, int jieguo[10][10], int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_selected, const BLOCK_DISPLAY_INFO* const bdi_normal);
void draw_magicball_exploded(const CONSOLE_GRAPHICS_INFO* const pCGI, int jieguo[10][10], int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal, const BLOCK_DISPLAY_INFO* const bdi_exploded, int& score);
void move_magicball(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal);
void generate_magicball(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_normal);
void hint(int hang, int lie, int shuju[10][10], int tishi[144][4], int& t); //找出可交换项并存入tishi数组
void tishi_to_jieguo(int tishi[144][4], int t, int jieguo[10][10]);
void draw_magicball_prompt(const CONSOLE_GRAPHICS_INFO* const pCGI, int jieguo[10][10], int shuju[10][10], int row, int col, const BLOCK_DISPLAY_INFO* const bdi_prompt);
void magicball_mouse(const CONSOLE_GRAPHICS_INFO* const pCGI, int shuju[10][10], int tishi[144][4], int hang, int lie, int t, bool& tuichu, const BLOCK_DISPLAY_INFO* bdi_selected_highlight, const BLOCK_DISPLAY_INFO* bdi_normal, const BLOCK_DISPLAY_INFO* bdi_prompt);
