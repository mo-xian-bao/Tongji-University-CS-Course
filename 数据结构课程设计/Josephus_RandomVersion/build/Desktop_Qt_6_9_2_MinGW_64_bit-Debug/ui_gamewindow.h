/********************************************************************************
** Form generated from reading UI file 'gamewindow.ui'
**
** Created by: Qt User Interface Compiler version 6.9.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GAMEWINDOW_H
#define UI_GAMEWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_GameWindow
{
public:
    QHBoxLayout *horizontalLayout;
    QWidget *visualizationWidget;
    QVBoxLayout *verticalLayout;
    QGroupBox *controlGroup;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label;
    QLabel *remainingCountLabel;
    QPushButton *nextTurnButton;
    QPushButton *resetButton;
    QGroupBox *logGroup;
    QVBoxLayout *verticalLayout_3;
    QTextBrowser *logBrowser;

    void setupUi(QWidget *GameWindow)
    {
        if (GameWindow->objectName().isEmpty())
            GameWindow->setObjectName("GameWindow");
        GameWindow->resize(618, 389);
        horizontalLayout = new QHBoxLayout(GameWindow);
        horizontalLayout->setObjectName("horizontalLayout");
        visualizationWidget = new QWidget(GameWindow);
        visualizationWidget->setObjectName("visualizationWidget");
        QSizePolicy sizePolicy(QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(visualizationWidget->sizePolicy().hasHeightForWidth());
        visualizationWidget->setSizePolicy(sizePolicy);

        horizontalLayout->addWidget(visualizationWidget);

        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName("verticalLayout");
        controlGroup = new QGroupBox(GameWindow);
        controlGroup->setObjectName("controlGroup");
        verticalLayout_2 = new QVBoxLayout(controlGroup);
        verticalLayout_2->setObjectName("verticalLayout_2");
        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName("horizontalLayout_2");
        label = new QLabel(controlGroup);
        label->setObjectName("label");

        horizontalLayout_2->addWidget(label);

        remainingCountLabel = new QLabel(controlGroup);
        remainingCountLabel->setObjectName("remainingCountLabel");

        horizontalLayout_2->addWidget(remainingCountLabel);


        verticalLayout_2->addLayout(horizontalLayout_2);

        nextTurnButton = new QPushButton(controlGroup);
        nextTurnButton->setObjectName("nextTurnButton");

        verticalLayout_2->addWidget(nextTurnButton);

        resetButton = new QPushButton(controlGroup);
        resetButton->setObjectName("resetButton");

        verticalLayout_2->addWidget(resetButton);


        verticalLayout->addWidget(controlGroup);

        logGroup = new QGroupBox(GameWindow);
        logGroup->setObjectName("logGroup");
        verticalLayout_3 = new QVBoxLayout(logGroup);
        verticalLayout_3->setObjectName("verticalLayout_3");
        logBrowser = new QTextBrowser(logGroup);
        logBrowser->setObjectName("logBrowser");

        verticalLayout_3->addWidget(logBrowser);


        verticalLayout->addWidget(logGroup);


        horizontalLayout->addLayout(verticalLayout);

        horizontalLayout->setStretch(0, 2);
        horizontalLayout->setStretch(1, 1);

        retranslateUi(GameWindow);

        QMetaObject::connectSlotsByName(GameWindow);
    } // setupUi

    void retranslateUi(QWidget *GameWindow)
    {
        GameWindow->setWindowTitle(QCoreApplication::translate("GameWindow", "Josephus Game", nullptr));
        controlGroup->setTitle(QCoreApplication::translate("GameWindow", "\346\270\270\346\210\217\346\216\247\345\210\266", nullptr));
        label->setText(QCoreApplication::translate("GameWindow", "\345\211\251\344\275\231\344\272\272\346\225\260:", nullptr));
        remainingCountLabel->setText(QCoreApplication::translate("GameWindow", "0", nullptr));
        nextTurnButton->setText(QCoreApplication::translate("GameWindow", "\344\270\213\344\270\200\346\255\245", nullptr));
        resetButton->setText(QCoreApplication::translate("GameWindow", "\351\207\215\347\275\256\350\277\224\345\233\236", nullptr));
        logGroup->setTitle(QCoreApplication::translate("GameWindow", "\346\227\245\345\277\227", nullptr));
    } // retranslateUi

};

namespace Ui {
    class GameWindow: public Ui_GameWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GAMEWINDOW_H
