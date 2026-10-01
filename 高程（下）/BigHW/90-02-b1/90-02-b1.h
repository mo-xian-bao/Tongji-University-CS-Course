/* 2351520 计拔 毛星博 */
#pragma once

void choice_A();
void choice_B();
void choice_C();
void choice_D();
void choice_E();
void choice_F();
void choice_G();

void find(int x, int y, int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10]);
bool chazhao_jieguo(int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10] = { 0 });
bool detect_game_finished(int hang,int lie,int shuju[10][10]);   //判断游戏是否结束（即是否还存在可消除区域）
void keyboard_and_mouse(int hang, int lie, int shuju[10][10], int tishi_weizhi_y, int fenge);
void keyboard_and_mouse_full(int hang, int lie, int shuju[10][10], int jieguo[10][10], int tishi_weizhi_y, int fenge,bool& tuichu);
void mouse_leftclick_or_keyboard_Enter_or_C(int mode);