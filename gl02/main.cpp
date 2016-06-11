//
//  main.c
//  gl02
//
//  Created by 鲁飞 on 15/8/7.
//  Copyright (c) 2015年 鲁飞. All rights reserved.
//


#include "LCommon.h"
#include "drawitem.h"
#include "shader.h"


void display(){
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(program);
    GLfloat p[2] = {0, 0};
    GLfloat color[4] = {1, 0, 0, 0};
    
//    GLuint vao_id;
//    glGenVertexArraysAPPLE(1, &vao_id);
//    glBindVertexArrayAPPLE(vao_id);
    glEnableVertexAttribArray(0);/*position*/
    glEnableVertexAttribArray(1);/*color*/

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, p);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, color);
    
    glDrawArrays(GL_POINTS, 0, 1);
    
    glFlush();
}

void mouse(int button, int state, int x, int y){
    if (state == GLUT_DOWN) {
        if (button == GLUT_LEFT_BUTTON) {
         //   glutPostRedisplay();
        }
    }
    
}

void keyboard(unsigned char keyValue, int x, int y){
    switch (keyValue) {
        case 'q':
            printf("EXIT");
            exit(-1);
            break;
            
        default:
            break;
    }
}


int main(int argc, const char * argv[]) {
    // insert code here...
    glutInit(&argc, (char **)argv);
    glutInitDisplayMode (GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize (640, 480);
    glutInitWindowPosition (1000, 100);
    glutCreateWindow ("graphics with opengl");
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    
    createShaderProgram();
    glutMainLoop();
    
    return 0;
}
