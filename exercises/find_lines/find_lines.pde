// Pull out the white/yellow lines in an image
PImage currentImg;
PImage[] images = new PImage[4];
String fname = "emptyroad.jpg";
boolean drawn = false;

color yellow = color(255, 255, 0);
color white = color(255, 255, 255);
color black = color(0, 0, 0);
float wThresh = 75;
float yThresh = 170;

void setup() {
    size(400, 400);
    surface.setResizable(true);
    images[0] = loadImage(fname);
    currentImg = images[0];
    surface.setSize(currentImg.width, currentImg.height);


    PImage whiteLines = findColor(currentImg, white, wThresh, white);
    PImage yellowLines = findColor(currentImg, yellow, yThresh, yellow);
    images[1] = whiteLines;
    images[2] = yellowLines;
    images[3] = combineImages(whiteLines, yellowLines);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(currentImg, 0, 0);
    }
}

PImage findColor(PImage original, color refColor, float threshold, color repColor) {
    PImage filteredImg = createImage(original.width, original.height, ARGB);

    for (int y = 0; y < original.height; y++) {
        for (int x = 0; x < original.width; x++) {
            color originalPixel = original.get(x, y);
            float cDist = calculateColorDistance(originalPixel, refColor);
            if (cDist > threshold) {
                filteredImg.set(x, y, black);
            }
            else {
                filteredImg.set(x, y, repColor);
            }
        }
    }

    return filteredImg;
}

PImage combineImages(PImage img1, PImage img2) {
    PImage combinedImg = createImage(img1.width, img2.height, ARGB);

    for (int y = 0; y < img1.height; y++) {
        for (int x = 0; x < img1.width; x++) {
            color img1Pix = img1.get(x, y);
            color img2Pix = img2.get(x, y);
            combinedImg.set(x, y, img1Pix + img2Pix);
        }
    }

    return combinedImg;
}

float calculateColorDistance(color first, color second) {
    float r = pow((red(first) - red(second)), 2);
    float g = pow((green(first) - green(second)), 2);
    float b = pow((blue(first) - blue(second)), 2);
    return sqrt(r + g + b);
}

void keyReleased() {
    switch (key) {
        case '0':
            currentImg = images[0];
            break;
        case '1':
            currentImg = images[1];
            break;
        case '2':
            currentImg = images[2];
            break;
        case '3':
            currentImg = images[3];
            break;
    }
    drawn = false;
}
