#include "PageManager.h"
#include "Allocator.h"

unsigned int PageManager::PHY_MEM_SIZE;
unsigned int UserPageManager::USER_PAGE_POOL_SIZE;

PageManager::PageManager(Allocator* allocator)
{
	this->m_pAllocator = allocator;
}

int PageManager::Initialize()
{
	for ( unsigned int i = 0; i < MEMORY_MAP_ARRAY_SIZE; i++ ) 
	{
		this->map[i].m_AddressIdx = 0;
		this->map[i].m_Size = 0;
	}
	for ( unsigned int i = 0; i < PAGE_REF_ARRAY_SIZE; i++ )
	{
		this->m_PageRef[i] = 0;
	}
	return 0;
}

unsigned long PageManager::AllocMemory(unsigned long size)
{
	unsigned long pageCount = (size + (PAGE_SIZE -1)) / PAGE_SIZE;
	unsigned long address = this->m_pAllocator->Alloc(this->map, pageCount) * PAGE_SIZE;

	if (address == 0)
	{
		return 0;
	}

	unsigned int startFrame = (unsigned int)(address / PAGE_SIZE);
	for (unsigned int i = 0; i < pageCount; i++)
	{
		this->SetPageRef(startFrame + i, 1);
	}

	return address;
}

unsigned long PageManager::FreeMemory(unsigned long size, unsigned long startAddress)
{
	unsigned long pageCount = (size + (PAGE_SIZE -1)) / PAGE_SIZE;
	unsigned int startFrame = (unsigned int)(startAddress / PAGE_SIZE);

	for (unsigned int i = 0; i < pageCount; i++)
	{
		unsigned int frame = startFrame + i;
		int ref = this->GetPageRef(frame);
		if (ref <= 0)
		{
			continue;
		}

		if (this->DecPageRef(frame) == 0)
		{
			this->m_pAllocator->Free(this->map, 1, frame);
		}
	}

	return startAddress;
}

int PageManager::GetPageRef(unsigned int pageFrame) const
{
	if (pageFrame >= PAGE_REF_ARRAY_SIZE)
	{
		return 0;
	}
	return this->m_PageRef[pageFrame];
}

void PageManager::SetPageRef(unsigned int pageFrame, int value)
{
	if (pageFrame >= PAGE_REF_ARRAY_SIZE)
	{
		return;
	}
	this->m_PageRef[pageFrame] = value;
}

void PageManager::IncPageRef(unsigned int pageFrame)
{
	if (pageFrame >= PAGE_REF_ARRAY_SIZE)
	{
		return;
	}
	this->m_PageRef[pageFrame]++;
}

int PageManager::DecPageRef(unsigned int pageFrame)
{
	if (pageFrame >= PAGE_REF_ARRAY_SIZE)
	{
		return 0;
	}
	if (this->m_PageRef[pageFrame] > 0)
	{
		this->m_PageRef[pageFrame]--;
	}
	return this->m_PageRef[pageFrame];
}

PageManager::~PageManager()
{
}

KernelPageManager::KernelPageManager(Allocator* allocator)
	:PageManager(allocator)
{
}

int KernelPageManager::Initialize()
{
	PageManager::Initialize();
	
	this->map[0].m_AddressIdx = 
		KERNEL_PAGE_POOL_START_ADDR / PageManager::PAGE_SIZE;
	this->map[0].m_Size = 
		KERNEL_PAGE_POOL_SIZE / PageManager::PAGE_SIZE;
	return 0;
}

UserPageManager::UserPageManager(Allocator* allocator)
	:PageManager(allocator)
{
}

int UserPageManager::Initialize()
{
	PageManager::Initialize();
	
	this->map[0].m_AddressIdx = 
		USER_PAGE_POOL_START_ADDR / PageManager::PAGE_SIZE;
	this->map[0].m_Size = 
		USER_PAGE_POOL_SIZE / PageManager::PAGE_SIZE;
	return 0;
}

