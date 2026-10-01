#include "TTy.h"
#include "Assembly.h"
#include "Kernel.h"
#include "CRT.h"

/*==============================class TTy_Queue===============================*/
TTy_Queue::TTy_Queue()
{
	this->m_Head = 0;
	this->m_Tail = 0;
}

TTy_Queue::~TTy_Queue()
{
	//nothing to do here
}

char TTy_Queue::GetChar()
{
	char ch = TTy::GET_ERROR;
	{
		if ( this->m_Head == this->m_Tail )
		{
			//Buffer Empty
			return ch;
		}
	}

	ch = this->m_CharBuf[m_Tail];
	this->m_Tail = ( this->m_Tail + 1 ) % TTY_BUF_SIZE;

	return ch;
}

void TTy_Queue::PutChar(char ch)
{
	this->m_CharBuf[m_Head] = ch;
	this->m_Head = ( this->m_Head + 1 ) % TTY_BUF_SIZE;
}

int TTy_Queue::CharNum()
{
	/* 当Head < Tail时使用%运算会出问题！！改用'&'运算。
	 *  譬如下标Head = 5，Tail = 10； (5 - 10) %  TTY_BUF_SIZE ，
	 *  会被当作0xFFFF FFFB  ( =4294967291) 去模运算TTY_BUF_SIZE，结果就错了。
	 */
	// unsigned int ans = this->m_Head - this->m_Tail;
	// ans = ans % TTY_BUF_SIZE;
	// return ans;
	
	int ans = (this->m_Head - this->m_Tail) & (TTy_Queue::TTY_BUF_SIZE - 1);
	return ans;
}

char* TTy_Queue::CurrentChar()
{
	/* 返回下一个将要取出字符的地址 */
	return &this->m_CharBuf[m_Tail];
}

/*==============================class TTy===============================*/
/* 控制台对象实例的定义 */
TTy g_TTy;

TTy::TTy()
{
	this->m_HistoryHead = 0;
	this->m_HistoryCount = 0;
	this->m_HistoryCurrentIndex = -1;
	for(int i=0; i<HISTORY_SIZE; i++)
		for(int j=0; j<CMD_MAX_LEN; j++)
			m_History[i][j] = 0;
}

TTy::~TTy()
{

}

/*
 * 从标准输入队列取字符，送用户区
 * 直至队列为空，或满足应用程序之所需（u.u_IOParam.m_Count 为  0）
 * 其间，进程有可能入睡。这一定是 因为标准输入队列为空，且原始输入队列中没有定界符
 * （用户没有输入回车，还可能对原始队列中的输入数据进行修改）
 * */
void TTy::TTRead()
{
	/* 设备没有开始工作，返回 */
	if ( (this->t_state & TTy::CARR_ON) == 0 )
	{
		return;
	}

	if ( this->t_canq.CharNum() || this->Canon() )
	{
		while ( this->t_canq.CharNum() && (this->PassC(this->t_canq.GetChar()) >= 0) );
	}
}

/*
 * 一次一个字节地将用户区中等待输出的内容送标准输出队列。
 * 若队列满，将其中内容刷新至显存。 输出过程会引发多次刷新。
 * 调整CRT::m_BeginChar令其指向输出队列中存放下一个字符的单元。BackSpace不可以擦除该指针之前的任何字符。
 */
void TTy::TTWrite()
{
	/* 
	 * 因为现在的输出设备是内存，其相应速度相当快，所以
	 * 不需要在结束回显后发送中断，这样的代价非常大。这和
	 * 原来unix v6的有些不同。本来可以在输出字符的过程中关
	 * 中断来防止用户输入但不能被正常删除的bug,但因为这样
	 * 可能会导致时钟中断相应的延迟，这个问题更加严重，因
	 * 此没有这样做。
	 */
	char ch;
	
	 /* 设备没有开始工作，返回 */
	if ( (this->t_state & TTy::CARR_ON) == 0 )
	{
		return;
	}

	while ( (ch = CPass()) > 0 )
	{
		/*输出队列中超过规定字符数，需要赶快显示 */
		if ( this->t_outq.CharNum() > TTy::TTHIWAT)
		{
			this->TTStart();
			/* 重新设置BeginChar指向输出字符缓存队列中，未确认部分的起始处。
			 * 目的在于不允许Backspace键删除写在标准输出上的内容，譬如命令提示符之类。
			 */
			CRT::m_BeginChar = this->t_outq.CurrentChar();
		}
		this->TTyOutput(ch);
	}
	this->TTStart();
	CRT::m_BeginChar = this->t_outq.CurrentChar();
	/* 重设BeginChar为了防止错误删除打印的字符，这里需要清空显示缓存，但会造成前面输入回显
	 * 的字符在被删除时并不能被删掉，但是在实际中已经被删除了。
	 */
}

