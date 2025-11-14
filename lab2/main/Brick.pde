class Brick {
  PVector position;
  float w, h;
  color brickColor;
  boolean destroyed = false;

  Brick(float x, float y, float width, float height, color c) {
    position = new PVector(x, y);
    w = width;
    h = height;
    brickColor = c;
  }

  boolean checkCollision(Ball ball) {
    if (destroyed) return false;
    
    // AABB (Axis-Aligned Bounding Box) collision detection
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
      destroyed = true;
      
      // Determine bounce direction
      float overlapX = ball.radius - abs(ball.position.x - closestX);
      float overlapY = ball.radius - abs(ball.position.y - closestY);
      
      // Bounce on the axis with less overlap
      if (overlapX < overlapY) {
        ball.velocity.x *= -1;
      } else {
        ball.velocity.y *= -1;
      }
      
      return true;
    }
    
    return false;
  }

  void display() {
    if (!destroyed) {
      noStroke();
      fill(brickColor);
      rectMode(CENTER);
      rect(position.x, position.y, w, h, 3);
      
      // Highlight effect
      fill(255, 255, 255, 50);
      rect(position.x, position.y - h/4, w - 4, h/3, 2);
    }
  }
}
