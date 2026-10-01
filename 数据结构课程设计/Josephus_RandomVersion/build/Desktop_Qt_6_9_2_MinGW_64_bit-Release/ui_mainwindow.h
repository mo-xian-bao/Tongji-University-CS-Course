/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.9.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QFrame *frame;
    QVBoxLayout *verticalLayout_2;
    QVBoxLayout *verticalLayout;
    QSpacerItem *verticalSpacer_2;
    QLabel *label;
    QSpacerItem *verticalSpacer;
    QSpacerItem *verticalSpacer_4;
    QSpacerItem *verticalSpacer_5;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label_2;
    QSpinBox *playerNumber;
    QSpacerItem *verticalSpacer_3;
    QPushButton *startGameButton;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(619, 357);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        frame = new QFrame(centralwidget);
        frame->setObjectName("frame");
        frame->setGeometry(QRect(70, 30, 481, 271));
        frame->setFrameShape(QFrame::Shape::Panel);
        frame->setFrameShadow(QFrame::Shadow::Raised);
        frame->setLineWidth(2);
        verticalLayout_2 = new QVBoxLayout(frame);
        verticalLayout_2->setObjectName("verticalLayout_2");
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName("verticalLayout");
        verticalSpacer_2 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout->addItem(verticalSpacer_2);

        label = new QLabel(frame);
        label->setObjectName("label");
        QFont font;
        font.setPointSize(24);
        label->setFont(font);

        verticalLayout->addWidget(label, 0, Qt::AlignmentFlag::AlignHCenter);

        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout->addItem(verticalSpacer);

        verticalSpacer_4 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout->addItem(verticalSpacer_4);

        verticalSpacer_5 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout->addItem(verticalSpacer_5);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName("horizontalLayout_2");
        label_2 = new QLabel(frame);
        label_2->setObjectName("label_2");
        QFont font1;
        font1.setPointSize(12);
        label_2->setFont(font1);

        horizontalLayout_2->addWidget(label_2, 0, Qt::AlignmentFlag::AlignRight);

        playerNumber = new QSpinBox(frame);
        playerNumber->setObjectName("playerNumber");

        horizontalLayout_2->addWidget(playerNumber, 0, Qt::AlignmentFlag::AlignLeft);


        verticalLayout->addLayout(horizontalLayout_2);

        verticalSpacer_3 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout->addItem(verticalSpacer_3);

        startGameButton = new QPushButton(frame);
        startGameButton->setObjectName("startGameButton");
        startGameButton->setMinimumSize(QSize(463, 0));
        startGameButton->setMaximumSize(QSize(463, 16777215));
        QFont font2;
        font2.setPointSize(18);
        startGameButton->setFont(font2);

        verticalLayout->addWidget(startGameButton, 0, Qt::AlignmentFlag::AlignHCenter);


        verticalLayout_2->addLayout(verticalLayout);

        MainWindow->setCentralWidget(centralwidget);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName("statusbar");
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "\347\272\246\347\221\237\345\244\253\347\216\257\346\270\270\346\210\217-\351\252\260\345\255\220\347\211\210", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow", "\350\257\267\351\200\211\346\213\251\346\270\270\346\210\217\344\272\272\346\225\260\357\274\232", nullptr));
        startGameButton->setText(QCoreApplication::translate("MainWindow", "\345\274\200\345\247\213\346\270\270\346\210\217\357\274\201", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
