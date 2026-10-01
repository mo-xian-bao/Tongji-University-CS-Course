/* 2351520 计拔 毛星博 */
#include <iostream>
#include <fstream>
//不再允许加入任何头文件，特别是<Windows.h>，查到就是0分甚至是倒扣-20!!!!!
using namespace std;

#include "15-b8-bmp.h"

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：按需补充
***************************************************************************/
bitmap::bitmap(const char *const filename)
{
    ifstream file(filename, ios::binary);
    if (!file)
    {
        cout << "打开文件[" << filename << "]失败." << endl;
        return;
    }

    //读取文件头
    file.read((char *)&fileHeader, sizeof(FileHeader));

    //读取位图信息头
    file.read((char *)&infoHeader, sizeof(InfoHeader));

    //读取颜色表
    if (infoHeader.bitCount <= 8) {
        colorTable = new(nothrow) ColorTable[1 << infoHeader.bitCount];
        if (colorTable == nullptr) {
            cout << "内存分配失败." << endl;
            return;
        }
        file.read((char *)colorTable, sizeof(ColorTable) * (1 << infoHeader.bitCount));
    }

    //读取图像数据
    int padding = (4 - ((infoHeader.width * infoHeader.bitCount + 7) / 8) % 4) % 4;  // 计算字节对齐
    int rowSize = (infoHeader.width * infoHeader.bitCount + 7) / 8 + padding;  // 计算每行像素所占字节数
    int dataSize = rowSize * infoHeader.height;  // 计算图像数据总大小 
    data = new(nothrow) unsigned char[dataSize];
    if (data == nullptr) {
        cout << "内存分配失败." << endl;
        return;
    }
    file.read((char*)data, dataSize);

    file.close();
}

/***************************************************************************
  函数名称：
  功    能：
  输入参数：
  返 回 值：
  说    明：按需补充
***************************************************************************/
bitmap::~bitmap()
{
    if (colorTable) {
        delete[] colorTable;
    }
    if (data) {
        delete[] data;
    }
}


//画图函数，有角度和镜像功能
int bitmap::show(const int top_left_x, const int top_left_y, const int angle, const bool is_mirror,
    void (*draw_point)(const int x, const int y, const unsigned char red, const unsigned char green, const unsigned char blue)) const
{
    int width = infoHeader.width;
    int height = infoHeader.height;
    int padding = (4 - ((infoHeader.width * infoHeader.bitCount + 7) / 8) % 4) % 4;
    int rowSize = (infoHeader.width * infoHeader.bitCount + 7) / 8 + padding;
    unsigned char red, green, blue;

    // 计算旋转后的宽度和高度
    int rotatedWidth = (angle == 90 || angle == 270) ? height : width;
    int rotatedHeight = (angle == 90 || angle == 270) ? width : height;

    // 遍历旋转后的坐标系，从上到下打印
    for (int y = 0; y < rotatedHeight; ++y) {
        for (int x = 0; x < rotatedWidth; ++x) {
            int originalX, originalY;

            // 根据旋转角度计算原始坐标
            if (angle == 90) {
                originalX = y;
                originalY = height - 1 - x;
    }
            else if (angle == 0) {
                originalX = width - 1 - x;
                originalY = height - 1 - y;
            }
            else if (angle == 270) {
                originalX = width - 1 - y;
                originalY = x;
            }
            else { // angle == 180
                originalX = x;
                originalY = y;
            }

            // 镜像处理
            if (!is_mirror) {
                originalX = width - 1 - originalX;
            }

            // 获取像素颜色
            int index;
            if (infoHeader.bitCount == 1) {
                int byteIndex = originalY * ((width+7) / 8 + padding) + originalX / 8;
                int bitIndex = 7 - (originalX % 8);
                index = (data[byteIndex] >> bitIndex) & 0x01;
                blue = colorTable[index].blue;
                green = colorTable[index].green;
                red = colorTable[index].red;
            }
            else if (infoHeader.bitCount == 4) {
                int byteIndex = originalY * ((width * 4 + 7) / 8 + padding) + originalX / 2;
                int bitIndex = 4 * (1 - originalX % 2);
                index = (data[byteIndex] >> bitIndex) & 0x0F;
                blue = colorTable[index].blue;
                green = colorTable[index].green;
                red = colorTable[index].red;
            }
            else if (infoHeader.bitCount == 8) {
                index = data[originalY * (width + padding) + originalX];
                blue = colorTable[index].blue;
                green = colorTable[index].green;
                red = colorTable[index].red;
            }
            else if (infoHeader.bitCount == 24) {
                index = originalY * (width * 3 + padding) + originalX * 3;
                blue = data[index];
                green = data[index + 1];
                red = data[index + 2];
            }
            else if (infoHeader.bitCount == 32) {
                index = originalY * width * 4 + originalX * 4;
                blue = data[index];
                green = data[index + 1];
                red = data[index + 2];
            }

            // 调用绘制函数
            draw_point(top_left_x + x, top_left_y + y, red, green, blue);
}
    }
    return 0;
}