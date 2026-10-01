/* 2351520 毛星博 计拔 */

/* 允许添加需要的头文件、宏定义等 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string.h>
#include "16-b5.h"
using namespace std;

/* 给出 TString 类的所有成员函数的体外实现 */
TString::TString()  //默认构造函数，初始化为空字符串
{
	content = new(nothrow) char[1];
	if (content == nullptr) {
		cout << "内存分配失败！" << endl;
		return;
	}
	strcpy(content, "\0");
	len = 0;
}

TString::TString(const char* p)
{
	if (p == nullptr) {
		content = new(nothrow) char[1];
		if (content == nullptr) {
			cout << "内存分配失败！" << endl;
			return;
		}
		strcpy(content, "\0");
		len = 0;
	}
	else {
		content = new(nothrow) char[strlen(p)+1];
		if (content == nullptr) {
			cout << "内存分配失败！" << endl;
			return;
		}
		strcpy(content, p);
		len = strlen(p);
	}
}

TString::TString(const char c)
{
	content = new(nothrow) char[2];
	if (content == nullptr) {
		cout << "内存分配失败！" << endl;
		return;
	}
	content[0] = c;
	content[1] = '\0';
	len = 1;
}

TString::TString(const TString& other)
{
	content = new(nothrow) char[other.len + 1];
	if (content == nullptr) {
		cout << "内存分配失败！" << endl;
		return;
	}
	strcpy(content, other.content);
	len = other.len;
}

TString& TString::operator = (const TString& other)
{
	if (this == &other) {
		return *this;
	}
	else {
		delete[] content;
		content = new(nothrow) char[other.len + 1];
		if (content == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		strcpy(content, other.content);
		len = other.len;
		return *this;
	}
}

TString::~TString()
{
	if (content != nullptr) {
		delete[] content;
		content = nullptr;
	}
}

const char* TString::c_str() const
{
	return content;
}

TString& TString::append(const TString& s2)
{
	char* p = new(nothrow) char[len + s2.len + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	strcpy(p, content);
	strcat(p, s2.content);
	delete[] content;
	content = p;
	len += s2.len;
	return *this;
}


int TString :: length() const
{
	return len;
}

char& TString::operator [] (int i)
{
	return content[i];
}

/* 如果有需要的其它全局函数的实现，可以写于此处 */
ostream& operator << (ostream& out, const TString& s)
{
	if (s.len == 0) {
		out << "<EMPTY>" << endl;
	}
	else {
		out << s.content << endl;
	}
	return out;
} 

istream& operator >> (istream& in, TString& s)
{
	char buffer[1024];
	in >> buffer;
	s = buffer;
	return in;
}

TString operator +(const TString& s1, const TString& s2)
{
	TString res;
	delete[] res.content;
	res.content = new(nothrow) char[s1.len + s2.len + 1];
	if (res.content == nullptr) {
		cout << "内存分配失败！" << endl;
		return "";
	}
	strcpy(res.content, s1.content);
	strcat(res.content, s2.content);
	res.len = s1.len + s2.len;
	return res;
}

TString& operator += (TString & s1, const TString & s2)
{
	s1.append(s2);
	return s1;
}

TString operator -(const TString& s1, const TString& s2)
{
	bool flag = false;
	int i, j;
	for (i = 0; i < s1.len - s2.len + 1; i++) {
		flag = true;
		for (j = 0; j < s2.len; j++) {
			if (s1.content[i+j] != s2.content[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			break;
		}
	}
	if (!flag) {  //没有找到
		TString res = s1;
		return res;
	}
	else {
		char* p = new(nothrow) char[s1.len - s2.len + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return "";
		}
		for (int k = 0; k < s1.len; k++) {
			if (k < i) {
				p[k] = s1.content[k];
			}
			else if (k > i + s2.len - 1) {
				p[k - s2.len] = s1.content[k];
			}
		}
		p[s1.len - s2.len] = '\0';
		TString res = p;
		delete[] p;
		return res;
	}
}

TString& operator -= (TString& s1, const TString& s2)
{
	bool flag = false;
	int i, j;
	for (i = 0; i < s1.len - s2.len + 1; i++) {
		flag = true;
		for (j = 0; j < s2.len; j++) {
			if (s1.content[i + j] != s2.content[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			break;
		}
	}
	if (flag) {
		char* p = new(nothrow) char[s1.len - s2.len + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return s1;
		}
		for (int k = 0; k < s1.len; k++) {
			if (k < i) {
				p[k] = s1.content[k];
			}
			else if (k > i + s2.len - 1) {
				p[k - s2.len] = s1.content[k];
			}
		}
		p[s1.len - s2.len] = '\0';
		delete[] s1.content;
		s1.content = p;
		s1.len = s1.len - s2.len;
	}
	return s1;
}

TString operator *(const TString& s1, const int n)
{
	if (n == 0) {
		TString res = "";
		return res;
	}
	else {
		char* p = new(nothrow) char[s1.len * n + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return "";
		}
		for (int i = 0; i < n; i++) {
			strcpy(p + i * s1.len, s1.content);
		}
		p[s1.len * n] = '\0';
		TString res = p;
		delete[] p;
		return res;
	}
}

TString& operator *= (TString& s1, const int n)
{
	if (n == 0) {
		delete[] s1.content;
		s1.content = new(nothrow) char[1];
		if (s1.content == nullptr) {
			cout << "内存分配失败！" << endl;
			return s1;
		}
		s1.content[0] = '\0';
		s1.len = 0;
	}
	else {
		char* p = new(nothrow) char[s1.len * n + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return s1;
		}
		for (int i = 0; i < n; i++) {
			strcpy(p + i * s1.len, s1.content);
		}
		p[s1.len * n] = '\0';
		delete[] s1.content;
		s1.content = p;
		s1.len = s1.len * n;
	}
	return s1;
}

TString operator !(const TString& s)
{
	char* p = new(nothrow) char[s.len + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return "";
	}
	for (int i = 0; i < s.len; i++) {
		p[i] = s.content[s.len - i - 1];
	}
	p[s.len] = '\0';
	TString res = p;
	delete[] p;
	return res;
}

bool operator ==(const TString& s1, const TString& s2)
{
	if (s1.len != s2.len) {
		return false;
	}
	else {
		if (strcmp(s1.content, s2.content)) {
			return false;
		}
	}
	return true;
}

bool operator !=(const TString& s1, const TString& s2)
{
	if (s1.len != s2.len) {
		return true;
	}
	else {
		if (strcmp(s1.content, s2.content)) {
			return true;
		}
	}
	return false;
}

bool operator <(const TString& s1, const TString& s2)
{
	if (strcmp(s1.content, s2.content) < 0) {
		return true;
	}
	else {
		return false;
	}
}

bool operator >(const TString& s1, const TString& s2)
{
	if (strcmp(s1.content, s2.content) > 0) {
		return true;
	}
	else {
		return false;
	}
}

bool operator <=(const TString& s1, const TString& s2)
{
	if (strcmp(s1.content, s2.content) <= 0) {
		return true;
	}
	else {
		return false;
	}
}

bool operator >=(const TString& s1, const TString& s2)
{
	if (strcmp(s1.content, s2.content) >= 0) {
		return true;
	}
	else {
		return false;
	}
}

int TStringLen(const TString& s)
{
	return s.len;
}
