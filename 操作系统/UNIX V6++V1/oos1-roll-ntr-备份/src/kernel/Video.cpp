#include "Video.h"

int Diagnose::ROWS =10;
const int Diagnose::COLUMNS;
const int Diagnose::SCREEN_ROWS;
const int Diagnose::COLOR;
const int Diagnose::MAX_DEBUG_LINES;

unsigned short* Diagnose::m_VideoMemory = (unsigned short *)(0xB8000 + 0xC0000000);
unsigned int Diagnose::m_Row = 15; // Diagnose区域起始行 (SCREEN_ROWS - ROWS)
unsigned int Diagnose::m_Column = 0;

// [新增] 缓冲区成员初始化
char Diagnose::m_Buffer[Diagnose::MAX_DEBUG_LINES][Diagnose::COLUMNS] = {0};
unsigned int Diagnose::m_BufferHead = 0;    // 当前写入的逻辑行号
unsigned int Diagnose::m_ViewStartRow = 0;  // 视口起始逻辑行号

bool Diagnose::trace_on = true;

Diagnose::Diagnose()
{
	//全部都是static成员变量，所以没有什么需要在构造函数中初始化的。
}

Diagnose::~Diagnose()
{
	//this is an empty dtor
}

void Diagnose::TraceOn()
{
	Diagnose::trace_on = 1;
}

void Diagnose::TraceOff()
{
	Diagnose::trace_on = 0;
}

/*
	能够输出格式化后的字符串，目前只能识别一些%d %x  %s 和%n;
	没有检查错误功能，% 和 值匹配要自己注意。
*/
void Diagnose::Write(const char* fmt, ...)
{
	if ( false == Diagnose::trace_on )
	{
		return;
	}
	//使va_arg中存放参数fmt的 “后一个参数” 所在的内存地址
	//fmt的内容本身是字符串的首地址(这不是我们要的)，而&fmt + 1则是下一个参数的地址
	//参考UNIX v6中的函数prf.c/printf(fmt, x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc)
	unsigned int * va_arg = (unsigned int *)&fmt + 1;
	const char * ch = fmt;
	
	while(1)
	{
		while(*ch != '%' && *ch != '\n')
		{
			if(*ch == '\0')
				return;
			if(*ch == '\n')
				break;
			/*注意： '\n'是一个单一字符，而不是'\\'和 ‘n'两个字符的相加， 
			譬如在字符串"\nHello World!!"中如果比较 if(*ch == '\\' && *(ch+1) == '\n' ) 的话，
			会死的狠惨的！*/
			WriteChar(*ch++);
		}
		
		ch++;	//skip the '%' or '\n'   

		if(*ch == 'd' || *ch == 'x')
		{//%d 或 %x 格式来输出，当然要添加八进制和二进制也很容易，但用处不大。
			int value = (int)(*va_arg);
			va_arg++;
			if(*ch == 'x')
				Write("0x");   //as prefix for HEX value
			PrintInt(value, *ch == 'd' ? 10 : 16);
			ch++;	//skip the 'd' or 'x'
		}
		
		else if(*ch == 's')
		{//%s 格式来输出
			ch++;	//skip the 's'
			char *str = (char *)(*va_arg);
			va_arg++;
			while(char tmp = *str++)
			{
				WriteChar(tmp);
			}
		}
		else /* if(*(ch-1) == '\n') */
		{
			Diagnose::NextLine();
		}
	}
}

/*
	参考UNIX v6中的函数prf.c/printn(n,b)
	此函数的功能是将一个值value以base进制的方式显示出来。
*/
void Diagnose::PrintInt(unsigned int value, int base)
{
	//因为数字0～9 和 A~F的ASCII码之间不是连续的，所以不能简单通过
	//ASCII(i) = i + '0'直接计算得到，因此用了Digits字符数组。
	static char Digits[] = "0123456789ABCDEF";
	int i;
	
	if((i = value / base) != 0)
		PrintInt(i ,base);
	WriteChar(Digits[value % base]);
}

