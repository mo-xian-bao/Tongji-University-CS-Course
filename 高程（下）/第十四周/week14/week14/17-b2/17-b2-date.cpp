/* 2351520 毛星博 计拔 */
#include <iostream>
#include <iomanip>
#include "17-b2-date.h"
using namespace std;

/* --- 给出Date类的成员函数的体外实现(含友元及其它必要的公共函数)  --- */ 

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
Date::Date()
{
	year = 1900;
	month = 1;
	day = 1;
}

Date::Date(int y, int m, int d)
{
	if (Is_Valid_Date(y, m, d)) {
		year = y;
		month = m;
		day = d;
	}
	else {
		year = 1900;
		month = 1;
		day = 1;
	}
}

void Date::show() const
{
	cout<<year<<"-"<<setw(2)<<setfill ('0') << month << "-" << setw(2) << setfill('0') << day << endl;
}

void Date::set(int y, int m, int d)
{
	if (Is_Valid_Date(y, m, d)) {
		year = y;
		month = m;
		day = d;
	}
	else {
		year = 1900;
		month = 1;
		day = 1;
	}
}

void Date::get(int& y, int& m, int& d) const
{
	y = year;
	m = month;
	d = day;
}


Date::Date(const int days0)
{
	int days = days0;
	while (days < 0) {
		days += 73049;
	}
	if (days > 73048) {
		days %= 73049;
	}

	days+=1;
	int y = 1900, m = 1;

	while (days > days_of_year(y)) {
		days -= days_of_year(y);
		y++;
	}
	while (days > days_of_month(y, m)) {
		days -= days_of_month(y, m);
		m++;
	}
	year = y;
	month = m;
	day = days;
}

Date::Date(const long long days0)
{
	long long days = days0;
	while (days < 0) {
		days += 73049;
	}
	if (days > 73048) {
		days %= 73049;
	}

	days+=1;
	int y = 1900, m = 1;

	while (days > days_of_year(y)) {
		days -= days_of_year(y);
		y++;
	}
	while (days > days_of_month(y, m)) {
		days -= days_of_month(y, m);
		m++;
	}
	year = y;
	month = m;
	day = (int)days;
}

Date:: operator int() const
{
	int days = 0;

	for (int i = 1900; i < year; i++) {
		days += days_of_year(i);
	}
	for (int i = 1; i < month; i++) {
		days += days_of_month(year, i);
	}
	days += day-1;
	return days;
}

Date:: operator long long() const
{
	long long days = 0;

	for (int i = 1900; i < year; i++) {
		days += days_of_year(i);
	}
	for (int i = 1; i < month; i++) {
		days += days_of_month(year, i);
	}
	days += day-1;
	return days;
}

Date:: operator long int() const
{
	long int days = 0;

	for (int i = 1900; i < year; i++) {
		days += days_of_year(i);
	}
	for (int i = 1; i < month; i++) {
		days += days_of_month(year, i);
	}
	days += day-1;
	return days;
}

Date Date::operator+(int n) const
{
	return Date(int(*this) + n);
}

Date Date::operator-(int n) const
{
	return Date(int(*this) - n);
}

int Date::operator-(const Date& date) const
{
	return int(*this) - int(date);
}

Date& Date::operator++()
{
	int d = *this;
	d++;
	*this = d;
	return *this;
}

Date Date::operator++(int)
{
	Date old_date = *this;
	int d = *this;
	d++;
	*this = d;
	return old_date;
}

Date& Date::operator--()
{
	int d = *this;
	d--;
	*this = d;
	return *this;
}

Date Date::operator--(int)
{
	Date old_date = *this;
	int d = *this;
	d--;
	*this = d;
	return old_date;
}

bool Date::operator ==(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 == d2) {
		return true;
	}
	else {
		return false;
	}
}

bool Date::operator!=(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 != d2) {
		return true;
	}
	else {
		return false;
	}
}

bool Date::operator <(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 < d2) {
		return true;
	}
	else {
		return false;
	}
}

bool Date::operator >(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 > d2) {
		return true;
	}
	else {
		return false;
	}
}

bool Date::operator <=(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 <= d2) {
		return true;
	}
	else {
		return false;
	}
}

bool Date::operator >=(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	if (d1 >= d2) {
		return true;
	}
	else {
		return false;
	}
}

/***************************************************************************
  函数名称：友元函数及其它必要的公共函数
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
bool Is_Valid_Date(int year, int month, int day)
{
	if (year < 1900 || year>2099 || month < 1 || month>12 || day < 1 || day>31) {
		return false;
	}
	switch (month) {
	case 2:
		if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
			if (day < 1 || day>29) {
				return false;
			}
		}
		else {
			if (day < 1 || day>28) {
				return false;
			}
		}
		break;
	case 4:
	case 6:
	case 9:
	case 11:
		if (day < 1 || day>30) {
			return false;
		}
		break;
	default:
		if (day < 1 || day>31) {
			return false;
		}
		break;
	}
	return true;
}

int days_of_year(int y)
{
	if ((y % 4 == 0 && y % 100 != 0) || (y % 400 == 0)) {
		return 366;
	}
	else {
		return 365;
	}
}

int days_of_month(int y, int m)
{
	switch (m) {
	case 2:
		if ((y % 400 == 0) || (y % 100 != 0 && y % 4 == 0)) {
			return 29;
		}
		else {
			return 28;
		}
	case 4:
	case 6:
	case 9:
	case 11:
		return 30;
	case 1:
	case 3:
	case 5:
	case 7:
	case 8:
	case 10:
	case 12:
		return 31;
	default:
		return -1;
	}
}

ostream& operator<<(ostream& os, const Date& d)
{
	os << d.year << "-" << setw(2) << setfill('0') << d.month << "-" << setw(2) << setfill('0') << d.day;
	return os;
}

istream& operator>>(istream& is, Date& d)
{
	int y, m, day;
	is >> y >> m >> day;
	d.set(y, m, day);
	return is;
}

Date operator +(const int days, const Date& date)
{
	return Date(days + int(date));
}

