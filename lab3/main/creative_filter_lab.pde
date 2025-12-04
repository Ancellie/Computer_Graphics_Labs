PImage img;
PImage original;
String imagePath = "";
boolean imageLoaded = false;
String currentFilter = "None";

void setup() {
  size(1000, 600, P2D);
  surface. setTitle("Creative Filter Lab");
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
  } else {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Press 'O' to open an image", width/2, height/2);
  }
}

void applyGrayscale() {
  img.loadPixels();
  for (int i = 0; i < img. pixels.length; i++) {
    color c = img.pixels[i];
    float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
    img.pixels[i] = color(gray);
  }
  img.updatePixels();
  currentFilter = "Grayscale";
}

void applyInvert() {
  img.loadPixels();
  for (int i = 0; i < img. pixels.length; i++) {
    color c = img.pixels[i];
    img.pixels[i] = color(255 - red(c), 255 - green(c), 255 - blue(c));
  }
  img.updatePixels();
  currentFilter = "Invert";
}

void resetImage() {
  img = original.copy();
  currentFilter = "None";
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Select an image:", "fileSelected");
  }
  if (! imageLoaded) return;
  
  if (key == '1') {
    resetImage();
    applyGrayscale();
  }
  if (key == '2') {
    resetImage();
    applyInvert();
  }
  if (key == 'r' || key == 'R') {
    resetImage();
  }
}
