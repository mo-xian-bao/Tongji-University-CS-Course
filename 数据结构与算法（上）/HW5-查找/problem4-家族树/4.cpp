#include <iostream>
#include <map>
#include <string>
#include <vector>
using namespace std;

struct Member {
    string name;
    int d;  // 当前成员的层级深度
    Member* parent;
    // vector<Member*> children;

    Member(string name, int d, Member* parent = nullptr)
        : name(name), d(d), parent(parent) {}
};

map<string, Member*> family;      // 存储所有成员
vector<vector<Member*>> dep(50);  // 存储各层级成员

// 判断m1是否是m2的子女
bool is_child(Member* m1, Member* m2) {
    return m1->parent != nullptr && m1->parent == m2;
}

// 判断m1是否是m2的父母
bool is_parent(Member* m1, Member* m2) {
    return m2->parent != nullptr && m1 == m2->parent;
}

// 判断m1和m2是否是兄弟姐妹
bool is_sibling(Member* m1, Member* m2) {
    return m1 == m2 || m1->parent == m2->parent;
}

// 判断m1是否是m2的祖先
bool is_ancestor(Member* m1, Member* m2) {
    if (m1 == m2) return true;
    for (Member* parent = m2->parent; parent != nullptr;
         parent = parent->parent) {
        if (parent == m1) return true;
    }
    return false;
}

// 判断m1是否是m2的后代
bool is_descendant(Member* m1, Member* m2) { return is_ancestor(m2, m1); }

int main() {
    int n, m;

    // 读取并处理输入
    while (cin >> n >> m && n != 0 && m != 0) {
        cin.ignore();  // 忽略换行符

        // 处理家庭成员的输入
        for (int i = 0; i < n; i++) {
            string line;
            getline(cin, line);
            int d = 0;

            // 计算成员的深度
            while (line[d] == ' ') {
                d++;
            }

            // 获取成员的名字
            string name = line.substr(d);
            Member* new_member = new Member(name, d);
            family[name] = new_member;
            dep[d].push_back(new_member);

            // 如果不是根成员，设置父母
            if (d > 0) {
                int n = dep[d - 1].size() - 1;
                new_member->parent = dep[d - 1][n];
                // dep[d - 1][n]->children.push_back(new_member);
            }
        }

        // 处理查询
        for (int i = 0; i < m; i++) {
            string member1, is, a, relation, of, member2;
            cin >> member1 >> is >> a >> relation >> of >> member2;

            // 去掉 member2 后面的句点
            member2.pop_back();

            Member* m1 = family[member1];
            Member* m2 = family[member2];

            // 根据查询类型判断关系
            if (relation == "child") {
                cout << (is_child(m1, m2) ? "True" : "False") << endl;
            } else if (relation == "parent") {
                cout << (is_parent(m1, m2) ? "True" : "False") << endl;
            } else if (relation == "sibling") {
                cout << (is_sibling(m1, m2) ? "True" : "False") << endl;
            } else if (relation == "ancestor") {
                cout << (is_ancestor(m1, m2) ? "True" : "False") << endl;
            } else if (relation == "descendant") {
                cout << (is_descendant(m1, m2) ? "True" : "False") << endl;
            }
        }

        cout << endl;  // 输出一个空行分隔每组查询
    }

    return 0;
}
