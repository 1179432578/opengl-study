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

static GLuint PBO;
static unsigned char pixels[640*480*4];
void display(){
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    drawCube(0, 0, 0, 0.5);
//    glDrawPixels(400, 400, GL_RGBA, GL_UNSIGNED_BYTE, pixels);//从PBO读像素
    glFlush();
    
    //进行裁剪
    //glScissor(600, 400, 640, 480);
//    testShader();
//    glSwapAPPLE();

    
}

//使用着色器跟一些函数会冲突，效果不正确
void drawPixels(){
    //读像素
//    glReadBuffer(GL_FRONT);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, PBO);
    glReadPixels(0, 0, 640, 480, GL_RGBA, GL_UNSIGNED_BYTE, NULL);//读到PBO
    glBindBuffer(GL_PIXEL_PACK_BUFFER, 0);
    
    //写像素
    glClearColor(255, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, PBO);
    glDrawPixels(640, 480, GL_RGBA, GL_UNSIGNED_BYTE, NULL);//从PBO读像素
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
    glFlush();
//    glSwapAPPLE();
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
        case 'r':
            drawPixels();
            printf("r\n");
            break;
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
    glutInitDisplayMode (GLUT_SINGLE | GLUT_RGBA | GLUT_DEPTH);
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
    
    glGenBuffers(1, &PBO);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, PBO);
    glBufferData(GL_PIXEL_PACK_BUFFER, 640*480*4, NULL, GL_DYNAMIC_COPY);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, 0);
    
    for (int i=0; i<480; i++) {
        for (int j=0; j<640; j++) {
            int index = (i*640+j)*4;
            pixels[index+0] = 255;
            pixels[index+1] = 0;
            pixels[index+2] = 255;
            pixels[index+3] = 255;
        }
    }
    
    glutMainLoop();
    
    return 0;
}
