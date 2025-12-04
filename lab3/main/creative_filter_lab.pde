PImage img;
PImage original;
String imagePath = "";
boolean imageLoaded = false;
String currentFilter = "None";
float filterIntensity = 50;
String currentTool = "None";
int brushSize = 20;
color brushColor = color(255, 0, 0);

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
      surface. setSize(img.width, img.height);
    }
  }
}

void draw() {
  background(30);
  if (imageLoaded) {
    image(img, 0, 0);
    if (currentTool. equals("Brush") || currentTool.equals("Eraser")) {
      noFill();
      stroke(255);
      ellipse(mouseX, mouseY, brushSize, brushSize);
    }
  } else {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Press 'O' to open an image", width/2, height/2);
  }
}

void mouseDragged() {
  if (! imageLoaded) return;
  
  if (currentTool.equals("Brush")) {
    drawBrush(mouseX, mouseY, brushColor);
  }
  if (currentTool. equals("Eraser")) {
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
  original.loadPixels();
  int radius = brushSize / 2;
  for (int i = -radius; i <= radius; i++) {
    for (int j = -radius; j <= radius; j++) {
      if (i*i + j*j <= radius*radius) {
        int px = x + i;
        int py = y + j;
        if (px >= 0 && px < img.width && py >= 0 && py < img. height) {
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
    img. pixels[i] = color(gray);
  }
  img. updatePixels();
  currentFilter = "Grayscale";
}

void applyInvert() {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
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
  img. updatePixels();
  currentFilter = "Brightness";
}

void applyContrast(float amount) {
  float factor = (259 * (amount + 255)) / (255 * (259 - amount));
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float r = constrain(factor * (red(c) - 128) + 128, 0, 255);
    float g = constrain(factor * (green(c) - 128) + 128, 0, 255);
    float b = constrain(factor * (blue(c) - 128) + 128, 0, 255);
    img. pixels[i] = color(r, g, b);
  }
  img.updatePixels();
  currentFilter = "Contrast";
}

void resetImage() {
  img = original.copy();
  currentFilter = "None";
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Select an image:", "fileSelected");
  }
  if (!imageLoaded) return;
  
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
  if (key == 'r' || key == 'R') {
    resetImage();
  }
  if (key == '+' || key == '=') {
    filterIntensity = constrain(filterIntensity + 10, -255, 255);
  }
  if (key == '-') {
    filterIntensity = constrain(filterIntensity - 10, -255, 255);
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
