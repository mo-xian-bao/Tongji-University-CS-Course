#ifndef BTREEWIDGET_H
#define BTREEWIDGET_H

#include <QWidget>
#include <QPainter>
#include <QVector>
#include <QPoint>
#include <QRect>
#include <QFont>
#include <QFontMetrics>
#include "btree.h"

struct NodeRect {
    QRect rect;
    BTreeNode* node;
    QVector<int> keys;
    int level;
};

class BTreeWidget : public QWidget
{
    Q_OBJECT

public:
    explicit BTreeWidget(QWidget *parent = nullptr);
    
    void setTree(BTree *tree);
    void highlightKey(int key);
    void clearHighlight();

protected:
    void paintEvent(QPaintEvent *event) override;
    QSize sizeHint() const override;

private:
    void calculateLayout();
    void drawNode(QPainter &painter, const NodeRect &nodeRect);
    void drawConnections(QPainter &painter);
    int calculateSubtreeWidth(BTreeNode *node);
    void layoutNodeCentered(BTreeNode *node, int &x, int y, int level);
    
    BTree *m_tree;
    QVector<NodeRect> m_nodeRects;
    int m_highlightedKey;
    bool m_hasHighlight;
    
    // 布局常量 - 改为私有成员变量
    int m_nodeWidth;
    int m_nodeHeight;
    int m_levelHeight;
    int m_horizontalSpacing;
    int m_keySpacing;
    
    QFont m_font;
    QFontMetrics m_fontMetrics;
};

#endif // BTREEWIDGET_H
