#include "CRT.h"
#include "IOPort.h"

unsigned short* CRT::m_VideoMemory = (unsigned short *)(0xB8000 + 0xC0000000);

/* 初始化光标位置 */
unsigned int CRT::m_CursorX = 0;
unsigned int CRT::m_CursorY = 0;

/* 初始化缓冲区控制变量 */
char CRT::m_Buffer[CRT::MAX_HISTORY_LINES][CRT::COLUMNS] = {0}; // 初始化为0
unsigned int CRT::m_BufferHead = 0;   // 当前写入行（逻辑绝对行号）
unsigned int CRT::m_ViewStartRow = 0; // 视口起始行（逻辑绝对行号）

char* CRT::m_Position = 0;
char* CRT::m_BeginChar = 0;

unsigned int CRT::ROWS = 15;

void CRT::CRTStart(TTy* pTTy)
{
	char ch;
	
    // 初始化缓冲区（可选，防止内存随机垃圾）
    // 在构造函数或系统初始化时做更好，这里简单处理
    static bool isInitialized = false;
    if (!isInitialized) {
        ClearScreen();
        isInitialized = true;
    }

	if ( 0 == CRT::m_BeginChar)
	{
		m_BeginChar = pTTy->t_outq.CurrentChar();
	}
	if ( 0 == m_Position )
	{
		m_Position = m_BeginChar;
	}

	while ( (ch = pTTy->t_outq.GetChar()) != TTy::GET_ERROR )
	{
		switch (ch)
		{
		case '\n':
			NextLine();
			CRT::m_BeginChar = pTTy->t_outq.CurrentChar();
			m_Position = CRT::m_BeginChar;
			break;

		case 0x15:
			//del_line();
			break;

		case '\b':
			if ( m_Position != CRT::m_BeginChar )
			{
				BackSpace();
				m_Position--;
			}
			break;

		case '\t':
			Tab();
			m_Position++;
			break;

		default:
			WriteChar(ch);
			m_Position++;
			break;
		}
   }
}

void CRT::MoveCursor(unsigned int col, unsigned int row)
{
	// 检查行是否超出屏幕范围
	if (row >= CRT::ROWS) {
		// 光标移出屏幕，隐藏光标
		unsigned short cursorPosition = CRT::ROWS * CRT::COLUMNS; // 屏幕外位置
		IOPort::OutByte(CRT::VIDEO_ADDR_PORT, 14);
		IOPort::OutByte(CRT::VIDEO_DATA_PORT, cursorPosition >> 8);
		IOPort::OutByte(CRT::VIDEO_ADDR_PORT, 15);
		IOPort::OutByte(CRT::VIDEO_DATA_PORT, cursorPosition & 0xFF);
		return;
	}

	// 检查列是否超出有效范围
	if (col >= CRT::COLUMNS) {
		col = CRT::COLUMNS - 1;
	}

	unsigned short cursorPosition = row * CRT::COLUMNS + col;

	IOPort::OutByte(CRT::VIDEO_ADDR_PORT, 14);
	IOPort::OutByte(CRT::VIDEO_DATA_PORT, cursorPosition >> 8);
	IOPort::OutByte(CRT::VIDEO_ADDR_PORT, 15);
	IOPort::OutByte(CRT::VIDEO_DATA_PORT, cursorPosition & 0xFF);
}

/* ============================================================
 * 核心修改区域：缓冲区与视图控制
 * ============================================================ */

/* 新增：重绘屏幕 */
/* 作用：将 m_Buffer 中从 m_ViewStartRow 开始的 ROWS 行数据复制到显存 */
void CRT::RefreshScreen()
{
    unsigned int screenRow, screenCol;
    unsigned int bufferRowIndex;

    for (screenRow = 0; screenRow < ROWS; screenRow++)
    {
        // 计算当前屏幕行对应的逻辑行号
        unsigned int logicalRow = m_ViewStartRow + screenRow;
         
        // 计算在循环缓冲区数组中的实际索引
        bufferRowIndex = logicalRow % MAX_HISTORY_LINES;

        for (screenCol = 0; screenCol < COLUMNS; screenCol++)
        {
            char ch = m_Buffer[bufferRowIndex][screenCol];
            // 如果缓冲区字符是0，显示空格
            if (ch == 0) ch = ' '; 
            
            m_VideoMemory[screenRow * COLUMNS + screenCol] = (unsigned char)ch | CRT::COLOR;
        }
    }
    
    // 只有当当前行在可视范围内时，才显示光标
    if (m_BufferHead >= m_ViewStartRow && m_BufferHead < m_ViewStartRow + ROWS) {
        // 计算当前行在屏幕上的相对Y坐标
        unsigned int screenRelY = m_BufferHead - m_ViewStartRow;
        MoveCursor(m_CursorX, screenRelY);
    } else {
        // 光标不在可视范围内，隐藏光标（将光标移出屏幕）
        MoveCursor(0, ROWS);
    }
}

