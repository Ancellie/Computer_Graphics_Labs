/**
 * Arkanoid Game
 * Classic 2D brick-breaking arcade game
 */

Ball ball;
Paddle paddle;
ArrayList<Brick> bricks;

int gameState = 0; // 0 = START, 1 = PLAY, 2 = GAME_OVER
boolean ballLaunched = false;

void setup() {
  size(800, 600);
  frameRate(60);
  
  // Initialize game objects
  ball = new Ball(width/2, height - 80, 10);
  paddle = new Paddle(width/2, height - 30, 100, 15);
  
  // Create bricks
  initializeBricks();
}

void draw() {
  background(20, 20, 40);
  
  // Update and display bricks
  for (int i = bricks.size() - 1; i >= 0; i--) {
    Brick brick = bricks.get(i);
    brick.display();
    
    // Check collision with ball
    if (ballLaunched && brick.checkCollision(ball)) {
      bricks.remove(i);
    }
  }
  
  // Update paddle
  paddle.update();
  paddle.display();
  
  // Update ball
  if (!ballLaunched) {
    ball.position.x = paddle.position.x;
    ball.position.y = paddle.position.y - paddle.h/2 - ball.radius - 2;
  } else {
    ball.update();
    ball.checkBoundaryCollision();
    paddle.checkCollision(ball);
  }
  
  ball.display();
  
  // HUD
  displayHUD();
  
  // Instructions
  if (!ballLaunched) {
    fill(255, 255, 100);
    textAlign(CENTER);
    textSize(20);
    text("Press SPACE to launch", width/2, height/2);
  }
  
  // Win condition
  if (bricks.size() == 0 && ballLaunched) {
    fill(100, 255, 100);
    textAlign(CENTER);
    textSize(32);
    text("YOU WIN!", width/2, height/2);
    textSize(20);
    text("Press R to restart", width/2, height/2 + 40);
  }
}

void initializeBricks() {
  bricks = new ArrayList<Brick>();
  
  int rows = 5;
  int cols = 10;
  float brickWidth = 70;
  float brickHeight = 25;
  float startX = (width - (cols * brickWidth + (cols - 1) * 10)) / 2;
  float startY = 80;
  
  color[] rowColors = {
    color(255, 100, 100),  // Red
    color(255, 200, 100),  // Orange
    color(255, 255, 100),  // Yellow
    color(100, 255, 100),  // Green
    color(100, 200, 255)   // Blue
  };
  
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      float x = startX + col * (brickWidth + 10) + brickWidth / 2;
      float y = startY + row * (brickHeight + 10) + brickHeight / 2;
      bricks.add(new Brick(x, y, brickWidth, brickHeight, rowColors[row]));
    }
  }
}

void displayHUD() {
  fill(255);
  textAlign(LEFT);
  textSize(16);
  text("Arkanoid Game", 10, 25);
  text("Bricks left: " + bricks.size(), 10, 45);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    ballLaunched = false;
    setup();
  }
  
  if (key == ' ' && !ballLaunched) {
    ball.launch();
    ballLaunched = true;
  }
  
  paddle.handleKeyPress();
}

void keyReleased() {
  paddle.handleKeyRelease();
}
