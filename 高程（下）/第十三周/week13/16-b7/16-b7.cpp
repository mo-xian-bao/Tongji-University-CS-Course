/* 2351520 毛星博 计拔 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cstring>
#include "16-b7.h"
using namespace std;

ostream& operator << (ostream& out, const week& w)
{
	switch (w) {
	case week::sun:
		out << "星期日" << endl;
		break;
	case week::mon:
		out << "星期一" << endl;
		break;
	case week::tue:
		out << "星期二" << endl;
		break;
	case week::wed:
		out << "星期三" << endl;
		break;
	case week::thu:
		out << "星期四" << endl;
		break;
	case week::fri:
		out << "星期五" << endl;
		break;
	case week::sat:
		out << "星期六" << endl;
		break;
	default:
		out << "错误" << endl;
		break;
	}
	return out;
}

istream& operator >> (istream& in, week& w)
{
	char str[100];
	in >> str;
#if defined(__linux) || defined(__linux__) //Linux
	if (strcasecmp(str, "mon") == 0) {
		w = week::mon;
	}
	else if (strcasecmp(str, "tue") == 0) {
		w = week::tue;
	}
	else if (strcasecmp(str, "wed") == 0) {
		w = week::wed;
	}
	else if (strcasecmp(str, "thu") == 0) {
		w = week::thu;
	}
	else if (strcasecmp(str, "fri") == 0) {
		w = week::fri;
	}
	else if (strcasecmp(str, "sat") == 0) {
		w = week::sat;
	}
	else if (strcasecmp(str, "sun") == 0) {
		w = week::sun;
	}
	else {
		w = (week)8;
	}
#else //VS+Dev
	if (_stricmp(str, "mon") == 0) {
		w = week::mon;
	}
	else if (_stricmp(str, "tue") == 0) {
		w = week::tue;
	}
	else if (_stricmp(str, "wed") == 0) {
		w = week::wed;
	}
	else if (_stricmp(str, "thu") == 0) {
		w = week::thu;
	}
	else if (_stricmp(str, "fri") == 0) {
		w = week::fri;
	}
	else if (_stricmp(str, "sat") == 0) {
		w = week::sat;
	}
	else if (_stricmp(str, "sun") == 0) {
		w = week::sun;
	}
	else {
		w = (week)8;
	}
#endif
	return in;
}

week& operator ++ (week& w)
{
	w = (week)(((int)(w)+1) % 7);
	return w;
}

week operator ++(week& w, int)
{
	week temp = w;
	w = (week)(((int)(w)+1) % 7);
	return temp;
}

week& operator -- (week& w)
{
	w = (week)(((int)(w)+6) % 7);
	return w;
}

week operator --(week& w, int)
{
	week temp = w;
	w = (week)(((int)(w)+6) % 7);
	return temp;
}

week operator + (week w, int n)
{
	return (week)(((int)(w)+n) % 7);
}

week operator - (week w, int n)
{
	return (week)((((int)(w)-n) % 7 + 7) % 7);
}

week& operator += (week& w, int n)
{
	w = (week)(((int)(w)+n) % 7);
	return w;
}

week& operator -= (week& w, int n)
{
	w = (week)((((int)(w)-n) % 7 + 7) % 7);
	return w;
}