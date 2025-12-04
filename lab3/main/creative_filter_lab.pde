PImage img;
PImage original;
String imagePath = "";
boolean imageLoaded = false;
String currentFilter = "None";
float filterIntensity = 50;
String currentTool = "None";
int brushSize = 20;
color brushColor = color(255, 0, 0);
boolean showHUD = true;
int blurRadius = 1;

void setup() {
  size(1200, 800, P2D);
  surface.setTitle("Creative Filter Lab");
  selectInput("Select an image:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection != null) {
    imagePath = selection.getAbsolutePath();
    img = loadImage(imagePath);
    if (img != null) {
      original = img.copy();
      imageLoaded = true;
      surface.setSize(img.width, img.height);
    }
  }
}

void draw() {
  background(30);
  if (imageLoaded) {
    image(img, 0, 0);
    if (currentTool.equals("Brush") || currentTool.equals("Eraser")) {
      noFill();
      stroke(255);
      ellipse(mouseX, mouseY, brushSize, brushSize);
    }
    if (showHUD) {
      drawHUD();
    }
  } else {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Press 'O' to open an image", width/2, height/2);
  }
}

void drawHUD() {
  fill(0, 150);
  noStroke();
  rect(10, 10, 280, 230, 10);
  
  fill(255);
  textAlign(LEFT, TOP);
  textSize(14);
  int y = 20;
  int lineHeight = 18;
  
  text("CREATIVE FILTER LAB", 20, y);
  y += lineHeight + 5;
  text("Filter: " + currentFilter, 20, y);
  y += lineHeight;
  text("Tool: " + currentTool, 20, y);
  y += lineHeight;
  text("Intensity: " + (int)filterIntensity, 20, y);
  y += lineHeight;
  text("Brush Size: " + brushSize, 20, y);
  y += lineHeight;
  text("Blur Radius: " + blurRadius, 20, y);
  y += lineHeight + 10;
  
  textSize(11);
  text("O-Open S-Save R-Reset H-HUD", 20, y);
  y += lineHeight;
  text("1-Gray 2-Invert 3-Bright 4-Contrast", 20, y);
  y += lineHeight;
  text("5-Blur 6-Sharpen 7-Edge", 20, y);
  y += lineHeight;
  text("B-Brush E-Eraser [/]-Size +/--Intensity", 20, y);
}

void mouseDragged() {
  if (!imageLoaded) return;
  
  if (currentTool.equals("Brush")) {
    drawBrush(mouseX, mouseY, brushColor);
  }
  if (currentTool.equals("Eraser")) {
    eraseArea(mouseX, mouseY);
  }
}

void mousePressed() {
  if (!imageLoaded) return;
  
  if (currentTool.equals("Brush")) {
    drawBrush(mouseX, mouseY, brushColor);
  }
  if (currentTool. equals("Eraser")) {
    eraseArea(mouseX, mouseY);
  }
}

void drawBrush(int x, int y, color c) {
  img.loadPixels();
  int radius = brushSize / 2;
  for (int i = -radius; i <= radius; i++) {
    for (int j = -radius; j <= radius; j++) {
      if (i*i + j*j <= radius*radius) {
        int px = x + i;
        int py = y + j;
        if (px >= 0 && px < img.width && py >= 0 && py < img.height) {
          int idx = py * img.width + px;
          img.pixels[idx] = c;
        }
      }
    }
  }
  img.updatePixels();
}

void eraseArea(int x, int y) {
  img.loadPixels();
  original.loadPixels();
  int radius = brushSize / 2;
  for (int i = -radius; i <= radius; i++) {
    for (int j = -radius; j <= radius; j++) {
      if (i*i + j*j <= radius*radius) {
        int px = x + i;
        int py = y + j;
        if (px >= 0 && px < img.width && py >= 0 && py < img.height) {
          int idx = py * img.width + px;
          img.pixels[idx] = original.pixels[idx];
        }
      }
    }
  }
  img.updatePixels();
}

void applyGrayscale() {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
    img.pixels[i] = color(gray);
  }
  img.updatePixels();
  currentFilter = "Grayscale";
}

void applyInvert() {
  img.loadPixels();
  for (int i = 0; i < img.pixels. length; i++) {
    color c = img.pixels[i];
    img.pixels[i] = color(255 - red(c), 255 - green(c), 255 - blue(c));
  }
  img.updatePixels();
  currentFilter = "Invert";
}

