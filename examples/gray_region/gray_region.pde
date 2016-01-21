// Convert image to grayscale
PImage img;
PImage currentImg;
PImage grayImg;
String fname = "colorful1.jpg";
int startX = 0, startY = 0;

void setup() {
    size(400, 400);
    surface.setResizable(true);
    img = loadImage(fname);
    surface.setSize(img.width, img.height);
    currentImg = img;

    noFill();
    stroke(255, 0, 0);
    rectMode(CORNERS);
}

void draw() {
    image(currentImg, 0, 0);

    if (mousePressed) {
        rect(startX, startY, mouseX, mouseY);
    }
}

PImage grayScale(PImage targetImg, int sx, int sy, int ex, int ey) {
    PImage grayScaledImage = targetImg.get();

    for (int y = sy; y < ey; y++) {
        for (int x = sx; x < ex; x++) {
            color c = targetImg.get(x, y);
            float r = red(c), g = green(c), b = blue(c);
            float grayScaled = (r + g + b)/3.0;
            grayScaledImage.set(x, y, color(grayScaled));
        }
    }

    return grayScaledImage;
}

void keyReleased() {
    if (key == 'c' || key == 'C') {
        currentImg = img;
    }
    else if (key == 'g' || key == 'G') {
        grayImg = grayScale(img, 0, 0, img.width, img.height);
        currentImg = grayImg;
    }
}

void mousePressed() {
    startX = mouseX;
    startY = mouseY;
    currentImg = img;
}

void mouseReleased() {
    int endX = mouseX, endY = mouseY;

    if (startX > mouseX) {
        endX = startX;
        startX = mouseX;
    }
    if (startY > mouseY) {
        endY = startY;
        startY = mouseY;
    }
    grayImg = grayScale(img, startX, startY, endX, endY);
    currentImg = grayImg;
}
