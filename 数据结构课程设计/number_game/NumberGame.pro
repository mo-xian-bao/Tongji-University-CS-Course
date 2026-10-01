QT += core widgets

CONFIG += c++17

TARGET = NumberGame

SOURCES += \
    main.cpp \
    NumberGameWidget.cpp

HEADERS += \
    NumberGameWidget.h

# Enable automatic MOC processing
CONFIG += moc

# Windows specific settings
win32 {
    CONFIG += console
}

# Release/Debug configurations
CONFIG(debug, debug|release) {
    DESTDIR = debug
} else {
    DESTDIR = release
}

OBJECTS_DIR = $$DESTDIR/.obj
MOC_DIR = $$DESTDIR/.moc
RCC_DIR = $$DESTDIR/.rcc
UI_DIR = $$DESTDIR/.ui
