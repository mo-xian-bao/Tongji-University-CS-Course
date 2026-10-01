/* 2351520 计拔 毛星博 */
#pragma once

//int magicball_menu(void);
void choice_1();
void choice_2();
void choice_3();
void choice_4();
void choice_5();
void choice_6();
void choice_7();
void choice_8();
void choice_9();
//void wait_for_return();
void lighten(int hang, int lie, int shuju[10][10], int panduan[54][4], int x, int y, int mode);
void xialuo(int shuju[10][10], int panduan[54][4], int hang, int lie);
void shuzu_zhiling(int shuju[10][10], int panduan[54][4], int hang, int lie);//把数组可消除项置零
//void huiche();
//void print_shuzu(int hang, int lie, int& x, int& y, int shuju[10][10]); //输出数组并返回第一个数的位置
//void shuru(int& hang, int& lie); //输入行列数
bool can_disappear(int shuju[10][10], int jieguo[10][10]); //判断是否有可以消除的组，返回布尔值真或假
void hint(int hang, int lie, int shuju[10][10], int tishi[144][4], int& t); //找出可交换项并存入tishi数组
void paint_frame(int shuju[10][10], int hang, int lie, int mode);
void paint_ball(int shuju[10][10], int hang, int lie, int mode);
void xialuo_graph(int shuju[10][10], int panduan[54][4], int hang, int lie, int& score);
void mark(int shuju[10][10], int tishi[144][4], int hang, int lie, int t);
void mouse(int shuju[10][10], int tishi[144][4], int hang,int lie, int t);
void mouse_full(int shuju[10][10], int tishi[144][4], int hang, int lie, int t,bool& tuichu);
void panduan_to_jieguo(int panduan[][4], int jieguo[10][10]);
void tishi_to_jieguo(int tishi[144][4], int t,int jieguo[10][10]); 
void baozha(int shuju[10][10], int jieguo[10][10], int hang, int lie, int& score);
void tianchong(int hang, int lie, int shuju[10][10]);