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

static const char* suffix[] = { ".cpp",".c",".h",".hpp","all","" }; //源程序文件后缀名

void usage(const char* const full_procname)
{
	const char* procname = strrchr(full_procname, '\\');
	if (procname == NULL)
		procname = full_procname;

	const int wkey = 7 + strlen(procname) + 1;
	const int wopt = 7 + strlen(procname) + 4;
	cout << endl;

	cout << "Usage: " << procname << " 必选项/可选项" << endl;
	cout << endl;
	cout << setw(wkey) << ' ' << "必选项：指定操作" << endl;
	cout << setw(wopt) << ' ' << "--action opname : 支持的opname如下" << endl;
	cout << setw(wopt) << ' ' << "\t base              : 基础检查(文件是否提交、是否被改动、编码是否正确)" << endl;
	cout << setw(wopt) << ' ' << "\t firstline         : 首行检查（仅源程序文件需要）" << endl;
	cout << setw(wopt) << ' ' << "\t secondline        : 次行检查（仅部分源程序文件需要）" << endl;

	cout << setw(wkey) << ' ' << "必选项：指定课号" << endl;
	cout << setw(wopt) << ' ' << "--cno course_no     : 课号" << endl;

	cout << setw(wkey) << ' ' << "必选项：指定学生" << endl;
	cout << setw(wopt) << ' ' << "--stu no/all        : 指定单个/全部(7位数字为学号,all为全部)" << endl;

	cout << setw(wkey) << ' ' << "必选项：指定文件" << endl;
	cout << setw(wopt) << ' ' << "--file filename/all : 具体文件名/全部(all为全部,其余为具体文件名)" << endl;

	cout << setw(wkey) << ' ' << "可选项：" << endl;
	cout << setw(wopt) << ' ' << "--chapter n         : 在--file的基础上再进行章节的筛选(无/-1则全部章节,可与--week共存)" << endl;
	cout << setw(wopt) << ' ' << "--week n            : 在--file的基础上再进行周次的筛选(无/-1则全部周次,可与--chapter共存)" << endl;
	cout << setw(wopt) << ' ' << "--display xxxxx     : 每位0/1分别表示正常信息/未提交信息/错误信息/汇总信息/严重错误信息" << endl;
	cout << setw(wopt) << ' ' << "--cfgfile filename  : 指定配置文件名(缺省:hw_check.conf)" << endl;
	cout << endl;

	const char* DEMO_CNO = "10108001";
	const char* DEMO_SRC_FNAME = "12-b1.cpp";
	const char* DEMO_STUNO = "2359999";

	cout << "e.g.   " << procname << " --action base --cno " << DEMO_CNO << " --stu all --file all             : 检查" << DEMO_CNO << "所有学生的所有作业的基本信息" << endl;
	cout << "       " << procname << " --action base --cno " << DEMO_CNO << " --stu all --file all --chapter 4 : 检查" << DEMO_CNO << "所有学生的第4章作业的基本信息" << endl;
	cout << "       " << procname << " --action base --cno " << DEMO_CNO << " --stu all --file all --week 6    : 检查" << DEMO_CNO << "所有学生的第6周作业的基本信息" << endl;
	cout << "       " << procname << " --action base --cno " << DEMO_CNO << " --stu " << DEMO_STUNO << " --file all         : 检查" << DEMO_CNO << "的" << DEMO_STUNO << "学生的所有作业的基本信息" << endl;
	cout << "       " << procname << " --action base --cno " << DEMO_CNO << " --stu " << DEMO_STUNO << " --file " << DEMO_SRC_FNAME << "   : 检查" << DEMO_CNO << "的" << DEMO_STUNO << "学生的" << DEMO_SRC_FNAME << "作业的基本信息" << endl;
	cout << endl;

	cout << "       " << procname << " --action firstline --cno " << DEMO_CNO << " --stu all --file all             : 检查" << DEMO_CNO << "所有学生的所有作业的首行信息" << endl;
	cout << "       " << procname << " --action firstline --cno " << DEMO_CNO << " --stu all --file all --chapter 4 : 检查" << DEMO_CNO << "所有学生的第4章作业的首行信息" << endl;
	cout << "       " << procname << " --action firstline --cno " << DEMO_CNO << " --stu all --file all --week 6    : 检查" << DEMO_CNO << "所有学生的第6周作业的首行信息" << endl;
	cout << "       " << procname << " --action firstline --cno " << DEMO_CNO << " --stu " << DEMO_STUNO << " --file all         : 检查" << DEMO_CNO << "的" << DEMO_STUNO << "学生的所有作业的首行信息" << endl;
	cout << "       " << procname << " --action firstline --cno " << DEMO_CNO << " --stu " << DEMO_STUNO << " --file " << DEMO_SRC_FNAME << "   : 检查" << DEMO_CNO << "的" << DEMO_STUNO << "学生的" << DEMO_SRC_FNAME << "作业的首行信息" << endl;
	cout << endl;

	cout << "       " << procname << " --action secondline --cno " << DEMO_CNO << " --stu all --file " << DEMO_SRC_FNAME << " : 检查" << DEMO_CNO << "的所有学生的" << DEMO_SRC_FNAME << "作业的次行信息" << endl;
	cout << endl;

	cout << "       " << procname << " --cfgfile E:\\test\\my.conf --action base --cno " << DEMO_CNO << " --stu all --file all : 检查" << DEMO_CNO << "所有学生的所有作业的基本信息(指定配置文件)" << endl;
	cout << endl;


	cout << endl;
}

