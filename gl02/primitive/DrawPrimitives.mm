//
//  DrawPrimitives.cpp
//  gl02
//
//  Created by 鲁飞 on 16/6/13.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#include "DrawPrimitives.h"
#include "shader.h"
#import <Cocoa/cocoa.h>

#define V_POSITON_COLOR_SIZE \
"													\n\
attribute vec4 a_position;							\n\
uniform float u_pointSize;							\n\
uniform	vec4 u_color;								\n\
uniform mat4 MVPMatrix; \
                                                    \n\
#ifdef GL_ES										\n\
varying lowp vec4 v_fragmentColor;					\n\
#else												\n\
varying vec4 v_fragmentColor;						\n\
#endif												\n\
                                                    \n\
void main()											\n\
{													\n\
gl_Position =  MVPMatrix * a_position;              \n\
gl_PointSize = u_pointSize;                         \n\
v_fragmentColor = u_color;                          \n\
}													\n\
"

#define  F_COLOR \
"										\n\
#ifdef GL_ES							\n\
precision lowp float;					\n\
#endif									\n\
                                        \n\
varying vec4 v_fragmentColor;			\n\
                                        \n\
void main()								\n\
{										\n\
gl_FragColor = v_fragmentColor;         \n\
}										\n\
"

//纹理顶点着色器
#define V_TEXTURE \
"													\n\
attribute vec4 a_position;							\n\
attribute vec2 a_texCoord;                          \n\
varying vec2 v_texCoord;    \n\
uniform	vec4 u_color;								\n\
uniform mat4 MVPMatrix;                             \n\
varying vec4 v_fragmentColor;						\n\
void main()											\n\
{													\n\
gl_Position =  MVPMatrix * a_position;              \n\
v_fragmentColor = u_color;                          \n\
v_texCoord = a_texCoord; \n\
}													\n\
"

//纹理片元着色器
#define  F_TEXTURE \
"										\n\
                                        \n\
varying vec4 v_fragmentColor;			\n\
varying vec2 v_texCoord; \
uniform sampler2D u_tex;                  \n\
                                        \n\
void main()								\n\
{										\n\
gl_FragColor = v_fragmentColor * texture2D(u_tex, v_texCoord);         \n\
}										\n\
"

static bool s_bInitialized = false;
static GLuint s_program;

/*着色器中变量的位置*/
static GLint s_nColorLocation;
static GLint s_nPointSizeLocation;
static GLint s_mvcMatrixLocation;
/*着色器变量默认值*/
static GLfloat s_fPointSize = 10.0f;
static GLfloat s_tColor[] = {1.0f,1.0f,1.0f,1.0f};
static GLfloat s_matrix[] = {1, 0, 0, 0,
                             0, 0.6, 0.5, 0,
                             0, -0.5, 0.6, 0,
                             0, 0, 0, 1};
//static GLfloat s_matrix[] = {1, 0, 0, 0,
//                             0, 1, 0, 0,
//                             0, 0, 1, 0,
//                             0, 0, 0, 1};

static void initDraw()
{
    if(!s_bInitialized ) {
        s_program = createShaderProgram(V_POSITON_COLOR_SIZE, F_COLOR);
        
        //全局变量
        s_nColorLocation = glGetUniformLocation(s_program, "u_color");
        s_nPointSizeLocation = glGetUniformLocation(s_program, "u_pointSize");
        s_mvcMatrixLocation = glGetUniformLocation(s_program, "MVPMatrix");
        
        //顶点输入
        glBindAttribLocation(s_program, 0, "a_position");
        
        s_bInitialized = true;
    }
}

static void initDraw2()
{
    if(!s_bInitialized ) {
        s_program = createShaderProgram(V_TEXTURE, F_TEXTURE);
        
        s_nColorLocation = glGetUniformLocation(s_program, "u_color");
        s_mvcMatrixLocation = glGetUniformLocation(s_program, "MVPMatrix");
        
        glBindAttribLocation(s_program, 0, "a_position");
        glBindAttribLocation(s_program, 1, "a_texCoord");
        
        s_bInitialized = true;
    }
}

void sefDrawColorf(GLfloat r, GLfloat g, GLfloat b, GLfloat a)
{
    s_tColor[0] = r;
    s_tColor[1] = g;
    s_tColor[2] = b;
    s_tColor[3] = a;
}

void setPointSize(GLfloat pointSize)
{
    s_fPointSize = pointSize;
    glPointSize(pointSize);
}

