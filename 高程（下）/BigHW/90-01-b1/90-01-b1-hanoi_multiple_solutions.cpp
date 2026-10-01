/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include "../include/cmd_console_tools.h"
#include "90-01-b1-hanoi.h"
#include <conio.h>
using namespace std;

/* ----------------------------------------------------------------------------------

     本文件功能：
	1、存放被 hanoi_main.cpp 中根据菜单返回值调用的各菜单项对应的执行函数

     本文件要求：
	1、不允许定义外部全局变量（const及#define不在限制范围内）
	2、允许定义静态全局变量（具体需要的数量不要超过文档显示，全局变量的使用准则是：少用、慎用、能不用尽量不用）
	3、静态局部变量的数量不限制，但使用准则也是：少用、慎用、能不用尽量不用
	4、按需加入系统头文件、自定义头文件、命名空间等

   ----------------------------------------------------------------------------------- */

static int sum[3];
static int step;
static int num[3][10];
static int speed;

/***************************************************************************
  函数名称：hanoi
  功    能：(总-递归汉诺塔函数)
  输入参数：
  返 回 值：
  说    明：不超过15行！
***************************************************************************/
void hanoi(int n, char src, char tmp, char dst,int flag)
{
    if (n == 1) {
        shuchu(n, src, tmp, dst, flag);
    }
    else {
        hanoi(n - 1, src, dst, tmp,flag);
        shuchu(n, src, tmp, dst, flag);
        hanoi(n - 1, tmp, src, dst,flag);
    }
}

void stop(int speed)
{
    if (speed == 1) {
        Sleep(100);
    }
    else if (speed == 2) {
        Sleep(80);
    }
    else if (speed == 3) {
        Sleep(50);
    }
    else if (speed == 4||speed==0 ) {
        Sleep(10);
    }
    else if (speed == 5) {
        Sleep(0);
    }
}

void stop1(int speed)
{
    char c;
    if (speed == 0) {
        while (1) {
            c = cin.get();
            if (c == '\n') {
                break;
            }
        }
    }
}

void change_quanju(char src, char dst)
{
    num[dst - 65][sum[dst - 65]] = num[src - 65][sum[src - 65] - 1];
    sum[dst - 65]++;
    sum[src - 65]--;
}

void print_shuzu()
{
    cout << "A:";
    for (int i = 0; i < sum[0]; i++) {
        cout << right << setw(2) << setfill(' ') << num[0][i];
    }
    for (int i = sum[0]; i < 10; i++) {
        cout << "  ";
    }
    cout << " ";

    cout << "B:";
    for (int i = 0; i < sum[1]; i++) {
        cout << right << setw(2) << setfill(' ') << num[1][i];
    }
    for (int i = sum[1]; i < 10; i++) {
        cout << "  ";
    }
    cout << " ";

    cout << "C:";
    for (int i = 0; i < sum[2]; i++) {
        cout << right << setw(2) << setfill(' ') << num[2][i];
    }
    for (int i = sum[2]; i < 10; i++) {
        cout << "  ";
    }
}

