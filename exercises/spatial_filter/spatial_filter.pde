// Perform spatial filtering on an image using masks
PImage img, lowPassImg, highPassImg, currentImg;
String fname = "emptyroad.jpg";
boolean drawn = false;

float kernel1Base = 1/9.0;
float[][] kernel1 = {{kernel1Base, kernel1Base, kernel1Base},
                     {kernel1Base, kernel1Base, kernel1Base},
                     {kernel1Base, kernel1Base, kernel1Base}};

float[][] kernel2 = {{-1.0, -1.0, -1.0},
                     {-1.0, 9.0, -1.0},
                     {-1.0, -1.0, -1.0}};

void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;

    lowPassImg = convolve(img, kernel1);
    highPassImg = convolve(img, kernel2);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(currentImg, 0, 0);
    }
}

PImage convolve(PImage source, float[][] kernel) {
    PImage convolved = createImage(source.width, source.height, RGB);

    for (int x = 0; x < source.width; x++) {
        for (int y = 0; y < source.height; y++) {
            color toSet;
            if (x == 0 || y == 0 || x == source.width-1 || y == source.height-1) {
                toSet = source.get(x, y);
            }
            else {
                toSet = applyKernel(source, x, y, kernel);
            }
            convolved.set(x, y, toSet);
        }
    }

    return convolved;
}

color applyKernel(PImage source, int centerX, int centerY, float[][] kernel) {
    float r = 0.0, g = 0.0, b = 0.0;

    int iDiff = (kernel.length-1)/2;
    int jDiff = (kernel[0].length-1)/2;

    for (int i = 0; i < kernel.length; i++) {
        int sourceX = i + (centerX-iDiff);
        for (int j = 0; j < kernel[0].length; j++) {
            int sourceY = j + (centerY-jDiff);

            float pixelRatio = kernel[i][j];
            color pixel = source.get(sourceX, sourceY);

            r += red(pixel) * pixelRatio;
            g += green(pixel) * pixelRatio;
            b += blue(pixel) * pixelRatio;
        }
    }

    return color(r, g, b);
}

void keyReleased() {
    switch (key) {
        case 'l':
            currentImg = lowPassImg;
            break;
        case 'h':
            currentImg = highPassImg;
            break;
        case 'i':
            currentImg = img;
            break;
    }
    drawn = false;
}