// 读取config配置文件
void read_config_file(const string& filename, string& dbserver, string& dbuser, string& dbpasswd, string& dbname, string& src_rootdir)
{
	config_file_tools cft(filename);  //默认分隔符为'='
	if (cft.is_read_succeeded() == 0) {
		cout << "配置文件[" << filename << "]读取不成功" << endl;
		return;
	}
	if (cft.item_get_string("[数据库]", "db_host", dbserver) == 0) {
		cout << "配置文件[" << filename << "]读取数据库服务器地址失败" << endl;
		return;
	}
	if (cft.item_get_string("[数据库]", "db_username", dbuser) == 0) {
		cout << "配置文件[" << filename << "]读取数据库用户名失败" << endl;
		return;
	}
	if (cft.item_get_string("[数据库]", "db_passwd", dbpasswd) == 0) {
		cout << "配置文件[" << filename << "]读取数据库密码失败" << endl;
		return;
	}
	if (cft.item_get_string("[数据库]", "db_name", dbname) == 0) {
		cout << "配置文件[" << filename << "]读取数据库名称失败" << endl;
		return;
	}
	if (cft.item_get_string("[文件目录]", "src_rootdir", src_rootdir) == 0) {
		cout << "配置文件[" << filename << "]读取源文件根目录失败" << endl;
		return;
	}
}

bool check_args(args_analyse_tools* args, char* argv[])
{
	//检查周和章节是否与单文件同时出现
	if (args[HW_ARGS_FILE].get_string() != "all" && (args[HW_ARGS_WEEK].existed() || args[HW_ARGS_CHAPTER].existed())) {
		usage(argv[0]);
		cout<<"参数[--chapter/--week]不能出现在[--file 单个文件名]时."<<endl;
		return false;
	}

	//检查display参数格式是否正确
	string display_str = args[HW_ARGS_DISPLAY].get_string();
	if (display_str.length() != 5 ||
		display_str[0] != '0' && display_str[0] != '1' ||
		display_str[1] != '0' && display_str[1] != '1' ||
		display_str[2] != '0' && display_str[2] != '1' ||
		display_str[3] != '0' && display_str[3] != '1' ||
		display_str[4] != '0' && display_str[4] != '1') {
		usage(argv[0]);
		cout<<"参数[--display]的长度不正确，只能是[5]位的0/1."<<endl;
		return false;
	}

	//检查课号是否为8/13位数字
	string action_str = args[HW_ARGS_ACTION].get_string();
	string cno_str = args[HW_ARGS_CNO].get_string();
	if (action_str == "base" || action_str == "firstline") {
		if (cno_str.length() != 8 && cno_str.length() != 13) {
			/*usage(argv[0]);*/
			cout << "课号不是8/13位" << endl;
			return false;
		}
	}

	//检查学号是否为7位数字或all
	string stu_str = args[HW_ARGS_STU].get_string();
	if (stu_str.length() != 7 && stu_str != "all") { 
		cout << "文件[" << stu_str << "]无法打开." << endl;
		cout << endl;
		if (display_str[4] == '1')
			cout << "[--严重错误--] 读取 [--stu] 指定的文件出错." << endl;
		return false;
	}

	//根据action检查
	//如果是首行检查，文件必须是源程序文件
	if (action_str == "firstline") {
		bool is_src_file = false;
		for (int i = 0; suffix[i] != ""; i++) {
			if (args[HW_ARGS_FILE].get_string().find(suffix[i])!= string::npos) { //找到后缀名(all也行）
				is_src_file = true;
				break;
			}
		}
		if (!is_src_file) {
			cout<<"首行检查的文件["<<args[HW_ARGS_FILE].get_string()<<"]必须是源程序文件."<<endl;
			return false;
		}
	}
	//如果是次行检查，文件必须是源程序文件且—file 只能是单文件，--stu 必须是 all
	string file_str = args[HW_ARGS_FILE].get_string();
	if (action_str == "secondline") {
		bool is_src_file = false;
		for (int i = 0; suffix[i] != ""; i++) {
			if (args[HW_ARGS_FILE].get_string().find(suffix[i]) != string::npos) { //找到后缀名(all也行）
				is_src_file = true;
				break;
			}
		}
		if (!is_src_file) {
			cout << "次行检查的文件[" << args[HW_ARGS_FILE].get_string() << "]必须是源程序文件." << endl;
			return false;
		}

		if (stu_str != "all") {
			cout<<"HW_Check_SecondLine 只能针对全体学生"<<endl;
			return false;
		}

		if (file_str == "all") {
			cout << "HW_Check_SecondLine 只能针对单文件" << endl;
			return false;
		}
	}

	return true;
}

