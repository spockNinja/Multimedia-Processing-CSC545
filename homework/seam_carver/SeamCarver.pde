float INFINITY = sq(255) * 100;
int PROTECT = -1;
int ERASE = 1;
color grn = color(0, 255, 0);
color rd = color(255, 0, 0);
color blk = color(0);

class SeamCarver {
    PImage img;
    float[][] energyMatrix;
    int[][] weights;

    PImage energyImg;
    boolean energyImgCreated = false;

    int[] hSeam;
    boolean hSeamCalculated = false;

    int[] vSeam;
    boolean vSeamCalculated = false;

    float maxEnergy = 0;
    float minEnergy = INFINITY;
    boolean hasEraseRegion = false;

    SeamCarver(PImage source) {
        img = source;
        weights = new int[img.width][img.height];
        calcEnergy();
    }

    PImage picture() {
        return img;
    }

    PImage energyImage() {
        // return an image showing energy scaled and stored in pixels
        if (energyImgCreated) {
            return energyImg;
        }

        energyImg = createImage(energyMatrix.length, energyMatrix[0].length, RGB);
        for (int x = 0; x < energyMatrix.length; x++) {
            for (int y = 0; y < energyMatrix[0].length; y++) {
                int weight = weights[x][y];
                color energyColor = blk;
                if (weight == 0) {
                    float scaled = map(energyMatrix[x][y], minEnergy, maxEnergy, 0, 255);
                    energyColor = color(scaled);
                }
                else if (weight == PROTECT){
                    energyColor = grn;
                }
                else if (weight == ERASE) {
                    energyColor = rd;
                }
                energyImg.set(x, y, energyColor);
            }
        }

        energyImgCreated = true;
        return energyImg;
    }

    int width() {
        return img.width;
    }

    int height() {
        return img.height;
    }

    void resetAfterChange() {
        energyImgCreated = false;
        hSeamCalculated = false;
        vSeamCalculated = false;
        maxEnergy = 0;
        minEnergy = INFINITY;
        calcEnergy();
    }

    void calcEnergy() {
        // fill up energyMatrix
        energyMatrix = new float[img.width][img.height];
        boolean foundEraseRegion = false;

        for(int x = 0; x < img.width; x++) {
            for (int y = 0; y < img.height; y++) {
                float pixelEnergy = getEnergy(x, y);
                if (pixelEnergy > maxEnergy) {
                    maxEnergy = pixelEnergy;
                }
                if (pixelEnergy < minEnergy) {
                    minEnergy = pixelEnergy;
                }

                int pixelWeight = weights[x][y];
                if (pixelWeight == ERASE) {
                    pixelEnergy = -INFINITY;
                    foundEraseRegion = true;
                }
                else if (pixelWeight == PROTECT) {
                    pixelEnergy = INFINITY;
                }
                energyMatrix[x][y] = pixelEnergy;
            }
        }

        hasEraseRegion = foundEraseRegion;
    }

    float getEnergy(int x, int y) {
        // get the energy of pixel at x, y
        color centerPixel = img.get(x, y);
        color leftPixel = centerPixel;
        color rightPixel = centerPixel;
        color abovePixel = centerPixel;
        color belowPixel = centerPixel;

        int leftX = x - 1;
        if (leftX >= 0) {
            leftPixel = img.get(leftX, y);
        }

        int rightX = x + 1;
        if (rightX < img.width) {
            rightPixel = img.get(rightX, y);
        }

        int aboveY = y - 1;
        if (aboveY >= 0) {
            abovePixel = img.get(x, aboveY);
        }

        int belowY = y + 1;
        if (belowY < img.height) {
            belowPixel = img.get(x, belowY);
        }

        float rHDiff = sq(red(leftPixel) - red(rightPixel));
        float gHDiff = sq(green(leftPixel) - green(rightPixel));
        float bHDiff = sq(blue(leftPixel) - blue(rightPixel));

        float rVDiff = sq(red(abovePixel) - red(belowPixel));
        float gVDiff = sq(green(abovePixel) - green(belowPixel));
        float bVDiff = sq(blue(abovePixel) - blue(belowPixel));

        return rHDiff + gHDiff + bHDiff + rVDiff + gVDiff + bVDiff;
    }

