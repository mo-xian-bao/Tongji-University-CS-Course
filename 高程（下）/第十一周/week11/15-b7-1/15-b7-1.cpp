/* 计拔 2351520 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <fstream>
#include <iomanip>
#include <cstring>

#if defined(_MSC_VER)
#include <conio.h>
#endif
//根据需要可加入其它头文件
using namespace std;

//此处为示例，允许修改结构体名称，允许修改结构体中的成员内容，要求sizeof必须是64
#pragma pack(1)
struct shuxing {
    char nicheng[16];
    short shengming;
    short liliang;
    short tizhi;
    short lingqiao;
    int jinqian;
    int mingshen;
    int meili;
    long long leijishijian;
    char yidongsudu;
    char gongjisudu;
    char gongjifanwei;
    char yuliu;
    short gonglili;
    short fangyuli;
    char mingjie;
    char zhili;
    char jingyan;
    char dengji;
    short mofazhi;
    char once_mofazhi;
    char mofashanghai;
    char mingzhonglv;
    char mokang;
    char baojilv;
    char naili;
};
#pragma pack()

/* 此处允许新增函数，数量不限
   1、所有新增的函数，均不允许定义新的 fstream / ifstream / ofstream 流对象，并进行打开/读/写/关闭等操作
   2、所有新增的函数，均不允许用C方式进行文件处理
   3、上述两个限制同样适用于main函数
*/
void print_shuxing(long long x,const char* a, long long min_x, long long max_x)
{
    char str[100];
    if (x < min_x || x > max_x) {
        sprintf(str, "非法的%s：", a);
    }
    else {
        sprintf(str, "%s：", a);
    }
    cout << setw(20) << str << x << endl;
}

void print_xiugai(shuxing& shuxing)
{
    cout << "--------------------------------------" << endl;
    cout << "  游戏存档文件修改工具" << endl;
    cout << "--------------------------------------" << endl;
    cout<<"  a.玩家昵称    ("<< shuxing.nicheng << ")" << endl;
    cout<<"  b.生命        ("<<shuxing.shengming<<")"<<endl;
    cout<<"  c.力量        ("<<shuxing.liliang<<")"<<endl;
    cout<<"  d.体质        ("<<shuxing.tizhi<<")"<<endl;
    cout<<"  e.灵巧        ("<<shuxing.lingqiao<<")"<<endl;
    cout<<"  f.金钱        ("<<shuxing.jinqian<<")"<<endl;
    cout<<"  g.名声        ("<<shuxing.mingshen<<")"<<endl;
    cout<<"  h.魅力        ("<<shuxing.meili<<")"<<endl;
    cout<<"  i.游戏累计时间("<<shuxing.leijishijian<<")"<<endl;
    cout<<"  j.移动速度    ("<< (int)shuxing.yidongsudu<<")"<<endl;
    cout<<"  k.攻击速度    ("<< (int)shuxing.gongjisudu<<")"<<endl;
    cout<<"  l.攻击范围    ("<< (int)shuxing.gongjifanwei<<")"<<endl;
    cout<<"  m.攻击力      ("<<shuxing.gonglili<<")"<<endl;
    cout<<"  n.防御力      ("<<shuxing.fangyuli<<")"<<endl;
    cout<<"  o.敏捷度      ("<< (int)shuxing.mingjie<<")"<<endl;
    cout<<"  p.智力        ("<< (int)shuxing.zhili<<")"<<endl;
    cout<<"  q.经验        ("<< (int)shuxing.jingyan<<")"<<endl;
    cout<<"  r.等级        ("<< (int)shuxing.dengji<<")"<<endl;
    cout<<"  s.魔法值      ("<<shuxing.mofazhi<<")"<<endl;
    cout<<"  t.消耗魔法值  ("<< (int)shuxing.once_mofazhi<<")"<<endl;
    cout<<"  u.魔法伤害力  ("<< (int)shuxing.mofashanghai<<")"<<endl;
    cout<<"  v.魔法命中率  ("<< (int)shuxing.mingzhonglv<<")"<<endl;
    cout<<"  w.魔法防御力  ("<< (int)shuxing.mokang<<")"<<endl;
    cout<<"  x.暴击率      ("<< (int)shuxing.baojilv<<")"<<endl;
    cout<<"  y.耐力        ("<< (int)shuxing.naili<<")"<<endl;
    cout << "--------------------------------------" << endl;
    cout << "  0.放弃修改" << endl;
    cout << "  1.存盘退出" << endl;
    cout << "--------------------------------------" << endl;
}


