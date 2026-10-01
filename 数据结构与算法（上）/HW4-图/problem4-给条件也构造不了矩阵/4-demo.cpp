#include <iostream>
#include <queue>
#include <vector>

using namespace std;

class Solution {
   public:
    bool topu(vector<vector<int>> vis, vector<int>& list, int k) {
        vector<vector<int>> edg(k + 1);
        vector<int> d(k + 1);
        for (auto& v : vis) {
            edg[v[0]].push_back(v[1]);
            d[v[1]]++;
        }
        queue<int> qu;
        for (int i = 1; i < d.size(); i++)
            if (d[i] == 0) qu.push(i);
        if (qu.size() == 0) return false;
        int tep = 0;
        while (!qu.empty()) {
            int v = qu.front();
            qu.pop();
            list[v] = tep;
            tep++;
            for (int i : edg[v]) {
                d[i]--;
                if (d[i] == 0) qu.push(i);
            }
        }

        return true;
    }
    vector<vector<int>> buildMatrix(int k, vector<vector<int>>& rowConditions,
                                    vector<vector<int>>& colConditions) {
        vector<vector<int>> ans(k, vector<int>(k));
        vector<int> x(k + 1);
        vector<int> y(k + 1);
        if (!topu(rowConditions, x, k)) return {};
        if (!topu(colConditions, y, k)) return {};
        for (int i = 1; i <= k; i++) ans[x[i]][y[i]] = i;
        return ans;
    }
};

int main() {
    Solution sol;
    int k, m, n;
    cin >> k >> m >> n;
    vector<vector<int>> rowConditions(n, vector<int>(2));
    vector<vector<int>> colConditions(m, vector<int>(2));
    for (int i = 0; i < n; i++) {
        cin >> rowConditions[i][0] >> rowConditions[i][1];
    }
    for (int i = 0; i < m; i++) {
        cin >> colConditions[i][0] >> colConditions[i][1];
    }
    vector<vector<int>> ans = sol.buildMatrix(k, rowConditions, colConditions);
    if (ans.empty()) {
        cout << "-1" << endl;
    } else {
        for (auto& v : ans) {
            for (int i : v) {
                cout << i << " ";
            }
            cout << endl;
        }
    }
    return 0;
}