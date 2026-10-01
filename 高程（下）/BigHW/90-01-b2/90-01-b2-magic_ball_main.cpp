/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-01-b2-magic_ball.h"
using namespace std;

int main()
{
	cct_setcolor();
	cct_cls();
	char choice;

	char magicball_menu[][100] = {
	 " 1.内部数组，生成初始状态，寻找是否有初始可消除项",
	 " 2.内部数组，消除初始可消除项后非0项下落并用0填充",
	 " 3.内部数组，消除初始可消除项后查找消除提示",
	 " 4.n*n的框架(无分隔线)，显示初始状态",
	 " 5.n*n的框架(有分隔线)，显示初始状态",
	 " 6.n*n的框架(无分隔线)，显示初始状态及初始可消除项",
	 " 7.n*n的框架(有分隔线)，消除初始可消除项后显示消除提示",
	 " 8.cmd图形界面完整版(有分隔线，鼠标移动时显示坐标，右键退出)",
	 " 9.cmd图形界面完整版",
	 " 0.退出",
	 NULL
	};

	while (1) {

		/* demo中首先执行此句，将cmd窗口设置为40行x120列（缓冲区宽度120列，行数9000行，即cmd窗口右侧带有垂直滚动杆）*/
		cct_setfontsize("新宋体", 16);
		cct_setconsoleborder(120, 40, 120, 9000);

		choice =all_menu(1,magicball_menu);

		if (choice == '0') {
			break;
		}
		else if (choice == '1') {
			choice_1();
		}
		else if (choice == '2') {
			choice_2();
		}
		else if (choice == '3') {
			choice_3();
		}
		else if (choice == '4') {
			choice_4();
		}
		else if (choice == '5') {
			choice_5();
		}
		else if (choice == '6') {
			choice_6();
		}
		else if (choice == '7') {
			choice_7();
		}
		else if (choice == '8') {
			choice_8();
		}
		else if (choice == '9') {
			choice_9();
		}

		cct_cls();
	}


	return 0;
}