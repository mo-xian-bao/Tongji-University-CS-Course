#include <iostream>
#include <vector>
#include <algorithm>
#include <ctime>
#include <chrono>

using namespace std;

void Divider(vector<int> &cards, vector<int> &A_cards, vector<int> &B_cards, int &A_val, int &B_val)
{
    A_val = 0;
    int total_val = 0;
    for (int i = 0; i < cards.size(); i++)
        total_val += cards[i];
    int goal_val = total_val / 2;

    vector<vector<int>> dp(cards.size(), vector<int>(goal_val + 1, 0));

    for (int i = 0; i < cards.size(); i++){
        for (int j = 1; j <= goal_val; j++){
            if (i == 0){
                if (cards[i] <= j)
                    dp[i][j] = cards[i];
            }
            else{
                if (cards[i] <= j)
                    dp[i][j] = max(dp[i - 1][j], dp[i - 1][j - cards[i]] + cards[i]);
                else
                    dp[i][j] = dp[i - 1][j];
            }
        }
    }

    A_val = dp[cards.size() - 1][goal_val];
    B_val = total_val - A_val;

    int i = cards.size() - 1;
    int j = goal_val;
    while (true){
        if(i == 0 && j == 0)
            break;
        if (i == 0){
            A_cards.push_back(1);
            break;
        }
        if (dp[i][j] != dp[i - 1][j])
        {
            A_cards.push_back(i+1);
            j -= cards[i];
        }
        i--;
    }
    reverse(A_cards.begin(), A_cards.end());

    for (int i = 0; i < cards.size(); i++)
    {
        if (find(A_cards.begin(), A_cards.end(), i+1) == A_cards.end())
            B_cards.push_back(i+1);
    }

    //展示中间结果
    // cout<< "DP table:" << endl;
    // for(int i = 0; i < cards.size(); i++){
    //     for(int j = 0; j <= goal_val; j++){
    //         cout << dp[i][j] << " ";
    //     }
    //     cout << endl;
    // }
}

int main()
{
    vector<int> cards = {2, 1, 3, 1, 5, 2, 3, 4, 8, 7, 6, 9};
    int A_val, B_val;
    vector<int> A_cards, B_cards;
    //记录时间
    auto start = std::chrono::high_resolution_clock::now();
    Divider(cards, A_cards, B_cards, A_val, B_val);
    auto end = std::chrono::high_resolution_clock::now();
    auto time_taken = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

    cout << "Time taken: " << time_taken << " microseconds" << endl;
    cout << "Abe's cards: ";
    for (int card : A_cards)
        cout << card << " ";
    cout << "\nAbe's total value: " << A_val << endl;

    cout << "Bob's cards: ";
    for (int card : B_cards)
        cout << card << " ";
    cout << "\nBob's total value: " << B_val << endl;

    return 0;
}