#include <iostream>
#include <map>
#include <sstream>
#include <string>
using namespace std;

// 判断x是否是y的祖先
bool isAncestor(const string& x, const string& y,
                const map<string, string>& parentMap) {
    string current = y;
    if (x == y) return true;  // 自己是自己的祖先。。。
    while (current != parentMap.at(current)) {  // 一直向上找y的祖先
        if (parentMap.at(current) == x) return true;
        current = parentMap.at(current);
    }
    return false;
}

int main() {
    int n, m;
    while (cin >> n >> m && n != 0 && m != 0) {
        cin.ignore();
        map<string, string> parentMap;  // parentMap[x] = parent of x
        string ancestor, last;  // ancestor记录最高祖先，last记录上一个节点，用于构建parentMap
        int lastIndent = 0;  // 记录上一个节点的缩进（辈分）
        for (int i = 0; i < n; ++i) {
            string line;
            getline(cin, line);
            int currentIndent = 0;  // 当前节点的缩进（辈分）
            while (line[currentIndent] == ' ') ++currentIndent;
            string name = line.substr(currentIndent);
            if (i == 0) {                // 第一个节点，为最高祖先
                parentMap[name] = name;  // 置祖先为自己，方便后续判断
                ancestor = name;         // 记录最高祖先
            } else {
                string parent = last;
                for (int j = 0; j < lastIndent + 1 - currentIndent; j++)
                    parent = parentMap[parent];  // 向上寻找祖先
                parentMap[name] = parent;
            }
            last = name;
            lastIndent = currentIndent;
        }
        for (int i = 0; i < m; ++i) {
            string x, y, relation, a, b, c;
            cin >> x >> a >> b >> relation >> c >> y;
            y = y.substr(0, y.size() - 1);  // Correctly modify y
            bool result = false;
            if (relation == "child") {
                result = (x != y && parentMap[x] == y);  // Corrected logic
            } else if (relation == "sibling") {
                result = (x != ancestor && y != ancestor &&
                          parentMap[x] == parentMap[y]) ||
                         x == y;
            } else if (relation == "parent") {
                result = (x != y && parentMap[y] == x);
            } else if (relation == "ancestor") {
                result = isAncestor(x, y, parentMap);
            } else if (relation == "descendant") {
                result = isAncestor(y, x, parentMap);
            }
            cout << (result ? "True" : "False") << endl;
        }
        cout << endl;
    }
    return 0;
}