/* 由中断处理程序调用。参数ch是扫描码转换成的ASCII码。
 * 功能：将ch放入原始输入队列，并对其进行回显 （送标准输出队列，之后立即TTStart送显存）
 * 代码中粗糙的地方：this->t_rawq.PutChar(ch) 之前没有判断原始输入队列有没有满。造成的结果是原始队列中原本已有
 * 的字符被删除。
 * 原始输入队列满只能说明一个问题：没有进程在等待键盘输入。
 * 考虑 改进系统，TTyInput加入以下判断：没有进程睡眠等待键盘输入的时候，不要将ch放入原始队列。
 * */
void TTy::TTyInput(char ch)
{
//	if ( (ch &= 0xFF) == '\r' && (this->t_flags & TTy::CRMOD) )
//	{
//		ch = '\n';
//	}

	/* 如果是小写终端 */
//	if ( (this->t_flags & TTy::LCASE) && ch >= 'A' && ch <= 'Z' )
//	{
//		ch += 'a' - 'A';
//	}

	/* 将输入字符放入原始字符缓存队列 */
	this->t_rawq.PutChar(ch);

	//if ( this->t_flags & TTy::RAW || ch == '\n' || ch == TTy::CEOT )
	if ( ch == '\n' || ch == TTy::CEOT )
	{
		if (ch == '\n')
		{
			this->SaveHistory();
		}
		Kernel::Instance().GetProcessManager().WakeUpAll((unsigned long)&this->t_rawq);
		this->t_rawq.PutChar(0x7);
		this->t_delct++;
	}

	if ( this->t_flags & TTy::ECHO )
	{
		this->TTyOutput(ch);
		this->TTStart();
	}
}

void TTy::TTyOutput(char ch)
{
	/* 如果输入字符为文件结束符，并且终端工作在原始方式下，则返回 */
	 /*if ( (ch &= 0xFF) == TTy::CEOT && (this->t_flags & TTy::RAW) == 0 )
	{
		return;
	}

	if ( '\n' == ch && (this->t_flags & TTy::CRMOD) )
	{
		this->TTyOutput('\r');
	} */

	/* 将字符放入输出字符缓存队列中 */
	if (ch)
	{
		this->t_outq.PutChar(ch);
	}
}

void TTy::TTStart()
{
	CRT::CRTStart(this);
}

void TTy::FlushTTy()
{
	while ( this->t_canq.GetChar() >= 0 );
	while ( this->t_outq.GetChar() >= 0 );
	Kernel::Instance().GetProcessManager().WakeUpAll((unsigned long)&this->t_canq);
	Kernel::Instance().GetProcessManager().WakeUpAll((unsigned long)&this->t_outq);
	
	X86Assembly::CLI();
	while ( this->t_rawq.GetChar() >= 0 );
	this->t_delct = 0;
	X86Assembly::STI();
}

int TTy::Canon()
{
     char* pChar;
     char ch;
     User& u = Kernel::Instance().GetUser();

     X86Assembly::CLI();
     while ( this->t_delct == 0 )   // 原始队列无回车符，没有可以送给应用程序的数据，睡眠等待用户输入回车符
     {
         if ( (this->t_state & TTy::CARR_ON) == 0 )
        	 return 0;   // 设备没打开，返回
         u.u_procp->Sleep((unsigned long)&this->t_rawq, ProcessManager::TTIPRI);
     }
    X86Assembly::STI();

    // 处理原始队列中的字符，送入canon队列
    pChar = &Canonb[0];

    while ( (ch = this->t_rawq.GetChar()) >= 0 )    // 从原始队列取一行字符，存入Canonb队列。
    {
        if ( 0x7 == ch )		/* 是定界符*/
        {
        	this->t_delct--;     //  原始队列行数--
        	break;
        }

       if ( ch == this->t_erase )     	/* 是backspace */
       {
    	   if ( pChar > &Canonb[0] )
    		   pChar--;    //  擦掉Canonb中的前一个字符。Yeah ！！！删除屏幕上的字符，这里有一半
    	   continue;
       }

       if ( ch == TTy::CEOT )	/* CEOT == 0x4（试试 ctrl + d） */
    	   continue;       		/* 是文件结束符。没数据啦，返回 */

       *pChar++ = ch;       		/* 是普通字符。存入Canonb队列 */

       if ( pChar >= Canonb + TTy::CANBSIZ )
    	   break;    			/* Canonb队列满返回。本行剩余字符，下次Canon函数执行时再取 */
    }

    char* pEnd = pChar;
    pChar = &Canonb[0];

    while ( pChar < pEnd )
        this->t_canq.PutChar(*pChar++);   /* 将Cannonb队列中处理过的字符送标准队列 */

    return 1;
}

