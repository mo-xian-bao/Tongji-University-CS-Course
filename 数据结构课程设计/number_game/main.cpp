#include <QApplication>
#include "NumberGameWidget.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    NumberGameWidget widget;
    widget.show();
    
    return app.exec();
}
