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
#include "Texture2D.h"
#include "matrix_transform.h"
#include "Matrix.h"

//平面着色器
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

//纹理变灰着色器
#define V_GARY \
"\
attribute vec4 a_position;\n\
attribute vec2 a_texCoord;\n\
varying vec2 v_texCoord;\n\
void main(){\n\
    gl_Position = a_position;\n\
    v_texCoord = a_texCoord;\n\
}\n\
"

//纹理默认绑定到了0号单元
#define F_GARY \
"\
varying vec2 v_texCoord;\n\
uniform sampler2D u_tex;\n\
void main(){\n\
vec4 color = texture2D(u_tex, v_texCoord);\
if(color.a <= 0.0){\n\
    discard;\n\
}\n\
color.rgb = color.rgb + vec3(0, -color.g, -color.b);\
gl_FragColor = color;\n\
}\
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


//多重纹理顶点着色器
#define V_DTEXTURE \
"													\n\
attribute vec4 a_position;							\n\
attribute vec2 a_texCoord;                          \n\
varying vec2 v_texCoord;    \n\
varying vec4 v_fragmentColor;						\n\
void main()											\n\
{													\n\
gl_Position =  a_position;              \n\
v_texCoord = a_texCoord;                            \n\
}													\n\
"

//多重纹理片元着色器
#define  F_DTEXTURE \
"										\n\
varying vec2 v_texCoord; \
uniform sampler2D u_tex1;                  \n\
uniform sampler2D u_tex2;           \n\
\n\
void main()								\n\
{										\n\
    vec4 color1 = texture2D(u_tex1, v_texCoord); \n\
    vec4 color2 = texture2D(u_tex2, v_texCoord); \n\
    if(color2.a > 0.0){\n\
        gl_FragColor = color1 * 0.5 + color2 * 0.5;\n\
        gl_FragColor.a = color1.a;\n\
    }\n\
    else{\n\
        gl_FragColor = color1;\n\
    }\n\
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
                             0, 1, 0, 0,
                             0, 0, 1, 0,
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

//实现一个读取外部着色器代码，绑定属性位置，获得uniform变量位置的创建着色器函数

static void initDraw3(){
    if(!s_bInitialized ) {
        s_program = createShaderProgram(V_GARY, F_GARY);
        
        GLint texLocation = glGetUniformLocation(s_program, "u_tex");
        glUniform1i(texLocation, 0);
        
        glBindAttribLocation(s_program, 0, "a_position");
        glBindAttribLocation(s_program, 1, "a_texCoord");
        
        s_bInitialized = true;
    }
}

//用于双纹理着色
static void initDraw4(){
    if(!s_bInitialized ) {
        s_program = createShaderProgram(V_DTEXTURE, F_DTEXTURE);
        
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

//画四边形
void drawQuads(GLfloat p[], GLfloat texCoord[], int numberOfPoints, Texture2D *tex){
    initDraw2();
    
    glUseProgram(s_program);
    glUniform4fv(s_nColorLocation, 1, s_tColor);/*设置顶点颜色*/
    glUniformMatrix4fv(s_mvcMatrixLocation, 1, GL_FALSE, s_matrix);/*设置顶点变换矩阵*/
    
    //激活绑定纹理
    tex->useTexture();
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, p);
    
    glEnableVertexAttribArray(1);//texture coordinate
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoord);
    
    glDrawArrays(GL_QUADS, 0, numberOfPoints);
    
}

void drawCube(){
    //顶点坐标
    GLfloat vertexPos[] = {
        //前面
        -0.5,0.5,0.5,
        0.5,0.5,0.5,
        0.5,-0.5,0.5,
        -0.5,-0.5,0.5,
        //后面
        -0.5,0.5,-0.5,
        0.5,0.5,-0.5,
        0.5,-0.5,-0.5,
        -0.5,-0.5,-0.5,
        //左面
        -0.5,0.5,0.5,
        -0.5,0.5,-0.5,
        -0.5,-0.5,-0.5,
        -0.5,-0.5,0.5,
        //右面
        0.5,0.5,0.5,
        0.5,0.5,-0.5,
        0.5,-0.5,-0.5,
        0.5,-0.5,0.5,
        //上面
        -0.5,0.5,-0.5,
        0.5,0.5,-0.5,
        0.5,0.5,0.5,
        -0.5,0.5,0.5,
        //下面
        -0.5,-0.5,-0.5,
        0.5,-0.5,-0.5,
        0.5,-0.5,0.5,
        -0.5,-0.5,0.5
    };
    
    Texture2D *tex = Texture2D::create("resource/Icon-72@2x.png");
    
    //纹理坐标
    GLfloat texCoord[] = {
        //前面
        0,1,
        1,1,
        1,0,
        0,0,
        //后面
        0,1,
        1,1,
        1,0,
        0,0,
        //左面
        0,1,
        1,1,
        1,0,
        0,0,
        //右面
        0,1,
        1,1,
        1,0,
        0,0,
        //上面
        0,1,
        1,1,
        1,0,
        0,0,
        //下面
        0,1,
        1,1,
        1,0,
        0,0,
    };
    
    //对模型进行变换
    changeMatrix();
    
    drawQuads(vertexPos, texCoord, sizeof(vertexPos)/sizeof(GLfloat)/3, tex);
}

void changeMatrix(){
    //模型变换
    Matrix44 m1 = rotate(30, 1, 1, -1);
    //观察变换
    Matrix44 m2 = mglLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
    //设置投影空间
    Matrix44 m3 = mgluPerspective(M_PI_4, 640.0f/480.f, 1, 1000);
    
    //求矩阵乘积
    Matrix44 m4 = multiply(&m1, &m2);
    m4 = multiply(&m4, &m3);
    print(&m3);
    //设置着色器关联变量值
    memcpy(s_matrix, &m4, 64);
}

//画四边形
void drawQuads2(GLfloat p[], GLfloat texCoord[], int numberOfPoints, Texture2D *tex){
    initDraw3();
    
    glUseProgram(s_program);
    
    //激活绑定纹理
    tex->useTexture();
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, p);
    
    glEnableVertexAttribArray(1);//texture coordinate
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoord);
    
    glDrawArrays(GL_QUADS, 0, numberOfPoints);
    
}

//画四边形
void drawQuads3(GLfloat p[], GLfloat texCoord[], int numberOfPoints, Texture2D *tex1, Texture2D *tex2){
    initDraw4();
    glUseProgram(s_program);
    
    //激活绑定纹理
    tex1->useTexture(1);
    tex2->useTexture(2);
    
    /*传数据给opengl服务器*/
    glEnableVertexAttribArray(0);/*position*/
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, p);
    
    glEnableVertexAttribArray(1);//texture coordinate
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoord);
    
    glDrawArrays(GL_QUADS, 0, numberOfPoints);
    
}

void testShader(){
    GLfloat vPos[] = {
            -1, -1,
            1, -1,
            1, 1,
            -1, 1};
    
    GLfloat texPos[] = {
        0, 1,
        1, 1,
        1, 0,
        0, 0};
    
    Texture2D *tex1 = Texture2D::create("resource/1.png", 1);
    Texture2D *tex2 = Texture2D::create("resource/4.png", 2);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    tex1->useTexture(1);
    GLint tex1Location = glGetUniformLocation(s_program, "u_tex1");
    glUniform1i(tex1Location, 1);//绑到纹理单元0
    
    tex2->useTexture(2);
    GLint tex2Location = glGetUniformLocation(s_program, "u_tex2");
    glUniform1i(tex2Location, 2);//绑定到纹理单元1

    drawQuads3(vPos, texPos, 4, tex1, tex2);
}