/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：整个函数，只允许出现一次open、一次read（因为包含错误处理，允许多次close）
***************************************************************************/
int read()
{
    /* 本函数中只允许定义一个 ifstream流对象，不再允许定义任何形式的fstream/ifstream/ofstream流对象，也不允许使用C方式的文件处理 */
    ifstream gfile;

    /* 文件打开，具体要求为：
       1、要求以读方式打开，打开方式***自行指定
       2、除本次open外，本函数其它地方不允许再出现open  */
    gfile.open("game.dat", ios::in|ios::binary);

    /* 进行后续操作，包括错误处理、读文件、显示各游戏项的值、关闭文件等，允许调用函数
       其中：只允许用一次性读取64字节的方法将game.dat的内容读入***（缓冲区名称、结构体名称自行指定）
                 gfile.read(***, sizeof(demo));
    */
    
    gfile.seekg(0, ios::end);
    int filesize = (int)gfile.tellg();
    gfile.seekg(0, ios::beg);

    if (filesize != 64) {
        cout << "文件game.dat的字节大小不正确" << endl;
        return -1;
    }

    shuxing shuxing;
    gfile.read((char*)(&shuxing), sizeof(shuxing));

    if (strlen(shuxing.nicheng) > 15 || strlen(shuxing.nicheng) < 1) {
        cout<<setw(20)<<"非法的玩家昵称"<<endl;
        return -1;
    }
    
    cout<<setw(20)<<"玩家昵称："<<shuxing.nicheng << endl;
    print_shuxing(shuxing.shengming, "生命值", 0, 10000);
    print_shuxing(shuxing.liliang, "力量值", 0, 10000);
    print_shuxing(shuxing.tizhi, "体质值", 0, 8192);
    print_shuxing(shuxing.lingqiao, "灵巧值", 0, 1024);
    print_shuxing(shuxing.jinqian, "金钱值", 0, 100000000);
    print_shuxing(shuxing.mingshen, "名声值", 0, 1000000);
    print_shuxing(shuxing.meili, "魅力值", 0, 1000000);
    print_shuxing(shuxing.leijishijian, "游戏累计时间(us)值", 0, 10000000000000000);
    print_shuxing(shuxing.yidongsudu, "移动速度值", 0, 100);
    print_shuxing(shuxing.gongjisudu, "攻击速度值", 0, 100);
    print_shuxing(shuxing.gongjifanwei, "攻击范围值", 0, 100);
    print_shuxing(shuxing.gonglili, "攻击力值", 0, 2000);
    print_shuxing(shuxing.fangyuli, "防御力值", 0, 2000);
    print_shuxing(shuxing.mingjie, "敏捷度值", 0, 100);
    print_shuxing(shuxing.zhili, "智力值", 0, 100);
    print_shuxing(shuxing.jingyan, "经验值", 0, 100);
    print_shuxing(shuxing.dengji, "等级值", 0, 100);
    print_shuxing(shuxing.mofazhi, "魔法值", 0, 10000);
    print_shuxing(shuxing.once_mofazhi, "消耗魔法值", 0, 100);
    print_shuxing(shuxing.mofashanghai, "魔法伤害力值", 0, 100);
    print_shuxing(shuxing.mingzhonglv, "命中率值", 0, 100);
    print_shuxing(shuxing.mokang, "魔法防御力值", 0, 100);
    print_shuxing(shuxing.baojilv, "暴击率值", 0, 100);
    print_shuxing(shuxing.naili, "耐力值", 0, 100);

    /* 关闭文件 */
    gfile.close();

    return 0;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：整个函数，只允许出现一次open、一次read、一次write（因为包含错误处理，允许多次close）
***************************************************************************/
int modify()
{
    /* 本函数中只允许定义一个 fstream流对象，不再允许定义任何形式的fstream/ifstream/ofstream流对象，也不允许使用C方式的文件处理 */
    fstream gfile;

    /* 文件打开，具体要求为：
       1、要求以读写方式打开，打开方式***自行指定
       2、除本次open外，本函数其它地方不允许再出现open  */
    gfile.open("game.dat", ios::in|ios::out|ios::binary);

    /* 进行后续操作，包括错误处理、读文件、显示各游戏项的值、关闭文件等，允许调用函数
       其中：只允许用一次性读取64字节的方法将game.dat的内容读入***（缓冲区名称、结构体名称自行指定）
                 gfile.read(***, sizeof(demo));
             只允许用一次性写入64字节的方法将***的内容写入game.dat中（缓冲区名称、结构体名称自行指定）
                 gfile.write(***, sizeof(demo));
    */

    gfile.seekg(0, ios::end);
    int filesize = (int)gfile.tellg();
    gfile.seekg(0, ios::beg);

    if (filesize != 64) {
        cout << "文件game.dat的字节大小不正确" << endl;
        return -1;
    }

    shuxing shuxing;
    gfile.read((char*)(&shuxing), sizeof(shuxing));

    while (true) {
        print_xiugai(shuxing);
        cout << "请选择[a..y, 0..1] ";
        char ch;
#if defined(_MSC_VER)
        ch = _getche();
#else
        ch = getchar(); 
        while (getchar() != '\n')
            ;
#endif
        
        cout << endl;
        cout << endl;
        switch (ch) {
        case '0':
            gfile.close();
            return 0;
        case '1':
            gfile.seekp(0, ios::beg);
            gfile.write((char*)(&shuxing), sizeof(shuxing));
            gfile.close();
            return 0;
        case 'a':
            char c[100];
            char name[16];
            cout << "玩家昵称，当前值=";
            cout << shuxing.nicheng;
            cout << "，请输入 :";
            cin >> c;
            while (getchar() != '\n')
                ;
            strncpy(name, c, 15);
            name[15] = '\0';
            strcpy(shuxing.nicheng, name); 
            break;
        case 'b':
            while (true) {
                cout << "生命，当前值=";
                cout << shuxing.shengming;
                cout << "，范围[0..10000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 10000) {
                    cout << "非法的生命值：" << x << endl;
                    continue;
                }
                shuxing.shengming = x;
                break;
            }
            break;
        case 'c':
            while (true) {
                cout << "力量，当前值=";
                cout << shuxing.liliang;
                cout << "，范围[0..10000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 10000) {
                    cout << "非法的力量值：" << x << endl;
                    continue;
                }
                shuxing.liliang = x;
                break;
            }
            break;
        case 'd':
            while (true) {
                cout << "体质，当前值=";
                cout << shuxing.tizhi;
                cout << "，范围[0..8192]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 8192) {
                    cout << "非法的体质值：" << x << endl;
                    continue;
                }
                shuxing.tizhi = x;
                break;
            }
            break;
        case 'e':
            while (true) {
                cout << "灵巧，当前值=";
                cout << shuxing.lingqiao;
                cout << "，范围[0..1024]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 1024) {
                    cout << "非法的灵巧值：" << x << endl;
                    continue;
                }
                shuxing.lingqiao = x;
                break;
            }
            break;
        case 'f':
            while (true) {
                cout << "金钱，当前值=";
                cout << shuxing.jinqian;
                cout << "，范围[0..100000000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100000000) {
                    cout << "非法的金钱值：" << x << endl;
                    continue;
                }
                shuxing.jinqian = x;
                break;
            }
            break;
        case 'g':
            while (true) {
                cout << "名声，当前值=";
                cout << shuxing.mingshen;
                cout << "，范围[0..1000000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 1000000) {
                    cout << "非法的名声值：" << x << endl;
                    continue;
                }
                shuxing.mingshen = x;
                break;
            }
            break;
        case 'h':
            while (true) {
                cout << "魅力，当前值=";
                cout << shuxing.meili;
                cout << "，范围[0..1000000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 1000000) {
                    cout << "非法的魅力值：" << x << endl;
                    continue;
                }
                shuxing.meili = x;
                break;
            }
            break;
        case 'i':
            while (true) {
                cout << "游戏累计时间(us)，当前值=";
                cout << shuxing.leijishijian;
                cout << "，范围[0..10000000000000000]，请输入 :";
                long long x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的游戏累计时间(us)值：" << x << endl;
                    continue;
                }
                shuxing.leijishijian = x;
                break;
            }
            break;
        case 'j':
            while (true) {
                cout << "移动速度，当前值=";
                cout << shuxing.yidongsudu;
                cout << "，范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的移动速度值：" << x << endl;
                    continue;
                }
                shuxing.yidongsudu = x;
                break;
            }
            break;
        case 'k':
            while (true) {
                cout << "攻击速度，当前值=";
                cout << shuxing.gongjisudu;
                cout << "，范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的攻击速度值：" << x << endl;
                    continue;
                }
                shuxing.gongjisudu = x;
                break;
            }
            break;
        case 'l':
            while (true) {
                cout << "攻击范围，当前值=";
                cout << shuxing.gongjifanwei;
                cout << "，范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的攻击范围值：" << x << endl;
                    continue;
                }
                shuxing.gongjifanwei = x;
                break;
            }
            break;
        case'm':
            while (true) {
                cout << "攻击力，当前值=";
                cout << shuxing.gonglili;
                cout << "，范围[0..2000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 2000) {
                    cout << "非法的攻击力值：" << x << endl;
                    continue;
                }
                shuxing.gonglili = x;
                break;
            }
            break;
        case 'n':
            while (true) {
                cout << "防御力，当前值=";
                cout << shuxing.fangyuli;
                cout << "，范围[0..2000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 2000) {
                    cout << "非法的防御力值：" << x << endl;
                    continue;
                }
                shuxing.fangyuli = x;
                break;
            }
            break;
        case 'o':
            while (true) {
                cout << "敏捷度，当前值=";
                cout << shuxing.mingjie;
                cout << "，范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的敏捷度值：" << x << endl;
                    continue;
                }
                shuxing.mingjie = x;
                break;
            }
            break;
        case 'p':
            while (true) {
                cout << "智力，当前值=" << shuxing.zhili << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的智力值：" << x << endl;
                    continue;
                }
                shuxing.zhili = x;
                break;
            }
            break;
        case 'q':
            while (true) {
                cout << "经验，当前值=" << shuxing.jingyan << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的经验值：" << x << endl;
                    continue;
                }
                shuxing.jingyan = x;
                break;
            }
            break;
        case 'r':
            while (true) {
                cout << "等级，当前值=" << shuxing.dengji << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的等级值：" << x << endl;
                    continue;
                }
                shuxing.dengji = x;
                break;
            }
            break;
        case 's':
            while (true) {
                cout << "魔法，当前值=" << shuxing.mofazhi << ",范围[0..10000]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 10000) {
                    cout << "非法的魔法值：" << x << endl;
                    continue;
                }
                shuxing.mofazhi = x;
                break;
            }
            break;
        case 't':
            while (true) {
                cout << "消耗魔法，当前值=" << shuxing.once_mofazhi << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的消耗魔法值：" << x << endl;
                    continue;
                }
                shuxing.once_mofazhi = x;
                break;
            }
            break;
        case 'u':
            while (true) {
                cout << "魔法伤害力，当前值=" << shuxing.mofashanghai << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的魔法伤害力值：" << x << endl;
                    continue;
                }
                shuxing.mofashanghai = x;
                break;
            }
            break;
        case 'v':
            while (true) {
                cout << "命中率，当前值=" << shuxing.mingzhonglv << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的命中率值：" << x << endl;
                    continue;
                }
                shuxing.mingzhonglv = x;
                break;
            }
            break;
        case 'w':
            while (true) {
                cout << "魔法防御力，当前值=" << shuxing.mokang << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的魔法防御力：" << x << endl;
                    continue;
                }
                shuxing.mokang = x;
                break;
            }
            break;
        case 'x':
            while (true) {
                cout << "暴击率，当前值=" << shuxing.baojilv << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的暴击率值：" << x << endl;
                    continue;
                }
                shuxing.baojilv = x;
                break;
            }
            break;
        case 'y':
            while (true) {
                cout << "耐力，当前值=" << shuxing.naili << ",范围[0..100]，请输入 :";
                int x;
                cin >> x;
                while (getchar() != '\n')
                    ;
                if (cin.fail()) {
                    cin.clear();
                    continue;
                }
                if (x < 0 || x > 100) {
                    cout << "非法的暴击伤害力值：" << x << endl;
                    continue;
                }
                shuxing.naili = x;
                break;
            }
            break;
        default:
            break;
        }
    }
    gfile.close();
    return 0;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：main函数允许带参数，不允许进行文件读写
***************************************************************************/
int main(int argc, char** argv)
{
    if (argc == 1) {
        cout << "usage :" << argv[0] << " --modify | --read" << endl;
    }
    else {
        if (strcmp(argv[1], "--modify") == 0) {
            return modify();
        }
        else if (strcmp(argv[1], "--read") == 0) {
            return read();
        }
    }
    return 0;
}
