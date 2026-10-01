#include <iostream>
#include <fstream>
#include <cstring>

using namespace std;

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
    char jinyan;
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

int main() {
    ifstream file("game.dat", ios::in | ios::binary);
    shuxing shuxing;
    file.read((char*)&shuxing, sizeof(shuxing));
    cout<<shuxing.nicheng<<endl;
    cout<<shuxing.shengming<<endl;
}