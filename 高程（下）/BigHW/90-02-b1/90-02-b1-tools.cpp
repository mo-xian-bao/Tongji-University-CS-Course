/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include <conio.h>
#include <cstring>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_input.h"
#include "90-02-b1.h"
#include <cmath>
using namespace std;

bool detect_game_finished(int hang, int lie, int shuju[10][10])  //判断游戏是否结束（即是否还存在可消除区域）
{
	for (int i = 0; i < hang - 1; i++) {
		for (int j = 0; j < lie; j++) {
			if (shuju[i][j] != 0) {
				if (shuju[i][j] == shuju[i + 1][j]) {
					return true;
				}
			}
		}
	}
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie - 1; j++) {
			if (shuju[i][j] != 0) {
				if (shuju[i][j] == shuju[i][j + 1]) {
					return true;
				}
			}
		}
	}
	return false;
}

void find(int x, int y, int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10])
{
	// 判断当前坐标是否在边界内
	if (x < 0 || x >= hang || y < 0 || y >= lie) {
		return;
	}
	//cout << "fuck1" << endl;

	// 判断当前点是否已经被访问过或数字不匹配
	if (jieguo[x][y] != 0 || shuju[x][y] != shuju[find_hang][find_lie]) {
		return;
	}
	//cout << "fuck2" << endl;

	// 记录当前点
	jieguo[x][y] = 1;
	//cout << "fuck3" << endl;

	// 递归搜索四个方向
	find(x + 1, y, find_hang, find_lie, hang, lie, shuju, jieguo); // 下
	find(x - 1, y, find_hang, find_lie, hang, lie, shuju, jieguo); // 上
	find(x, y + 1, find_hang, find_lie, hang, lie, shuju, jieguo); // 右
	find(x, y - 1, find_hang, find_lie, hang, lie, shuju, jieguo); // 左
}



bool chazhao_jieguo(int find_hang, int find_lie, int hang, int lie, int shuju[10][10], int jieguo[10][10])
{
	int count = 0;

	//每次重置结果数组
	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			jieguo[i][j] = 0;
		}
	}

	//查找并存入结果数组
	find(find_hang, find_lie, find_hang, find_lie, hang, lie, shuju, jieguo);

	for (int i = 0; i < hang; i++) {
		for (int j = 0; j < lie; j++) {
			count += jieguo[i][j];
		}
	}

	return count > 1;
}

