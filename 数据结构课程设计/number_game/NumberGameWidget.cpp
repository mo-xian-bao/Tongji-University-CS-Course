#include "NumberGameWidget.h"

const QColor NumberGameWidget::ACTIVE_COLOR = QColor(100, 200, 100);
const QColor NumberGameWidget::ELIMINATED_COLOR = QColor(200, 100, 100);
const QColor NumberGameWidget::CURRENT_COLOR = QColor(255, 215, 0);
const QColor NumberGameWidget::COUNTING_COLOR = QColor(100, 150, 255);

NumberGameWidget::NumberGameWidget(QWidget *parent)
    : QWidget(parent)
    , gameStarted(false)
    , gameFinished(false)
    , currentThrower(0)
    , step(0)
    , totalPeople(0)
    , animationTimer(new QTimer(this))
    , currentAnimation(nullptr)
    , animationGroup(new QSequentialAnimationGroup(this))
{
    setupUI();
    
    connect(animationTimer, &QTimer::timeout, this, &NumberGameWidget::nextStep);
    connect(animationGroup, &QSequentialAnimationGroup::finished, 
            this, &NumberGameWidget::onAnimationFinished);
}

NumberGameWidget::~NumberGameWidget()
{
    resetGame();
}

void NumberGameWidget::setupUI()
{
    setWindowTitle("数字游戏 - 约瑟夫环变种");
    setMinimumSize(800, 600);
    
    mainLayout = new QVBoxLayout(this);
    topLayout = new QHBoxLayout();
    bottomLayout = new QHBoxLayout();
    
    // 输入区域
    inputGroup = new QGroupBox("游戏设置");
    QHBoxLayout* inputLayout = new QHBoxLayout(inputGroup);
    
    inputLayout->addWidget(new QLabel("人数:"));
    peopleCountSpinBox = new QSpinBox();
    peopleCountSpinBox->setRange(3, 20);
    peopleCountSpinBox->setValue(7);
    inputLayout->addWidget(peopleCountSpinBox);
    
    inputLayout->addStretch();
    
    // 控制区域
    controlGroup = new QGroupBox("游戏控制");
    QHBoxLayout* controlLayout = new QHBoxLayout(controlGroup);
    
    startButton = new QPushButton("开始游戏");
    resetButton = new QPushButton("重置游戏");
    nextStepButton = new QPushButton("下一步");
    nextStepButton->setEnabled(false);
    
    controlLayout->addWidget(startButton);
    controlLayout->addWidget(nextStepButton);
    controlLayout->addWidget(resetButton);
    
    connect(startButton, &QPushButton::clicked, this, &NumberGameWidget::startGame);
    connect(resetButton, &QPushButton::clicked, this, &NumberGameWidget::resetGame);
    connect(nextStepButton, &QPushButton::clicked, this, &NumberGameWidget::nextStep);
    
    topLayout->addWidget(inputGroup);
    topLayout->addWidget(controlGroup);
    
    // 游戏区域
    setupGameArea();
    
    // 输出区域
    outputGroup = new QGroupBox("游戏日志");
    QVBoxLayout* outputLayout = new QVBoxLayout(outputGroup);
    
    statusLabel = new QLabel("准备开始游戏...");
    statusLabel->setStyleSheet("QLabel { font-weight: bold; color: blue; }");
    
    diceLabel = new QLabel("骰子点数: -");
    diceLabel->setStyleSheet("QLabel { font-size: 14px; color: red; }");
    
    progressBar = new QProgressBar();
    progressBar->setVisible(false);
    
    logTextEdit = new QTextEdit();
    logTextEdit->setMaximumHeight(150);
    logTextEdit->setReadOnly(true);
    
    outputLayout->addWidget(statusLabel);
    outputLayout->addWidget(diceLabel);
    outputLayout->addWidget(progressBar);
    outputLayout->addWidget(logTextEdit);
    
    bottomLayout->addWidget(gameGroup);
    bottomLayout->addWidget(outputGroup);
    
    mainLayout->addLayout(topLayout);
    mainLayout->addLayout(bottomLayout);
}

