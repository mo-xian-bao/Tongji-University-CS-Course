#include <iostream>
#include <map>
#include <string>
#include <vector>

using namespace std;

struct Member {
    string name;
    int d;
    Member* parent;
    vector<Member*> children;

    Member(string name, int d, Member* parent = nullptr)
        : name(name), d(d), parent(parent) {}
};
map<string, Member*> family;
vector<vector<Member*>> dep(50);

bool is_child(Member* m1, Member* m2) { return m1->parent == m2; }

bool is_parent(Member* m1, Member* m2) { return m1 == m2->parent; }

bool is_sibling(Member* m1, Member* m2) { return m1->parent == m2->parent; }

bool is_ancestor(Member* m1, Member* m2) {
    for (Member* parent = m2->parent; parent != nullptr;
         parent = parent->parent) {
        if (parent == m1) return true;
    }
    return false;
}

bool is_descendant(Member* m1, Member* m2) { return is_ancestor(m2, m1); }

int main() {
    int n, m;
    while (cin >> n >> m && n != 0 && m != 0) {
        cin.ignore();  // 忽略上一个输入留下的换行符
        for (int i = 0; i < n; i++) {
            string line;
            getline(cin, line);
            int d = 0;
            while (line[d] == ' ') {
                d++;
            }
            string name = line.substr(d);
            Member* new_member = new Member(name, d);
            family[name] = new_member;
            dep[d].push_back(new_member);
            if (d > 0) {
                int n = dep[d - 1].size() - 1;
                new_member->parent = dep[d - 1][n];
                dep[d - 1][n]->children.push_back(new_member);
            }
        }
        for (int i = 0; i < m; i++) {
            string member1, is, a, relation, of, member2;
            cin >> member1 >> is >> a >> relation >> of >> member2;
            member2 = member2.substr(0, member2.size() - 1);  // 去掉最后一个.
            Member* m1 = family[member1];
            Member* m2 = family[member2];
            if (relation == "child") {
                if (is_child(m1, m2)) {
                    cout << "True" << endl;
                } else {
                    cout << "False" << endl;
                }
            } else if (relation == "parent") {
                if (is_parent(m1, m2)) {
                    cout << "True" << endl;
                } else {
                    cout << "False" << endl;
                }
            } else if (relation == "sibling") {
                if (is_sibling(m1, m2)) {
                    cout << "True" << endl;
                } else {
                    cout << "False" << endl;
                }
            } else if (relation == "ancestor") {
                if (is_ancestor(m1, m2)) {
                    cout << "True" << endl;
                } else {
                    cout << "False" << endl;
                }
            } else if (relation == "descendant") {
                if (is_descendant(m1, m2)) {
                    cout << "True" << endl;
                } else {
                    cout << "False" << endl;
                }
            }
        }
        cout << endl;
    }
}
