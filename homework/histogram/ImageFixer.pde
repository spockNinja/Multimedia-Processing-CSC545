color r = color(255, 0, 0);
color g = color(0, 255, 0);
color b = color(0, 0, 255);

int posR = 10, posG = 275, posB = 541; // offsets for 3 graphs

class ImageFixer {
    int[] baseR = new int[256];
    int[] baseG = new int[256];
    int[] baseB = new int[256];

    int[] stretchedR = new int[256];
    int[] stretchedG = new int[256];
    int[] stretchedB = new int[256];

    int[] equalizedR = new int[256];
    int[] equalizedG = new int[256];
    int[] equalizedB = new int[256];

    int[] cumulativeR = new int[256];
    int[] cumulativeG = new int[256];
    int[] cumulativeB = new int[256];

    PImage baseImg;
    PImage stretched;
    PImage equalized;

    int minPixel = 255;
    int maxPixel = 0;
    int rangeMax = 0;

    ImageFixer(String fileName) {
        baseImg = loadImage(fileName);

        baseImg.loadPixels();
        loadHistogram(baseImg, baseR, baseG, baseB);
        loadCumulative(baseR, cumulativeR);
        loadCumulative(baseG, cumulativeG);
        loadCumulative(baseB, cumulativeB);

        stretched = stretchImage(baseImg);
        equalized = equalizeImage(baseImg);
        loadHistogram(stretched, stretchedR, stretchedG, stretchedB);
        loadHistogram(equalized, equalizedR, equalizedG, equalizedB);
    }

    void loadHistogram(PImage source, int[] valsR, int[] valsG, int[] valsB) {
        int grassThreshold = source.pixels.length/100;
        for (int i = 0; i < source.pixels.length; i++) {
            color pixel = source.pixels[i];
            int redVal = int(red(pixel));
            int greenVal = int(green(pixel));
            int blueVal = int(blue(pixel));

            valsR[redVal]++;
            valsG[greenVal]++;
            valsB[blueVal]++;

            // only check min/max if we are above the "grass" line
            int grassCheck = max(valsR[redVal], valsG[greenVal], valsB[blueVal]);
            if (grassCheck > grassThreshold) {
                minPixel = min(minPixel, min(redVal, greenVal, blueVal));
                maxPixel = max(maxPixel, max(redVal, greenVal, blueVal));
            }
        }
    }

    void loadCumulative(int[] sourceH, int[] cumulativeH) {
        cumulativeH[0] = sourceH[0];
        for(int i = 1; i < sourceH.length; i++) {
            cumulativeH[i] = cumulativeH[i-1] + sourceH[i];
        }
    }

    void drawHistogram(char mode) {
        surface.setSize(900, 500);
        background(0);

        int[] histR = null, histG = null, histB = null;
        switch(mode) {
            case 'h':
            case 'H':
                histR = baseR;
                histG = baseG;
                histB = baseB;
                break;
            case 's':
            case 'S':
                histR = stretchedR;
                histG = stretchedG;
                histB = stretchedB;
                break;
            case 'e':
            case 'E':
                histR = equalizedR;
                histG = equalizedG;
                histB = equalizedB;
                break;
            case 'c':
            case 'C':
                histR = cumulativeR;
                histG = cumulativeG;
                histB = cumulativeB;
                break;
            default:
                return;
        }
        rangeMax = max(max(histR), max(histG), max(histB));
        drawGraph(r, histR, posR, rangeMax);
        drawGraph(g, histG, posG, rangeMax);
        drawGraph(b, histB, posB, rangeMax);
    }

    void drawImage(char mode) {
        PImage toDraw = null;
        switch(mode) {
            case '1':
                toDraw = baseImg;
                break;
            case '2':
                toDraw = stretched;
                break;
            case '3':
                toDraw = equalized;
                break;
            default:
                return;
        }
        surface.setSize(toDraw.width, toDraw.height);
        image(toDraw, 0, 0);
    }

    void drawImage(char mode, int sX, int sY, int eX, int eY) {
        // Overloaded drawImage that just draws a rectangular region of the image
        PImage toDraw = null;
        switch(mode) {
            case '1':
                toDraw = baseImg;
                break;
            case '2':
                toDraw = stretched;
                break;
            case '3':
                toDraw = equalized;
                break;
            default:
                return;
        }
        image(toDraw, sX, sY, eX-sX, eY-sY,
                      sX, sY, eX, eY);
    }

    PImage stretchImage(PImage source) {
        int factor = 255/(maxPixel-minPixel);
        PImage s = createImage(source.width, source.height, RGB);
        for (int i = 0; i < source.pixels.length; i++) {
            color pixel = source.pixels[i];
            int sourceRed = int(red(pixel));
            int sourceGreen = int(green(pixel));
            int sourceBlue = int(blue(pixel));

            int newRed = (sourceRed - minPixel) * factor;
            int newGreen = (sourceGreen - minPixel) * factor;
            int newBlue = (sourceRed - minPixel) * factor;
            s.pixels[i] = color(newRed, newGreen, newBlue);
        }
        s.updatePixels();
        return s;
    }

    PImage equalizeImage(PImage source) {
        PImage eq = createImage(source.width, source.height, RGB);
        int pixelCount = source.pixels.length;
        for (int i = 0; i < source.pixels.length; i++) {
            color pixel = source.pixels[i];
            int sourceRed = int(red(pixel));
            int sourceGreen = int(green(pixel));
            int sourceBlue = int(blue(pixel));

            float newRed = map(cumulativeR[sourceRed], 0, pixelCount, 0, 255);
            float newGreen = map(cumulativeG[sourceGreen], 0, pixelCount, 0, 255);
            float newBlue = map(cumulativeB[sourceBlue], 0, pixelCount, 0, 255);
            eq.pixels[i] = color(newRed, newGreen, newBlue);
        }
        eq.updatePixels();
        return eq;
    }

    void drawGraph(color c, int[] vals, int offset, int rangeMax) {
        stroke(c);
        for (int i = 0; i < vals.length; i++) {
            int yVal = (int) map(vals[i], 0, rangeMax, 0, height/2);
            int xVal = i + offset;
            line(xVal, height, xVal, height-yVal);
        }
        if (mouseX >= offset && mouseX < vals.length + offset) {
            int displayMouseX = mouseX - offset;
            int displayMouseY = vals[displayMouseX];
            String coords = "X: " + nf(displayMouseX) + "   Y: " + nf(displayMouseY);
            fill(c);
            text(coords, 10, 10);
        }
    }
}