int hw_check_base(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir)
{
	bool cno_match = false;
	string stu_no_name;  //学生学号/姓名
	int stu_count = 0;   //学生数量
	int file_maxlen = 0;  //文件名最大长度
	int name_maxlen = 0;  //学生姓名最大长度
	vector<MYSQL_ROW> row_list;  //学生信息列表
	vector<string> file_list;  //文件列表
	int file_count = 0;  //文件数量

	bool pdf_format_error = false;  //pdf格式错误
	bool is_src_file = false;		//是否是源程序文件
	bool is_submitted = false;		//是否提交
	bool is_utf8 = false;			//是否是utf-8编码
	bool vs_error = false;	//vs无法识别

	int unsubmitted_count = 0;  //未提交数量
	int right_count = 0;		//正确数量
	int pdf_error_count = 0;	//pdf格式错误数量
	int gb_error_count = 0;	//编码错误数量
	int vs_error_count = 0;	//vs无法识别数量

	int total_unsubmitted_count = 0;  //总未提交数量
	int total_right_count = 0;		//总正确数量
	int total_pdf_error_count = 0;	//总pdf格式错误数量
	int total_gb_error_count = 0;	//总编码错误数量
	int total_vs_error_count = 0;	//总vs无法识别数量

	/*构建sql查询指令*/
	//学生信息访问的 SQL 命令
	string search_stu = "select * from view_hwcheck_stulist where stu_cno = \""+args[HW_ARGS_CNO].get_string()+"\" ";
	string search_cno = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" ";
	//作业信息访问的 SQL 命令
	string search_hw;
	if (args[HW_ARGS_CHAPTER].get_int() != -1) {
		if (args[HW_ARGS_WEEK].get_int() != -1) { //如果指定了章节和周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_chapter = \"" + to_string(args[HW_ARGS_CHAPTER].get_int()) + "\" and hw_week = \"" + to_string(args[HW_ARGS_WEEK].get_int())+"\" ";
		}
		else { //如果只指定了章节
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_chapter = \"" + to_string(args[HW_ARGS_CHAPTER].get_int()) + "\" ";
		}
	}
	else {
		if (args[HW_ARGS_WEEK].get_int() != -1) { //如果只指定了周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_week = \"" + to_string(args[HW_ARGS_WEEK].get_int()) + "\" ";
		}
		else { //如果不指定章节和周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" ";
		}
	}

	//判断课号是否存在
	if (mysql_query(mysql, search_cno.c_str())) {  //检查连接是否正常，语法是否正确
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	while ((row = mysql_fetch_row(result)) != NULL) {
		if(row[1]==args[HW_ARGS_CNO].get_string()){
			cno_match = true;
			break;
		}
	}
	if (!cno_match) { //如果课号不存在
		cout<<"查找的课号不存在！"<<endl;
		return -1;
	}

	//查询学生信息
	if (mysql_query(mysql, search_stu.c_str())) {
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}

	stu_count = (int)mysql_num_rows(result);  //学生数量
	while ((row = mysql_fetch_row(result)) != NULL) {
		row_list.push_back(row);
		int len = (int)strlen(row[3]);
		//if (string(row[3]).find("·") != string::npos) {
		//	len = (int)strlen(row[3]) - 1;  //去掉学生姓名中的·
		//}
		if (len > name_maxlen) {
			name_maxlen = len;  //姓名最大长度, 用于输出格式化
		}
	}

	//查询作业信息
	MYSQL_RES* result_hw_list = NULL;  //作业表
	if (mysql_query(mysql, search_hw.c_str())) {
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result_hw_list = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	file_count = (int)mysql_num_rows(result_hw_list);  //文件数量
	while ((row = mysql_fetch_row(result_hw_list)) != NULL) {
		file_list.push_back((string)row[5]);
		if ((int)strlen(row[5]) > file_maxlen) {
			file_maxlen = strlen(row[5]);  //文件名最大长度, 用于输出格式化
		}
	}
	mysql_free_result(result_hw_list);

	//指定了学生和文件
	if (args[HW_ARGS_STU].get_string() != "all" && args[HW_ARGS_FILE].get_string() != "all") {
		//先检查文件是否存在
		bool is_exist = false;
		for (int i = 0; i < file_count; i++) {
			if (file_list[i] == args[HW_ARGS_FILE].get_string()) {
				is_exist = true;
				break;
			}
		}
		if (!is_exist) {
			cout << "查找的文件不存在！"<<endl;
			return -1;
		}

		stu_count = 0;
		for (int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			if (row[2] == args[HW_ARGS_STU].get_string()) { //找到学生
				string name0 = (string)row[3],name;
				if (name0.find("·") != string::npos) {
					name = name0.substr(0, name0.find("·"))+"."+name0.substr(name0.find("·")+2);  //去掉学生姓名中的·
				}
				else {
					name = name0;
				}
				stu_no_name = (string)row[2] + "/" + name;
				stu_count = 1;
				base_check_file(is_submitted, is_src_file, is_utf8, pdf_format_error,vs_error, args[HW_ARGS_CNO].get_string(), args[HW_ARGS_STU].get_string(), args[HW_ARGS_FILE].get_string(), src_rootdir);
				break;
			}
		}
		//输出结果
		cout<< "课号 : " << args[HW_ARGS_CNO].get_string() << ' ' << "学生数量 : " << stu_count << ' ' << "源文件名 : " << args[HW_ARGS_FILE].get_string() << endl;
		if (stu_count != 0) {  //学生存在
			cout << setiosflags(ios::left); //左对齐
			cout << left << setw(3)<<stu_count<<": "<< setw(name_maxlen+8) << stu_no_name << " : ";
			base_state_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count,vs_error_count, is_submitted, is_utf8, pdf_format_error,vs_error, args[HW_ARGS_DISPLAY].get_string());
			cout << endl;
			cout << endl;
		}
		base_detail_info_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count,vs_error_count, stu_count);
		cout << endl;
	}
	//指定了学生, 所有文件
	else if (args[HW_ARGS_STU].get_string() != "all" && args[HW_ARGS_FILE].get_string() == "all") { 
		//查询学生信息
		stu_count = 0;
		for(int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			if (row[2] == args[HW_ARGS_STU].get_string()) { //找到学生
				string name0 = (string)row[3];
				if (name0.find("·") != string::npos) {
					stu_no_name = name0.substr(0, name0.find("·"))+"."+name0.substr(name0.find("·")+2);  //去掉学生姓名中的·
				}
				else {
					stu_no_name = name0;
				}
				stu_count = 1;
				break;
			}
		}
        //输出结果
		if (stu_count != 0) {
			cout << "1  : 学号-" << args[HW_ARGS_STU].get_string() << ' ' << "姓名-" << stu_no_name << ' ' << "课号-" << args[HW_ARGS_CNO].get_string() << ' ' << "文件数量-" << file_count << endl;
			for (int i = 0; i < file_count; i++) {
				base_check_file(is_submitted, is_src_file, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_CNO].get_string(), args[HW_ARGS_STU].get_string(), file_list[i], src_rootdir);				
				cout << setiosflags(ios::left); //左对齐
				cout << "  " << setw(file_maxlen) << file_list[i] << " : ";
				base_state_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count, vs_error_count, is_submitted, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_DISPLAY].get_string());
			}
			base_stu_detail_info_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count,vs_error_count, file_count);
			cout << endl;
			cout << endl;
		}
		base_total_detail_info_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count,vs_error_count, stu_count, file_count);
		cout << endl;
	}
	//指定了文件，所有学生
	else if (args[HW_ARGS_STU].get_string() == "all" && args[HW_ARGS_FILE].get_string() != "all") { 
		//先检查文件是否存在
		bool is_exist = false;
		for (int i = 0; i < file_count; i++) {
			if (file_list[i] == args[HW_ARGS_FILE].get_string()) {
				is_exist = true;
				break;
			}
		}
		if (!is_exist) {
			cout << "查找的文件不存在！" << endl;
			return -1;
		}

		stu_count = (int)mysql_num_rows(result);  //学生数量
		cout<<"课号 : "<<args[HW_ARGS_CNO].get_string()<<" 学生数量 : "<<stu_count<<" 源文件名 : "<<args[HW_ARGS_FILE].get_string()<<endl;
		for (int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			string name0 = (string)row[3],name;
			if (name0.find("·") != string::npos) {
				name = name0.substr(0, name0.find("·"))+"."+name0.substr(name0.find("·")+2);  //去掉学生姓名中的·
			}
			else {
				name = name0;
			}
			stu_no_name = (string)row[2] + "/" + name;
			base_check_file(is_submitted, is_src_file, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_CNO].get_string(), row[2], args[HW_ARGS_FILE].get_string(), src_rootdir);
			cout << setiosflags(ios::left); //左对齐
			cout << left << setw(3) << i + 1<< ": " << setw(name_maxlen+8) << stu_no_name << " : ";
			base_state_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count, vs_error_count, is_submitted, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_DISPLAY].get_string());
		}
		cout << endl;
		base_detail_info_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count, vs_error_count, stu_count);
		cout << endl;
	}
	//所有学生，所有文件
	else { 
		stu_count = (int)mysql_num_rows(result);  //学生数量
		for (int j = 0; j < (int)row_list.size(); j++) {
			row = row_list[j];
			string name0 = (string)row[3];
			if (name0.find("·") != string::npos) {
				stu_no_name = name0.substr(0, name0.find("·"))+"."+name0.substr(name0.find("·")+2);  //去掉学生姓名中的·
			}
			else {
				stu_no_name = name0;
			}
			cout << setiosflags(ios::left); //左对齐
			cout << left << setw(3)<<j+1<<": 学号-"<<row[2]<<" 姓名-"<<stu_no_name<<" 课号-"<<args[HW_ARGS_CNO].get_string()<<" 文件数量-"<<file_count<<endl;
			//初始化计数器
			unsubmitted_count = 0;
			right_count = 0;
			pdf_error_count = 0;
			gb_error_count = 0;
			vs_error_count = 0;

			for (int i = 0; i < file_count; i++) {
				base_check_file(is_submitted, is_src_file, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_CNO].get_string(), row[2], file_list[i], src_rootdir);
				cout << "  " << setw(file_maxlen) << left << file_list[i] << " : ";
				base_state_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count, vs_error_count, is_submitted, is_utf8, pdf_format_error, vs_error, args[HW_ARGS_DISPLAY].get_string());
			}
			total_unsubmitted_count += unsubmitted_count;
			total_right_count += right_count;
			total_pdf_error_count += pdf_error_count;
			total_gb_error_count += gb_error_count;
			total_vs_error_count += vs_error_count;
			base_stu_detail_info_display(unsubmitted_count, right_count, pdf_error_count, gb_error_count, vs_error_count, file_count);
			cout << endl;
		}
		cout << endl;
		base_total_detail_info_display(total_unsubmitted_count, total_right_count, total_pdf_error_count, total_gb_error_count, total_vs_error_count, stu_count, file_count);
		cout << endl;
	}

	/* 释放result，否则会丢失内存 */
	mysql_free_result(result);
	return 0;
}

