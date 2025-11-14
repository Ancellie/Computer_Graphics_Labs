/**
 * Arkanoid Game
 * Classic 2D brick-breaking arcade game
 * with Power-ups!
 */

Ball ball;
Paddle paddle;
ArrayList<Brick> bricks;
ArrayList<PowerUp> powerUps;

int gameState = 0;
boolean ballLaunched = false;

int score = 0;
int lives = 3;
int level = 1;
int highScore = 0;
int difficulty = 1;

// Power-up timers
int paddleExpandTimer = 0;
int slowBallTimer = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  
  ball = new Ball(width/2, height - 80, 10);
  paddle = new Paddle(width/2, height - 30, 100, 15);
  powerUps = new ArrayList<PowerUp>();
  
  applyDifficulty();
  initializeBricks();
}

void applyDifficulty() {
  if (difficulty == 1) {
    ball.maxSpeed = 6;
    paddle.w = 120;
    paddle.speed = 8;
  } else if (difficulty == 2) {
    ball.maxSpeed = 7;
    paddle.w = 100;
    paddle.speed = 9;
  } else {
    ball.maxSpeed = 9;
    paddle.w = 80;
    paddle.speed = 10;
  }
  
  float levelMultiplier = 1 + (level - 1) * 0.1;
  ball.maxSpeed *= levelMultiplier;
}

void draw() {
  background(20, 20, 40);
  
  if (gameState == 0) {
    drawStartScreen();
  } else if (gameState == 1) {
    drawGame();
  } else if (gameState == 2) {
    drawGameOver();
  }
}

void drawGame() {
  // Update power-up timers
  if (paddleExpandTimer > 0) {
    paddleExpandTimer--;
    if (paddleExpandTimer == 0) {
      paddle.w = 100; // Reset size
      applyDifficulty();
    }
  }
  
  if (slowBallTimer > 0) {
    slowBallTimer--;
    if (slowBallTimer == 0) {
      ball.maxSpeed = 7; // Reset speed
      applyDifficulty();
    }
  }
  
  // Update and display bricks
  for (int i = bricks.size() - 1; i >= 0; i--) {
    Brick brick = bricks.get(i);
    brick.display();
    
    if (ballLaunched && brick.checkCollision(ball)) {
      score += 10 * difficulty;
      
      // Random power-up drop (15% chance)
      if (random(1) < 0.15) {
        int powerType = int(random(4));
        powerUps.add(new PowerUp(brick.position.x, brick.position.y, powerType));
      }
      
      bricks.remove(i);
    }
  }
  
  // Update and display power-ups
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    p.update();
    p.display();
    
    if (p.checkCollision(paddle)) {
      activatePowerUp(p.type);
      powerUps.remove(i);
    } else if (p.isOffScreen()) {
      powerUps.remove(i);
    }
  }
  
  paddle.update();
  paddle.display();
  
  if (!ballLaunched) {
    ball.position.x = paddle.position.x;
    ball.position.y = paddle.position.y - paddle.h/2 - ball.radius - 2;
  } else {
    ball.update();
    
    if (ball.checkBoundaryCollision()) {
      lives--;
      ballLaunched = false;
      ball.reset(paddle.position.x, paddle.position.y - paddle.h/2 - ball.radius - 2);
      
      // Reset power-ups on death
      paddleExpandTimer = 0;
      slowBallTimer = 0;
      paddle.w = 100;
      applyDifficulty();
      
      if (lives <= 0) {
        gameState = 2;
        if (score > highScore) {
          highScore = score;
        }
      }
    }
    
    paddle.checkCollision(ball);
  }
  
  ball.display();
  displayHUD();
  
  if (!ballLaunched && lives > 0) {
    fill(255, 255, 100);
    textAlign(CENTER);
    textSize(20);
    text("Press SPACE to launch", width/2, height/2);
  }
  
  if (bricks.size() == 0 && ballLaunched) {
    fill(100, 255, 100);
    textAlign(CENTER);
    textSize(32);
    text("LEVEL COMPLETE!", width/2, height/2);
    textSize(20);
    text("Score Bonus: +" + (lives * 50), width/2, height/2 + 35);
    text("Press SPACE for next level", width/2, height/2 + 65);
    ballLaunched = false;
  }
}

void activatePowerUp(int type) {
  score += 25; // Bonus for collecting power-up
  
  switch(type) {
    case 0: // Expand paddle
      paddle.w = 150;
      paddleExpandTimer = 600; // 10 seconds
      break;
    case 1: // Extra life
      lives = min(lives + 1, 5);
      break;
    case 2: // Slow ball
      ball.maxSpeed = 4;
      slowBallTimer = 600;
      break;
    case 3: // Multi-ball (simplified - just speed boost)
      ball.velocity.mult(1.2);
      break;
  }
}

