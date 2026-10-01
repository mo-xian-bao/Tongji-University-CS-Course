#include <iostream>
#include <map>
#include <string>

using namespace std;
bool x_is_an_ancestor_of_y(const string& x0, const string& y0,
                           map<string, string>& mp) {
    string y = y0;
    if (y0 == x0) return true;
    while (mp[y] != y) {
        if (mp[y] == x0) return true;
        y = mp[y];
    }
    return false;
}
int main() {
    bool is_first = true;
    while (1) {
        int n, m;
        cin >> n >> m;
        if (n == 0 && m == 0) break;
        if (is_first)
            is_first = false;
        else
            cout << endl;
        map<string, string> mp;
        cin.ignore();
        string last;
        int last_num;
        string ancestor;
        for (int i = 0; i < n; i++) {
            string s;
            getline(cin, s);
            int num = 0;
            if (i == 0) {
                mp[s] = s;
                ancestor = s;
            } else {
                while (s[0] == ' ') {
                    s.erase(s.begin());
                    num++;
                }
                string ans = last;
                for (int j = 0; j < last_num + 1 - num; j++) {
                    ans = mp[ans];
                }
                mp[s] = ans;
            }
            last = s;
            last_num = num;
        }
        for (int i = 0; i < m; i++) {
            string x, r1, r2, k, r3, y;
            cin >> x >> r1 >> r2 >> k >> r3 >> y;
            y.pop_back();
            if (k[0] == 'c')
                cout << ((x != y && mp[x] == y) ? "True" : "False") << endl;
            else if (k[0] == 's')
                cout << (((x != ancestor && y != ancestor && mp[x] == mp[y]) ||
                          x == y)
                             ? "True"
                             : "False")
                     << endl;
            else if (k[0] == 'p')
                cout << ((x != y && mp[y] == x) ? "True" : "False") << endl;
            else if (k[0] == 'a')
                cout << (x_is_an_ancestor_of_y(x, y, mp) ? "True" : "False")
                     << endl;
            else
                cout << (x_is_an_ancestor_of_y(y, x, mp) ? "True" : "False")
                     << endl;
        }
    }
    return 0;
}