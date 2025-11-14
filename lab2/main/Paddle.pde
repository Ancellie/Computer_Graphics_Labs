class Paddle {
  PVector position;
  float w, h;
  float speed = 8;
  boolean movingLeft = false;
  boolean movingRight = false;
  color paddleColor;

  Paddle(float x, float y, float width, float height) {
    position = new PVector(x, y);
    w = width;
    h = height;
    paddleColor = color(100, 200, 255);
  }

  void update() {
    // Keyboard movement
    if (movingLeft) {
      position.x -= speed;
    }
    if (movingRight) {
      position.x += speed;
    }
    
    // Mouse movement (optional, can comment out)
    // position.x = mouseX;
    
    // Constrain to screen
    position.x = constrain(position.x, w/2, width - w/2);
  }

  void handleKeyPress() {
    if (key == 'a' || key == 'A' || keyCode == LEFT) {
      movingLeft = true;
    }
    if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      movingRight = true;
    }
  }

  void handleKeyRelease() {
    if (key == 'a' || key == 'A' || keyCode == LEFT) {
      movingLeft = false;
    }
    if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      movingRight = false;
    }
  }

  void checkCollision(Ball ball) {
    // Circle-Rectangle collision detection
    float halfW = w / 2;
    float halfH = h / 2;
    
    // Find closest point on rectangle to circle center
    float closestX = constrain(ball.position.x, position.x - halfW, position.x + halfW);
    float closestY = constrain(ball.position.y, position.y - halfH, position.y + halfH);
    
    // Calculate distance
    float distanceX = ball.position.x - closestX;
    float distanceY = ball.position.y - closestY;
    float distanceSquared = distanceX * distanceX + distanceY * distanceY;
    
    // Check collision
    if (distanceSquared < (ball.radius * ball.radius)) {
      // Collision detected!
      
      // Bounce ball upward
      ball.velocity.y = -abs(ball.velocity.y);
      
      // Add horizontal velocity based on hit position
      float hitPos = (ball.position.x - position.x) / (w / 2);
      ball.velocity.x += hitPos * 2;
      
      // Limit velocity
      ball.velocity.limit(8);
      
      // Move ball above paddle to prevent sticking
      ball.position.y = position.y - halfH - ball.radius;
    }
  }

  void display() {
    noStroke();
    fill(paddleColor);
    rectMode(CENTER);
    rect(position.x, position.y, w, h, 5);
  }
}
