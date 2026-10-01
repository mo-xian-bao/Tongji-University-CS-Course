/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <climits>
#include <conio.h>
#include <windows.h>
#include "../include/cmd_console_tools.h"
#include "../include/cmd_gmw_tools.h"
using namespace std;

/* --------------------------------------------------
		此处可以给出需要的静态全局变量（尽可能少，最好没有）、静态全局只读变量/宏定义（个数不限）等
   -------------------------------------------------- */


/* --------------------------------------------------
		此处可以给出需要的内部辅助工具函数
		1、函数名不限，建议为 gmw_inner_* 
		2、个数不限
		3、必须是static函数，确保只在本源文件中使用
   -------------------------------------------------- */
/***************************************************************************
  函数名称：
  功    能：计算cmd窗口大小
  输入参数：
  返 回 值：
  说    明：cmd窗口的大小
            int lines;		//为了给中文输入法提示行及运行结束的提示信息留空间，要求在计算得到的结果基础上
			                 （上下额外空间+上状态栏+列标显示+主区域+下状态栏）+ 4（1中文输入法提示行+3预留空行）
            int cols;
***************************************************************************/
static void gmw_inner_update_consoleborder(CONSOLE_GRAPHICS_INFO* const pCGI)
{
	/* 计算窗口大小 */
	pCGI->lines = (pCGI->row_num * pCGI->CFI.block_high + (pCGI->row_num-1)*pCGI->CFI.separator + 2) + pCGI->extern_up_lines + pCGI->extern_down_lines
				+ 4 + (pCGI->top_status_line ? 1 : 0)+ (pCGI->draw_frame_with_col_no ? 1 : 0) + (pCGI->lower_status_line ? 1 : 0);
	pCGI->cols = (pCGI->col_num * pCGI->CFI.block_width +(pCGI->col_num-1)*pCGI->CFI.separator*2 + 4) + pCGI->extern_left_cols + pCGI->extern_right_cols
		         + (pCGI->draw_frame_with_row_no ? 2 : 0) + 1;
}

/***************************************************************************
  函数名称：
  功    能：计算起始位置
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
static void gmw_inner_update_startxy(CONSOLE_GRAPHICS_INFO* const pCGI)
{
	/* 设置主框架起始坐标 */
	pCGI->start_x = pCGI->extern_left_cols+ (pCGI->draw_frame_with_row_no) * 2;             // 左边留出额外列数
	pCGI->start_y = pCGI->extern_up_lines + (pCGI->top_status_line ? 1 : 0)+ (pCGI->draw_frame_with_col_no);         // 上边留出状态栏

	/* 设置状态栏起始坐标 */
	if (pCGI->top_status_line) {
		pCGI->SLI.top_start_x = pCGI->start_x - (pCGI->draw_frame_with_row_no)*2;
		pCGI->SLI.top_start_y = pCGI->start_y-1-(pCGI->draw_frame_with_col_no);
	}
	if (pCGI->lower_status_line) {
		pCGI->SLI.lower_start_x = pCGI->start_x - (pCGI->draw_frame_with_row_no)*2;
		pCGI->SLI.lower_start_y = pCGI->start_y + (pCGI->row_num * pCGI->CFI.block_high + (pCGI->row_num - 1) * pCGI->CFI.separator + 2);
	}
}

/***************************************************************************
  函数名称：
  功    能：打印列标
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
static void gmw_inner_print_col_no(int col_no, int start_x,int start_y, int bgcolor, int fgcolor)
{
	cct_setcolor(bgcolor, fgcolor);
	cct_gotoxy(start_x, start_y);
	if (col_no > 99) {
		cout << "**";
	}
	else {
		cout << col_no;
	}
	cct_setcolor();
}

/***************************************************************************
  函数名称：
  功    能：打印行号
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
static void gmw_inner_print_row_no(int row_no, int start_x, int start_y, int bgcolor, int fgcolor)
{
	if (row_no >= 0 && row_no < 26) {
		cct_showch(start_x, start_y, row_no + 'A', bgcolor, fgcolor);
	}
	else if (row_no >= 26 && row_no < 52) {
		cct_showch(start_x, start_y, row_no - 26 + 'a', bgcolor, fgcolor);
	}
	else if (row_no >= 52) {
		cct_showch(start_x, start_y, '*', bgcolor, fgcolor);
	}
	cct_setcolor();
}

/***************************************************************************
  函数名称：
  功    能：画色块（给定坐标）
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
static void gmw_inner_draw_block(const CONSOLE_GRAPHICS_INFO* const pCGI, const int block_start_x,const int block_start_y, const int bdi_value, const BLOCK_DISPLAY_INFO* const bdi)
{
	int block_bgcolor;
	int block_fgcolor;
	int index;

	for (index = 0; bdi[index].value != BDI_VALUE_END; index++) {
		if (bdi[index].value == bdi_value) {
			block_bgcolor = (bdi[index].bgcolor == -1) ? pCGI->CFI.bgcolor : bdi[index].bgcolor;
			block_fgcolor = (bdi[index].fgcolor == -1) ? pCGI->CFI.fgcolor : bdi[index].fgcolor;
			break;
		}
	}

	if (bdi_value != BDI_VALUE_BLANK) {

		if (pCGI->CFI.block_width < 6) {
			cct_showstr(block_start_x, block_start_y, "  ", block_bgcolor, block_fgcolor, pCGI->CFI.block_width / 2);
		}
		else {
			cct_showstr(block_start_x, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.top_left : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.h_normal : " "), block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.top_right : " "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		for (int i = 1; i < pCGI->CFI.block_high - 1; i++) {
			cct_showstr(block_start_x, block_start_y + i, (pCGI->CBI.block_border ? pCGI->CBI.v_normal : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y + i, "  ", block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y + i, (pCGI->CBI.block_border ? pCGI->CBI.v_normal : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		if (pCGI->CFI.block_high > 1) {
			cct_showstr(block_start_x, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.lower_left : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.h_normal : " "), block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.lower_right : " "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		if (bdi[index].content != NULL) {
			cct_showstr(block_start_x + pCGI->CFI.block_width / 2 - 1, block_start_y + pCGI->CFI.block_high / 2, bdi[index].content, block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}
		else {  //如果没有设置显示内容，则显示数字
			char number_str[16] = { 0 };
			sprintf(number_str, "%d", bdi_value);
			cct_showstr(block_start_x + (pCGI->CFI.block_width - strlen(number_str)) / 2, block_start_y + pCGI->CFI.block_high / 2, number_str, block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}
	}
	else {
		for (int i = 0; i < pCGI->CFI.block_high; i++) {
			cct_showstr(block_start_x, block_start_y + i, "  ", pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
			Sleep(pCGI->delay_of_draw_block);
		}
	}
}


/* ----------------------------------------------- 
		实现下面给出的函数（函数声明不准动）
   ----------------------------------------------- */
