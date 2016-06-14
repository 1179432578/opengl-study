//
//  Texture2D.hpp
//  CG
//
//  Created by lewis on 16/6/10.
//  Copyright © 2016年 lewis. All rights reserved.
//

#ifndef Texture2D_hpp
#define Texture2D_hpp

#include <stdio.h>
#include "Node.h"/*Object*/
#include "FileUtils.h"

class Texture2D : public Node{
public:
    static Texture2D* create(int x, int y, const char *filename);
    virtual void draw();
private:
    unsigned char *m_data;
};

#endif /* Texture2D_hpp */