int TTy::PassC(char ch)
{
	User& u = Kernel::Instance().GetUser();

	/* 将字符送入用户目标区 */
	if ( u.u_IOParam.m_Count > 0 )
	{
		*(u.u_IOParam.m_Base++) = ch;
		//u.u_IOParam.m_Offset++;
		u.u_IOParam.m_Count--;
		return 0;
	}
	return -1;
}

char TTy::CPass()
{
	char ch;
	User& u = Kernel::Instance().GetUser();

	ch = *(u.u_IOParam.m_Base++);
	if ( u.u_IOParam.m_Count > 0 )
	{
		u.u_IOParam.m_Count--;
		//u.u_IOParam.m_Offset++;
		return ch;
	}
	else
	{
		return -1;
	}
}

void TTy::SaveHistory()
{
	// 定义一个临时字符数组，用于暂存当前要保存的命令字符串
	char temp[CMD_MAX_LEN];
	int bufSize = TTy_Queue::TTY_BUF_SIZE;
	
	// 如果字符数 <= 1，通常意味着只按了回车键（或者队列为空），这种空命令不需要保存历史
	if (this->t_rawq.CharNum() <= 1) return;
	
	// t_rawq.m_Head 指向下一个可写入的位置
	int ptr = (this->t_rawq.m_Head - 2 + bufSize) % bufSize;
	int len = 0;
	
	// 从队列尾部向前回溯，计算刚才那条命令的长度
	while (ptr != (this->t_rawq.m_Tail - 1 + bufSize) % bufSize)
	{
		char c = this->t_rawq.m_CharBuf[ptr];
		if (c == '\n' || c == 0x7) break;
		len++;
		ptr = (ptr - 1 + bufSize) % bufSize;
		if (len >= CMD_MAX_LEN - 1) break;
	}
	
	if (len == 0) return;
	
	// 计算命令的起始位置：m_Head (队尾) - 1 (换行符) - len (命令长度)
	int start = (this->t_rawq.m_Head - 1 - len + bufSize) % bufSize;
	// 循环复制字符到 temp 数组
	for (int i = 0; i < len; i++)
	{
		temp[i] = this->t_rawq.m_CharBuf[(start + i) % bufSize];
	}
	temp[len] = 0; // 字符串末尾补零
	
	// 保存到 m_History 数组中
	int lastIdx = (m_HistoryHead - 1 + HISTORY_SIZE) % HISTORY_SIZE;
	bool same = false;
	
	// 比较当前命令 (temp) 和上一条历史命令 (m_History[lastIdx])
	if (m_HistoryCount > 0)
	{
		bool match = true;
		for(int k=0; k<CMD_MAX_LEN; k++) {
			if(m_History[lastIdx][k] != temp[k]) { match = false; break; }
			if(temp[k] == 0) break;
		}
		same = match;
	}
	
	if (!same)
	{
		for(int i=0; i<CMD_MAX_LEN; i++) m_History[m_HistoryHead][i] = temp[i];
		m_HistoryHead = (m_HistoryHead + 1) % HISTORY_SIZE;
		if (m_HistoryCount < HISTORY_SIZE) m_HistoryCount++;
	}
	
	m_HistoryCurrentIndex = -1;
}

