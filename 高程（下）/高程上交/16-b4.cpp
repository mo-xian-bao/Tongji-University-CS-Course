/* 2351520 毛星博 计拔 */
#include <iostream>
#include "16-b4.h"
using namespace std;

/* 给出 Date 类的所有成员函数的体外实现 */
Date::Date()
{
	year = 2000;
	month = 1;
	day = 1;
}

Date::Date(int y, int m, int d)
{
	convert_ValidDate(y, m, d);
	year = y;
	month = m;
	day = d;
}

void Date::set(int y, int m, int d)
{
	if (y == 0) {
		y = year;
	}
	if (m == 0) {
		m = month;
	}
	if (d == 0) {
		d = day;
	}
	convert_ValidDate(y, m, d);
	year = y;
	month = m;
	day = d;
}

void Date::get(int& y, int& m, int& d) const
{
	y = year;
	m = month;
	d = day;
}

void Date::show() const
{
	cout<<year<<"年"<<month<<"月"<<day<<"日"<<endl;
}

Date::Date(const int d)
{
	int days = d;

	if (days < 1) {
		year = 1900;
		month = 1;
		day = 1;
	}
	else if (days > 73049) {
	    year = 2099;
	    month = 12;
	    day = 31;
	}
	else {
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
}

Date::operator int() const
{
	int days = 0;

	for (int i = 1900; i < year; i++) {
		days += days_of_year(i);
	}
	for (int i = 1; i < month; i++) {
		days += days_of_month(year, i);
	}
	days += day;
	return days;
}

Date Date::operator+(int days) const
{
	int d = *this;
	d += days;
	Date new_date(d);
	return new_date;
}

Date Date::operator-(int days) const
{
	int d = *this;
	d -= days;
	Date new_date(d);
	return new_date;
}

int Date::operator-(const Date& d) const
{
	int d1 = *this;
	int d2 = d;
	int days = d1 - d2;
	return days;
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

/* 如果有需要的其它全局函数的实现，可以写于此处 */
void convert_ValidDate(int& y, int& m, int& d)
{
	if (y < 1900 || y>2099) {
		y = 2000;
	}
	if (m < 1 || m > 12) {
		m = 1;
	}
	switch (m) {
	case 2:
		if (y % 4 == 0 || (y % 100 != 0 && y % 400 == 0)) {
			if (d < 1 || d > 29) {
				d = 1;
			}
		}
		else {
			if (d < 1 || d > 28) {
				d = 1;
			}
		}
		break;
	case 4:
	case 6:
	case 9:
	case 11:
		if (d < 1 || d > 30) {
			d = 1;
		}
		break;
	case 1:
	case 3:
	case 5:
	case 7:
	case 8:
	case 10:
	case 12:
		if (d < 1 || d > 31) {
			d = 1;
		}
		break;
	}
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
		if (y % 400 == 0 || (y % 100 != 0 && y % 4 == 0)) {
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

Date operator +(const int days1, const Date& date)
{
	int days2 = date;
	int days = days1 + days2;
	Date new_date(days);
	return new_date;
}

ostream& operator <<(ostream& out, const Date& date)
{
	date.show();
	return out;
}

istream& operator >>(istream& in, Date& date)
{
	int y, m, d;
	in >> y >> m >> d;
	date.set(y, m, d);
	return in;
}