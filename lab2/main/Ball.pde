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
    // Launch ball at random angle upward
    float angle = random(-PI/3, -2*PI/3); // Between -60° and -120°
    velocity = PVector.fromAngle(angle);
    velocity.mult(5);
  }

  void update() {
    position.add(velocity);
  }

  void checkBoundaryCollision() {
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
    
    // Bottom - ball falls off (TODO: later)
    if (position.y > height + radius) {
      reset();
    }
  }
  
  void reset() {
    position.set(width/2, height/2);
    velocity.set(0, 0);
  }

  void display() {
    noStroke();
    fill(ballColor);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}
