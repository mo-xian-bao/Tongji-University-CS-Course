/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string>
#include <vector>
#include <iomanip>
#include <fstream>
#include <sstream>

#include "hw_check.h"
#include "../include/class_aat.h"
#include "../include/class_cft.h"
#include "../include_mariadb_x86/mysql/mysql.h"      // mysql特有

using namespace std;

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
 ***************************************************************************/
int main(int argc, char** argv)
{
	const string Action_Name[] = { "base","firstline","secondline","" }; //也可以根据需要，放入头文件中以便共享 

	args_analyse_tools args[] = {
		args_analyse_tools("--help",     ST_EXTARGS_TYPE::boolean,            0, false),
		args_analyse_tools("--debug",    ST_EXTARGS_TYPE::boolean,            0, false),
		args_analyse_tools("--action",   ST_EXTARGS_TYPE::str_with_set_error, 1, -1, Action_Name),	//参数-1无意义，表示无默认，必须指定
		args_analyse_tools("--cno",      ST_EXTARGS_TYPE::str,                1, string("")),
		args_analyse_tools("--stu",      ST_EXTARGS_TYPE::str,                1, string("")),
		args_analyse_tools("--file",     ST_EXTARGS_TYPE::str,                1, string("")),
		args_analyse_tools("--chapter",  ST_EXTARGS_TYPE::int_with_error,     1, -1, -1, 99), //参数-1表示不进行章节选择
		args_analyse_tools("--week",     ST_EXTARGS_TYPE::int_with_error,     1, -1, -1, 20), //参数-1表示不进行周次选择
		args_analyse_tools("--display",  ST_EXTARGS_TYPE::str,                1, string("11111")),
		args_analyse_tools("--cfgfile",  ST_EXTARGS_TYPE::str,                1, string("hw_check.conf")),
		args_analyse_tools()  //最后一个，用于结束
	};

	int cur_argc;

	//最后一个参数1，表示除选项参数外，还有其它参数
	if ((cur_argc = args_analyse_process(argc, argv, args, 0)) < 0) {
		//错误信息在函数中已打印
		return -1;
	}

	if (argc == 1) {  //无参数，打印帮助信息
		usage(argv[0]);
	}

	//有help参数
	if (args[HW_ARGS_HELP].existed()) {
		args_analyse_print(args);
		usage(argv[0]);
		return 0;
	}

	//处理必选项
	if (!args[HW_ARGS_ACTION].existed()) {
		cout<<"参数["<<args[HW_ARGS_ACTION].get_name()<<"]必须指定."<<endl;
		return -1;
	}
	if (!args[HW_ARGS_CNO].existed()) {
		cout<<"参数["<<args[HW_ARGS_CNO].get_name()<<"]必须指定."<<endl;
		return -1;
	}
	if (!args[HW_ARGS_STU].existed()) {
		cout<<"参数["<<args[HW_ARGS_STU].get_name()<<"]必须指定."<<endl;
		return -1;
	}
	if (!args[HW_ARGS_FILE].existed()) {
		cout<<"参数["<<args[HW_ARGS_FILE].get_name()<<"]必须指定."<<endl;
		return -1;
	}

	//开始连接数据库
	string dbserver;  //数据库服务器地址
	string dbuser;  //数据库用户名
	string dbpasswd;  //数据库密码
	string dbname;   //数据库名称
	string src_rootdir;  //源文件根目录
	string cfgfile;  //配置文件名
	cfgfile = args[HW_ARGS_CFGFILE].get_string(); //读取配置文件名
	read_config_file(cfgfile, dbserver, dbuser, dbpasswd, dbname, src_rootdir);  //读取配置文件

	if(src_rootdir[src_rootdir.length()-1]=='/')  //去掉末尾的'/'
		src_rootdir = src_rootdir.substr(0,src_rootdir.length()-1);

	MYSQL* mysql;  
	MYSQL_RES* result = NULL;    
	MYSQL_ROW  row;  

	/* 初始化 mysql 变量，失败返回NULL */
	if ((mysql = mysql_init(NULL)) == NULL) {
		cout << "mysql_init failed" << endl;
		return -1;
	}

	/* 连接数据库，失败返回NULL
		1、mysqld没运行
		2、没有指定名称的数据库存在 */
	if (mysql_real_connect(mysql, dbserver.c_str(), dbuser.c_str(), dbpasswd.c_str(), dbname.c_str(), 0, NULL, 0) == NULL) {
		cout << "mysql_real_connect failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}

	/* 设置字符集，否则读出的字符乱码 */
	mysql_set_character_set(mysql, "gbk");

	//先检查参数格式是否正确(错误信息在函数中已打印)
	if(check_args(args,argv) == false) {
		return -1;  //参数格式错误，退出
	}

	string action = args[HW_ARGS_ACTION].get_string(); 
	if (action == "base") {
		hw_check_base(mysql, result, row, args, src_rootdir);
	}
	else if (action == "firstline") {
		hw_check_firstline(mysql, result, row, args, src_rootdir);
	}
	else if (action == "secondline") {
		hw_check_secondline(mysql, result, row, args, src_rootdir);
	}

	return 0;
}