void TTy::HistoryUp()
{
	// 如果 m_HistoryCount 为 0，说明历史记录本是空的，没法往上翻，直接返回。
	if (m_HistoryCount == 0) return;

	int target = -1; // 用于暂存我们要找的那条历史记录的索引 (下标)
	if (m_HistoryCurrentIndex == -1) // 情况 A: 用户当前处于“最新输入行”，还没开始翻历史。
	{
		target = (m_HistoryHead - 1 + HISTORY_SIZE) % HISTORY_SIZE;
	}
	else // 情况 B: 用户当前处于“历史记录中间某行”，正在翻历史。
	{
		int oldest = (m_HistoryHead - m_HistoryCount + HISTORY_SIZE) % HISTORY_SIZE;
		if (m_HistoryCurrentIndex == oldest) return;
		target = (m_HistoryCurrentIndex - 1 + HISTORY_SIZE) % HISTORY_SIZE;
	}
	
	m_HistoryCurrentIndex = target; // 更新当前浏览指针，指向我们找到的目标记录。
	
	// 擦除屏幕上当前的命令行
	int bufSize = TTy_Queue::TTY_BUF_SIZE;
	int ptr = (this->t_rawq.m_Head - 1 + bufSize) % bufSize;
	int len = 0;
	while (this->t_rawq.m_Head != this->t_rawq.m_Tail)
	{
		if (ptr == (this->t_rawq.m_Tail - 1 + bufSize) % bufSize) break;
		char c = this->t_rawq.m_CharBuf[ptr];
		if (c == '\n' || c == 0x7) break;
		len++;
		ptr = (ptr - 1 + bufSize) % bufSize;
	}
	
	for (int i = 0; i < len; i++)
	{
		this->TTyOutput('\b');
		this->TTyOutput(' ');
		this->TTyOutput('\b');
	}
	this->TTStart();
	
	// 内存擦除：在输入队列中真正删除这些字符
	this->t_rawq.m_Head = (this->t_rawq.m_Head - len + bufSize) % bufSize;
	
	char* cmd = m_History[target];
	for (int i = 0; cmd[i] != 0; i++)
	{
		this->t_rawq.PutChar(cmd[i]);
		this->TTyOutput(cmd[i]);
	}
	this->TTStart();
}

void TTy::HistoryDown()
{
	// 如果 m_HistoryCount 为 0，说明历史记录本是空的，没法翻，直接返回。
	// 如果 m_HistoryCurrentIndex 为 -1，说明已经在最新输入行，没法再往下翻。
	if (m_HistoryCount == 0 || m_HistoryCurrentIndex == -1) return;
	
	int newest = (m_HistoryHead - 1 + HISTORY_SIZE) % HISTORY_SIZE;
	int target = -1; // 用于暂存我们要跳转到的目标索引
	
	if (m_HistoryCurrentIndex == newest) // 情况 A: 当前看的已经是"最新"的那条历史了。
	{
		// 再按"下"就应该回到"当下" (空白输入行)，所以 target 设为 -1。
		target = -1;
	}
	else // 情况 B: 当前看的是某条中间的或者较老的历史。
	{
		// 按"下"键应该看"更新"的一条，索引加 1。
		target = (m_HistoryCurrentIndex + 1) % HISTORY_SIZE;
	}
	
	m_HistoryCurrentIndex = target; // 更新当前浏览指针
	
	// 擦除屏幕上当前的命令行
	int bufSize = TTy_Queue::TTY_BUF_SIZE;
	int ptr = (this->t_rawq.m_Head - 1 + bufSize) % bufSize;
	int len = 0;
	while (this->t_rawq.m_Head != this->t_rawq.m_Tail)
	{
		if (ptr == (this->t_rawq.m_Tail - 1 + bufSize) % bufSize) break;
		char c = this->t_rawq.m_CharBuf[ptr];
		if (c == '\n' || c == 0x7) break;
		len++;
		ptr = (ptr - 1 + bufSize) % bufSize;
	}
	
	for (int i = 0; i < len; i++)
	{
		this->TTyOutput('\b');
		this->TTyOutput(' ');
		this->TTyOutput('\b');
	}
	this->TTStart();
	
	// 内存擦除：在输入队列中真正删除这些字符
	this->t_rawq.m_Head = (this->t_rawq.m_Head - len + bufSize) % bufSize;
	
	if (target != -1)
	{
		char* cmd = m_History[target];
		for (int i = 0; cmd[i] != 0; i++)
		{
			this->t_rawq.PutChar(cmd[i]);
			this->TTyOutput(cmd[i]);
		}
	}
	this->TTStart();
}



