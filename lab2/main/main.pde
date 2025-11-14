/**
 * Arkanoid Game
 * Classic 2D brick-breaking arcade game
 */

Ball ball;
Paddle paddle;
ArrayList<Brick> bricks;

int gameState = 0; // 0 = START, 1 = PLAY, 2 = GAME_OVER
boolean ballLaunched = false;

// Game statistics
int score = 0;
int lives = 3;
int level = 1;
int highScore = 0;

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
  
  if (gameState == 0) {
    // START screen
    drawStartScreen();
  } else if (gameState == 1) {
    // PLAY
    drawGame();
  } else if (gameState == 2) {
    // GAME OVER
    drawGameOver();
  }
}

void drawGame() {
  // Update and display bricks
  for (int i = bricks.size() - 1; i >= 0; i--) {
    Brick brick = bricks.get(i);
    brick.display();
    
    // Check collision with ball
    if (ballLaunched && brick.checkCollision(ball)) {
      score += 10;
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
    
    // Check if ball fell off
    if (ball.checkBoundaryCollision()) {
      lives--;
      ballLaunched = false;
      ball.reset(paddle.position.x, paddle.position.y - paddle.h/2 - ball.radius - 2);
      
      if (lives <= 0) {
        gameState = 2; // GAME OVER
        if (score > highScore) {
          highScore = score;
        }
      }
    }
    
    paddle.checkCollision(ball);
  }
  
  ball.display();
  
  // HUD
  displayHUD();
  
  // Instructions
  if (!ballLaunched && lives > 0) {
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
    text("LEVEL COMPLETE!", width/2, height/2);
    textSize(20);
    text("Press SPACE for next level", width/2, height/2 + 40);
    ballLaunched = false;
  }
}

void drawStartScreen() {
  fill(100, 200, 255);
  textAlign(CENTER);
  textSize(48);
  text("ARKANOID", width/2, height/2 - 50);
  
  textSize(20);
  fill(255);
  text("Press SPACE to start", width/2, height/2 + 20);
  text("Controls: ← → or A D", width/2, height/2 + 50);
  
  if (highScore > 0) {
    textSize(16);
    fill(255, 255, 100);
    text("High Score: " + highScore, width/2, height/2 + 90);
  }
}

void drawGameOver() {
  fill(255, 100, 100);
  textAlign(CENTER);
  textSize(48);
  text("GAME OVER", width/2, height/2 - 50);
  
  textSize(24);
  fill(255);
  text("Final Score: " + score, width/2, height/2 + 20);
  
  if (score == highScore && score > 0) {
    fill(255, 255, 100);
    text("NEW HIGH SCORE!", width/2, height/2 + 50);
  }
  
  textSize(20);
  fill(200);
  text("Press R to restart", width/2, height/2 + 90);
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
    color(255, 100, 100),
    color(255, 200, 100),
    color(255, 255, 100),
    color(100, 255, 100),
    color(100, 200, 255)
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
  textSize(18);
  text("Score: " + score, 10, 25);
  text("Lives: " + lives, 10, 50);
  text("Level: " + level, width - 100, 25);
  
  // Draw lives as hearts
  for (int i = 0; i < lives; i++) {
    fill(255, 100, 100);
    ellipse(80 + i * 25, 60, 15, 15);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    score = 0;
    lives = 3;
    level = 1;
    ballLaunched = false;
    gameState = 0;
    setup();
  }
  
  if (key == ' ') {
    if (gameState == 0) {
      gameState = 1; // Start game
    } else if (gameState == 1 && !ballLaunched) {
      if (bricks.size() == 0) {
        // Next level
        level++;
        lives = min(lives + 1, 5); // Bonus life
        initializeBricks();
      }
      ball.launch();
      ballLaunched = true;
    }
  }
  
  if (gameState == 1) {
    paddle.handleKeyPress();
  }
}

void keyReleased() {
  paddle.handleKeyRelease();
}
