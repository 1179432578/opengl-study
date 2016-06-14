//
//  main.c
//  gl02
//
//  Created by 鲁飞 on 15/8/7.
//  Copyright (c) 2015年 鲁飞. All rights reserved.
//


#include "LCommon.h"
#include "shader.h"
#include "DrawPrimitives.h"

void display(){
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
//    setPointSize(10);
//    drawPoint(0.0f, 0.0f);
//    drawLine(0.0f, 0.0f, 0.5f, 0.5f);
//    drawRectangle(Point2f(-0.5, -0.5), Point2f(0.5, 0.5));
    glMatrixMode(GL_MODELVIEW);
    glRotatef(1, 29, 0, 0);
    drawFourcone();
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
//    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glEnable(GL_TEXTURE_2D);//开启纹理
    createShaderProgram();
    glutMainLoop();
    
    return 0;
}