/* 修改：换行逻辑 */
void CRT::NextLine()
{
    // 1. 光标 X 归零
	m_CursorX = 0;

    // 2. 逻辑行号增加 (写入位置下移)
    m_BufferHead++;
    
    // 清空新的一行在缓冲区中的旧数据 (因为是循环缓冲区，可能存着旧数据)
    unsigned int realRowIndex = m_BufferHead % MAX_HISTORY_LINES;
    for(int i=0; i<COLUMNS; i++) {
        m_Buffer[realRowIndex][i] = 0; 
    }

    // 3. 判断是否需要滚动视图
    // 当前行号 m_BufferHead 相对于 视图起始 m_ViewStartRow 的偏移
    unsigned int relativeRow = m_BufferHead - m_ViewStartRow;

    if ( relativeRow >= CRT::ROWS )
    {
        // 溢出：视口下移一行
        m_ViewStartRow++;
        
        // 光标保持在屏幕最后一行
        m_CursorY = CRT::ROWS - 1;
        
        // 触发重绘：将新视口内容刷到显存
        RefreshScreen();
    }
    else
    {
        // 未溢出：光标物理下移
        m_CursorY++;
        MoveCursor(m_CursorX, m_CursorY);
    }
}

/* 修改：写入字符 */
void CRT::WriteChar(char ch)
{
    // 检查是否需要滚动到最底部
    if (m_BufferHead >= m_ViewStartRow + ROWS) {
        // 视图不在最底部，滚动到最新行
        m_ViewStartRow = m_BufferHead - ROWS + 1;
        RefreshScreen();
    }

    // 1. 写入缓冲区 (永久存储)
    unsigned int realRowIndex = m_BufferHead % MAX_HISTORY_LINES;
    m_Buffer[realRowIndex][m_CursorX] = ch;

    // 2. 判断是否可见并写入显存 (显示同步)
    // 只有当正在写的这行在当前视口范围内时，才更新显存
    if (m_BufferHead >= m_ViewStartRow && m_BufferHead < m_ViewStartRow + ROWS)
    {
        // 计算屏幕上的相对Y坐标
        unsigned int screenRelY = m_BufferHead - m_ViewStartRow;
        m_VideoMemory[screenRelY * CRT::COLUMNS + m_CursorX] = (unsigned char) ch | CRT::COLOR;
    }

    // 3. 移动光标
	m_CursorX++;
	
	if ( m_CursorX >= CRT::COLUMNS )
	{
		NextLine();
	}
    else
    {
        // 只有在当前可视行才移动硬件光标
        if (m_BufferHead >= m_ViewStartRow && m_BufferHead < m_ViewStartRow + ROWS) {
            unsigned int screenRelY = m_BufferHead - m_ViewStartRow;
    	    MoveCursor(m_CursorX, screenRelY);
        }
    }
}

/* 修改：退格 */
void CRT::BackSpace()
{
    // 检查是否需要回退到上一行
	if ( m_CursorX == 0 )
	{
        // 回退到上一行末尾
		m_CursorX = CRT::COLUMNS - 1;
        
        // 逻辑行号减一
        if (m_BufferHead > 0) {
            m_BufferHead--;
        }

        // 视图与光标同步
        if (m_CursorY > 0) {
            m_CursorY--;
        } else {
            // 如果光标在屏幕顶端，且缓冲区还有上面内容，需要视图上滚 (Scroll Up)
            if (m_ViewStartRow > 0) {
                m_ViewStartRow--;
                RefreshScreen();
                m_CursorY = 0; // 保持在顶端
            }
        }
	} else {
        // 正常退格，只移动 X
        m_CursorX--;
	}
    
    // 更新硬件光标
	MoveCursor(m_CursorX, m_CursorY);

	/* 1. 同步修改缓冲区 */
    unsigned int realRowIndex = m_BufferHead % MAX_HISTORY_LINES;
    m_Buffer[realRowIndex][m_CursorX] = 0; // 或者 ' '

    /* 2. 同步修改显存 (如果在可视范围内) */
    if (m_BufferHead >= m_ViewStartRow && m_BufferHead < m_ViewStartRow + ROWS) {
        unsigned int screenRelY = m_BufferHead - m_ViewStartRow;
	    m_VideoMemory[screenRelY * COLUMNS + m_CursorX] = ' ' | CRT::COLOR;
    }
}

/* 清屏操作 */
void CRT::ClearScreen()
{
    // 清空历史缓冲区
    for (int i = 0; i < MAX_HISTORY_LINES; i++) {
        for (int j = 0; j < COLUMNS; j++) {
            m_Buffer[i][j] = 0;
        }
    }
    
    // 重置控制变量
    m_BufferHead = 0;
    m_ViewStartRow = 0;
    m_CursorX = 0;
    m_CursorY = 0;

    // 清空显存
	for (unsigned int i = 0; i < COLUMNS * ROWS; i++ )
	{
		m_VideoMemory[i] = (unsigned short)' ' | CRT::COLOR;
	}
    
    MoveCursor(0, 0);
}

/* Tab键处理：Tab宽度为8，超过列宽时换行 */
void CRT::Tab()
{
	m_CursorX &= 0xFFFFFFF8;
	m_CursorX += 8;

	if ( m_CursorX >= CRT::COLUMNS )
		NextLine();
	else
		MoveCursor(m_CursorX, m_CursorY);
}