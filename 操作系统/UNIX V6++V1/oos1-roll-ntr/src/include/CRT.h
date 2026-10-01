#ifndef CRT_H
#define CRT_H

#include "TTy.h"

class CRT
{
	/* Const Member */
public:
	static const unsigned short VIDEO_ADDR_PORT = 0x3d4;
	static const unsigned short VIDEO_DATA_PORT = 0x3d5;
	
	static const unsigned int COLUMNS = 80;
	static unsigned int ROWS;
	
	static const unsigned short COLOR = 0x0F00;

    /* 缓冲区配置 */
    static const unsigned int MAX_HISTORY_LINES = 200; // 历史记录最大行数

	/* Functions */
public:
	static void CRTStart(TTy* pTTy);
	static void MoveCursor(unsigned int x, unsigned int y);
	static void NextLine();
	static void BackSpace();
	static void Tab();
	static void WriteChar(char ch);
	static void ClearScreen();

    /* 新增：根据缓冲区重绘整个屏幕 */
    static void RefreshScreen();

	/* Members */
public:
	static unsigned short* m_VideoMemory;
	
    /* 屏幕光标坐标 (0 ~ ROWS-1) */
    static unsigned int m_CursorX;
	static unsigned int m_CursorY;

    /* 缓冲区相关成员 */
    static char m_Buffer[MAX_HISTORY_LINES][COLUMNS]; // 字符缓冲区
    static unsigned int m_BufferHead;   // 当前正在写入的逻辑行号 (绝对行号)
    static unsigned int m_ViewStartRow; // 当前屏幕第一行对应的缓冲区逻辑行号

	static char* m_Position;
	static char* m_BeginChar;
};

#endif