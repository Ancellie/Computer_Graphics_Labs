#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 lightPosition;
uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 materialAmbient;
uniform vec3 materialDiffuse;
uniform vec3 materialSpecular;
uniform float shininess;

varying vec3 vertNormal;
varying vec3 vertPosition;

void main() {
  // Ambient component
  vec3 ambient = ambientColor * materialAmbient;
  
  // Diffuse component (per-fragment)
  vec3 lightDir = normalize(lightPosition - vertPosition);
  float diff = max(dot(vertNormal, lightDir), 0.0);
  vec3 diffuse = lightColor * materialDiffuse * diff;
  
  // Specular component (per-fragment - Phong)
  vec3 viewDir = normalize(-vertPosition);
  vec3 reflectDir = reflect(-lightDir, vertNormal);
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
  vec3 specular = lightColor * materialSpecular * spec;
  
  // Combine all components
  vec3 result = ambient + diffuse + specular;
  
  gl_FragColor = vec4(result, 1.0);
}