void shuru(int* cengshu, char* qishi, char* zhongjian, char* mubiao,int choice)
{
    int n;
    char src, dst, tmp, c;

    while (1) {
        cout << "请输入汉诺塔的层数(1-10)" << endl;
        cin >> n;
        if (cin.fail() || (n > 10 || n < 0)) {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
        }
        else {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
            break;
        }
    }

    while (1) {
        cout << "请输入起始柱(A-C)" << endl;
        cin >> src;
        if (cin.fail() || (src != 'A' && src != 'B' && src != 'C' && src != 'a' && src != 'b' && src != 'c')) {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
        }
        else {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
            break;
        }
    }

    while (1) {
        cout << "请输入目标柱(A-C)" << endl;
        cin >> dst;
        if (cin.fail() || (dst != 'A' && dst != 'B' && dst != 'C' && dst != 'a' && dst != 'b' && dst != 'c')) {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
        }
        else if (dst == src) {
            if (dst == 'a' || dst == 'A') {
                cout << "目标柱(A)不能与起始柱(A)相同" << endl;
            }
            else if (dst == 'b' || dst == 'B') {
                cout << "目标柱(B)不能与起始柱(B)相同" << endl;
            }
            if (dst == 'C' || dst == 'c') {
                cout << "目标柱(C)不能与起始柱(C)相同" << endl;
            }
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
        }
        else {
            cin.clear();
            while ((c = cin.get()) != '\n' && c != EOF);
            break;
        }
    }

    if (src == 'A' || src == 'a') {
        src = 'A';
        if (dst == 'B' || dst == 'b') {
            dst = 'B';
            tmp = 'C';
        }
        else {
            dst = 'C';
            tmp = 'B';
        }
    }
    else if (src == 'B' || src == 'b') {
        src = 'B';
        if (dst == 'A' || dst == 'a') {
            dst = 'A';
            tmp = 'C';
        }
        else {
            dst = 'C';
            tmp = 'A';
        }
    }
    else {
        src = 'C';
        if (dst == 'A' || dst == 'a') {
            dst = 'A';
            tmp = 'B';
        }
        else {
            dst = 'B';
            tmp = 'A';
        }
    }

    if (choice == 4||choice==8) {
        while (1) {
            cout << "请输入移动速度(0-5: 0-按回车单步演示 1-延时最长 5-延时最短)" << endl;
            cin >> speed;
            if (cin.fail() || speed < 0 || speed>5) {
                cin.clear();
                while ((c = cin.get()) != '\n' && c != EOF);
            }
            else {
                cin.clear();
                while ((c = cin.get()) != '\n' && c != EOF);
                break;
            }
        }
    }

    *cengshu = n;
    *qishi = src;
    *zhongjian = tmp;
    *mubiao = dst;
}

void shuchu(int n, char src, char tmp, char dst, int flag)
{
    cct_setcursor(CURSOR_INVISIBLE);
    if (flag == 1) {
        cout << right << setw(2) << setfill(' ') << n << "# " << src << "-->" << dst << endl;
    }
    else if (flag == 2) {
        cout << "第" << right << setw(4) << setfill(' ') << (++step) << " 步(" << setw(2) << setfill(' ') << n << "#: " << src << "-->" << dst << ")" << endl;;
    }
    else if (flag == 3) {
        cout << "第" << right << setw(4) << setfill(' ') << (++step) << " 步(" << setw(2) << setfill(' ') << n << "#: " << src << "-->" << dst << ")  ";
        change_quanju(src, dst);
        print_shuzu();
        cout << endl;
    }
    else if (flag == 4) {
        stop1(speed);

        cct_gotoxy(20, 20);
        cout << "第" << right << setw(4) << setfill(' ') << (++step) << " 步(" << setw(2) << setfill(' ') << n << "#: " << src << "-->" << dst << ")  ";
        change_quanju(src, dst);
        print_shuzu();

        stop(speed);

        cct_gotoxy(21+10*(src-'A'), 15 - sum[src - 'A']-1);
        cout << "  ";
        cct_gotoxy(21 + 10 * (dst - 'A'), 15 - sum[dst - 'A']);
        cout << setw(2) << setfill(' ') << num[dst - 'A'][sum[dst - 'A']-1];
    }
    else if (flag == 8) {
        stop1(speed);

        cct_gotoxy(20, 35);
        cout << "第" << right << setw(4) << setfill(' ') << (++step) << " 步(" << setw(2) << setfill(' ') << n << "#: " << src << "-->" << dst << ")  ";
        move_panzi(src, dst);
        change_quanju(src, dst);
        cct_gotoxy(41,35);
        print_shuzu();

        cct_gotoxy(21 + 10 * (src - 'A'), 30 - sum[src - 'A'] - 1);
        cout << "  ";
        cct_gotoxy(21 + 10 * (dst - 'A'), 30 - sum[dst - 'A']);
        cout << setw(2) << setfill(' ') << num[dst - 'A'][sum[dst - 'A'] - 1];
    }
    else if (flag == 9) {

        cct_gotoxy(20, 35);
        cout << "第" << right << setw(4) << setfill(' ') << (++step) << " 步(" << setw(2) << setfill(' ') << n << "#: " << src << "-->" << dst << ")  ";
        move_panzi(src, dst);
        change_quanju(src, dst);
        cct_gotoxy(41, 35);
        print_shuzu();

        cct_gotoxy(21 + 10 * (src - 'A'), 30 - sum[src - 'A'] - 1);
        cout << "  ";
        cct_gotoxy(21 + 10 * (dst - 'A'), 30 - sum[dst - 'A']);
        cout << setw(2) << setfill(' ') << num[dst - 'A'][sum[dst - 'A'] - 1];
    }
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
}

