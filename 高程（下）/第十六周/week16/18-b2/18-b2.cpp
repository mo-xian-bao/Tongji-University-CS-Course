/* 2351520 毛星博 计拔 */
#include <iostream>
#include <cmath>
using namespace std;

/* 从此处到标记替换行之间，给出各种类的定义及实现
	1、不允许定义全局变量（不含const和#define）
	2、不允许添加其它系统头文件
*/
class integral {  //积分基类
	protected:
		double high, low, n;
	public:
		friend istream& operator >>(istream& is, integral& fRef); //友元函数，输入运算符重载
		virtual void prompt() = 0; //虚函数，输入提示
		virtual double value() = 0; //虚函数，返回积分值
};
istream& operator >>(istream& is, integral& fRef)
{
	fRef.prompt();
	is  >> fRef.low >> fRef.high >> fRef.n;
	while (fRef.low > fRef.high || fRef.n <= 0) {
		cout << "数据输入错误，请重新输入" << endl;
		is.clear();
		while (is.get() != '\n')
			continue;
		fRef.prompt();
		is >> fRef.low >> fRef.high >> fRef.n;
	}
	//清空输入缓冲区
	while (is.get()!='\n')
		continue;
	return is;
}

class integral_sin : public integral {  //sin积分类
	public:
		virtual void prompt(); //虚函数，输入提示
		virtual double value(); //函数多态性
};

void integral_sin::prompt()
{
	cout << "请输入sinxdx的下限、上限及区间划分数量"<< endl;
}
double integral_sin::value()
{
	double sum = 0;
	double step = (high - low) / n;
	for (int i = 0; i < n; i++) {
		sum += step * sin(low + (i+1) * step);
	}
	cout<<"sinxdx["<<low<<"~"<<high<<"/"<<"n="<<n<<"] : "<<sum<<endl;
	return sum;
}

class integral_cos : public integral {  //cos积分类
	public:
		virtual void prompt(); //虚函数，输入提示
		virtual double value(); //函数多态性
};

void integral_cos::prompt()
{
	cout << "请输入cosxdx的下限、上限及区间划分数量" << endl;
}
double integral_cos::value()
{
	double sum = 0;
	double step = (high - low) / n;
	for (int i = 0; i < n; i++) {
		sum += step * cos(low + (i+1) * step);
	}
	cout<<"cosxdx["<<low<<"~"<<high<<"/"<<"n="<<n<<"] : "<<sum<<endl;
	return sum;
}

class integral_exp : public integral {  //exp积分类
	public:
		virtual void prompt(); //虚函数，输入提示
		virtual double value(); //函数多态性
};

void integral_exp::prompt()
{
	cout << "请输入e^xdx的下限、上限及区间划分数量" << endl;
}
double integral_exp::value()
{
	double sum = 0;
	double step = (high - low) / n;
	for (int i = 0; i < n; i++) {
		sum += step * exp(low + (i+1) * step);
	}
	cout<<"e^xdx["<<low<<"~"<<high<<"/"<<"n="<<n<<"] : "<<sum<<endl;
	return sum;
}

/* -- 替换标记行 -- 本行不要做任何改动 -- 本行不要删除 -- 在本行的下面不要加入任何自己的语句，作业提交后从本行开始会被替换 -- 替换标记行 -- */

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：fun_integral不准动，思考一下，integral应如何定义
***************************************************************************/
void fun_integral(integral& fRef)
{
	cin >> fRef;	//输入上下限、划分数
	cout << fRef.value() << endl;
	return;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：main函数不准动
***************************************************************************/
int main()
{
	integral_sin s1;
	integral_cos s2;
	integral_exp s3;

	fun_integral(s1); //计算sinxdx的值
	fun_integral(s2); //计算cosxdx的值
	fun_integral(s3); //计算expxdx的值

	return 0;
}

//注：矩形计算取右值，输出为正常double格式

