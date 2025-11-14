// ==========================================
// РЕЖИМ A: BÉZIER EDITOR
// ==========================================

void drawBezierMode() {
  // Градієнтний фон з lerpColor
  for (int y = 0; y < height; y++) {
    color c1 = color(20, 24, 82);
    color c2 = color(133, 76, 130);
    color c = lerpColor(c1, c2, float(y) / height);
    stroke(c);
    line(0, y, width, y);
  }
  
  // Допоміжні лінії (з alpha)
  stroke(180, 100);
  strokeWeight(1);
  line(p0.x, p0.y, p1.x, p1.y);
  line(p2.x, p2.y, p3.x, p3.y);
  
  // Крива Без'є
  stroke(255, 200, 0);
  strokeWeight(3);
  noFill();
  bezier(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
  
  // Рухомий маркер на кривій
  float x = bezierPoint(p0.x, p1.x, p2.x, p3.x, t);
  float y = bezierPoint(p0.y, p1.y, p2.y, p3.y, t);
  fill(255, 0, 0);
  noStroke();
  circle(x, y, 12);
  
  t += 0.01;
  if (t > 1) t = 0;
  
  // Заповнена фігура з bezierVertex (якщо увімкнено)
  if (showShape) {
    fill(100, 200, 255, 100); // з alpha
    stroke(255, 150);
    strokeWeight(2);
    beginShape();
    vertex(p0.x, p0.y);
    bezierVertex(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    vertex(width/2, height - 50);
    endShape(CLOSE);
  }
  
  // Контрольні точки
  fill(255);
  stroke(0);
  strokeWeight(2);
  ellipse(p0.x, p0.y, 12, 12);
  ellipse(p3.x, p3.y, 12, 12);
  
  fill(255, 0, 0);
  ellipse(p1.x, p1.y, 12, 12);
  ellipse(p2.x, p2.y, 12, 12);
  
  // Підписи P0..P3
  fill(255);
  textSize(14);
  textAlign(CENTER);
  text("P0", p0.x, p0.y - 15);
  text("P1", p1.x, p1.y - 15);
  text("P2", p2.x, p2.y - 15);
  text("P3", p3.x, p3.y - 15);
  
  // Відображення компонентів кольору
  displayColorInfo();
}
