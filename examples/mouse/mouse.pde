// Draw ellipse at mouse position
color r = color(255, 0, 0);

void setup() {
    size(600, 400);
    background(0);
    strokeWeight(10);
    stroke(255, 255, 0);
}

void draw() {
    if (mousePressed) {
        line(pmouseX, pmouseY, mouseX, mouseY);
    }
}

void keyPressed() {
    if (key == 'w') {
        background(255);
    }
    if (key == 'b') {
        background(0);
    }
}
