/* 计拔 2351520 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(_MSC_VER)
#include <conio.h>
#endif

//根据需要可加入其它头文件


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
   1、所有新增的函数，均不允许定义新的 FILE* 并进行打开/读/写/关闭等操作
   2、上述限制同样适用于main函数
*/

void print_shuxing(long long x, const char* a, long long min_x, long long max_x)
{
    char str[100];
    if (x < min_x || x > max_x) {
        sprintf(str, "非法的%s：", a);
    }
    else {
        sprintf(str, "%s：", a);
    }
    printf("%20s%lld\n", str, x);
}

void print_xiugai(struct shuxing shuxing)
{
    printf("--------------------------------------\n");
    printf("  游戏存档文件修改工具\n");
    printf("--------------------------------------\n");
    printf("  a.玩家昵称    (%s)\n", shuxing.nicheng);
    printf("  b.生命        (%d)\n", shuxing.shengming);
    printf("  c.力量        (%d)\n", shuxing.liliang);
    printf("  d.体质        (%d)\n", shuxing.tizhi);
    printf("  e.灵巧        (%d)\n", shuxing.lingqiao);
    printf("  f.金钱        (%d)\n", shuxing.jinqian);
    printf("  g.名声        (%d)\n", shuxing.mingshen);
    printf("  h.魅力        (%d)\n", shuxing.meili);
    printf("  i.游戏累计时间(%lld)\n", shuxing.leijishijian);
    printf("  j.移动速度    (%d)\n", shuxing.yidongsudu);
    printf("  k.攻击速度    (%d)\n", shuxing.gongjisudu);
    printf("  l.攻击范围    (%d)\n", shuxing.gongjifanwei);
    printf("  m.攻击力      (%d)\n", shuxing.gonglili);
    printf("  n.防御力      (%d)\n", shuxing.fangyuli);
    printf("  o.敏捷度      (%d)\n", shuxing.mingjie);
    printf("  p.智力        (%d)\n", shuxing.zhili);
    printf("  q.经验        (%d)\n", shuxing.jingyan);
    printf("  r.等级        (%d)\n", shuxing.dengji);
    printf("  s.魔法值      (%d)\n", shuxing.mofazhi);
    printf("  t.消耗魔法值  (%d)\n", shuxing.once_mofazhi);
    printf("  u.魔法伤害力  (%d)\n", shuxing.mofashanghai);
    printf("  v.魔法命中率  (%d)\n", shuxing.mingzhonglv);
    printf("  w.魔法防御力  (%d)\n", shuxing.mokang);
    printf("  x.暴击率      (%d)\n", shuxing.baojilv);
    printf("  y.耐力        (%d)\n", shuxing.naili);
    printf("--------------------------------------\n");
    printf("  0.放弃修改\n");
    printf("  1.存盘退出\n");
    printf("--------------------------------------\n");
}


/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：整个函数，只允许出现一次fopen、一次fread（因为包含错误处理，允许多次fclose）
***************************************************************************/
int read()
{
    /* 本函数中只允许定义一个 FILE* */
    FILE* fp;

    /* 文件打开，具体要求为：
       1、要求以读方式打开，打开方式***自行指定
       2、除本次fopen外，本函数其它地方不允许再出现fopen/freopen  */
    fp = fopen("game.dat", "rb");

    /* 进行后续操作，包括错误处理、读文件、显示各游戏项的值、关闭文件等，允许调用函数
       其中：只允许用一次性读取64字节的方法将game.dat的内容读入***（缓冲区名称、结构体名称自行指定）
                 fread(***, 1, sizeof(demo), fp);
    */
    if (!fp) {
        printf("无法打开文件 game.dat\n");
        return -1;
    }

    // 检查文件大小
    fseek(fp, 0, SEEK_END);
    int filesize = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if (filesize != 64) {
        printf("文件game.dat的字节大小不正确\n");
        fclose(fp);
        return -1;
    }

    struct shuxing shuxing;
    fread(&shuxing, sizeof(struct shuxing), 1, fp);

    if (strlen(shuxing.nicheng) > 15 || strlen(shuxing.nicheng) < 1) {
        printf("%20s\n", "非法的玩家昵称");
        fclose(fp);
        return -1;
    }

    printf("%20s%s\n", "玩家昵称：", shuxing.nicheng);
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

    fclose(fp);
    return 0;
}

