//
//  shader.cpp
//  gl02
//
//  Created by lewis on 16/6/11.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#include "shader.h"
#include <stdlib.h>

GLuint program;

void checkGLError(){
    GLenum __error = glGetError();
    if(__error) {
        printf("OpenGL error 0x%04X in %s %s %d\n", __error, __FILE__, __FUNCTION__, __LINE__); \
    }
}

/*创建着色程序*/
GLuint createShaderProgram(){
    /*着色程序*/
    program = glCreateProgram();
    checkGLError();
    
    /*顶点着色器*/
    GLint status;
    const GLchar *vsSources[] = {
              VSHADE_POSITION_COLOR
    };
    
    GLuint vshader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vshader, sizeof(vsSources)/sizeof(GLchar *), vsSources, NULL);
    glCompileShader(vshader);
    
    glGetShaderiv(vshader, GL_COMPILE_STATUS, &status);
    if (! status)
    {
        GLsizei length;
        glGetShaderiv(vshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(vshader, length, NULL, src);
        printf("cocos2d: ERROR: Failed to compile shader:\n%s", src);
        
        free(src);
    }

    //片元着色器
    GLint status2;
    const GLchar *fsSources[] = {
        FSHADE_POSITION_COLOR
    };
    
    GLuint fshader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fshader, sizeof(fsSources)/sizeof(GLchar *), fsSources, NULL);
    glCompileShader(fshader);
    
    glGetShaderiv(fshader, GL_COMPILE_STATUS, &status2);
    if (! status2)
    {
        GLsizei length;
        glGetShaderiv(fshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(fshader, length, NULL, src);
        printf("cocos2d: ERROR: Failed to compile shader:\n%s", src);

        free(src);
    }
    
    /*add to shader program*/
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
    
    glBindAttribLocation(program, 0, "a_position");
    glBindAttribLocation(program, 1, "a_color");
    
    /*link*/
    glLinkProgram(program);
    glDeleteShader(vshader);
    glDeleteShader(fshader);
    
    checkGLError();
    
    return program;
}

GLuint createShaderProgram(const char *vsource, const char *fsource){
    /*着色程序*/
    GLuint program = glCreateProgram();
    checkGLError();
    
    /*顶点着色器*/
    GLint status;

    GLuint vshader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vshader, 1, &vsource, NULL);
    glCompileShader(vshader);
    
    glGetShaderiv(vshader, GL_COMPILE_STATUS, &status);
    if (! status)
    {
        GLsizei length;
        glGetShaderiv(vshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(vshader, length, NULL, src);
        printf("cocos2d: ERROR: Failed to compile shader:\n%s", src);
        
        free(src);
    }
    
    //片元着色器
    GLint status2;

    GLuint fshader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fshader, 1, &fsource, NULL);
    glCompileShader(fshader);
    
    glGetShaderiv(fshader, GL_COMPILE_STATUS, &status2);
    if (! status2)
    {
        GLsizei length;
        glGetShaderiv(fshader, GL_SHADER_SOURCE_LENGTH, &length);
        GLchar* src = (GLchar *)malloc(sizeof(GLchar) * length);
        
        glGetShaderSource(fshader, length, NULL, src);
        printf("cocos2d: ERROR: Failed to compile shader:\n%s", src);
        
        free(src);
    }
    
    /*add to shader program*/
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
    
    return program;
}