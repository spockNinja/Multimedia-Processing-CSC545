int x = 40, y = 40;
int w = 50, h = 50;
int speed = 5;

int sw = 600;

void setup() {
  size(600, 400);
  fill(255, 0, 0);
  background(0);
  noStroke();
}

void draw() {
  background(0);
  ellipse(x, y, w, h);

  int circleCenter = w/2;
  if (x < (0 + circleCenter) || x > (sw - circleCenter)) {
    speed = speed*-1;
  }
  x += speed;
}
