#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

class Solution {
   private:
    int n, m;

   public:
    int solve(vector<vector<string>>& old_chart,
              vector<vector<string>>& new_chart) {
        n = old_chart.size();
        m = old_chart[0].size();
        unordered_map<string, pair<int, int>> target_positions;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                target_positions[new_chart[i][j]] = {i, j};
            }
        }

        vector<vector<bool>> visited(n, vector<bool>(m, false));
        int swaps = 0;

        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (visited[i][j] || old_chart[i][j] == new_chart[i][j])
                    continue;

                int x = i, y = j;
                int cycle_size = 0;

                while (!visited[x][y]) {
                    visited[x][y] = true;
                    pair<int, int> target_pos =
                        target_positions[old_chart[x][y]];
                    x = target_pos.first;
                    y = target_pos.second;
                    cycle_size++;
                }

                if (cycle_size > 0) {
                    swaps += (cycle_size - 1);
                }
            }
        }

        return swaps;
    }
};
