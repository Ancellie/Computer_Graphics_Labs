import processing.pdf.*;

// ==========================================
// ГЛОБАЛЬНІ ЗМІННІ
// ==========================================
int mode = 0; // 0 = Bezier, 1 = Sierpinski
boolean showHelp = true;
boolean recordPDF = false;

// ========== Bézier змінні ==========
PVector p0, p1, p2, p3;
PVector draggedPoint = null;
boolean useHSB = false;
boolean showShape = false;
float t = 0;

// ========== Sierpiński змінні ==========
int level = 6;
boolean monochrome = false;
float baseHue = 180;
boolean useChaos = false;
ArrayList<PVector> chaosPoints;
int chaosIterations = 0;


// ==========================================
// SETUP
// ==========================================
void setup() {
  size(800, 700);
  
  // Ініціалізація Bézier точок
  p0 = new PVector(200, 400);
  p1 = new PVector(300, 200);
  p2 = new PVector(500, 200);
  p3 = new PVector(600, 400);
  
  // Ініціалізація chaos game
  chaosPoints = new ArrayList<PVector>();
}


// ==========================================
// DRAW (головний цикл)
// ==========================================
void draw() {
  if (recordPDF) {
    beginRecord(PDF, "output-" + year() + month() + day() + "-" + hour() + minute() + second() + ".pdf");
  }
  
  if (mode == 0) {
    drawBezierMode();
  } else {
    drawSierpinskiMode();
  }
  
  if (showHelp) {
    drawHelp();
  }
  
  if (recordPDF) {
    endRecord();
    recordPDF = false;
    println("✓ PDF збережено!");
  }
}