void drawPoint(float x, float y){
    initDraw();
    
    GLfloat point[2] = {x, y};
    
    /*设置着色器参数值*/
    glUseProgram(s_program);

    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
    glUniform1f(s_nPointSizeLocation, s_fPointSize);/*设置顶点大小*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/

    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, point);

    glDrawArrays(GL_POINTS, 0, 1);
}

void drawLine(float x1, float y1, float x2, float y2){
    initDraw();
    
    GLfloat p[4] = {x1, y1, x2, y2};
    
    glUseProgram(s_program);
    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
    glUniform1f(s_nPointSizeLocation, s_fPointSize);/*设置顶点大小*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/

    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, p);
    
    glDrawArrays(GL_LINES, 0, 2);
}

void drawLine(Point2f p1, Point2f p2){
    drawLine(p1.x, p1.y, p2.x, p2.y);
}

void drawRectangle(Point2f origin, Point2f destination){
    drawLine(CCPointMake(origin.x, origin.y), CCPointMake(destination.x, origin.y));
    drawLine(CCPointMake(destination.x, origin.y), CCPointMake(destination.x, destination.y));
    drawLine(CCPointMake(destination.x, destination.y), CCPointMake(origin.x, destination.y));
    drawLine(CCPointMake(origin.x, destination.y), CCPointMake(origin.x, origin.y));
}

void drawTriangles(Point2f p[], int numberOfPoints){
    initDraw();
    
    glUseProgram(s_program);
    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
    glUniform1f(s_nPointSizeLocation, s_fPointSize);/*设置顶点大小*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, p);
    
    glDrawArrays(GL_TRIANGLES, 0, numberOfPoints);

}

void drawTriangles(GLfloat p[], int numberOfPoints){
    initDraw();
    
    glUseProgram(s_program);
    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
//    glUniform1f(s_nPointSizeLocation, s_fPointSize);/*设置顶点大小*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/
    
    //设置纹理
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, p);
    
    glEnableVertexAttribArray(1);//texture coordinate
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, p);
    
    glDrawArrays(GL_TRIANGLES, 0, numberOfPoints);
    
}

void drawTriangles(GLfloat p[], GLfloat texCoord[], int numberOfPoints, GLuint tex){
    initDraw2();
    
    glUseProgram(s_program);
    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/
    
    //激活绑定纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, tex);
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, p);
    
    glEnableVertexAttribArray(1);//texture coordinate
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoord);
    
    glDrawArrays(GL_TRIANGLES, 0, numberOfPoints);
    
}

void drawFourcone(){
//    GLfloat points[] = {-0.5, 0, 0.5,//0
//                        -0.5, 0, -0.5,//1
//                        0.5, 0, -0.5,//2
//                        0.5, 0, 0.5,//3
//                        0, 0.5, 0};//4
    GLfloat points[] = {-0.5, 0, 0.5, -0.5, 0, -0.5, 0.5, 0, -0.5,
        -0.5, 0, 0.5,0.5, 0, -0.5,0.5, 0, 0.5,
        -0.5, 0, 0.5,-0.5, 0, -0.5,0, 0.5, 0,
        -0.5, 0, -0.5, 0.5, 0, -0.5, 0, 0.5, 0,
        0.5, 0, -0.5,0.5, 0, 0.5,0, 0.5, 0,
        -0.5, 0, 0.5,0.5, 0, 0.5,0, 0.5, 0
    };
    
    //生成纹理
    //读取一个外部文件 并获得它的图片信息
    NSImage *img = [[NSImage alloc]initWithContentsOfFile:[[NSString alloc] initWithUTF8String:"/Users/lewis/Desktop/opengl-study/resource/Icon-72@2x.png"]];
    NSRect rt = NSMakeRect(0, 0, img.size.width , img.size.height);
    CGImageRef temImg = [img CGImageForProposedRect:&rt context:nil hints:nil];
    CGDataProviderRef pr = CGImageGetDataProvider(temImg);
    CFDataRef r = CGDataProviderCopyData(pr);
    void* data = (void*)CFDataGetBytePtr(r);
    int height = CGImageGetHeight(temImg);
    int width = CGImageGetWidth(temImg);
    
    //生成纹理
    GLuint tex;
    glGenTextures(1, &tex);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, tex);
    
    //    glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
    
    //纹理参数设置
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    //设置纹理数据
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, height, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    //释放图片像素数据， 纹理已经保存在显存中，渲染时gpu直接对纹理操作，图片数据不再需要保存在内存中了
    free((void*)data);

    
    //设置纹理坐标
    GLfloat texCoord[] = {0, 0, 0, 1, 1, 0,
        0, 0, 0, 1, 1, 0,
        0, 0, 0, 1, 1, 0,
        0, 0, 0, 1, 1, 0,
        0, 0, 0, 1, 1, 0,
        0, 0, 0, 1, 1, 0
    };
    
    drawTriangles(points, texCoord, sizeof(points)/sizeof(GLfloat)/3, tex);
}
