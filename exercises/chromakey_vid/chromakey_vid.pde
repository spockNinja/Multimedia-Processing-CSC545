/* This program plays a green screen movie and replaces its background
   'g': toggle whether to replace green; 'p': toggle pause; 'r': reverse play
*/
import processing.video.*;

String vidname = "APACHE HELICOPTER GREEN SCREEN FOOTAGE HD.mp4"; //640 x 360
String bgname = "moon-surface.jpg";
PImage bg, displayImg;  //background image and display image w/background inserted
Movie m;
boolean replaceGreen = false, paused = false;
float playSpeed = 1.0;

void setup() {
  size(640, 360);
  displayImg = createImage(640, 360, RGB);
  bg = loadImage(bgname);
  bg.resize(640, 360);  //Make bg image same size as movie frames
  frameRate(30);
  m = new Movie(this, vidname);
  m.play();
}
void draw() {
  background(0);

  //if replaceGreen is true, show the displayImage
  if (replaceGreen) {
      image(displayImg, 0, 0);
  }
  else {
      image(m, 0, 0);
  }
  //otherwise, show the movie frame
}
void movieEvent(Movie m) {
  m.read();
  //println(m.width + "; " + m.height);
  chromakey(m, bg, displayImg);
}
void chromakey(Movie fg, PImage bg, PImage target) {
  //target <-- fg + bg (bg replaces green in fg)
  fg.loadPixels();
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
}
void keyReleased() {
  if (key == 'g') {
    replaceGreen = !replaceGreen;
  } else if (key == 'p') {
      // pause
      if (paused) {
          m.play();
      } else {
          m.pause();
      }
      paused = !paused;
  } else if (key == 'r') {
    // glitchy on mac
    playSpeed *= -1;
    m.pause();
    m.speed(playSpeed);
    m.play();
  }
}
