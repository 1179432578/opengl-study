//
//  shader.hpp
//  gl02
//
//  Created by lewis on 16/6/11.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#ifndef shader_hpp
#define shader_hpp

#include <stdio.h>
#include <GLUT/GLUT.h>

/*着色程序*/
extern GLuint program;

//void checkGLError();
#define checkGLError() {\
GLenum __error = glGetError();\
if(__error) {\
printf("OpenGL error 0x%04X in %s %s %d\n", __error, __FILE__, __FUNCTION__, __LINE__);\
}\
}

/*创建默认着色程序*/
GLuint createShaderProgram();

/*创建着色程序*/
GLuint createShaderProgram(const char *vsource, const char *fsource);

/*着色代码*/
/*顶点着色属性：位置与颜色*/
#define VSHADE_POSITION_COLOR    \
"uniform mat4 CC_PMatrix;\n"     \
"uniform mat4 CC_MVMatrix;\n"    \
"uniform mat4 CC_MVPMatrix;\n"   \
"uniform vec4 CC_Time;\n"        \
"uniform vec4 CC_SinTime;\n"     \
"uniform vec4 CC_CosTime;\n"     \
"uniform vec4 CC_Random01;\n"    \
"//CC INCLUDES END\n\n",         \
"														\n\
attribute vec4 a_position;								\n\
attribute vec4 a_color;									\n\
#ifdef GL_ES											\n\
varying lowp vec4 v_fragmentColor;						\n\
#else													\n\
varying vec4 v_fragmentColor;							\n\
#endif													\n\
\n\
void main()												\n\
{														\n\
gl_Position = a_position;                               \n\
v_fragmentColor = a_color;                              \n\
}														\n\
"

/*片元着色*/
#define FSHADE_POSITION_COLOR   \
"uniform mat4 CC_PMatrix;\n"    \
"uniform mat4 CC_MVMatrix;\n"   \
"uniform mat4 CC_MVPMatrix;\n"  \
"uniform vec4 CC_Time;\n"       \
"uniform vec4 CC_SinTime;\n"    \
"uniform vec4 CC_CosTime;\n"    \
"uniform vec4 CC_Random01;\n"   \
"//CC INCLUDES END\n\n",        \
"													\n\
#ifdef GL_ES										\n\
precision lowp float;								\n\
#endif												\n\
\n\
varying vec4 v_fragmentColor;						\n\
\n\
void main()											\n\
{													\n\
gl_FragColor = v_fragmentColor;                     \n\
}													\n\
"

GLuint loadShaderFile(const char *vSourceFilename, const char *fSourceFilename, ...);

#endif /* shader_hpp */