void dengdaiqingping() 
{
    char c;
    while (1) {
        c = _getch();
        if (c == '\r') {
            break;
        }
    }
}

void zhuzi()
{
    cct_setcursor(CURSOR_INVISIBLE);
    cct_setcolor(14, 14);
    cct_gotoxy(2,15);
    for (int i = 0; i < 23; i++) {
        cout << " ";
    }
    cct_gotoxy(35,15);
    for (int i = 0; i < 23; i++) {
        cout << " ";
    }
    cct_gotoxy(68,15);
    for (int i = 0; i < 23; i++) {
        cout << " ";
    }
    for (int i = 1; i <= 12; i++) {
        for (int j = 0; j <= 2; j++) {
            cct_gotoxy(13+j*33, 15-i);
            cout << " ";
            Sleep(30);
        }
    }

    cct_setcolor(0, 7);
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
}

void panzi(char a)
{
    cct_setcursor(CURSOR_INVISIBLE);
    int color = sum[a - 'A'];
    for (int i = 0; i < sum[a - 'A']; i++) {
        cct_gotoxy(13 + 33 * (a - 'A')-num[a-'A'][i], 15 - i - 1);
        cct_setcolor(color, color);
        color -= 1;
        for (int j = 0; j < (num[a - 'A'][i])*2+1; j++) {
            cout << " ";
        }
        Sleep(50);
    }
    cct_setcolor(0, 7);
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
}

