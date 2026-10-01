/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-01-b2-magic_ball.h"
#include <conio.h>
#include <ctime>
#include <cmath>
using namespace std;

void shuzu_zhiling(int shuju[10][10], int panduan[54][4], int hang, int lie) //把数组可消除项置零
{
    for (int h = 0; panduan[h][2] > 2; h++) {
        if (panduan[h][3] == 1) {
            for (int j = panduan[h][1]; j < panduan[h][1] + panduan[h][2]; j++) {
                shuju[panduan[h][0]][j] = 0;
            }
        }
        else if (panduan[h][3] == 2) {
            for (int i = panduan[h][0]; i < panduan[h][0] + panduan[h][2]; i++) {
                shuju[i][panduan[h][1]] = 0;
            }
        }
    }
}

void xialuo(int shuju[10][10], int panduan[54][4], int hang, int lie) //数组下落函数
{
    for (int i = 0; i < hang; i++) {
        for (int j = 0; j < lie; j++) {
            if (shuju[i][j] == 0) {
                for (int k = i; k > 0; k--) {
                    shuju[k][j] = shuju[k - 1][j];
                }
                shuju[0][j] = 0;
            }
        }
    }
}

bool can_disappear(int shuju[10][10], int jieguo[10][10]) //判断是否有可以消除的组，返回布尔值真或假
{
    bool flag = false;
    int h = 0;
    int panduan[100][4] = { 0 };

    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (shuju[i][j] != 0) {
                panduan[h][2] = 1;
                for (int k = 1; i + k < 9 && shuju[i + k][j] == shuju[i][j]; k++)
                    panduan[h][2]++;
                if (panduan[h][2] >= 3) {
                    panduan[h][3] = 2;
                    panduan[h][0] = i;
                    panduan[h][1] = j;
                    flag = true;
                    h++;
                }
            }
            if (shuju[i][j] != 0) {
                panduan[h][2] = 1;
                for (int k = 1; j + k < 9 && shuju[i][j + k] == shuju[i][j]; k++)
                    panduan[h][2]++;
                if (panduan[h][2] >= 3) {
                    panduan[h][3] = 1;
                    panduan[h][0] = i;
                    panduan[h][1] = j;
                    flag = true;
                    h++;
                }
            }
        }
    }

    panduan_to_jieguo(panduan, jieguo);

    return flag;
}

void hint(int hang, int lie, int shuju[10][10],int tishi[144][4], int& t) //找出可交换项并存入jieguo数组
{
    int shuju_virtual[10][10] = { 0 };
    int jieguo_virtual[10][10] = { 0 };
    int exchange;

    //每次置零提示数组
    t = 0;
    for (int i = 0; i < 144; i++) {
        for (int j = 0; j < 4; j++) {
            tishi[i][j] = 0;
        }
    }

    for (int i = 0; i < hang; i++) { //模拟横向交换
        for (int j = 0; j < lie - 1; j++) {
            for (int i0 = 0; i0 < hang; i0++) {
                for (int j0 = 0; j0 < lie; j0++) {
                    shuju_virtual[i0][j0] = shuju[i0][j0];
                }
            }
            exchange = shuju_virtual[i][j];
            shuju_virtual[i][j] = shuju_virtual[i][j + 1];
            shuju_virtual[i][j + 1] = exchange;
            if (can_disappear(shuju_virtual, jieguo_virtual)) {
                tishi[t][0] = i;
                tishi[t][1] = j;
                tishi[t][2] = i;
                tishi[t][3] = j + 1;
                t++;
            }
        }
    }
    for (int i = 0; i < hang - 1; i++) { //模拟纵向交换
        for (int j = 0; j < lie; j++) {
            for (int i0 = 0; i0 < hang; i0++) {
                for (int j0 = 0; j0 < lie; j0++) {
                    shuju_virtual[i0][j0] = shuju[i0][j0];
                }
            }
            exchange = shuju_virtual[i][j];
            shuju_virtual[i][j] = shuju_virtual[i + 1][j];
            shuju_virtual[i + 1][j] = exchange;
            if (can_disappear(shuju_virtual,jieguo_virtual)) {
                tishi[t][0] = i;
                tishi[t][1] = j;
                tishi[t][2] = i + 1;
                tishi[t][3] = j;
                t++;
            }
        }
    }
}

void choice_1()
{
    int x, y; //数组起始位置
    int hang, lie;
    int shuju[10][10] = { 0 };
    int jieguo[10][10] = { 0 };
    srand(static_cast<unsigned int>(time(0)));

	cct_cls();
	shuru(2,hang, lie);
    for (int i = 0; i < hang; i++) {
        for (int j = 0; j < lie; j++) {
            shuju[i][j] = rand() % 9 + 1;
        }
    }

    cout << endl;
    cout << "初始数组：" << endl;
    print_shuzu(1,hang, lie, x, y, shuju);
    cout << "按回车键进行寻找初始可消除项的操作...";
    huiche();
    cout << endl;
    if (can_disappear(shuju, jieguo)) {
        cout<<"初始可消除项（不同色标识）："<<endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(1,hang,lie,shuju,jieguo,x,y); //模式1：标亮可消除项
    }
    else {
        cout << "初始已无可消除项" << endl;
    }

    cct_gotoxy(0, y + hang + 3);
    wait_for_return();
}