void clear_input_buffer()
{
    int c;
    while ((c = getchar()) != '\n' && c != EOF) {
        ;
    }
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：整个函数，只允许出现一次open、一次read、一次write（因为包含错误处理，允许多次fclose）
***************************************************************************/
int modify()
{
    /* 本函数中只允许定义一个 FILE* */
    FILE* fp;

    /* 文件打开，具体要求为：
       1、要求以读写方式打开，打开方式***自行指定
       2、除本次fopen外，本函数其它地方不允许再出现fopen/freopen  */
    fp = fopen("game.dat", "rb+");

    /* 进行后续操作，包括错误处理、读文件、显示各游戏项的值、关闭文件等，允许调用函数
       其中：只允许用一次性读取64字节的方法将game.dat的内容读入***（缓冲区名称、结构体名称自行指定）
                 fread(***, 1, sizeof(demo), fp);
             只允许用一次性写入64字节的方法将***的内容写入game.dat中（缓冲区名称、结构体名称自行指定）
                 fwrite(***, 1, sizeof(demo), fp);
    */
    fseek(fp, 0, SEEK_END);
    long filesize = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if (filesize != 64) {
        printf("文件game.dat的字节大小不正确\n");
        fclose(fp);
        return -1;
    }

    struct shuxing shuxing;
    fread(&shuxing, sizeof(shuxing), 1, fp);

    while (1) {
        print_xiugai(shuxing);
        printf("请选择[a..y, 0..1] ");
        char ch;
#if defined(_MSC_VER)
        ch = _getche();
#else
        ch = getchar();
        clear_input_buffer();
#endif
        printf("\n\n");


        char c[100];
        char name[16];
        switch (ch) {
        case '0':
            fclose(fp);
            return 0;
        case '1':
            fseek(fp, 0, SEEK_SET);
            fwrite(&shuxing, sizeof(shuxing), 1, fp);
            fclose(fp);
            return 0;
        case 'a': 
            printf("玩家昵称，当前值=%s，请输入 :", shuxing.nicheng);
            scanf("%99s", c);
            strncpy(name, c, 15);
            name[15] = '\0';
            strcpy(shuxing.nicheng, name);
            clear_input_buffer();
            break;
        
        case 'b': 
            while (1) {
                printf("生命，当前值=%d，范围[0..10000]，请输入 :", shuxing.shengming);
                int x;
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 10000) {
                    printf("非法的生命值：%d\n", x);
                    continue;
                }
                shuxing.shengming = x;
                break;
            }
            break;
        case 'c':
            while (1) {
                int x;
                printf("力量，当前值=%d，范围[0..10000]，请输入 :", shuxing.liliang);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 10000) {
                    printf("非法的力量值：%d\n", x);
                    continue;
                }
                shuxing.liliang = x;
                break;
            }
            break;
        case 'd':
            while (1) {
                int x;
                printf("体质，当前值=%d，范围[0..8192]，请输入 :", shuxing.tizhi);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 8192) {
                    printf("非法的体质值：%d\n", x);
                    continue;
                }
                shuxing.tizhi = x;
                break;
            }
            break;
        case 'e':
            while (1) {
                int x;
                printf("灵巧，当前值=%d，范围[0..1024]，请输入 :", shuxing.lingqiao);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 1024) {
                    printf("非法的灵巧值：%d\n", x);
                    continue;
                }
                shuxing.lingqiao = x;
                break;
            }
            break;
        case 'f':
            while (1) {
                int x;
                printf("金钱，当前值=%d，范围[0..100000000]，请输入 :", shuxing.jinqian);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100000000) {
                    printf("非法的金钱值：%d\n", x);
                    continue;
                }
                shuxing.jinqian = x;
                break;
            }
            break;
        case 'g':
            while (1) {
                int x;
                printf("名声，当前值=%d，范围[0..1000000]，请输入 :", shuxing.mingshen);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 1000000) {
                    printf("非法的名声值：%d\n", x);
                    continue;
                }
                shuxing.mingshen = x;
                break;
            }
            break;
        case 'h':
            while (1) {
                int x;
                printf("魅力，当前值=%d，范围[0..1000000]，请输入 :", shuxing.meili);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 1000000) {
                    printf("非法的魅力值：%d\n", x);
                    continue;
                }
                shuxing.meili = x;
                break;
            }
            break;
        case 'i':
            while (1) {
                long long x;
                printf("游戏累计时间(us)，当前值=%lld，范围[0..10000000000000000]，请输入 :", shuxing.leijishijian);
                if (scanf("%lld", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 10000000000000000LL) {
                    printf("非法的游戏累计时间(us)值：%lld\n", x);
                    continue;
                }
                shuxing.leijishijian = x;
                break;
            }
            break;
        case 'j':
            while (1) {
                int x;
                printf("移动速度，当前值=%d，范围[0..100]，请输入 :", shuxing.yidongsudu);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的移动速度值：%d\n", x);
                    continue;
                }
                shuxing.yidongsudu = x;
                break;
            }
            break;
        case 'k':
            while (1) {
                int x;
                printf("攻击速度，当前值=%d，范围[0..100]，请输入 :", shuxing.gongjisudu);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的攻击速度值：%d\n", x);
                    continue;
                }
                shuxing.gongjisudu = x;
                break;
            }
            break;
        case 'l':
            while (1) {
                int x;
                printf("攻击范围，当前值=%d，范围[0..100]，请输入 :", shuxing.gongjifanwei);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的攻击范围值：%d\n", x);
                    continue;
                }
                shuxing.gongjifanwei = x;
                break;
            }
            break;
        case 'm':
            while (1) {
                int x;
                printf("攻击力，当前值=%d，范围[0..2000]，请输入 :", shuxing.gonglili);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 2000) {
                    printf("非法的攻击力值：%d\n", x);
                    continue;
                }
                shuxing.gonglili = x;
                break;
            }
            break;
        case 'n':
            while (1) {
                int x;
                printf("防御力，当前值=%d，范围[0..2000]，请输入 :", shuxing.fangyuli);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 2000) {
                    printf("非法的防御力值：%d\n", x);
                    continue;
                }
                shuxing.fangyuli = x;
                break;
            }
            break;
        case 'o':
            while (1) {
                int x;
                printf("敏捷度，当前值=%d，范围[0..100]，请输入 :", shuxing.mingjie);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的敏捷度值：%d\n", x);
                    continue;
                }
                shuxing.mingjie = x;
                break;
            }
            break;
        case 'p':
            while (1) {
                int x;
                printf("智力，当前值=%d，范围[0..100]，请输入 :", shuxing.zhili);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的智力值：%d\n", x);
                    continue;
                }
                shuxing.zhili = x;
                break;
            }
            break;
        case 'q':
            while (1) {
                int x;
                printf("经验，当前值=%d，范围[0..100]，请输入 :", shuxing.jingyan);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的经验值：%d\n", x);
                    continue;
                }
                shuxing.jingyan = x;
                break;
            }
            break;
        case 'r':
            while (1) {
                int x;
                printf("等级，当前值=%d，范围[0..100]，请输入 :", shuxing.dengji);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的等级值：%d\n", x);
                    continue;
                }
                shuxing.dengji = x;
                break;
            }
            break;
        case 's':
            while (1) {
                int x;
                printf("魔法，当前值=%d，范围[0..10000]，请输入 :", shuxing.mofazhi);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 10000) {
                    printf("非法的魔法值：%d\n", x);
                    continue;
                }
                shuxing.mofazhi = x;
                break;
            }
            break;
        case 't':
            while (1) {
                int x;
                printf("消耗魔法，当前值=%d，范围[0..100]，请输入 :", shuxing.once_mofazhi);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的消耗魔法值：%d\n", x);
                    continue;
                }
                shuxing.once_mofazhi = x;
                break;
            }
            break;
        case 'u':
            while (1) {
                int x;
                printf("魔法伤害力，当前值=%d，范围[0..100]，请输入 :", shuxing.mofashanghai);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的魔法伤害力值：%d\n", x);
                    continue;
                }
                shuxing.mofashanghai = x;
                break;
            }
            break;
        case 'v':
            while (1) {
                int x;
                printf("命中率，当前值=%d，范围[0..100]，请输入 :", shuxing.mingzhonglv);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的命中率值：%d\n", x);
                    continue;
                }
                shuxing.mingzhonglv = x;
                break;
            }
            break;
        case 'w':
            while (1) {
                int x;
                printf("魔法防御力，当前值=%d，范围[0..100]，请输入 :", shuxing.mokang);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的魔法防御力：%d\n", x);
                    continue;
                }
                shuxing.mokang = x;
                break;
            }
            break;
        case 'x':
            while (1) {
                int x;
                printf("暴击率，当前值=%d，范围[0..100]，请输入 :", shuxing.baojilv);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的暴击率值：%d\n", x);
                    continue;
                }
                shuxing.baojilv = x;
                break;
            }
            break;
        case 'y':
            while (1) {
                int x;
                printf("耐力，当前值=%d，范围[0..100]，请输入 :", shuxing.naili);
                if (scanf("%d", &x) != 1) {
                    clear_input_buffer();
                    continue;
                }
                clear_input_buffer();
                if (x < 0 || x > 100) {
                    printf("非法的耐力值：%d\n", x);
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

    fclose(fp);
    return 0;
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：main函数允许带参数，不允许进行文件读写
***************************************************************************/
int main(int argc, char* argv[])
{
    if (argc == 1) {
        printf("usage: %s --modify | --read\n", argv[0]);
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
