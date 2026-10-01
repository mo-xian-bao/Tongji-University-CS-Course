ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
 
export CROSS_COMPILE
######################################################################### 

# 得到Makefile文件所在的路径 
TOPDIR := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)
export TOPDIR

# 引用config.mk文件 
include $(TOPDIR)/config.mk

# 定义了几个子目录
SUBDIRS = common ucos port

# 每个子目录下面存在的LIB库文件 
LIBS = common/common.o ucos/ucos.o port/port.o

######################################################################### 

# 编译的目标，注意其中的OS.bin 
all: ucosii.om ucosii.bin ucosii.asm OS.bin

ucosii.om: depend subdirs $(LIBS) Makefile
	$(CC) -Tram.ld -o $@ $(LIBS) -nostdlib $(LDFLAGS)

ucosii.bin: ucosii.om
	mips-sde-elf-objcopy -O binary $< $@

OS.bin: ucosii.bin
	./BinMerge.exe -f $< -o $@

ucosii.asm: ucosii.om
	mips-sde-elf-objdump -D $< > $@

######################################################################### 

depend dep:
	@for dir in $(SUBDIRS) ; do $(MAKE) -C $$dir .depend ; done

subdirs:
	@for dir in $(SUBDIRS) ; do $(MAKE) -C $$dir || exit 1 ; done

clean:
	find . -type f \
		\( -name 'core' -o -name '*.bak' -o -name '*~' \
		-o -name '*.o'  -o -name '*.tmp' -o -name '*.hex' \
		-o -name 'OS.bin' -o -name 'ucosii.bin' -o -name '*.srec' \
		-o -name '*.mem' -o -name '*.img' -o -name '*.out' \
		-o -name '*.aux' -o -name '*.log' -o -name '*.data' \) -print \
		| xargs rm -f
	rm -f System.map

distclean: clean
	find . -type f \
		\( -name .depend -o -name '*.srec' -o -name '*.bin' \
		-o -name '*.pdf' \) \
		-print | xargs rm -f
	rm -f $(OBJS) *.bak tags TAGS
	rm -fr *.*~

#########################################################################