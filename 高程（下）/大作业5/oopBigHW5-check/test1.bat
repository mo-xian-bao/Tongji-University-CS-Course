   hw_check_demo --action base --cno 10108001 --stu all --file all > demo.txt
   hw_check_demo --action base --cno 10108002 --stu all --file all >> demo.txt
   hw_check_demo --action base --cno 5000244001602 --stu all --file all >> demo.txt
   hw_check_demo --action firstline --cno 10108001 --stu all --file all >> demo.txt
   hw_check_demo --action firstline --cno 10108002 --stu all --file all >> demo.txt
   hw_check_demo --action firstline --cno 5000244001602 --stu all --file all >> demo.txt
   hw_check_demo --action secondline --cno 10108001,10108002 --stu all --file 15-b2.cpp > demo.txt
   hw_check_demo --action secondline --cno 10108001,10108002 --stu all --file 15-b5.c >> demo.txt
   hw_check_demo --action secondline --cno 10108001 --stu all --file 15-b5.c >> demo.txt
   hw_check_demo --action secondline --cno 10108002 --stu all --file 15-b5.c >> demo.txt
   hw_check_demo --action secondline --cno 5000244001602 --stu all --file 5-b14.c >> demo.txt
   hw_check_demo --action firstline --cno 10108001 --stu all --file 15-b8-bmp.h >> demo.txt
   hw_check_demo --action firstline --cno 10108002 --stu all --file 15-b8-bmp.h >> demo.txt
   hw_check_demo --action firstline --cno 5000244001602 --stu all --file 5-b14.c >> demo.txt
   hw_check_demo --action base --cno 10108001 --stu all --file 15-b8-bmp.h >> demo.txt
   hw_check_demo --action base --cno 10108002 --stu all --file 15-b8-bmp.h >> demo.txt
   hw_check_demo --action base --cno 5000244001602 --stu all --file 5-b14.c >> demo.txt
   hw_check --action base --cno 10108001 --stu all --file all > my.txt
   hw_check --action base --cno 10108002 --stu all --file all >> my.txt
   hw_check --action base --cno 5000244001602 --stu all --file all >> my.txt
   hw_check --action firstline --cno 10108001 --stu all --file all >> my.txt
   hw_check --action firstline --cno 10108002 --stu all --file all >> my.txt
   hw_check --action firstline --cno 5000244001602 --stu all --file all >> my.txt
   hw_check --action secondline --cno 10108001,10108002 --stu all --file 15-b2.cpp > my.txt
   hw_check --action secondline --cno 10108001,10108002 --stu all --file 15-b5.c >> my.txt
   hw_check --action secondline --cno 10108001 --stu all --file 15-b5.c >> my.txt
   hw_check --action secondline --cno 10108002 --stu all --file 15-b5.c >> my.txt
   hw_check --action secondline --cno 5000244001602 --stu all --file 5-b14.c >> my.txt
   hw_check --action firstline --cno 10108001 --stu all --file 15-b8-bmp.h >> my.txt
   hw_check --action firstline --cno 10108002 --stu all --file 15-b8-bmp.h >> my.txt
   hw_check --action firstline --cno 5000244001602 --stu all --file 5-b14.c >> my.txt
   hw_check --action base --cno 10108001 --stu all --file 15-b8-bmp.h >> my.txt
   hw_check --action base --cno 10108002 --stu all --file 15-b8-bmp.h >> my.txt
   hw_check --action base --cno 5000244001602 --stu all --file 5-b14.c >> my.txt

   hw_check_demo --action firstline --cno 10108001 --stu 2354366 --file all --chapter 12> demo.txt
   hw_check_demo --action firstline --cno 10108001 --stu 2354366 --file all --week 10>> demo.txt
   hw_check_demo --action firstline --cno 10108001 --stu 2354366 --file all --week 9 --chapter 15>> demo.txt

   hw_check --action firstline --cno 10108001 --stu 2354366 --file all --chapter 12> my.txt
   hw_check --action firstline --cno 10108001 --stu 2354366 --file all --week 10>> my.txt
   hw_check --action firstline --cno 10108001 --stu 2354366 --file all --week 9 --chapter 15>> my.txt

compare --file1 demo.txt --file2 my.txt --display detailed --trim right > result.txt

