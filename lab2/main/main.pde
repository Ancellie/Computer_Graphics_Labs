/**
 * Arkanoid Game
 * Classic 2D brick-breaking arcade game
 * 
 * Based on circle collision physics
 */

Ball ball;
Paddle paddle;
int gameState = 0; // 0 = START, 1 = PLAY, 2 = GAME_OVER
boolean ballLaunched = false;

void setup() {
  size(800, 600);
  frameRate(60);
  
  // Initialize game objects
  ball = new Ball(width/2, height - 80, 10);
  paddle = new Paddle(width/2, height - 30, 100, 15);
}

void draw() {
  background(20, 20, 40);
  
  // Update paddle
  paddle.update();
  paddle.display();
  
  // Update ball
  if (!ballLaunched) {
    // Ball follows paddle before launch
    ball.position.x = paddle.position.x;
    ball.position.y = paddle.position.y - paddle.h/2 - ball.radius - 2;
  } else {
    ball.update();
    ball.checkBoundaryCollision();
    
    // Check collision with paddle
    paddle.checkCollision(ball);
  }
  
  ball.display();
  
  // Simple HUD
  displayHUD();
  
  // Instructions
  if (!ballLaunched) {
    fill(255, 255, 100);
    textAlign(CENTER);
    textSize(20);
    text("Press SPACE to launch", width/2, height/2);
  }
}

void displayHUD() {
  fill(255);
  textAlign(LEFT);
  textSize(16);
  text("Arkanoid Game", 10, 25);
  text("FPS: " + int(frameRate), 10, 45);
  text("Controls: ← → or A D", 10, 65);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    ballLaunched = false;
    setup(); // Restart
  }
  
  if (key == ' ' && !ballLaunched) {
    ball.launch();
    ballLaunched = true;
  }
  
  // Paddle controls
  paddle.handleKeyPress();
}

void keyReleased() {
  paddle.handleKeyRelease();
}