    int[] findHorizontalSeam() {
        // return sequence of y indeces for lowest-energy horizontal seam
        if (hSeamCalculated) {
            return hSeam;
        }

        float[][] lowestPath = new float[energyMatrix.length][energyMatrix[0].length];
        int currentY = 0;
        float startMin = INFINITY;

        // Fill up the lowestPath with a simple dynamic programming algorithm
        for (int x = 0; x < energyMatrix.length; x++) {
            for (int y = 0; y < energyMatrix[0].length; y++) {
                float pixelEnergy = energyMatrix[x][y];
                if (x == 0) {
                    lowestPath[x][y] = pixelEnergy;
                }
                else {
                    int leftX = x-1;
                    float leftAbove = INFINITY;
                    float left = lowestPath[leftX][y];
                    float leftBelow = INFINITY;

                    int leftAboveY = y - 1;
                    if (leftAboveY >= 0) {
                        leftAbove = lowestPath[leftX][leftAboveY];
                    }

                    int leftBelowY = y + 1;
                    if (leftBelowY < energyMatrix[0].length) {
                        leftBelow = lowestPath[leftX][leftBelowY];
                    }

                    float lowestPrevious = min(leftAbove, left, leftBelow);

                    float cumulativeEnergy = lowestPrevious + pixelEnergy;
                    lowestPath[x][y] = cumulativeEnergy;

                    // Find the starting point to work backwords from
                    if (x == energyMatrix.length-1 && cumulativeEnergy < startMin) {
                        startMin = cumulativeEnergy;
                        currentY = y;
                    }
                }
            }
        }

        // Finally, fill up the seam array
        int[] seam = new int[energyMatrix.length];
        seam[0] = currentY;
        int seamIdx = 1;
        for (int j = lowestPath.length-2; j >= 0; j--) {
            int leftAboveY = currentY - 1;
            boolean avoidAbove = false;
            if (leftAboveY < 0) {
                leftAboveY = lowestPath[0].length - 1;
                avoidAbove = true;
            }
            int leftY = currentY;
            int leftBelowY = currentY + 1;
            boolean avoidBelow = false;
            if (leftBelowY >= lowestPath[0].length) {
                leftBelowY = 0;
                avoidBelow = true;
            }

            float leftAbove = lowestPath[j][leftAboveY];
            float left = lowestPath[j][leftY];
            float leftBelow = lowestPath[j][leftBelowY];

            float minLeft = min(leftAbove, left, leftBelow);

            if (minLeft == left) {
                currentY = leftY;
            }
            else if (minLeft == leftAbove && !avoidAbove) {
                currentY = leftAboveY;
            }
            else if (!avoidBelow) {
                currentY = leftBelowY;
            }
            else {
                currentY = leftY;
            }
            seam[seamIdx] = currentY;
            seamIdx++;
        }

        hSeam = reverse(seam);
        hSeamCalculated = true;
        return hSeam;
    }

