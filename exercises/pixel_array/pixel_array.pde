// Display negative/grayscale/binary images
PImage img, distImg, selectedDistImg, currentImg;
String fname = "4.2.03.jpg";
boolean drawn = false;
int startX, startY, endX, endY;


void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;

    img.loadPixels();
    distImg = avgDist(img, findAverageColor(img));

    rectMode(CORNERS);
}

void draw() {
    if (!drawn || mousePressed) {
        drawn = true;
        image(currentImg, 0, 0);

        if (mousePressed) {
            noFill();
            stroke(255, 255, 0);
            rect(startX, startY, mouseX, mouseY);
        }
    }
}

float calculateColorDistance(color first, color second) {
    return dist(red(first), blue(first), green(first),
                red(second), blue(second), green(second));
}

color findAverageColor(PImage source) {
    float sumRed = 0, sumGreen = 0, sumBlue = 0;
    for (int i = 0; i < source.pixels.length; i++) {
        color pix = source.pixels[i];
        sumRed += red(pix);
        sumGreen += green(pix);
        sumBlue += blue(pix);
    }

    float avgRed = sumRed/source.pixels.length;
    float avgGreen = sumGreen/source.pixels.length;
    float avgBlue = sumBlue/source.pixels.length;
    return color(avgRed, avgGreen, avgBlue);
}

PImage avgDist(PImage source, color avgColor) {
    PImage dist = createImage(source.width, source.height, RGB);
    for (int i = 0; i < source.pixels.length; i++) {
        color srcPix = source.pixels[i];
        dist.pixels[i] = color(calculateColorDistance(srcPix, avgColor));
    }
    dist.updatePixels();
    return dist;
}

void keyReleased() {
    if (key == '1') {
        currentImg = img;
    }
    else if (key == '2') {
        currentImg = distImg;
    }
    else if (key == '3') {
        currentImg = selectedDistImg;
    }
    drawn = false;
}

void mousePressed() {
    startX = mouseX;
    startY = mouseY;
}

void mouseReleased() {
    endX = mouseX;
    endY = mouseY;
    if (startX > mouseX) {
        endX = startX;
        startX = mouseX;
    }
    if (startY > mouseY) {
        endY = startY;
        startY = mouseY;
    }

    PImage selectedArea = createImage(abs(startX-endX), abs(startY-endY), RGB);
    for (int x = startX; x < endX; x++) {
        for (int y = startY; y < endY; y++) {
            selectedArea.set(x-startX, y-startY, img.get(x, y));
        }
    }
    selectedArea.loadPixels();

    selectedDistImg = avgDist(img, findAverageColor(selectedArea));
    currentImg = selectedDistImg;
    drawn = false;
}
