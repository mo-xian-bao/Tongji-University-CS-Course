/* 2351520 计拔 毛星博 */
#pragma once

#include <string>
#include "../include/class_aat.h"
#include "../include_mariadb_x86/mysql/mysql.h"      // mysql特有
using namespace std;

enum HW_ARGS_TYPE {  //命令行参数类型
	HW_ARGS_HELP,
	HW_ARGS_DEBUG,
	HW_ARGS_ACTION,
	HW_ARGS_CNO,
	HW_ARGS_STU,
	HW_ARGS_FILE,
	HW_ARGS_CHAPTER,
	HW_ARGS_WEEK,
	HW_ARGS_DISPLAY,
	HW_ARGS_CFGFILE
};



void usage(const char* const full_procname);
void read_config_file(const string& filename, string& dbserver, string& dbuser, string& dbpasswd, string& dbname, string& src_rootdir);
int hw_check_base(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir);
int hw_check_firstline(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir);
int hw_check_secondline(MYSQL* mysql, MYSQL_RES* result, MYSQL_ROW& row, args_analyse_tools* args, string& src_rootdir);
bool check_args(args_analyse_tools* args, char* argv[]);
void base_check_file(bool& is_submitted, bool& is_src_file, bool& is_utf8, bool& pdf_format_error, bool& vs_error, const string& cno, const string& stu, const string& file, const string& src_rootdir);
void base_state_display(int& unsubmitted_count, int& right_count, int& pdf_error_count, int& gb_error_count, int& vs_error_count, bool is_submitted, bool is_utf8, bool pdf_format_error, bool vs_error, const string& display);
void base_detail_info_display(int unsubmitted_count, int right_count, int pdf_error_count, int gb_error_count, int vs_error_count, int stu_count);
void base_stu_detail_info_display(int& unsubmitted_count, int& right_count, int& pdf_error_count, int& gb_error_count, int& vs_error_count, int file_count);
void base_total_detail_info_display(int& unsubmitted_count, int& right_count, int& pdf_error_count, int& gb_error_count, int vs_error_count, int stu_count, int file_count);
void firstline_check_file(bool& is_submitted, bool& is_utf8, bool& is_anno, bool& anno_format, bool& is_three, bool& error, bool& vs_error, bool& no_error, bool& name_error, bool& major_error, string& stu_no, string& stu_name, string& stu_fmajor, string& stu_smajor, const string& cno, const string& file_name, string& src_rootdir);
void first_state_display(int& unsubmitted_count, int& right_count, int& gb_error_count, int& isnt_anno_count, int& isnt_three_count, int& anno_format_error_count, int& anno_error_count, int& vs_error_count, bool is_submitted, bool is_utf8, bool is_anno, bool anno_format, bool is_three, bool error, bool vs_error, bool no_error, bool name_error, bool major_error, string& src_rootdir, const string& cno, string& stu_no, const string& file_name);
void firstline_detail_info_display(int unsubmitted_count, int right_count, int gb_error_count, int isnt_anno_count, int isnt_three_count, int anno_format_error_count, int anno_error_count, int vs_error_count, int stu_count);
void firstline_total_detail_info_display(int& unsubmitted_count, int& right_count, int& gb_error_count, int& isnt_anno_count, int& isnt_three_count, int& anno_format_error_count, int& anno_error_count, int& vs_error_count, int& stu_count, int& file_count);
void firstline_stu_detail_info_display(int& unsubmitted_count, int& right_count, int& gb_error_count, int& isnt_anno_count, int& isnt_three_count, int& anno_format_error_count, int& anno_error_count, int& vs_error_count, int& file_count);
void secondline_detail_info_display(int right_count, int unsubmitted_count, int gb_error_count, int isnt_anno_count, int stu_count);
void secondline_check_and_state_file(bool& is_submitted, bool& is_utf8, bool& is_anno, MYSQL_ROW& row, const string& file_name, string& src_rootdir, vector<vector<string>>& other_no, vector<vector<string>>& other_name, int& right_count, int& unsubmitted_count, int& gb_error_count, int& isnt_anno_count);






