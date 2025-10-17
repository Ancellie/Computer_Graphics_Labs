int level = 6;

void setup() {
  size(800, 700);
}

void draw() {
  background(255);
  
  float x1 = width / 2;
  float y1 = 50;
  float x2 = 50;
  float y2 = height - 50;
  float x3 = width - 50;
  float y3 = height - 50;
  
  drawTriangle(x1, y1, x2, y2, x3, y3, level);
  
  fill(255, 0, 0);
  textSize(24);
  text("Level: " + level, 20, 30);
  text("Q - Increase, E - Decrease", 20, 60);
}

void drawTriangle(float x1, float y1, float x2, float y2, float x3, float y3, int level) {
  if (level == 0) {
    fill(0);
    triangle(x1, y1, x2, y2, x3, y3);
  } else {
    float mx1 = (x1 + x2) / 2;
    float my1 = (y1 + y2) / 2;
    
    float mx2 = (x2 + x3) / 2;
    float my2 = (y2 + y3) / 2;
    
    float mx3 = (x1 + x3) / 2;
    float my3 = (y1 + y3) / 2;
    
    drawTriangle(x1, y1, mx1, my1, mx3, my3, level - 1);
    drawTriangle(mx1, my1, x2, y2, mx2, my2, level - 1);
    drawTriangle(mx3, my3, mx2, my2, x3, y3, level - 1);
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    level++; 
    if (level > 9) level = 9; 
  }
  
  if (key == 'e' || key == 'E') {
    level--; 
    if (level < 0) level = 0; 
  }
}