void choice_2()
{
    int x, y; //数组起始位置
    int hang, lie;
    int shuju[10][10] = { 0 };
    int jieguo[10][10] = { 0 };
    srand(static_cast<unsigned int>(time(0)));

    cct_cls();
    shuru(2,hang, lie);
    for (int i = 0; i < hang; i++) {
        for (int j = 0; j < lie; j++) {
            shuju[i][j] = rand() % 9 + 1;
        }
    }

    cout << endl;
    cout << "初始数组：" << endl;
    print_shuzu(1,hang, lie, x, y, shuju);

    cout << "按回车键进行寻找初始可消除项的操作...";
    huiche();
    cout << endl;
    while (can_disappear(shuju, jieguo)) {
        cct_gotoxy(0, y + hang + 3);
        cout << "初始可消除项（不同色标识）：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(1,hang,lie,shuju,jieguo,x,y); //模式1：标亮可消除项

        cct_gotoxy(0, y + hang + 3);
        cout << "按回车键进行数组下落除0操作..." << endl;
        huiche();
        shuzu_zhiling(hang, lie, shuju, jieguo);
        MOVE(2,shuju,hang,lie);
        cout << "下落除0后的数组(不同色标识)：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(2, hang, lie, shuju, jieguo, x, y); //模式2：标亮0项

        cct_gotoxy(0, y + hang + 3);
        cout << "按回车键进行新值填充..." << endl;
        huiche();
        cout << "新值填充后的数组(不同色标识)：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(3,hang,lie,shuju,jieguo,x,y);//模式3：标亮并对0填充新的值
    }
    cct_gotoxy(0, y + hang + 3);
    cout << "初始已无可消除项" << endl;
    wait_for_return();
}

void choice_3()
{
    int x, y; //数组起始位置
    int hang, lie, tishi[144][4] = { 0 }, t = 0;
    int shuju[10][10] = { 0 };
    int jieguo[10][10] = { 0 };
    srand(static_cast<unsigned int>(time(0)));

    cct_cls();
    shuru(2,hang, lie);
    for (int i = 0; i < hang; i++) {
        for (int j = 0; j < lie; j++) {
            shuju[i][j] = rand() % 9 + 1;
        }
    }

    cout << endl;
    cout << "初始数组：" << endl;
    print_shuzu(1,hang, lie, x, y, shuju);

    cout << "按回车键进行寻找初始可消除项的操作...";
    huiche();
    cout << endl;
    while (can_disappear(shuju,jieguo)) {
        cct_gotoxy(0, y + hang + 3);
        cout << "初始可消除项（不同色标识）：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(1,hang,lie,shuju,jieguo,x,y); //模式1：标亮可消除项

        cct_gotoxy(0, y + hang + 3);
        cout << "按回车键进行数组下落除0操作..." << endl;
        huiche();
        shuzu_zhiling(hang, lie, shuju, jieguo);
        MOVE(2, shuju, hang, lie);
        cout << "下落除0后的数组(不同色标识)：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(2, hang, lie, shuju, jieguo, x, y); //模式2：标亮0项

        cct_gotoxy(0, y + hang + 3);
        cout << "按回车键进行新值填充..." << endl;
        huiche();
        cout << "新值填充后的数组(不同色标识)：" << endl;
        print_shuzu(1,hang, lie, x, y, shuju);
        highlight(3,hang,lie,shuju,jieguo,x,y);//模式3：标亮并对0填充新的值
    }
    cct_gotoxy(0, y + hang + 3);
    cout << "初始已无可消除项" << endl;
    cout << endl;
    cout << "可选择的消除提示（不同色标识）：" << endl;
    print_shuzu(1,hang, lie, x, y, shuju);
    hint(hang, lie, shuju, tishi, t);
    tishi_to_jieguo(tishi, t, jieguo);

   /* for (int t0 = 0; t0<t; t0++) {
        cout << tishi[t0][0] << tishi[t0][1] << tishi[t0][2] << tishi[t0][3] << endl;
    }*/
    highlight(1,hang,lie,shuju,jieguo,x,y); //模式1：标亮可交换项

    cct_gotoxy(0, y + hang + 3);
    wait_for_return();
}

void panduan_to_jieguo(int panduan[][4], int jieguo[10][10])
{
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            jieguo[i][j] = 0;
        }
    }

    for (int h = 0; panduan[h][2] > 2; h++) {
        if (panduan[h][3] == 1) {
            for (int i = 0; i < panduan[h][2]; i++) {
                jieguo[panduan[h][0]][panduan[h][1]+i] = 1;
            }
        }
        else if (panduan[h][3] == 2) {
            for (int i = 0; i < panduan[h][2]; i++) {
                jieguo[panduan[h][0]+i][panduan[h][1]] = 1;
            }
        }
    }
}

void tishi_to_jieguo(int tishi[144][4],int t, int jieguo[10][10])
{
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            jieguo[i][j] = 0;
        }
    }

    for (int t0 = 0; t0 < t; t0++) {
        jieguo[tishi[t0][0]][tishi[t0][1]] = 1;
        jieguo[tishi[t0][2]][tishi[t0][3]] = 1;
    }
}