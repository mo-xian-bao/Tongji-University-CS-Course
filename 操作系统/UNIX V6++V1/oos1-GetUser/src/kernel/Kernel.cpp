#include "Kernel.h"
#include "Machine.h"
#include "New.h"
#include "Video.h"

Kernel Kernel::instance;

/* 
 * 内存管理相关的全局manager
 */
UserPageManager g_UserPageManager(&(Allocator::GetInstance()));
KernelPageManager g_KernelPageManager(&(Allocator::GetInstance()));
KernelAllocator g_KernelAllocator(&(Allocator::GetInstance()));

/*
 * 交换区相关全局manager
 */
SwapperManager g_SwapperManager(&(Allocator::GetInstance()));

/* 
 * 进程相关全局manager
 */
ProcessManager g_ProcessManager;

/*
 * 设备管理、高速缓存管理全局manager
 */
BufferManager g_BufferManager;
DeviceManager g_DeviceManager;

/*
 * 文件系统相关全局manager
 */
FileSystem g_FileSystem;
FileManager g_FileManager;

Kernel::Kernel()
{
}

Kernel::~Kernel()
{
}

Kernel& Kernel::Instance()
{
	return Kernel::instance;
}

void Kernel::InitMemory()
{
	this->m_KernelPageManager = &g_KernelPageManager;
	this->m_UserPageManager = &g_UserPageManager;
	
	Diagnose::Write("Initilize Memory...");
	this->GetKernelPageManager().Initialize();
	this->GetUserPageManager().Initialize();
	Diagnose::Write("Ok.\n");

	this->m_KernelAllocator = &g_KernelAllocator;

	Diagnose::Write("Initilize KernelAllocator...");
	this->GetKernelAllocator().Initialize();
	Diagnose::Write("Ok.\n");

	/* 设置new/delete operator需要使用的Allocator */
	set_kernel_allocator(this->m_KernelAllocator);

	this->m_SwapperManager = &g_SwapperManager;
	Diagnose::Write("Initialize Swapper...");
	this->GetSwapperManager().Initialize();
	Diagnose::Write("Ok.\n");

}

void Kernel::InitProcess()
{
	this->m_ProcessManager = &g_ProcessManager;

	Diagnose::Write("Initilize Process...");
	this->GetProcessManager().Initialize();
	Diagnose::Write("Ok.\n");
}

void Kernel::InitBuffer()
{
	this->m_BufferManager = &g_BufferManager;
	this->m_DeviceManager = &g_DeviceManager;

	Diagnose::Write("Initialize Buffer...");
	this->GetBufferManager().Initialize();
	Diagnose::Write("OK.\n");

	Diagnose::Write("Initialize Device Manager...");
	this->GetDeviceManager().Initialize();
	Diagnose::Write("OK.\n");
}

void Kernel::InitFileSystem()
{
	this->m_FileSystem = &g_FileSystem;
	this->m_FileManager = &g_FileManager;

	Diagnose::Write("Initialize File System...");
	this->GetFileSystem().Initialize();
	Diagnose::Write("OK.\n");

	Diagnose::Write("Initialize File Manager...");
	this->GetFileManager().Initialize();
	Diagnose::Write("OK.\n");
}

void Kernel::Initialize()
{
	InitMemory();
	InitProcess();
	InitBuffer();
	InitFileSystem();
}

KernelPageManager& Kernel::GetKernelPageManager()
{
	return *(this->m_KernelPageManager);
}

UserPageManager& Kernel::GetUserPageManager()
{
	return *(this->m_UserPageManager);
}

ProcessManager& Kernel::GetProcessManager()
{
	return *(this->m_ProcessManager);
}

KernelAllocator& Kernel::GetKernelAllocator()
{
	return *(this->m_KernelAllocator);
}

SwapperManager& Kernel::GetSwapperManager()
{
	return *(this->m_SwapperManager);
}

BufferManager& Kernel::GetBufferManager()
{
	return *(this->m_BufferManager);
}

DeviceManager& Kernel::GetDeviceManager()
{
	return *(this->m_DeviceManager);
}

FileSystem& Kernel::GetFileSystem()
{
	return *(this->m_FileSystem);
}

FileManager& Kernel::GetFileManager()
{
	return *(this->m_FileManager);
}

User& Kernel::GetUser()
{
	/*
	 * Linus 的方法：用 ESP 寄存器定位现运行进程的 User 结构。
	 * 
	 * 原理：每个进程的 PPDA（包含 User 结构和内核栈）占用一个 4KB 页。
	 * User 结构位于 PPDA 页的起始位置，内核栈从页顶向下增长。
	 * 当进程在内核态运行时，ESP 指向该 PPDA 页内的某个位置。
	 * 将 ESP 与 ~(USIZE - 1) 进行与运算，清除低 12 位，
	 * 即可得到 PPDA 页的起始地址，也就是 User 结构的地址。
	 */
	unsigned long esp;
	__asm__ __volatile__("movl %%esp, %0" : "=r"(esp));
		
	User* pUser = (User*)(esp & ~(ProcessManager::USIZE - 1));
	
	/* 验证：ESP 方法与固定地址方法结果应一致 */
	if ((unsigned long)pUser != USER_ADDRESS)
	{
		Diagnose::Write("GetUser ERROR: ESP=0x%x, pUser=0x%x, expected=0x%x\n", 
			esp, (unsigned long)pUser, USER_ADDRESS);
	}
	else{
		Diagnose::Write("GetUser OK: ESP=0x%x, pUser=0x%x, expected=0x%x\n", 
			esp, (unsigned long)pUser, USER_ADDRESS);
	}
	
	return *pUser;
}