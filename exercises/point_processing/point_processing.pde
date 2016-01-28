// Display negative/grayscale/binary images
PImage img, negImg, grayImg, binImg, currentImg;
String fname = "4.2.03.jpg";
boolean drawn = false;
int binThresh = 174;

color black = color(0);
color white = color(255);

void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;

    img.loadPixels();
    negImg = negative(img);
    grayImg = grayscale(img);
    binImg = makeBinary(img, binThresh);
}

void draw() {
    if (!drawn || mousePressed) {
        drawn = true;
        if (mousePressed) {
            // Layer the base image and the current image
            image(img, 0, 0);
            image(currentImg, mouseX, 0, currentImg.width, currentImg.height,
                              mouseX, 0, currentImg.width+mouseX, currentImg.height);
        }
        else {
            image(currentImg, 0, 0);
        }
    }
}

PImage negative(PImage source) {
    PImage neg = createImage(source.width, source.height, RGB);
    int dimension = source.width * source.height;
    for (int i = 0; i < dimension; i++) {
        color srcPix = source.pixels[i];
        neg.pixels[i] = color(255-red(srcPix), 255-green(srcPix), 255-blue(srcPix));
    }
    neg.updatePixels();
    return neg;
}

PImage grayscale(PImage source) {
    PImage grayScale = createImage(source.width, source.height, RGB);
    int dimension = source.width * source.height;
    for (int i = 0; i < dimension; i++) {
        color srcPix = source.pixels[i];
        float gsPixCol = 0.299 * red(srcPix) + 0.587 * green(srcPix) + 0.114 * blue(srcPix);
        grayScale.pixels[i] = color(gsPixCol);
    }
    grayScale.updatePixels();
    return grayScale;
}

PImage makeBinary(PImage source, int thresh) {
    PImage bin = createImage(source.width, source.height, RGB);
    int dimension = source.width * source.height;
    for (int i = 0; i < dimension; i++) {
        color srcPix = source.pixels[i];
        int avg = int(red(srcPix) + green(srcPix) + blue(srcPix)) / 3;

        if (avg < thresh) {
            bin.pixels[i] = black;
        }
        else {
            bin.pixels[i] = white;
        }
    }
    bin.updatePixels();
    return bin;
}

void keyReleased() {
    if (key == CODED) {
        boolean redrawBin = false;
        switch(keyCode) {
            case UP:
                binThresh += 1;
                redrawBin = true;
                break;
            case DOWN:
                binThresh -= 1;
                redrawBin = true;
                break;
        }

        if (redrawBin) {
            PImage oldBin = binImg;
            binImg = makeBinary(img, binThresh);
            if (oldBin == currentImg) {
                currentImg = binImg;
            }
            drawn = false;
        }
    }

    switch (key) {
        case 'b':
            currentImg = binImg;
            break;
        case 'c':
            currentImg = img;
            break;
        case 'g':
            currentImg = grayImg;
            break;
        case 'n':
            currentImg = negImg;
            break;
    }
    drawn = false;
}
