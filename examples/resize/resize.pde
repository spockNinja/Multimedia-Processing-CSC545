// Resize window from keypresses

void setup() {
    size(600, 400);
    surface.setResizable(true);
    background(0);
}

void draw() {
    // Just handling resizes
}

void keyPressed() {
    if (key == '1') {
        surface.setSize(100, 100);
        println(width, height);
    }
    else if (key == '2') {
        surface.setSize(200, 200);
        println(width, height);
    }
    else if (key == '3') {
        surface.setSize(300, 300);
        println(width, height);
    }
    else if (key == '0') {
        surface.setSize(600, 400);
        println(width, height);
    }
}
