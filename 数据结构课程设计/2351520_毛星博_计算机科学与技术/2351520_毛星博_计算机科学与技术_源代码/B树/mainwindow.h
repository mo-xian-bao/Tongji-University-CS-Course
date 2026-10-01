#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMessageBox>
#include "btreewidget.h"
#include "btree.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onInsertClicked();
    void onDeleteClicked();
    void onSearchClicked();
    void onClearClicked();
    void onInsertTestDataClicked();
    void onTraverseClicked();

private:
    void setupUI();
    void updateDisplay();
    void showMessage(const QString &message);
    
    Ui::MainWindow *ui;
    
    // 自定义组件
    BTreeWidget *m_treeWidget;
    
    // B树对象
    BTree m_tree;
};

#endif // MAINWINDOW_H
