/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "../include/class_aat.h"
#include "../include/class_cft.h"
#include "../include_mariadb_x86/mysql/mysql.h"  // mysql特有
#include "hw_check.h"

static const char* suffix[] = {".cpp", ".c",  ".h", ".hpp", "all", ""};  // 源程序文件后缀名

static bool check_pdf_format(const string src_rootdir, const string cno, const string stu, const string file) 
{
    const char* suffix = strrchr(file.c_str(), '.');
    if (suffix == NULL) {
        return false;
    }
    if (strcmp(suffix, ".pdf") != 0) {
        return true;
    } 
    else {
        string filepath = src_rootdir + "/" + cno + "-" + stu + "/" + file;
        ifstream fin(filepath);
        if (!fin) {
            return false;
        }
        char str0[9] = {0};
        fin.read(str0, 8);
        string str = str0;
        string str1 = str.substr(0, 7);
        fin.close();
        if (str1 != "%PDF-1." || str0[7] < '0' || str0[7] > '9') {
            return false;
        }
    }
    return true;
}

static bool is_utf8(const char* str) 
{
    // 0XXX_XXXX(ascii码）
    /*utf8编码规则：
    110X_XXXX 10XX_XXXX
    1110_XXXX 10XX_XXXX 10XX_XXXX
    1111_0XXX 10XX_XXXX 10XX_XXXX 10XX_XXXX
    1111_10XX 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX
    1111_110X 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX*/
    unsigned int nBytes = 0;  // UFT8可用1-6个字节编码,ASCII用一个字节
    unsigned char chr;
    bool AllAscii = true;
    for (unsigned int i = 0; str[i] != '\0'; ++i) {
        chr = *(str + i);
        // 判断是否ASCII编码,如果不是,说明有可能是UTF8,ASCII用7位编码,最高位标记为0,0xxxxxxx
        if (nBytes == 0 && (chr & 0x80) != 0) {
            AllAscii = false;
        }
        if (nBytes == 0) {  // 下一个为新的多字节开始
            if (chr >= 0x80) {
                if (chr >= 0xFC && chr <= 0xFD) {  // 1111_110X
                    nBytes = 6;
                } 
                else if (chr >= 0xF8) {  // 1111_10XX
                    nBytes = 5;
                } 
                else if (chr >= 0xF0) {  // 1111_0XXX
                    nBytes = 4;
                } 
                else if (chr >= 0xE0) {  // 1110_XXXX
                    nBytes = 3;
                } 
                else if (chr >= 0xC0) {  // 110X_XXXX
                    nBytes = 2;
                } 
                else {
                    return false;  //
                }
                nBytes--;
            }
        } 
        else {
            // 多字节符的非首字节,应为 10xxxxxx
            if ((chr & 0xC0) != 0x80) {
                return false;
            }
            // 减到为零为止
            nBytes--;
        }
    }
    // 违返UTF8编码规则
    if (nBytes != 0) {
        return false;
    }
    if (AllAscii) {  // 如果全部都是ASCII,不认为是UTF8
        return false;
    }
    return true;
}

static bool find_file(const string& cno, const string& stu, const string& file,const string& src_rootdir) 
{
    string filepath = src_rootdir + "/" + cno + "-" + stu + "/" + file;
    ifstream fin(filepath);
    if (!fin) {
        return false;
    }
    fin.close();
    return true;
}

static bool check_utf8(const string& cno, const string& stu, const string& file,const string& src_rootdir) 
{
    string filepath = src_rootdir + "/" + cno + "-" + stu + "/" + file;

    ifstream fin(filepath, ios::binary);
    if (!fin) {
        cout << "check_utf8: file cannot open." << endl;
        return false;  // 文件无法打开
    }

    string str0 = "", str;
    while (getline(fin, str)) {
        str0 += str;
    }
    fin.close();

    if (is_utf8(str0.c_str())) {
        return true;
    } 
    else {
        return false;
    }
}

