#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "Josephus.h"
#include "gamewindow.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_startGameButton_clicked();
    void handlePlayerEliminated(int playerNumber, int diceRoll, int nextPlayerNumber);
    void handleGameOver(int winnerNumber, const std::vector<int>& eliminationOrder);
    void handleResetRequested();

signals:
    void updateGameLog(const QString& message);

private:
    Ui::MainWindow *ui;
    Game *game;
    GameWindow *gameWindow;
};
#endif 
