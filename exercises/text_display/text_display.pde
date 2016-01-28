// show text in display window
PFont f;
color fColor = color(255, 255, 0);
color mColor = color(255, 0, 255);
String hello = "Hello World!";
float textHeight = 48;

void setup() {
    size(600, 600);
    background(0);
    f = createFont("Arial", textHeight);
    textFont(f);

    textAlign(LEFT, CENTER);

    fill(fColor);
    float tw = textWidth(hello);
    int centerX = width/2;
    int centerY = height/2;
    text(hello, centerX-tw, centerY);
    stroke(100);
    noFill();

    rect(centerX-tw, centerY-textHeight/2, tw*2, textHeight);
}

void draw() {
    if (mousePressed) {
        String coords = "X: " + nf(mouseX) + "   Y: " + nf(mouseY);
        float tw = textWidth(coords);

        fill(0);
        noStroke();
        rect(75, 200, tw, textHeight);

        fill(mColor);
        textAlign(LEFT, TOP);
        text(coords, 75, 200);
    }
}
