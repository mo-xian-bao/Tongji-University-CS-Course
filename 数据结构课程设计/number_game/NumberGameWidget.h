#ifndef NUMBERGAMEWIDGET_H
#define NUMBERGAMEWIDGET_H

#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QLabel>
#include <QTextEdit>
#include <QSpinBox>
#include <QProgressBar>
#include <QTimer>
#include <QGroupBox>
#include <QMessageBox>
#include <QList>
#include <QGraphicsView>
#include <QGraphicsScene>
#include <QGraphicsEllipseItem>
#include <QGraphicsTextItem>
#include <QPropertyAnimation>
#include <QSequentialAnimationGroup>
#include <QParallelAnimationGroup>
#include <QEasingCurve>
#include <QRandomGenerator>
#include <QPainter>
#include <QPainterPath>
#include <QBrush>
#include <QPen>
#include <cmath>

struct Person {
    int id;
    bool isActive;
    QGraphicsEllipseItem* circle;
    QGraphicsTextItem* text;
    
    Person(int id) : id(id), isActive(true), circle(nullptr), text(nullptr) {}
};

class NumberGameWidget : public QWidget
{
    Q_OBJECT

public:
    NumberGameWidget(QWidget *parent = nullptr);
    ~NumberGameWidget();

private slots:
    void startGame();
    void resetGame();
    void nextStep();
    void onAnimationFinished();

private:
    void setupUI();
    void setupGameArea();
    void updateGameDisplay();
    void animateThrow();
    void animateCount(int steps);
    void eliminatePerson(int index);
    void showResults();
    int rollDice();
    int getNextActiveIndex(int current);
    int countActivePeople();
    void highlightCurrentThrower();
    void clearHighlights();

    // UI Components
    QVBoxLayout* mainLayout;
    QHBoxLayout* topLayout;
    QHBoxLayout* bottomLayout;
    
    QGroupBox* inputGroup;
    QGroupBox* controlGroup;
    QGroupBox* gameGroup;
    QGroupBox* outputGroup;
    
    QSpinBox* peopleCountSpinBox;
    QPushButton* startButton;
    QPushButton* resetButton;
    QPushButton* nextStepButton;
    
    QGraphicsView* gameView;
    QGraphicsScene* gameScene;
    
    QTextEdit* logTextEdit;
    QLabel* statusLabel;
    QLabel* diceLabel;
    QProgressBar* progressBar;
    
    // Game Logic
    QList<Person*> people;
    QList<int> eliminationOrder;
    int currentThrower;
    int totalPeople;
    bool gameStarted;
    bool gameFinished;
    int step;
    
    // Animation
    QTimer* animationTimer;
    QPropertyAnimation* currentAnimation;
    QSequentialAnimationGroup* animationGroup;
    
    // Visual Constants
    static const int CIRCLE_RADIUS = 30;
    static const int SCENE_SIZE = 400;
    static const QColor ACTIVE_COLOR;
    static const QColor ELIMINATED_COLOR;
    static const QColor CURRENT_COLOR;
    static const QColor COUNTING_COLOR;
};

#endif // NUMBERGAMEWIDGET_H
