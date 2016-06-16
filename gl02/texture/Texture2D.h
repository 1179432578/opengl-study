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
#include <GLUT/GLUT.h>

class Texture2D{
public:
    static Texture2D* create(const char *filename, int texIndex = 0);
    void useTexture();
    void useTexture(int index);
private:
    GLuint m_tex;
};


//纹理的一些操作，可以封装成一个类库
//glReadPixels(<#GLint x#>, <#GLint y#>, <#GLsizei width#>, <#GLsizei height#>, <#GLenum format#>, <#GLenum type#>, <#GLvoid *pixels#>)
//glReadBuffer(<#GLenum mode#>)
//glTexImage2D(<#GLenum target#>, <#GLint level#>, <#GLint internalformat#>, <#GLsizei width#>, <#GLsizei height#>, <#GLint border#>, <#GLenum format#>, <#GLenum type#>, <#const GLvoid *pixels#>)
//glTexSubImage2D(<#GLenum target#>, <#GLint level#>, <#GLint xoffset#>, <#GLint yoffset#>, <#GLsizei width#>, <#GLsizei height#>, <#GLenum format#>, <#GLenum type#>, <#const GLvoid *pixels#>)
//glCopyTexSubImage2D(<#GLenum target#>, <#GLint level#>, <#GLint xoffset#>, <#GLint yoffset#>, <#GLint x#>, <#GLint y#>, <#GLsizei width#>, <#GLsizei height#>)
//glCopyTexImage2D(<#GLenum target#>, <#GLint level#>, <#GLenum internalformat#>, <#GLint x#>, <#GLint y#>, <#GLsizei width#>, <#GLsizei height#>, <#GLint border#>)
//glDeleteTextures(<#GLsizei n#>, <#const GLuint *textures#>)
//glIsTexture(<#GLuint texture#>)
//glTexParameterf(<#GLenum target#>, <#GLenum pname#>, <#GLfloat param#>)

#endif /* Texture2D_hpp */
