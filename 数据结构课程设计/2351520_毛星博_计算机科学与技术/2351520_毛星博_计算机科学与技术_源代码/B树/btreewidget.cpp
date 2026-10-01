#include "btreewidget.h"
#include <QPaintEvent>
#include <QDebug>

BTreeWidget::BTreeWidget(QWidget *parent)
    : QWidget(parent)
    , m_tree(nullptr)
    , m_highlightedKey(-1)
    , m_hasHighlight(false)
    , m_nodeWidth(80)
    , m_nodeHeight(40)
    , m_levelHeight(80)
    , m_horizontalSpacing(20)
    , m_keySpacing(25)
    , m_font("Arial", 10, QFont::Bold)
    , m_fontMetrics(m_font)
{
    setMinimumSize(600, 400);
    setStyleSheet("background-color: white;");
}

void BTreeWidget::setTree(BTree *tree)
{
    m_tree = tree;
    calculateLayout();
    update();
}

void BTreeWidget::highlightKey(int key)
{
    m_highlightedKey = key;
    m_hasHighlight = true;
    update();
}

void BTreeWidget::clearHighlight()
{
    m_hasHighlight = false;
    update();
}

void BTreeWidget::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)
    
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.setFont(m_font);
    
    if (!m_tree || m_tree->isEmpty()) {
        painter.setPen(Qt::gray);
        painter.drawText(rect(), Qt::AlignCenter, "B树为空\n插入一些数据来查看可视化效果");
        return;
    }
    
    // 先画连接线
    drawConnections(painter);
    
    // 再画节点
    for (const NodeRect &nodeRect : m_nodeRects) {
        drawNode(painter, nodeRect);
    }
}

QSize BTreeWidget::sizeHint() const
{
    if (!m_tree || m_tree->isEmpty()) {
        return QSize(600, 400);
    }
    
    int maxX = 0;
    int maxY = 0;
    
    for (const NodeRect &nodeRect : m_nodeRects) {
        maxX = qMax(maxX, nodeRect.rect.right());
        maxY = qMax(maxY, nodeRect.rect.bottom());
    }
    
    return QSize(qMax(600, maxX + 50), qMax(400, maxY + 50));
}

void BTreeWidget::calculateLayout()
{
    m_nodeRects.clear();
    
    if (!m_tree || m_tree->isEmpty()) {
        return;
    }
    
    // 第一步：算出整棵树的总宽度
    int treeWidth = calculateSubtreeWidth(m_tree->getRoot());
    
    // 把整棵树放在控件中间
    int availableWidth = qMax(width(), 800); // 最小宽度
    int startX = qMax(50, (availableWidth - treeWidth) / 2);
    int nextX = startX;
    
    layoutNodeCentered(m_tree->getRoot(), nextX, 50, 0);
    
    // 调整控件大小以适应树
    int maxX = 0;
    int maxY = 0;
    for (const NodeRect &nodeRect : m_nodeRects) {
        maxX = qMax(maxX, nodeRect.rect.right());
        maxY = qMax(maxY, nodeRect.rect.bottom());
    }
    
    setMinimumSize(qMax(800, maxX + 50), qMax(400, maxY + 50));
}

void BTreeWidget::layoutNodeCentered(BTreeNode *node, int &x, int y, int level)
{
    if (!node) return;
    
    NodeRect nodeRect;
    nodeRect.node = node;
    nodeRect.level = level;
    
    // 获取节点的关键字
    for (int i = 0; i < node->getKeyCount(); i++) {
        nodeRect.keys.append(node->getKey(i));
    }
    
    // 根据关键字数量计算节点宽度
    int nodeWidth = qMax(m_nodeWidth, nodeRect.keys.size() * m_keySpacing + 20);
    
    // 如果是叶子节点，直接定位
    if (node->isLeaf()) {
        nodeRect.rect = QRect(x, y, nodeWidth, m_nodeHeight);
        m_nodeRects.append(nodeRect);
        x += nodeWidth + m_horizontalSpacing;
    } else {
        // 内部节点要先摆放所有子节点
        int childY = y + m_levelHeight;
        int childStartX = x;
        
        // 先布局所有子节点
        for (int i = 0; i <= node->getKeyCount(); i++) {
            BTreeNode *child = node->getChild(i);
            if (child) {
                layoutNodeCentered(child, x, childY, level + 1);
            }
        }
        
        // 然后把父节点放在子节点上方中间
        int childrenWidth = x - childStartX - m_horizontalSpacing;
        int parentX = childStartX + (childrenWidth - nodeWidth) / 2;
        
        nodeRect.rect = QRect(parentX, y, nodeWidth, m_nodeHeight);
        m_nodeRects.append(nodeRect);
    }
}

