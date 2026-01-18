float angleRotation = 0;
boolean autoRotate = true;

void setup() {
  size(1200, 800, P3D);
  perspective(PI/3.0, float(width)/height, 0.1, 1000);
}

void draw() {
  background(20);
  
  camera(300, -200, 400, 0, 0, 0, 0, 1, 0);
  
  ambientLight(200, 200, 200);            
  
  if (autoRotate) {
    angleRotation += 0.01;
  }
  
  drawHierarchicalObject();
  
  drawHUD();
}

void drawHierarchicalObject() {
  pushMatrix();
  
  translate(0, 0, 0);
  rotateY(angleRotation);
  
  fill(100, 100, 150);
  box(150, 20, 150);
  
  pushMatrix();
  translate(0, -60, 0);
  fill(150, 100, 100);
  box(30, 100, 30);
  
  pushMatrix();
  translate(0, -60, 0);
  fill(200, 150, 100);
  sphere(25);
  
  pushMatrix();
  rotateZ(sin(angleRotation * 2) * 0.3);
  translate(50, 0, 0);
  fill(100, 150, 150);
  box(100, 20, 20);
  popMatrix();
  
  popMatrix();
  popMatrix();
  popMatrix();
}

void drawHUD() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  fill(255);
  textAlign(LEFT, TOP);
  text("Controls:", 10, 10);
  text("SPACE - Toggle auto-rotation", 10, 30);
  text("R - Reset rotation", 10, 50);
  hint(ENABLE_DEPTH_TEST);
  perspective(PI/3.0, float(width)/height, 0.1, 1000);
}

void keyPressed() {
  if (key == ' ') {
    autoRotate = !autoRotate;
  }
  if (key == 'r' || key == 'R') {
    angleRotation = 0;
  }
}
