//
//  Texture2D.cpp
//  CG
//
//  Created by lewis on 16/6/10.
//  Copyright © 2016年 lewis. All rights reserved.
//

#include "Texture2D.h"
#import <Cocoa/Cocoa.h>
#include <string.h>

Texture2D* Texture2D::create(const char *filename){
    Texture2D *ret = new Texture2D;
    
    //生成纹理
    //读取一个外部文件 并获得它的图片信息
    NSImage *img = [[NSImage alloc]initWithContentsOfFile:[[NSString alloc] initWithUTF8String:filename]];
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
    
    //glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
    
    //纹理参数设置
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    //设置纹理数据
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, height, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    //释放图片像素数据， 纹理已经保存在显存中，渲染时gpu直接对纹理操作，图片数据不再需要保存在内存中了
    free((void*)data);

    ret->m_tex = tex;
    return ret;
}

void Texture2D::useTexture(){
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, m_tex);
}
