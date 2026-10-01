#include "sys.h"
#include "stdlib.h"

int execv(char *pathname, char *argv[])
{
	int res;
	int argc = 0;
	while(argv[argc] != 0)
		argc++;	
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(11),"b"(pathname),"c"(argc),"d"(argv));
	if ( res >= 0 )
		return res;
	return -1;
}

int fork()
{
	int res;
	__asm__ __volatile__ ( "int $0x80":"=a"(res):"a"(2));
	if ( res >= 0 )
		return res;
	return -1;
}

int wait(int* status)	/* 获取子进程返回的Return Code */
{
	int res;
	__asm__ __volatile__ ( "int $0x80":"=a"(res):"a"(7),"b"(status));
	if ( res >= 0 )
		return res;
	return -1;
}

int exit(int status)	/* 子进程返回给父进程的Return Code */
{
	int res;
	__asm__ __volatile__ ( "int $0x80":"=a"(res):"a"(1),"b"(status));
	if ( res >= 0 )
		return res;
	return -1;
}

int signal(int signal, void (*func)())
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(48),"b"(signal), "c"(func) );
	if ( res >= 0 )
		return res;
	return -1;
}

int kill(int pid, int signal)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(37),"b"(pid), "c"(signal) );
	if ( res >= 0 )
		return res;
	return -1;
}

int sleep(unsigned int seconds)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(35),"b"(seconds) );
	if ( res >= 0 )
		return res;
	return -1;
}

/* 使用errno需要include "stdlib.h" */
extern errno;
int brk(void * newEndDataAddr)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(17),"b"(newEndDataAddr));
	/* 系统调用的返回值赋值APP的全局变量errno */
	if ( res >= 0 )
		return res;
	errno = -1*res;
	printf("%d\n",errno);
	return -1;
}

int syncFileSystem()
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(36) );
	if ( res >= 0 )
		return res;
	return -1;
}

int getPath(char *path)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(39),"b"(path));
	if ( res >= 0 )
		return res;
	return -1;
}

int getpid()
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(20) );
	if ( res >= 0 )
		return res;
	return -1;
}

unsigned int getgid()
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(47) );
	if ( res >= 0 )
		return res;
	return -1;
}

unsigned int getuid()
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(24) );
	if ( res >= 0 )
		return res;
	return -1;
}

int setgid(short gid)
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(46),"b"(gid) );
	if ( res >= 0 )
		return res;
	return -1;
}

int setuid(short uid)
{
	int res;
	__asm__ volatile ( "int $0x80":"=a"(res):"a"(23),"b"(uid) );
	if ( res >= 0 )
		return res;
	return -1;
}

int gettime(struct tms* ptms)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(13),"b"(ptms) );
	if ( res >= 0 )
		return res;
	return -1;
}

int times(struct tms* ptms)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(43),"b"(ptms) );
	if ( res >= 0 )
		return res;
	return -1;
}

int getswtch()
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(38) );
	if ( res >= 0 )
		return res;
	return -1;
}

int trace(int lines)
{
	int res;
	__asm__ volatile ("int $0x80":"=a"(res):"a"(29),"b"(lines) );
	if ( res >= 0 )
		return res;
	return -1;
}

unsigned int fakeedata = 0;
int sbrk(int increment)
{
	if (fakeedata == 0)
	{
		fakeedata = brk(0);
	}
	unsigned int newedata = fakeedata + increment - 1;
	brk(((newedata >> 12) + 1) << 12);
	fakeedata = newedata + 1;
	return fakeedata;
}

/* 49号系统调用 - 获取父进程PID */
int getppid()
{
	int res;
	__asm__ volatile("int $0x80" : "=a"(res) : "a"(49));
	if (res >= 0)
		return res;
	return -1;
}

/* 50号系统调用 - 获取当前进程和父进程PID数组 */
int getpids(int *pids)
{
	int res;
	__asm__ volatile("int $0x80" : "=a"(res) : "a"(50), "b"(pids));
	if (res >= 0)
		return res;
	return -1;
}

