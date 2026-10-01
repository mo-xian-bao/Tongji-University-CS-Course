/* 学号 姓名 班级 */
#pragma once

#include "17-b2-date.h"
#include "17-b2-time.h"

/* 如果有其它全局函数需要声明，写于此处 */

/* DateTime类的基本要求：
	1、不允许定义任何数据成员
	2、尽量少定义成员函数 
*/

class DateTime:public Date, public Time {
protected:
	/* 不允许再定义任何数据成员 */ 

public:
	/* 不允许再定义任何数据成员，允许需要的成员函数及友元函数的声明 */
	
	/* 允许加入友元声明（如果有必要） */

};
