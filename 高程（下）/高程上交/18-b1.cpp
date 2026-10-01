/* 2351520 毛星博 计拔 */
#include <iostream>
#include <cmath>
using namespace std;

#define Pi 3.14159

class Shape {
protected:
    //根据需要加入相应的成员，也可以为空
public:
    virtual void ShapeName() = 0; //此句不准动
    //根据需要加入相应的成员，也可以为空
    virtual double area() = 0;
};

//此处给出五个类的定义及实现(成员函数采用体外实现形式)
class Circle : public Shape {
protected:
    double radius;
public:
    Circle(double r);   //构造函数
    virtual void ShapeName();
    virtual double area();
};

Circle::Circle(double r) 
{
    radius = r;
}

void Circle::ShapeName() 
{
    cout << "Circle" << endl;
}

double Circle::area() 
{
    if (radius <= 0) {
        return 0;
    }
    return Pi * radius * radius;
}

class Square : public Shape {
protected:
    double side;
public:
    Square(double s);   //构造函数
    virtual void ShapeName();
    virtual double area();
};

Square::Square(double s) 
{
    side = s;
}

void Square::ShapeName() 
{
    cout << "Square" << endl;
}

double Square::area() 
{
    if (side <= 0) {
        return 0;
    }
    return side * side;
}

class Rectangle : public Shape {
protected:
    double length;
    double width;
public:
    Rectangle(double l, double w);   //构造函数
    virtual void ShapeName();
    virtual double area();
};

Rectangle::Rectangle(double l, double w) 
{
    length = l;
    width = w;
}

void Rectangle::ShapeName() 
{
    cout << "Rectangle" << endl;
}

double Rectangle::area() 
{
    if (length <= 0 || width <= 0) {
        return 0;
    }
    return length * width;
}

class Trapezoid : public Shape {
protected:
    double upperBase;
    double lowerBase;
    double height;
public:
    Trapezoid(double u, double l, double h);   //构造函数
    virtual void ShapeName();
    virtual double area();
};

Trapezoid::Trapezoid(double u, double l, double h) 
{
    upperBase = u;
    lowerBase = l;
    height = h;
}

void Trapezoid::ShapeName() 
{
    cout << "Trapezoid" << endl;
}

double Trapezoid::area() 
{
    if (upperBase <= 0 || lowerBase <= 0 || height <= 0) {
        return 0;
    }
    return 0.5 * (upperBase + lowerBase) * height;
}

class Triangle : public Shape {
protected:
    double side1;
    double side2;
    double side3;
public:
    Triangle(double s1, double s2, double s3);   //构造函数
    virtual void ShapeName();
    virtual double area();
};

Triangle::Triangle(double s1, double s2, double s3) 
{
    side1 = s1;
    side2 = s2;
    side3 = s3;
}

void Triangle::ShapeName() 
{
    cout << "Triangle" << endl;
}

double Triangle::area()
{
    if (side1 <= 0 || side2 <= 0 || side3 <= 0 || (side1 + side2 <= side3) || (side1 + side3 <= side2) || (side2 + side3 <= side1)) {
        return 0;
    }
    double s = (side1 + side2 + side3) / 2;
    return sqrt(s * (s - side1) * (s - side2) * (s - side3));
}


/* -- 替换标记行 -- 本行不要做任何改动 -- 本行不要删除 -- 在本行的下面不要加入任何自己的语句，作业提交后从本行开始会被替换 -- 替换标记行 -- */

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：给出的是main函数的大致框架，允许进行微调或改变初值
***************************************************************************/
int main()
{
    if (1) {
        Circle    c1(5.2);           //半径（如果<=0，面积为0）
        Square    s1(5.2);           //边长（如果<=0，面积为0）
        Rectangle r1(5.2, 3.7);      //长、宽（如果任一<=0，面积为0）
        Trapezoid t1(2.3, 4.4, 3.8); //上底、下底、高（如果任一<=0，面积为0）
        Triangle  t2(3, 4, 5);       //三边长度（如果任一<=0或不构成三角形，面积为0）
        Shape* s[5] = { &c1, &s1, &r1, &t1, &t2 };

        int   i;
        for (i = 0; i < 5; i++) {
            s[i]->ShapeName(); //分别打印不同形状图形的名称（格式参考demo）
            cout << s[i]->area() << endl; //分别打印不同形状图形的面积（格式参考demo）
            cout << endl;
        }
    }

    if (1) {
        Circle    c1(-1);           //半径（如果<=0，面积为0）
        Square    s1(-1);           //边长（如果<=0，面积为0）
        Rectangle r1(5.2, -1);      //长、宽（如果任一<=0，面积为0）
        Trapezoid t1(2.3, -1, 3.8); //上底、下底、高（如果任一<=0，面积为0）
        Triangle  t2(3, 4, -1);       //三边长度（如果任一<=0或不构成三角形，面积为0）
        Shape* s[5] = { &c1, &s1, &r1, &t1, &t2 };

        cout << "============" << endl;
        int   i;
        for (i = 0; i < 5; i++) {
            s[i]->ShapeName(); //分别打印不同形状图形的名称（格式参考demo）
            cout << s[i]->area() << endl; //分别打印不同形状图形的面积（格式参考demo）
            cout << endl;
        }
    }

    return 0;
}

