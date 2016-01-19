// Convert image to grayscale
PImage img;
String fname = "colorful1.jpg";
boolean drawn = false;

void setup() {
    size(400, 400);
    surface.setResizable(true);
    img = loadImage(fname);
    surface.setSize(img.width, img.height);
}

void draw() {
    if (!drawn) {
        drawn = true;
        image(img, 0, 0);
    }
}

void grayScale() {
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            color c = get(x, y);
            float r = red(c), g = green(c), b = blue(c);
            float grayScaled = (r + g + b)/3.0;
            set(x, y, color(grayScaled));
        }
    }
}

void keyReleased() {
    if (key == 'c' || key == 'C') {
        image(img, 0, 0);
    }
    else if (key == 'g' || key == 'G') {
        grayScale();
    }
}
