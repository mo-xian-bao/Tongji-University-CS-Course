#include "gamewindow.h"
#include "ui_gamewindow.h"
#include <QPainter>
#include <QPropertyAnimation>
#include <QSequentialAnimationGroup>
#include <QParallelAnimationGroup>
#include <QPauseAnimation>
#include <QResizeEvent>
#include <QTimer>
#include <cmath>

GameWindow::GameWindow(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::GameWindow)
{
    ui->setupUi(this);
}

GameWindow::~GameWindow()
{
    delete ui;
}

void GameWindow::setPlayerCount(int count)
{
    setupPlayersUI(count);
    ui->remainingCountLabel->setText(QString::number(count));
}

void GameWindow::setupPlayersUI(int count)
{
    // 先把之前的玩家控件清掉
    for (QLabel* label : playerLabels) {
        delete label;
    }
    playerLabels.clear();
    originalStyles.clear();

    // 先创建玩家的小圆圈控件（先不摆位置，等resize时再布局）
    for (int i = 0; i < count; ++i) {
        QLabel *playerLabel = new QLabel(QString::number(i + 1), ui->visualizationWidget);
        playerLabel->setFixedSize(50, 50);
        playerLabel->setAlignment(Qt::AlignCenter);
        QString style = "border: 2px solid green; border-radius: 25px; background-color: lightgreen; font-size: 16pt;";
        playerLabel->setStyleSheet(style);
        playerLabel->setObjectName(QString("player_%1").arg(i + 1));
        playerLabel->show();
        playerLabels.push_back(playerLabel);
        originalStyles.push_back(style);
    }

    // 现在创建好了控件，先调用一次定位；窗口大小变化时会再定位
    repositionPlayers();
}

void GameWindow::repositionPlayers()
{
    // 没有玩家就秒退
    if (playerLabels.empty()) return;

    int count = playerLabels.size();
    int radius = qMin(ui->visualizationWidget->width(), ui->visualizationWidget->height()) / 2 - 30;
    QPoint center(ui->visualizationWidget->width() / 2, ui->visualizationWidget->height() / 2);

    for (int i = 0; i < count; ++i) {
    double angle = 2 * M_PI * i / count - M_PI / 2; // 从顶部开始摆放
        int x = center.x() + radius * cos(angle) - 25;
        int y = center.y() + radius * sin(angle) - 25;
        playerLabels[i]->move(x, y);
    }
}

// 窗口尺寸变了（包括第一次显示），重新摆位置
void GameWindow::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    repositionPlayers();
}

void GameWindow::updateLog(const QString& message)
{
    ui->logBrowser->append(message);
}

void GameWindow::eliminatePlayer(int playerNumber)
{
    if (playerNumber > 0 && playerNumber <= playerLabels.size()) {
        QLabel *playerLabel = playerLabels[playerNumber - 1];
        QString eliminatedStyle = "border: 2px solid red; border-radius: 25px; background-color: #FFC0CB; font-size: 16pt;";
        playerLabel->setStyleSheet(eliminatedStyle);
            // 更新记录，表示这个玩家现在是被淘汰的样式
            originalStyles[playerNumber - 1] = eliminatedStyle;
    }
    int currentRemaining = ui->remainingCountLabel->text().toInt();
    ui->remainingCountLabel->setText(QString::number(currentRemaining - 1));
}

void GameWindow::animateElimination(const std::vector<int>& path, int eliminatedPlayer)
{
    if (path.empty()) {
        eliminatePlayer(eliminatedPlayer);
        return;
    }

    const int intervalMs = 300;
    ui->nextTurnButton->setEnabled(false);

    // 用定时器一个步子一个步子地高亮（扫描效果）
    for (size_t i = 0; i < path.size(); ++i) {
        int playerNum = path[i];
        QTimer::singleShot(static_cast<int>(i) * intervalMs, this, [this, playerNum, i, path]() {
            // 把当前数到的玩家标成黄色
            if (playerNum > 0 && playerNum <= static_cast<int>(playerLabels.size())) {
                QLabel *cur = playerLabels[playerNum - 1];
                cur->setStyleSheet("border: 2px solid yellow; border-radius: 25px; background-color: yellow; font-size: 16pt;");
            }

            // 把上一个玩家还原到它原来的样式（可能是绿的或红的）
            if (i > 0) {
                int prevNum = path[i - 1];
                if (prevNum > 0 && prevNum <= static_cast<int>(playerLabels.size())) {
                    QLabel *prev = playerLabels[prevNum - 1];
                    prev->setStyleSheet(originalStyles[prevNum - 1]);
                }
            }
        });
    }

    // 扫描到最后一步后，先还原最后一个，再把被淘汰者标成红色
    QTimer::singleShot(static_cast<int>(path.size()) * intervalMs, this, [this, path, eliminatedPlayer]() {
        if (!path.empty()) {
            int lastNum = path.back();
            if (lastNum > 0 && lastNum <= static_cast<int>(playerLabels.size())) {
                playerLabels[lastNum - 1]->setStyleSheet(originalStyles[lastNum - 1]);
            }
        }
        eliminatePlayer(eliminatedPlayer);
        ui->nextTurnButton->setEnabled(true);
    });
}


void GameWindow::on_nextTurnButton_clicked()
{
    emit nextTurnRequested();
}

void GameWindow::on_resetButton_clicked()
{
    emit resetRequested();
}

void GameWindow::disableNextTurnButton()
{
    ui->nextTurnButton->setEnabled(false);
}

