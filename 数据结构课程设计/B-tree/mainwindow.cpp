#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QTime>
#include <QVector>
#include <QTextCursor>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setupUI();
    updateDisplay();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setupUI()
{
    // 创建并设置自定义的BTreeWidget
    m_treeWidget = new BTreeWidget(this);
    ui->treeScrollArea->setWidget(m_treeWidget);
    
    // 连接信号槽
    connect(ui->insertButton, &QPushButton::clicked, this, &MainWindow::onInsertClicked);
    connect(ui->deleteButton, &QPushButton::clicked, this, &MainWindow::onDeleteClicked);
    connect(ui->searchButton, &QPushButton::clicked, this, &MainWindow::onSearchClicked);
    connect(ui->clearButton, &QPushButton::clicked, this, &MainWindow::onClearClicked);
    connect(ui->testDataButton, &QPushButton::clicked, this, &MainWindow::onInsertTestDataClicked);
    connect(ui->traverseButton, &QPushButton::clicked, this, &MainWindow::onTraverseClicked);
    
    // 允许回车键触发插入
    connect(ui->keyInput, &QLineEdit::returnPressed, this, &MainWindow::onInsertClicked);
}

void MainWindow::onInsertClicked()
{
    bool ok;
    int key = ui->keyInput->text().toInt(&ok);
    
    if (!ok) {
        QMessageBox::warning(this, "输入错误", "请输入一个有效的整数！");
        return;
    }
    
    // 检查关键字是否已经存在
    if (m_tree.search(key) != nullptr) {
        showMessage(QString("数值 %1 已存在于树中！").arg(key));
        return;
    }
    
    m_tree.insert(key);
    showMessage(QString("已插入数值: %1").arg(key));
    updateDisplay();
    ui->keyInput->clear();
    ui->keyInput->setFocus();
}

void MainWindow::onDeleteClicked()
{
    bool ok;
    int key = ui->keyInput->text().toInt(&ok);
    
    if (!ok) {
        QMessageBox::warning(this, "输入错误", "请输入一个有效的整数！");
        return;
    }
    
    if (m_tree.search(key) == nullptr) {
        showMessage(QString("数值 %1 在树中不存在！").arg(key));
        return;
    }
    
    m_tree.remove(key);
    showMessage(QString("已删除数值: %1").arg(key));
    updateDisplay();
    ui->keyInput->clear();
    ui->keyInput->setFocus();
}

void MainWindow::onSearchClicked()
{
    bool ok;
    int key = ui->keyInput->text().toInt(&ok);
    
    if (!ok) {
        QMessageBox::warning(this, "输入错误", "请输入一个有效的整数！");
        return;
    }
    
    BTreeNode* result = m_tree.search(key);
    if (result != nullptr) {
        showMessage(QString("数值 %1 在树中找到了！").arg(key));
        m_treeWidget->highlightKey(key);
    } else {
        showMessage(QString("数值 %1 在树中未找到！").arg(key));
        m_treeWidget->clearHighlight();
    }
    
    ui->keyInput->clear();
    ui->keyInput->setFocus();
}

void MainWindow::onClearClicked()
{
    if (QMessageBox::question(this, "确认清空", 
                             "您确定要清空整棵树吗？",
                             QMessageBox::Yes | QMessageBox::No) == QMessageBox::Yes) {
        m_tree.clear();
        showMessage("树已清空成功！");
        updateDisplay();
    }
}

void MainWindow::onInsertTestDataClicked()
{
    QVector<int> testKeys = {10, 20, 5, 6, 12, 30, 7, 17};
    
    QString insertedKeys;
    for (int key : testKeys) {
        if (m_tree.search(key) == nullptr) {  // 只在还不存在时才插入
            m_tree.insert(key);
            insertedKeys += QString::number(key) + " ";
        }
    }
    
    if (!insertedKeys.isEmpty()) {
        showMessage("已插入测试数据: " + insertedKeys.trimmed());
        updateDisplay();
    } else {
        showMessage("所有测试数据都已存在于树中！");
    }
}

void MainWindow::onTraverseClicked()
{
    QString traversal = m_tree.getTraversalString();
    if (traversal.isEmpty()) {
        showMessage("树为空 - 无法进行遍历");
    } else {
        showMessage("中序遍历结果: " + traversal);
    }
}

void MainWindow::updateDisplay()
{
    m_treeWidget->setTree(&m_tree);
    
    // 更新状态
    QString status = m_tree.isEmpty() ? "树为空" : "树包含数据";
    ui->statusLabel->setText(status);
}

void MainWindow::showMessage(const QString &message)
{
    ui->logOutput->append(QString("[%1] %2")
                       .arg(QTime::currentTime().toString("hh:mm:ss"))
                       .arg(message));
    
    // 自动滚动到底部
    QTextCursor cursor = ui->logOutput->textCursor();
    cursor.movePosition(QTextCursor::End);
    ui->logOutput->setTextCursor(cursor);
}
