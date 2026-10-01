#include <bits/stdc++.h>
using namespace std;

class Solution {
    public:
        bool canMeasureWater(int x, int y, int target) {
            return target % __gcd(x, y) == 0 && target <= x + y;
        }
};