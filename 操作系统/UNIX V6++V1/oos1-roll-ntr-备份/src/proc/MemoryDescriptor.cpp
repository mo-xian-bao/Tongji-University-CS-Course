#include "MemoryDescriptor.h"
#include "Kernel.h"
#include "PageManager.h"
#include "Machine.h"
#include "PageDirectory.h"
#include "Video.h"

/* 相对页表项编码模式：0=相对页框（旧语义），1=绝对页框（为后续COW共享页准备） */
static const unsigned int REL_ENTRY_MODE_RELATIVE = 0;
static const unsigned int REL_ENTRY_MODE_ABSOLUTE = 1;

void MemoryDescriptor::Initialize()
{
	KernelPageManager& kernelPageManager = Kernel::Instance().GetKernelPageManager();
	
	/* m_UserPageTableArray需要把AllocMemory()返回的物理内存地址 + 0xC0000000 */
	this->m_UserPageTableArray = (PageTable*)(kernelPageManager.AllocMemory(sizeof(PageTable) * USER_SPACE_PAGE_TABLE_CNT) + Machine::KERNEL_SPACE_START_ADDRESS);
}

void MemoryDescriptor::Release()
{
	KernelPageManager& kernelPageManager = Kernel::Instance().GetKernelPageManager();
	if ( this->m_UserPageTableArray )
	{
		kernelPageManager.FreeMemory(sizeof(PageTable) * USER_SPACE_PAGE_TABLE_CNT, (unsigned long)this->m_UserPageTableArray - Machine::KERNEL_SPACE_START_ADDRESS);
		this->m_UserPageTableArray = NULL;
	}
}

unsigned int MemoryDescriptor::MapEntry(unsigned long virtualAddress, unsigned int size, unsigned long phyPageIdx, bool isReadWrite)
{	
	unsigned long address = virtualAddress - USER_SPACE_START_ADDRESS;

	/* 私有1#用户页表对应虚地址[4M,8M)，映射下标范围[0,1023] */
	if (address < PageTable::SIZE_PER_PAGETABLE_MAP)
	{
		return phyPageIdx;
	}

	unsigned long startIdx = (address >> 12) - PageTable::ENTRY_CNT_PER_PAGETABLE;
	unsigned long cnt = ( size + (PageManager::PAGE_SIZE - 1) )/ PageManager::PAGE_SIZE;

	PageTableEntry* entrys = (PageTableEntry*)this->m_UserPageTableArray;
	for ( unsigned int i = startIdx; i < startIdx + cnt; i++, phyPageIdx++ )
	{
		entrys[i].m_Present = 0x1;
		entrys[i].m_UserSupervisor = 0x1;
		entrys[i].m_ReadWriter = isReadWrite;
		entrys[i].m_ForSystemUser = REL_ENTRY_MODE_RELATIVE;
		entrys[i].m_PageBaseAddress = phyPageIdx;
	}
	return phyPageIdx;
}

void MemoryDescriptor::MapTextEntrys(unsigned long textStartAddress, unsigned long textSize, unsigned long textPageIdx)
{
	this->MapEntry(textStartAddress, textSize, textPageIdx, false);
}
void MemoryDescriptor::MapDataEntrys(unsigned long dataStartAddress, unsigned long dataSize, unsigned long dataPageIdx)
{
	this->MapEntry(dataStartAddress, dataSize, dataPageIdx, true);
}

void MemoryDescriptor::MapStackEntrys(unsigned long stackSize, unsigned long stackPageIdx)
{
	unsigned long stackStartAddress = (USER_SPACE_START_ADDRESS + USER_SPACE_SIZE - stackSize) & 0xFFFFF000;
	this->MapEntry(stackStartAddress, stackSize, stackPageIdx, true);
}

