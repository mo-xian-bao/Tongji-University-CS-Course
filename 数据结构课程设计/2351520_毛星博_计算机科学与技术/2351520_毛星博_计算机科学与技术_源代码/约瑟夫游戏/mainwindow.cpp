#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "Josephus.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , game(nullptr)
    , gameWindow(nullptr)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
        delete game; // gameWindow 会在关闭时被删掉
}

void MainWindow::on_startGameButton_clicked()
{
    int n = ui->playerNumber->value();
    if (n < 2 || n > 20) {
        QMessageBox::warning(this, "输入无效", "请输入2到20之间的玩家人数。");
        return;
    }

    if(game) {
        delete game;
    }
    game = new Game(n);

    if(gameWindow) {
        gameWindow->close(); //关闭欢迎界面
    }
    gameWindow = new GameWindow();
    gameWindow->setPlayerCount(n);

    connect(game, &Game::playerEliminated, this, &MainWindow::handlePlayerEliminated);
    connect(game, &Game::gameOver, this, &MainWindow::handleGameOver);
    connect(this, &MainWindow::updateGameLog, gameWindow, &GameWindow::updateLog);
    connect(gameWindow, &GameWindow::nextTurnRequested, game, &Game::nextTurn);
    connect(game, &Game::eliminationPath, gameWindow, &GameWindow::animateElimination);
    connect(gameWindow, &GameWindow::resetRequested, this, &MainWindow::handleResetRequested);


    gameWindow->show();
    this->hide();

    emit updateGameLog(QString("游戏开始，总共有 %1 个玩家。").arg(n));
    emit updateGameLog(QString("当前玩家是 %1 号").arg(game->getCurrentPlayer()->number));
}

void MainWindow::handlePlayerEliminated(int playerNumber, int diceRoll, int nextPlayerNumber)
{
    // This slot now primarily exists to log the event, as animation handles the visuals.
        // 这个槽主要用来写日志，画面上的效果交给动画去做
    emit updateGameLog(QString("掷骰子结果: %1. 玩家 %2 被淘汰.").arg(diceRoll).arg(playerNumber));
    emit updateGameLog(QString("下一轮从玩家 %1 开始.").arg(nextPlayerNumber));
}

void MainWindow::handleGameOver(int winnerNumber, const std::vector<int>& eliminationOrder)
{
    emit updateGameLog(QString("游戏结束！获胜者是 %1 号玩家！").arg(winnerNumber));
    
    // 输出淘汰顺序
    QString orderText = "出列顺序: ";
    for (size_t i = 0; i < eliminationOrder.size(); ++i) {
        if (i > 0) orderText += " -> ";
        orderText += QString::number(eliminationOrder[i]);
    }
    orderText += " -> " + QString::number(winnerNumber) + "(获胜者)";
    
    emit updateGameLog(orderText);
    
    QMessageBox::information(gameWindow, "游戏结束", 
        QString("获胜者是 %1 号玩家！\n\n出列顺序:\n%2").arg(winnerNumber).arg(orderText));
    gameWindow->disableNextTurnButton();
}

void MainWindow::handleResetRequested()
{
    // 收到重置请求，关闭游戏窗口，回到主界面
    if (gameWindow) {
        gameWindow->close();
        delete gameWindow;
        gameWindow = nullptr;
    }

    // 把游戏实例也删了，下一次重新开始
    if (game) {
        delete game;
        game = nullptr;
    }

    this->show();
}
