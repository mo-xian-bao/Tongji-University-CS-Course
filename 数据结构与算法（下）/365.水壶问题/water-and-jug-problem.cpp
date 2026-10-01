#include <bits/stdc++.h>
using namespace std;

class Solution {
    public:
        bool canMeasureWater(int x, int y, int target) {
            if(target > x+y)
                return false;

            deque<pair<int, int>> q;
            set<pair<int, int>> s;
            q.push_back({0, 0});
            s.insert({0, 0});

            while (q.empty()==false){
                pair<int, int> cur = q.front();
                q.pop_front();
                int cx = cur.first;
                int cy = cur.second;
                if(cx==target||cy==target||cx+cy==target)
                    return true;
                
                // 生成所有可能的下一个状态
                //1. 把x壶倒满
                if(s.find({x,cy})==s.end()){
                    s.insert({x, cy});
                    q.push_back({x, cy});
                }
                //2. 把y壶倒满
                if(s.find({cx,y})==s.end()){
                    s.insert({cx, y});
                    q.push_back({cx, y});
                }
                //3. 把x壶倒空
                if(s.find({0,cy})==s.end()){
                    s.insert({0, cy});
                    q.push_back({0, cy});
                }
                //4. 把y壶倒空
                if(s.find({cx,0})==s.end()){
                    s.insert({cx, 0});
                    q.push_back({cx, 0});
                }
                //5. 把x壶倒入y壶
                if(cx+cy<=y && s.find({0, cx+cy})==s.end()){
                    s.insert({0, cx+cy});
                    q.push_back({0, cx+cy});
                } 
                else if(cx+cy>y && s.find({cx-(y-cy), y})==s.end()){
                    s.insert({cx-(y-cy), y});
                    q.push_back({cx-(y-cy), y});
                }
                //6. 把y壶倒入x壶
                if(cx+cy<=x && s.find({cx+cy, 0})==s.end()){
                    s.insert({cx+cy, 0});
                    q.push_back({cx+cy, 0});
                } 
                else if(cx+cy>x && s.find({x, cy-(x-cx)})==s.end()){
                    s.insert({x, cy-(x-cx)});
                    q.push_back({x, cy-(x-cx)});
                }
            }
            return false;
        }

};

