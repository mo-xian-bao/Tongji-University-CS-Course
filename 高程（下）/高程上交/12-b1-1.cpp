/* 2351520 计拔 毛星博 */
#include <iostream>
#include <iomanip>
using namespace std;

#define STUDENT_NUM	4
#define SCORE_NUM	5

/* --- 不允许定义任何形式的全局变量 --- */

/***************************************************************************
  函数名称：
  功    能：求第一门课的平均分
  输入参数：
  返 回 值：
  说    明：相关输出都放在函数中即可
***************************************************************************/
void average(int (*score)[SCORE_NUM])
{
    /* 函数定义语句部分：
       1、本函数中仅允许定义 1个简单变量 + 1个指针变量 */
    double avg_score = 0;
    int(*p)[SCORE_NUM];

       /* 函数执行语句部分：
          1、不允许再定义任何类型的变量，包括 for (int i=0;...）等形式定义变量
          2、循环变量必须是指针变量，后续语句中不允许出现[]形式访问数组
             不允许：int a[10], i;
                     for(i=0; i<10; i++)
                         cout << a[i];
             允许  ：int a[10], p;
                     for(p=a; p<a+10; p++)
                         cout << *p;          */

    for (p = score; p < score + STUDENT_NUM; p++ ) {
        avg_score += *p[0];
    }
    avg_score /= STUDENT_NUM;

    cout << "第1门课平均分：" << avg_score << endl;
    cout << endl;
}

/***************************************************************************
  函数名称：
  功    能：找出有两门以上课程不及格的学生
  输入参数：
  返 回 值：
  说    明：相关输出都放在函数中即可
***************************************************************************/
void fail(int (*score)[SCORE_NUM])
{
    /* 函数定义语句部分：
       1、本函数中仅允许定义 2个简单变量 + 1个行指针变量 + 1个简单指针变量 */
    int fail_num;
    double avg_score;
    int (*q)[SCORE_NUM];
    int* p;

       /* 函数执行语句部分（要求同average）*/
    cout << "2门以上不及格的学生：" << endl;
    for (q = score; q < score + STUDENT_NUM; q++) {
        avg_score = 0;
        fail_num = 0;
        for (p = *q; p < *q + SCORE_NUM; p++) {
            if (*p < 60) {
                fail_num++;
            }
            avg_score += *p;
        }
        avg_score /= SCORE_NUM;
        if (fail_num >= 2) {
            cout << "No：" << q - score + 1 << " ";
            for (p = *q; p < *q + SCORE_NUM; p++) {
                cout << setw(3) <<left << *p;
            }
            cout << "平均：" << avg_score << endl;
        }
    }
    cout << endl;
}

/***************************************************************************
  函数名称：
  功    能：找出平均成绩在90分以上或全部成绩在85分以上的学生
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void good(int (*score)[SCORE_NUM])
{
    /* 函数定义语句部分：
       1、本函数中仅允许定义 2个简单变量 + 1个行指针变量 + 1个简单指针变量 */
    int good_num;
    double avg_score = 0;
    int (*q)[SCORE_NUM];
    int* p;

       /* 函数执行语句部分（要求同average）*/
    cout << "平均90以上或全部85以上的学生：" << endl;
    for (q = score; q < score + STUDENT_NUM; q++) {
        good_num = 0;
        avg_score = 0;
        for (p = *q; p < *q + SCORE_NUM; p++) {
            avg_score += *p;
            if (*p >= 85){
                good_num++;
            }
        }
        avg_score /= SCORE_NUM;
        if (avg_score >= 90 || good_num == SCORE_NUM) {
            cout << "No：" << q - score + 1 << " ";
            for (p = *q; p < *q + SCORE_NUM; p++) {
                cout << setw(3) <<left << *p;
            }
            cout << "平均：" << avg_score << endl;
        }
    }
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
int main()
{
    int a[STUDENT_NUM][SCORE_NUM] = {
        {91, 81, 71, 61, 51},	//第1个学生的1-5门课的成绩
        {92, 82, 72, 32, 52},   //第2个学生的1-5门课的成绩
        {93, 83, 99, 80, 95},   //第3个学生的1-5门课的成绩
        {97, 85, 87, 91, 88} }; //第4个学生的1-5门课的成绩

    /* 除上面的预置数组外，本函数中仅允许定义 1个行指针变量 + 1个简单指针变量 */
    int (*p)[SCORE_NUM];
    int *q;

    /* 函数执行语句部分（要求同average）*/
    cout << "初始信息：" << endl;
    for (p = a; p < a + STUDENT_NUM; p++) {
        cout << "No." << p - a + 1 << "的1-5门课成绩：";
        for (q = *p; q < *p + SCORE_NUM; q++) {
            cout << setw(3) << left << *q;
        }
        cout << endl;
    }
    cout << endl;

    p = a;
    average(p);
    fail(p);
    good(p);

    return 0;
}