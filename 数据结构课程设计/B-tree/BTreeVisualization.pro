QT += core widgets

CONFIG += c++11

TARGET = BTreeVisualization
TEMPLATE = app

SOURCES += \
    main_qt.cpp \
    mainwindow.cpp \
    btreewidget.cpp \
    btree.cpp

HEADERS += \
    mainwindow.h \
    btreewidget.h \
    btree.h

FORMS += \
    mainwindow.ui
