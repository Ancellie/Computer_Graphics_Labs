// ==========================================
// РЕЖИМ B: SIERPIŃSKI TRIANGLE
// ==========================================

void drawSierpinskiMode() {
  background(255);
  
  float x1 = width / 2;
  float y1 = 50;
  float x2 = 50;
  float y2 = height - 50;
  float x3 = width - 50;
  float y3 = height - 50;
  
  if (useChaos) {
    // Chaos Game режим
    drawChaosGame(x1, y1, x2, y2, x3, y3);
  } else {
    // Рекурсивний режим
    drawTriangle(x1, y1, x2, y2, x3, y3, level, level);
  }
  
  // Інформація про глибину
  fill(255, 0, 0);
  textSize(24);
  textAlign(LEFT);
  text("Level: " + level, 20, 30);
  text("Q - Increase, E - Decrease", 20, 60);
  if (useChaos) {
    text("Chaos Game: " + chaosIterations + " points", 20, 90);
  }
}


// Рекурсивна функція Sierpiński
void drawTriangle(float x1, float y1, float x2, float y2, float x3, float y3, int lvl, int maxLevel) {
  if (lvl == 0) {
    // Колір залежить від глибини
    if (monochrome) {
      fill(0);
    } else {
      colorMode(HSB, 360, 100, 100);
      float hue = (baseHue + (maxLevel - lvl) * 40) % 360;
      fill(hue, 80, 90);
      colorMode(RGB, 255);
    }
    
    noStroke();
    triangle(x1, y1, x2, y2, x3, y3);
  } else {
    float mx1 = (x1 + x2) / 2;
    float my1 = (y1 + y2) / 2;
    
    float mx2 = (x2 + x3) / 2;
    float my2 = (y2 + y3) / 2;
    
    float mx3 = (x1 + x3) / 2;
    float my3 = (y1 + y3) / 2;
    
    drawTriangle(x1, y1, mx1, my1, mx3, my3, lvl - 1, maxLevel);
    drawTriangle(mx1, my1, x2, y2, mx2, my2, lvl - 1, maxLevel);
    drawTriangle(mx3, my3, mx2, my2, x3, y3, lvl - 1, maxLevel);
  }
}


// Chaos Game алгоритм
void drawChaosGame(float x1, float y1, float x2, float y2, float x3, float y3) {
  PVector[] vertices = {
    new PVector(x1, y1),
    new PVector(x2, y2),
    new PVector(x3, y3)
  };
  
  // Ініціалізація випадкової точки
  if (chaosPoints.size() == 0) {
    chaosPoints.add(new PVector(random(x2, x3), random(y1, y2)));
  }
  
  // Генеруємо нові точки
  for (int i = 0; i < 100; i++) {
    PVector last = chaosPoints.get(chaosPoints.size() - 1);
    int randomVertex = int(random(3));
    PVector target = vertices[randomVertex];
    
    PVector newPoint = new PVector(
      (last.x + target.x) / 2,
      (last.y + target.y) / 2
    );
    
    chaosPoints.add(newPoint);
    chaosIterations++;
  }
  
  // Малюємо точки з alpha для показу щільності
  noStroke();
  for (int i = 0; i < chaosPoints.size(); i++) {
    PVector p = chaosPoints.get(i);
    
    if (monochrome) {
      fill(0, 100);
    } else {
      colorMode(HSB, 360, 100, 100);
      float hue = (baseHue + i * 0.1) % 360;
      fill(hue, 80, 90, 150);
      colorMode(RGB, 255);
    }
    
    circle(p.x, p.y, 2);
  }
}