/* 51号系统调用 - 获取进程详细信息 */
int getproc(struct proc_info *info)
{
	int res;
	__asm__ volatile("int $0x80" : "=a"(res) : "a"(51), "b"(info));
	if (res >= 0)
		return res;
	return -1;
}

/* 
 * setjmp/longjmp - 远跳转API (纯汇编实现)
 * 
 * 功能: 实现非本地跳转，用于从信号处理函数等位置跳回到安全点
 * 
 * jmp_buf 结构 (24字节):
 *   env[0]  (偏移0):  ebx
 *   env[1]  (偏移4):  esi
 *   env[2]  (偏移8):  edi
 *   env[3]  (偏移12): ebp (栈帧指针)
 *   env[4]  (偏移16): esp (栈指针)
 *   env[5]  (偏移20): eip (返回地址)
 */

/*
 * int setjmp(jmp_buf env)
 * 
 * 功能: 保存当前执行环境到 env 中
 * 返回值: 首次调用返回0; 由longjmp跳转回来时返回longjmp的val参数
 * 
 * 调用时栈布局:
 *   esp+4: env参数 (jmp_buf指针)
 *   esp:   返回地址 (call指令压入)
 */
__asm__(
".globl _setjmp\n"
"_setjmp:\n"
"	movl 4(%esp), %eax\n"      /* eax = env, 获取jmp_buf指针参数 */
"	movl %ebx, 0(%eax)\n"      /* env[0] = ebx, 保存被调用者保存寄存器 */
"	movl %esi, 4(%eax)\n"      /* env[1] = esi */
"	movl %edi, 8(%eax)\n"      /* env[2] = edi */
"	movl %ebp, 12(%eax)\n"     /* env[3] = ebp, 保存栈帧指针 */
"	leal 4(%esp), %ecx\n"      /* ecx = esp+4, 即setjmp返回后调用者的esp值 */
"	movl %ecx, 16(%eax)\n"     /* env[4] = 调用者的esp */
"	movl (%esp), %ecx\n"       /* ecx = 返回地址 (setjmp调用后的下一条指令) */
"	movl %ecx, 20(%eax)\n"     /* env[5] = 返回地址 */
"	xorl %eax, %eax\n"         /* eax = 0, 首次调用setjmp返回0 */
"	ret\n"                     /* 返回到调用者 */
);

/*
 * void longjmp(jmp_buf env, int val)
 * 
 * 功能: 恢复env中保存的执行环境，跳转回setjmp调用处
 * 参数: env - 由setjmp保存的环境; val - setjmp的返回值(0会被改为1)
 * 
 * 调用时栈布局:
 *   esp+8: val参数
 *   esp+4: env参数 (jmp_buf指针)
 *   esp:   返回地址 (不会使用，直接跳转)
 */
__asm__(
".globl _longjmp\n"
"_longjmp:\n"
"	movl 4(%esp), %edx\n"      /* edx = env, 获取jmp_buf指针 */
"	movl 8(%esp), %eax\n"      /* eax = val, 获取返回值参数 */
"	testl %eax, %eax\n"        /* 测试val是否为0 */
"	jnz 1f\n"                  /* 不为0则跳过下一条 */
"	incl %eax\n"               /* val为0时改为1, 因为setjmp首次返回0需区分 */
"1:\n"
"	movl 0(%edx), %ebx\n"      /* 恢复ebx */
"	movl 4(%edx), %esi\n"      /* 恢复esi */
"	movl 8(%edx), %edi\n"      /* 恢复edi */
"	movl 12(%edx), %ebp\n"     /* 恢复ebp栈帧指针 */
"	movl 16(%edx), %esp\n"     /* 恢复esp栈指针 - 关键! 切换回setjmp调用者的栈 */
"	jmp *20(%edx)\n"           /* 跳转到setjmp的返回地址, eax中的值作为setjmp返回值 */
);