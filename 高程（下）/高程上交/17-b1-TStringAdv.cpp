/* 2351520 毛星博 计拔 */

/* 允许添加需要的头文件、宏定义等 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string.h>
#include "17-b1-TStringAdv.h"
#include <limits.h>
using namespace std;

TStringAdv& TStringAdv::assign(const TStringAdv& ts2)
{
	if (this == &ts2) {
		return *this;
	}

	delete[] content;
	content = new(nothrow) char[strlen(ts2.content) + 1];
	if (content == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	len = ts2.len;
	strcpy(content, ts2.content);
	return *this;
}

TStringAdv& TStringAdv::assign(const char* s)
{
	if (s == nullptr) {
		delete[] content;
		content = new(nothrow) char[1];
		if (content == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		content[0] = '\0';
		len = 0;
	}
	else {
		len = strlen(s);
		content = new char[len + 1];
		strcpy(content, s);
	}
	return *this;
}

TStringAdv& TStringAdv::append(const TStringAdv& ts2)
{
	char *p = new(nothrow)char[len + ts2.len + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	strcpy(p, content);
	strcat(p, ts2.content);
	delete[] content;
	content = p;
	len += ts2.len;
	return *this;
}

TStringAdv& TStringAdv::append(const char* s)
{
	if (s == nullptr) {
		return *this;
	}
	int slen = strlen(s);
	char *p = new(nothrow)char[len + slen + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	strcpy(p, content);
	strcat(p, s);
	delete[] content;
	content = p;
	len += slen;
	return *this;
}

TStringAdv& TStringAdv::append(const char& c)
{
	char *p = new(nothrow)char[len + 2];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	strcpy(p, content);
	p[len] = c;
	p[len + 1] = '\0';
	delete[] content;
	content = p;
	len++;
	return *this;
}

TStringAdv& TStringAdv::insert(const TStringAdv& ts2, int pos)
{
	pos = pos - 1;
	if (pos < 0 || pos > len) {
		return *this;
	}
	if (ts2.len == 0) {  // 空字符串不插入
		return *this;
	}

	char *p = new(nothrow)char[len + ts2.len + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	for (int i = 0; i < pos; i++) {
		p[i] = content[i];
	}
	strcpy(p + pos, ts2.content);
	for (int i = pos; i < len; i++) {
		p[i + ts2.len] = content[i];
	}
	p[len + ts2.len] = '\0';
	delete[] content;
	content = p;
	len += ts2.len;
	return *this;
}

TStringAdv& TStringAdv::insert(const char* s, int pos)
{
	pos = pos - 1;
	if (pos < 0 || pos > len) {
		return *this;
	}
	if (s == nullptr) {  // 空字符串不插入
		return *this;
	}
	int slen = strlen(s);
	if (slen == 0) {  // 空字符串不插入
		return *this;
	}

	char *p = new(nothrow)char[len + slen + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	for (int i = 0; i < pos; i++) {
		p[i] = content[i];
	}
	strcpy(p + pos, s);
	for (int i = pos; i < len; i++) {
		p[i + slen] = content[i];
	}
	p[len + slen] = '\0';
	delete[] content;
	content = p;
	len += slen;
	return *this;
}

TStringAdv& TStringAdv::insert(const char& c, int pos)
{
	pos = pos - 1;
	if (pos < 0 || pos > len) {
		return *this;
	}

	if (c == '\0') {
		content[pos] = '\0';
		char *new_content = new(nothrow)char[pos + 1];
		if (new_content == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		strcpy(new_content, content);
		delete[] content;
		content = new_content;
		len = pos;
		return *this;
	}

	char *p = new(nothrow)char[len + 2];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return *this;
	}
	for (int i = 0; i < pos; i++) {
		p[i] = content[i];
	}
	p[pos] = c;
	for (int i = pos; i < len; i++) {
		p[i + 1] = content[i];
	}
	p[len+1] = '\0';
	delete[] content;
	content = p;
	len++;
	return *this;
}

TStringAdv& TStringAdv::erase(const TStringAdv& ts2)
{
	bool flag = false;
	int i, j;
	for (i = 0; i < len - ts2.len + 1; i++) {
		flag = true;
		for (j = 0; j < ts2.len; j++) {
			if (content[i + j] != ts2.content[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			break;
		}
	}
	if (!flag) {  //没有找到
		return *this;
	}
	else {
		char* p = new(nothrow) char[len - ts2.len + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		for (int k = 0; k < len; k++) {
			if (k < i) {
				p[k] = content[k];
			}
			else if (k > i + ts2.len - 1) {
				p[k - ts2.len] = content[k];
			}
		}
		p[len - ts2.len] = '\0';
		delete[] content;
		content = p;
		len -= ts2.len;
		return *this;
	}
}

TStringAdv& TStringAdv::erase(const char* s)
{
	if (s == nullptr) {
		return *this;
	}
	int slen = strlen(s);
	bool flag = false;
	int i, j;
	for (i = 0; i < len - slen + 1; i++) {
		flag = true;
		for (j = 0; j < slen; j++) {
			if (content[i + j] != s[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			break;
		}
	}
	if (!flag) {  //没有找到
		return *this;
	}
	else {
		char* p = new(nothrow) char[len - slen + 1];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		for (int k = 0; k < len; k++) {
			if (k < i) {
				p[k] = content[k];
			}
			else if (k > i + slen - 1) {
				p[k - slen] = content[k];
			}
		}
		p[len - slen] = '\0';
		delete[] content;
		content = p;
		len -= slen;
		return *this;
	}
}

TStringAdv& TStringAdv::erase(const char& c)
{
	if (c == '\0') {
		return *this;
	}
	bool flag = false;
	int i;
	for (i = 0; i < len; i++) {
		if (content[i] == c) {
			flag = true;
			break;
		}
	}
	if (!flag) {  //没有找到
		return *this;
	}
	else {
		char* p = new(nothrow) char[len];
		if (p == nullptr) {
			cout << "内存分配失败！" << endl;
			return *this;
		}
		for (int k = 0; k < len; k++) {
			if (k < i) {
				p[k] = content[k];
			}
			else if (k > i) {
				p[k - 1] = content[k];
			}
		}
		p[len - 1] = '\0';
		delete[] content;
		content = p;
		len--;
		return *this;
	}
}

TStringAdv TStringAdv::substr(const int pos, const int len)
{
	int pos1 = pos - 1,len0;
	if (pos1<0 || pos1>=this->len || len <= 0) {
		return TStringAdv();
	}
	if ((unsigned)pos1 + len > (unsigned)this->len) {
		len0 = this->len - pos1;
	}
	else {
		len0 = len;
	}
	char* p = new(nothrow) char[len0 + 1];
	if (p == nullptr) {
		cout << "内存分配失败！" << endl;
		return TStringAdv();
	}
	for (int i = 0; i < len0; i++) {
		p[i] = content[pos1 + i];
	}
	p[len0] = '\0';
	TStringAdv ts(p);
	delete[] p;
	return ts;
}

char& TStringAdv::at(const int n)
{
	return content[n];
}

int TStringAdvLen(const TStringAdv& s)
{
	return s.len;
}