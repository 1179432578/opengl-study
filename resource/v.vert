attribute vec2 position;

varying vec3 fragmentColor;

attribute vec3 color2;
void main(){
    gl_Position =  vec4(position.xy, 0.0, 1.0);
//    if (-1.0 <= 0.0) {
//        color2 = vec3(1.0, 0.0, 1.0);
//    }
//    color2.x = color2.x + 1.0;
//    fragmentColor.x = position.x + 1.0;
    fragmentColor = color2;
//    if (color2.r > 0.0) {
//        fragmentColor = vec3(1, 0, 0);
//    }
//    else{
//        fragmentColor = vec3(1, 0, 1);
//    }

}