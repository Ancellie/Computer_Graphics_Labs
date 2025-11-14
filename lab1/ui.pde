// ==========================================
// ІНТЕРФЕЙС (UI)
// ==========================================

void drawHelp() {
  fill(0, 220);
  noStroke();
  rect(10, height - 240, 320, 230);
  
  fill(255, 255, 0);
  textSize(18);
  textAlign(LEFT);
  text("Режим: " + (mode == 0 ? "BÉZIER" : "SIERPIŃSKI"), 20, height - 215);
  
  fill(255);
  textSize(13);
  text("TAB - перемикання режимів", 20, height - 190);
  text("H - показати/сховати підказки", 20, height - 170);
  text("S - зберегти PDF", 20, height - 150);
  
  if (mode == 0) {
    fill(100, 200, 255);
    text("=== BÉZIER ===", 20, height - 125);
    fill(255);
    text("M - перемикач RGB/HSB", 20, height - 105);
    text("SPACE - показати/сховати фігуру", 20, height - 85);
    text("Перетягуй точки P0-P3 мишкою", 20, height - 65);
    text("Червоний маркер рухається по кривій", 20, height - 45);
  } else {
    fill(255, 100, 100);
    text("=== SIERPIŃSKI ===", 20, height - 125);
    fill(255);
    text("Q/E - збільшити/зменшити глибину", 20, height - 105);
    text("1-8 - встановити глибину (1-8)", 20, height - 85);
    text("R - рандомна палітра", 20, height - 65);
    text("C - монохром ON/OFF", 20, height - 45);
    text("G - Chaos Game ON/OFF", 20, height - 25);
  }
}


// Відображення RGB/HSB компонентів
void displayColorInfo() {
  fill(0, 200);
  noStroke();
  rect(width - 220, height - 120, 210, 110);
  
  fill(255);
  textSize(14);
  textAlign(LEFT);
  text("Color Mode: " + (useHSB ? "HSB" : "RGB"), width - 210, height - 95);
  
  color sampleColor = color(255, 200, 0); // жовтий
  
  if (useHSB) {
    colorMode(HSB, 360, 100, 100);
    text("Hue: " + int(hue(sampleColor)), width - 210, height - 70);
    text("Saturation: " + int(saturation(sampleColor)), width - 210, height - 50);
    text("Brightness: " + int(brightness(sampleColor)), width - 210, height - 30);
    colorMode(RGB, 255);
  } else {
    text("Red: " + int(red(sampleColor)), width - 210, height - 70);
    text("Green: " + int(green(sampleColor)), width - 210, height - 50);
    text("Blue: " + int(blue(sampleColor)), width - 210, height - 30);
  }
}
