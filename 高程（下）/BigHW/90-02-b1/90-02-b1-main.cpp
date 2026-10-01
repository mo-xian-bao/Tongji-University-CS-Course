/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-02-b1.h"
using namespace std;

int main()
{
	char choice;

	char star_menu[][100] = {
	 "A.命令行找出可消除项并标识",
	 "B.命令行完成一次消除（分步骤显示）",
	 "C.命令行完成一关（分步骤显示）",
	 "D.伪图形界面下用鼠标选择一个色块（无分隔线）",
	 "E.伪图形界面下用鼠标选择一个色块（有分隔线）",
	 "F.伪图形界面完成一次消除（分步骤）",
	 "G.伪图形界面完整版",
	 "Q.退出",
	 NULL
	};
	while (1) {

		/* demo中首先执行此句，将cmd窗口设置为40行x120列（缓冲区宽度120列，行数9000行，即cmd窗口右侧带有垂直滚动杆）*/
		cct_setfontsize("新宋体", 16);
		cct_setconsoleborder(120, 40, 120, 9000);

		choice = all_menu(2, star_menu);

		if (choice == 'Q'||choice=='q') {
			break;
		}
		else if (choice == 'A' || choice == 'a') {
			choice_A();
		}
		else if (choice == 'B' || choice == 'b') {
			choice_B();
		}
		else if (choice == 'C' || choice == 'c') {
			choice_C();
		}
		else if (choice == 'D' || choice == 'd') {
			choice_D();
		}
		else if (choice == 'E' || choice == 'e') {
			choice_E();
		}
		else if (choice == 'F' || choice == 'f') {
			choice_F();
		}
		else if (choice == 'G' || choice == 'g') {
			choice_G();
		}
	}
	return 0;
}
