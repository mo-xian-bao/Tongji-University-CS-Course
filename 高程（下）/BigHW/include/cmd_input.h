/* 2351520 计拔 毛星博 */
#pragma once
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <cstring>
#include <conio.h>
#include <ctime>
#include <cmath>

#define UP 8
#define DOWN 2
#define LEFT 4
#define RIGHT 6
#define DOWN_LEFT 24

char all_menu(int mode, char cai_dan[][100]);
void shuru(int mode, int& hang, int& lie);   //输入行列数(模式2为彩球，模式3为星星)
void print_shuzu(int mode,int hang, int lie, int& x, int& y, int shuju[10][10]); //输出数组并返回第一个数的位置
void wait_for_return(); //输入end返回菜单
void huiche(); //回车等待，用于检查和调试
void MOVE(int mode, int shuju[10][10], int hang, int lie, int frame_shixin_or_kongxin=0, int sekuai_shu=0, int sekuai_heng=0, const char* neirong=0, int biaohao=0, int fenge=0, int tuxing_shixin_or_kongxin=0); //数组移动函数
void highlight(int mode, int hang, int lie, int shuju[10][10], int jieguo[10][10], int x, int y); //标记函数，对数组进行各种标记操作
int shuzu_zhiling(int hang, int lie, int shuju[10][10], int jieguo[10][10]);  //根据结果数组对数组可消除项置零，并清空结果数组
void paint_frame(int hang, int lie, int shuju[10][10], int fenge, int biaohao, int shixin_or_kongxin, int sekuai_shu, int sekuai_heng);  //画框架函数
void edit_tuxing(int shuzi, int x, int y, int shixin_or_kongxin, int sekuai_shu, int sekuai_heng, const char* neirong, int mode); //编辑图形函数
void print_zhuangtailan(int x, int y, const char* str); //打印状态栏函数