PageTable* MemoryDescriptor::GetUserPageTableArray()
{
	return this->m_UserPageTableArray;
}
unsigned long MemoryDescriptor::GetTextStartAddress()
{
	return this->m_TextStartAddress;
}
unsigned long MemoryDescriptor::GetTextSize()
{
	return this->m_TextSize;
}
unsigned long MemoryDescriptor::GetDataStartAddress()
{
	return this->m_DataStartAddress;
}
unsigned long MemoryDescriptor::GetDataSize()
{
	return this->m_DataSize;
}
unsigned long MemoryDescriptor::GetStackSize()
{
	return this->m_StackSize;
}

bool MemoryDescriptor::EstablishUserPageTable( unsigned long textVirtualAddress, unsigned long textSize, unsigned long dataVirtualAddress, unsigned long dataSize, unsigned long stackSize )
{
	User& u = Kernel::Instance().GetUser();

	/* 如果超出允许的用户程序最大8M的地址空间限制 */
	if ( textSize + dataSize + stackSize  + PageManager::PAGE_SIZE > USER_SPACE_SIZE - textVirtualAddress)
	{
		u.u_error = User::ENOMEM;
		Diagnose::Write("u.u_error = %d\n",u.u_error);
		return false;
	}

	this->ClearUserPageTable();

	/* 以页框偏移量phyPageIndex == 0，为正文段建立相对地址映照表 */
	unsigned int phyPageIndex = 0;
	phyPageIndex = this->MapEntry(textVirtualAddress, textSize, phyPageIndex, false);

	/* 以相对起始地址phyPageIndex为1，ppda区占用1页4K大小物理内存，为数据段建立相对地址映照表 */
	phyPageIndex = 1;
	phyPageIndex = this->MapEntry(dataVirtualAddress, dataSize, phyPageIndex, true);

	/* 紧跟着数据段之后，为堆栈段建立相对地址映照表 */
	unsigned long stackStartAddress = (USER_SPACE_START_ADDRESS + USER_SPACE_SIZE - stackSize) & 0xFFFFF000;
	this->MapEntry(stackStartAddress, stackSize, phyPageIndex, true);

	/* 将相对地址映照表根据正文段和数据段在内存中的起始地址pText->x_caddr、p_addr，建立用户态内存区的页表映射 */
	this->MapToPageTable();
	return true;
}

void MemoryDescriptor::ClearUserPageTable()
{
	User& u = Kernel::Instance().GetUser();
	PageTable* pUserPageTable = u.u_MemoryDescriptor.m_UserPageTableArray;

	unsigned int j ;

	for (j = 0; j < PageTable::ENTRY_CNT_PER_PAGETABLE; j++ )
	{
		/* 第0张：相对地址映照表 */
		pUserPageTable[0].m_Entrys[j].m_Present = 0;
		pUserPageTable[0].m_Entrys[j].m_ReadWriter = 0;
		pUserPageTable[0].m_Entrys[j].m_UserSupervisor = 1;
		pUserPageTable[0].m_Entrys[j].m_ForSystemUser = REL_ENTRY_MODE_RELATIVE;
		pUserPageTable[0].m_Entrys[j].m_PageBaseAddress = 0;

		/* 第1张：供PDE1使用的实际页表 */
		pUserPageTable[1].m_Entrys[j].m_Present = 0;
		pUserPageTable[1].m_Entrys[j].m_ReadWriter = 0;
		pUserPageTable[1].m_Entrys[j].m_UserSupervisor = 1;
		pUserPageTable[1].m_Entrys[j].m_ForSystemUser = REL_ENTRY_MODE_RELATIVE;
		pUserPageTable[1].m_Entrys[j].m_PageBaseAddress = 0;
	}

}

