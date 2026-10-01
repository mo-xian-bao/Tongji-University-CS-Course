/* 2351520 计拔 毛星博 */
#pragma once

/* ------------------------------------------------------------------------------------------------------

     本文件功能：
	1、为了保证 hanoi_main.cpp/hanoi_menu.cpp/hanoi_multiple_solutions.cpp 能相互访问函数的函数声明
	2、一个以上的cpp中用到的宏定义（#define）或全局只读（const）变量，个数不限
	3、可以参考 cmd_console_tools.h 的写法（认真阅读并体会）
   ------------------------------------------------------------------------------------------------------ */

//int hanoi_menu(void);
void choice_1();
void shuchu(int n, char src, char tmp, char dst, int flag);
void choice_2();
void choice_3();
void shuru(int* cengshu, char* qishi, char* zhongjian, char* mubiao, int choice);
void choice_4();
void choice_5();
void choice_6();
void choice_7();
void choice_8();
void choice_9();
void move_panzi(char, char);