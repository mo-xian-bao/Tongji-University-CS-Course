/* 2351520 毛星博 计拔 */
#pragma once

#include <iostream>
using namespace std;

enum week { sun, mon, tue, wed, thu, fri, sat };

/* 允许添加相应的函数声明 */
ostream& operator << (ostream& out, const week& w);

istream& operator >> (istream& in, week& w);

week& operator ++ (week& w);

week operator ++ (week& w, int);

week& operator -- (week& w);

week operator -- (week& w, int);

week operator + (week w1, int n);

week operator - (week w1, int n);

week& operator += (week& w1, int n);

week& operator -= (week& w1, int n);