#include "Josephus.h"
#include <cstdlib>
#include <ctime>

// Game 构造函数
Game::Game(int n, QObject *parent)
    : QObject(parent), first(nullptr), currentPlayer(nullptr), total(n), remaining(n) {
    eliminationOrder.clear();
    initializeGame();
}

// Game 析构函数
Game::~Game() {
    cleanup();
}

// 初始化游戏：创建循环链表
void Game::initializeGame() {
    if (total <= 0)
        return;

    // 创建第一个玩家
    first = new Player(1);
    Player* current = first;

    // 创建其余玩家并连接
    for (int i = 2; i <= total; i++) {
        current->next = new Player(i);
        current = current->next;
    }

    // 形成循环链表
    current->next = first;
    currentPlayer = first; // 从1号玩家开始
    srand((unsigned int)time(0)); // 初始化随机数种子
}

// 清理内存
void Game::cleanup() {
    if (!first)
        return;

    Player* current = first;
    Player* temp;

    // 先断开循环
    Player* last = first;
    while (last->next != first) {
        last = last->next;
    }
    last->next = nullptr;

    // 删除所有节点
    while (current) {
        temp = current;
        current = current->next;
        delete temp;
    }
    first = nullptr;
    currentPlayer = nullptr;
}

// 找到下一个未被淘汰的玩家
Player* Game::getNextActivePlayer(Player* current) {
    Player* next = current->next;
    while (next->is_out) {
        next = next->next;
    }
    return next;
}

// 从指定玩家开始，前进steps步，找到要淘汰的玩家
Player* Game::findOutPlayer(Player* startPlayer, int steps) {
    Player* current = startPlayer;

    // 前进steps-1步（因为当前玩家算第1步）
    for (int i = 1; i < steps; i++) {
        current = getNextActivePlayer(current);
    }

    return current;
}

// 淘汰指定玩家
void Game::eliminatePlayer(Player* player) {
    player->is_out = true;
    remaining--;
    eliminationOrder.push_back(player->number); // 记录淘汰顺序
}

Player* Game::getCurrentPlayer() {
    return currentPlayer;
}

int Game::getRemainingCount() {
    return remaining;
}

Player* Game::getWinner() {
    if (remaining == 1) {
        Player* winner = first;
        while (winner->is_out) {
            winner = winner->next;
        }
        return winner;
    }
    return nullptr;
}

void Game::nextTurn() {
    if (remaining <= 1) {
        Player* winner = getWinner();
        if(winner) {
            emit gameOver(winner->number, eliminationOrder);
        }
        return;
    }

    // 掷骰子
    int diceRoll = rand() % 6 + 1;

    // 找到要淘汰的玩家和路径
    std::vector<int> path;
    Player* p = currentPlayer;
    for (int i = 0; i < diceRoll; ++i) {
        path.push_back(p->number);
        p = getNextActivePlayer(p);
    }
    Player* playerToEliminate = findOutPlayer(currentPlayer, diceRoll);


    // 淘汰该玩家
    eliminatePlayer(playerToEliminate);

    // 确定下一轮的起始玩家
    Player* nextPlayer = getNextActivePlayer(playerToEliminate);

    emit eliminationPath(path, playerToEliminate->number);
    emit playerEliminated(playerToEliminate->number, diceRoll, nextPlayer->number);

    currentPlayer = nextPlayer;

    if (remaining == 1) {
        Player* winner = getWinner();
        if(winner) {
            emit gameOver(winner->number, eliminationOrder);
        }
    }
}