void keyboard_and_mouse(int hang, int lie, int shuju[10][10], int tishi_weizhi_y, int fenge)
{
	int MX, MY, MAction, keycode1, keycode2;  //用于处理键盘和鼠标
	int event;  //记录键盘鼠标事件
	int hang_old = 0, lie_old = 0; //记录选中可选项后的位置(初始位于A行0列)
	int hang_new, lie_new;
	bool flag = false;  //flag记录位置是否非法
	int qishi_x = 4, qishi_y = 3;
	char zhuangtailan[100] = { 0 };

	edit_tuxing(shuju[0][0], qishi_x, qishi_y, 2, 3, 6, "★", 2);
	/*cct_gotoxy(0, tishi_weizhi_y);
	cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列                               ";*/
	sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                         ", 'A' + hang_old, lie_old);
	print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

	while (6) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);

		if (event == CCT_KEYBOARD_EVENT) {  //检测到键盘事件（仅方向键和回车键）
			if (keycode1 == 0xe0) {
				edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

				if (keycode2 == KB_ARROW_UP) {
					hang_old = (hang_old + hang - 1) % hang;
				}
				else if (keycode2 == KB_ARROW_DOWN) {
					hang_old = (hang_old + 1) % hang;
				}
				else if (keycode2 == KB_ARROW_LEFT) {
					lie_old = (lie_old + lie - 1) % lie;
				}
				else if (keycode2 == KB_ARROW_RIGHT) {
					lie_old = (lie_old + 1) % lie;
				}

				qishi_x = 4 + lie_old * (6 + 2 * fenge);
				qishi_y = 3 + hang_old * (3 + fenge);
				edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

				/*cct_gotoxy(0, tishi_weizhi_y);
				cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列";*/
				sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                         ", 'A' + hang_old, lie_old);
				print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
			}

			else if (keycode1 == 0x0d) {
				/*cct_gotoxy(0, tishi_weizhi_y);
				cout << "选中了" << (char)('A' + hang_old) << "行" << lie_old << "列                                ";*/
				sprintf_s(zhuangtailan, "选中了%c行%d列                                         ", 'A' + hang_old, lie_old);
				print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				break;
			}
		}

		else if (event == CCT_MOUSE_EVENT) {  //检测到鼠标事件
			if (fenge == 0) {
				if (MX < 4 || MX>3 + 6 * lie || MY < 3 || MY>2 + 3 * hang) {
					flag = false;
				}
				else
					flag = true;

				if (flag) {
					hang_new = (MY - 3) / 3;
					lie_new = (MX - 4) / 6;

					if (hang_new != hang_old || lie_new != lie_old) {
						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << (char)('A' + hang_old) << "行" << lie_old << "列           ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]%c行%d列           ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

				}
				else {
					qishi_x = 4 + lie_old * (6 + 2 * fenge);
					qishi_y = 3 + hang_old * (3 + fenge);
					edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << "位置非法        ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]位置非法        ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
			}
			else if (fenge == 1) {
				if ((MX >= 4 && MX <= 1 + 8 * lie) && (MX % 8 != 2 && MX % 8 != 3) && (MY >= 3 && MY <= 1 + 4 * hang) && (MY % 4 != 2)) {
					flag = true;
				}
				else {
					flag = false;
				}

				if (flag) {
					hang_new = (MY - 3) / 4;
					lie_new = (MX - 4) / 8;

					if (hang_new != hang_old || lie_new != lie_old) {
						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << (char)('A' + hang_old) << "行" << lie_old << "列           ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]%c行%d列           ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
				else {
					qishi_x = 4 + lie_old * (6 + 2 * fenge);
					qishi_y = 3 + hang_old * (3 + fenge);
					edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << "位置非法        ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]位置非法        ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
			}

			// 检查鼠标按键事件
			bool flag2 = false;
			if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
				if (flag) {
					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "选中了" << (char)('A' + hang_old) << "行" << lie_old << "列                                ";*/
					sprintf_s(zhuangtailan, "选中了%c行%d列                                         ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
					break;
				}
			}
		}
	}
}

void keyboard_and_mouse_full(int hang, int lie, int shuju[10][10], int jieguo[10][10], int tishi_weizhi_y, int fenge, bool& tuichu)
{
	int MX, MY, MAction, keycode1, keycode2;  //用于处理键盘和鼠标
	int event;  //记录键盘鼠标事件
	int hang_old = hang - 1, lie_old = 0; //记录选中可选项后的位置(初始位于A行0列)
	int hang_new, lie_new;
	bool flag = false;  //flag记录位置是否非法
	int qishi_x = 4, qishi_y = 3 + hang_old * (3 + fenge);
	char zhuangtailan[200] = { 0 };

	edit_tuxing(shuju[hang_old][0], qishi_x, qishi_y, 2, 3, 6, "★", 2);
	/*cct_gotoxy(0, tishi_weizhi_y);
	cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                      ";*/
	sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                                      ", 'A' + hang_old, lie_old);

	while (6) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);

		for (int i = 0; i < hang; i++) {
			for (int j = 0; j < lie; j++) {
				if (jieguo[i][j] > 0) {
					qishi_x = 4 + j * (6 + 2 * fenge);
					qishi_y = 3 + i * (3 + fenge);
					edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
					jieguo[i][j] = 0;
				}
			}
		}

		if (event == CCT_KEYBOARD_EVENT) {  //检测到键盘事件（仅方向键和回车键）

			if (keycode1 == 0xe0) {
				edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

				if (keycode2 == KB_ARROW_UP) {
					hang_old = (hang_old + hang - 1) % hang;
					while (shuju[hang_old][lie_old] == 0) {
						hang_old = (hang_old + hang - 1) % hang;
					}
				}
				else if (keycode2 == KB_ARROW_DOWN) {
					hang_old = (hang_old + 1) % hang;
					while (shuju[hang_old][lie_old] == 0) {
						hang_old = (hang_old + 1) % hang;
					}
				}
				else if (keycode2 == KB_ARROW_LEFT) {
					lie_old = (lie_old + lie - 1) % lie;
					while (shuju[hang_old][lie_old] == 0) {
						lie_old = (lie_old + lie - 1) % lie;
					}
				}
				else if (keycode2 == KB_ARROW_RIGHT) {
					lie_old = (lie_old + 1) % lie;
					while (shuju[hang_old][lie_old] == 0) {
						lie_old = (lie_old + 1) % lie;
					}
				}

				qishi_x = 4 + lie_old * (6 + 2 * fenge);
				qishi_y = 3 + hang_old * (3 + fenge);
				edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

				/*cct_gotoxy(0, tishi_weizhi_y);
				cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                ";*/
				sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                                ", 'A' + hang_old, lie_old);
				print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

			}
			else if (keycode1 == 0x0d) {
				/*cct_gotoxy(0, tishi_weizhi_y);
				cout << "选中了" << (char)('A' + hang_old) << "行" << lie_old << "列                                              ";*/
				sprintf_s(zhuangtailan, "选中了%c行%d列                                              ", 'A' + hang_old, lie_old);
				print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

				bool kefou_xiaochu = chazhao_jieguo(hang_old, lie_old, hang, lie, shuju, jieguo);

				if (kefou_xiaochu == 1) {
					for (int i = 0; i < hang; i++) {
						for (int j = 0; j < lie; j++) {
							if (jieguo[i][j] > 0) {
								qishi_x = 4 + j * (6 + 2 * fenge);
								qishi_y = 3 + i * (3 + fenge);
								edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 2);
							}
						}
					}
					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "箭头键/鼠标移动取消当前选择, 回车键/单击左键合成                                           ";*/
					sprintf_s(zhuangtailan, "箭头键/鼠标移动取消当前选择, 回车键/单击左键合成                                           ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

				}
				else {
					/*cct_gotoxy(0, tishi_weizhi_y);
					cct_setcolor(0, COLOR_HYELLOW);
					cout << "周围无相同值,";
					cct_setcolor();
					cout << "箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束                                              ";*/
					sprintf_s(zhuangtailan, "周围无相同值! 箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束                                              ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

				}

				while (6) {
					event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);
					if (event == CCT_KEYBOARD_EVENT) {
						if (keycode1 == 0xe0) {
							for (int i = 0; i < hang; i++) {
								for (int j = 0; j < lie; j++) {
									if (jieguo[i][j] > 0) {
										qishi_x = 4 + j * (6 + 2 * fenge);
										qishi_y = 3 + i * (3 + fenge);
										edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
										jieguo[i][j] = 0;
									}
								}
							}

							if (keycode2 == KB_ARROW_UP) {
								hang_old = (hang_old + hang - 1) % hang;
								while (shuju[hang_old][lie_old] == 0) {
									hang_old = (hang_old + hang - 1) % hang;
								}
							}
							else if (keycode2 == KB_ARROW_DOWN) {
								hang_old = (hang_old + 1) % hang;
								while (shuju[hang_old][lie_old] == 0) {
									hang_old = (hang_old + 1) % hang;
								}
							}
							else if (keycode2 == KB_ARROW_LEFT) {
								lie_old = (lie_old + lie - 1) % lie;
								while (shuju[hang_old][lie_old] == 0) {
									lie_old = (lie_old + lie - 1) % lie;
								}
							}
							else if (keycode2 == KB_ARROW_RIGHT) {
								lie_old = (lie_old + 1) % lie;
								while (shuju[hang_old][lie_old] == 0) {
									lie_old = (lie_old + 1) % lie;
								}
							}

							qishi_x = 4 + lie_old * (6 + 2 * fenge);
							qishi_y = 3 + hang_old * (3 + fenge);
							edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

							/*cct_gotoxy(0, tishi_weizhi_y);
							cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                         ";*/
							sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                                         ", 'A' + hang_old, lie_old);
							print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

							break;
						}
						else if (keycode1 == 0x0d) {
							if (kefou_xiaochu == 1) {
								return;
							}
							else {
								continue;
							}
						}
						else if (keycode1 == 81 || keycode1 == 113) {
							tuichu = true;
							return;
						}
					}
					else if (event == CCT_MOUSE_EVENT) {
						if (fenge == 0) {
							if (MX < 4 || MX>3 + 6 * lie || MY < 3 || MY>2 + 3 * hang) {
								flag = false;
							}
							else
								flag = true;

							if (flag) {
								hang_new = (MY - 3) / 3;
								lie_new = (MX - 4) / 6;

								if (hang_new != hang_old || lie_new != lie_old) {
									for (int i = 0; i < hang; i++) {
										for (int j = 0; j < lie; j++) {
											if (jieguo[i][j] > 0) {
												qishi_x = 4 + j * (6 + 2 * fenge);
												qishi_y = 3 + i * (3 + fenge);
												edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
												jieguo[i][j] = 0;
											}
										}
									}

									hang_old = hang_new;
									lie_old = lie_new;

									qishi_x = 4 + lie_old * (6 + 2 * fenge);
									qishi_y = 3 + hang_old * (3 + fenge);
									edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

									break;
								}
							}
							else {
								for (int i = 0; i < hang; i++) {
									for (int j = 0; j < lie; j++) {
										if (jieguo[i][j] > 0) {
											qishi_x = 4 + j * (6 + 2 * fenge);
											qishi_y = 3 + i * (3 + fenge);
											edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
											jieguo[i][j] = 0;
										}
									}
								}

								break;
							}
						}
						else if (fenge == 1) {
							if ((MX >= 4 && MX <= 1 + 8 * lie) && (MX % 8 != 2 && MX % 8 != 3) && (MY >= 3 && MY <= 1 + 4 * hang) && (MY % 4 != 2)) {
								flag = true;
							}
							else {
								flag = false;
							}

							if (flag) {
								;
							}
							else {
								for (int i = 0; i < hang; i++) {
									for (int j = 0; j < lie; j++) {
										if (jieguo[i][j] > 0) {
											qishi_x = 4 + j * (6 + 2 * fenge);
											qishi_y = 3 + i * (3 + fenge);
											edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
											jieguo[i][j] = 0;
										}
									}
								}

								break;
							}
						}

						if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
							if (kefou_xiaochu == 1) {
								return;
							}
							else {
								continue;
							}
						}
					}
				}
			}
			else if (keycode1 == 81 || keycode1 == 113) {
				tuichu = true;
				return;
			}
		}

		else if (event == CCT_MOUSE_EVENT) {  //检测到鼠标事件
			if (fenge == 0) {
				int hang_test;
				int lie_test;

				if (MX < 4 || MX>3 + 6 * lie || MY < 3 || MY>2 + 3 * hang) {
					flag = false;
				}
				else {
					hang_test = (MY - 3) / 3;
					lie_test = (MX - 4) / 6;
					if (shuju[hang_test][lie_test] != 0) {
						flag = true;
					}
					else
						flag = false;
				}

				if (flag) {
					hang_new = (MY - 3) / 3;
					lie_new = (MX - 4) / 6;

					if (hang_new != hang_old || lie_new != lie_old) {
						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}
					else if (hang_new != hang_test || lie_new != lie_test) {
						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                     ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]%c行%d列                                                     ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
				else {
					qishi_x = 4 + lie_old * (6 + 2 * fenge);
					qishi_y = 3 + hang_old * (3 + fenge);
					edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << "位置非法                                                                 ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]位置非法                                                                 ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
			}
			else if (fenge == 1) {
				int hang_test;
				int lie_test;

				if ((MX >= 4 && MX <= 1 + 8 * lie) && (MX % 8 != 2 && MX % 8 != 3) && (MY >= 3 && MY <= 1 + 4 * hang) && (MY % 4 != 2)) {
					hang_test = (MY - 3) / 4;
					lie_test = (MX - 4) / 8;

					if (shuju[hang_test][lie_test] != 0) {
						flag = true;
					}
					else
						flag = false;
				}
				else {
					flag = false;
				}

				if (flag) {
					hang_new = (MY - 3) / 4;
					lie_new = (MX - 4) / 8;

					if (hang_new != hang_old || lie_new != lie_old) {
						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}
					else {
						hang_old = hang_new;
						lie_old = lie_new;

						qishi_x = 4 + lie_old * (6 + 2 * fenge);
						qishi_y = 3 + hang_old * (3 + fenge);
						edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);
					}

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                   ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]%c行%d列                                                   ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

				}
				else {
					qishi_x = 4 + lie_old * (6 + 2 * fenge);
					qishi_y = 3 + hang_old * (3 + fenge);
					edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 1);

					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "[当前鼠标]" << "位置非法                                                          ";*/
					sprintf_s(zhuangtailan, "[当前鼠标]位置非法                                                          ");
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);
				}
			}

			// 检查鼠标按键事件
			if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
				if (flag) {
					/*cct_gotoxy(0, tishi_weizhi_y);
					cout << "选中了" << (char)('A' + hang_old) << "行" << lie_old << "列                                                    ";*/
					sprintf_s(zhuangtailan, "选中了%c行%d列                                                    ", 'A' + hang_old, lie_old);
					print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

					bool kefou_xiaochu = chazhao_jieguo(hang_old, lie_old, hang, lie, shuju, jieguo);

					if (kefou_xiaochu == 1) {
						for (int i = 0; i < hang; i++) {
							for (int j = 0; j < lie; j++) {
								if (jieguo[i][j] > 0) {
									qishi_x = 4 + j * (6 + 2 * fenge);
									qishi_y = 3 + i * (3 + fenge);
									edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 2);
								}
							}
						}
						/*cct_gotoxy(0, tishi_weizhi_y);
						cout << "箭头键/鼠标移动取消当前选择, 回车键/单击左键合成                                          ";*/
						sprintf_s(zhuangtailan, "箭头键/鼠标移动取消当前选择, 回车键/单击左键合成                                          ");
						print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

					}
					else {
						/*cct_gotoxy(0, tishi_weizhi_y);
						cct_setcolor(0, COLOR_HYELLOW);
						cout << "周围无相同值,";
						cct_setcolor();
						cout << "箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束                                            ";*/
						sprintf_s(zhuangtailan, "周围无相同值! 箭头键/鼠标移动, 回车键/单击左键选择, Q/单击右键结束                                            ");
						print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

					}

					while (6) {
						event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);
						if (event == CCT_KEYBOARD_EVENT) {
							if (keycode1 == 0xe0) {
								for (int i = 0; i < hang; i++) {
									for (int j = 0; j < lie; j++) {
										if (jieguo[i][j] > 0) {
											qishi_x = 4 + j * (6 + 2 * fenge);
											qishi_y = 3 + i * (3 + fenge);
											edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
											jieguo[i][j] = 0;
										}
									}
								}

								if (keycode2 == KB_ARROW_UP) {
									hang_old = (hang_old + hang - 1) % hang;
									while (shuju[hang_old][lie_old] == 0) {
										hang_old = (hang_old + hang - 1) % hang;
									}
								}
								else if (keycode2 == KB_ARROW_DOWN) {
									hang_old = (hang_old + 1) % hang;
									while (shuju[hang_old][lie_old] == 0) {
										hang_old = (hang_old + 1) % hang;
									}
								}
								else if (keycode2 == KB_ARROW_LEFT) {
									lie_old = (lie_old + lie - 1) % lie;
									while (shuju[hang_old][lie_old] == 0) {
										lie_old = (lie_old + lie - 1) % lie;
									}
								}
								else if (keycode2 == KB_ARROW_RIGHT) {
									lie_old = (lie_old + 1) % lie;
									while (shuju[hang_old][lie_old] == 0) {
										lie_old = (lie_old + 1) % lie;
									}
								}

								qishi_x = 4 + lie_old * (6 + 2 * fenge);
								qishi_y = 3 + hang_old * (3 + fenge);
								edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

								/*cct_gotoxy(0, tishi_weizhi_y);
								cout << "[当前键盘]" << (char)('A' + hang_old) << "行" << lie_old << "列                                                    ";*/
								sprintf_s(zhuangtailan, "[当前键盘]%c行%d列                                                    ", 'A' + hang_old, lie_old);
								print_zhuangtailan(0, tishi_weizhi_y, zhuangtailan);

								break;
							}
							else if (keycode1 == 0x0d) {
								if (kefou_xiaochu == 1) {
									return;
								}
								else {
									continue;
								}
							}
							else if (keycode1 == 81 || keycode1 == 113) {
								tuichu = true;
								return;
							}
						}
						else if (event == CCT_MOUSE_EVENT) {
							if (fenge == 0) {
								if (MX < 4 || MX>3 + 6 * lie || MY < 3 || MY>2 + 3 * hang) {
									flag = false;
								}
								else
									flag = true;

								if (flag) {
									hang_new = (MY - 3) / 3;
									lie_new = (MX - 4) / 6;

									if (hang_new != hang_old || lie_new != lie_old) {
										for (int i = 0; i < hang; i++) {
											for (int j = 0; j < lie; j++) {
												if (jieguo[i][j] > 0) {
													qishi_x = 4 + j * (6 + 2 * fenge);
													qishi_y = 3 + i * (3 + fenge);
													edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
													jieguo[i][j] = 0;
												}
											}
										}

										hang_old = hang_new;
										lie_old = lie_new;

										qishi_x = 4 + lie_old * (6 + 2 * fenge);
										qishi_y = 3 + hang_old * (3 + fenge);
										edit_tuxing(shuju[hang_old][lie_old], qishi_x, qishi_y, 2, 3, 6, "★", 2);

										break;
									}
								}
								else {
									for (int i = 0; i < hang; i++) {
										for (int j = 0; j < lie; j++) {
											if (jieguo[i][j] > 0) {
												qishi_x = 4 + j * (6 + 2 * fenge);
												qishi_y = 3 + i * (3 + fenge);
												edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
												jieguo[i][j] = 0;
											}
										}
									}

									break;
								}
							}
							else if (fenge == 1) {
								if ((MX >= 4 && MX <= 1 + 8 * lie) && (MX % 8 != 2 && MX % 8 != 3) && (MY >= 3 && MY <= 1 + 4 * hang) && (MY % 4 != 2)) {
									flag = true;
								}
								else {
									flag = false;
								}

								if (flag) {
									;
								}
								else {
									for (int i = 0; i < hang; i++) {
										for (int j = 0; j < lie; j++) {
											if (jieguo[i][j] > 0) {
												qishi_x = 4 + j * (6 + 2 * fenge);
												qishi_y = 3 + i * (3 + fenge);
												edit_tuxing(shuju[i][j], qishi_x, qishi_y, 2, 3, 6, "★", 1);
												jieguo[i][j] = 0;
											}
										}
									}

									break;
								}
							}

							if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
								if (kefou_xiaochu == 1) {
									return;
								}
								else {
									continue;
								}
							}
						}
					}
				}
			}
			else if (MAction == MOUSE_RIGHT_BUTTON_CLICK) {
				tuichu = true;
				return;
			}
		}
	}
}

void mouse_leftclick_or_keyboard_Enter_or_C(int mode)
{
	int MX, MY, MAction, keycode1, keycode2;  //用于处理键盘和鼠标
	int event;  //记录键盘鼠标事件

	while (6) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, keycode1, keycode2);

		if (event == CCT_KEYBOARD_EVENT) {  //检测到键盘事件
			if (keycode1 == 0x0d && mode == 1) {
				return;
			}
			if ((keycode1 == 67 || keycode1 == 99) && mode == 2) {
				return;
			}
		}

		else if (event == CCT_MOUSE_EVENT) {   //检测到鼠标事件
			if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
				return;
			}
		}
	}
}