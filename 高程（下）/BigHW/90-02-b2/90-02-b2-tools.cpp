/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <conio.h>
#include <cstring>
#include <ctime>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-02-b2.h"
#include "../include/cmd_gmw_tools.h"
#include <cmath>
using namespace std;

void initalize_board(int board[12][12],int row,int col)
{
	srand((unsigned int)(time(0)));    //随机数种子

	//初始化边界
	for (int i = 0; i < row + 2; i++) {
		board[i][0] = BOUNDARY;
		board[i][col + 1] = BOUNDARY;
	}
	for (int i = 0; i < col + 2; i++) {
		board[0][i] = BOUNDARY;
		board[row + 1][i] = BOUNDARY;
	}
	
	for (int i = 0; i < 2; i++) {    //生成2个数字
		int x = rand() % row+1;
		int y = rand() % col+1;
		while (board[x][y]!= 0) {    //判断是否有数字
			x = rand() % row+1;
			y = rand() % col+1;
		}
		board[x][y] = (rand() % 2+1) * 2;    //生成2或4
	}
}

void random_create_num_and_block(const CONSOLE_GRAPHICS_INFO* const pCGI, int board[12][12], int row, int col, const BLOCK_DISPLAY_INFO* const bdi)
{
	srand((unsigned int)(time(0)));    //随机数种子

	for (int i = 0; i < 1; i++) {    //生成1个数字
		int x = rand() % row + 1;
		int y = rand() % col + 1;
		while (board[x][y] != 0) {    //判断是否有数字
			x = rand() % row + 1;
			y = rand() % col + 1;
		}
		board[x][y] = (rand() % 2 + 1) * 2;    //生成2或4
		gmw_draw_block(pCGI, x-1, y-1, board[x][y], bdi);    //显示色块
	}
}

bool gameover_judge(int board[12][12], int row, int col)
{
	//如果有空位，则游戏未结束
	for (int i = 1; i <= row; i++) {
		for (int j = 1; j <= col; j++) {
			if (board[i][j] == 0) {
				return false;
			}
		}
	}

	//如果没有空位且没有相同相邻数字，则游戏结束
	for (int i = 1; i <= row; i++) {
		for (int j = 1; j <= col; j++) {
			if (board[i][j] != 0) {
				if (board[i-1][j] == board[i][j] || board[i+1][j] == board[i][j] || board[i][j-1] == board[i][j] || board[i][j+1] == board[i][j]) {
					return false;
				}  //经过边界的处理，这里不需要再判断边界
			}
		}
	}

	return true;
}

