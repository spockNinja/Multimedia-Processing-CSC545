// Pull out the white/yellow lines in an image
PImage img;
PFont f;
String fname = "marbles.jpg";
boolean drawn = false;
float textHeight = 24;

color r = color(255, 0, 0);
color g = color(0, 255, 0);
color b = color(0, 0, 255);

void setup() {
    size(400, 400);
    surface.setResizable(true);
    img = loadImage(fname);
    surface.setSize(img.width, img.height);

    f = createFont("Arial", textHeight);
    textFont(f);
    textAlign(LEFT, TOP);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(img, 0, 0);
    }

    if (mousePressed) {
        color currentPixel = img.get(mouseX, mouseY);
        String rDisplay = "RED: " + nf(red(currentPixel));
        String gDisplay = "GREEN: " + nf(green(currentPixel));
        String bDisplay = "BLUE: " + nf(blue(currentPixel));

        fill(r);
        text(rDisplay, 0, 0);

        fill(g);
        text(gDisplay, 0, textHeight);

        fill(b);
        text(bDisplay, 0, textHeight*2);
        drawn = false; // redraw next time
    }
}
