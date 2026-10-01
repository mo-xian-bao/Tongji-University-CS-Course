/* 2351520 毛星博 计拔 */

#pragma once

#include <iostream>
using namespace std;

/* 补全TString类的定义，所有成员函数均体外实现，不要在此处体内实现 */
class TString {
	protected:
		char *content;
		int   len;
		/* 根据需要定义所需的数据成员、成员函数、友元函数等 */
	public:
		/* 根据需要定义所需的数据成员、成员函数、友元函数等 */
		TString();  //构造函数
		TString(const char* p);
		TString(const char c);
		TString(const TString& other);
		~TString();

		TString& operator = (const TString& other);
		/*TString operator + (const TString& other) const;*/
		friend ostream& operator << (ostream& out, const TString& s);
		friend istream& operator >> (istream& out, TString& s);

		friend TString operator +(const TString& s1, const TString& s2);
		friend TString& operator +=(TString& s1, const TString& s2);
		friend TString operator -(const TString& s1, const TString& s2);
		friend TString& operator -=(TString& s1, const TString& s2);
		friend TString operator *(const TString& s1, const int n);
		friend TString& operator *=(TString& s1, const int n);
		friend TString operator !(const TString& s);

		friend bool operator ==(const TString& s1, const TString& s2);
		friend bool operator !=(const TString& s1, const TString& s2);
		friend bool operator <(const TString& s1, const TString& s2);
		friend bool operator >(const TString& s1, const TString& s2);
		friend bool operator <=(const TString& s1, const TString& s2);
		friend bool operator >=(const TString& s1, const TString& s2);

		friend int TStringLen(const TString& s);

		const char* c_str() const;
		int length() const;
		char& operator[] (int i);
};

/* 如果有其它全局函数需要声明，写于此处 */
int TStringLen(const TString& s);

/* 如果有需要的宏定义、只读全局变量等，写于此处 */