/***************************************************************************
  函数名称：
  功    能：设置游戏主框架的行列数
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int row						：行数(错误则为0，不设上限，人为保证正确性)
			const int col						：列数(错误则为0，不设上限，人为保证正确性)
  返 回 值：
  说    明：1、指消除类游戏的矩形区域的行列值
            2、行列的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_rowcol(CONSOLE_GRAPHICS_INFO *const pCGI, const int row, const int col)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->row_num = row;
	pCGI->col_num = col;

	gmw_inner_update_consoleborder(pCGI);   // 计算窗口大小
	gmw_inner_update_startxy(pCGI);         // 计算起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置整个窗口（含游戏区、附加区在内的整个cmd窗口）的颜色
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const int bg_color					：前景色（缺省COLOR_BLACK）
		   const int fg_color					：背景色（缺省COLOR_WHITE）
		   const bool cascade					：是否级联（缺省为true-级联）
  返 回 值：
  说    明：1、cascade = true时
				同步修改游戏主区域的颜色
				同步修改上下状态栏的正常文本的背景色和前景色，醒目文本的背景色（前景色不变）
			2、不检查颜色值错误及冲突，需要人为保证
				例：颜色非0-15
				    前景色背景色的值一致导致无法看到内容
					前景色正好是状态栏醒目前景色，导致无法看到醒目提示
					...
***************************************************************************/
int gmw_set_color(CONSOLE_GRAPHICS_INFO *const pCGI, const int bgcolor, const int fgcolor, const bool cascade)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->area_bgcolor = bgcolor;
	pCGI->area_fgcolor = fgcolor;
	cct_setcolor(pCGI->area_bgcolor,pCGI->area_fgcolor);
	cct_cls();

	// 级联修改
	if (cascade) {   
		/* 同步修改游戏主区域的颜色 */
		pCGI->CFI.bgcolor = bgcolor;
		pCGI->CFI.fgcolor = fgcolor;
        /* 同步修改上下状态栏的正常文本的背景色和前景色，醒目文本的背景色（前景色不变） */
		if (pCGI->top_status_line) {
			pCGI->SLI.top_normal_bgcolor = bgcolor;
			pCGI->SLI.top_normal_fgcolor = fgcolor;
			pCGI->SLI.top_catchy_bgcolor = bgcolor;
		}
		if (pCGI->lower_status_line) {
			pCGI->SLI.lower_normal_bgcolor = bgcolor;
			pCGI->SLI.lower_normal_fgcolor = fgcolor;
			pCGI->SLI.lower_catchy_bgcolor = bgcolor;
		}
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置窗口的字体
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const char *fontname					：字体名称（只能是"Terminal"和"新宋体"两种，错误则返回-1，不改变字体）
		   const int fs_high					：字体高度（缺省及错误为16，不设其它限制，人为保证）
		   const int fs_width					：字体高度（缺省及错误为8，不设其它限制，人为保证）
  返 回 值：
  说    明：1、与cmd_console_tools中的setfontsize相似，目前只支持“点阵字体”和“新宋体”
            2、若设置其它字体则直接返回，保持原字体设置不变
***************************************************************************/
int gmw_set_font(CONSOLE_GRAPHICS_INFO *const pCGI, const char *fontname, const int fs_high, const int fs_width)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->CFT.font_size_high = fs_high<0 ? 16 : fs_high;
	pCGI->CFT.font_size_width = fs_width<0 ? 8 : fs_width;

	if (strcmp(fontname, "Terminal") == 0) {
		strcpy(pCGI->CFT.font_type, fontname);
		cct_setfontsize(pCGI->CFT.font_type, fs_high, fs_width);
	}
	else if (strcmp(fontname, "新宋体") == 0) {
		strcpy(pCGI->CFT.font_type, fontname);
		cct_setfontsize(pCGI->CFT.font_type, fs_high);
	}
	else {
		return -1;
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置延时
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const int type						：延时的类型（目前为3种）
		   const int delay_ms					：以ms为单位的延时
			   画边框的延时：0 ~ 不设上限，人为保证正确（<0则置0）
			   画色块的延时：0 ~ 不设上限，人为保证正确（<0则置0）
			   色块移动的延时：BLOCK_MOVED_DELAY_MS ~ 不设上限，人为保证正确（ <BLOCK_MOVED_DELAY_MS 则置 BLOCK_MOVED_DELAY_MS）
  返 回 值：
  说    明：
***************************************************************************/
int gmw_set_delay(CONSOLE_GRAPHICS_INFO *const pCGI, const int type, const int delay_ms)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	if (type == DELAY_OF_DRAW_FRAME) {
		pCGI->delay_of_draw_frame = delay_ms < 0 ? 0 : delay_ms;
	}
	else if (type == DELAY_OF_DRAW_BLOCK) {
		pCGI->delay_of_draw_block = delay_ms < 0 ? 0 : delay_ms;
	}
	else if (type == DELAY_OF_BLOCK_MOVED) {
		pCGI->delay_of_block_moved = delay_ms < BLOCK_MOVED_DELAY_MS ? BLOCK_MOVED_DELAY_MS : delay_ms;
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  输入参数：设置游戏主框架结构之外需要保留的额外区域
  功    能：CONSOLE_GRAPHICS_INFO *const pCGI	：BLOCK_MOVED_DELAY_MSBLOCK_MOVED_DELAY_MS2
		   const int up_lines					：上部额外的行（缺省及错误为0，不设上限，人为保证）
		   const int down_lines				：下部额外的行（缺省及错误为0，不设上限，人为保证）
		   const int left_cols					：左边额外的列（缺省及错误为0，不设上限，人为保证）
		   const int right_cols				：右边额外的列（缺省及错误为0，不设上限，人为保证）
  返 回 值：
  说    明：额外行列的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_ext_rowcol(CONSOLE_GRAPHICS_INFO *const pCGI, const int up_lines, const int down_lines, const int left_cols, const int right_cols)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->extern_up_lines = up_lines < 0 ? 0 : up_lines;
	pCGI->extern_down_lines = down_lines < 0 ? 0 : down_lines;
	pCGI->extern_left_cols = left_cols < 0 ? 0 : left_cols;
	pCGI->extern_right_cols = right_cols < 0 ? 0 : right_cols;

	gmw_inner_update_consoleborder(pCGI);   // 计算窗口大小
	gmw_inner_update_startxy(pCGI);         // 计算起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_FRAME_TYPE 结构中的11种线型（缺省4种）
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int type						：1 - 全双线 2 - 全单线 3 - 横双竖单 4 - 横单竖双
  返 回 值：
  说    明：
***************************************************************************/
int gmw_set_frame_default_linetype(CONSOLE_GRAPHICS_INFO *const pCGI, const int type)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	const char special[][3] = { "╔", "╚", "╗", "╝", "═", "║", "╦", "╩", "╠", "╣", "╬",
							"┏", "┗", "┓", "┛", "━", "┃", "┳", "┻", "┣", "┫", "╋",
							"╒", "╘", "╕", "╛", "═", "│", "╤", "╧", "╞", "╡", "╪",
							"╓", "╙", "╖", "╜", "─", "║", "╥", "╨", "╟", "╢", "╫",
							NULL
	};

	strcpy(pCGI->CFI.top_left, special[(type - 1) * 11]);
	strcpy(pCGI->CFI.lower_left, special[(type - 1) * 11 + 1]);
	strcpy(pCGI->CFI.top_right, special[(type - 1) * 11 + 2]);
	strcpy(pCGI->CFI.lower_right, special[(type - 1) * 11 + 3]);
	strcpy(pCGI->CFI.h_normal, special[(type - 1) * 11 + 4]);
	strcpy(pCGI->CFI.v_normal, special[(type - 1) * 11 + 5]);
	strcpy(pCGI->CFI.h_top_separator, special[(type - 1) * 11 + 6]);
	strcpy(pCGI->CFI.h_lower_separator, special[(type - 1) * 11 + 7]);
	strcpy(pCGI->CFI.v_left_separator, special[(type - 1) * 11 + 8]);
	strcpy(pCGI->CFI.v_right_separator, special[(type - 1) * 11 + 9]);
	strcpy(pCGI->CFI.mid_separator, special[(type - 1) * 11 + 10]);

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_FRAME_TYPE 结构中的11种线型
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const char *...						：共11种，具体见.h，此处略
  返 回 值：
  说    明：约定为一个中文制表符，可以使用其它内容，人为保证2字节
			1、超过2字节则只取前2字节
			2、如果给NULL，用两个空格替代
			3、如果给1字节，则补一个空格，如果因此而导致显示乱，不算错
***************************************************************************/
int gmw_set_frame_linetype(CONSOLE_GRAPHICS_INFO *const pCGI, const char *top_left, const char *lower_left, const char *top_right,
	const char *lower_right, const char *h_normal, const char *v_normal, const char *h_top_separator,
	const char *h_lower_separator, const char *v_left_separator, const char *v_right_separator, const char *mid_separator)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	if (top_left)
		if (strlen(top_left) >= 2) {
			strncpy(pCGI->CFI.top_left, top_left, 2);
			pCGI->CFI.top_left[2] = '\0';
		}
		else {
			pCGI->CFI.top_left[0] = top_left[0];
			strcpy(pCGI->CFI.top_left + 1, " ");
		}
	else
		strcpy(pCGI->CFI.top_left, "  ");

	if (lower_left)
		if (strlen(lower_left) >= 2) {
			strncpy(pCGI->CFI.lower_left, lower_left, 2);
			pCGI->CFI.lower_left[2] = '\0';
		}
		else {
			pCGI->CFI.lower_left[0] = lower_left[0];
			strcpy(pCGI->CFI.lower_left + 1, " ");
		}
	else
		strcpy(pCGI->CFI.lower_left, "  ");

	if (top_right)
		if (strlen(top_right) >= 2) {
			strncpy(pCGI->CFI.top_right, top_right, 2);
			pCGI->CFI.top_right[2] = '\0';
		}
		else {
			pCGI->CFI.top_right[0] = top_right[0];
			strcpy(pCGI->CFI.top_right + 1, " ");
		}
	else
		strcpy(pCGI->CFI.top_right, "  ");

	if (lower_right)
		if (strlen(lower_right) >= 2) {
			strncpy(pCGI->CFI.lower_right, lower_right, 2);
			pCGI->CFI.lower_right[2] = '\0';
		}
		else {
			pCGI->CFI.lower_right[0] = lower_right[0];
			strcpy(pCGI->CFI.lower_right + 1, " ");
		}
	else
		strcpy(pCGI->CFI.lower_right, "  ");

	if (h_normal)
		if (strlen(h_normal) >= 2) {
			strncpy(pCGI->CFI.h_normal, h_normal, 2);
			pCGI->CFI.h_normal[2] = '\0';
		}
		else {
			pCGI->CFI.h_normal[0] = h_normal[0];
			strcpy(pCGI->CFI.h_normal + 1, " ");
		}
	else
		strcpy(pCGI->CFI.h_normal, "  ");

	if (v_normal)
		if (strlen(v_normal) >= 2) {
			strncpy(pCGI->CFI.v_normal, v_normal, 2);
			pCGI->CFI.v_normal[2] = '\0';
		}
		else {
			pCGI->CFI.v_normal[0] = v_normal[0];
			strcpy(pCGI->CFI.v_normal + 1, " ");
		}
	else
		strcpy(pCGI->CFI.v_normal, "  ");

	if (h_top_separator)
		if (strlen(h_top_separator) >= 2) {
			strncpy(pCGI->CFI.h_top_separator, h_top_separator, 2);
			pCGI->CFI.h_top_separator[2] = '\0';
		}
		else {
			pCGI->CFI.h_top_separator[0] = h_top_separator[0];
			strcpy(pCGI->CFI.h_top_separator + 1, " ");
		}
	else
		strcpy(pCGI->CFI.h_top_separator, "  ");

	if (h_lower_separator)
		if (strlen(h_lower_separator) >= 2) {
			strncpy(pCGI->CFI.h_lower_separator, h_lower_separator, 2);
			pCGI->CFI.h_lower_separator[2] = '\0';
		}
		else {
			pCGI->CFI.h_lower_separator[0] = h_lower_separator[0];
			strcpy(pCGI->CFI.h_lower_separator + 1, " ");
		}
	else
		strcpy(pCGI->CFI.h_lower_separator, "  ");

	if (v_left_separator)
		if (strlen(v_left_separator) >= 2) {
			strncpy(pCGI->CFI.v_left_separator, v_left_separator, 2);
			pCGI->CFI.v_left_separator[2] = '\0';
		}
		else {
			pCGI->CFI.v_left_separator[0] = v_left_separator[0];
			strcpy(pCGI->CFI.v_left_separator + 1, " ");
		}
	else
		strcpy(pCGI->CFI.v_left_separator, "  ");

	if (v_right_separator)
		if (strlen(v_right_separator) >= 2) {
			strncpy(pCGI->CFI.v_right_separator, v_right_separator, 2);
			pCGI->CFI.v_right_separator[2] = '\0';
		}
		else {
			pCGI->CFI.v_right_separator[0] = v_right_separator[0];
			strcpy(pCGI->CFI.v_right_separator + 1, " ");
		}
	else
		strcpy(pCGI->CFI.v_right_separator, "  ");

	if (mid_separator)
		if (strlen(mid_separator) >= 2) {
			strncpy(pCGI->CFI.mid_separator, mid_separator, 2);
			pCGI->CFI.mid_separator[2] = '\0';
		}
		else {
			pCGI->CFI.mid_separator[0] = mid_separator[0];
			strcpy(pCGI->CFI.mid_separator + 1, " ");
		}
	else
		strcpy(pCGI->CFI.mid_separator, "  ");

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_FRAME_TYPE 结构中的色块数量大小、是否需要分隔线等
  输入参数：输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int block_width						：宽度（错误及缺省2，因为约定表格线为中文制表符，如果给出奇数，要+1）
			const int block_high						：高度（错误及缺省1）
			const bool separator						：是否需要分隔线（缺省为true，需要分隔线）
  返 回 值：
  说    明：框架大小/是否需要分隔线等的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_frame_style(CONSOLE_GRAPHICS_INFO *const pCGI, const int block_width, const int block_high, const bool separator)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->CFI.block_width = block_width < 0 ? 2 : block_width;
	pCGI->CFI.block_width = (pCGI->CFI.block_width + 1) & 0xfe; // 保证为偶数
	pCGI->CFI.block_high = block_high < 0 ? 1 : block_high;
	pCGI->CFI.separator = separator;

	gmw_inner_update_consoleborder(pCGI);   // 计算窗口大小
	gmw_inner_update_startxy(pCGI);         // 计算起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_BORDER_TYPE 结构中的颜色
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int bg_color					：背景色（缺省 -1表示用窗口背景色）
			const int fg_color					：前景色（缺省 -1表示用窗口前景色）
  返 回 值：
  说    明：不检查颜色值错误及冲突，需要人为保证
				例：颜色非0-15，前景色背景色的值一致导致无法看到内容等
***************************************************************************/
int gmw_set_frame_color(CONSOLE_GRAPHICS_INFO *const pCGI, const int bgcolor, const int fgcolor)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->CFI.bgcolor = bgcolor;
	pCGI->CFI.fgcolor = fgcolor;

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_BLOCK_INFO 结构中的6种线型（缺省4种）
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int type						：1 - 全双线 2 - 全单线 3 - 横双竖单 4 - 横单竖双
  返 回 值：
  说    明：
***************************************************************************/
int gmw_set_block_default_linetype(CONSOLE_GRAPHICS_INFO *const pCGI, const int type)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	const char special[][3] = {"╔", "╚", "╗", "╝", "═", "║", "╦", "╩", "╠", "╣", "╬",
							"┏", "┗", "┓", "┛", "━", "┃", "┳", "┻", "┣", "┫", "╋",
							"╒", "╘", "╕", "╛", "═", "│", "╤", "╧", "╞", "╡", "╪",
							"╓", "╙", "╖", "╜", "─", "║", "╥", "╨", "╟", "╢", "╫",
							NULL
	};
	strcpy(pCGI->CBI.top_left, special[(type-1)*11]);
	strcpy(pCGI->CBI.lower_left, special[(type-1)*11+1]);
	strcpy(pCGI->CBI.top_right, special[(type-1)*11+2]);
	strcpy(pCGI->CBI.lower_right, special[(type-1)*11+3]);
	strcpy(pCGI->CBI.h_normal, special[(type - 1) * 11 + 4]);
	strcpy(pCGI->CBI.v_normal, special[(type - 1) * 11 + 5]);

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：填充 CONSOLE_BLOCK_INFO 结构中的6种线型
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const char *...					：共6种，具体见.h，此处略
  返 回 值：
  说    明：约定为一个中文制表符，可以使用其它内容，人为保证2字节
			1、超过2字节则只取前2字节
			2、如果给NULL，用两个空格替代
			3、如果给1字节，则补一个空格，如果因此而导致显示乱，不算错
***************************************************************************/
int gmw_set_block_linetype(CONSOLE_GRAPHICS_INFO *const pCGI, const char *top_left, const char *lower_left, const char *top_right, const char *lower_right, const char *h_normal, const char *v_normal)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	if (top_left)
		if (strlen(top_left) >= 2) {
			strncpy(pCGI->CBI.top_left, top_left, 2);
			pCGI->CBI.top_left[2] = '\0';
		}
		else {
			pCGI->CBI.top_left[0] = top_left[0];
			strcpy(pCGI->CBI.top_left + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.top_left, "  ");

	if (lower_left)
		if (strlen(lower_left) >= 2) {
			strncpy(pCGI->CBI.lower_left, lower_left, 2);
			pCGI->CBI.lower_left[2] = '\0';
		}
		else {
			pCGI->CBI.lower_left[0] = lower_left[0];
			strcpy(pCGI->CBI.lower_left + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.lower_left, "  ");

	if (top_right)
		if (strlen(top_right) >= 2) {
			strncpy(pCGI->CBI.top_right, top_right, 2);
			pCGI->CBI.top_right[2] = '\0';
		}
		else {
			pCGI->CBI.top_right[0] = top_right[0];
			strcpy(pCGI->CBI.top_right + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.top_right, "  ");

	if (lower_right)
		if (strlen(lower_right) >= 2) {
			strncpy(pCGI->CBI.lower_right, lower_right, 2);
			pCGI->CBI.lower_right[2] = '\0';
		}
		else {
			pCGI->CBI.lower_right[0] = lower_right[0];
			strcpy(pCGI->CBI.lower_right + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.lower_right, "  ");

	if (h_normal)
		if (strlen(h_normal) >= 2) {
			strncpy(pCGI->CBI.h_normal, h_normal, 2);
			pCGI->CBI.h_normal[2] = '\0';
		}
		else {
			pCGI->CBI.h_normal[0] = h_normal[0];
			strcpy(pCGI->CBI.h_normal + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.h_normal, "  ");

	if (v_normal)
		if (strlen(v_normal) >= 2) {
			strncpy(pCGI->CBI.v_normal, v_normal, 2);
			pCGI->CBI.v_normal[2] = '\0';
		}
		else {
			pCGI->CBI.v_normal[0] = v_normal[0];
			strcpy(pCGI->CBI.v_normal + 1, " ");
		}
	else 
		strcpy(pCGI->CBI.v_normal, "  ");
	
	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置每个游戏色块(彩球)是否需要小边框
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const bool on_off					：true - 需要 flase - 不需要（缺省false）
  返 回 值：
  说    明：边框约定为中文制表符，双线
***************************************************************************/
int gmw_set_block_border_switch(CONSOLE_GRAPHICS_INFO *const pCGI, const bool on_off)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->CBI.block_border = on_off;

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置是否显示上下状态栏
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int type						：状态栏类型（上/下）
			const bool on_off					：true - 需要 flase - 不需要（缺省true）
  返 回 值：
  说    明：1、状态栏的相关约定如下：
			   1.1、上状态栏只能一行，在主区域最上方框线/列标的上面，为主区域的最开始一行（主区域的左上角坐标就是上状态栏的坐标）
			   1.2、下状态栏只能一行，在主区域最下方框线的下面
			   1.3、状态栏的宽度为主区域宽度，如果信息过长则截断
		   2、行列的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_status_line_switch(CONSOLE_GRAPHICS_INFO *const pCGI, const int type, const bool on_off)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	if (type == TOP_STATUS_LINE){
		pCGI->top_status_line = on_off;
		pCGI->SLI.is_top_status_line = on_off;
	}
	else{  //(type == LOWER_STATUS_LINE)
		pCGI->lower_status_line = on_off;
		pCGI->SLI.is_lower_status_line = on_off;
	}

	gmw_inner_update_consoleborder(pCGI); //更新窗口大小
	gmw_inner_update_startxy(pCGI);       //更新起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置上下状态栏的颜色
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const int type						：状态栏类型（上/下）
			const int normal_bgcolor			：正常文本背景色（缺省 -1表示使用窗口背景色）
			const int normal_fgcolor			：正常文本前景色（缺省 -1表示使用窗口前景色）
			const int catchy_bgcolor			：醒目文本背景色（缺省 -1表示使用窗口背景色）
			const int catchy_fgcolor			：醒目文本前景色（缺省 -1表示使用亮黄色）
  输入参数：
  返 回 值：
  说    明：不检查颜色值错误及冲突，需要人为保证
				例：颜色非0-15，前景色背景色的值一致导致无法看到内容等
***************************************************************************/
int gmw_set_status_line_color(CONSOLE_GRAPHICS_INFO *const pCGI, const int type, const int normal_bgcolor, const int normal_fgcolor, const int catchy_bgcolor, const int catchy_fgcolor)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	if (type == TOP_STATUS_LINE) {
		pCGI->SLI.top_normal_bgcolor = (normal_bgcolor==-1) ? pCGI->area_bgcolor : normal_bgcolor;
		pCGI->SLI.top_normal_fgcolor = (normal_fgcolor==-1) ? pCGI->area_fgcolor : normal_fgcolor;
		pCGI->SLI.top_catchy_bgcolor = (catchy_bgcolor==-1) ? pCGI->area_bgcolor : catchy_bgcolor;
		pCGI->SLI.top_catchy_fgcolor = (catchy_fgcolor==-1) ? COLOR_HYELLOW : catchy_fgcolor;
	}
	else if(type == LOWER_STATUS_LINE) {
		pCGI->SLI.lower_normal_bgcolor = (normal_bgcolor==-1) ? pCGI->area_bgcolor : normal_bgcolor;
		pCGI->SLI.lower_normal_fgcolor = (normal_fgcolor==-1) ? pCGI->area_fgcolor : normal_fgcolor;
		pCGI->SLI.lower_catchy_bgcolor = (catchy_bgcolor==-1) ? pCGI->area_bgcolor : catchy_bgcolor;
		pCGI->SLI.lower_catchy_fgcolor = (catchy_fgcolor==-1) ? COLOR_HYELLOW : catchy_fgcolor;
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置是否显示行号
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const bool on_off					：true - 显示 flase - 不显示（缺省false）
  返 回 值：
  说    明：1、行号约定为字母A开始连续排列（如果超过26，则从a开始，超过52的统一为*，实际应用不可能）
            2、是否显示行号的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_rowno_switch(CONSOLE_GRAPHICS_INFO *const pCGI, const bool on_off)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->draw_frame_with_row_no = on_off;

	gmw_inner_update_consoleborder(pCGI); //更新窗口大小
	gmw_inner_update_startxy(pCGI);       //更新起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：设置是否显示列标
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
			const bool on_off					：true - 显示 flase - 不显示（缺省false）
  返 回 值：
  说    明：1、列标约定为数字0开始连续排列（数字0-99，超过99统一为**，实际应用不可能）
            2、是否显示列标的变化会导致CONSOLE_GRAPHICS_INFO结构体中其它成员值的变化，要处理
***************************************************************************/
int gmw_set_colno_switch(CONSOLE_GRAPHICS_INFO *const pCGI, const bool on_off)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	pCGI->draw_frame_with_col_no = on_off;

	gmw_inner_update_consoleborder(pCGI); //更新窗口大小
	gmw_inner_update_startxy(pCGI);       //更新起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：打印 CONSOLE_GRAPHICS_INFO 结构体中的各成员值
  输入参数：
  返 回 值：
  说    明：1、仅供调试用，打印格式自定义
            2、本函数测试用例中未调用过，可以不实现
***************************************************************************/
int gmw_print(const CONSOLE_GRAPHICS_INFO *const pCGI)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：将 CONSOLE_GRAPHICS_INFO 结构体用缺省值进行初始化
  输入参数：CONSOLE_GRAPHICS_INFO *const pCGI：整体结构指针
		   const int row					：游戏区域色块行数（缺省10）
		   const int col					：游戏区域色块列数（缺省10）
		   const int bgcolor				：整个窗口背景色（缺省 COLOR_BLACK）
		   const int fgcolor				：整个窗口背景色（缺省 COLOR_WHITE）
  返 回 值：
  说    明：窗口背景黑/前景白，点阵16*8，上下左右无额外行列，上下状态栏均有，无行号/列标，框架线型为双线，色块宽度2/高度1/无小边框，颜色略
***************************************************************************/
int gmw_init(CONSOLE_GRAPHICS_INFO *const pCGI, const int row, const int col, const int bgcolor, const int fgcolor)
{
	/* 首先置标记 */
	pCGI->inited = CGI_INITED;

	/* 初始化窗口信息 */
	gmw_set_ext_rowcol(pCGI, 0, 0, 0, 0);     // 初始化扩展行列
	gmw_set_rowcol(pCGI, row, col);           // 游戏主框架区域色块行列数
	gmw_set_color(pCGI, bgcolor, fgcolor);     // 设置窗口颜色

	/* 初始化主框架 */
	gmw_set_frame_style(pCGI, 2, 1, true);  //宽度2/高度1/有分隔线
	gmw_set_rowno_switch(pCGI, false);     // 不显示行号
	gmw_set_colno_switch(pCGI, false);     // 不显示列标
	gmw_set_frame_linetype(pCGI, "╔", "╚", "╗", "╝", "═", "║", "╦", "╩", "╠", "╣", "╬"); //设置框架线型为全双线

	/* 初始化色块 */
	gmw_set_block_border_switch(pCGI, false);      // 色块没有边框
	gmw_set_block_default_linetype(pCGI, 1);

	/* 初始化状态栏 */
	gmw_set_status_line_switch(pCGI, TOP_STATUS_LINE, true);  // 需要上状态栏
	gmw_set_status_line_switch(pCGI, LOWER_STATUS_LINE, true);  // 需要下状态栏
	gmw_set_status_line_color(pCGI, TOP_STATUS_LINE, -1);    //设置上状态栏颜色
	gmw_set_status_line_color(pCGI, LOWER_STATUS_LINE, -1);  //设置下状态栏颜色

	/* 初始化延时 */
	gmw_set_delay(pCGI, DELAY_OF_DRAW_FRAME, 0);
	gmw_set_delay(pCGI, DELAY_OF_DRAW_BLOCK, 0);
	gmw_set_delay(pCGI, DELAY_OF_BLOCK_MOVED, 3);

	gmw_set_font(pCGI, "新宋体", 16, 8);                     //设置字体
	gmw_inner_update_consoleborder(pCGI);					 //更新窗口大小
	gmw_inner_update_startxy(pCGI);							 //更新起始坐标

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：画主游戏框架
  输入参数：const CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
  返 回 值：
  说    明：具体可参考demo的效果
***************************************************************************/
int gmw_draw_frame(const CONSOLE_GRAPHICS_INFO *const pCGI)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	cct_setconsoleborder(pCGI->cols, pCGI->lines); //设置窗口大小

	if (pCGI->CFI.separator) { //有分隔线
		if (pCGI->draw_frame_with_col_no) { //显示列标
			for (int i = 0; i < pCGI->col_num; i++) {
				gmw_inner_print_col_no(i, pCGI->start_x + (pCGI->CFI.block_width + 2) / 2 + i * (pCGI->CFI.block_width + 2), pCGI->start_y - 1, pCGI->area_bgcolor, pCGI->area_fgcolor);
			}
		}

		cct_showstr(pCGI->start_x, pCGI->start_y, pCGI->CFI.top_left, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		for (int j = 0; j < pCGI->col_num - 1; j++) {
			cct_showstr(pCGI->start_x + 2 + j * (pCGI->CFI.block_width+2), pCGI->start_y, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width/2);
			/*Sleep(pCGI->delay_of_draw_frame);*/
			cct_showstr(pCGI->start_x + 2 + j * (pCGI->CFI.block_width+2)+pCGI->CFI.block_width, pCGI->start_y, pCGI->CFI.h_top_separator, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
		}
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2), pCGI->start_y, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
		/*Sleep(pCGI->delay_of_draw_frame);*/
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2)+ pCGI->CFI.block_width, pCGI->start_y, pCGI->CFI.top_right, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);

		for (int i = 0; i < pCGI->row_num- 1; i++) {
			for (int j = 0; j < pCGI->CFI.block_high; j++) {
				if (pCGI->draw_frame_with_row_no) { //显示行号
					if (j == pCGI->CFI.block_high / 2) {
						/*cct_showch(pCGI->start_x - 2, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + j, i + 'A', pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);*/
						gmw_inner_print_row_no(i, pCGI->start_x - 2, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + j, pCGI->area_bgcolor, pCGI->area_fgcolor);
					}
				}

				cct_showstr(pCGI->start_x, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
				Sleep(pCGI->delay_of_draw_frame);
				for (int m = 0; m < pCGI->col_num; m++) {
					cct_showstr(pCGI->start_x + 2 + m * (pCGI->CFI.block_width+2), pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + j, "  ", pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width/2);
					cct_showstr(pCGI->start_x + 2+pCGI->CFI .block_width + m * (pCGI->CFI.block_width+2), pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
					Sleep(pCGI->delay_of_draw_frame);
				}
			}
			cct_showstr(pCGI->start_x, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + pCGI->CFI.block_high, pCGI->CFI.v_left_separator, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
			for (int m = 0; m < pCGI->col_num - 1; m++) {
				cct_showstr(pCGI->start_x + 2 + m * (pCGI->CFI.block_width + 2), pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + pCGI->CFI.block_high, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
				/*Sleep(pCGI->delay_of_draw_frame);*/
				cct_showstr(pCGI->start_x + 2 + m * (pCGI->CFI.block_width + 2) + pCGI->CFI.block_width, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + pCGI->CFI.block_high, pCGI->CFI.mid_separator, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
				Sleep(pCGI->delay_of_draw_frame);
			}
			cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2), pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + pCGI->CFI.block_high, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
			/*Sleep(pCGI->delay_of_draw_frame);*/
			cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2) + pCGI->CFI.block_width, pCGI->start_y + 1 + i * (pCGI->CFI.block_high + 1) + pCGI->CFI.block_high, pCGI->CFI.v_right_separator, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
		}

		for (int j = 0; j < pCGI->CFI.block_high; j++) {
			if (pCGI->draw_frame_with_row_no) { //显示行号
				if (j == pCGI->CFI.block_high / 2) {
					/*cct_showch(pCGI->start_x - 2, pCGI->start_y + 1 + (pCGI->row_num - 1) * (pCGI->CFI.block_high + 1) + j, pCGI->row_num-1 + 'A', pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);*/
					gmw_inner_print_row_no(pCGI->row_num-1, pCGI->start_x - 2, pCGI->start_y + 1 + (pCGI->row_num - 1) * (pCGI->CFI.block_high + 1) + j, pCGI->area_bgcolor, pCGI->area_fgcolor);
					Sleep(pCGI->delay_of_draw_frame);
				}
			}

			cct_showstr(pCGI->start_x, pCGI->start_y + 1 + (pCGI->row_num - 1) * (pCGI->CFI.block_high + 1) + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
			for (int m = 0; m < pCGI->col_num; m++) {
				cct_showstr(pCGI->start_x + 2 + m * (pCGI->CFI.block_width+2), pCGI->start_y + 1 + (pCGI->row_num - 1) * (pCGI->CFI.block_high + 1) + j, "  ", pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width/2);
				cct_showstr(pCGI->start_x + 2 + pCGI->CFI.block_width + m * (pCGI->CFI.block_width+2), pCGI->start_y + 1 + (pCGI->row_num - 1) * (pCGI->CFI.block_high + 1) + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
				Sleep(pCGI->delay_of_draw_frame);
			}
		}
		cct_showstr(pCGI->start_x, pCGI->start_y + pCGI->row_num * (pCGI->CFI.block_high + 1), pCGI->CFI.lower_left, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		for (int j = 0; j < pCGI->col_num - 1; j++) {
			cct_showstr(pCGI->start_x + 2 + j * (pCGI->CFI.block_width+2), pCGI->start_y + pCGI->row_num * (pCGI->CFI.block_high + 1), pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
			/*Sleep(pCGI->delay_of_draw_frame);*/
			cct_showstr(pCGI->start_x + 2 + j * (pCGI->CFI.block_width+2) + pCGI->CFI.block_width, pCGI->start_y + pCGI->row_num * (pCGI->CFI.block_high + 1), pCGI->CFI.h_lower_separator, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
		}
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2), pCGI->start_y + pCGI->row_num * (pCGI->CFI.block_high + 1), pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, pCGI->CFI.block_width / 2);
		/*Sleep(pCGI->delay_of_draw_frame);*/
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num-1) * (pCGI->CFI.block_width+2) + pCGI->CFI.block_width, pCGI->start_y + pCGI->row_num * (pCGI->CFI.block_high + 1), pCGI->CFI.lower_right, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		cct_setcolor();
	}
	else { //无分隔线
		if (pCGI->draw_frame_with_col_no) { //显示列标
			for (int i = 0; i < pCGI->col_num; i++) {
				/*cct_setcolor(pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
				cct_gotoxy(pCGI->start_x + (pCGI->CFI.block_width + 2) / 2 + i * (pCGI->CFI.block_width), pCGI->start_y - 1);
				cout << i;*/
				gmw_inner_print_col_no(i, pCGI->start_x + (pCGI->CFI.block_width + 2) / 2 + i * (pCGI->CFI.block_width), pCGI->start_y - 1, pCGI->area_bgcolor, pCGI->area_fgcolor);
			}
		}

		cct_showstr(pCGI->start_x, pCGI->start_y, pCGI->CFI.top_left, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		cct_showstr(pCGI->start_x + 2, pCGI->start_y, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, (pCGI->col_num) * pCGI->CFI.block_width/2);
		Sleep(pCGI->delay_of_draw_frame);
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num) * pCGI->CFI.block_width, pCGI->start_y, pCGI->CFI.top_right, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);

		for (int i = 0; i < (pCGI->row_num) * (pCGI->CFI.block_high); i++) {
			if (pCGI->draw_frame_with_row_no) {  //显示行号
				if (i % pCGI->CFI.block_high == pCGI->CFI .block_high / 2) 
					gmw_inner_print_row_no(i / pCGI->CFI.block_high, pCGI->start_x - 2, pCGI->start_y + 1 + i, pCGI->area_bgcolor, pCGI->area_fgcolor);
			}

			cct_showstr(pCGI->start_x, pCGI->start_y + 1 + i, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
			cct_showstr(pCGI->start_x + 2, pCGI->start_y + 1 + i,"  ", pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, (pCGI->col_num)* pCGI->CFI.block_width / 2);
			Sleep(pCGI->delay_of_draw_frame);
			cct_showstr(pCGI->start_x + 2 + (pCGI->col_num) * pCGI->CFI.block_width, pCGI->start_y + 1 + i, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
			Sleep(pCGI->delay_of_draw_frame);
		}

		cct_showstr(pCGI->start_x, pCGI->start_y + 1 + (pCGI->row_num) * (pCGI->CFI.block_high), pCGI->CFI.lower_left, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		cct_showstr(pCGI->start_x + 2, pCGI->start_y + 1 + (pCGI->row_num) * (pCGI->CFI.block_high), pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor, (pCGI->col_num) * pCGI->CFI.block_width/2);
		Sleep(pCGI->delay_of_draw_frame);
		cct_showstr(pCGI->start_x + 2 + (pCGI->col_num) * pCGI->CFI.block_width, pCGI->start_y + 1 + (pCGI->row_num) * (pCGI->CFI.block_high), pCGI->CFI.lower_right, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
		Sleep(pCGI->delay_of_draw_frame);
		cct_setcolor();
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：在状态栏上显示信息
  输入参数：const CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const int type							：指定是上/下状态栏
		   const char *msg						：正常信息
		   const char *catchy_msg					：需要特别标注的信息（在正常信息前显示）
  返 回 值：
  说    明：1、输出宽度限定为主框架的宽度（含行号列标位置），超出则截去
            2、如果最后一个字符是某汉字的前半个，会导致后面乱码，要处理
***************************************************************************/
int gmw_status_line(const CONSOLE_GRAPHICS_INFO *const pCGI, const int type, const char *msg, const char *catchy_msg)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	unsigned int status_line_width = pCGI->draw_frame_with_col_no * 2 + (pCGI->col_num * pCGI->CFI.block_width + (pCGI->col_num - 1) * pCGI->CFI.separator * 2 + 4);
	if (catchy_msg == NULL) {
		char display_msg[256] = { 0 };
		strncpy(display_msg, msg, status_line_width);
		for(unsigned int i=strlen(display_msg); i<status_line_width; i++)
			display_msg[i] = ' ';

		//处理最后一个字符是汉字的前半个
		int count = 0;
		for (int i = status_line_width - 1; display_msg[i] & 0x80; i--) 
			count++;
		if(count%2==1)
			display_msg[status_line_width - 1] = ' ';

		if (type == TOP_STATUS_LINE && pCGI->top_status_line)
			cct_showstr(pCGI->SLI.top_start_x, pCGI->SLI.top_start_y, display_msg, pCGI->SLI.top_normal_bgcolor, pCGI->SLI.top_normal_fgcolor);
		else if (type == LOWER_STATUS_LINE && pCGI->lower_status_line)
			cct_showstr(pCGI->SLI.lower_start_x, pCGI->SLI.lower_start_y, display_msg, pCGI->SLI.lower_normal_bgcolor, pCGI->SLI.lower_normal_fgcolor);
	}
	else {
		char display_catchy_msg[256] = { 0 };
		if (strlen(catchy_msg) >= status_line_width) {
			strncpy(display_catchy_msg, catchy_msg, status_line_width);
			
			//处理最后一个字符是汉字的前半个
			int count = 0;
			for (int i = status_line_width - 1; display_catchy_msg[i] & 0x80; i--) 
				count++;
			if(count%2==1)
				display_catchy_msg[status_line_width - 1] = ' ';

			if (type == TOP_STATUS_LINE && pCGI->top_status_line)
				cct_showstr(pCGI->SLI.top_start_x, pCGI->SLI.top_start_y, display_catchy_msg, pCGI->SLI.top_catchy_bgcolor, pCGI->SLI.top_catchy_fgcolor);
			else if (type == LOWER_STATUS_LINE && pCGI->lower_status_line)
				cct_showstr(pCGI->SLI.lower_start_x, pCGI->SLI.lower_start_y, display_catchy_msg, pCGI->SLI.lower_catchy_bgcolor, pCGI->SLI.lower_catchy_fgcolor);
		}
		else {
			char display_msg[256] = { 0 };
			strncpy(display_catchy_msg, catchy_msg, strlen(catchy_msg));
			strncpy(display_msg, msg, status_line_width - strlen(catchy_msg));
			for (unsigned int i = strlen(display_msg); i < status_line_width - strlen(catchy_msg); i++)
				display_msg[i] = ' ';

			//处理最后一个字符是汉字的前半个
			int count = 0;
			for (int i = status_line_width - strlen(catchy_msg) - 1; display_msg[i] & 0x80; i--) 
				count++;
			if(count%2==1)
				display_msg[status_line_width - strlen(catchy_msg) - 1] = ' ';

			if (type == TOP_STATUS_LINE && pCGI->top_status_line) {
				cct_showstr(pCGI->SLI.top_start_x, pCGI->SLI.top_start_y, display_catchy_msg, pCGI->SLI.top_catchy_bgcolor, pCGI->SLI.top_catchy_fgcolor);
				cct_showstr(pCGI->SLI.top_start_x + strlen(display_catchy_msg), pCGI->SLI.top_start_y, display_msg, pCGI->SLI.top_normal_bgcolor, pCGI->SLI.top_normal_fgcolor);
			}
			else if (type == LOWER_STATUS_LINE && pCGI->lower_status_line) {
				cct_showstr(pCGI->SLI.lower_start_x, pCGI->SLI.lower_start_y, display_catchy_msg, pCGI->SLI.lower_catchy_bgcolor, pCGI->SLI.lower_catchy_fgcolor);
				cct_showstr(pCGI->SLI.lower_start_x + strlen(display_catchy_msg), pCGI->SLI.lower_start_y, display_msg, pCGI->SLI.lower_normal_bgcolor, pCGI->SLI.lower_normal_fgcolor);
			}
		}
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：显示某一个色块(内容为字符串，坐标为row/col)
  输入参数：const CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const int row_no						：行号（从0开始，人为保证正确性，程序不检查）
		   const int col_no						：列号（从0开始，人为保证正确性，程序不检查）
		   const int bdi_value						：需要显示的值
		   const BLOCK_DISPLAY_INFO *const bdi		：存放该值对应的显示信息的结构体数组
  返 回 值：
  说    明：1、BLOCK_DISPLAY_INFO 的含义见头文件，用法参考测试样例
            2、bdi_value为 BDI_VALUE_BLANK 表示空白块，要特殊处理
***************************************************************************/
int gmw_draw_block(const CONSOLE_GRAPHICS_INFO *const pCGI, const int row_no, const int col_no, const int bdi_value, const BLOCK_DISPLAY_INFO *const bdi)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	int block_start_x = pCGI->start_x + 2 + col_no * (pCGI->CFI.block_width + pCGI->CFI.separator * 2);
	int block_start_y = pCGI->start_y + 1 + row_no * (pCGI->CFI.block_high + pCGI->CFI.separator);
	int block_bgcolor=pCGI->area_bgcolor;
	int block_fgcolor=pCGI->area_fgcolor;
	int index;
	
	for (index = 0; bdi[index].value != BDI_VALUE_END; index++) {
		if (bdi[index].value == bdi_value) {
			block_bgcolor = (bdi[index].bgcolor == -1) ? pCGI->CFI.bgcolor : bdi[index].bgcolor;
			block_fgcolor = (bdi[index].fgcolor == -1) ? pCGI->CFI.fgcolor : bdi[index].fgcolor;
			break;
		}
	}

	if (bdi_value != BDI_VALUE_BLANK) {
		if(row_no<0 || row_no>=pCGI->row_num || col_no<0 || col_no>=pCGI->col_num)
			return -1;

		if (pCGI->CFI.block_width < 6) {
			cct_showstr(block_start_x, block_start_y, "  ", block_bgcolor, block_fgcolor, pCGI->CFI.block_width / 2);
		}
		else {
			cct_showstr(block_start_x, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.top_left : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.h_normal : " "), block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y, (pCGI->CBI.block_border ? pCGI->CBI.top_right : " "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		for (int i = 1; i < pCGI->CFI.block_high - 1; i++) {
			cct_showstr(block_start_x, block_start_y + i, (pCGI->CBI.block_border ? pCGI->CBI.v_normal : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y + i, "  ", block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y + i, (pCGI->CBI.block_border ? pCGI->CBI.v_normal : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		if (pCGI->CFI.block_high > 1) {
			cct_showstr(block_start_x, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.lower_left : "  "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.h_normal : " "), block_bgcolor, block_fgcolor, (pCGI->CFI.block_width - 4) / 2);
			Sleep(pCGI->delay_of_draw_block);
			cct_showstr(block_start_x + 2 + pCGI->CFI.block_width - 4, block_start_y + pCGI->CFI.block_high - 1, (pCGI->CBI.block_border ? pCGI->CBI.lower_right : " "), block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}

		if (bdi[index].content != NULL) {
			cct_showstr(block_start_x + pCGI->CFI.block_width / 2 - 1, block_start_y + pCGI->CFI.block_high / 2, bdi[index].content, block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}
		else {  //如果没有设置显示内容，则显示数字
			char number_str[16] = { 0 };
			sprintf(number_str, "%d", bdi_value);
			cct_showstr(block_start_x + (pCGI->CFI.block_width - strlen(number_str)) / 2, block_start_y + pCGI->CFI.block_high / 2, number_str, block_bgcolor, block_fgcolor);
			Sleep(pCGI->delay_of_draw_block);
		}
	}
	else {
		for (int i = 0; i < pCGI->CFI.block_high; i++) {
			cct_showstr(block_start_x, block_start_y + i, "  ", block_bgcolor, block_fgcolor,pCGI->CFI.block_width/2);
			Sleep(pCGI->delay_of_draw_block);
		}
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：移动某一个色块
  输入参数：const CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   const int row_no						：行号（从0开始，人为保证正确性，程序不检查）
		   const int col_no						：列号（从0开始，人为保证正确性，程序不检查）
		   const int bdi_value						：需要显示的值
		   const int blank_bdi_value				：移动过程中用于动画效果显示时用于表示空白的值（一般为0，此处做为参数代入，是考虑到可能出现的特殊情况）
		   const BLOCK_DISPLAY_INFO *const bdi		：存放显示值/空白值对应的显示信息的结构体数组
		   const int direction						：移动方向，一共四种，具体见cmd_gmw_tools.h
		   const int distance						：移动距离（从1开始，人为保证正确性，程序不检查）
  返 回 值：
  说    明：
***************************************************************************/
int gmw_move_block(const CONSOLE_GRAPHICS_INFO *const pCGI, const int row_no, const int col_no, const int bdi_value, const int blank_bdi_value, const BLOCK_DISPLAY_INFO *const bdi, const int direction, const int distance)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;
	//移动方向上下左右分别为0 1 2 3

	int row=row_no;
	int col=col_no;

	for (int k = 0; k < distance; k++) {
		int block_start_x = pCGI->start_x + 2 + col * (pCGI->CFI.block_width + pCGI->CFI.separator * 2);
		int block_start_y = pCGI->start_y + 1 + row * (pCGI->CFI.block_high + pCGI->CFI.separator);

		if (direction == 0 || direction == 1) {  //上下移动
			for (int i = 0; i < pCGI->CFI.block_high + pCGI->CFI.separator; i++) {
				if (direction == 0) {  //上移
					gmw_inner_draw_block(pCGI, block_start_x, block_start_y - i, blank_bdi_value, bdi);   //将当前位置的块显示为空白块
					gmw_inner_draw_block(pCGI, block_start_x, block_start_y - i - 1, bdi_value, bdi);  //将下一个位置的块显示为当前块的值
					Sleep(pCGI->delay_of_block_moved);
				}
				else {  //下移
					gmw_inner_draw_block(pCGI, block_start_x, block_start_y + i, blank_bdi_value, bdi);   //将当前位置的块显示为空白块
					gmw_inner_draw_block(pCGI, block_start_x, block_start_y + i + 1, bdi_value, bdi);  //将下一个位置的块显示为当前块的值
					Sleep(pCGI->delay_of_block_moved);
				}
			}
			if (pCGI->CFI.separator) {  //如果有分隔线
				if (direction == 0) {  //上移
					cct_showstr(block_start_x, block_start_y - 1, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor,pCGI->CFI.block_width/2);
				}
				else {  //下移
					cct_showstr(block_start_x, block_start_y + pCGI->CFI.block_high, pCGI->CFI.h_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor,pCGI->CFI.block_width/2);
				}
			}
			if (direction == 0) {  //上移
				row=(row-1+pCGI->row_num)%pCGI->row_num;  //更新当前块的行号
			}
			else {  //下移
				row=(row+1+pCGI->row_num)%pCGI->row_num;  //更新当前块的行号
			}
		}

		else if (direction == 2 || direction == 3) {  //左右移动
			for (int i = 0; i < pCGI->CFI.block_width + pCGI->CFI.separator * 2; i+=2) {
				if (direction == 2) {  //左移
					gmw_inner_draw_block(pCGI, block_start_x - i, block_start_y, blank_bdi_value, bdi);   //将当前位置的块显示为空白块
					gmw_inner_draw_block(pCGI, block_start_x - i - 2, block_start_y, bdi_value, bdi);  //将下一个位置的块显示为当前块的值
					Sleep(pCGI->delay_of_block_moved);
				}
				else {  //右移
					gmw_inner_draw_block(pCGI, block_start_x + i, block_start_y, blank_bdi_value, bdi);   //将当前位置的块显示为空白块
					gmw_inner_draw_block(pCGI, block_start_x + i + 2, block_start_y, bdi_value, bdi);  //将下一个位置的块显示为当前块的值
					Sleep(pCGI->delay_of_block_moved);
				}
			}
			if (pCGI->CFI.separator) {  //如果有分隔线
				if (direction == 2) {  //左移
					for (int j = 0; j < pCGI->CFI.block_high; j++) {
						cct_showstr(block_start_x - 2, block_start_y + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
					}
				}
				else {  //右移
					for (int j = 0; j < pCGI->CFI.block_high; j++) {
						cct_showstr(block_start_x + pCGI->CFI.block_width, block_start_y + j, pCGI->CFI.v_normal, pCGI->CFI.bgcolor, pCGI->CFI.fgcolor);
					}
				}
			}
			if (direction == 2) {  //左移
				col=(col-1+pCGI->col_num)%pCGI->col_num;  //更新当前块的列号
			}
			else {  //右移
				col=(col+1+pCGI->col_num)%pCGI->col_num;  //更新当前块的列号
			}
		}
	}

	return 0; //此句可根据需要修改
}

/***************************************************************************
  函数名称：
  功    能：读键盘或鼠标
  输入参数：const CONSOLE_GRAPHICS_INFO *const pCGI	：整体结构指针
		   int &MAction							：如果返回 CCT_MOUSE_EVENT，则此值有效，为 MOUSE_ONLY_MOVED/MOUSE_LEFT_BUTTON_CLICK/MOUSE_RIGHT_BUTTON_CLICK 三者之一
		                                               如果返回 CCT_KEYBOARD_EVENT，则此值无效
		   int &MRow								：如果返回 CCT_MOUSE_EVENT 且 MAction = MOUSE_ONLY_MOVED/MOUSE_LEFT_BUTTON_CLICK，则此值有效，表示左键选择的游戏区域的行号（从0开始）
												  其余情况此值无效（如果访问无效值导致错误，不是本函数的错!!!）
		   int &MCol								：如果返回 CCT_MOUSE_EVENT 且 MAction = MOUSE_ONLY_MOVED/MOUSE_LEFT_BUTTON_CLICK，则此值有效，表示左键选择的游戏区域的列号（从0开始）
												  其余情况此值无效（如果访问无效值导致错误，不是本函数的错!!!）
		   int &KeyCode1							：如果返回 CCT_KEYBOARD_EVENT，则此值有效，为读到的键码（如果双键码，则为第一个）
												  其余情况此值无效（如果访问无效值导致错误，不是本函数的错!!!）
		   int &KeyCode2							：如果返回 CCT_KEYBOARD_EVENT，则此值有效，为读到的键码（如果双键码，则为第二个，如果是单键码，则为0）
												  其余情况此值无效（如果访问无效值导致错误，不是本函数的错!!!）
		   const bool update_lower_status_line		：鼠标移动时，是否要在本函数中显示"[当前光标] *行*列/位置非法"的信息（true=显示，false=不显示，缺省为true）
  返 回 值：函数返回约定
		   1、如果是鼠标移动，得到的MRow/MCol与传入的相同(鼠标指针微小的移动)，则不返回，继续读
							  得到行列非法位置，则不返回，根据 update_lower_status_line 的设置在下状态栏显示"[当前光标] 位置非法"
							  得到的MRow/MCol与传入的不同(行列至少一个变化)，根据 update_lower_status_line 的设置在下状态栏显示"[当前光标] *行*列"，再返回MOUSE_ONLY_MOVED（有些游戏返回后要处理色块的不同颜色显示）
		   2、如果是按下鼠标左键，且当前鼠标指针停留在主游戏区域的*行*列上，则返回 CCT_MOUSE_EVENT ，MAction 为 MOUSE_LEFT_BUTTON_CLICK, MRow 为行号，MCol 为列标
		                          且当前鼠标指针停留在非法区域（非游戏区域，游戏区域中的分隔线），则不返回，根据 update_lower_status_line 的设置在下状态栏显示"[当前光标] 位置非法"
		   3、如果是按下鼠标右键，则不判断鼠标指针停留区域是否合法，直接返回 CCT_MOUSE_EVENT ，MAction 为 MOUSE_RIGHT_BUTTON_CLICK, MRow、MCol取当前值（因为消灭星星的右键标记需要坐标）
		   4、如果按下键盘上的某键（含双键码按键），则直接返回 CCT_KEYBOARD_EVENT，KeyCode1/KeyCode2中为对应的键码值
 说    明：通过调用 cmd_console_tools.cpp 中的 read_keyboard_and_mouse 函数实现
***************************************************************************/
int gmw_read_keyboard_and_mouse(const CONSOLE_GRAPHICS_INFO *const pCGI, int &MAction, int &MRow, int &MCol, int &KeyCode1, int &KeyCode2, const bool update_lower_status_line)
{
	/* 防止在未调用 gmw_init 前调用其它函数 */
	if (pCGI->inited != CGI_INITED)
		return -1;

	cct_enable_mouse();

	int MX, MY, event;
	int new_MRow=MRow, new_MCol=MCol;
	bool flag=false;  //判断位置是否非法
	
	while (true) {
		event = cct_read_keyboard_and_mouse(MX, MY, MAction, KeyCode1, KeyCode2);

		if (event == CCT_KEYBOARD_EVENT) {
			return CCT_KEYBOARD_EVENT;
		}
		else if (event == CCT_MOUSE_EVENT) {
			if (pCGI->CFI.separator) {
				if ((((MX - pCGI->start_x) / (2 + pCGI->CFI.block_width)) >= 0) &&
					(((MX - pCGI->start_x) / (2 + pCGI->CFI.block_width)) < pCGI->col_num) &&
					(((MX - pCGI->start_x) % (2 + pCGI->CFI.block_width)) >= 2) &&
					(((MX - pCGI->start_x) % (2 + pCGI->CFI.block_width)) < (2 + pCGI->CFI.block_width)) &&
					(((MY - pCGI->start_y) / (1 + pCGI->CFI.block_high)) >= 0) &&
					(((MY - pCGI->start_y) / (1 + pCGI->CFI.block_high)) < pCGI->row_num) &&
					(((MY - pCGI->start_y) % (1 + pCGI->CFI.block_high)) >= 1) &&
					(((MY - pCGI->start_y) % (1 + pCGI->CFI.block_high)) < (1 + pCGI->CFI.block_high))) {
					flag = true;
					new_MRow = (MY - pCGI->start_y) / (1 + pCGI->CFI.block_high);
					new_MCol = (MX - pCGI->start_x) / (2 + pCGI->CFI.block_width);
				}
				else {
					flag = false;
				}
			}
			else {
				if ((((MX - pCGI->start_x - 2) / (pCGI->CFI.block_width)) >= 0) &&
					(((MX - pCGI->start_x - 2) / (pCGI->CFI.block_width)) < pCGI->col_num) &&
					(((MY - pCGI->start_y - 1) / (pCGI->CFI.block_high)) >= 0) &&
					(((MY - pCGI->start_y - 1) / (pCGI->CFI.block_high)) < pCGI->row_num)) {
					flag = true;
					new_MRow = (MY - pCGI->start_y - 1) / (pCGI->CFI.block_high);
					new_MCol = (MX - pCGI->start_x - 2) / (pCGI->CFI.block_width);
				}
				else {
					flag = false;
				}
			}

			if (MAction == MOUSE_ONLY_MOVED) {
				if (flag && (new_MRow != MRow || new_MCol != MCol)) {
					MRow = new_MRow;
					MCol = new_MCol;
					//状态栏
					if (update_lower_status_line) {
						char weizhi[20];
						sprintf(weizhi, "[当前光标] %c行%d列",MRow+'A',MCol);
						gmw_status_line(pCGI, LOWER_STATUS_LINE, weizhi);
					}
					return CCT_MOUSE_EVENT;
				}
				else if (flag && (new_MRow == MRow && new_MCol == MCol)) {
					//状态栏
					if (update_lower_status_line) {
						char weizhi[20];
						sprintf(weizhi, "[当前光标] %c行%d列", MRow + 'A', MCol);
						gmw_status_line(pCGI, LOWER_STATUS_LINE, weizhi);
					}
					continue; //无变化，继续读
				}
				else{  //位置非法
					//状态栏
					if (update_lower_status_line) {
						gmw_status_line(pCGI, LOWER_STATUS_LINE, "[当前光标] 位置非法");
					}
					continue; //位置非法，继续读
				}
			}
			else if (MAction == MOUSE_LEFT_BUTTON_CLICK) {
				if (flag) {
					MRow = new_MRow;
					MCol = new_MCol;
					//状态栏
					if (update_lower_status_line) {
						char weizhi[20];
						sprintf(weizhi, "[当前光标] %c行%d列", MRow + 'A', MCol);
						gmw_status_line(pCGI, LOWER_STATUS_LINE, weizhi);
					}
					return CCT_MOUSE_EVENT;
				}
				else {
					//状态栏
					if (update_lower_status_line) {
						gmw_status_line(pCGI, LOWER_STATUS_LINE, "[当前光标] 位置非法");
					}
					continue; //位置非法，继续读
				}
			}
			else if (MAction == MOUSE_RIGHT_BUTTON_CLICK) {
				MRow = new_MRow;
				MCol = new_MCol;
				return CCT_MOUSE_EVENT;
			}
		}
	}
	return -1; //此句可根据需要修改
}