void drawStartScreen() {
  fill(100, 200, 255);
  textAlign(CENTER);
  textSize(48);
  text("ARKANOID", width/2, height/2 - 100);
  
  textSize(24);
  fill(255);
  text("Select Difficulty:", width/2, height/2 - 20);
  
  drawDifficultyButton(1, "EASY", width/2 - 150, height/2 + 30);
  drawDifficultyButton(2, "MEDIUM", width/2, height/2 + 30);
  drawDifficultyButton(3, "HARD", width/2 + 150, height/2 + 30);
  
  textSize(18);
  fill(200);
  text("Press 1, 2, or 3 to select", width/2, height/2 + 90);
  text("Press SPACE to start", width/2, height/2 + 115);
  text("Controls: ← → or A D", width/2, height/2 + 140);
  
  // Power-up legend
  textSize(14);
  fill(150);
  text("Power-ups: [W] Wide Paddle  [+] Extra Life  [S] Slow Ball  [M] Speed Boost", width/2, height - 80);
  
  if (highScore > 0) {
    textSize(16);
    fill(255, 255, 100);
    text("High Score: " + highScore, width/2, height - 50);
  }
}

void drawDifficultyButton(int diff, String label, float x, float y) {
  if (difficulty == diff) {
    fill(100, 255, 100);
    strokeWeight(3);
    stroke(255);
  } else {
    fill(60, 60, 100);
    strokeWeight(1);
    stroke(150);
  }
  
  rectMode(CENTER);
  rect(x, y, 120, 40, 5);
  
  fill(255);
  textSize(18);
  text(label, x, y + 6);
  noStroke();
}

void drawGameOver() {
  fill(255, 100, 100);
  textAlign(CENTER);
  textSize(48);
  text("GAME OVER", width/2, height/2 - 70);
  
  textSize(24);
  fill(255);
  text("Final Score: " + score, width/2, height/2);
  text("Level Reached: " + level, width/2, height/2 + 35);
  
  if (score == highScore && score > 0) {
    fill(255, 255, 100);
    textSize(28);
    text("★ NEW HIGH SCORE! ★", width/2, height/2 + 75);
  }
  
  textSize(20);
  fill(200);
  text("Press R to restart", width/2, height/2 + 120);
}

void initializeBricks() {
  bricks = new ArrayList<Brick>();
  
  int rows = 5 + (level - 1);
  rows = min(rows, 8);
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
    color(100, 200, 255),
    color(200, 100, 255),
    color(255, 100, 200),
    color(100, 255, 255)
  };
  
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      float x = startX + col * (brickWidth + 10) + brickWidth / 2;
      float y = startY + row * (brickHeight + 10) + brickHeight / 2;
      bricks.add(new Brick(x, y, brickWidth, brickHeight, rowColors[row % rowColors.length]));
    }
  }
}

void displayHUD() {
  fill(255);
  textAlign(LEFT);
  textSize(18);
  text("Score: " + score, 10, 25);
  text("Lives: " + lives, 10, 50);
  
  textAlign(RIGHT);
  text("Level: " + level, width - 10, 25);
  String diffText = difficulty == 1 ? "Easy" : (difficulty == 2 ? "Medium" : "Hard");
  text("Difficulty: " + diffText, width - 10, 50);
  
  // Active power-ups indicator
  textAlign(LEFT);
  textSize(14);
  fill(100, 255, 100);
  if (paddleExpandTimer > 0) {
    text("Wide Paddle: " + (paddleExpandTimer/60) + "s", 10, height - 30);
  }
  if (slowBallTimer > 0) {
    text("Slow Ball: " + (slowBallTimer/60) + "s", 10, height - 10);
  }
  
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
    paddleExpandTimer = 0;
    slowBallTimer = 0;
    gameState = 0;
    powerUps.clear();
    setup();
  }
  
  if (gameState == 0) {
    if (key == '1') difficulty = 1;
    if (key == '2') difficulty = 2;
    if (key == '3') difficulty = 3;
  }
  
  if (key == ' ') {
    if (gameState == 0) {
      gameState = 1;
      applyDifficulty();
    } else if (gameState == 1 && !ballLaunched) {
      if (bricks.size() == 0) {
        level++;
        score += lives * 50;
        lives = min(lives + 1, 5);
        applyDifficulty();
        powerUps.clear();
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