bool move_block(const CONSOLE_GRAPHICS_INFO* const pCGI, int board[12][12],int row, int col, const BLOCK_DISPLAY_INFO* const bdi, int direction,int &score)
{
	bool is_move = false;
	int mark[12][12] = { 0 };    //标记是否已经移动过的位置

	if (direction == 0) {    //向上移动(需要合成相同数字),如果没有可移动的位置，则返回false
		int is_moved[12] = {0};
		for (int i = 1; i <= col; i++) {
			for (int j = 1; j <= row; j++) {
				if (board[j][i]) {
					int num = board[j][i];
					int len = 0;
					while (!board[j - len - 1][i]) {  //上一格为空
						board[j - len - 1][i] = board[j - len][i];
						board[j - len][i] = 0;
						len++;
						is_moved[i]++;
					}
					bool is_merge = (board[j - len - 1][i] == board[j - len][i] && mark[j - len - 1][i] == 0);
					if (is_merge) {
						board[j - len - 1][i] *= 2;
						mark[j - len - 1][i] = 1;
						board[j - len][i] = 0;
						len++;
						is_moved[i]++;
					}
					gmw_move_block(pCGI, j - 1, i - 1, num, BDI_VALUE_BLANK, bdi, DOWN_TO_UP, len);
					if (is_merge) {
						gmw_draw_block(pCGI, j - len - 1, i - 1, 2 * num, bdi);
						score += 2 * num;
					}
				}
			}
		}
		for (int i = 1; i <= col; i++) {
			if (is_moved[i] > 0) {
				is_move = true;
				break;
			}
		}
		if (!is_move) {
			return false;
		}
	}
	else if (direction == 1) {    //向下移动(需要合成相同数字),如果没有可移动的位置，则返回false
		int is_moved[12] = { 0 };
		for (int i = 1; i <= col; i++) {
			for (int j = row; j >= 1; j--) {
				if (board[j][i]) {
					int num = board[j][i];
					int len = 0;
					while (!board[j + len + 1][i]) {  //下一格为空
						board[j + len + 1][i] = board[j + len][i];
						board[j + len][i] = 0;
						len++;
						is_moved[i]++;
					}
					bool is_merge = (board[j + len + 1][i] == board[j + len][i] && mark[j + len + 1][i] == 0);
					if (is_merge) {
						board[j + len + 1][i] *= 2;
						mark[j + len + 1][i] = 1;
						board[j + len][i] = 0;
						len++;
						is_moved[i]++;
					}
					gmw_move_block(pCGI, j - 1, i - 1, num, BDI_VALUE_BLANK, bdi, UP_TO_DOWN, len);
					if (is_merge) {
						gmw_draw_block(pCGI, j + len - 1, i - 1, 2 * num, bdi);
						score += 2 * num;
					}
				}
			}
		}
		for (int i = 1; i <= col; i++) {
			if (is_moved[i] > 0) {
				is_move = true;
				break;
			}
		}
		if (!is_move) {
			return false;
		}
	}
	else if (direction == 2) {    //向左移动(需要合成相同数字),如果没有可移动的位置，则返回false
		int is_moved[12] = { 0 };
		for (int i = 1; i <= row; i++)
			for (int j = 1; j <= col; j++)
				if (board[i][j]) {
					int num = board[i][j];
					int len = 0;
					while (!board[i][j - len - 1]) {
						board[i][j - len - 1] = board[i][j - len];
						board[i][j - len] = 0;
						len++;
						is_moved[i]++;
					}
					bool is_merge = (board[i][j - len - 1] == board[i][j - len] && mark[i][j - len - 1] == 0);
					if (is_merge) {
						board[i][j - len - 1] *= 2;
						mark[i][j - len - 1] = 1;
						board[i][j - len] = 0;
						len++;
						is_moved[i]++;
					}
					gmw_move_block(pCGI, i - 1, j - 1, num, BDI_VALUE_BLANK, bdi, RIGHT_TO_LEFT, len);
					if (is_merge) {
						gmw_draw_block(pCGI, i - 1, j - len - 1, 2 * num, bdi);
						score += 2 * num;
					}
				}
		for (int i = 1; i <= row; i++) {
			if (is_moved[i] > 0) {
				is_move = true;
				break;
			}
		}
		if (!is_move) {
			return false;
		}
	}
	else if (direction == 3) {    //向右移动(需要合成相同数字),如果没有可移动的位置，则返回false
		int is_moved[12] = { 0 };
		for (int i = 1; i <= row; i++)
			for (int j = col; j >= 1; j--)
				if (board[i][j]) {
					int num = board[i][j];
					int len = 0;
					while (!board[i][j + len + 1]) {
						board[i][j + len + 1] = board[i][j + len];
						board[i][j + len] = 0;
						len++;
						is_moved[i]++;
					}
					bool is_merge = (board[i][j + len + 1] == board[i][j + len] && mark[i][j + len + 1] == 0);
					if (is_merge) {
						board[i][j + len + 1] *= 2;
						mark[i][j + len + 1] = 1;
						board[i][j + len] = 0;
						len++;
						is_moved[i]++;
					}
					gmw_move_block(pCGI, i - 1, j - 1, num, BDI_VALUE_BLANK, bdi, LEFT_TO_RIGHT, len);
					if (is_merge) {
						gmw_draw_block(pCGI, i - 1, j + len - 1, 2 * num, bdi);
						score += 2 * num;
					}
				}
		for (int i = 1; i <= row; i++) {
			if (is_moved[i] > 0) {
				is_move = true;
				break;
			}
		}
		if (!is_move) {
			return false;
		}
	}
	return true;
}

void input_row_col_seprator(int& row, int& col,bool& is_seprator)
{
	char c;
	int a;
	
	while (6) {
		cout << "请输入行数(" << 4 << "-" << 10 << ")：" << endl;
		cin >> row;
		if (cin.fail() || (row > 10 || row < 4)) {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
		}
		else {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
			break;
		}
	}
	while (6) {
		cout << "请输入列数(" << 4 << "-" << 10 << ")：" << endl;
		cin >> col;
		if (cin.fail() || (col > 10 || col < 4)) {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
		}
		else {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
			break;
		}
	}
	while (6) {
		cout << "是否需要分隔线(1:是 0:否)：" << endl;
		cin >> a;
		if (cin.fail() || (a != 0 && a != 1)) {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
		}
		else {
			cin.clear();
			while ((c = cin.get()) != '\n' && c != EOF);
			is_seprator = (a == 1);
			break;
		}
	}
}