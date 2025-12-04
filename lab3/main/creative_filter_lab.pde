class Ball {
  PVector position;
  PVector velocity;
  float radius;
  float maxSpeed = 7;
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
    
    // Ensure minimum speed
    if (velocity.mag() < 3) {
      velocity.setMag(3);
    }
    
    // Limit maximum speed
    velocity.limit(maxSpeed);
  }

  boolean checkBoundaryCollision() {
    boolean fellOff = false;
    
    if (position.x > width - radius) {
      position.x = width - radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    }
    
    if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
    
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
    
    // Trail effect
    fill(ballColor, 50);
    ellipse(position.x - velocity.x, position.y - velocity.y, radius * 2, radius * 2);
    
    fill(ballColor);
    ellipse(position.x, position.y, radius * 2, radius * 2);
    
    // Glow effect
    fill(255, 255, 255, 150);
    ellipse(position.x - 2, position.y - 2, radius, radius);
  }
}
