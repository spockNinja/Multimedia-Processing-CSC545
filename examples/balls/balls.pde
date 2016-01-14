Ball[] balls = new Ball[50];
boolean frozen = false;

void setup() {
    size(600, 400);
    noStroke();
    for (int i=0; i < balls.length; i++) {
        balls[i] = new Ball();
    }
}

void draw() {
    for (int i = 0; i < balls.length; i++) {
        balls[i].move();
        balls[i].display();
    }
}

void keyPressed() {
    if (key == ' ') {
        if (frozen) {
            frozen = false;
            loop();
        }
        else {
            frozen = true;
            noLoop();
        }
    }
    else if (key == 'c' || key == 'C') {
        background(0);
    }
}