/*
 * [新增] 刷新屏幕显示
 * 将缓冲区中从 m_ViewStartRow 开始的 ROWS 行内容渲染到显存
 */
void Diagnose::RefreshScreen()
{
	unsigned int screenRow, screenCol;
	unsigned int bufferRowIndex;

	for (screenRow = 0; screenRow < ROWS; screenRow++)
	{
		unsigned int logicalRow = m_ViewStartRow + screenRow;
		bufferRowIndex = logicalRow % MAX_DEBUG_LINES;
		unsigned int physRow = SCREEN_ROWS - ROWS + screenRow;

		for (screenCol = 0; screenCol < COLUMNS; screenCol++)
		{
			char ch = m_Buffer[bufferRowIndex][screenCol];
			if (ch == 0) ch = ' ';
			m_VideoMemory[physRow * COLUMNS + screenCol] = (unsigned char)ch | Diagnose::COLOR;
		}
	}
}

/*
 * [修改] 换行处理
 * 原逻辑：简单增加m_Row，超出屏幕则清屏
 * 新逻辑：写入缓冲区，支持自动滚动视图
 */
void Diagnose::NextLine()
{
	m_Column = 0;
	m_BufferHead++;

	// 清空新行的旧数据(循环缓冲区可能有残留)
	unsigned int realRowIndex = m_BufferHead % MAX_DEBUG_LINES;
	for(int i=0; i<COLUMNS; i++) {
		m_Buffer[realRowIndex][i] = 0; 
	}

	// 自动滚动：如果写入位置超出视口，视口下移
	if (m_BufferHead >= m_ViewStartRow + ROWS)
	{
		m_ViewStartRow = m_BufferHead - ROWS + 1;
	}
	RefreshScreen();
}

/*
 * [修改] 写入单个字符
 * 原逻辑：直接写入显存
 * 新逻辑：先写入缓冲区，再同步到显存
 */
void Diagnose::WriteChar(const char ch)
{
	// 确保视图在最底部
	if (m_BufferHead >= m_ViewStartRow + ROWS) {
		m_ViewStartRow = m_BufferHead - ROWS + 1;
		RefreshScreen();
	}

	if(Diagnose::m_Column >= Diagnose::COLUMNS)
	{
		NextLine();
	}

	// 1. 写入缓冲区
	unsigned int realRowIndex = m_BufferHead % MAX_DEBUG_LINES;
	m_Buffer[realRowIndex][m_Column] = ch;

	// 2. 写入显存
	if (m_BufferHead >= m_ViewStartRow && m_BufferHead < m_ViewStartRow + ROWS)
	{
		unsigned int relRow = m_BufferHead - m_ViewStartRow;
		unsigned int physRow = (SCREEN_ROWS - ROWS) + relRow;
		Diagnose::m_VideoMemory[physRow * COLUMNS + m_Column] = (unsigned char) ch | Diagnose::COLOR;
	}

	Diagnose::m_Column++;
}

/*
 * [修改] 清屏
 * 新增：同时清空缓冲区和重置视口
 */
void Diagnose::ClearScreen()
{
	// 清空缓冲区
	for(int i=0; i<MAX_DEBUG_LINES; i++)
		for(int j=0; j<COLUMNS; j++)
			m_Buffer[i][j] = 0;

	m_BufferHead = 0;
	m_ViewStartRow = 0;
	m_Column = 0;
	m_Row = SCREEN_ROWS - ROWS;

	// 清空显存区域
	for(unsigned int i = 0; i < (COLUMNS * ROWS); i++)
	{
		unsigned int offset = (SCREEN_ROWS - ROWS) * COLUMNS + i;
		Diagnose::m_VideoMemory[offset] = (unsigned char) ' ' | Diagnose::COLOR;
	}
}