void applyBrightness(float amount) {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float r = constrain(red(c) + amount, 0, 255);
    float g = constrain(green(c) + amount, 0, 255);
    float b = constrain(blue(c) + amount, 0, 255);
    img.pixels[i] = color(r, g, b);
  }
  img.updatePixels();
  currentFilter = "Brightness";
}

void applyContrast(float amount) {
  float factor = (259 * (amount + 255)) / (255 * (259 - amount));
  img.loadPixels();
  for (int i = 0; i < img. pixels.length; i++) {
    color c = img.pixels[i];
    float r = constrain(factor * (red(c) - 128) + 128, 0, 255);
    float g = constrain(factor * (green(c) - 128) + 128, 0, 255);
    float b = constrain(factor * (blue(c) - 128) + 128, 0, 255);
    img.pixels[i] = color(r, g, b);
  }
  img.updatePixels();
  currentFilter = "Contrast";
}

void applyConvolution(float[][] kernel) {
  PImage result = createImage(img.width, img. height, RGB);
  img.loadPixels();
  result.loadPixels();
  
  int kSize = kernel.length;
  int offset = kSize / 2;
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      float rSum = 0, gSum = 0, bSum = 0;
      
      for (int ky = 0; ky < kSize; ky++) {
        for (int kx = 0; kx < kSize; kx++) {
          int px = constrain(x + kx - offset, 0, img.width - 1);
          int py = constrain(y + ky - offset, 0, img.height - 1);
          int idx = py * img.width + px;
          color c = img.pixels[idx];
          
          rSum += red(c) * kernel[ky][kx];
          gSum += green(c) * kernel[ky][kx];
          bSum += blue(c) * kernel[ky][kx];
        }
      }
      
      int idx = y * img.width + x;
      result.pixels[idx] = color(constrain(rSum, 0, 255), constrain(gSum, 0, 255), constrain(bSum, 0, 255));
    }
  }
  
  result.updatePixels();
  img = result;
}

void applyBlur() {
  int size = blurRadius * 2 + 1;
  float[][] kernel = new float[size][size];
  float val = 1.0 / (size * size);
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      kernel[i][j] = val;
    }
  }
  applyConvolution(kernel);
  currentFilter = "Blur";
}

void applySharpen() {
  float[][] kernel = {
    {0, -1, 0},
    {-1, 5, -1},
    {0, -1, 0}
  };
  applyConvolution(kernel);
  currentFilter = "Sharpen";
}

void applyEdgeDetection() {
  float[][] kernel = {
    {-1, -1, -1},
    {-1, 8, -1},
    {-1, -1, -1}
  };
  applyConvolution(kernel);
  currentFilter = "Edge Detection";
}

void resetImage() {
  img = original.copy();
  currentFilter = "None";
}

void saveImage() {
  String filename = "output_" + year() + month() + day() + "_" + hour() + minute() + second() + ".png";
  img.save(filename);
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Select an image:", "fileSelected");
  }
  if (!imageLoaded) return;
  
  if (key == 's' || key == 'S') {
    saveImage();
  }
  if (key == 'h' || key == 'H') {
    showHUD = !showHUD;
  }
  if (key == '1') {
    resetImage();
    applyGrayscale();
  }
  if (key == '2') {
    resetImage();
    applyInvert();
  }
  if (key == '3') {
    resetImage();
    applyBrightness(filterIntensity);
  }
  if (key == '4') {
    resetImage();
    applyContrast(filterIntensity);
  }
  if (key == '5') {
    resetImage();
    applyBlur();
  }
  if (key == '6') {
    resetImage();
    applySharpen();
  }
  if (key == '7') {
    resetImage();
    applyEdgeDetection();
  }
  if (key == 'r' || key == 'R') {
    resetImage();
  }
  if (key == '+' || key == '=') {
    filterIntensity = constrain(filterIntensity + 10, -255, 255);
    blurRadius = min(10, blurRadius + 1);
  }
  if (key == '-') {
    filterIntensity = constrain(filterIntensity - 10, -255, 255);
    blurRadius = max(1, blurRadius - 1);
  }
  if (key == 'b' || key == 'B') {
    currentTool = "Brush";
  }
  if (key == 'e' || key == 'E') {
    currentTool = "Eraser";
  }
  if (key == '[') {
    brushSize = max(5, brushSize - 5);
  }
  if (key == ']') {
    brushSize = min(100, brushSize + 5);
  }
}