void move_panzi(char src, char dst)
{
    cct_setcursor(CURSOR_INVISIBLE);
    int n = src - 65;
    int m = dst - 65;
    for (int i = sum[n]; i < 13; i++) {
        cct_gotoxy(13 + 33 * (n) - num[n][sum[n] - 1], 15 - i);
        cct_setcolor(0, 0);
        for (int j = 0; j < num[n][sum[n] - 1]; j++) {
            cout << " ";
        }
        cct_setcolor(14, 14);
        cout << " ";
        cct_setcolor(0, 0);
        for (int j = 0; j < num[n][sum[n] - 1]; j++) {
            cout << " ";
        }
        stop(speed);
        cct_setcolor(num[n][sum[n]-1], num[n][sum[n] - 1]);
        cct_gotoxy(13 + 33 * (n) - num[n][sum[n] - 1], 15 - i-1);
        for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
            cout << " ";
        }
        stop(speed);
    }

    if (dst > src) {
        for (int i = 0; i < 33*(dst-src); i++) {
            cct_gotoxy(13 + 33 * (n) - num[n][sum[n] - 1]+i, 2);
            cct_setcolor(0, 0);
            for (int j = 0; j < (num[n][sum[n] - 1])*2+1; j++) {
                cout << " ";
            }
            stop(speed);
            cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
            cct_gotoxy(13 + 33 * (n)-num[n][sum[n] - 1] + i+1, 2);
            for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
                cout << " ";
            }
            stop(speed);
        }
        cct_gotoxy(13 + 33 * (m) - (num[n][sum[n] - 1]), 2);
        cct_setcolor(0, 0);
        for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
            cout << " ";
        }
        stop(speed);
        for (int i = 3; i < 15 - sum[m]; i++) {
            cct_gotoxy(13 + 33 * (m) - (num[n][sum[n] - 1]), i);
            cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
            for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
                cout << " ";
            }
            stop(speed);
            cct_gotoxy(13 + 33 * (m) - (num[n][sum[n] - 1]), i);
            cct_setcolor(0, 0);
            for (int j = 0; j < num[n][sum[n] - 1]; j++) {
                cout << " ";
            }
            cct_setcolor(14, 14);
            cout << " ";
            cct_setcolor(0, 0);
            for (int j = 0; j < num[n][sum[n] - 1]; j++) {
                cout << " ";
            }
            stop(speed);
        }
        cct_gotoxy(13 + 33 * (m) - (num[n][sum[n] - 1]), 15 - sum[m] - 1);
        cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
        for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
            cout << " ";
        }
    }
    else if (dst < src) {
        for (int i = 0; i < 33 * (src-dst); i++) {
            cct_gotoxy(13 + 33 * (n)-num[n][sum[n] - 1] - i, 2);
            cct_setcolor(0, 0);
            for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
                cout << " ";
            }
            stop(speed);
            cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
            cct_gotoxy(13 + 33 * (n)-num[n][sum[n] - 1] - i - 1, 2);
            for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
                cout << " ";
            }
            stop(speed);
        }
        cct_gotoxy(13 + 33 * (m)- (num[n][sum[n] - 1]), 2);
        cct_setcolor(0, 0);
        for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
            cout << " ";
        }
        stop(speed);
        for (int i = 3; i < 15 - sum[m]; i++) {
            cct_gotoxy(13 + 33 * (m)- (num[n][sum[n] - 1]), i);
            cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
            for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
                cout << " ";
            }
            stop(speed);
            cct_gotoxy(13 + 33 * (m)- (num[n][sum[n] - 1]), i);
            cct_setcolor(0, 0);
            for (int j = 0; j < num[n][sum[n] - 1]; j++) {
                cout << " ";
            }
            cct_setcolor(14, 14);
            cout << " ";
            cct_setcolor(0, 0);
            for (int j = 0; j < num[n][sum[n] - 1]; j++) {
                cout << " ";
            }
            stop(speed);
        }
        cct_gotoxy(13 + 33 * (m)- (num[n][sum[n] - 1]), 15 - sum[m] - 1);
        cct_setcolor(num[n][sum[n] - 1], num[n][sum[n] - 1]);
        for (int j = 0; j < (num[n][sum[n] - 1]) * 2 + 1; j++) {
            cout << " ";
        }
    }
    cct_setcolor(0, 7);
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
}

void choice_1()
{
    int n;
    char src, dst, tmp;

    step = 0;

    shuru(&n, &src, &tmp, &dst,1);
    hanoi(n, src, tmp, dst,1);

    cout << endl;
    cout << endl;
    cout << "按回车键继续";
    dengdaiqingping();
}

void choice_2()
{
    int n;
    char src, dst, tmp;

    step = 0;

    shuru(&n, &src, &tmp, &dst,2);
    hanoi(n, src, tmp, dst, 2);

    cout << endl;
    cout << endl;
    cout << "按回车键继续" ;
    dengdaiqingping();
}

void choice_3()
{
    int n;
    char src, dst, tmp;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src, &tmp, &dst,3);

    sum[src - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src - 65][i] = n - i;
    }

    hanoi(n, src, tmp, dst, 3);

    cout << endl;
    cout << endl;
    cout << "按回车键继续" ;
    dengdaiqingping();
}

void choice_4()
{
    int n;
    char src, dst, tmp;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src, &tmp, &dst, 4);

    sum[src - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src - 65][i] = n - i;
    }

    cct_cls();
    cct_gotoxy(0, 0);
    cout << "从 " << src << " 移动到 " << dst << "，共 " << n << " 层，延时设置为 " << speed;

    cct_gotoxy(20, 15);
    cout << "=========================";
    cct_gotoxy(22, 16);
    cout << "A         B         C";

    cct_gotoxy(20, 20);
    cout << "初始:                ";
    print_shuzu();


    for (int i = 0; i < sum[0]; i++) {
        cct_gotoxy(21, 14 - i);
        cout << right << setw(2) << setfill(' ') << num[0][i];
    }
    for (int i = 0; i < sum[1]; i++) {
        cct_gotoxy(31, 14 - i);
        cout << right << setw(2) << setfill(' ') << num[1][i];
    }
    for (int i = 0; i < sum[2]; i++) {
        cct_gotoxy(41, 14 - i);
        cout << right << setw(2) << setfill(' ') << num[2][i];
    }

    hanoi(n, src, tmp, dst, 4);

    cct_gotoxy(20, 25);
    cout << "按回车键继续" << endl;
    dengdaiqingping();
}

