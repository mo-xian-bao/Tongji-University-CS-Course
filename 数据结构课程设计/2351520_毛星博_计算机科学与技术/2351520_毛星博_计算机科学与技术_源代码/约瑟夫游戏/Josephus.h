#ifndef JOSEPHUS_H
#define JOSEPHUS_H

#include <QObject>
#include <vector>

// 玩家类，保存编号和是否被淘汰之类的信息
class Player {
public:
    int number;                 // 玩家编号
    bool is_out;                // 是否已经出列
    Player* next;               // 指向下一个玩家

    // 构造函数
    Player(int playerId) : number(playerId), is_out(false), next(nullptr) {}
};

// 游戏类，负责创建循环链表、进行淘汰并发信号给界面
class Game : public QObject {
    Q_OBJECT

public:
    // 构造 / 析构
    Game(int n, QObject *parent = nullptr);
    ~Game();

    // 初始化、清理
    void initializeGame();
    void cleanup();

    // 核心工具函数
    Player* getNextActivePlayer(Player* current);
    Player* findOutPlayer(Player* startPlayer, int steps);
    void eliminatePlayer(Player* player);

    // 状态查询
    Player* getCurrentPlayer();
    int getRemainingCount();
    Player* getWinner();

    // 执行下一步（掷骰子并淘汰）
    void nextTurn();


signals:
    void gameStarted();
    void playerEliminated(int playerNumber, int diceRoll, int nextPlayerNumber);
    void gameOver(int winnerNumber, const std::vector<int>& eliminationOrder);
    void eliminationPath(const std::vector<int>& path, int eliminatedPlayer);

private:
    Player* first;          // 头指针，指向第一个玩家
    Player* currentPlayer;  // 当前轮次的玩家
    int total;              // 总玩家数
    int remaining;          // 剩余玩家数
    std::vector<int> eliminationOrder; // 记录淘汰顺序
};

#endif // JOSEPHUS_H
