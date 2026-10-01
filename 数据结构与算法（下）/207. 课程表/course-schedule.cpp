#include <bits/stdc++.h>
using namespace std;

class Solution {
    public:
        bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
            //邻接表graph，存储每门课的后续课程号
            vector<vector<int>> graph(numCourses);
            //入度indegree，储存节点的入度
            vector<int> indegree(numCourses,0);
            //已经学完的课程数
            int course_num = 0;

            for(auto vec : prerequisites){
                int a = vec[0];
                int b = vec[1];
                graph[b].push_back(a);
                indegree[a]++;
            }

            //队列，存放入度为0的课程，入度为0表示已经可以修了
            queue<int> q;

            // 将所有入度为0的课程加入队列
            for(int i = 0; i < numCourses; i++)
                if(indegree[i] == 0)
                    q.push(i);

            //拓扑排序
            while(q.empty()==false){
                int course = q.front();
                q.pop();
                course_num++;

                for(auto next : graph[course]){
                    indegree[next]--;
                    if(indegree[next]==0){
                        q.push(next);
                    }
                }
            }

            return course_num == numCourses;
        }
};

int main()
{
    Solution s;
    int numCourses = 2;
    vector<vector<int>> prerequisites = {{1,0}};
    bool result = s.canFinish(numCourses, prerequisites);
    cout << (result ? "true" : "false") << endl;
    return 0;
}