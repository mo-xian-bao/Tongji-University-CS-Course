class Process {
public:
    // 1. 进程标识
    short p_uid;          // 用户标识 (User ID)。标识该进程属于哪个用户。操作系统根据用户ID来判断进程对文件和其他资源的访问权限。
    int p_pid;            // 进程标识 (Process ID)。唯一标识一个进程的编号。
    int p_ppid;           // 父进程标识 (Parent Process ID)。创建该进程的父进程的PID。这构成了系统的进程树状结构。

    // 2. 分配给正文段和可交换部分的物理内存
    unsigned long p_addr; // 可交换部分起始地址。包括PPDA，数据段和用户栈。
    unsigned int p_size;  // 可交换部分的长度（以字节为单位）
    Text *p_textp;        // 指向正文段控制块的指针，指向一个Text结构体，该结构体描述了进程的代码段（正文段）。通过这种方式，多个进程可以共享同一个代码段，以节省内存。

    // 3. 进程状态
    ProcessState p_stat;  // CPU调度状态
    int p_flag;           // 其他状态标识。SLOAD值为1时，表示进程的核心部分（可交换部分和正文段）当前位于主内存中。SSYS值为1时，表示这是一个系统进程，例如调度进程或交换进程，它们不能被换出。

    // 4. 进程优先数
    int p_pri;            // 进程优先级，数值越小，优先级越高。调度程序会选择优先级最高的就绪进程来运行。
    int p_nice;           // 用于计算进程优先级的基准量
    int p_cpu;            // CPU使用时长的记录

    // 5. 驻留时间，是一个计时器
    int p_time;           // 进程在盘交换区或内存的驻留时间

    // 6. 进程睡眠原因
    unsigned long p_wchan; // 如果进程处于睡眠状态，p_wchan 指向它正在等待的内核事件的地址。

    // 7. 进程收到的信号
    int p_sig;            // 进程收到的信号

    // 8. 进程的终端
    TTy *p_ttyp;          // 键盘输入、屏幕输出的控制终端指针
};

class User {
public:
    // 0. 连接Process结构
    Process *u_procp;      // 指向Process结构的指针

    // 1. 内存描述符
    MemoryDescriptor u_MemoryDescriptor; // 这是一个结构体，详细描述了进程的虚拟地址空间布局，包括代码段、数据段和栈的起始地址与大小

    // 2. 进程切换时，用来保护 ESP、EBP
    unsigned long u_rsav[2];
    unsigned long u_ssav[2];

    // 3. 登记进程运行时长
    int u_utime;          // 用户态运行时长
    int u_stime;          // 核心态运行时长
    int u_cutime;         // 子进程用户态运行时长的总和
    int u_cstime;         // 子进程核心态运行时长的总和

    // 4. 信号处理与被打断的系统调用
    unsigned long u_signal[NSIG]; // 信号处理方式
    unsigned long u_qsav[2];      // 信号接收进程应立即返回用户态执行信号处理函数，这是被打断的系统调用的远跳转点
    bool u_intflg;       // 标识系统调用执行状态。1表示系统调用被打断，0表示未被打断。

    // 5. 进程的用户标识
    short u_uid;          // 有效用户ID
    short u_gid;          // 有效组ID。用于权限检查。通常，它与真实ID相同，但在执行设置了set-user-ID权限位的程序时，有效ID会临时变为程序文件的所有者ID。
    short u_ruid;         // 真实用户ID
    short u_rgid;         // 真实组ID

    // 6. 系统调用的入口参数和出错码
    unsigned int *u_ar0;
    int u_arg[5];
    ErrorCode u_error;    // 系统调用的出错码

    // 7. 文件系统访问类系统调用需要使用的全局变量
    Inode *u_cdir;        // 当前工作目录的内存i-node
    char u_curdir[128];   // 当前工作目录的完整路径

    OpenFiles u_ofiles;   // 打开文件表，进程正在使用的所有文件的状态
    IOParameter u_IOParam; // read, write系统调用的工作参数

    char *u_dirp;        // 入口参数，目标文件或目录的路径名
    DirectoryEntry u_dent; // 当前目录的目录项
    char u_dbuf[DirectoryEntry::DIRSIZ]; // 下个路径名分量
    Inode *u_pdir;       // 当前目录的父目录i-node

    // 8. Unix V6过时字段，Unix V6++没用到
    int u_segflg;
};