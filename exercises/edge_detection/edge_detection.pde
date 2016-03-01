/*
    Perform edge detection using a mask

    Commands:
        p: prewitt horizontal
        P: prewitt vertical
        s: sobel horizontal
        S: sobel vertical
        l: laplacian
        L: blurred > laplacian
        +: original image + laplacian
        u: unsharpen (original - blurred + original)
*/
PImage img, lowPassImg, highPassImg, currentImg;
String fname = "emptyroad.jpg";
boolean drawn = false;

float blurBase = 1/9.0;
float[][] blurKernel = {{blurBase, blurBase, blurBase},
                        {blurBase, blurBase, blurBase},
                        {blurBase, blurBase, blurBase}};

float[][] prewittHKernel = {{-1.0, -1.0, -1.0}, {0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}};
float[][] prewittVKernel = {{-1.0, 0.0, 1.0}, {-1.0, 0.0, 1.0}, {-1.0, 0.0, 1.0}};
float[][] sobelHKernel = {{-1.0, -2.0, -1.0}, {0.0, 0.0, 0.0}, {1.0, 2.0, 1.0}};
float[][] sobelVKernel = {{-1.0, 0.0, 1.0}, {-2.0, 0.0, 2.0}, {-1.0, 0.0, 1.0}};
float[][] laplacianKernel = {{-1.0, -1.0, -1.0}, {-1.0, 8.0, -1.0}, {-1.0, -1.0, -1.0}};

void setup() {
    size(400, 400);

    img = loadImage(fname);
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    currentImg = img;
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
        case 'o':
            currentImg = img;
            break;
        case 'p':
            currentImg = convolve(img, prewittHKernel);
            break;
        case 'P':
            currentImg = convolve(img, prewittVKernel);
            break;
        case 's':
            currentImg = convolve(img, sobelHKernel);
            break;
        case 'S':
            currentImg = convolve(img, sobelVKernel);
            break;
        case 'l':
            currentImg = convolve(img, laplacianKernel);
            break;
        case 'L':
            PImage blurred = convolve(img, blurKernel);
            currentImg = convolve(blurred, laplacianKernel);
            break;
        case '+':
            PImage laplacian = convolve(img, laplacianKernel);
            PImage copiedBase = img.copy();
            copiedBase.blend(laplacian, 0, 0, img.width, img.height,
                                        0, 0, img.width, img.height,
                                        ADD);
            currentImg = copiedBase;
            break;
        case 'u':
            PImage uBlurred = convolve(img, blurKernel);
            PImage uCopiedBase = img.copy();
            uCopiedBase.blend(uBlurred, 0, 0, img.width, img.height,
                                        0, 0, img.width, img.height,
                                        SUBTRACT);
            uCopiedBase.blend(img, 0, 0, img.width, img.height,
                                   0, 0, img.width, img.height,
                                   ADD);
            currentImg = uCopiedBase;
            break;
    }
    drawn = false;
}