static bool check_anno(bool& anno_format, const string& file_name,const string& src_rootdir, const string& stu_no, const string& cno, int opt, string& anno_str) 
{
    string filepath = src_rootdir + "/" + cno + "-" + stu_no + "/" + file_name;
    ifstream fin(filepath);
    if (!fin) {
        // cout << "check_anno: file cannot open." << endl;
        return false;
    }
    string str = "";
    while (str == "") getline(fin, str);
    if (opt == 2) {  // 读取第二行
        str = "";
        while (str == "") getline(fin, str);
    }
    fin.close();
    // 去除左右空格
    str.erase(0, str.find_first_not_of(" "));
    str.erase(str.find_last_not_of(" ") + 1);

    if (str[0] == '/' && str[1] == '/') {
        anno_str = str.substr(2);
        return true;
    } 
    else if (str[0] == '/' && str[1] == '*') {
        if (str[str.length() - 2] == '*' && str[str.length() - 1] == '/') {
            anno_format = true;
            anno_str = str.substr(2, str.length() - 4);
            return true;
        } 
        else {
            anno_format = false;
            anno_str = str.substr(2);
            if(opt == 1)
                return true;
            else
                return false;
        }
    }
    return false;
}

static bool check_three(const string& file_name, const string& src_rootdir, const string& stu_no, const string& cno) 
{
    stringstream ss;

    string filepath = src_rootdir + "/" + cno + "-" + stu_no + "/" + file_name;
    ifstream fin(filepath);
    if (!fin) {
        cout << "check_three: file cannot open." << endl;
        return false;
    }
    string str = "";
    while (str == "") getline(fin, str);
    fin.close();
    // 去除左右空格
    str.erase(0, str.find_first_not_of(" "));
    str.erase(str.find_last_not_of(" ") + 1);

    // 去除注释符号
    if (str[0] == '/' && str[1] == '/') {
        str.erase(0, 2);
    } 
    else if (str[0] == '/' && str[1] == '*') {
        if (str[str.length() - 2] == '*' && str[str.length() - 1] == '/') {
            str.erase(0, 2);
            str.erase(str.length() - 2, 2);
        } 
        else {
            str.erase(0, 2);
        }
    }

    ss << str;
    string s1, s2, s3, s4;
    ss >> s1 >> s2 >> s3 >> s4;

    if (s1.empty() || s2.empty() || s3.empty() || !s4.empty()) {
        return false;
    } 
    else {
        return true;
    }
}

static bool check_error(const string& stu_no, const string& stu_name, const string& stu_fmajor, const string& stu_smajor, const string& src_rootdir, const string& cno,const string& file_name, bool& no_error,bool& name_error, bool& major_error) 
{
    string filepath = src_rootdir + "/" + cno + "-" + stu_no + "/" + file_name;
    ifstream fin(filepath);
    if (!fin) {
        // cout << "check_error: file cannot open." << endl;
        return false;
    }
    string str = "";
    while (str == "") getline(fin, str);
    fin.close();
    // 去除左右空格
    str.erase(0, str.find_first_not_of(" "));
    str.erase(str.find_last_not_of(" ") + 1);

    // 去除注释符号
    if (str[0] == '/' && str[1] == '/') {
        str.erase(0, 2);
    } 
    else if (str[0] == '/' && str[1] == '*') {
        if (str[str.length() - 2] == '*' && str[str.length() - 1] == '/') {
            str.erase(0, 2);
            str.erase(str.length() - 2, 2);
        } 
        else {
            str.erase(0, 2);
        }
    }

    stringstream ss;
    ss << str;
    string s1, s2, s3;
    ss >> s1 >> s2 >> s3;

    if (s1 != stu_no && s2 != stu_no && s3 != stu_no) {  // 三项都不是学号
        no_error = true;
    } 
    else {
        no_error = false;
    }
    if (s1 != stu_name && s2 != stu_name && s3 != stu_name) {  // 三项都不是姓名
        name_error = true;
    } 
    else {
        name_error = false;
    }
    if (s1 != stu_fmajor && s2 != stu_fmajor && s3 != stu_fmajor &&
        stu_smajor.find(s1) == string::npos &&
        stu_smajor.find(s2) == string::npos &&
        stu_smajor.find(s3) == string::npos) {  // 三项都不是专业
        major_error = true;
    } 
    else {
        major_error = false;
    }

    return no_error || name_error || major_error;  // 任一项错误返回true，否则返回false
}

