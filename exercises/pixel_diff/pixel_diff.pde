// Display the horizontal and vertical "difference" of an image's pixels
PImage img, vDiffImg, hDiffImg, currentImg;
String fname = "emptyroad.jpg";
boolean drawn = false;

void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;

    vDiffImg = vDiff(img);
    hDiffImg = hDiff(img);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(currentImg, 0, 0);
    }
}

PImage vDiff(PImage source) {
    PImage diff = createImage(source.width, source.height, RGB);
    int dimension = source.width * source.height;
    for (int x = 0; x < source.width; x++) {
        for (int y = 0; y < source.height; y++) {
            diff.set(x, y, pixelDiff(source.get(x, y), source.get(x, y-1 % source.height)));
        }
    }
    diff.updatePixels();
    return diff;
}

PImage hDiff(PImage source) {
    PImage diff = createImage(source.width, source.height, RGB);
    int dimension = source.width * source.height;
    for (int y = 0; y < source.height; y++) {
        for (int x = 0; x < source.width; x++) {
            diff.set(x, y, pixelDiff(source.get(x, y), source.get(x-1 % source.width, y)));
        }
    }
    diff.updatePixels();
    return diff;
}

color pixelDiff(color p1, color p2) {
    float r1 = red(p1), g1 = green(p1), b1 = blue(p1);
    float r2 = red(p2), g2 = green(p2), b2 = blue(p2);
    float diff = constrain(abs(r1-r2) + abs(g1-g2) + abs(b1-b2), 0, 255);
    return color(int(diff));
}

void keyReleased() {
    switch (key) {
        case 'v':
            currentImg = vDiffImg;
            break;
        case 'h':
            currentImg = hDiffImg;
            break;
        case 'i':
            currentImg = img;
            break;
    }
    drawn = false;
}