int hw_check_firstline(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir)
{
	bool cno_match = false;  //课号是否存在
	string stu_name;  //学生姓名
	string stu_no;  //学生学号
	string stu_fmajor;  //学生专业
	string stu_smajor;  //学生专业简称
	int stu_count = 0;  //学生数量
	int file_maxlen = 0;  //文件名最大长度
	int name_maxlen = 0;  //姓名最大长度
	vector <MYSQL_ROW> row_list;  //每行学生信息列表
	vector<string> file_list;  //文件列表
	int file_count = 0;  //文件数量

	bool is_submitted = false;  //是否提交
	bool is_utf8 = false;			//是否是utf-8编码
	bool is_anno;  //是否是注释
	bool anno_format;  //注释格式是否正确
	bool is_three;  //是否是三项
	bool error;  //首行信息不匹配（检查出错）
	bool name_error;  //姓名不匹配
	bool no_error;  //学号不匹配
	bool major_error;  //班级不匹配
	bool vs_error;  //vs无法识别

	int unsubmitted_count = 0;  //未提交数量
	int right_count = 0;		//正确数量
	int gb_error_count = 0;  //编码错误数量
	int isnt_anno_count = 0;  //非注释数量
	int isnt_three_count = 0;  //非三项数量
	int anno_format_error_count = 0;  //注释格式错误数量
	int anno_error_count = 0;  //注释错误数量(不匹配）
	int vs_error_count = 0;  //vs无法识别数量

	int total_unsubmitted_count = 0;  //总未提交数量
	int total_right_count = 0;		//总正确数量
	int total_gb_error_count = 0;  //总编码错误数量
	int total_isnt_anno_count = 0;  //总非注释数量
	int total_isnt_three_count = 0;  //总非三项数量
	int total_anno_format_error_count = 0;  //总注释格式错误数量
	int total_anno_error_count = 0;  //总注释错误数量(不匹配）
	int total_vs_error_count = 0;  //总vs无法识别数量
	
	/*构建sql查询指令*/
	//学生信息访问的 SQL 命令
	string search_stu = "select * from view_hwcheck_stulist where stu_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" ";
	string search_cno = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" ";
	//作业信息访问的 SQL 命令
	string search_hw;
	if (args[HW_ARGS_CHAPTER].get_int() != -1) {
		if (args[HW_ARGS_WEEK].get_int() != -1) { //如果指定了章节和周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_chapter = \"" + to_string(args[HW_ARGS_CHAPTER].get_int()) + "\" and hw_week = \"" + to_string(args[HW_ARGS_WEEK].get_int()) + "\" ";
		}
		else { //如果只指定了章节
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_chapter = \"" + to_string(args[HW_ARGS_CHAPTER].get_int()) + "\" ";
		}
	}
	else {
		if (args[HW_ARGS_WEEK].get_int() != -1) { //如果只指定了周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" and hw_week = \"" + to_string(args[HW_ARGS_WEEK].get_int()) + "\" ";
		}
		else { //如果不指定章节和周次
			search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + args[HW_ARGS_CNO].get_string() + "\" ";
		}
	}

	//判断课号是否存在
	if (mysql_query(mysql, search_cno.c_str())) {  //检查连接是否正常，语法是否正确
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	while ((row = mysql_fetch_row(result)) != NULL) {
		if (row[1] == args[HW_ARGS_CNO].get_string()) {
			cno_match = true;
			break;
		}
	}
	if (!cno_match) { //如果课号不存在
		cout << "查找的课号不存在！" << endl;
		return -1;
	}

	//查询学生信息
	if (mysql_query(mysql, search_stu.c_str())) {
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	stu_count = (int)mysql_num_rows(result);  //学生数量
	while ((row = mysql_fetch_row(result)) != NULL) {
		row_list.push_back(row);
		int len = (int)strlen(row[3]);
		//if (string(row[3]).find("·") != string::npos) {
		//	len = (int)strlen(row[3]) - 1;  //去掉学生姓名中的·
		//}
		if (len > name_maxlen) {
			name_maxlen = len;  //姓名最大长度, 用于输出格式化
		}
	}

	//查询作业信息
	MYSQL_RES* result_hw_list = NULL;  //作业表
	if (mysql_query(mysql, search_hw.c_str())) {
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result_hw_list = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	
	while ((row = mysql_fetch_row(result_hw_list)) != NULL) {
		//只有源文件才需要检查
		bool is_src_file = false;
		for (int i = 0; suffix[i] != ""; i++) {
			if (string(row[5]).find(suffix[i]) != string::npos) { //找到后缀名(all也行）
				is_src_file = true;
				break;
			}
		}
		if (!is_src_file) {
			continue;
		}
		file_list.push_back((string)row[5]);
		if ((int)strlen(row[5]) > file_maxlen) {
			file_maxlen = strlen(row[5]);  //文件名最大长度, 用于输出格式化
		}
	}
	mysql_free_result(result_hw_list);
	file_count = (int)file_list.size();  //文件数量

	//指定了学生和文件
	if (args[HW_ARGS_STU].get_string() != "all" && args[HW_ARGS_FILE].get_string() != "all") {
		//先检查文件是否存在
		bool is_exist = false;
		for (int i = 0; i < file_count; i++) {
			if (file_list[i] == args[HW_ARGS_FILE].get_string()) {
				is_exist = true;
				break;
			}
		}
		if (!is_exist) {
			cout << "查找的文件不存在！" << endl;
			return -1;
		}

		stu_count = 0;
		for (int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			if (row[2] == args[HW_ARGS_STU].get_string()) { //找到学生
				string stu_name0 = (string)row[3]; //学生姓名
				if (stu_name0.find("·") != string::npos) { //如果姓名中有·，则将·换成.
					stu_name = stu_name0.substr(0, stu_name0.find("·")) + "." + stu_name0.substr(stu_name0.find("·") + 2);
				}
				else {
					stu_name = stu_name0;
				}
				stu_no = (string)row[2]; //学生学号
				stu_fmajor = (string)row[5]; //学生专业
				stu_smajor = (string)row[6]; //学生专业简称
				stu_count = 1;
				firstline_check_file(is_submitted, is_utf8, is_anno, anno_format, is_three, error, vs_error, no_error,name_error, major_error, stu_no,stu_name0,stu_fmajor,stu_smajor, args[HW_ARGS_CNO].get_string(), args[HW_ARGS_FILE].get_string(), src_rootdir);
				break;
			}
		}

		//输出结果
		cout << "课号 : " << args[HW_ARGS_CNO].get_string() << ' ' << "学生数量 : " << stu_count << ' ' << "源文件名 : " << args[HW_ARGS_FILE].get_string() << endl;
		if (stu_count != 0) {
			cout << setiosflags(ios::left);
			cout<<setw(3)<<stu_count<<": "<<setw(8+name_maxlen)<<stu_no+"/"+stu_name<<" : ";
			first_state_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, src_rootdir, args[HW_ARGS_CNO].get_string(),stu_no, args[HW_ARGS_FILE].get_string());
			cout << endl;
		}
		cout << endl;
		firstline_detail_info_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, stu_count);
		cout << endl;
	}
	//指定了学生，所有文件
	else if (args[HW_ARGS_STU].get_string() != "all" && args[HW_ARGS_FILE].get_string() == "all") {
		//查询学生信息
		stu_count = 0;
		string stu_name0;  //学生原始姓名
		for (int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			if (row[2] == args[HW_ARGS_STU].get_string()) { //找到学生
				stu_name0 = (string)row[3]; //学生姓名
				if (stu_name0.find("·") != string::npos) { //如果姓名中有·，则将·换成.
					stu_name = stu_name0.substr(0, stu_name0.find("·")) + "." + stu_name0.substr(stu_name0.find("·") + 2);
				}
				else {
					stu_name = stu_name0;
				}
				stu_no = (string)row[2]; //学生学号
				stu_fmajor = (string)row[5]; //学生专业
				stu_smajor = (string)row[6]; //学生专业简称
				stu_count = 1;
				break;
			}
		}

		//输出结果
		if (stu_count != 0) {
			cout << setiosflags(ios::left);  //左对齐
			cout<<setw(3)<<stu_count<<": "<<"学号-"<<stu_no<<" 姓名-"<<stu_name<<" 课号-"<<args[HW_ARGS_CNO].get_string()<<" 文件数量-"<<file_count << endl;
			for (int i = 0; i < file_count; i++) {
				firstline_check_file(is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, stu_no, stu_name0, stu_fmajor, stu_smajor, args[HW_ARGS_CNO].get_string(), file_list[i], src_rootdir);
				cout << setiosflags(ios::left);
				cout << "  " << setw(file_maxlen) << left << file_list[i] << " : ";
				first_state_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, src_rootdir, args[HW_ARGS_CNO].get_string(), stu_no, file_list[i]);
			}
			firstline_stu_detail_info_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, file_count);
			cout << endl;
			cout << endl;
		}
		firstline_total_detail_info_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, stu_count, file_count);
		cout << endl;
	}
	//指定了文件，所有学生
	else if (args[HW_ARGS_STU].get_string() == "all" && args[HW_ARGS_FILE].get_string() != "all") {
		//先检查文件是否存在
		bool is_exist = false;
		for (int i = 0; i < file_count; i++) {
			if (file_list[i] == args[HW_ARGS_FILE].get_string()) {
				is_exist = true;
				break;
			}
		}
		if (!is_exist) {
			cout << "查找的文件不存在！" << endl;
			return -1;
		}

		cout << "课号 : " << args[HW_ARGS_CNO].get_string() << ' ' << "学生数量 : " << stu_count << ' ' << "源文件名 : " << args[HW_ARGS_FILE].get_string() << endl;
		for (int i = 0; i < (int)row_list.size(); i++) {
			row = row_list[i];
			string stu_name0 = (string)row[3]; //学生姓名
			if (stu_name0.find("·") != string::npos) { //如果姓名中有·，则将·换成.
				stu_name = stu_name0.substr(0, stu_name0.find("·")) + "." + stu_name0.substr(stu_name0.find("·") + 2);
			}
			else {
				stu_name = stu_name0;
			}
			if ((int)stu_name.length() > name_maxlen)
				name_maxlen = stu_name.length(); //姓名最大长度, 用于输出格式化

			stu_no = (string)row[2]; //学生学号
			stu_fmajor = (string)row[5]; //学生专业
			stu_smajor = (string)row[6]; //学生专业简称
			firstline_check_file(is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, stu_no, stu_name0, stu_fmajor, stu_smajor, args[HW_ARGS_CNO].get_string(), args[HW_ARGS_FILE].get_string(), src_rootdir);
			cout << setiosflags(ios::left);
			cout << setw(3) << i+1 << ": " << setw(8 + name_maxlen) << stu_no + "/" + stu_name << " : ";
			first_state_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, src_rootdir, args[HW_ARGS_CNO].get_string(), stu_no, args[HW_ARGS_FILE].get_string());
		}
		cout << endl;
		firstline_detail_info_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, stu_count);
		cout << endl;
	}
	//所有学生，所有文件
	else {
		stu_count = (int)mysql_num_rows(result);  //学生数量
		for (int j = 0; j < (int)row_list.size(); j++) {
			row = row_list[j];
			string name0 = (string)row[3];
			if (name0.find("·") != string::npos) {
				stu_name = name0.substr(0, name0.find("·")) + "." + name0.substr(name0.find("·") + 2);  //去掉学生姓名中的·
			}
			else {
				stu_name = name0;
			}
			stu_no = (string)row[2]; //学生学号
			stu_fmajor = (string)row[5]; //学生专业
			stu_smajor = (string)row[6]; //学生专业简称
			cout << setiosflags(ios::left); //左对齐
			cout << left << setw(3) << j + 1 << ": 学号-" << stu_no << " 姓名-" << stu_name << " 课号-" << args[HW_ARGS_CNO].get_string() << " 文件数量-" << file_count << endl;
			//初始化计数器
			unsubmitted_count = 0;
			right_count = 0;
			gb_error_count = 0;
			isnt_anno_count = 0;
			isnt_three_count = 0;
			anno_format_error_count = 0;
			anno_error_count = 0;
			vs_error_count = 0;

			for (int i = 0; i < file_count; i++) {
				firstline_check_file(is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, stu_no, name0, stu_fmajor, stu_smajor, args[HW_ARGS_CNO].get_string(), file_list[i], src_rootdir);
				cout << "  " << setw(file_maxlen) << left << file_list[i] << " : ";
				first_state_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, is_submitted, is_utf8, is_anno, anno_format, is_three, error,vs_error, no_error, name_error, major_error, src_rootdir, args[HW_ARGS_CNO].get_string(), stu_no, file_list[i]);
			}
			
			total_unsubmitted_count += unsubmitted_count;
			total_right_count += right_count;
			total_gb_error_count += gb_error_count;
			total_isnt_anno_count += isnt_anno_count;
			total_isnt_three_count += isnt_three_count;
			total_anno_format_error_count += anno_format_error_count;
			total_anno_error_count += anno_error_count;
			total_vs_error_count += vs_error_count;
			
			firstline_stu_detail_info_display(unsubmitted_count, right_count, gb_error_count, isnt_anno_count, isnt_three_count, anno_format_error_count, anno_error_count,vs_error_count, file_count);
			cout << endl;
		}
		cout << endl;
		firstline_total_detail_info_display(total_unsubmitted_count, total_right_count, total_gb_error_count, total_isnt_anno_count, total_isnt_three_count, total_anno_format_error_count, total_anno_error_count,total_vs_error_count, stu_count, file_count);
		cout << endl;
	}

	/*释放result，否则会丢失内存*/
	mysql_free_result(result);
	return 0;
}

