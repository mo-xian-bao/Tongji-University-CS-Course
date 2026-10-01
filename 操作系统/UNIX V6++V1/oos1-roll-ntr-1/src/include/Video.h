#ifndef VIDEO_H
#define VIDEO_H

/*
	Diagnose类用于调试信息输出
	Diagnose::Write()类似于printf()函数
	支持的格式说明符: %d %x %s
*/
class Diagnose
{
public:
	static int ROWS ;			// Diagnose占用的行数
	static const int COLUMNS = 80;		// 每行的列数
	static const int SCREEN_ROWS = 25;	// 屏幕总行数
	static const int COLOR = 0x0B00;	// Diagnose输出颜色(青色)

	static const int MAX_DEBUG_LINES = 200;	// [新增] 环形缓冲区最大行数

public:
	Diagnose();
	~Diagnose();

	static void TraceOn();		// 开启跟踪输出
	static void TraceOff();		// 关闭跟踪输出

	static void Write(const char* fmt, ...);	// 格式化输出函数

	/* [新增] 刷新屏幕函数 */
	static void RefreshScreen();// 将缓冲区刷新到屏幕
	
	static void ClearScreen();	// 清屏
	
private:
	static void WriteChar(const char ch);			// 输出单个字符
	static void PrintInt(unsigned int value, int base);	// 输出整数
	static void NextLine();		// 换行处理


	/* 成员变量 */
public:
	static unsigned short *m_VideoMemory;	// 显存地址
	static unsigned int m_Row;				// 当前输出行
	static unsigned int m_Column;			// 当前输出列

	static bool trace_on;	// 跟踪开关

	/* [新增] 环形缓冲区，用于存储调试输出历史 */
	static char m_Buffer[MAX_DEBUG_LINES][COLUMNS];	// 环形缓冲区(字符数组)
	static unsigned int m_BufferHead;		// 缓冲区写入位置(环形索引)
	static unsigned int m_ViewStartRow;		// 视图起始行在缓冲区的位置
};

#endif