    int[] findVerticalSeam() {
        // return sequence of x indeces for lowest-energy horizontal seam
        if (vSeamCalculated) {
            return vSeam;
        }

        float[][] lowestPath = new float[energyMatrix.length][energyMatrix[0].length];
        int currentX = 0;
        float startMin = INFINITY;

        // Fill up the lowestPath with a simple dynamic programming algorithm
        for (int y = 0; y < energyMatrix[0].length; y++) {
            for (int x = 0; x < energyMatrix.length; x++) {
                float pixelEnergy = energyMatrix[x][y];
                if (y == 0) {
                    lowestPath[x][y] = pixelEnergy;
                }
                else {
                    int aboveY = y-1;
                    float aboveLeft = INFINITY;
                    float above = lowestPath[x][aboveY];
                    float aboveRight = INFINITY;

                    int aboveLeftX = x - 1;
                    if (aboveLeftX >= 0) {
                        aboveLeft = lowestPath[aboveLeftX][aboveY];
                    }

                    int aboveRightX = x + 1;
                    if (aboveRightX < energyMatrix.length) {
                        aboveRight = lowestPath[aboveRightX][aboveY];
                    }

                    float lowestPrevious = min(aboveLeft, above, aboveRight);
                    float cumulativeEnergy = lowestPrevious + pixelEnergy;
                    lowestPath[x][y] = cumulativeEnergy;

                    // Find the starting point to work backwords from
                    if (y == energyMatrix[0].length-1 && cumulativeEnergy < startMin) {
                        startMin = cumulativeEnergy;
                        currentX = x;
                    }
                }
            }
        }

        // Finally, fill up the seam array
        int[] seam = new int[energyMatrix[0].length];
        seam[0] = currentX;
        int seamIdx = 1;
        for (int j = lowestPath[0].length-2; j >= 0; j--) {
            int aboveLeftX = currentX - 1;
            boolean avoidLeft = false;
            if (aboveLeftX < 0) {
                aboveLeftX = lowestPath.length - 1;
                avoidLeft = true;
            }
            int aboveX = currentX;
            int aboveRightX = currentX + 1;
            boolean avoidRight = false;
            if (aboveRightX >= lowestPath.length) {
                aboveRightX = 0;
                avoidRight = true;
            }

            float aboveLeft = lowestPath[aboveLeftX][j];
            float above = lowestPath[aboveX][j];
            float aboveRight = lowestPath[aboveRightX][j];

            float minAbove = min(aboveLeft, above, aboveRight);

            if (minAbove == above) {
                currentX = aboveX;
            }
            else if (minAbove == aboveLeft && !avoidLeft) {
                currentX = aboveLeftX;
            }
            else if (!avoidRight) {
                currentX = aboveRightX;
            }
            else {
                currentX = aboveX;
            }
            seam[seamIdx] = currentX;
            seamIdx++;
        }

        vSeam = reverse(seam);
        vSeamCalculated = true;
        return vSeam;
    }

    void removeHorizontalSeam() {
        // remove given seam from image
        int[] seam = findHorizontalSeam();

        // also have to resize the weights
        int[][] newWeights = new int[img.width][img.height-1];

        PImage newImg = createImage(img.width, img.height-1, RGB);
        for (int x = 0; x < img.width; x++) {
            boolean seamPixelFound = false;
            for (int y = 0; y < img.height; y++) {
                if (y == seam[x]) {
                    seamPixelFound = true;
                }
                else {
                    int setY = y;
                    if (seamPixelFound) {
                        setY -= 1;
                    }
                    newImg.set(x, setY, img.get(x, y));
                    newWeights[x][setY] = weights[x][y];
                }
            }
        }

        img = newImg;
        weights = newWeights;
        resetAfterChange();
    }

    void removeVerticalSeam() {
        // remove given seam from image
        int[] seam = findVerticalSeam();

        // also have to resize the weights
        int[][] newWeights = new int[img.width-1][img.height];

        PImage newImg = createImage(img.width-1, img.height, RGB);
        for (int y = 0; y < img.height; y++) {
            boolean seamPixelFound = false;
            for (int x = 0; x < img.width; x++) {
                if (x == seam[y]) {
                    seamPixelFound = true;
                }
                else {
                    int setX = x;
                    if (seamPixelFound) {
                        setX -= 1;
                    }
                    newImg.set(setX, y, img.get(x, y));
                    newWeights[setX][y] = weights[x][y];
                }
            }
        }

        img = newImg;
        weights = newWeights;
        resetAfterChange();
    }

    void setProtectRegion(int startX, int startY, int endX, int endY) {
        setRegion(startX, startY, endX, endY, PROTECT);
    }

    void setEraseRegion(int startX, int startY, int endX, int endY) {
        setRegion(startX, startY, endX, endY, ERASE);
    }

    void setRegion(int startX, int startY, int endX, int endY, int mode) {
        for (int x = startX; x <= endX; x++) {
            for (int y = startY; y <= endY; y++) {
                weights[x][y] = mode;
            }
        }
        resetAfterChange();
    }

    void clearProtection() {
        for (int x = 0; x < weights.length; x++) {
            for (int y = 0; y < weights[0].length; y++) {
                int currentWeight = weights[x][y];
                if (currentWeight == PROTECT) {
                    weights[x][y] = 0;
                }
            }
        }
        resetAfterChange();
    }

    void eraseVerticalSeams() {
        // remove area selected by mouse by removing vertical seams
        while(hasEraseRegion) {
            removeVerticalSeam();
        }
    }

    void eraseHorizontalSeams() {
        // remove area selected by mouse by removing horizontal seams
        while(hasEraseRegion) {
            removeHorizontalSeam();
        }
    }

}
