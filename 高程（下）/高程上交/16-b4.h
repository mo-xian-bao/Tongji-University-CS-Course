/* 2351520 毛星博 计拔 */

#pragma once

#include <iostream>
using namespace std;

/* 如果有其它全局函数需要声明，写于此处 */
void convert_ValidDate(int& y, int& m, int& d);
int days_of_year(int y);
int days_of_month(int y, int m);

/* 如果有需要的宏定义、只读全局变量等，写于此处 */


/* 补全Date类的定义，所有成员函数均体外实现，不要在此处体内实现 */
class Date {
private:
	int year;
	int month;
	int day;
	/* 不允许添加数据成员 */
public:
	/* 根据需要定义所需的成员函数、友元函数等(不允许添加数据成员) */

	Date();   // 默认构造函数
	Date(int y, int m, int d);  // 构造函数

	void set(int y = 2000, int m = 1, int d = 1);  // 设置日期
	void get(int& y, int& m, int& d) const;  // 获取日期
	void show() const;  // 显示日期

	Date(const int d);   // 转换构造函数
	operator int() const;  // 类型转换函数

	Date operator+(int n) const;
	Date operator-(int n) const;
	int operator-(const Date& date) const;
	friend Date operator +(const int days1, const Date& date);

	Date& operator++();  // 前置自增运算符
	Date operator++(int);  // 后置自增运算符
	Date& operator--();  // 前置自减运算符
	Date operator--(int);  // 后置自减运算符

	friend ostream& operator<<(ostream& out, const Date& date);  // 重载输出运算符
	friend istream& operator>>(istream& in, Date& date);  // 重载输入运算符

	bool operator==(const Date& date) const;
	bool operator!=(const Date& date) const;
	bool operator<(const Date& date) const;
	bool operator<=(const Date& date) const;
	bool operator>(const Date& date) const;
	bool operator>=(const Date& date) const;
};

