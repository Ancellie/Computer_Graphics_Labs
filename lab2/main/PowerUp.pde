class PowerUp {
  PVector position;
  PVector velocity;
  float size = 20;
  int type; // 0 = expand paddle, 1 = extra life, 2 = slow ball, 3 = multi-ball
  color powerColor;
  String label;
  boolean collected = false;

  PowerUp(float x, float y, int t) {
    position = new PVector(x, y);
    velocity = new PVector(0, 2);
    type = t;
    
    switch(type) {
      case 0:
        powerColor = color(100, 200, 255);
        label = "W";
        break;
      case 1:
        powerColor = color(255, 100, 100);
        label = "+";
        break;
      case 2:
        powerColor = color(255, 255, 100);
        label = "S";
        break;
      case 3:
        powerColor = color(200, 100, 255);
        label = "M";
        break;
    }
  }

  void update() {
    position.add(velocity);
  }

  boolean checkCollision(Paddle paddle) {
    float d = dist(position.x, position.y, paddle.position.x, paddle.position.y);
    if (d < size + paddle.w/2) {
      collected = true;
      return true;
    }
    return false;
  }

  boolean isOffScreen() {
    return position.y > height + size;
  }

  void display() {
    noStroke();
    fill(powerColor);
    ellipse(position.x, position.y, size * 2, size * 2);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, position.x, position.y);
  }
}
