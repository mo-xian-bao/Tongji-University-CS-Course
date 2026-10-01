/* 2351520 毛星博 计拔 */
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
	DateTime();
	DateTime(int year, int month, int day, int hour, int minute, int second);
	DateTime(long long n);
	operator long long() const;
	operator long int() const;

	void show() const;
	void set(int year=1900, int month=1, int day=1, int hour=0, int minute=0, int second=0);
	void get(int& year, int& month, int& day, int& hour, int& minute, int& second) const;

	DateTime operator+(const int n) const;
	DateTime operator+(const long long n) const;
	DateTime operator+(const long int n) const;
	DateTime operator-(const int n) const;
	DateTime operator-(const long long n) const;
	DateTime operator-(const long int n) const;
	long long operator-(const DateTime& dt) const;

	DateTime& operator ++();
	DateTime operator ++(int); 
	DateTime& operator --();
	DateTime operator --(int);

	bool operator==(const DateTime& dt) const;
	bool operator!=(const DateTime& dt) const;
	bool operator<(const DateTime& dt) const;
	bool operator<=(const DateTime& dt) const;
	bool operator>(const DateTime& dt) const;
	bool operator>=(const DateTime& dt) const;
	
	/* 允许加入友元声明（如果有必要） */
	friend ostream& operator<<(ostream& os, const DateTime& dt);
	friend istream& operator>>(istream& is, DateTime& dt);
	friend DateTime operator+(const int n, const DateTime& dt);
	friend DateTime operator+(const long long n, const DateTime& dt);
};
