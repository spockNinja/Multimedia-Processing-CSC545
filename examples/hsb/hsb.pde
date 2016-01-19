// Draw a window with HSB colors
void setup() {
    size(360, 200);
    background(0);
    colorMode(HSB, 360, 100, 100);

    for (int i = 0; i < width; i++) {
        color c = color(i, 100, 100);
        stroke(c);
        line(i, 0, i, height);
    }
}

void draw() {
    // just draw setup
}
