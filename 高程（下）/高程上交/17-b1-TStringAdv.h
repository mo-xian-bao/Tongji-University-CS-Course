/* 2351520 毛星博 计拔 */

#pragma once

#include "17-b1-TString.h"
#include <climits>

class TStringAdv :public TString {
	public:
		//构造函数不能继承，只能在派生类中激活基类的构造函数！！！
		TStringAdv():TString() {};
		TStringAdv(const char* s) :TString(s) {};
		TStringAdv(const char c) :TString(c) {};
		TStringAdv(const TStringAdv& ts) :TString((const TString&)ts) {};
		TStringAdv(const TString& str) : TString(str) {};
		//派生类没有动态内存分配，所以不需要析构函数，基类的析构函数可以直接调用

		TStringAdv& assign(const TStringAdv& ts2);
		TStringAdv& assign(const char* s);
		TStringAdv& append(const TStringAdv& ts2);
		TStringAdv& append(const char* s);
		TStringAdv& append(const char& c);
		TStringAdv& insert(const TStringAdv& ts2, int pos);
		TStringAdv& insert(const char* s, int pos);
		TStringAdv& insert(const char& c, int pos);
		TStringAdv& erase(const TStringAdv& ts2);
		TStringAdv& erase(const char* s);
		TStringAdv& erase(const char& c);
		TStringAdv substr(const int pos, const int len = INT_MAX);
		char& at(const int n);
		friend int TStringAdvLen(const TStringAdv& s);

		/*friend TStringAdv operator +(const TStringAdv& s1, const TStringAdv& s2);*/
};

int TStringAdvLen(const TStringAdv& s);