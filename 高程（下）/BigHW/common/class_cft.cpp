/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
/* 添加自己需要的头文件，注意限制 */
#include <string>
#include <sstream>
#include "../include/class_cft.h"
using namespace std;

/* 给出各种自定义函数的实现（已给出的内容不全） */
void get_valid_line(string& line) //取出一行后，先截断;或#或//开始的注释，再去除前后空格/tab，剩下为有效内容
{
	int index1 = line.find_first_of(";"); 
	int index2 = line.find_first_of("#");
	int index3 = string::npos;
	if (line.length() >= 2) {
		for (unsigned int i = 0; i < line.length() - 1; i++) {
			if (line[i] == '/' && line[i + 1] == '/') {
				index3 = i;
				break;
			}
		}
	}
	if (index1 == string::npos) 
		index1 = line.length();
	if (index2 == string::npos) 
		index2 = line.length();
	if (index3 == string::npos)
		index3 = line.length();
	int index = min(min(index1, index2), index3);
	line = line.substr(0, index);  //去除注释

	line.erase(0, line.find_first_not_of(" \t")); //去除前空格/tab
	line.erase(line.find_last_not_of(" \t") + 1,line.length()); //去除后空格/tab
}

bool is_group_name(const string& line)
{
	if (line[0] == '[' && line[line.length() - 1] == ']') {
		return true;
	}
	else {
		return false;
	}
}

bool config_file_tools::get_item_name(const string& item_line, string& item_name)
{
	if (item_separate_character_type == BREAK_CTYPE::Equal) {
		int index = item_line.find_first_of("=");
		if (index == string::npos) {  //没有分隔符，则认为是无效行
			return false;
		}
		item_name = item_line.substr(0, index);\
		get_valid_line(item_name);
	}
	else if (item_separate_character_type == BREAK_CTYPE::Space) {
		int index = item_line.find_first_of(" ");
		if (index == string::npos) {  //没有分隔符，则认为是无效行
			return false;
		}
		item_name = item_line.substr(0, index);
		get_valid_line(item_name);
	}
	return true;
}

void config_file_tools::get_item_value(const string& item_line, string& item_value)
{
	if (item_separate_character_type == BREAK_CTYPE::Equal) {
		item_value = item_line.substr(item_line.find_first_of("=") + 1);
		get_valid_line(item_value);
	}
	else if (item_separate_character_type == BREAK_CTYPE::Space) {
		item_value = item_line.substr(item_line.find_first_of(" ") + 1);
		get_valid_line(item_value);
	}
}

bool config_file_tools::get_group_range(const string& group_name, int& start_index, int& end_index,bool is_case_sensitive)
{
	start_index = -1;
	end_index = -1;

	if (group_name.empty()) {
		start_index = 0;
	}
	else {
		for (unsigned int i = 0; i < cfg_list.size(); i++) {
			if (is_group_name(cfg_list[i])) {
				if (is_case_sensitive) {
					if (cfg_list[i] == group_name) {
						start_index = i + 1;
						break;
					}
				}
				else {
					if (_stricmp(cfg_list[i].c_str(), group_name.c_str())==0) {
						start_index = i + 1;
						break;
					}
				}
			}
		}
		if (start_index == -1) {
			return false;
		}
	}

	for (unsigned int i = start_index; i < cfg_list.size(); i++) {
		if (is_group_name(cfg_list[i])) {
			end_index = i - 1;
			break;
		}
	}
	if (end_index == -1) {
		end_index = cfg_list.size() - 1;
	}
	return true;
}

// 判断字符串是否为int类型
bool Is_Int(const string str0)
{
	string str = str0;
	if (str[0] == '-') {
		str = str.substr(1);
	}
	if (str.empty()) {
		return false;
	}
	for (unsigned int i = 0; i < str.size(); i++) {
		if (str[i] < '0' || str[i] > '9') {
			return false;
		}
	}
	return true;
}

