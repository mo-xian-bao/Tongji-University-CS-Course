## 系统功能一览及使用说明
输入输出区、系统打印区均为滚动设计。

#### 输入输出区
- 支持键盘 `PageUp`、`PageDown` 滚动。
- 支持鼠标滚轮滚动（虚拟机启动时默认是禁用鼠标状态，通过 `Ctrl + 鼠标中键` 来启用和禁用鼠标）。
- 支持方向键上下获取最近的命令。
- 查看历史信息时有新输入跳转到输入行。

#### 系统打印区
- 支持键盘 `Alt + PageUp`、`Alt + PageDown` 滚动。



## 配置说明
上面各文件夹是所有src下做过修改的文件夹，其中有所有修改或新增的文件。若原本存在，覆盖即可，不存在则新增。  
然后还要修改虚拟机配置文件bochsrc.bxrc

#### include/
- 修改 `CRT.h`：新增屏幕刷新和历史缓冲区管理等定义。
- 修改 `TTy.h`：新增历史输入命令管理支持。
- 修改 `Video.h`：新增屏幕刷新和历史缓冲区管理等定义。
- 修改 `Chip8259A.h`：新增鼠标端口IRQ 12的宏定义。
- **新增** `Mouse.h`：定义鼠标设备操作类，包括初始化和中断处理。
- **新增** `MouseInterrupt.h`：定义鼠标中断入口函数类。

#### interrupt/
- 修改 `Makefile`：加上对MouseInterrupt.cpp的编译。
- **新增** `MouseInterrupt.cpp`：实现鼠标中断处理函数，负责中断现场保存、恢复和EOI发送，内部调用鼠标类中的handler。

#### kernel/
- 修改 `main.cpp`：新增鼠标IRQ 12端口的启用和鼠标初始化。
- 修改 `Video.cpp`：实现Diagnose类的缓冲区和屏幕滚动刷新，修改换行、清屏、写入字符逻辑。

#### machine/
- 修改 `Machine.cpp`：加入鼠标中断的IDT表注册。

#### tty/
- 修改 `CRT.cpp`：实现CRT类的成员函数（包括刷新屏幕、清屏、换行、退格和写入字符逻辑），处理字符输出到视频内存和光标控制。
- 修改 `Keyboard.cpp`：实现键盘处理类，包括扫描码解析和字符映射。
- 修改 `Makefile`：加入Mouse.cpp的编译。
- 修改 `TTy.cpp`：实现TTY类的成员函数（包括保存历史命令、上下切换历史命令），管理字符队列和输入输出流程。
- **新增** `Mouse.cpp`：实现Mouse类的成员函数，初始化鼠标设备并处理数据包。

#### 其他
- 修改 `bochsrc.bxrc`：加入鼠标的四字节模式的支持。





## 进阶配置说明
对于 `Chip8259A.h`、`main.cpp`、`Machine.cpp`、`bochsrc.bxrc` 这些公用文件，如果先前有修改过，不方便直接覆盖，请参考下面来配置：

#### Chip8259A.h
在 `public` 中加入这一行宏定义（给出文件的第59行）：
```cpp
static const unsigned int IRQ_MOUSE = 12;   //鼠标中断发到从片的IR4引脚
```

#### main.cpp
在 `main0` 函数中加入这两行调用（给出文件的第63-65行）：
```cpp
//初始化鼠标
Mouse::Init();
Chip8259A::IrqEnable(Chip8259A::IRQ_MOUSE);    //开启鼠标中断 (IRQ 12)，主片级联从片的引脚上面已经启用
```

#### Machine.cpp
在 `InitIDT` 函数中加入这一行调用（给出文件的第96-98行）：
```cpp
/* 设置鼠标中断的中断门 */
/* IRQ 0 映射到 0x20，那么 IRQ 12 就是 0x2C */
this->GetIDT().SetInterruptGate(0x2C, (unsigned long)MouseInterrupt::MouseInterruptEntrance);
```

#### bochsrc.bxrc
在鼠标配置后加入“`type=imps2`”（给出文件的第36行，初始应该是“`mouse: enabled=0`”）：
```
# disable the mouse, since DLX is text only
mouse: enabled=0, type=imps2
```