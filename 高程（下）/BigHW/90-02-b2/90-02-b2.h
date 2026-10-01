/* 2351520 ¼Æ°Î Ã«ÐÇ²© */
#pragma once

#include "../include/cmd_gmw_tools.h"

#define BOUNDARY 1

void initalize_board(int board[12][12], int row, int col);
void random_create_num_and_block(const CONSOLE_GRAPHICS_INFO* const pCGI, int board[12][12], int row, int col, const BLOCK_DISPLAY_INFO* const bdi);
bool gameover_judge(int board[12][12], int row, int col);
bool move_block(const CONSOLE_GRAPHICS_INFO* const pCGI, int board[12][12], int row, int col, const BLOCK_DISPLAY_INFO* const bdi, int direction,int& score);
void input_row_col_seprator(int& row, int& col, bool& is_seprator);