// 判断字符串是否为合法的IP地址
bool Is_Valid_IPAddr(const string str)
{
	if (str.empty()) {
		return false;
	}
	int dot_count = 0;  // 记录"."的个数
	string num_str;     // 记录数字串
	for (unsigned int i = 0; i < str.size(); i++) {
		if (str[i] == '.') {
			if (i == 0 || i == str.size() - 1) {
				return false;  //"."不能是开头或结尾
			}
			if (!Is_Int(num_str) || stoi(num_str) > 255 || stoi(num_str) < 0 ||num_str.length() > 3) {
				return false;  
			}
			num_str.clear();
			dot_count++;
		}
		else {
			num_str += str[i];
		}
	}
	// 最后一个数字串
	if (num_str.empty()) {
		return false;  // 数字串为空
	}
	else {
		if (!Is_Int(num_str) || stoi(num_str) > 255 || stoi(num_str) < 0 || num_str.length() > 3) {
			return false;  
		}
	}
	if (dot_count != 3) {
		return false;  //"."的个数不等于3
	}
	return true;
}

// 将IP地址转换为整数
unsigned int IPAddr_To_Int(const string str)
{
	if (str.empty())
		return 0;

	unsigned int ip_int = 0;
	string num_str;
	for (unsigned int i = 0; i < str.size(); i++) {
		if (str[i] == '.') {
			ip_int = (ip_int << 8) + stoi(num_str);
			num_str.clear();
		}
		else if (i == str.size() - 1) {
			num_str += str[i];
			ip_int = (ip_int << 8) + stoi(num_str);
		}
		else {
			num_str += str[i];
		}
	}
	return ip_int;
}

/***************************************************************************
  函数名称：
  功    能：构造函数，指定要读取的配置文件名及分隔符的形式,将指定配置文件中的所有组/项均读入并存储到自定义结构中，方便后续各种get函数的调用
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
config_file_tools::config_file_tools(const char* const _cfgname, const enum BREAK_CTYPE _ctype)
{
	cfgname = _cfgname;   // 保存配置文件名
	item_separate_character_type = _ctype;  // 用于配置项名字和值的分隔符

	int line_index = 0;
	ifstream fin(cfgname);
	if (fin.is_open()) {
		string line;
		while (getline(fin, line)) {
			if(line.length() > MAX_LINE){
				cout<<"非法格式的配置文件，第"<<line_index+1<<"行超过最大长度 1024."<<endl;
				is_read_success = false;
				break;
			}
			get_valid_line(line);
			if (!line.empty()) {
				cfg_list.push_back(line); //将有效行加入列表中
			}
		}
	}
	else {
		is_read_success = false;
	}
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
config_file_tools::config_file_tools(const string& _cfgname, const enum BREAK_CTYPE _ctype)
{
	cfgname = _cfgname;   // 保存配置文件名
	item_separate_character_type = _ctype;  // 用于配置项名字和值的分隔符

	int line_index = 0;
	ifstream fin(cfgname);
	if (fin.is_open()) {
		string line;
		while (getline(fin, line)) {
			if (line.length() > MAX_LINE) {
				cout << "非法格式的配置文件，第[" << line_index + 1 << "]行超过最大长度1024." << endl;
				is_read_success = false;
				break;
			}
			get_valid_line(line);
			if (!line.empty()) {
				cfg_list.push_back(line); //将有效行加入列表中
			}
			line_index++;
		}
	}
	else {
		is_read_success = false;
	}
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
config_file_tools::~config_file_tools()
{
	/* 按需完成 */
}


/***************************************************************************
  函数名称：
  功    能：判断读配置文件是否成功
  输入参数：
  返 回 值：true - 成功，已读入所有的组/项
		    false - 失败，文件某行超长/文件全部是注释语句
  说    明：
***************************************************************************/
bool config_file_tools::is_read_succeeded() const
{
	return is_read_success;
}

/***************************************************************************
  函数名称：
  功    能：返回配置文件中的所有组
  输入参数：vector <string>& ret : vector 中每项为一个组名
  返 回 值：读到的组的数量（简单配置文件的组数量为1，组名为"）
  说    明：
***************************************************************************/
int config_file_tools::get_all_group(vector <string>& ret)
{
	int group_count = 0;
	for (unsigned int i = 0; i < cfg_list.size(); i++) {
		if (i == 0 && !is_group_name(cfg_list[i])) {
			ret.push_back("");
			group_count++;
			continue;
		}
		if (is_group_name(cfg_list[i])) {
			ret.push_back(cfg_list[i]);
		}
	}
	group_count = ret.size();
	return group_count;
}

