class Ball {
  PVector position;
  PVector velocity;
  float radius;
  color ballColor;

  Ball(float x, float y, float r) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    radius = r;
    ballColor = color(255, 100, 100);
  }
  
  void launch() {
    float angle = random(-PI/3, -2*PI/3);
    velocity = PVector.fromAngle(angle);
    velocity.mult(5);
  }

  void update() {
    position.add(velocity);
  }

  boolean checkBoundaryCollision() {
    boolean fellOff = false;
    
    // Left and right walls
    if (position.x > width - radius) {
      position.x = width - radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    }
    
    // Top wall
    if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
    
    // Bottom - ball falls off
    if (position.y > height + radius) {
      fellOff = true;
    }
    
    return fellOff;
  }
  
  void reset(float x, float y) {
    position.set(x, y);
    velocity.set(0, 0);
  }

  void display() {
    noStroke();
    fill(ballColor);
    ellipse(position.x, position.y, radius * 2, radius * 2);
    
    // Glow effect
    fill(255, 255, 255, 100);
    ellipse(position.x - 2, position.y - 2, radius, radius);
  }
}
