float angleRotation = 0;
boolean autoRotate = true;
boolean showLights = true;
PShape model3D;

// Camera controls
float cameraDistance = 500;
float cameraAngleH = 0.3;
float cameraAngleV = -0.3;
float cameraX, cameraY, cameraZ;
int lastMouseX, lastMouseY;

// Bounding sphere
PVector sphereCenter;
float sphereRadius = 80;
boolean sphereHit = false;
boolean showBoundingSphere = true;

void setup() {
  size(1200, 800, P3D);
  perspective(PI/3.0, float(width)/height, 0.1, 1000);
  
  try {
    model3D = loadShape("model.obj");
  } catch (Exception e) {
    println("Note: model.obj not found.");
  }
  
  sphereCenter = new PVector(-60, -50, 0);
  updateCamera();
}

void draw() {
  background(20);
  
  camera(cameraX, cameraY, cameraZ, 0, 0, 0, 0, 1, 0);
  
  if (showLights) {
    ambientLight(30, 30, 40);
    directionalLight(100, 100, 80, -0.5, 0.5, -1);
    pointLight(200, 150, 100, 
               200 * cos(angleRotation), -100, 200 * sin(angleRotation));
    pointLight(100, 200, 150, -150, -50, 0);
    spotLight(255, 255, 200, 0, -300, 0, 0, 1, 0, PI/4, 2);
  }
  
  if (autoRotate) {
    angleRotation += 0.01;
  }
  
  // Mouse picking check
  checkMousePicking();
  
  drawHierarchicalObject();
  drawImportedModel();
  drawBoundingSphere();
  drawHUD();
}

void checkMousePicking() {
  // Create ray from camera through mouse position
  PVector rayOrigin = new PVector(cameraX, cameraY, cameraZ);
  PVector rayDir = getRayDirection(mouseX, mouseY);
  
  // Ray-sphere intersection
  sphereHit = raySphereIntersection(rayOrigin, rayDir, sphereCenter, sphereRadius);
}

PVector getRayDirection(float screenX, float screenY) {
  // Convert screen coordinates to normalized device coordinates
  float x = (2.0 * screenX) / width - 1.0;
  float y = 1.0 - (2.0 * screenY) / height;
  
  // Get view direction
  PVector dir = PVector.sub(new PVector(0, 0, 0), new PVector(cameraX, cameraY, cameraZ));
  
  // Get right and up vectors
  PVector up = new PVector(0, 1, 0);
  PVector right = dir.cross(up);
  right.normalize();
  PVector camUp = right.cross(dir);
  camUp.normalize();
  
  // Calculate ray direction
  float fov = PI / 3.0;
  float aspectRatio = float(width) / height;
  float tanFov = tan(fov / 2.0);
  
  PVector rayDir = dir.copy();
  rayDir.add(PVector.mult(right, x * tanFov * aspectRatio));
  rayDir.add(PVector.mult(camUp, y * tanFov));
  rayDir.normalize();
  
  return rayDir;
}

boolean raySphereIntersection(PVector rayOrigin, PVector rayDir, PVector center, float radius) {
  PVector oc = PVector.sub(rayOrigin, center);
  float a = rayDir.dot(rayDir);
  float b = 2.0 * oc.dot(rayDir);
  float c = oc.dot(oc) - radius * radius;
  float discriminant = b * b - 4 * a * c;
  
  return discriminant >= 0;
}

void drawBoundingSphere() {
  if (showBoundingSphere) {
    pushMatrix();
    translate(sphereCenter.x, sphereCenter.y, sphereCenter.z);
    
    noFill();
    if (sphereHit) {
      stroke(255, 255, 0);
      strokeWeight(3);
    } else {
      stroke(0, 255, 0, 100);
      strokeWeight(1);
    }
    
    sphere(sphereRadius);
    strokeWeight(1);
    popMatrix();
  }
}