void choice_5()
{
    cct_cls();
    zhuzi();

    cct_gotoxy(0, 25);
    cout << "按回车键继续" ;
    dengdaiqingping();
}

void choice_6()
{
    int n;
    char src, dst, tmp;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src, &tmp, &dst, 6);

    sum[src - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src - 65][i] = n - i;
    }

    cct_cls();
    zhuzi();
    panzi(src);

    cct_gotoxy(0, 25);
    cout << "按回车键继续";
    dengdaiqingping();
}

void choice_7()
{
    int n;
    char src, dst, tmp;
    speed = 4;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src, &tmp, &dst, 7);

    sum[src - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src - 65][i] = n - i;
    }

    cct_cls();
    cct_gotoxy(0, 0);
    cout << "从" << src << "移动到" << dst << "，共" << n << "层";

    zhuzi();
    panzi(src);
    Sleep(1000);
    move_panzi(src, (n%2==1?dst:tmp));

    cct_gotoxy(0, 25);
    cout << "按回车键继续";
    dengdaiqingping();
}

void choice_8()
{
    int n;
    char src, dst, tmp;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src, &tmp, &dst, 8);

    sum[src - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src - 65][i] = n - i;
    }

    cct_cls();
    cct_gotoxy(0, 0);
    cout << "从 " << src << " 移动到 " << dst << "，共 " << n << " 层，延时设置为 " << speed;

    cct_gotoxy(20, 30);
    cout << "=========================";
    cct_gotoxy(22, 31);
    cout << "A         B         C";

    for (int i = 0; i < sum[0]; i++) {
        cct_gotoxy(21, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[0][i];
    }
    for (int i = 0; i < sum[1]; i++) {
        cct_gotoxy(31, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[1][i];
    }
    for (int i = 0; i < sum[2]; i++) {
        cct_gotoxy(41, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[2][i];
    }

    cct_gotoxy(20, 35);
    cout << "初始:                ";
    print_shuzu();

    zhuzi();
    panzi(src);
    Sleep(1000);

    hanoi(n, src, tmp, dst, 8);

    cct_gotoxy(0, 40);
    cout << "按回车键继续";
    dengdaiqingping();
}

void choice_9()
{
    int n;
    char src0, dst0, tmp;
    char src, dst;
    speed = 4;
    int end = 0;

    //初始化各个量
    for (int i = 0; i < 3; i++) {
        sum[i] = 0;
    }
    step = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 10; j++) {
            num[i][j] = 0;
        }
    }

    shuru(&n, &src0, &tmp, &dst0, 9);

    sum[src0 - 65] = n;
    for (int i = 0; i < n; i++) {
        num[src0 - 65][i] = n - i;
    }

    cct_cls();
    cct_gotoxy(0, 0);
    cout << "从 " << src0 << " 移动到 " << dst0 << "，共 " << n << " 层";

    cct_gotoxy(20, 30);
    cout << "=========================";
    cct_gotoxy(22, 31);
    cout << "A         B         C";

    for (int i = 0; i < sum[0]; i++) {
        cct_gotoxy(21, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[0][i];
    }
    for (int i = 0; i < sum[1]; i++) {
        cct_gotoxy(31, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[1][i];
    }
    for (int i = 0; i < sum[2]; i++) {
        cct_gotoxy(41, 29 - i);
        cout << right << setw(2) << setfill(' ') << num[2][i];
    }

    cct_gotoxy(20, 35);
    cout << "初始:                ";
    print_shuzu();

    zhuzi();
    panzi(src0);

    cct_gotoxy(10, 37);
    cout << "请输入移动的柱号(命令形式，AC等于将A柱顶端盘子移动到C柱，按Q退出)：";

    char in[10];
    while (1) {
        cct_gotoxy(77, 37);

        for (int i = 0; i < 10; ) {
            in[i] = _getche();
            if (in[i] == '\r') {
                if (i == 2) {
                    if (in[0] == 'a' || in[0] == 'A') {
                        if (in[1] == 'b' || in[1] == 'B') {
                            src = 'A';
                            dst = 'B';
                            break;
                        }
                        else if (in[1] == 'c' || in[1] == 'C') {
                            src = 'A';
                            dst = 'C';
                            break;
                        }
                        else {
                            i = 0;
                            cct_gotoxy(77, 37);
                            cout << "                          ";
                            cct_gotoxy(77, 37);
                            continue;
                        }
                    }
                    else if (in[0] == 'b' || in[0] == 'B') {
                        if (in[1] == 'A' || in[1] == 'a') {
                            src = 'B';
                            dst = 'A';
                            break;
                        }
                        else if (in[1] == 'c' || in[1] == 'C') {
                            src = 'B';
                            dst = 'C';
                            break;
                        }
                        else {
                            i = 0;
                            cct_gotoxy(77, 37);
                            cout << "                          ";
                            cct_gotoxy(77, 37);
                            continue;
                        }
                    }
                    else if (in[0] == 'c' || in[0] == 'C') {
                        if (in[1] == 'A' || in[1] == 'a') {
                            src = 'C';
                            dst = 'A';
                            break;
                        }
                        else if (in[1] == 'b' || in[1] == 'B') {
                            src = 'C';
                            dst = 'B';
                            break;
                        }
                        else {
                            i = 0;
                            cct_gotoxy(77, 37);
                            cout << "                          ";
                            cct_gotoxy(77, 37);
                            continue;
                        }
                    }
                    else {
                        i = 0;
                        cct_gotoxy(77, 37);
                        cout << "                          ";
                        cct_gotoxy(77, 37);
                        continue;
                    }
                }
                else if (i == 1) {
                    if (in[0] == 'Q' || in[0] == 'q') {
                        end = 1;
                        break;
                    }
                    else {
                        i = 0;
                        cct_gotoxy(77, 37);
                        cout << "                          ";
                        cct_gotoxy(77, 37);
                        continue;
                    }
                }
                else {
                    i = 0;
                    cct_gotoxy(77, 37);
                    cout << "                          ";
                    cct_gotoxy(77, 37);
                    continue;
                }
            }
            i++;
            if (i == 10) {
                i = 0;
                cct_gotoxy(77, 37);
                cout << "                          ";
                cct_gotoxy(77, 37);
                continue;
            }
        }
        if (end == 1) {
            cct_gotoxy(10, 38);
            cout << "游戏结束！！！";
            break;
        }

        if (sum[src - 'A'] == 0) {
            cct_gotoxy(10, 38);
            cout << "源柱为空！！！";
            Sleep(1000);
            cct_gotoxy(10, 38);
            cout << "                ";
            cct_gotoxy(77, 37);
            cout << "                ";
        }
        else if ((num[src - 'A'][sum[src - 'A'] - 1] > num[dst - 'A'][sum[dst - 'A'] - 1]) && (num[dst - 'A'][sum[dst - 'A'] - 1] != 0)) {
            cct_gotoxy(10, 38);
            cout << "大盘压小盘，非法移动！！！";
            Sleep(1000);
            cct_gotoxy(10, 38);
            cout << "                           ";
            cct_gotoxy(77, 37);
            cout << "                          ";
        }
        else {
            shuchu(n, src, tmp, dst, 9);
            cct_gotoxy(77, 37);
            cout << "                          ";
            cct_gotoxy(77, 37);

            if (sum[dst0 - 'A'] == n) {
                cct_gotoxy(10, 38);
                cout << "游戏结束 congratulations！！！";
                break;
            }        }
    }



    cct_gotoxy(0, 40);
    cout << "按回车键继续";
    dengdaiqingping();
}
