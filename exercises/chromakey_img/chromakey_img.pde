/* This program implements chromakey, given foreground and
   background images. The foreground image must have foreground
   people or objects in front of a blue or green background.
   The default images are the same size; modify the program
   so it can accept a background image that is larger than the
   foreground. The program will then use part of the background
   image.
*/

PImage bckgrnd, forgrnd, finalImage;
int show = 0;

void setup() {
  float r, g, b;
  size(500, 500);
  surface.setResizable(true);
  forgrnd = loadImage("studiosetup_standing.jpg");
  surface.setSize(forgrnd.width, forgrnd.height);
  bckgrnd = loadImage("Neil-Armstrong-on-the-moon-300x295.jpg");
  finalImage = chromakey(forgrnd, bckgrnd);
}
void draw() {
  if (show == 0) {
    image(forgrnd, 0, 0);
  } else if (show == 1) {
    image(bckgrnd, 0, 0);
  } else if (show == 2) {
    image(finalImage, 0, 0);
  }
}
PImage chromakey(PImage fg, PImage bg) {
  PImage target = createImage(bg.width, bg.height, RGB);
  for(int x = 0; x < bg.width; x++) {
      for(int y = 0; y < bg.height; y++) {
          color bgPixel = bg.get(x, y);
          color fgPixel = color(0, 255, 0);

          if (x < fg.width && y < fg.height) {
              fgPixel = fg.get(x, y);
          }

          float fgR = red(fgPixel);
          float fgG = green(fgPixel);
          float fgB = blue(fgPixel);
          float fgRG = fgR + fgG;
          float fgRB = fgR + fgB;
          if (fgRG < fgB || fgRB < fgG) {
              target.set(x, y, bgPixel);
          }
          else {
              target.set(x, y, fgPixel);
          }
      }
  }

  target.updatePixels();
  return target;
}
void keyPressed() {
  if (key == '0') {
    show = 0;
  } else if (key == '1') {
    show = 1;
  } else if (key == '2') {
    show = 2;
  }
}
