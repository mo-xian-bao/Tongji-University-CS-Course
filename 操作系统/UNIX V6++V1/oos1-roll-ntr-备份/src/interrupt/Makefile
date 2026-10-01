SHELL := cmd.exe
include ..\Makefile.inc

TARGET = ..\..\targets\objs

all		:	$(TARGET)\exception.o $(TARGET)\systemcall.o $(TARGET)\diskinterrupt.o \
			$(TARGET)\keyboardinterrupt.o $(TARGET)\timeinterrupt.o $(TARGET)\mouseinterrupt.o
			
			
$(TARGET)\exception.o	:	Exception.cpp $(INCLUDE)\Exception.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@
	
$(TARGET)\systemcall.o	:	SystemCall.cpp $(INCLUDE)\SystemCall.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@
	
$(TARGET)\diskinterrupt.o	:	DiskInterrupt.cpp $(INCLUDE)\DiskInterrupt.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@

$(TARGET)\keyboardinterrupt.o	:	KeyboardInterrupt.cpp $(INCLUDE)\KeyboardInterrupt.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@
	
$(TARGET)\timeinterrupt.o	:	TimeInterrupt.cpp $(INCLUDE)\TimeInterrupt.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@

$(TARGET)\mouseinterrupt.o	:	MouseInterrupt.cpp $(INCLUDE)\MouseInterrupt.h
	$(CC) $(CFLAGS) -I"$(INCLUDE)" -c $< -o $@
	