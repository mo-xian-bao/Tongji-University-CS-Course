#ifndef GAMEWINDOW_H
#define GAMEWINDOW_H

#include <QWidget>
#include <vector>
#include <QLabel>

namespace Ui {
class GameWindow;
}

// 游戏界面窗口，左侧显示玩家圈，右侧显示控制和日志
// 我们在这里维护玩家的 QLabel 列表和原始样式，方便动画恢复
class GameWindow : public QWidget
{
    Q_OBJECT

public:
    explicit GameWindow(QWidget *parent = nullptr);
    ~GameWindow();
    // 设置玩家数量（创建对应的玩家控件）
    void setPlayerCount(int count);

public slots:
    // 把一条日志写到右侧日志框
    void updateLog(const QString& message);
    // 把指定编号的玩家标记为淘汰（红色）
    void eliminatePlayer(int playerNumber);
    // 禁用“下一步”按钮
    void disableNextTurnButton();
    // 播放从当前玩家到被淘汰玩家的扫描动画
    void animateElimination(const std::vector<int>& path, int eliminatedPlayer);


signals:
    void nextTurnRequested();
    void resetRequested();

private slots:
    void on_nextTurnButton_clicked();
    void on_resetButton_clicked();

protected:
    void resizeEvent(QResizeEvent *event) override;

private:
    Ui::GameWindow *ui;
    void setupPlayersUI(int count);
    void repositionPlayers();
    std::vector<QLabel*> playerLabels;
    std::vector<QString> originalStyles;
};

#endif