void MemoryDescriptor::DisplayPageTable()
{
	unsigned int i,j;

	Diagnose::Write("Process PT:");
	for (i = 0; i < Machine::USER_PAGE_TABLE_CNT; i++)
		for ( j = 0; j < PageTable::ENTRY_CNT_PER_PAGETABLE; j++)
			if ( 1 == this->m_UserPageTableArray[i].m_Entrys[j].m_Present )
				Diagnose::Write("<%d,%x>  ",i*1024+j,this->m_UserPageTableArray[i].m_Entrys[j].m_PageBaseAddress);
	Diagnose::Write("\n");

	Diagnose::Write("<PPDA,%x>  ",Machine::Instance().GetKernelPageTable().m_Entrys[1023].m_PageBaseAddress);

	PageTable* pUserPageTable = Machine::Instance().GetUserPageTableArray();
	Diagnose::Write("System PT:");
	for (i = 0; i < Machine::USER_PAGE_TABLE_CNT; i++)
		for ( j = 0; j < PageTable::ENTRY_CNT_PER_PAGETABLE; j++)
			if ( 1 == pUserPageTable[i].m_Entrys[j].m_Present )
				Diagnose::Write("<%d,%x>  ",i*1024+j,pUserPageTable[i].m_Entrys[j].m_PageBaseAddress);
	Diagnose::Write("\n");
}

void MemoryDescriptor::MapToPageTable()
{
	User& u = Kernel::Instance().GetUser();

	if(u.u_MemoryDescriptor.m_UserPageTableArray == NULL)
		return;

	PageTable* pUserPageTable = u.u_MemoryDescriptor.m_UserPageTableArray;
	unsigned int textPF = 0;
	if ( u.u_procp->p_textp != NULL )
	{
		textPF = u.u_procp->p_textp->x_caddr >> 12;
	}

	unsigned int pAddrPF = u.u_procp->p_addr >> 12;

	/* table0 存相对映射；table1 存PDE1实际使用的绝对映射 */
	for ( unsigned int j = 0; j < PageTable::ENTRY_CNT_PER_PAGETABLE; j++ )
	{
		pUserPageTable[1].m_Entrys[j].m_Present = 0;

		if ( 1 == this->m_UserPageTableArray[0].m_Entrys[j].m_Present )
		{
			unsigned int targetFrame = 0;
			if (this->m_UserPageTableArray[0].m_Entrys[j].m_ForSystemUser == REL_ENTRY_MODE_ABSOLUTE)
			{
				targetFrame = this->m_UserPageTableArray[0].m_Entrys[j].m_PageBaseAddress;
			}
			else if ( 0 == this->m_UserPageTableArray[0].m_Entrys[j].m_ReadWriter )
			{
				targetFrame = this->m_UserPageTableArray[0].m_Entrys[j].m_PageBaseAddress + textPF;
			}
			else
			{
				targetFrame = this->m_UserPageTableArray[0].m_Entrys[j].m_PageBaseAddress + pAddrPF;
			}

			if ( 0 == this->m_UserPageTableArray[0].m_Entrys[j].m_ReadWriter )
			{
				pUserPageTable[1].m_Entrys[j].m_Present = 1;
				pUserPageTable[1].m_Entrys[j].m_UserSupervisor = 1;
				pUserPageTable[1].m_Entrys[j].m_ReadWriter = 0;
				pUserPageTable[1].m_Entrys[j].m_ForSystemUser = this->m_UserPageTableArray[0].m_Entrys[j].m_ForSystemUser;
				pUserPageTable[1].m_Entrys[j].m_PageBaseAddress = targetFrame;
			}
			else
			{
				pUserPageTable[1].m_Entrys[j].m_Present = 1;
				pUserPageTable[1].m_Entrys[j].m_UserSupervisor = 1;
				pUserPageTable[1].m_Entrys[j].m_ReadWriter = 1;
				pUserPageTable[1].m_Entrys[j].m_ForSystemUser = this->m_UserPageTableArray[0].m_Entrys[j].m_ForSystemUser;
				pUserPageTable[1].m_Entrys[j].m_PageBaseAddress = targetFrame;
			}
		}
	}

	FlushPageDirectory(u.u_procp->GetPageDirectoryPhyAddr());
}

