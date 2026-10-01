/* 2351520 毛星博 计拔 */
#pragma once

#include <iostream>
using namespace std;

/* 如果有其它全局函数需要声明，写于此处 */
bool Is_Valid_Date(int year, int month, int day);
int days_of_year(int y);
int days_of_month(int y, int m);

/* Date类的声明 */ 
class Date {
protected:
	/* 除这三个以外，不允许再定义任何数据成员 */ 
	int year;
	int month;
	int day;
public:
	/* 允许需要的成员函数及友元函数的声明 */
	Date();
	Date(int y, int m, int d);
	void show() const;
	void set(int y = 1900, int m = 1, int d = 1);
	void get(int& y, int& m, int& d) const;
	Date(const int d);  // 转换构造函数
	Date(const long long d);
	operator int() const;  // 转换为整型数值
	operator long long() const;
	operator long int() const;

	Date operator+(int n) const;
	Date operator-(int n) const;
	int operator-(const Date& date) const;

	Date& operator++();  // 前置自增运算符
	Date operator++(int);  // 后置自增运算符
	Date& operator--();  // 前置自减运算符
	Date operator--(int);  // 后置自减运算符

	bool operator==(const Date& date) const;
	bool operator!=(const Date& date) const;
	bool operator<(const Date& date) const;
	bool operator<=(const Date& date) const;
	bool operator>(const Date& date) const;
	bool operator>=(const Date& date) const;

	/* 允许加入友元声明（如果有必要） */
	friend ostream& operator<<(ostream& out, const Date& d);
	friend istream& operator>>(istream& in, Date& d);
	friend Date operator +(const int days, const Date& date);
};
