/*
    Test 1: Perform median filtering on an image

    Author: Jacob Foster
    Date: 3/3/2016
    Class: CSC 545
    Professor: Dr. Lloyd Smith
*/
PImage img, filteredImg, currentImg;
String fname = "Test1_img1.png";
boolean drawn = false;
int matrixSize = 3;

void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;

    filteredImg = medianFilter(img);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(currentImg, 0, 0);
    }
}

PImage medianFilter(PImage source) {
    PImage median = createImage(source.width, source.height, RGB);
    int offset = (matrixSize-1)/2;
    int medianIdx = (matrixSize*matrixSize-1)/2;

    for (int x = 0; x < source.width; x++) {
        for (int y = 0; y < source.height; y++) {
            color toSet;
            if (x < offset || y < offset || x > source.width-offset || y > source.height-offset) {
                toSet = source.get(x, y);
            }
            else {
                toSet = applyFilter(source, x, y, offset, medianIdx);
            }
            median.set(x, y, toSet);
        }
    }

    return median;
}

color applyFilter(PImage source, int centerX, int centerY, int offset, int medianIdx) {
    float[] reds = new float[matrixSize*matrixSize];
    float[] greens = new float[matrixSize*matrixSize];
    float[] blues = new float[matrixSize*matrixSize];

    int colorArraysIdx = 0;
    for (int i = 0; i < matrixSize; i++) {
        int sourceX = i + (centerX-offset);
        for (int j = 0; j < matrixSize; j++) {
            int sourceY = j + (centerY-offset);
            color pixel = source.get(sourceX, sourceY);

            reds[colorArraysIdx] = red(pixel);
            greens[colorArraysIdx] = green(pixel);
            blues[colorArraysIdx] = blue(pixel);

            colorArraysIdx++;
        }
    }

    float[] sortedR = sort(reds);
    float[] sortedG = sort(greens);
    float[] sortedB = sort(blues);

    return color(sortedR[medianIdx], sortedG[medianIdx], sortedB[medianIdx]);
}

void keyReleased() {
    switch (key) {
        case '1':
            currentImg = img;
            break;
        case '2':
            currentImg = filteredImg;
            break;
    }
    drawn = false;
}
