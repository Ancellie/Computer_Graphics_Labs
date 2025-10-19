PVector p0, p1, p2, p3;
PVector draggedPoint = null;

void setup() {
  size(800, 600);
  p0 = new PVector(200, 400);
  p1 = new PVector(300, 200);
  p2 = new PVector(500, 200);
  p3 = new PVector(600, 400);
}

void draw() {
  background(255);
  fill(0);
  
  stroke(180);
  line(p0.x, p0.y, p1.x, p1.y);
  line(p2.x, p2.y, p3.x, p3.y);
  
  stroke(0);
  noFill();
  bezier(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);

  fill(255);
  stroke(0);
  ellipse(p0.x, p0.y, 12, 12);
  ellipse(p3.x, p3.y, 12, 12);
  
  fill(255, 0, 0);
  ellipse(p1.x, p1.y, 12, 12);
  ellipse(p2.x, p2.y, 12, 12);
}

void mousePressed() {
  if (dist(mouseX, mouseY, p0.x, p0.y) < 10) draggedPoint = p0;
  else if (dist(mouseX, mouseY, p1.x, p1.y) < 10) draggedPoint = p1;
  else if (dist(mouseX, mouseY, p2.x, p2.y) < 10) draggedPoint = p2;
  else if (dist(mouseX, mouseY, p3.x, p3.y) < 10) draggedPoint = p3;
}

void mouseDragged() {
  if (draggedPoint != null) {
    draggedPoint.x = mouseX;
    draggedPoint.y = mouseY;
  }
}

void mouseReleased() {
  draggedPoint = null;
}
