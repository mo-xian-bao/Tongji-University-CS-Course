#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <climits>
#include <ctime>
#include <chrono>
using namespace std;

//暴力回溯法，枚举所有可能的分配方式
vector<int> path;
vector<vector<int>> all_paths;
vector<int> res;
void backtracking(vector<int> &cards, int start)
{
    if(start >= cards.size()){
        all_paths.push_back(path);
        int A_val = 0;
        for (int i = 0; i < path.size(); i++)
            A_val += cards[path[i]];
        res.push_back(A_val);
        return;
    }
    path.push_back(start);
    backtracking(cards, start + 1);
    path.pop_back();
    backtracking(cards, start + 1);
}

int main()
{
    path.clear();
    all_paths.clear();
    res.clear();

    vector<int> cards = {2, 1, 3, 1, 5, 2, 3, 4, 8, 7, 6, 9}; //卡片的值
    //记录时间
    auto start = std::chrono::high_resolution_clock::now();
    backtracking(cards, 0);

    int total_val = accumulate(cards.begin(), cards.end(), 0);
    int min_diff = INT_MAX;
    int best_A_val = 0;
    int best_path = 0;
    for (int i = 0; i < res.size(); i++)
    {
        int A_val = res[i];
        int B_val = total_val - A_val;
        int diff = abs(A_val - B_val);
        if (diff < min_diff)
        {
            min_diff = diff;
            best_A_val = A_val;
            best_path = i;
        }
    }
    
    vector<int> A_cards;
    vector<int> B_cards;

    for (int idx : all_paths[best_path])
        A_cards.push_back(idx + 1);
    for (int i = 0; i < cards.size(); i++)
    {
        if (find(all_paths[best_path].begin(), all_paths[best_path].end(), i) == all_paths[best_path].end())
            B_cards.push_back(i + 1);
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto time_taken = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

    cout << "Time taken: " << time_taken << " microseconds" << endl;
    cout << "Abe's cards: ";
    for (int i = 0; i < A_cards.size(); i++)
        cout << A_cards[i] << " ";
    cout << endl;
    cout << "Abe's total value: " << best_A_val << endl;

    cout << "Bob's cards: ";
    for (int i = 0; i < B_cards.size(); i++)
        cout << B_cards[i] << " ";
    cout << endl;
    cout << "Bob's total value: " << total_val - best_A_val << endl;

    return 0;
}