void BTreeWidget::drawNode(QPainter &painter, const NodeRect &nodeRect)
{
    // 节点背景
    QRect rect = nodeRect.rect;
    
    if (nodeRect.node->isLeaf()) {
        painter.setBrush(QColor(220, 255, 220));  // 叶子节点用浅绿色
    } else {
        painter.setBrush(QColor(220, 220, 255));  // 内部节点用浅蓝色
    }
    
    painter.setPen(QPen(Qt::black, 2));
    painter.drawRect(rect);
    
    // 画关键字
    painter.setPen(Qt::black);
    int keyWidth = rect.width() / nodeRect.keys.size();
    
    for (int i = 0; i < nodeRect.keys.size(); i++) {
        int key = nodeRect.keys[i];
        QRect keyRect(rect.x() + i * keyWidth, rect.y(), keyWidth, rect.height());
        
        // 如果这个关键字正在被搜索，就高亮显示
        if (m_hasHighlight && key == m_highlightedKey) {
            painter.fillRect(keyRect, QColor(255, 255, 0, 128));  // 黄色高亮
        }
        
        // 画关键字分隔线（最后一个不画）
        if (i > 0) {
            painter.drawLine(keyRect.left(), rect.top(), keyRect.left(), rect.bottom());
        }
        
        // 画关键字文本
        painter.drawText(keyRect, Qt::AlignCenter, QString::number(key));
    }
    
    // 添加节点类型标识
    painter.setPen(Qt::gray);
    QFont smallFont = m_font;
    smallFont.setPointSize(8);
    painter.setFont(smallFont);
    
    QString nodeType = nodeRect.node->isLeaf() ? "叶" : "内";
    painter.drawText(rect.adjusted(2, 2, -2, -2), Qt::AlignTop | Qt::AlignRight, nodeType);
    
    painter.setFont(m_font);
}

int BTreeWidget::calculateSubtreeWidth(BTreeNode *node)
{
    if (!node) return 0;
    
    int nodeWidth = qMax(m_nodeWidth, node->getKeyCount() * m_keySpacing + 20);
    
    if (node->isLeaf()) {
        return nodeWidth;
    }
    
    // 内部节点需要计算所有子节点的总宽度
    int childrenWidth = 0;
    int childCount = 0;
    
    for (int i = 0; i <= node->getKeyCount(); i++) {
        BTreeNode *child = node->getChild(i);
        if (child) {
            childrenWidth += calculateSubtreeWidth(child);
            childCount++;
        }
    }
    
    // 子节点之间要加间距
    if (childCount > 1) {
        childrenWidth += (childCount - 1) * m_horizontalSpacing;
    }
    
    // 返回节点宽度和子节点总宽度中较大的那个
    return qMax(nodeWidth, childrenWidth);
}

void BTreeWidget::drawConnections(QPainter &painter)
{
    painter.setPen(QPen(Qt::darkGray, 2));
    
    for (const NodeRect &nodeRect : m_nodeRects) {
        if (nodeRect.node->isLeaf()) continue;
        
        // 找到子节点并画连接线
        for (int i = 0; i <= nodeRect.node->getKeyCount(); i++) {
            BTreeNode *child = nodeRect.node->getChild(i);
            if (!child) continue;
            
            // 找到子节点的矩形
            for (const NodeRect &childRect : m_nodeRects) {
                if (childRect.node == child) {
                    // 计算连接点的位置，让居中效果更好
                    QPoint parentPoint;
                    
                    if (nodeRect.keys.size() == 1) {
                        // 单个关键字 - 从节点的左/中/右连接
                        if (i == 0) {
                            // 左子节点 - 从左四分之一处连接
                            parentPoint = QPoint(nodeRect.rect.x() + nodeRect.rect.width() / 4, 
                                               nodeRect.rect.bottom());
                        } else {
                            // 右子节点 - 从右四分之一处连接  
                            parentPoint = QPoint(nodeRect.rect.x() + 3 * nodeRect.rect.width() / 4, 
                                               nodeRect.rect.bottom());
                        }
                    } else {
                        // 多个关键字 - 从合适的位置连接
                        int sectionWidth = nodeRect.rect.width() / (nodeRect.keys.size() + 1);
                        parentPoint = QPoint(nodeRect.rect.x() + (i + 1) * sectionWidth, 
                                           nodeRect.rect.bottom());
                    }
                    
                    QPoint childPoint(childRect.rect.center().x(), childRect.rect.top());
                    
                    painter.drawLine(parentPoint, childPoint);
                    break;
                }
            }
        }
    }
}