void base_check_file(bool& is_submitted, bool& is_src_file, bool& is_utf8, bool& pdf_format_error, bool& vs_error, const string& cno,const string& stu, const string& file, const string& src_rootdir) 
{
    // 是否提交文件
    is_submitted = find_file(cno, stu, file, src_rootdir);

    if (is_submitted) {
        // 是否源文件
        is_src_file = false;
        for (int i = 0; suffix[i] != ""; i++) {
            if (file.find(suffix[i]) != string::npos) {  // 找到后缀名(all也行）
                is_src_file = true;
                break;
            }
        }
        // 是否utf-8编码
        is_utf8 = false;
        if (is_src_file) {  // 源文件才检查编码
            is_utf8 = check_utf8(cno, stu, file, src_rootdir);
        }
        // pdf格式是否正确
        pdf_format_error = !check_pdf_format(src_rootdir, cno, stu, file);
        // vs能否识别
        if (is_src_file) {
            string filepath = src_rootdir + "/" + cno + "-" + stu + "/" + file;
            ifstream fin(filepath);
            if (!fin) {
                cout << "vs_error: file cannot open." << endl;
            }
            vs_error = false;
            string str;
            while (getline(fin, str)) {
                if (fin.good() == false && fin.fail() == false) {
                    vs_error = true;
                    break;
                }
            }
            fin.close();
        }
    }
}

void base_state_display(int& unsubmitted_count, int& right_count,
                        int& pdf_error_count, int& gb_error_count,
                        int& vs_error_count, bool is_submitted, bool is_utf8,
                        bool pdf_format_error, bool vs_error,
                        const string& display) 
{
    if (!is_submitted) {
        unsubmitted_count++;
        if (display[1] == '1') {
            cout << "未提交" << endl;
        }
    } 
    else {
        if (is_utf8) {
            gb_error_count++;
            if (display[2] == '1') {
                cout << "源文件格式不正确(非GB编码)" << endl;
            }
        }
        if (pdf_format_error) {
            pdf_error_count++;
            if (display[3] == '1') {
                cout << "PDF文件格式不正确" << endl;
            }
        }
        if (vs_error) {
            vs_error_count++;
            cout << "源文件格式不正确(VS无法识别)" << endl;
        }
    }
    if (is_submitted && !is_utf8 && !pdf_format_error && !vs_error) {
        right_count++;
        if (display[0] == '1') {
            cout << "正确" << endl;
        }
    }
}

void base_detail_info_display(int unsubmitted_count, int right_count,
                              int pdf_error_count, int gb_error_count,
                              int vs_error_count, int stu_count) 
{
    int length = 0;  //=线的长度
    if (vs_error_count != 0)
        length = 40;
    else if (gb_error_count != 0)
        length = 38;
    else if (pdf_error_count != 0)
        length = 29;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    if (stu_count == right_count)  // 全部正确
        cout << "全部";
    else
        cout << "检查";

    cout << setfill('=');
    cout << "通过" << right_count << "/" << stu_count << "个学生，本次通过" << right_count << "个" << endl;
    cout << setw(length) << '=' << endl;
    cout << "详细信息" << endl;
    cout << setw(length) << '=' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (pdf_error_count != 0)
        cout << setw(length - 7) << "PDF文件格式不正确 : " << pdf_error_count << endl;
    if (vs_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7)<< "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    cout << setfill('=') << setw(length) << '=' << endl;

    cout << setfill(' ');
}

