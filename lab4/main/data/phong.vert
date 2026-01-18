uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec3 normal;

varying vec3 vertNormal;
varying vec3 vertPosition;

void main() {
  // Pass position and normal to fragment shader
  vertPosition = vec3(modelview * position);
  vertNormal = normalize(normalMatrix * normal);
  
  gl_Position = transform * position;
}