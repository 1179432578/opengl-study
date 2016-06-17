//
//  main.c
//  gl02
//
//  Created by 鲁飞 on 15/8/7.
//  Copyright (c) 2015年 鲁飞. All rights reserved.
//

#include "shader.h"
#include "DrawPrimitives.h"
#include <stdlib.h>

void display(){
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    setPointSize(10);
//    drawPoint(0.0f, 0.0f);
//    drawLine(0.0f, 0.0f, 0.5f, 0.5f);
//    drawRectangle(Point2f(-0.5, -0.5), Point2f(0.5, 0.5));

    drawCube(0, 0, 0, 0.5);
    //进行裁剪
    //glScissor(600, 400, 640, 480);
//    testShader();
    glSwapAPPLE();
}

static float dx = 0;
static float dy = 0;
static float dz = 0;
static float delta = 0.5;
void draw(){
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    drawCube(dx, dy, dz, delta);
    glSwapAPPLE();
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
        case 'w':
            dy += 0.1f;
            draw();
            break;
        case 's':
            dy -= 0.1f;
            draw();
            break;
        case 'a':
            dx -= 0.1f;
            draw();
            break;
        case 'd':
            dx += 0.1f;
            draw();
            break;
        case '+':
            dz += 0.1f;
            draw();
            break;
        case '-':
            dz -= 0.1f;
            draw();
            break;
        case ' ':
            delta += 0.1f;
            draw();
            break;
        default:
            break;
    }
}


int main(int argc, const char * argv[]) {
    // insert code here...
    glutInit(&argc, (char **)argv);
    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowSize (640, 480);
    glutInitWindowPosition (1000, 100);
    glutCreateWindow ("graphics with opengl");
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_SCISSOR_TEST);
    glEnable(GL_BLEND);
//    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glEnable(GL_TEXTURE_2D);//开启纹理
//    createShaderProgram();
    glutMainLoop();
    
    return 0;
}
