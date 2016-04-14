/*Converts a grayscale image to binary by thresholding
  'i' displays grayscale image; 'b' displays binary image
  'h' displays histogram of grayscale image
*/
String[] fname = {"basketball.jpg", "FlyingMan.jpg",
                  "bicycles.jpeg", "ChromaKeyLadybug7-512.jpg",
                  "Man-Blue.jpg", "studiosetup_standing.jpg",
                  "TRACEY-blue.jpg", "Woman1.jpg"};
PImage img, thr_img;
float  thr;
//vals arrays will hold random values to graph
int[] redHist = new int[256], greenHist = new int[256];
int[] blueHist = new int[256];
int posRed = 10, posGreen = 275, posBlue = 541;
int xval, yval;
PFont f;
boolean showHists = false;  //Start out showing image
int rmax=0, gmax=0, bmax=0; //hold max vals for each band
PImage display;  //Image to display
boolean mouseDown = false;  //Used to select a region by dragging
int startX, startY, endX, endY; //Used for selection

void setup() {
  size(500, 500);
  surface.setResizable(true);
  img = loadImage(fname[7]);
  //img.resize(500, 0);  //Use this for fname[6]
  if (img.width < (256 * 3 + 30)) surface.setSize(256 * 3 + 30, img.height);
  else surface.setSize(img.width, img.height);
  img.filter(GRAY);
  img.loadPixels();
  thr_img = thresholdImage(img);
  background(0);
  image(img, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(1);
  f = createFont("verdana", 24);
  textFont(f);
  calcHists();
  display = img;
  rectMode(CORNERS);
}
void draw() {
  if (showHists) drawHists();
  else image(display, 0, 0);
  if (mouseDown) {
    noFill();
    rect(startX, startY, mouseX, mouseY);
  }
}
PImage thresholdImage(PImage src) {
  PImage newImage;
  newImage = createImage(src.width, src.height, RGB);
  newImage.copy(img, 0, 0, src.width, src.height,
                    0, 0, newImage.width, newImage.height);
  newImage.loadPixels();

  // basic threshold
  float threshold = 0.5;

  // average pixel
  //int avgPixel = getAveragePixel(newImage, "all", 0);
  //threshold = norm(avgPixel, 0, 255);

  // median pixel
  //int medianPixel = getMedianPixel(newImage);
  //threshold = norm(medianPixel, 0, 255);

  // Ridler-Carver threshold
  int rcThreshold = getRCThreshold(newImage);
  threshold = norm(rcThreshold, 0, 255);

  newImage.filter(THRESHOLD, threshold);

  return newImage;
}

int getRCThreshold(PImage imgToThresh) {
    int t0 = 0;
    int t1 = 128;

    while (t0 != t1) {
        t0 = t1;
        int m0 = getAveragePixel(imgToThresh, "below", t0);
        int m1 = getAveragePixel(imgToThresh, "above", t0);

        t1 = (m0+m1)/2;
    }

    return t0;
}

int getAveragePixel(PImage imgToAvg, String mode, int t) {
    int total = 0;

    for (int i=0; i < imgToAvg.pixels.length; i++) {
        int pixelVal = int(red(imgToAvg.pixels[i]));

        if (mode == "all") {
            total += pixelVal;
        }
        else if (mode == "below" && pixelVal < t) {
            total += pixelVal;
        }
        else if (mode == "above" && pixelVal >= t) {
            total += pixelVal;
        }
    }

    return total/imgToAvg.pixels.length;
}

int getMedianPixel(PImage imgToMed) {
    int[] grayScaleValues = new int[imgToMed.pixels.length];

    for (int i=0; i < imgToMed.pixels.length; i++) {
        grayScaleValues[i] = int(red(imgToMed.pixels[i]));
    }

    grayScaleValues = sort(grayScaleValues);
    int middle = grayScaleValues.length/2;
    return grayScaleValues[middle];
}

void calcHists() {
  int r, g, b;
  //First init hist counts to 0
  for (int i = 0; i < redHist.length; i++) {
    redHist[i] = 0; greenHist[i] = 0; blueHist[i] = 0;
  }
  //Now fill r, g, and b hists with counts
  for (int i = 0; i < img.pixels.length; i++) {
    r = (int) red(img.pixels[i]);
    g = (int) green(img.pixels[i]);
    b = (int) blue(img.pixels[i]);
    redHist[r] += 1;
    greenHist[g] += 1;
    blueHist[b] += 1;
  }
  //Now find max values for each band
  rmax = 0; gmax = 0; bmax = 0;
  for (int i = 0; i < redHist.length; i++) {
    if (redHist[i] > rmax) rmax = redHist[i];
    if (greenHist[i] > gmax) gmax = greenHist[i];
    if (blueHist[i] > bmax) bmax = blueHist[i];
  }
  println(rmax + "; " + gmax + "; " + bmax);
}
void drawHists() {
  background(0);
  stroke(255, 0, 0);
  for (int i = 0; i < redHist.length; i++) {
    yval = (int) map(redHist[i], 0, rmax, 0, height/2);
    xval = i + posRed;
    line(xval, height, xval, height-yval);
  }
  stroke(0, 255, 0);
  for (int i = 0; i < greenHist.length; i++) {
    yval = (int) map(greenHist[i], 0, gmax, 0, height/2);
    xval = i + posGreen;
    line(xval, height, xval, height-yval);
  }
  stroke(0, 0, 255);
  for (int i = 0; i < blueHist.length; i++) {
    yval = (int) map(blueHist[i], 0, bmax, 0, height/2);
    xval = i + posBlue;
    line(xval, height, xval, height-yval);
  }
  if (mouseX >= posRed && mouseX < posRed + redHist.length) {
    xval = mouseX - posRed;
    text("x: " + xval + "; y: " + redHist[xval], 10, 50);
  }
  else if (mouseX >= posGreen && mouseX < posGreen+greenHist.length) {
    xval = mouseX - posGreen;
    text("x: " + xval + "; y: " + greenHist[xval], 10, 50);
  }
  else if (mouseX >= posBlue && mouseX < posBlue+blueHist.length) {
    xval = mouseX - posBlue;
    text("x: " + xval + "; y: " + blueHist[xval], 10, 50);
  }
}
//Displays pixel values in selected region of display window
void mousePressed() {
  startX = mouseX;
  startY = mouseY;
  mouseDown = true;
}
void mouseReleased() {
  float r, g, b;
  color p;
  endX = mouseX;
  endY = mouseY;
  mouseDown = false;
  for (int y = startY; y < endY; y++) {
    for (int x = startX; x < endX; x++) {
      p = get(x, y);
      r = red(p); g = green(p); b = blue(p);
      println(r + "; " + g + "; " + b);
    }
  }
}
void keyReleased() {
  if (key == 'i' || key == 'I') {
    showHists = false;
    display = img;
  }
  else if (key == 'h' || key == 'H') showHists = true;
  else if (key == 'b' || key == 'B') {
    showHists = false;
    display = thr_img;
  }
}
void makeTestImage() {
  img = createImage(500, 500, RGB);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    int val = i % 256;
    img.pixels[i] = color(val, val, val);
  }
  img.updatePixels();
}