/***************************************************************************
  函数名称：
  功    能：查找指定组的所有项并返回项的原始内容
  输入参数：const char* const group_name：组名
		   vector <string>& ret：vector 中每项为一个项的原始内容
		   const bool is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：项的数量，0表示空
  说    明：
***************************************************************************/
int config_file_tools::get_all_item(const char* const group_name, vector <string>& ret, const bool is_case_sensitive)
{
	if (group_name == nullptr) {
		return 0;
	}
	else {
		return get_all_item(string(group_name), ret, is_case_sensitive);
	}
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::get_all_item(const string& group_name, vector <string>& ret, const bool is_case_sensitive)
{
	int item_count = 0;   // 项的数量
	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置
	
	if (!get_group_range(group_name, start_index, last_index, is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		ret.push_back(cfg_list[i]);
		item_count++;
	}
	return item_count;
}

/***************************************************************************
  函数名称：
  功    能：取某项的原始内容（=后的所有字符，string方式）
  输入参数：const char* const group_name
		   const char* const item_name
		   string &ret
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::item_get_raw(const char* const group_name, const char* const item_name, string& ret, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if(item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(),item_name_str.c_str())==0){
			get_item_value(cfg_list[i],ret);
			return 1;
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::item_get_raw(const string& group_name, const string& item_name, string& ret, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_raw(group_name.c_str(), item_name.c_str(), ret, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为char型
  输入参数：const char* const group_name               ：组名
		   const char* const item_name                ：项名
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：1 - 该项的项名存在
		   0 - 该项的项名不存在
  说    明：
***************************************************************************/
int config_file_tools::item_get_null(const char* const group_name, const char* const item_name, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			return 1;
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_null(const string& group_name, const string& item_name, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_null(group_name.c_str(), item_name.c_str(), group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为char型
  输入参数：const char* const group_name               ：组名
		   const char* const item_name                ：项名
		   char& value                                ：读到的char的值（返回1时可信，返回0则不可信）
		   const char* const choice_set = nullptr     ：合法的char的集合（例如："YyNn"表示合法输入为Y/N且不分大小写，该参数有默认值nullptr，表示全部字符，即不检查）
		   const char def_value = DEFAULT_CHAR_VALUE  ：读不到/读到非法的情况下的默认值，该参数有默认值DEFAULT_CHAR_VALUE，分两种情况
															当值是   DEFAULT_CHAR_VALUE 时，返回0（值不可信）
															当值不是 DEFAULT_CHAR_VALUE 时，令value=def_value并返回1
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：1 - 取到正确值
			   未取到值/未取到正确值，设置了缺省值（包括设为缺省值）
		   0 - 未取到（只有为未指定默认值的情况下才会返回0）
  说    明：
***************************************************************************/
int config_file_tools::item_get_char(const char* const group_name, const char* const item_name, char& value,
						const char* const choice_set, const char def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str;
			get_item_value(cfg_list[i], value_str);
			istringstream iss(value_str);
			char c;
			iss >> c;
			if (iss.fail() == false && ((choice_set != nullptr && strchr(choice_set, c) != nullptr) || choice_set == nullptr)) {
				/*cout << iss. fail() << endl;*/
				value = c;
				return 1;
			}
			else {
				if (def_value != DEFAULT_CHAR_VALUE) {
					value = def_value;
					return 1;
				}
				else {
					return 0;
				}
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_char(const string& group_name, const string& item_name, char& value,
						const char* const choice_set, const char def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_char(group_name.c_str(), item_name.c_str(), value, choice_set, def_value, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为int型
  输入参数：const char* const group_name               ：组名
		   const char* const item_name                ：项名
		   int& value                                 ：读到的int的值（返回1时可信，返回0则不可信）
		   const int min_value = INT_MIN              : 期望数据范围的下限，默认为INT_MIN
		   const int max_value = INT_MAX              : 期望数据范围的上限，默认为INT_MAX
		   const int def_value = DEFAULT_INT_VALUE    ：读不到/读到非法的情况下的默认值，该参数有默认值 DEFAULT_INT_VALUE，分两种情况
															当值是   DEFAULT_INT_VALUE 时，返回0（值不可信）
															当值不是 DEFAULT_INT_VALUE 时，令value=def_value并返回1
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::item_get_int(const char* const group_name, const char* const item_name, int& value,
						const int min_value, const int max_value, const int def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str;
			get_item_value(cfg_list[i], value_str);
			istringstream iss(value_str);
			int x;
			iss >> x;
			if (iss.fail() == false && (x >= min_value && x <= max_value)) {
				value = x;
				return 1;
			}
			else {
				if (def_value != DEFAULT_INT_VALUE) {
					value = def_value;
					return 1;
				}
				else {
					return 0;
				}
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_int(const string& group_name, const string& item_name, int& value,
						const int min_value, const int max_value, const int def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_int(group_name.c_str(), item_name.c_str(), value, min_value, max_value, def_value, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为double型
  输入参数：const char* const group_name                  ：组名
		   const char* const item_name                   ：项名
		   double& value                                 ：读到的int的值（返回1时可信，返回0则不可信）
		   const double min_value = __DBL_MIN__          : 期望数据范围的下限，默认为INT_MIN
		   const double max_value = __DBL_MAX__          : 期望数据范围的上限，默认为INT_MAX
		   const double def_value = DEFAULT_DOUBLE_VALUE ：读不到/读到非法的情况下的默认值，该参数有默认值DEFAULT_DOUBLE_VALUE，分两种情况
																当值是   DEFAULT_DOUBLE_VALUE 时，返回0（值不可信）
																当值不是 DEFAULT_DOUBLE_VALUE 时，令value=def_value并返回1
		   const bool group_is_case_sensitive = false     : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false      : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::item_get_double(const char* const group_name, const char* const item_name, double& value,
						const double min_value, const double max_value, const double def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str;
			get_item_value(cfg_list[i], value_str);
			istringstream iss(value_str);
			double x;
			iss >> x;
			if (iss.fail() == false && (x >= min_value && x <= max_value)) {
				value = x;
				return 1;
			}
			else {
				if (def_value != DEFAULT_DOUBLE_VALUE) {
					value = def_value;
					return 1;
				}
				else {
					return 0;
				}
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_double(const string& group_name, const string& item_name, double& value,
						const double min_value, const double max_value, const double def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_double(group_name.c_str(), item_name.c_str(), value, min_value, max_value, def_value, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为char * / char []型
  输入参数：const char* const group_name                  ：组名
		   const char* const item_name                   ：项名
		   char *const value                             ：读到的C方式的字符串（返回1时可信，返回0则不可信）
		   const int str_maxlen                          ：指定要读的最大长度（含尾零）
																如果<1则返回空串(不是DEFAULT_CSTRING_VALUE，虽然现在两者相同，但要考虑default值可能会改)
																如果>MAX_STRLEN 则上限为MAX_STRLEN
		   const char* const def_str                     ：读不到情况下的默认值，该参数有默认值DEFAULT_CSTRING_VALUE，分两种情况
																当值是   DEFAULT_CSTRING_VALUE 时，返回0（值不可信）
																当值不是 DEFAULT_CSTRING_VALUE 时，令value=def_value并返回1（注意，不是直接=）
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：1、为简化，未对\"等做转义处理，均按普通字符
		   2、含尾零的最大长度为str_maxlen，调用时要保证有足够空间
		   3、如果 str_maxlen 超过了系统预设的上限 MAX_STRLEN，则按 MAX_STRLEN 取
***************************************************************************/
int config_file_tools::item_get_cstring(const char* const group_name, const char* const item_name, char* const value,
						const int str_maxlen, const char* const def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str;
			get_item_value(cfg_list[i], value_str);
			istringstream iss(value_str);
			char* p = new(nothrow) char[value_str.length() + 1];
			if (p == nullptr) {
				cout << "空间申请失败!" << endl;
				return -1;
			}
			iss >> p;
			if (iss.fail() == false) {
				int len = strlen(p);
				if (len > str_maxlen-1) {
					len = str_maxlen-1;
				}
				strncpy(value, p, len);
				value[len] = '\0';
				delete[] p;
				return 1;
			}
			else {
				if (def_value != DEFAULT_CSTRING_VALUE) {
					int len = strlen(def_value);
					if (len > str_maxlen-1) {
						len = str_maxlen-1;
					}
					strncpy(value, def_value, len);
					value[len] = '\0';
					delete[] p;
					return 1;
				}
				else {
					delete[] p;
					return 0;
				}
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_cstring(const string& group_name, const string& item_name, char* const value,
						const int str_maxlen, const char* const def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)

{
	/* 本函数已实现 */
	return item_get_cstring(group_name.c_str(), item_name.c_str(), value, str_maxlen, def_value, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为 string 型
  输入参数：const char* const group_name               ：组名
		   const char* const item_name                ：项名
		   string &value                              ：读到的string方式的字符串（返回1时可信，返回0则不可信）
		   const string &def_value                    ：读不到情况下的默认值，该参数有默认值DEFAULT_STRING_VALUE，分两种情况
															当值是   DEFAULT_STRING_VALUE 时，返回0（值不可信）
															当值不是 DEFAULT_STRING_VALUE 时，令value=def_value并返回1
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：为简化，未对\"等做转义处理，均按普通字符
***************************************************************************/
int config_file_tools::item_get_string(const char* const group_name, const char* const item_name, string& value,
						const string& def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str0, value_str;
			get_item_value(cfg_list[i], value_str0);
			istringstream iss(value_str0);
			iss >> value_str;  //有点sb的操作，但是为了统一处理，就这样吧
			if (value_str.empty()) {
				if (def_value != DEFAULT_STRING_VALUE) {
					value = def_value;
					return 1;
				}
				else {
					return 0;
				}
			}
			else {
				value = value_str;
				return 1;
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_string(const string& group_name, const string& item_name, string& value,
						const string& def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_string(group_name.c_str(), item_name.c_str(), value, def_value, group_is_case_sensitive, item_is_case_sensitive);
}

/***************************************************************************
  函数名称：
  功    能：取某项的内容，返回类型为 IPv4 地址的32bit整型（主机序）
  输入参数：const char* const group_name               ：组名
		   const char* const item_name                ：项名
		   unsigned int &value                        ：读到的IP地址，32位整型方式（返回1时可信，返回0则不可信）
		   const unsigned int &def_value              ：读不到情况下的默认值，该参数有默认值DEFAULT_IPADDR_VALUE，分两种情况
															当值是   DEFAULT_IPADDR_VALUE 时，返回0（值不可信）
															当值不是 DEFAULT_IPADDR_VALUE 时，令value=def_value并返回1
		   const bool group_is_case_sensitive = false : 组名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
		   const bool item_is_case_sensitive = false  : 项名是否大小写敏感，true-大小写敏感 / 默认false-大小写不敏感
  返 回 值：
  说    明：
***************************************************************************/
int config_file_tools::item_get_ipaddr(const char* const group_name, const char* const item_name, unsigned int& value,
						const unsigned int& def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	string group_name_str = group_name;
	string item_name_str = item_name;

	int start_index;  // 组的内容的起始位置
	int last_index;   // 组的内容的结束位置

	if (!get_group_range(group_name_str, start_index, last_index, group_is_case_sensitive)) {
		return 0;
	}

	for (int i = start_index; i <= last_index; i++) {  // 遍历组的内容
		string item_name_in_line;
		if (!get_item_name(cfg_list[i], item_name_in_line)) {
			continue;
		}
		if (item_is_case_sensitive && item_name_in_line == item_name_str || !item_is_case_sensitive && _stricmp(item_name_in_line.c_str(), item_name_str.c_str()) == 0) {
			string value_str0, value_str;
			get_item_value(cfg_list[i], value_str0);
			istringstream iss(value_str0);
			iss >> value_str;
			if (Is_Valid_IPAddr(value_str)) {
				value = IPAddr_To_Int(value_str);
				return 1;
			}
			else {
				if (def_value != DEFAULT_IPADDR_VALUE) {
					value = def_value;
					return 1;
				}
				else {
					return 0;
				}
			}
		}
	}
	return 0;
}

/***************************************************************************
  函数名称：
  功    能：组名/项目为string方式，其余同上
  输入参数：
  返 回 值：
  说    明：因为工具函数一般在程序初始化阶段被调用，不会在程序执行中被高频次调用，
		   因此这里直接套壳，会略微影响效率，但不影响整体性能（对高频次调用，此方法不适合）
***************************************************************************/
int config_file_tools::item_get_ipaddr(const string& group_name, const string& item_name, unsigned int& value,
						const unsigned int& def_value, const bool group_is_case_sensitive, const bool item_is_case_sensitive)
{
	/* 本函数已实现 */
	return this->item_get_ipaddr(group_name.c_str(), item_name.c_str(), value, def_value, group_is_case_sensitive, item_is_case_sensitive);
}
