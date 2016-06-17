varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_tex;
void main(){
    gl_FragColor = v_fragmentColor * texture2D(u_tex, v_texCoord);
}