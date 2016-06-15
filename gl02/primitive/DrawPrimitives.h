//
//  DrawPrimitives.hpp
//  gl02
//
//  Created by 鲁飞 on 16/6/13.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#ifndef DrawPrimitives_hpp
#define DrawPrimitives_hpp

#include <stdio.h>
#include <GLUT/GLUT.h>

/*绘制基本图元*/
struct Point2f{
    float x;
    float y;
    Point2f(float _x, float _y):x(_x), y(_y){}
};

#define CCPointMake(x, y) Point2f(x, y)

void drawPoint(float x, float y);

void drawLine(float x1, float y1, float x2, float y2);

void drawRectangle(Point2f origin, Point2f destination);

void sefDrawColorf(GLfloat r, GLfloat g, GLfloat b, GLfloat a );

void setPointSize(GLfloat pointSize);

/*画一组三角形*/
void drawTriangles(Point2f p[], int numberOfPoints);

/*画四角锥*/
void drawFourcone();

//画正方体
void drawCube();

//改变变换矩阵
void changeMatrix();

//测试着色程序
void testShader();

#endif /* DrawPrimitives_hpp */
