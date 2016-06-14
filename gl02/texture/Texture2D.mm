//
//  Texture2D.cpp
//  CG
//
//  Created by lewis on 16/6/10.
//  Copyright © 2016年 lewis. All rights reserved.
//

#import "Texture2D.h"
#import <Cocoa/Cocoa.h>
#include <string.h>


Texture2D* Texture2D::create(int x, int y, const char *filename){
    Texture2D *ret = new Texture2D;
    ret->m_posX = x;
    ret->m_posY = y;
    
    std::string newFilename = FileUtils::getInstance()->getFullPathForFilename(filename);
    
    /*读取图片数据*/
    NSImage *img = [[NSImage alloc]initWithContentsOfFile:[[NSString alloc] initWithUTF8String:newFilename.c_str()]];
    NSRect rt = NSMakeRect(0, 0, img.size.width , img.size.height);
    CGImageRef temImg = [img CGImageForProposedRect:&rt context:nil hints:nil];
    CGDataProviderRef pr = CGImageGetDataProvider(temImg);
    CFDataRef r = CGDataProviderCopyData(pr);
    ret->m_data = (unsigned char*)CFDataGetBytePtr(r);
    ret->m_height = CGImageGetHeight(temImg);
    ret->m_width = CGImageGetWidth(temImg);
    
    return ret;
}
