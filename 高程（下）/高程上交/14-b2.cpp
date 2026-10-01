/* 计拔 2351520 毛星博 */
#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <time.h>
/* 如果有需要，此处可以添加头文件 */

using namespace std;

/* 允许定义常变量/宏定义，但不允许定义全局变量 */

/* 可以添加自己需要的函数 */

char huase(int i)
{
#if defined(__linux__)
	return "HDCS"[i % 4];
#else
	return char(i % 4 + 3);
#endif
}


/***************************************************************************
  函数名称：
  功    能：打印某个玩家的牌面信息，如果是地主，后面加标记
  输入参数：
  返 回 值：
  说    明：
 ***************************************************************************/
int print(const char* prompt, const bool landlord, const unsigned long long player)
{
	/* 只允许定义不超过三个基本类型的简单变量，不能定义数组变量、结构体、string等 */

	cout << prompt ;
	for (int i = 0; i < 54; i++) {
		if (player & (1ULL << i)) {
			if (i < 28) {
				cout<<huase(i)<<i/4+3<<" ";
			}
			else if (i >= 28 && i < 32) {
				cout<<huase(i)<<'T' << " ";
			}
			else if (i >= 32 && i < 36) {
				cout<<huase(i)<<'J' << " ";
			}
			else if (i >= 36 && i < 40) {
				cout<<huase(i)<<'Q' << " ";
			}
			else if (i >= 40 && i < 44) {
				cout<<huase(i)<<'K' << " ";
			}
			else if (i >= 44 && i < 48) {
				cout<<huase(i)<<'A' << " ";
			}
			else if (i >= 48 && i < 52) {
				cout<<huase(i)<<'2' << " ";
			}
			else if (i == 52) {
				cout<<"BJ" << " ";
			}
			else if (i == 53) {
				cout<<"RJ" << " ";
			}
		}
	}
	if (landlord) {
		cout << "(地主)" ;
	}
	cout << endl;

	return 0;
}

/***************************************************************************
  函数名称：
  功    能：发牌（含键盘输入地主）
  输入参数：
  返 回 值：
  说    明：
 ***************************************************************************/
int deal(unsigned long long* player)
{
	/* 只允许定义不超过十个基本类型的简单变量，不能定义数组变量、结构体、string等 */
	unsigned long long card = 0;
	int n, landlord;
	srand((unsigned int)time(NULL)); //设置随机种子

	for (int i = 0; i < 17; i++) {  //每人发17张牌
		for (int j = 0; j < 3; j++) {  
			n=rand()%54; //随机生成0-50的整数
			while(card & (1ULL << n))
				n=rand()%54; //如果已经发过，重新生成
			card |= (1ULL << n); 
			player[j] |= (1ULL << n); //将牌加入到玩家手中
		}
		cout<<"第"<<i+1<<"轮结束："<<endl;
		print("甲的牌：", false, player[0]);
		print("乙的牌：", false, player[1]);
		print("丙的牌：", false, player[2]);
	}
	cout << endl;

	while (true) { //选择地主
		cout << "请选择一个地主[0-2]：" << endl;
		cin >> landlord;
		if (cin.fail() || landlord < 0 || landlord > 2) {
			cout << endl;
			cin.clear();
			while (cin.get() != '\n')
				;
			continue;
		}
		else {
			break;
		}
	}
	for (int i = 0; i < 54; i++) {
		if ((card & (1ULL << i)) == 0) {
			card |= (1ULL << n);
			player[landlord] |= (1ULL << i); //将地主的牌加入到玩家手中
		}
	}

	return landlord; //此处修改为选定的地主(0-2)
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：main函数，不准修改
 ***************************************************************************/
int main()
{
	unsigned long long player[3] = { 0 }; //存放三个玩家的发牌信息
	int landlord; //返回0-2表示哪个玩家是地主

	cout << "按回车键开始发牌";
	while (getchar() != '\n')
		;

	landlord = deal(player);
	print("甲的牌：", (landlord == 0), player[0]);
	print("乙的牌：", (landlord == 1), player[1]);
	print("丙的牌：", (landlord == 2), player[2]);

	return 0;
}