//secondline只针对全体学生和指定文件
int hw_check_secondline(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir)
{
	int stu_count = 0;  //学生数量
	string stu_no, stu_name, stu_name0;
	vector<MYSQL_ROW> row_list;
	vector<string> name0_list;  //学生原始姓名列表
	int name_maxlen = 0;  //姓名最大长度
	vector<vector<string>> other_name,other_no; //学生次行写的互验学号和姓名

	bool is_submitted = false;  //是否提交
	bool is_utf8 = false;  //是否UTF-8
	bool is_anno = false;  //是否有注释

	int right_count = 0;  //正确数量
	int unsubmitted_count = 0;  //未提交数量
	int gb_error_count = 0;  //gb编码错误数量
	int isnt_anno_count = 0;  //没有注释数量

	//处理课号
	string cno1, cno2;
	string cno = args[HW_ARGS_CNO].get_string();
	if (cno.find(",") != string::npos) {
		cno1 = cno.substr(0, cno.find(","));
		cno2 = cno.substr(cno.find(",") + 1);
		//去掉左右空格
		cno2.erase(0, cno2.find_first_not_of(" "));
		cno2.erase(cno2.find_last_not_of(" ") + 1);
	}
	else {
		cno2 = "";
		cno1 = cno;
	}
	cno1.erase(0, cno1.find_first_not_of(" "));
	cno1.erase(cno1.find_last_not_of(" ") + 1);

	//查询作业列表
	string search_hw = "select * from view_hwcheck_hwlist where hw_cno = \"" + cno1 + "\"";
	if (cno2 != "")
		search_hw += " or hw_cno = \"" + cno2 + "\"";

	MYSQL_RES* result_hw_list = NULL;  //作业表
	if (mysql_query(mysql, search_hw.c_str())) {
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result_hw_list = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	bool is_exist = false;
	while ((row = mysql_fetch_row(result_hw_list)) != NULL){
		if (row[5] == args[HW_ARGS_FILE].get_string()) {
			is_exist = true;
			break;
		}
	}
	if (!is_exist) {
		cout << "查找的文件不存在！" << endl;
		mysql_free_result(result_hw_list);
		return -1;
	}

	//查询学生列表
	string search_stu = "select * from view_hwcheck_stulist where stu_cno = \"" + cno1 + "\"";
	if (cno2 != "")
		search_stu += " or stu_cno = \"" + cno2 + "\"";
	
	if(mysql_query(mysql, search_stu.c_str())){
		cout << "mysql_query failed(" << mysql_error(mysql) << ")" << endl;
		return -1;
	}
	/* 将查询结果存储起来，出现错误则返回NULL
		注意：查询结果为NULL，不会返回NULL */
	if ((result = mysql_store_result(mysql)) == NULL) {
		cout << "mysql_store_result failed" << endl;
		return -1;
	}
	while ((row = mysql_fetch_row(result)) != NULL) {
		row_list.push_back(row);
		name0_list.push_back((string)row[3]); //存的原始姓名
		int len = string(row[3]).length();
		/*if(string(row[3]).find("·") != string::npos)
			len -= 1;*/
		if(len > name_maxlen)
			name_maxlen = len;  //姓名最大长度, 用于输出格式化
	}
	stu_count = (int)row_list.size();  //学生数量

	cout<<"课号 : "<<args[HW_ARGS_CNO].get_string() << " 学生数量 : " <<stu_count <<" 源文件名 : "<< args[HW_ARGS_FILE].get_string()<<endl;
	for (int i = 0; i < stu_count; i++) {
		row = row_list[i];
		stu_no = (string)row[2]; //学生学号
		stu_name0 = (string)row[3]; //学生姓名
		if (stu_name0.find("·") != string::npos) { //如果姓名中有·，则将·换成.
			stu_name = stu_name0.substr(0, stu_name0.find("·")) + "." + stu_name0.substr(stu_name0.find("·") + 2);
		}
		else {
			stu_name = stu_name0;
		}
		cout << setiosflags(ios::left);
		cout << setw(3) << i + 1 << ": " << setw(8 + name_maxlen) << stu_no + "/" + stu_name << " : ";
		secondline_check_and_state_file (is_submitted, is_utf8, is_anno, row,args[HW_ARGS_FILE].get_string(), src_rootdir,other_no,other_name,right_count,unsubmitted_count,gb_error_count,isnt_anno_count);
	}
	cout << endl;
	secondline_detail_info_display (right_count, unsubmitted_count, gb_error_count, isnt_anno_count, stu_count);
	cout << endl;
	//交叉检查
	cout << "交叉检查结果："<<endl;
	for (int i = 0; i < stu_count; i++) {
		row = row_list[i];
		cout << left << setw(3) << i + 1 << ": " << (string)row[7] << "-" << (string)row[2] + "-" + (string)row[3] << endl;
		for (int j = 0; j < (int)other_no[i].size(); j++) {
			cout << "	" << other_no[i][j] << " " <<  other_name[i][j] << "	";
			//对方姓名不正确
			bool f1 = false;
			for (int k = 0; k < stu_count; k++) {
				if (other_no[i][j] == (string)row_list[k][2] && other_name[i][j] != (string)row_list[k][3]) {
					cout<<"对方姓名不正确"<<endl;
					f1 = true;
					break;
				}
			}
			if (f1)
				continue;
			
			int other_index = -1;
			for (int k = 0; k < stu_count; k++) {
				if(other_no[i][j] == (string)row_list[k][2]){
					other_index = k;
					break;
				}
			}
			//对方学号找不到
			if (other_index == -1) {
				cout<<"对方学号不存在"<<endl;
				continue;
			}
			//对方抛弃了你
			int my_index = -1;
			for (int k = 0; k < (int)other_no[other_index].size(); k++) {
				if (other_no[other_index][k] == (string)row[2]) {
					my_index = k;
					break;
				}
			}
			if (my_index == -1) {
				cout<<"抛弃了你"<<endl;
				continue;
			}
			else {
				if (other_name[other_index][my_index] != (string)row[3]) {
					cout<<"没写对你名字"<<endl;
					continue;
				}
				cout << endl;
			}
		}
	}
	cout << endl;

	mysql_free_result(result_hw_list);
	mysql_free_result(result);
	return 0;
}

