// Perform histogram operations on an image,
// and display the source histograms
//  How to use the program:
//  * The program loads all images in the /data folder
//  * You can cycle through different images by using the left and right arrow keys
//  * While viewing an image, you can:
//    * Press '1' to view the original image
//    * Press '2' to view the "stretched" image
//    * Press '3' to view the "equalized" image
//    * Press 'h' to view the original histogram
//    * Press 's' to view the "stretched" histogram
//    * Press 'e' to view the "equalized" histogram
//    * Press 'c' to view the "cumulative" histogram
//  * While in one of the modified viewing modes ('2', '3'),
//    you can select a region of the image to modify and compare to the base image
//
//  Author: Jacob Foster
//  Date: February 16, 2016
//  Class: CSC 545
//  Professor: Dr. Lloyd Smith

PFont f;

File[] fileList;
ImageFixer[] images;
ImageFixer currentImage;
int currentIndex = 0;
char mode = '1';

boolean showHistogram = false;
boolean showImage = true;
boolean regionSelected = false;
int startX = 0, startY = 0, endX = 0, endY = 0;

void setup() {
    size(400, 400);
    surface.setResizable(true);

    fileList = dataFile("").listFiles();
    images = new ImageFixer[fileList.length];

    for (int i = 0; i < fileList.length; i++) {
        File f = fileList[i];
        images[i] = new ImageFixer(f.getName());
    }

    currentImage = images[0];
    surface.setSize(currentImage.baseImg.width, currentImage.baseImg.height);

    f = createFont("Arial", 40);
    textFont(f);
    textAlign(LEFT, TOP);

    rectMode(CORNERS);
}

void draw() {
    if (showImage) {
        if (regionSelected) {
            image(currentImage.baseImg, 0, 0);
            currentImage.drawImage(mode, startX, startY, endX, endY);
        }
        else {
            currentImage.drawImage(mode);
        }
    }
    else if (showHistogram) {
        currentImage.drawHistogram(mode);
    }

    if (mousePressed && "123".indexOf(mode) != -1) {
        noFill();
        stroke(255, 255, 0);
        rect(startX, startY, mouseX, mouseY);
    }
}

void keyReleased() {
    if (key == CODED) {
        if (keyCode == RIGHT) {
            currentIndex++;

            if (currentIndex >= images.length) {
                currentIndex = 0;
            }
        }
        else if (keyCode == LEFT) {
            currentIndex--;

            if (currentIndex < 0) {
                currentIndex = images.length-1;
            }
        }

        currentImage = images[currentIndex];
        mode = '1';
        showImage = true;
        showHistogram = false;
    }
    else {
        mode = key;
        if ("hHsSeEcC".indexOf(key) != -1) {
            showImage = false;
            showHistogram = true;
        }
        else {
            showImage = true;
            showHistogram = false;
        }
    }
    regionSelected = false;
}

void mousePressed() {
    regionSelected = false;
    startX = mouseX;
    startY = mouseY;
}

void mouseReleased() {
    endX = mouseX;
    endY = mouseY;
    if (startX > mouseX) {
        endX = startX;
        startX = mouseX;
    }
    if (startY > mouseY) {
        endY = startY;
        startY = mouseY;
    }
    regionSelected = true;
}
