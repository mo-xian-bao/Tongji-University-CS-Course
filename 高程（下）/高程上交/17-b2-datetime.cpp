/* 2351520 毛星博 计拔 */
#include <iostream>
#include <iomanip>
#include "17-b2-datetime.h"
#include "17-b2-date.h"
#include "17-b2-time.h"
using namespace std;

/* --- 给出DateTime类的成员函数的体外实现(含友元及其它必要的公共函数)  --- */ 
DateTime::DateTime():Date(),Time() {}

DateTime::DateTime(int year, int month, int day, int hour, int minute, int second)
{
	if (!Is_Valid_Date(year, month, day) || hour < 0 || hour>23 || minute < 0 || minute>59 || second < 0 || second>59) {
		this->set(1900, 1, 1, 0, 0, 0);
	}
	else {
		this->set(year, month, day, hour, minute, second);
	}
}

DateTime::DateTime(long long n)
{
	long long days = 0;
	long long seconds = 0;
	if (n >= 0) {
		if (n > 86399) {
			days = n/86400;
			n%=86400;
		}
		seconds = n;
	}
	else {
		if (n < 0) {
			days = n/86400-1;
			n%=86400;
		}
		seconds = n+86400;
	}
	Date d(days);
	Time t(seconds);
    int year, month, day, hour, minute, second;
    d.get(year, month, day);
    t.get(hour, minute, second);
    this->set(year, month, day, hour, minute, second);
}

DateTime::operator long long() const
{
	long long days = 0;
	long long seconds = 0;
	Date d(year, month, day);
	days = (long long)d;
	seconds = hour*3600 + minute*60 + second;
	seconds += days*86400;
	return seconds;
}

DateTime::operator long int() const
{
	long int days = 0;
	long int seconds = 0;
	Date d(year, month, day);
	days = (long int)d;
	seconds = hour*3600 + minute*60 + second;
	seconds += days*86400;
	return seconds;
}

void DateTime::set(int year, int month, int day, int hour, int minute, int second)
{
	if (!Is_Valid_Date(year, month, day) || hour < 0 || hour>23 || minute < 0 || minute>59 || second < 0 || second>59) {
		this->year = 1900;
		this->month = 1;
		this->day = 1;
		this->hour = 0;
		this->minute = 0;
		this->second = 0;
	}
	else {
		this->year = year;
		this->month = month;
		this->day = day;
		this->hour = hour;
		this->minute = minute;
		this->second = second;
	}
}

void DateTime::show() const
{
	cout << year << "-" << setfill('0') << setw(2) << month << "-" << setfill('0') << setw(2) << day << " ";
	cout << setfill('0') << setw(2) << hour << ":" << setfill('0') << setw(2) << minute << ":" << setfill('0') << setw(2) << second << endl;
}

void DateTime::get(int& year, int& month, int& day, int& hour, int& minute, int& second) const
{
	year = this->year;
	month = this->month;
	day = this->day;
	hour = this->hour;
	minute = this->minute;
	second = this->second;
}

DateTime DateTime::operator +(const int n) const
{
	return DateTime((long long)(*this) + (long long)n);
}

DateTime DateTime::operator+(const long long n) const
{
	return DateTime((long long)(*this) + n);
}

DateTime DateTime::operator + (const long int n) const
{
	return DateTime((long int)(*this) + n);
}

DateTime DateTime::operator-(const int n) const
{
	return DateTime((long long)(*this) - (long long)n);
}

DateTime DateTime::operator-(const long long n) const
{
	return DateTime((long long)(*this) - n);
}

DateTime DateTime::operator-(const long int n) const
{
	return DateTime((long int)(*this) - n);
}

long long DateTime::operator-(const DateTime& dt) const
{
	return (long long)(*this) - (long long)dt;
}

DateTime& DateTime::operator++()
{
	long long n = (long long)(*this) + 1;
	*this = DateTime(n);
	return *this;
}

DateTime DateTime::operator++(int)
{
	DateTime dt = *this;
	++(*this);
	return dt;
}

DateTime& DateTime::operator--()
{
	long long n = (long long)(*this) - 1;
	*this = DateTime(n);
	return *this;
}

DateTime DateTime::operator--(int)
{
	DateTime dt = *this;
	--(*this);
	return dt;
}

bool DateTime::operator<(const DateTime& dt) const
{
	return (long long)(*this) < (long long)dt;
}

bool DateTime::operator<=(const DateTime& dt) const
{
	return (long long)(*this) <= (long long)dt;
}

bool DateTime::operator>(const DateTime& dt) const
{
	return (long long)(*this) > (long long)dt;
}

bool DateTime::operator>=(const DateTime& dt) const
{
	return (long long)(*this) >= (long long)dt;
}

bool DateTime::operator==(const DateTime& dt) const
{
	return (long long)(*this) == (long long)dt;
}

bool DateTime::operator!=(const DateTime& dt) const
{
	return (long long)(*this) != (long long)dt;
}

///////////////////// 友元函数 ////////////////////
ostream& operator<<(ostream& os, const DateTime& dt)
{
	os << dt.year << "-" << setfill('0') << setw(2) << dt.month << "-" << setfill('0') << setw(2) << dt.day << " ";
	os << setfill('0') << setw(2) << dt.hour << ":" << setfill('0') << setw(2) << dt.minute << ":" << setfill('0') << setw(2) << dt.second;
	return os;
}

istream& operator>>(istream& is, DateTime& dt)
{
	int year, month, day, hour, minute, second;
	is >> year >> month >> day >> hour >> minute >> second;
	dt.set(year, month, day, hour, minute, second);
	return is;
}

DateTime operator+(const int n, const DateTime& dt)
{
	return DateTime((long long)n + (long long)dt);
}

DateTime operator+(const long long n, const DateTime& dt)
{
	return DateTime(n + (long long)dt);
}