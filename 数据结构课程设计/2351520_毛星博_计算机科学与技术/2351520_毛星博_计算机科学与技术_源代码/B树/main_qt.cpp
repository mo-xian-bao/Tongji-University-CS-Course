#include "mainwindow.h"
#include <QApplication>
#include <QTime>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setApplicationName("B树可视化系统");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("数据结构演示程序");

    MainWindow window;
    window.show();

    return app.exec();
}
