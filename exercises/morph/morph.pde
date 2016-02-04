// Blend two images together
PImage img1;
PImage img2;
String img1Name = "4.2.06.jpg";
String img2Name = "4.2.07.jpg";

boolean draw = false;
boolean freeze = false;
char mode;
float blendFactor = 1.0;

void setup() {
    size(400, 400);
    surface.setResizable(true);
    img1 = loadImage(img1Name);
    img2 = loadImage(img2Name);

    // make the images the same size, going with the smaller one
    if (img1.width != img2.width || img1.height != img2.height) {
        int newWidth = min(img1.width, img2.width);
        int newHeight = min(img1.height, img2.height);
        img1.resize(newWidth, newHeight);
        img2.resize(newWidth, newHeight);
    }

    surface.setSize(img1.width, img1.height);

    img1.loadPixels();
    img2.loadPixels();
}

void draw() {
    if (draw) {
        PImage b = null;
        if (mode == '1') {
            b = blender(img1, img2, blendFactor);
        }
        else if (mode == '2') {
            b = blender(img2, img1, blendFactor);
        }
        image(b, 0, 0);
        blendFactor -= 0.005;

        if (blendFactor < 0) {
            draw = false;
        }
    }
}

PImage blender(PImage source1, PImage source2, float factor) {
    PImage blended = createImage(source1.width, source1.height, RGB);

    for (int i = 0; i < source1.pixels.length; i++) {
        color src1Pixel = source1.pixels[i];
        color src2Pixel = source2.pixels[i];

        float src1R = red(src1Pixel);
        float src1G = green(src1Pixel);
        float src1B = blue(src1Pixel);

        float src2R = red(src2Pixel);
        float src2G = green(src2Pixel);
        float src2B = blue(src2Pixel);

        float factorOpposite = 1.0 - factor;

        float factoredR = (src1R * factor) + (src2R * factorOpposite);
        float factoredG = (src1G * factor) + (src2G * factorOpposite);
        float factoredB = (src1B * factor) + (src2B * factorOpposite);

        blended.pixels[i] = color(factoredR, factoredG, factoredB);
    }

    blended.updatePixels();
    return blended;
}

void keyReleased() {
    if (key == 'f') {
        if (freeze) {
            loop();
            freeze = false;
        }
        else {
            noLoop();
            freeze = true;
        }
    }
    else {
        mode = key;
        draw = true;
        blendFactor = 1.0;
    }
}
