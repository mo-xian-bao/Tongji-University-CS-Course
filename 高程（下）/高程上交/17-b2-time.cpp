/* 2351520 毛星博 计拔 */
#include <iostream>
#include <iomanip>
#include "17-b2-time.h"
using namespace std;

/* --- 给出Time类的成员函数的体外实现(含友元及其它必要的公共函数)  --- */ 
Time::Time()
{
    hour = 0;
    minute = 0;
    second = 0;
}

Time::Time(int h, int m, int s)
{
    if (h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59) {
        hour = 0;
        minute = 0;
        second = 0;
    }
    else {
        hour = h;
        minute = m;
        second = s;
    }
}

Time::Time(int seconds)
{
    if (seconds > 86399) {
        seconds%=86400;
    }
    if (seconds < 0) {
        seconds = seconds%86400 + 86400;
    }

    hour = seconds/3600;
    seconds %= 3600;
    minute = seconds/60;
    second = seconds%60;
}

Time::Time(long long seconds)
{
    if (seconds > 86399) {
        seconds%=86400;
    }
    if (seconds < 0) {
        seconds = seconds%86400 + 86400;
    }

    hour = (int)seconds/3600;
    seconds %= 3600;
    minute = (int)seconds/60;
    second = (int)seconds%60;
}

Time::operator int() const
{
    return hour*3600 + minute*60 + second;
}

void Time::show() const
{
    cout << setfill('0') << setw(2) << hour << ":";
    cout << setfill('0') << setw(2) << minute << ":";
    cout << setfill('0') << setw(2) << second << endl;
}

void Time::set(int h, int m, int s)
{
    if (h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59) {
        hour = 0;
        minute = 0;
        second = 0;
    }
    else {
        hour = h;
        minute = m;
        second = s;
    }
}

void Time::get(int& h, int& m, int& s) const
{
    h = hour;
    m = minute;
    s = second;
}

Time Time::operator+(const int seconds) const
{
    return Time(int(*this) + seconds);
}

Time Time::operator-(const int seconds) const
{
    return Time(int(*this) - seconds);
}

int Time::operator-(const Time& t) const
{
    return int(*this) - int(t);
}

Time& Time::operator ++()
{
    int seconds = int(*this) + 1;
    *this = Time(seconds);
    return *this;
}

Time Time::operator ++(int)
{
    Time t = *this;
    ++*this;
    return t;
}

Time& Time::operator --()
{
    int seconds = int(*this) - 1;
    *this = Time(seconds);
    return *this;
}

Time Time::operator --(int)
{
    Time t = *this;
    --*this;
    return t;
}

bool Time::operator<(const Time& t) const
{
    return int(*this) < int(t);
}

bool Time::operator<=(const Time& t) const
{
    return int(*this) <= int(t);
}

bool Time::operator>(const Time& t) const
{
    return int(*this) > int(t);
}

bool Time::operator>=(const Time& t) const
{
    return int(*this) >= int(t);
}

bool Time::operator==(const Time& t) const
{
    return int(*this) == int(t);
}

bool Time::operator!=(const Time& t) const
{
    return int(*this) != int(t);
}

/////////////// 友元函数 ///////////////
ostream& operator<<(ostream& os, const Time& t)
{
    os << setw(2) << setfill('0') << t.hour << ":";
    os << setw(2) << setfill('0') << t.minute << ":";
    os << setw(2) << setfill('0') << t.second<< endl;
    return os;
}

istream& operator>>(istream& is, Time& t)
{
    int h, m, s;
    is >> h >> m >> s;
    t.set(h, m, s);
    return is;
}

Time operator+(const int seconds, const Time& t)
{
    return Time(seconds + int(t));
}