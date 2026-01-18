float angleRotation = 0;
boolean autoRotate = true;
boolean showLights = true;
PShape model3D;

void setup() {
  size(1200, 800, P3D);
  perspective(PI/3.0, float(width)/height, 0.1, 1000);
  
  /*try {
    model3D = loadShape("IronMan.obj");
  } catch (Exception e) {
    println("Note: model.obj not found.  Create a data folder with an OBJ file.");
  } */
}

void draw() {
  background(20);
  
  camera(300, -200, 400, 0, 0, 0, 0, 1, 0);
  
  if (showLights) {
    ambientLight(30, 30, 40);
    directionalLight(100, 100, 80, -0.5, 0.5, -1);
    pointLight(200, 150, 100, 
               200 * cos(angleRotation), 
               -100, 
               200 * sin(angleRotation));
  }
  
  if (autoRotate) {
    angleRotation += 0.01;
  }
  
  drawHierarchicalObject();
  drawImportedModel();
  drawHUD();
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
    
    fill(180, 120, 80);
    ambient(90, 60, 40);
    specular(255, 200, 150);
    shininess(10.0);
    
    shape(model3D);
    
    popMatrix();
  }
}

void drawHUD() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  fill(255);
  textAlign(LEFT, TOP);
  text("3D Installation - Grade 3 Complete", 10, 10);
  text("", 10, 30);
  text("Controls:", 10, 50);
  text("SPACE - Toggle auto-rotation", 10, 70);
  text("R - Reset rotation", 10, 90);
  text("L - Toggle lights", 10, 110);
  text("", 10, 130);
  text("Features:", 10, 150);
  text("- Hierarchical object (5 levels)", 10, 170);
  text("- Imported OBJ model", 10, 190);
  text("- Lights:  Ambient + Directional + Point", 10, 210);
  text("- Specular materials with shininess", 10, 230);
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
  if (key == 'l' || key == 'L') {
    showLights = !showLights;
  }
}
