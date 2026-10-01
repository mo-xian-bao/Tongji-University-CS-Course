#include <bits/stdc++.h>
using namespace std;

class Solution {
    public:
        bool judgePoint24(vector<int>& cards) {
            vector<double> c;
            for (int i = 0; i < cards.size();i++)
                c.push_back(cards[i]);
            bt(c);
            return flag;
        }
    private:
        bool flag = false;
        void bt(vector<double>& cards)
        {
            if(cards.size()==1 && abs(cards[0]-24)<1e-6){
                flag = true;
                return;
            }
            for (int i = 0; i < cards.size();i++){
                for (int j = i+1; j < cards.size();j++){
                    vector<double> c = cards;
                    double x = c[i];
                    double y = c[j];
                    c.erase(c.begin() + j);
                    c.erase(c.begin() + i);

                    //x+y
                    c.push_back(x + y);
                    bt(c);
                    if(flag) return;
                    c.pop_back();
                    //x-y
                    c.push_back(x - y);
                    bt(c);
                    if(flag) return;
                    c.pop_back();
                    //y-x
                    c.push_back(y - x);
                    bt(c);
                    if(flag) return;
                    c.pop_back();
                    //x*y
                    c.push_back(x * y);
                    bt(c);
                    if(flag) return;
                    c.pop_back();
                    //x/y
                    if(y != 0) {
                        c.push_back(x / y);
                        bt(c);
                        if(flag) return;
                        c.pop_back();
                    }
                    //y/x
                    if(x != 0) {
                        c.push_back(y / x);
                        bt(c);
                        if(flag) return;
                        c.pop_back();
                    }
                }
            }
        }
};

int main()
{
    Solution s;
    vector<int> cards = {8,1,6,6};
    bool res = s.judgePoint24(cards);
    cout << (res ? "True" : "False") << endl;

    return 0;
}