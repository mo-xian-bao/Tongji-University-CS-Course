/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include "../include/class_aat.h"

#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

// 如有必要，可以加入其它头文件
using namespace std;

#if !ENABLE_LIB_COMMON_TOOLS  // 不使用lib才有效

/* ---------------------------------------------------------------
     允许加入其它需要static函数（内部工具用）
   ---------------------------------------------------------------- */

   // 匹配参数类型
static int Match_Args_Type(args_analyse_tools* const args, const string name)
{
    for (int i = 0; args[i].get_name().empty() == false; i++) {  // 遍历参数表直到遇到空表项
        if (name == args[i].get_name()) {
            return i;
        }
    }
    return -1;  // 未找到参数
}

// 判断字符串是否为int类型
static bool Is_Int(const string str0)
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

// 判断字符串是否为double类型
static bool Is_Double(const string str0)
{
    string str = str0;
    if (str[0] == '-') {
        str = str.substr(1);
    }
    if (str.empty()) {
        return false;
    }
    bool dot_existed = false;
    for (unsigned int i = 0; i < str.size(); i++) {
        if (str[i] < '0' || str[i] > '9') {
            if (str[i] == '.' && dot_existed == false) {
                dot_existed = true;
            }
            else {
                return false;
            }
        }
    }
    return true;
}

// 判断字符串是否为ip地址
static bool Is_IPAddr(const string str)
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
            if (!Is_Int(num_str)) {
                return false;  // 数字串不是整数
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
        if (!Is_Int(num_str)) {
            return false;  // 数字串不是整数
        }
    }
    if (dot_count != 3) {
        return false;  //"."的个数不等于3
    }
    return true;
}

// 判断ip地址是否合法
static bool Is_Valid_IPAddr(const string str)
{
    string num;
    for (unsigned int i = 0; i < str.size(); i++) {
        if (str[i] == '.') {
            if(stoi(num) < 0 || stoi(num) > 255||num.length() > 3)
                return false;
            num.clear();
        }
        else {
            num += str[i];
        }
    }
    if(stoi(num) < 0 || stoi(num) > 255 || num.length() > 3)
        return false;
    return true;
}

// 将IP地址转换为整数
static unsigned int IPAddr_To_Int(const string str)
{
    if(str.empty())
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

// 将整数转换为IP地址
static string Int_To_IPAddr(const unsigned int ip_int)
{
    string ip_str ;
    ip_str = to_string((ip_int >> 24) & 0xFF) + "." + to_string((ip_int >> 16) & 0xFF) + "." + to_string((ip_int >> 8) & 0xFF) + "." + to_string(ip_int & 0xFF);
    return ip_str;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：null
 ***************************************************************************/
args_analyse_tools::args_analyse_tools()
{
    args_name = "";  //仅用于判断结尾
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：boolean
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const ST_EXTARGS_TYPE type, const int ext_num, const bool def)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    extargs_bool_default = def;
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：int_with_default、int_with_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const ST_EXTARGS_TYPE type, const int ext_num, const int def, const int _min, const int _max)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    extargs_int_default = def;
    extargs_int_value = def;
    extargs_int_min = _min;
    extargs_int_max = _max;
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：int_with_set_default、int_with_set_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const enum ST_EXTARGS_TYPE type, const int ext_num, const int def_of_set_pos, const int* const set)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    
    int set_size = 0;
    while (set[set_size] != INVALID_INT_VALUE_OF_SET) {
        set_size++;
    }
    extargs_int_set = new(nothrow)int[set_size+1];
    for (int i = 0; i < set_size; i++) {
        extargs_int_set[i] = set[i];
    }
    extargs_int_set[set_size] = INVALID_INT_VALUE_OF_SET;

    extargs_int_default = set[def_of_set_pos];
    extargs_int_value = set[def_of_set_pos];
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：str、ipaddr_with_default、ipaddr_with_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const ST_EXTARGS_TYPE type, const int ext_num, const string def)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    if (type == ST_EXTARGS_TYPE::str) {
        extargs_string_default = def;
        extargs_string_value = def;
    }
    else {  // ipaddr
        extargs_ipaddr_default = IPAddr_To_Int(def);
        extargs_ipaddr_value = IPAddr_To_Int(def);
    }
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：str_with_set_default、str_with_set_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const ST_EXTARGS_TYPE type, const int ext_num, const int def_of_set_pos, const string* const set)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    
    int set_size = 0;
    while (set[set_size] != "") {
        set_size++;
    }
    extargs_string_set = new(nothrow)string[set_size+1];
    for (int i = 0; i < set_size; i++) {
        extargs_string_set[i] = set[i];
    }
    extargs_string_set[set_size] = "";

    if (def_of_set_pos < set_size && def_of_set_pos >= 0) {
        extargs_string_default = set[def_of_set_pos];
        extargs_string_value = set[def_of_set_pos];
    }
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：double_with_default、double_with_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const ST_EXTARGS_TYPE type, const int ext_num, const double	def, const double _min, const double _max)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    extargs_double_default = def;
    extargs_double_value = def;
    extargs_double_min = _min;
    extargs_double_max = _max;
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：double_with_set_default、double_with_set_error
 ***************************************************************************/
