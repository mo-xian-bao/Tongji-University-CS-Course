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
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QScrollArea>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QVBoxLayout *mainLayout;
    QGroupBox *controlGroup;
    QHBoxLayout *controlLayout;
    QLabel *keyLabel;
    QLineEdit *keyInput;
    QPushButton *insertButton;
    QPushButton *deleteButton;
    QPushButton *searchButton;
    QPushButton *clearButton;
    QPushButton *testDataButton;
    QPushButton *traverseButton;
    QSpacerItem *horizontalSpacer;
    QScrollArea *treeScrollArea;
    QGroupBox *logGroup;
    QVBoxLayout *logLayout;
    QTextEdit *logOutput;
    QLabel *statusLabel;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(713, 454);
        MainWindow->setMinimumSize(QSize(500, 300));
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        mainLayout = new QVBoxLayout(centralwidget);
        mainLayout->setObjectName("mainLayout");
        controlGroup = new QGroupBox(centralwidget);
        controlGroup->setObjectName("controlGroup");
        controlLayout = new QHBoxLayout(controlGroup);
        controlLayout->setObjectName("controlLayout");
        keyLabel = new QLabel(controlGroup);
        keyLabel->setObjectName("keyLabel");

        controlLayout->addWidget(keyLabel);

        keyInput = new QLineEdit(controlGroup);
        keyInput->setObjectName("keyInput");
        keyInput->setMaximumSize(QSize(120, 16777215));

        controlLayout->addWidget(keyInput);

        insertButton = new QPushButton(controlGroup);
        insertButton->setObjectName("insertButton");

        controlLayout->addWidget(insertButton);

        deleteButton = new QPushButton(controlGroup);
        deleteButton->setObjectName("deleteButton");

        controlLayout->addWidget(deleteButton);

        searchButton = new QPushButton(controlGroup);
        searchButton->setObjectName("searchButton");

        controlLayout->addWidget(searchButton);

        clearButton = new QPushButton(controlGroup);
        clearButton->setObjectName("clearButton");

        controlLayout->addWidget(clearButton);

        testDataButton = new QPushButton(controlGroup);
        testDataButton->setObjectName("testDataButton");

        controlLayout->addWidget(testDataButton);

        traverseButton = new QPushButton(controlGroup);
        traverseButton->setObjectName("traverseButton");

        controlLayout->addWidget(traverseButton);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Minimum);

        controlLayout->addItem(horizontalSpacer);


        mainLayout->addWidget(controlGroup);

        treeScrollArea = new QScrollArea(centralwidget);
        treeScrollArea->setObjectName("treeScrollArea");
        QSizePolicy sizePolicy(QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(1);
        sizePolicy.setHeightForWidth(treeScrollArea->sizePolicy().hasHeightForWidth());
        treeScrollArea->setSizePolicy(sizePolicy);
        treeScrollArea->setMinimumSize(QSize(0, 400));
        treeScrollArea->setWidgetResizable(true);

        mainLayout->addWidget(treeScrollArea);

        logGroup = new QGroupBox(centralwidget);
        logGroup->setObjectName("logGroup");
        logLayout = new QVBoxLayout(logGroup);
        logLayout->setObjectName("logLayout");
        logOutput = new QTextEdit(logGroup);
        logOutput->setObjectName("logOutput");
        logOutput->setMaximumSize(QSize(16777215, 150));
        logOutput->setReadOnly(true);

        logLayout->addWidget(logOutput);


        mainLayout->addWidget(logGroup);

        statusLabel = new QLabel(centralwidget);
        statusLabel->setObjectName("statusLabel");
        statusLabel->setStyleSheet(QString::fromUtf8("QLabel { padding: 5px; background-color: #f0f0f0; }"));

        mainLayout->addWidget(statusLabel);

        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName("menubar");
        menubar->setGeometry(QRect(0, 0, 713, 18));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName("statusbar");
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "B\346\240\221\345\217\257\350\247\206\345\214\226\347\263\273\347\273\237 - 3\351\230\266B\346\240\221", nullptr));
        controlGroup->setTitle(QCoreApplication::translate("MainWindow", "B\346\240\221\346\223\215\344\275\234", nullptr));
        keyLabel->setText(QCoreApplication::translate("MainWindow", "\346\225\260\345\200\274:", nullptr));
        keyInput->setPlaceholderText(QCoreApplication::translate("MainWindow", "\350\257\267\350\276\223\345\205\245\346\225\260\345\200\274...", nullptr));
        insertButton->setText(QCoreApplication::translate("MainWindow", "\346\217\222\345\205\245", nullptr));
        deleteButton->setText(QCoreApplication::translate("MainWindow", "\345\210\240\351\231\244", nullptr));
        searchButton->setText(QCoreApplication::translate("MainWindow", "\346\237\245\346\211\276", nullptr));
        clearButton->setText(QCoreApplication::translate("MainWindow", "\346\270\205\347\251\272\346\240\221", nullptr));
        testDataButton->setText(QCoreApplication::translate("MainWindow", "\346\217\222\345\205\245\346\265\213\350\257\225\346\225\260\346\215\256", nullptr));
        traverseButton->setText(QCoreApplication::translate("MainWindow", "\351\201\215\345\216\206", nullptr));
        logGroup->setTitle(QCoreApplication::translate("MainWindow", "\346\223\215\344\275\234\346\227\245\345\277\227", nullptr));
        statusLabel->setText(QCoreApplication::translate("MainWindow", "\345\260\261\347\273\252 - B\346\240\221\344\270\272\347\251\272", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
