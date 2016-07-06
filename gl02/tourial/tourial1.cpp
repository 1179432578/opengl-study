//
//  tourial1.cpp
//  gl02
//
//  Created by lewis on 16/7/6.
//  Copyright © 2016年 鲁飞. All rights reserved.
//

#include "tourial1.h"



void drawQuad(){
    static GLuint program = loadShaderFile("resource/v.vert", "resource/f.frag", 2, "position", 0, "color2", 1, 0);
    
    GLfloat position[] = {
        -0.5, -0.5,
        0.5, -0.5,
        0.5, 0.5,
        -0.5, 0.5};
    
    GLfloat color[] = {
        1, 0.5, 0.5,
        0.5, 1, 0.5,
        0.5, 0.5, 1,
        0.5, 1, 0.5};
    
    glUseProgram(program);
    
    //传数据给opengl服务器
    
//    GLint colorPos2 = glGetAttribLocation(program, "position");
    glEnableVertexAttribArray(0);//position
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, position);
    
//    GLint colorPos = glGetAttribLocation(program, "color2");
    glEnableVertexAttribArray(1);//color
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, color);
    
    glDrawArrays(GL_QUADS, 0, 4);
}