args_analyse_tools::args_analyse_tools(const char* name, const enum ST_EXTARGS_TYPE type, const int ext_num, const int def_of_set_pos, const double* const set)
{
    args_name = name;
    extargs_type = type;
    extargs_num = ext_num;   // 默认为1
    
    int set_size = 0;
    while (set[set_size] != INVALID_DOUBLE_VALUE_OF_SET) {
        set_size++;
    }
    extargs_double_set = new(nothrow)double[set_size+1];
    for (int i = 0; i < set_size; i++) {
        extargs_double_set[i] = set[i];
    }
    extargs_double_set[set_size] = INVALID_DOUBLE_VALUE_OF_SET;

    extargs_double_default = set[def_of_set_pos];
    extargs_double_value = set[def_of_set_pos];
    args_existed = false;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
 ***************************************************************************/
args_analyse_tools::~args_analyse_tools()
{
    if (extargs_type == ST_EXTARGS_TYPE::int_with_set_default || extargs_type == ST_EXTARGS_TYPE::int_with_set_error) {
        delete[] extargs_int_set;
    }
    else if (extargs_type == ST_EXTARGS_TYPE::double_with_set_default || extargs_type == ST_EXTARGS_TYPE::double_with_set_error) {
        delete[] extargs_double_set;
    }
    else if (extargs_type == ST_EXTARGS_TYPE::str_with_set_default || extargs_type == ST_EXTARGS_TYPE::str_with_set_error) {
        delete[] extargs_string_set;
    }
}

/* ---------------------------------------------------------------
     允许AAT中自定义成员函数的实现（private）
   ---------------------------------------------------------------- */

   /***************************************************************************
     函数名称：
     功    能：
     输入参数：
     返 回 值：
     说    明：已实现，不要动
    ***************************************************************************/
const string args_analyse_tools::get_name() const
{
    return this->args_name;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：加!!后，只能是0/1
            已实现，不要动
 ***************************************************************************/
const int args_analyse_tools::existed() const
{
    return !!this->args_existed;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：已实现，不要动
 ***************************************************************************/
const int args_analyse_tools::get_int() const
{
    return this->extargs_int_value;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：已实现，不要动
 ***************************************************************************/
const double args_analyse_tools::get_double() const
{
    return this->extargs_double_value;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：已实现，不要动
 ***************************************************************************/
const string args_analyse_tools::get_string() const
{
    return this->extargs_string_value;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：已实现，不要动
 ***************************************************************************/
const unsigned int args_analyse_tools::get_ipaddr() const
{
    return this->extargs_ipaddr_value;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：将 extargs_ipaddr_value 的值从 0x7f000001 转为 "127.0.0.1"
 ***************************************************************************/
const string args_analyse_tools::get_str_ipaddr() const
{
    string ip_str ;
    ip_str = to_string((extargs_ipaddr_value >> 24) & 0xFF) + "." 
              + to_string((extargs_ipaddr_value >> 16) & 0xFF) + "." 
              + to_string((extargs_ipaddr_value >> 8) & 0xFF) + "." 
              + to_string(extargs_ipaddr_value & 0xFF);
    return ip_str;
}


/***************************************************************************
  函数名称：
  功    能：
  输入参数：follow_up_args：是否有后续参数
            0  ：无后续参数
            1  ：有后续参数
  返 回 值：
  说    明：友元函数
***************************************************************************/
int args_analyse_process(const int argc, const char* const* const argv, args_analyse_tools* const args, const int follow_up_args)
{
    // 遍历参数
    for (int i = 1; i < argc; i++) {
        string arg = argv[i];  // 当前参数
        // 判断参数格式
        if (arg.substr(0, 2) == "--") {  // 以--开头,可变参数格式
            if (arg.length() < 3) {  //--后面没有内容
                cout << "参数[--]格式非法(不是--开头的有效内容)." << endl;
                return MY_ERROR;
            }
            // 后面有内容，尝试匹配参数表
            int index = Match_Args_Type(args, arg);
            if (index == -1) {  // 未找到参数
                cout << "参数[" << arg << "]非法." << endl;
                return MY_ERROR;
            }
            else {  // 找到参数,处理
                if (args[index].args_existed) {  // 参数已存在
                    cout << "参数[" << arg << "]重复." << endl;
                    return MY_ERROR;
                }
                args[index].args_existed = 1;
                if (args[index].extargs_num == 0) {  // 不需要附加值
                    continue;
                }
                else {  // 需要附加值
                    if (i == argc - 1|| argv[i + 1][0] == '-' && argv[i + 1][1] == '-') {  // 后面没有参数
                        if (i == argc - 1) { 
                            cout << "参数[" << arg << "]的附加参数不足. ";
                        }
                        else if (argv[i + 1][0] == '-' && argv[i + 1][1] == '-') {
                            cout << "参数[" << arg << "]缺少附加参数. ";
                        }
                        switch (args[index].extargs_type) {
                        case ST_EXTARGS_TYPE::int_with_default:
                            cout << "(类型:int, 范围[" << args[index].extargs_int_min << ".." << args[index].extargs_int_max << "] 缺省:" << args[index].extargs_int_default << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::int_with_error:
                            cout << "(类型:int, 范围[" << args[index].extargs_int_min << ".." << args[index].extargs_int_max << "])" << endl;
                            break;
                        case ST_EXTARGS_TYPE::int_with_set_default:
                            cout << "(类型:int, 可取值[";
                            for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                cout << *p;
                                if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                                    cout << "/";
                                }
                            }
                            cout << "] 缺省:" << args[index].extargs_int_default << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::int_with_set_error:
                            cout << "(类型:int, 可取值[";
                            for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                cout << *p;
                                if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                                    cout << "/";
                                }
                            }
                            cout << "])" << endl;
                            break;
                        case ST_EXTARGS_TYPE::double_with_default:
                            cout << "(类型:double, 范围[" << args[index].extargs_double_min << ".." << args[index].extargs_double_max << "] 缺省:" << args[index].extargs_double_default << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::double_with_error:
                            cout << "(类型:double, 范围[" << args[index].extargs_double_min << ".." << args[index].extargs_double_max << "])" << endl;
                            break;
                        case ST_EXTARGS_TYPE::double_with_set_default:
                            cout << "(类型:double, 可取值[";
                            for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                cout << *p;
                                if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                                    cout << "/";
                                }
                            }
                            cout << "] 缺省:" << args[index].extargs_double_default << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::double_with_set_error:
                            cout << "(类型:double, 可取值[";
                            for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                cout << *p;
                                if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                                    cout << "/";
                                }
                            }
                            cout << "])" << endl;
                            break;
                        case ST_EXTARGS_TYPE::str:
                            if (args[index].extargs_string_default.empty()) {
                                cout << "(类型:string)" << endl;
                            }
                            else {
                                cout << "(类型:string 缺省:" << args[index].extargs_string_default << ")" << endl;
                            }
                            break;
                        case ST_EXTARGS_TYPE::str_with_set_default:
                            cout << "(类型:string, 可取值[";
                            for (string* p = args[index].extargs_string_set; (*p).empty() == false; p++) {
                                cout << *p;
                                if (*(p + 1) != "") {
                                    cout << "/";
                                }
                            }
                            cout << "] 缺省:" << args[index].extargs_string_default << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::str_with_set_error:
                            cout << "(类型:string, 可取值[";
                            for (string* p = args[index].extargs_string_set; (*p).empty() == false; p++) {
                                cout << *p;
                                if (*(p + 1) != "") {
                                    cout << "/";
                                }
                            }
                            cout << "])" << endl;
                            break;
                        case ST_EXTARGS_TYPE::ipaddr_with_default:
                            cout << "(类型:IP地址 缺省:" << Int_To_IPAddr(args[index].extargs_ipaddr_default) << ")" << endl;
                            break;
                        case ST_EXTARGS_TYPE::ipaddr_with_error:
                            cout << "(类型:IP地址)" << endl;
                            break;
                        default:
                            break;
                        }
                        return MY_ERROR;
                    }
                    else {  // 后面有参数
                        bool found = false;
                        switch (args[index].extargs_type) {
                        case ST_EXTARGS_TYPE::int_with_default:
                            if (Is_Int(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是整数. (类型:int, 范围[" << args[index].extargs_int_min << ".." << args[index].extargs_int_max << "] 缺省:" << args[index].extargs_int_default << ")" << endl;
                                return MY_ERROR;
                            }
                            else {
                                int value = atoi(argv[i + 1]);
                                if (value < args[index].extargs_int_min || value > args[index].extargs_int_max) {  // 值超范围
                                    args[index].extargs_int_value = args[index].extargs_int_default;  // 使用缺省值
                                }
                                else {
                                    args[index].extargs_int_value = value;  // 使用附加值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::int_with_error:
                            if (Is_Int(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是整数. (类型:int, 范围[" << args[index].extargs_int_min << ".." << args[index].extargs_int_max << "])" << endl;
                                return MY_ERROR;
                            }
                            else {
                                int value = atoi(argv[i + 1]);
                                if (value < args[index].extargs_int_min || value > args[index].extargs_int_max) {  // 值超范围
                                    cout << "参数[" << arg << "]的附加参数值(" << value << ")非法. (类型:int, 范围[" << args[index].extargs_int_min << ".." << args[index].extargs_int_max << "])" << endl;
                                    return MY_ERROR;
                                }
                                else {
                                    args[index].extargs_int_value = value;  // 使用附加值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::int_with_set_default:
                            if (Is_Int(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是整数. (类型:int, 可取值[";
                                for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                    cout << *p;
                                    if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                                        cout << "/";
                                    }
                                }
                                cout << "] 缺省:" << args[index].extargs_int_default << ")" << endl;
                                return MY_ERROR;
                            }
                            else {
                                int value = atoi(argv[i + 1]);
                                for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                    if (value == *p) {  // 找到匹配项
                                        args[index].extargs_int_value = value;  // 使用附加值
                                        found = true;
                                        break;
                                    }
                                }
                                if (found == false) {  // 未找到匹配项
                                    args[index].extargs_int_value = args[index].extargs_int_default;  // 使用缺省值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::int_with_set_error:
                            if (Is_Int(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是整数. (类型:int, 可取值[";
                                for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                    cout << *p;
                                    if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                                        cout << "/";
                                    }
                                }
                                cout << "])" << endl;
                                return MY_ERROR;
                            }
                            else {
                                int value = atoi(argv[i + 1]);
                                for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                    if (value == *p) {  // 找到匹配项
                                        args[index].extargs_int_value = value;  // 使用附加值
                                        found = true;
                                        break;
                                    }
                                }
                                if (found == false) {  // 未找到匹配项
                                    cout << "参数[" << arg << "]的附加参数值(" << value << ")非法. (类型:int, 可取值[";
                                    for (int* p = args[index].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                                        cout << *p;
                                        if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                                            cout << "/";
                                        }
                                    }
                                    cout << "])" << endl;
                                    return MY_ERROR;
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::double_with_default:
                            if (Is_Double(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是浮点数. (类型:double, 范围[" << args[index].extargs_double_min << ".." << args[index].extargs_double_max << "] 缺省:" << args[index].extargs_double_default << ")" << endl;
                                return MY_ERROR;
                            }
                            else {
                                double value = atof(argv[i + 1]);
                                if (value < args[index].extargs_double_min || value > args[index].extargs_double_max) {  // 值超范围
                                    args[index].extargs_double_value = args[index].extargs_double_default;  // 使用缺省值
                                }
                                else {
                                    args[index].extargs_double_value = value;  // 使用附加值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::double_with_error:
                            if (Is_Double(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是浮点数. (类型:double, 范围[" << args[index].extargs_double_min << ".." << args[index].extargs_double_max << "])" << endl;
                                return MY_ERROR;
                            }
                            else {
                                double value = atof(argv[i + 1]);
                                if (value < args[index].extargs_double_min || value > args[index].extargs_double_max) {  // 值超范围
                                    cout << "参数[" << arg << "]的附加参数值(" << value << ")非法. (类型:double, 范围[" << args[index].extargs_double_min << ".." << args[index].extargs_double_max << "])" << endl;
                                    return MY_ERROR;
                                }
                                else {
                                    args[index].extargs_double_value = value;  // 使用附加值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::double_with_set_default:
                            if (Is_Double(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是浮点数. (类型:double, 可取值[";
                                for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                    cout << *p;
                                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                                        cout << "/";
                                    }
                                }
                                cout << "] 缺省:" << args[index].extargs_double_default << ")" << endl;
                                return MY_ERROR;
                            }
                            else {
                                double value = atof(argv[i + 1]);
                                for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                    if (value == *p) {  // 找到匹配项
                                        args[index].extargs_double_value = value;  // 使用附加值
                                        found = true;
                                        break;
                                    }
                                }
                                if (found == false) {  // 未找到匹配项
                                    args[index].extargs_double_value = args[index].extargs_double_default;  // 使用缺省值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::double_with_set_error:
                            if (Is_Double(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是浮点数. (类型:double, 可取值[";
                                for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                    cout << *p;
                                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                                        cout << "/";
                                    }
                                }
                                cout << "])" << endl;
                                return MY_ERROR;
                            }
                            else {
                                double value = atof(argv[i + 1]);
                                for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                    if (value == *p) {  // 找到匹配项
                                        args[index].extargs_double_value = value;  // 使用附加值
                                        found = true;
                                        break;
                                    }
                                }
                                if (found == false) {  // 未找到匹配项
                                    cout << "参数[" << arg << "]的附加参数值(" << value << ")非法. (类型:double, 可取值[";
                                    for (double* p = args[index].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                                        cout << *p;
                                        if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                                            cout << "/";
                                        }
                                    }
                                    cout << "])" << endl;
                                    return MY_ERROR;
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::str:
                            args[index].extargs_string_value = argv[i + 1];  // 使用附加值
                            break;
                        case ST_EXTARGS_TYPE::str_with_set_default:
                            for (string* p = args[index].extargs_string_set; (*p).empty() == false; p++) {
                                if (*p == argv[i + 1]) {  // 找到匹配项
                                    args[index].extargs_string_value = argv[i + 1];  // 使用附加值
                                    break;
                                }
                                else {  // 未找到匹配项
                                    args[index].extargs_string_value = args[index].extargs_string_default;  // 使用缺省值
                                }
                            }
                            break;
                        case ST_EXTARGS_TYPE::str_with_set_error:
                            for (string* p = args[index].extargs_string_set; (*p).empty() == false; p++) {
                                if (*p == argv[i + 1]) {  // 找到匹配项
                                    args[index].extargs_string_value = argv[i + 1];  // 使用附加值
                                    found = true;
                                    break;
                                }
                            }
                            if (found == false) {  // 未找到匹配项
                                cout << "参数[" << arg << "]的附加参数值(" << argv[i + 1] << ")非法. (类型:string, 可取值[";
                                for (string* p = args[index].extargs_string_set; (*p).empty() == false; p++) {
                                    cout << *p;
                                    if (*(p + 1) != "") {
                                        cout << "/";
                                    }
                                }
                                cout << "])" << endl;
                                return MY_ERROR;
                            }
                            break;
                        case ST_EXTARGS_TYPE::ipaddr_with_default:
                            if (Is_IPAddr(argv[i + 1]) == false ||Is_Valid_IPAddr(argv[i + 1]) == false) {
                                args[index].extargs_ipaddr_value = args[index].extargs_ipaddr_default;  // 使用缺省值
                            }
                            else {
                                args[index].extargs_ipaddr_value = IPAddr_To_Int(argv[i + 1]);  // 使用附加值
                            }
                            break;
                        case ST_EXTARGS_TYPE::ipaddr_with_error:
                            if (Is_IPAddr(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数不是IP地址. (类型:IP地址)" << endl;
                                return MY_ERROR;
                            }
                            else if (Is_Valid_IPAddr(argv[i + 1]) == false) {
                                cout << "参数[" << arg << "]的附加参数值(" << argv[i + 1] << ")非法. (类型:IP地址)" << endl;
                                return MY_ERROR;
                            }
                            else {
                                args[index].extargs_ipaddr_value = IPAddr_To_Int(argv[i + 1]);  // 使用附加值
                            }
                            break;
                        }
                        i++;  // 跳过附加参数
                    }
                }
            }
        }
        else {  // 不以--开头,固定参数格式
            if (follow_up_args == 0) {
                cout << "参数[" << arg << "]格式非法(不是--开头的有效内容)." << endl;
                return MY_ERROR;
            }
            else {
                // 后面的参数均视为固定参数,不做处理
                return i;  // 返回可变参数个数
            }
        }
    }
    return argc;  // 正常结束
}


/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：友元函数
***************************************************************************/
int args_analyse_print(const args_analyse_tools* const args)
{
    int w1 = 6, w2 = 5, w3 = 8, w4 = 7, w5 = 6, w6 = 10;  //都需要根据最大值动态调整（除了w4）
    for (int i = 0; args[i].args_name.empty() == false; i++) {
        ostringstream oss1, oss2, oss3, oss4, oss5, oss6;
        string str_set = "";
        switch (args[i].extargs_type) {
            case ST_EXTARGS_TYPE::boolean:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 5);
                break;
            case ST_EXTARGS_TYPE::int_with_default:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 15);
                w3 = max(w3, int(to_string(args[i].extargs_int_default).length() + 1));
                w5 = max(w5, (args[i].args_existed==1?int(to_string(args[i].extargs_int_value).length() + 1):1));
                w6 = max(w6, int(to_string(args[i].extargs_int_min).length() + 1) + int(to_string(args[i].extargs_int_max).length() + 1) + 3);
                break;
            case ST_EXTARGS_TYPE::int_with_error:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 13);
                w6 = max(w6, int(to_string(args[i].extargs_int_min).length() + 1) + int(to_string(args[i].extargs_int_max).length() + 1) + 3);
                break;
            case ST_EXTARGS_TYPE::int_with_set_default:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 18);
                w3 = max(w3, int(to_string(args[i].extargs_int_value).length() + 1));
                w5 = max(w5, (args[i].args_existed==1?int(to_string(args[i].extargs_int_value).length() + 1):1));
                for (int* p = args[i].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                    str_set += to_string(*p);
                    if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                        str_set += "/";
                    }
                }
                w6 = max(w6, int(str_set.length() + 1));
                break;
            case ST_EXTARGS_TYPE::int_with_set_error:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 16);
                w5 = max(w5, (args[i].args_existed==1?int(to_string(args[i].extargs_int_value).length() + 1):1));
                for (int* p = args[i].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                    str_set += to_string(*p);
                    if (*(p + 1) != INVALID_INT_VALUE_OF_SET) {
                        str_set += "/";
                    }
                }
                w6 = max(w6, int(str_set.length() + 1));
                break;
            case ST_EXTARGS_TYPE::double_with_default:
                oss1 << fixed << setprecision(6) << args[i].extargs_double_default;
                oss2 << fixed << setprecision(6) << args[i].extargs_double_value;
                oss3 << "[" << fixed << setprecision(6) << args[i].extargs_double_min << ".." << fixed << setprecision(6) << args[i].extargs_double_max << "]";
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 16);
                w3 = max(w3, int(oss1.str().length() + 1));
                w5 = max(w5, args[i].args_existed==1?int(oss2.str().length() + 1):1);
                w6 = max(w6, int(oss3.str().length() + 1));
                break;
            case ST_EXTARGS_TYPE::double_with_error:
                oss2 << fixed << setprecision(6) << args[i].extargs_double_value;
                oss3 << "[" << fixed << setprecision(6) << args[i].extargs_double_min << ".." << fixed << setprecision(6) << args[i].extargs_double_max << "]";
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 14);
                w5 = max(w5, args[i].args_existed==1?int(oss2.str().length() + 1):1);
                w6 = max(w6, int(oss3.str().length() + 1));
                break;
            case ST_EXTARGS_TYPE::double_with_set_default:
                oss1 << fixed << setprecision(6) << args[i].extargs_double_default;
                oss2 << fixed << setprecision(6) << args[i].extargs_double_value;
                for (double* p = args[i].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                    oss3 << fixed << setprecision(6) << *p;
                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                        oss3 << "/";
                    }
                }
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 19);
                w3 = max(w3, int(oss1.str().length() + 1));
                w5 = max(w5, args[i].args_existed==1?int(oss2.str().length() + 1):1);
                w6 = max(w6, int(oss3.str().length() + 1));
                break;
            case ST_EXTARGS_TYPE::double_with_set_error:
                oss2 << fixed << setprecision(6) << args[i].extargs_double_value;
                for (double* p = args[i].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                    oss3 << fixed << setprecision(6) << *p;
                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET) {
                        oss3 << "/";
                    }
                }
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 17);
                w5 = max(w5, args[i].args_existed==1?int(oss2.str().length() + 1):1);
                w6 = max(w6, int(oss3.str().length() + 1));
                break;
            case ST_EXTARGS_TYPE::str:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 7);
                w3 = max(w3, int(args[i].extargs_string_default.length() + 1));
                w5 = max(w5, args[i].args_existed==1?int(args[i].extargs_string_value.length() + 1):1);
                break;
            case ST_EXTARGS_TYPE::str_with_set_default:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 21);
                w3 = max(w3, int(args[i].extargs_string_default.length() + 1));
                w5 = max(w5, args[i].args_existed==1?int(args[i].extargs_string_value.length() + 1):1);
                for (string* p = args[i].extargs_string_set; (*p).empty() == false; p++) {
                    str_set += *p;
                    if (*(p + 1) != ""){
                        str_set += "/";
                    }
                }
                w6 = max(w6, int(str_set.length() + 1));
                break;
            case ST_EXTARGS_TYPE::str_with_set_error:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 19);
                w5 = max(w5, args[i].args_existed==1?int(args[i].extargs_string_value.length() + 1):1);
                for (string* p = args[i].extargs_string_set; (*p).empty() == false; p++) {
                    str_set += *p;
                    if (*(p + 1) != "") {
                        str_set += "/";
                    }
                }
                w6 = max(w6, int(str_set.length() + 1));
                break;
            case ST_EXTARGS_TYPE::ipaddr_with_default:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 18);
                w3 = max(w3, int(Int_To_IPAddr(args[i].extargs_ipaddr_default).length() + 1));
                w5 = max(w5, args[i].args_existed==1?int(Int_To_IPAddr(args[i].extargs_ipaddr_value).length() + 1):1);
                break;
            case ST_EXTARGS_TYPE::ipaddr_with_error:
                w1 = max(w1, int(args[i].args_name.length() + 2));
                w2 = max(w2, 16);
                w5 = max(w5, args[i].args_existed==1?int(Int_To_IPAddr(args[i].extargs_ipaddr_value).length() + 1):1);
                break;
        }
    }

    cout << left;
    cout << setw(w1 + w2 + w3 + w4 + w5 + w6) << setfill('=') << '=' << setfill(' ') << endl;
    cout << setw(w1) << " name" << setw(w2) << "type" << setw(w3) << "default" << setw(w4) << "exists" <<setw(w5) << "value" << "range/set" << endl;
    cout << setw(w1 + w2 + w3 + w4 + w5 + w6) << setfill('=') << '=' << setfill(' ') << endl;

    for (int i = 0; args[i].args_name.empty() == false; i++) {
        ostringstream oss_double;
        switch (args[i].extargs_type) {
            case ST_EXTARGS_TYPE::boolean:
                cout << setw(w1) << " "+args[i].args_name
                     << setw(w2) << "Bool" 
                     << setw(w3) << (args[i].extargs_bool_default ? "true" : "false")
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? "true" : "/")
                     << "/" << endl;
                break;
            case ST_EXTARGS_TYPE::int_with_default:
                cout << setw(w1) << " " +args[i].args_name
                     << setw(w2) << "IntWithDefault"
                     << setw(w3) << args[i].extargs_int_default
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? to_string(args[i].extargs_int_value) : "/")
                     << "[" << args[i].extargs_int_min << ".." << args[i].extargs_int_max << "]" << endl;
                break;
            case ST_EXTARGS_TYPE::int_with_error:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "IntWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? to_string(args[i].extargs_int_value) : "/")
                     << "[" << args[i].extargs_int_min << ".." << args[i].extargs_int_max << "]" << endl;
                break;
            case ST_EXTARGS_TYPE::int_with_set_default:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "IntSETWithDefault"
                     << setw(w3) << args[i].extargs_int_default
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? to_string(args[i].extargs_int_value) : "/");
                for (int* p = args[i].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                    cout << *p;
                    if (*(p + 1)!= INVALID_INT_VALUE_OF_SET)
                        cout << "/";
                }
                cout  << endl;
                break;
            case ST_EXTARGS_TYPE::int_with_set_error:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "IntSETWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? to_string(args[i].extargs_int_value) : "/");
                for (int* p = args[i].extargs_int_set; *p != INVALID_INT_VALUE_OF_SET; p++) {
                    cout << *p;
                    if (*(p + 1) != INVALID_INT_VALUE_OF_SET)
                        cout << "/";
                }
                cout  << endl;
                break;
            case ST_EXTARGS_TYPE::double_with_default:
                if(args[i].args_existed)
                    oss_double << fixed << setprecision(6) << args[i].extargs_double_value;
                else
                    oss_double << "/";
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "DoubleWithDefault"
                     << setw(w3) << fixed << setprecision(6) << args[i].extargs_double_default
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << oss_double.str()
                     << "[" << fixed << setprecision(6) << args[i].extargs_double_min << ".." << args[i].extargs_double_max << "]" << endl;
                break;
            case ST_EXTARGS_TYPE::double_with_error:
                if(args[i].args_existed)
                    oss_double << fixed << setprecision(6) << args[i].extargs_double_value;
                else
                    oss_double << "/";
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "DoubleWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << oss_double.str()
                     << "[" << fixed << setprecision(6) << args[i].extargs_double_min << ".." << args[i].extargs_double_max << "]" << endl;
                break;
            case ST_EXTARGS_TYPE::double_with_set_default:
                if(args[i].args_existed)
                    oss_double << fixed << setprecision(6) << args[i].extargs_double_value;
                else
                    oss_double << "/";
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "DoubleSETWithDefault"
                     << setw(w3) << fixed << setprecision(6) << args[i].extargs_double_default
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << oss_double.str();
                for (double* p = args[i].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                    cout << fixed << setprecision(6) << *p;
                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET)
                        cout << "/";
                }
                cout << endl;
                break;
            case ST_EXTARGS_TYPE::double_with_set_error:
                if(args[i].args_existed)
                    oss_double << fixed << setprecision(6) << args[i].extargs_double_value;
                else
                    oss_double << "/";
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "DoubleSETWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << oss_double.str();
                for (double* p = args[i].extargs_double_set; *p != INVALID_DOUBLE_VALUE_OF_SET; p++) {
                    cout << fixed << setprecision(6) << *p;
                    if (*(p + 1) != INVALID_DOUBLE_VALUE_OF_SET)
                        cout << "/";
                }
                cout  << endl;
                break;
            case ST_EXTARGS_TYPE::str:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "String"
                    << setw(w3) << (args[i].extargs_string_default.empty()==false ? args[i].extargs_string_default : "/")
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? args[i].extargs_string_value : "/")
                     << "/" << endl;
                break;
            case ST_EXTARGS_TYPE::str_with_set_default:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "StringSETWithDefault"
                     << setw(w3) << args[i].extargs_string_default
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? args[i].extargs_string_value : "/");
                for (string* p = args[i].extargs_string_set; (*p).empty() == false; p++) {
                    cout << *p;
                    if (*(p + 1) != "")
                        cout << "/";
                }
                cout  << endl;
                break;
            case ST_EXTARGS_TYPE::str_with_set_error:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "StringSETWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? args[i].extargs_string_value : "/");
                for (string* p = args[i].extargs_string_set; (*p).empty() == false; p++) {
                    cout << *p;
                    if (*(p + 1) != "")
                        cout << "/";
                }
                cout  << endl;
                break;
            case ST_EXTARGS_TYPE::ipaddr_with_default:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "IPAddrWithDefault"
                     << setw(w3) << Int_To_IPAddr(args[i].extargs_ipaddr_default)
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? Int_To_IPAddr(args[i].extargs_ipaddr_value) : "/")
                     << "/" << endl;
                break;
            case ST_EXTARGS_TYPE::ipaddr_with_error:
                cout << setw(w1) << " " + args[i].args_name
                     << setw(w2) << "IPAddrWithError"
                     << setw(w3) << "/"
                     << setw(w4) << args[i].args_existed 
                     << setw(w5) << (args[i].args_existed ? Int_To_IPAddr(args[i].extargs_ipaddr_value) : "/")
                     << "/" << endl;
                break;
            default:
                break;
        }
    }
    cout << setw(w1 + w2 + w3 + w4 + w5 + w6) << setfill('=') << '=' << setfill(' ') << endl;
    cout<<endl;
    cout.unsetf(ios::fixed);

    return 0;  // 此句根据需要修改
}

#endif  // !ENABLE_LIB_COMMON_TOOLS