void base_stu_detail_info_display(int& unsubmitted_count, int& right_count,
                                  int& pdf_error_count, int& gb_error_count,
                                  int& vs_error_count, int file_count) 
{
    int length = 0;  //-线的长度
    if (vs_error_count != 0)
        length = 40;
    else if (gb_error_count != 0)
        length = 38;
    else if (pdf_error_count != 0)
        length = 29;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    if (file_count == right_count)  // 全部正确
        cout << "全部";
    else
        cout << "检查";

    cout << setfill('-');
    cout << "通过" << right_count << "/" << file_count << "个文件，本次通过"<< right_count << "个" << endl;
    cout << setw(length) << '-' << endl;
    cout << "学生详细信息" << endl;
    cout << setw(length) << '-' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (pdf_error_count != 0)
        cout << setw(length - 7) << "PDF文件格式不正确 : " << pdf_error_count << endl;
    if (vs_error_count != 0)
        cout << setw(length - 7)<< "源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7)<< "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    cout << setfill('-') << setw(length) << '-' << endl;

    cout << setfill(' ');
}

void base_total_detail_info_display(int& unsubmitted_count, int& right_count,
                                    int& pdf_error_count, int& gb_error_count,
                                    int vs_error_count, int stu_count,
                                    int file_count) 
{
    int length = 0;  //=线的长度
    if (vs_error_count != 0)
        length = 40;
    else if (gb_error_count != 0)
        length = 38;
    else if (pdf_error_count != 0)
        length = 29;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    cout << setfill('=');
    cout << "共完成" << stu_count << "个学生的检查，文件总数:" << stu_count * file_count << "，通过总数:" << right_count << "，本次通过" << right_count << "个"<< endl;
    cout << setw(length) << '=' << endl;
    cout << "整体详细信息" << endl;
    cout << setw(length) << '=' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (pdf_error_count != 0)
        cout << setw(length - 7) << "PDF文件格式不正确 : " << pdf_error_count << endl;
    if (vs_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    cout << setfill('=') << setw(length) << '=' << endl;

    cout << setfill(' ');
}

void firstline_check_file(bool& is_submitted, bool& is_utf8, bool& is_anno,
                          bool& anno_format, bool& is_three, bool& error,
                          bool& vs_error, bool& no_error, bool& name_error,
                          bool& major_error, string& stu_no, string& stu_name,
                          string& stu_fmajor, string& stu_smajor,
                          const string& cno, const string& file_name,
                          string& src_rootdir) 
{
    // 是否提交文件
    is_submitted = find_file(cno, stu_no, file_name, src_rootdir);
    // 是否utf-8编码
    if (is_submitted) {
        is_utf8 = check_utf8(cno, stu_no, file_name, src_rootdir);
    }
    // 是否是注释行,以及注释格式是否正确
    if (!is_utf8) {
        string anno;
        is_anno = check_anno(anno_format, file_name, src_rootdir, stu_no, cno, 1, anno);
    }
    // 是否是三项
    if (is_anno) {  // 注释行才检查三项
        is_three = check_three(file_name, src_rootdir, stu_no, cno);
    }
    // 是否有错误(姓名、学号、专业任一项错误)
    if (is_three) {
        error = check_error(stu_no, stu_name, stu_fmajor, stu_smajor, src_rootdir, cno, file_name, no_error, name_error, major_error);
    }
    // vs能否识别
    if (is_submitted) {
        string filepath = src_rootdir + "/" + cno + "-" + stu_no + "/" + file_name;
        ifstream fin(filepath);
        if (!fin) {
            cout << "vs_error: file cannot open." << endl;
        }
        vs_error = false;
        if (fin.good() == false && fin.fail() == false) {
            vs_error = true;
        }
        fin.close();
    }
}

void first_state_display(
    int& unsubmitted_count, int& right_count, int& gb_error_count,
    int& isnt_anno_count, int& isnt_three_count, int& anno_format_error_count,
    int& anno_error_count, int& vs_error_count, bool is_submitted, bool is_utf8,
    bool is_anno, bool anno_format, bool is_three, bool error, bool vs_error,
    bool no_error, bool name_error, bool major_error, string& src_rootdir,
    const string& cno, string& stu_no, const string& file_name) 
{
    if (!is_submitted) {
        unsubmitted_count++;
        cout << "未提交" << endl;
        return;
    }
    if (is_utf8) {
        gb_error_count++;
        cout << "源文件格式不正确(非GB编码)" << endl;
        return;
    }
    if (vs_error) {
        vs_error_count++;
        cout << "源文件格式不正确(VS无法识别)" << endl;
        return;
    }

    string file_path = src_rootdir + "/" + cno + "-" + stu_no + "/" + file_name;
    ifstream fin(file_path);
    if (!fin) {
        cout << "first_state_display: file cannot open." << endl;
        return;
    }
    string str = "";
    while (str == "") getline(fin, str);
    fin.close();
    // 去除左右空格
    str.erase(0, str.find_first_not_of(" "));
    str.erase(str.find_last_not_of(" ") + 1);

    if (!anno_format) {
        cout << "首行多行注释格式不正确";
        cout << ' ' << '[' << str << ']' << endl;
        anno_format_error_count++;
        return;
    }
    if (!is_anno) {
        isnt_anno_count++;
        cout << "首行不是注释行";
        cout << ' ' << '[' << str << ']' << endl;
        return;
    }
    if (!is_three) {
        isnt_three_count++;
        cout << "首行不是三项";
        cout << ' ' << '[' << str << ']' << endl;
        return;
    }
    if (error) {
        anno_error_count++;
        cout << "首行";
        if (no_error) {
            cout << "学号不匹配";
        }
        if (name_error) {
            cout << "姓名不匹配";
        }
        if (major_error) {
            cout << "班级不匹配";
        }
        cout << ' ' << '[' << str << ']' << endl;
        return;
    }
    right_count++;
    cout << "正确" << endl;
    return;
}

void firstline_detail_info_display(int unsubmitted_count, int right_count,
                                   int gb_error_count, int isnt_anno_count,
                                   int isnt_three_count,
                                   int anno_format_error_count,
                                   int anno_error_count, int vs_error_count,
                                   int stu_count) 
{
    int length = 0;  //=线的长度
    if (vs_error_count != 0)
        length = 40;
    else if (gb_error_count != 0)
        length = 38;
    else if (anno_format_error_count != 0)
        length = 34;
    else if (isnt_anno_count != 0)
        length = 26;
    else if (isnt_three_count != 0 || anno_error_count != 0)
        length = 24;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    if (stu_count == right_count)  // 全部正确
        cout << "全部";
    else
        cout << "检查";
    cout << setfill('=');
    cout << "通过" << right_count << "/" << stu_count << "个学生，本次通过" << right_count << "个" << endl;
    cout << setw(length) << '=' << endl;
    cout << "详细信息" << endl;
    cout << setw(length) << '=' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    if (vs_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
    if (anno_format_error_count != 0)
        cout << setw(length - 7) << "首行多行注释格式不正确 : " << anno_format_error_count << endl;
    if (isnt_anno_count != 0)
        cout << setw(length - 7) << "首行不是注释行 : " << isnt_anno_count << endl;
    if (isnt_three_count != 0)
        cout << setw(length - 7) << "首行不是三项 : " << isnt_three_count << endl;
    if (anno_error_count != 0)
        cout << setw(length - 7) << "首行检查出错 : " << anno_error_count<< endl;

    cout << setfill('=') << setw(length) << '=' << endl;
    cout << setfill(' ');  // 恢复默认值
}

void firstline_total_detail_info_display(
    int& unsubmitted_count, int& right_count, int& gb_error_count,
    int& isnt_anno_count, int& isnt_three_count, int& anno_format_error_count,
    int& anno_error_count, int& vs_error_count, int& stu_count,
    int& file_count) 
{
    int length = 0;  //=线的长度
    if (vs_error_count != 0)
        length = 40;
    else if (gb_error_count != 0)
        length = 38;
    else if (anno_format_error_count != 0)
        length = 34;
    else if (isnt_anno_count != 0)
        length = 26;
    else if (isnt_three_count != 0 || anno_error_count != 0)
        length = 24;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    cout << setfill('=');
    cout << "共完成" << stu_count << "个学生的检查，文件总数:" << stu_count * file_count<< "，通过总数:" << right_count << "，本次通过" << right_count << "个"<< endl;
    cout << setw(length) << '=' << endl;
    cout << "整体详细信息" << endl;
    cout << setw(length) << '=' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    if (vs_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
    if (anno_format_error_count != 0)
        cout << setw(length - 7) << "首行多行注释格式不正确 : " << anno_format_error_count << endl;
    if (isnt_anno_count != 0)
        cout << setw(length - 7) << "首行不是注释行 : " << isnt_anno_count << endl;
    if (isnt_three_count != 0)
        cout << setw(length - 7) << "首行不是三项 : " << isnt_three_count << endl;
    if (anno_error_count != 0)
        cout << setw(length - 7) << "首行检查出错 : " << anno_error_count << endl;

    cout << setfill('=') << setw(length) << '=' << endl;
    cout << setfill(' ');  // 恢复默认值
}

void firstline_stu_detail_info_display(int& unsubmitted_count, int&
right_count, int& gb_error_count, int& isnt_anno_count, int&
isnt_three_count, int& anno_format_error_count, int& anno_error_count, int&
vs_error_count, int& file_count)
{
	int length = 0;  //-线的长度
	if(vs_error_count != 0)
		length = 40;
	else if (gb_error_count != 0)
		length = 38;
	else if (anno_format_error_count != 0)
		length = 34;
	else if (isnt_anno_count != 0)
		length = 26;
	else if (isnt_three_count != 0 || anno_error_count != 0)
		length = 24;
	else if (unsubmitted_count != 0)
		length = 18;
	else if (right_count != 0)
		length = 16;
	else
		length = 12;

	if (file_count == right_count) //全部正确
		cout << "全部";
	else
		cout << "检查";
	cout << setfill('-');
	cout << "通过" << right_count << "/" << file_count << "个文件，本次通过" <<right_count << "个" << endl; 	
    cout << setw(length) << '-' << endl; 	cout <<"学生详细信息" << endl; 	cout << setw(length) << '-' << endl; 	
    cout <<setfill(' '); 	
    cout << setiosflags(ios::right); 	if (right_count != 0) 		
        cout <<setw(length - 7) << "正确 : " << right_count << endl; 	
    if (unsubmitted_count!= 0) 		
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
	if(gb_error_count != 0)
		cout << setw(length - 7) << "源文件格式不正确(非GB编码) : " <<gb_error_count << endl; 	
    if(vs_error_count != 0) 		
        cout << setw(length - 7) <<"源文件格式不正确(VS无法识别) : " << vs_error_count << endl;
	if(anno_format_error_count != 0)
		cout << setw(length - 7) << "首行多行注释格式不正确 : " <<anno_format_error_count << endl; 	
    if(isnt_anno_count != 0) 		
        cout << setw(length- 7) << "首行不是注释行 : " << isnt_anno_count << endl; 	
    if(isnt_three_count!= 0 ) 		
        cout << setw(length - 7) << "首行不是三项 : " << isnt_three_count <<endl; 	
    if(anno_error_count != 0) 		
        cout << setw(length - 7) << "首行检查出错 : "<< anno_error_count << endl;

	cout << setfill('-') << setw(length) << '-' << endl;
	cout << setfill(' ');  //恢复默认值
}

void secondline_check_and_state_file(bool& is_submitted, bool& is_utf8, bool&is_anno, MYSQL_ROW& row,const string& file_name, string&src_rootdir,vector<vector<string>>& other_no,vector<vector<string>>&other_name, int& right_count, int& unsubmitted_count, int&gb_error_count,int&  isnt_anno_count)
{
	int no_size = other_no.size(), name_size = other_name.size();
	other_no.push_back(vector<string>());  //增加一项
	other_name.push_back(vector<string>());   //增加一项

	is_submitted = find_file(string(row[7]), string(row[2]), file_name,src_rootdir); 	
    if (!is_submitted) { 		
        cout << "未提交" << endl;
		unsubmitted_count++;
		return;
	}
	else {
		is_utf8 = check_utf8(string(row[7]), string(row[2]), file_name,src_rootdir); 		
        if (is_utf8) { 			
            cout << "源文件格式不正确(非GB编码)" << endl;
			gb_error_count++;
			return;
		}

		bool tmp;
		string anno;
		is_anno = check_anno(tmp, file_name, src_rootdir, string(row[2]),string(row[7]),2,anno); 		
        if (!is_anno) { 			
            cout << "次行不是注释"<< endl;
			isnt_anno_count++;
			return;
		}

		right_count++;  //接下来都算正确数量
		int count = 0;
		string stu_no, stu_name;
		stringstream ss_anno(anno);
		if (anno.empty()) {
			cout<< "正确"<< endl;
			return;
		}
		while (1) {
			ss_anno >> stu_no;
			if(ss_anno.fail())
				break;
            ss_anno >> stu_name;
            if (ss_anno.fail()) {   // 只有学号没有名字
                cout << "第[" << count << "]个学生后面的信息不全(只读到一项)，后续内容忽略" << endl;
                return;
            }
			if (stu_no.length() != 7) {
				cout<<"第"<<count+1<<"位同学的学号["<<stu_no<<"]不是7位，后续内容忽略"<< endl; 				
                return;
			}
			if (stu_no == string(row[2]) && stu_name == string(row[3])) {
				cout<<"第["<<count+1 <<"]项写了自己，后续内容忽略"<< endl;
				return;
			}
			other_no[no_size].push_back(stu_no);
			other_name[name_size].push_back(stu_name);
			count++;
		}
		cout << "正确"<< endl;
		return;
	}
}

void secondline_detail_info_display(int right_count, int unsubmitted_count, int gb_error_count, int isnt_anno_count, int stu_count) 
{
    int length = 0;  //=线的长度
    if (gb_error_count != 0)
        length = 38;
    else if (isnt_anno_count != 0)
        length = 24;
    else if (unsubmitted_count != 0)
        length = 18;
    else if (right_count != 0)
        length = 16;
    else
        length = 12;

    if (stu_count == right_count)  // 全部正确
        cout << "全部";
    else
        cout << "检查";
    cout << setfill('=');
    cout << "通过" << right_count << "/" << stu_count << "个学生，本次通过" << right_count << "个" << endl;
    cout << setw(length) << '=' << endl;
    cout << "详细信息" << endl;
    cout << setw(length) << '=' << endl;
    cout << setfill(' ');
    cout << setiosflags(ios::right);
    if (right_count != 0)
        cout << setw(length - 7) << "正确 : " << right_count << endl;
    if (unsubmitted_count != 0)
        cout << setw(length - 7) << "未提交 : " << unsubmitted_count << endl;
    if (gb_error_count != 0)
        cout << setw(length - 7) << "源文件格式不正确(非GB编码) : " << gb_error_count << endl;
    if (isnt_anno_count != 0)
        cout << setw(length - 7) << "次行不是注释 : " << isnt_anno_count << endl;

    cout << setfill('=') << setw(length) << '=' << endl;
    cout << setfill(' ');  // 恢复默认值
}