void NumberGameWidget::setupGameArea()
{
    gameGroup = new QGroupBox("游戏圆圈");
    QVBoxLayout* gameLayout = new QVBoxLayout(gameGroup);
    
    gameView = new QGraphicsView();
    gameScene = new QGraphicsScene();
    gameView->setScene(gameScene);
    gameView->setRenderHint(QPainter::Antialiasing);
    gameView->setFixedSize(SCENE_SIZE + 50, SCENE_SIZE + 50);
    gameScene->setSceneRect(-SCENE_SIZE/2, -SCENE_SIZE/2, SCENE_SIZE, SCENE_SIZE);
    
    gameLayout->addWidget(gameView);
}

void NumberGameWidget::startGame()
{
    if (gameStarted && !gameFinished) {
        QMessageBox::information(this, "提示", "游戏正在进行中！");
        return;
    }
    
    resetGame();
    
    totalPeople = peopleCountSpinBox->value();
    
    // 创建人员对象
    people.clear();
    eliminationOrder.clear();
    
    double angleStep = 2 * M_PI / totalPeople;
    double radius = (SCENE_SIZE - 2 * CIRCLE_RADIUS) / 2.5;
    
    for (int i = 0; i < totalPeople; i++) {
        Person* person = new Person(i + 1);
        
        // 计算位置 (顺时针排列，从顶部开始)
        double angle = -M_PI/2 + i * angleStep;
        double x = radius * cos(angle);
        double y = radius * sin(angle);
        
        // 创建圆形
        person->circle = gameScene->addEllipse(
            x - CIRCLE_RADIUS/2, y - CIRCLE_RADIUS/2,
            CIRCLE_RADIUS, CIRCLE_RADIUS,
            QPen(Qt::black, 2),
            QBrush(ACTIVE_COLOR)
        );
        
        // 创建文本
        person->text = gameScene->addText(QString::number(person->id));
        person->text->setPos(x - 10, y - 10);
        person->text->setFont(QFont("Arial", 12, QFont::Bold));
        
        people.append(person);
    }
    
    currentThrower = 0;
    gameStarted = true;
    gameFinished = false;
    step = 0;
    
    startButton->setEnabled(false);
    nextStepButton->setEnabled(true);
    peopleCountSpinBox->setEnabled(false);
    
    statusLabel->setText(QString("游戏开始！当前投掷者：%1号").arg(people[currentThrower]->id));
    logTextEdit->append(QString("=== 游戏开始，共%1人 ===").arg(totalPeople));
    
    highlightCurrentThrower();
    updateGameDisplay();
}

void NumberGameWidget::resetGame()
{
    gameStarted = false;
    gameFinished = false;
    currentThrower = 0;
    step = 0;
    
    // 清理场景
    gameScene->clear();
    
    // 清理人员列表
    for (Person* person : people) {
        delete person;
    }
    people.clear();
    eliminationOrder.clear();
    
    // 重置UI
    startButton->setEnabled(true);
    nextStepButton->setEnabled(false);
    peopleCountSpinBox->setEnabled(true);
    
    statusLabel->setText("准备开始游戏...");
    diceLabel->setText("骰子点数: -");
    logTextEdit->clear();
    progressBar->setVisible(false);
    
    if (animationGroup->state() == QSequentialAnimationGroup::Running) {
        animationGroup->stop();
    }
}

void NumberGameWidget::nextStep()
{
    if (!gameStarted || gameFinished) {
        return;
    }
    
    step++;
    
    // 投掷骰子
    int diceResult = rollDice();
    diceLabel->setText(QString("骰子点数: %1").arg(diceResult));
    
    statusLabel->setText(QString("第%1轮：%2号投出%3点").arg(step).arg(people[currentThrower]->id).arg(diceResult));
    logTextEdit->append(QString("第%1轮：%2号投掷骰子，得到%3点").arg(step).arg(people[currentThrower]->id).arg(diceResult));
    
    // 从当前投掷者开始计数
    int countIndex = currentThrower;
    int count = 0;
    
    // 执行计数动画
    animateCount(diceResult);
}

