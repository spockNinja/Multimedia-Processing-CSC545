/* Seam Carving - resize image by seam carving
    'o' displays the base image, essentially clearing out any special views
    'e' toggles the display of the energy image
    'v' toggles the display of the vertical seam
    'h' toggles the display of the horizontal seam
    'LEFT' cuts one vertical seam (makes it narrower)
    'DOWN' cuts one horizontal seam (makes it narrower)
    'DELETE' erases an area selected by right mouse drag by removing horizontal seams
    'BACKSPACE' erases an area selected by right mouse drag by removing vertical seams
    Left mouse selection protects a region from removal
    'c' clears protection

    Author: Jacob Foster
    Date: March 2, 2016
    Class: CSC 545
    Professor: Dr. Lloyd Smith
*/

PImage baseImage, currentImage;
String fName = "emptyroad.jpg";

SeamCarver carver;

boolean drawVertSeam = false, drawHorizSeam = false, drawEnergyImg = false;
int startX, startY;

void setup() {
    size(400, 400);
    surface.setResizable(true);

    carver = new SeamCarver(loadImage(fName));
    surface.setSize(carver.width(), carver.height());

    currentImage = carver.picture();

    stroke(255, 0, 0);
    noFill();
    rectMode(CORNERS);
}

void draw() {
    background(0);

    if (drawEnergyImg) {
        currentImage = carver.energyImage();
    }
    else {
        currentImage = carver.picture();
    }

    surface.setSize(currentImage.width, currentImage.height);
    image(currentImage, 0, 0);

    if (drawVertSeam) {
        drawVert();
    }
    if (drawHorizSeam) {
        drawHoriz();
    }

    if (mousePressed) {
        if (mouseButton == LEFT) {
            stroke(0, 255, 0);
        }
        else if (mouseButton == RIGHT) {
            stroke(255, 0, 0);
        }
        rect(startX, startY, mouseX, mouseY);
    }
}

void drawVert() {
    // Draws lowest-energy vertical seam
    stroke(255, 0, 0);
    int[] verticalSeam = carver.findVerticalSeam();
    for (int y = 0; y < verticalSeam.length; y++) {
        point(verticalSeam[y], y);
    }
}

void drawHoriz() {
    // Draws lowest-energy horizontal seam
    stroke(255, 0, 0);
    int[] horizontalSeam = carver.findHorizontalSeam();
    for (int x = 0; x < horizontalSeam.length; x++) {
        point(x, horizontalSeam[x]);
    }
}

void mousePressed() {
    startX = mouseX;
    startY = mouseY;
}

void mouseReleased() {
    // Complete selection and either protect or remove
    int endX = mouseX;
    int endY = mouseY;
    if (startX > mouseX) {
        endX = startX;
        startX = mouseX;
    }
    if (startY > mouseY) {
        endY = startY;
        startY = mouseY;
    }

    startX = constrain(startX, 0, currentImage.width-1);
    startY = constrain(startY, 0, currentImage.height-1);
    endX = constrain(endX, 0, currentImage.width-1);
    endY = constrain(endY, 0, currentImage.height-1);

    if (mouseButton == LEFT) {
        carver.setProtectRegion(startX, startY, endX, endY);
    }
    else if (mouseButton == RIGHT) {
        carver.setEraseRegion(startX, startY, endX, endY);
    }
}

void keyReleased() {
    // handle actions
    switch(key) {
        case 'o':
            drawEnergyImg = false;
            drawHorizSeam = false;
            drawVertSeam = false;
            break;
        case 'e':
            drawEnergyImg = !drawEnergyImg;
            break;
        case 'h':
            drawHorizSeam = !drawHorizSeam;
            break;
        case 'v':
            drawVertSeam = !drawVertSeam;
            break;
        case 'c':
            carver.clearProtection();
            break;
    }

    if (keyCode == BACKSPACE) {
        carver.eraseVerticalSeams();
    }
    else if (keyCode == DELETE) {
        carver.eraseHorizontalSeams();
    }
}

void keyPressed() {
    if (keyCode == DOWN) {
        carver.removeHorizontalSeam();
    }
    else if (keyCode == LEFT) {
        carver.removeVerticalSeam();
    }
}