void drawHierarchicalObject() {
  pushMatrix();
  translate(0, 0, 0);
  rotateY(angleRotation);
  
  fill(100, 100, 150);
  ambient(50, 50, 75);
  specular(200, 200, 255);
  shininess(15.0);
  box(150, 20, 150);
  
  pushMatrix();
  translate(0, -60, 0);
  fill(150, 100, 100);
  ambient(75, 50, 50);
  specular(255, 150, 150);
  shininess(20.0);
  box(30, 100, 30);
  
  pushMatrix();
  translate(0, -60, 0);
  fill(200, 180, 100);
  ambient(100, 90, 50);
  specular(255, 255, 200);
  shininess(50.0);
  sphere(25);
  
  pushMatrix();
  rotateZ(sin(angleRotation * 2) * 0.3);
  translate(50, 0, 0);
  fill(100, 150, 150);
  ambient(50, 75, 75);
  specular(150, 255, 255);
  shininess(25.0);
  box(100, 20, 20);
  
  pushMatrix();
  translate(50, 0, 0);
  fill(150, 100, 200);
  ambient(75, 50, 100);
  specular(255, 200, 255);
  shininess(30.0);
  sphere(15);
  popMatrix();
  
  popMatrix();
  popMatrix();
  popMatrix();
  popMatrix();
}

void drawImportedModel() {
  if (model3D != null) {
    pushMatrix();
    translate(-60, -50, 0);
    rotateY(angleRotation * 1.5);
    scale(20);
    
    if (sphereHit) {
      fill(255, 255, 0); // Highlight when hit
      ambient(127, 127, 0);
    } else {
      fill(180, 120, 80);
      ambient(90, 60, 40);
    }
    specular(255, 200, 150);
    shininess(10.0);
    
    shape(model3D);
    popMatrix();
  }
}

void updateCamera() {
  cameraX = cameraDistance * cos(cameraAngleV) * cos(cameraAngleH);
  cameraY = cameraDistance * sin(cameraAngleV);
  cameraZ = cameraDistance * cos(cameraAngleV) * sin(cameraAngleH);
}

void drawHUD() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  fill(255);
  textAlign(LEFT, TOP);
  text("3D Installation - Grade 4 Complete", 10, 10);
  text("", 10, 30);
  text("Controls:", 10, 50);
  text("SPACE - Toggle auto-rotation", 10, 70);
  text("R - Reset rotation", 10, 90);
  text("L - Toggle lights", 10, 110);
  text("B - Toggle bounding sphere", 10, 130);
  text("MOUSE DRAG - Orbit camera", 10, 150);
  text("SCROLL - Zoom", 10, 170);
  text("", 10, 190);
  text("Features:", 10, 210);
  text("- Ray-sphere picking:  " + (sphereHit ? "HIT!" : "no hit"), 10, 230);
  text("- Bounding sphere visualization", 10, 250);
  text("- Interactive orbit camera", 10, 270);
  hint(ENABLE_DEPTH_TEST);
  perspective(PI/3.0, float(width)/height, 0.1, 1000);
}

void keyPressed() {
  if (key == ' ') autoRotate = !autoRotate;
  if (key == 'r' || key == 'R') angleRotation = 0;
  if (key == 'l' || key == 'L') showLights = !showLights;
  if (key == 'b' || key == 'B') showBoundingSphere = !showBoundingSphere;
}

void mouseDragged() {
  float dx = mouseX - lastMouseX;
  float dy = mouseY - lastMouseY;
  cameraAngleH += dx * 0.01;
  cameraAngleV -= dy * 0.01;
  cameraAngleV = constrain(cameraAngleV, -PI/2 + 0.1, PI/2 - 0.1);
  updateCamera();
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mousePressed() {
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mouseWheel(MouseEvent event) {
  cameraDistance += event.getCount() * 20;
  cameraDistance = constrain(cameraDistance, 100, 1000);
  updateCamera();
}