void NumberGameWidget::animateCount(int steps)
{
    // 清除之前的高亮
    clearHighlights();
    
    // 高亮当前投掷者
    people[currentThrower]->circle->setBrush(QBrush(CURRENT_COLOR));
    
    // 开始计数动画
    int countIndex = currentThrower;
    
    for (int i = 1; i <= steps; i++) {
        // 找到下一个活跃的人
        if (i > 1) {
            countIndex = getNextActiveIndex(countIndex);
        }
        
        // 创建高亮动画
        QPropertyAnimation* highlightAnim = new QPropertyAnimation();
        highlightAnim->setDuration(500);
        
        // 使用lambda来捕获countIndex
        int currentIndex = countIndex;
        QTimer::singleShot(i * 500, [this, currentIndex, i, steps]() {
            if (currentIndex < people.size() && people[currentIndex]->isActive) {
                // 高亮计数的人
                people[currentIndex]->circle->setBrush(QBrush(COUNTING_COLOR));
                
                if (i == steps) {
                    // 最后一个人，准备淘汰
                    QTimer::singleShot(500, [this, currentIndex]() {
                        eliminatePerson(currentIndex);
                    });
                }
            }
        });
    }
}

void NumberGameWidget::eliminatePerson(int index)
{
    if (index >= people.size() || !people[index]->isActive) {
        return;
    }
    
    Person* person = people[index];
    person->isActive = false;
    person->circle->setBrush(QBrush(ELIMINATED_COLOR));
    
    eliminationOrder.append(person->id);
    
    logTextEdit->append(QString(">>> %1号被淘汰！").arg(person->id));
    
    // 检查游戏是否结束
    int activeCount = countActivePeople();
    if (activeCount == 1) {
        // 游戏结束
        for (Person* p : people) {
            if (p->isActive) {
                statusLabel->setText(QString("游戏结束！获胜者：%1号").arg(p->id));
                logTextEdit->append(QString("🎉 游戏结束！获胜者是：%1号").arg(p->id));
                p->circle->setBrush(QBrush(QColor(255, 215, 0))); // 金色
                break;
            }
        }
        showResults();
        gameFinished = true;
        nextStepButton->setEnabled(false);
        startButton->setEnabled(true);
        peopleCountSpinBox->setEnabled(true);
    } else {
        // 找到下一个投掷者
        currentThrower = getNextActiveIndex(index);
        
        // 延迟一秒后继续
        QTimer::singleShot(1000, [this]() {
            clearHighlights();
            highlightCurrentThrower();
            statusLabel->setText(QString("下一个投掷者：%1号").arg(people[currentThrower]->id));
        });
    }
    
    updateGameDisplay();
}

void NumberGameWidget::showResults()
{
    logTextEdit->append("\n=== 淘汰顺序 ===");
    for (int i = 0; i < eliminationOrder.size(); i++) {
        logTextEdit->append(QString("第%1个淘汰：%2号").arg(i + 1).arg(eliminationOrder[i]));
    }
    
    // 显示获胜者
    for (Person* p : people) {
        if (p->isActive) {
            logTextEdit->append(QString("🏆 最终获胜者：%1号").arg(p->id));
            break;
        }
    }
}

int NumberGameWidget::rollDice()
{
    return QRandomGenerator::global()->bounded(1, 7); // 1-6
}

int NumberGameWidget::getNextActiveIndex(int current)
{
    int next = (current + 1) % people.size();
    while (!people[next]->isActive) {
        next = (next + 1) % people.size();
    }
    return next;
}

int NumberGameWidget::countActivePeople()
{
    int count = 0;
    for (Person* person : people) {
        if (person->isActive) {
            count++;
        }
    }
    return count;
}

void NumberGameWidget::highlightCurrentThrower()
{
    if (currentThrower < people.size() && people[currentThrower]->isActive) {
        people[currentThrower]->circle->setBrush(QBrush(CURRENT_COLOR));
    }
}

void NumberGameWidget::clearHighlights()
{
    for (Person* person : people) {
        if (person->isActive) {
            person->circle->setBrush(QBrush(ACTIVE_COLOR));
        } else {
            person->circle->setBrush(QBrush(ELIMINATED_COLOR));
        }
    }
}

void NumberGameWidget::updateGameDisplay()
{
    // 更新进度条
    if (gameStarted && !progressBar->isVisible()) {
        progressBar->setVisible(true);
        progressBar->setRange(0, totalPeople - 1);
    }
    
    if (gameStarted) {
        progressBar->setValue(eliminationOrder.size());
    }
}

void NumberGameWidget::animateThrow()
{
    // 可以添加投掷动画效果
}

void NumberGameWidget::onAnimationFinished()
{
    // 动画完成后的处理
}
