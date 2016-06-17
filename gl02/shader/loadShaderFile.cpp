//
//  loadShaderFile.cpp
//  gl02
//
//  Created by 鲁飞 on 16/6/17.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#include <stdio.h>
#include "shader.h"
#include <stdlib.h>
#include <stdarg.h>

//加载外部着色程序，生成着色程序，并进行变量的初始化
//为attribute变量绑定外部位置
//获得uniform变量的位置，并且设置它们的值，如果它们值一直不变
//可变参数 int attributeNum, const char *a_name1, GLint pos1..., int uniformNUm, const char *u_name1, int *pos...
GLuint loadShaderFile(const char *vSourceFilename, const char *fSourceFilename, ...){
    //读取顶点着色器源文件
    FILE *vf = fopen(vSourceFilename, "rb");
    fseek(vf, 0, SEEK_END);
    long length = ftell(vf);
    fseek(vf, 0, SEEK_SET);
    
    char *vbuf = new char[length+1];
    fread(vbuf, length, 1, vf);
    vbuf[length] = '\0';
    fclose(vf);
    
    /*创建顶点着色器*/
    GLuint vshader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vshader, 1, &vbuf, NULL);
    glCompileShader(vshader);
    delete [] vbuf;
    
    //检查编译状态
    GLint status;
    glGetShaderiv(vshader, GL_COMPILE_STATUS, &status);
    if (!status)
    {
        GLsizei length;
        glGetShaderiv(vshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(vshader, length, NULL, src);
        printf("ERROR: Failed to compile shader:\n%s", src);
        
        free(src);
    }
    
    //读取片元着色器源码
    FILE *ff = fopen(fSourceFilename, "rb");
    fseek(ff, 0, SEEK_END);
    length = ftell(ff);
    fseek(ff, 0, SEEK_SET);
    
    char *fbuf = new char[length+1];
    fread(fbuf, length, 1, ff);
    fbuf[length] = '\0';
    fclose(ff);
    
    //创建片元着色器
    GLuint fshader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fshader, 1, &fbuf, NULL);
    glCompileShader(fshader);
    delete [] fbuf;
    
    //检查编译状态
    GLint status2;
    glGetShaderiv(fshader, GL_COMPILE_STATUS, &status2);
    if (! status2)
    {
        GLsizei length;
        glGetShaderiv(fshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(fshader, length, NULL, src);
        printf("ERROR: Failed to compile shader:\n%s", src);
        
        free(src);
    }
    
    /*add to shader program*/
    GLuint program = glCreateProgram();
    checkGLError();
    if (vshader)
    {
        glAttachShader(program, vshader);
    }
    checkGLError();
    
    if (fshader)
    {
        glAttachShader(program, fshader);
    }
    checkGLError();
    
    /*link*/
    glLinkProgram(program);
    glDeleteShader(vshader);
    glDeleteShader(fshader);
    checkGLError();
    
    //着色器变量设置
    va_list ap;//char*
    va_start(ap, fSourceFilename);//ap+=sizeof(fSourceFilename)
    
    //为attribute变量绑定外部位置
    int attributeCount = va_arg(ap, int);//*((int*)ap) ap+=4
    if (attributeCount) {//存在attribute
        while (attributeCount) {
            const char *attributeName = va_arg(ap, char*);
            int position = va_arg(ap, int);
            glBindAttribLocation(program, position, attributeName);
            attributeCount--;
        }
    }
    
    //获得uniform变量位置
    int uniformCount = va_arg(ap, int);
    while (uniformCount) {
        const char *uniformName = va_arg(ap, char *);
        int *location = va_arg(ap, int*);
        *location = glGetUniformLocation(program, uniformName);
        uniformCount--;
    }
    
    va_end(ap);
    
    return program;

}
