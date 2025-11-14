// ==========================================
// КЕРУВАННЯ (КЛАВІАТУРА + МИША)
// ==========================================

void keyPressed() {
  // TAB - перемикання режимів
  if (key == TAB) {
    mode = (mode + 1) % 2;
    t = 0;
  }
  
  // H - показати/сховати підказки
  if (key == 'h' || key == 'H') {
    showHelp = !showHelp;
  }
  
  // S - зберегти PDF
  if (key == 's' || key == 'S') {
    recordPDF = true;
    println("Збереження PDF...");
  }
  
  // ========== BÉZIER MODE ==========
  if (mode == 0) {
    // M - перемикання RGB/HSB
    if (key == 'm' || key == 'M') {
      useHSB = !useHSB;
      println("Колірний режим: " + (useHSB ? "HSB" : "RGB"));
    }
    
    // SPACE - показати фігуру
    if (key == ' ') {
      showShape = !showShape;
      println("Фігура: " + (showShape ? "ON" : "OFF"));
    }
  }
  
  // ========== SIERPIŃSKI MODE ==========
  if (mode == 1) {
    // Q/E - змінити глибину
    if (key == 'q' || key == 'Q') {
      level++; 
      if (level > 9) level = 9;
      chaosPoints.clear();
      chaosIterations = 0;
      println("Level: " + level);
    }
    
    if (key == 'e' || key == 'E') {
      level--; 
      if (level < 0) level = 0;
      chaosPoints.clear();
      chaosIterations = 0;
      println("Level: " + level);
    }
    
    // 1-8 - встановити глибину
    if (key >= '1' && key <= '8') {
      level = key - '0';
      chaosPoints.clear();
      chaosIterations = 0;
      println("Level: " + level);
    }
    
    // R - рандомна палітра
    if (key == 'r' || key == 'R') {
      baseHue = random(360);
      println("Нова палітра! Hue: " + baseHue);
    }
    
    // C - монохром
    if (key == 'c' || key == 'C') {
      monochrome = !monochrome;
      println("Монохром: " + (monochrome ? "ON" : "OFF"));
    }
    
    // G - Chaos Game
    if (key == 'g' || key == 'G') {
      useChaos = !useChaos;
      chaosPoints.clear();
      chaosIterations = 0;
      println("Chaos Game: " + (useChaos ? "ON" : "OFF"));
    }
  }
}


void mousePressed() {
  if (mode == 0) {
    if (dist(mouseX, mouseY, p0.x, p0.y) < 10) draggedPoint = p0;
    else if (dist(mouseX, mouseY, p1.x, p1.y) < 10) draggedPoint = p1;
    else if (dist(mouseX, mouseY, p2.x, p2.y) < 10) draggedPoint = p2;
    else if (dist(mouseX, mouseY, p3.x, p3.y) < 10) draggedPoint = p3;
  }
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
