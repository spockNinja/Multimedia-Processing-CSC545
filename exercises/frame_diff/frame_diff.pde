/* This program shows a video and, optionally, frame differences
   'd': toggle difference frames; 'p': toggle pause; 'r': restart
*/
import processing.video.*;

//String fname = "Notre Dame at Michigan - Football Highlights.mp4";  //640 x 360
String fname = "The Hobbit Trailer Pop-Up - Lord of the Rings Movie.mp4"; //640 x 360
//String fname = "Kane Waselenchuk vs Alex Landa-Ektelon Nationals Racquetball.mp4"; //640 x 360
PImage old_img, diff_img;
Movie m;
boolean show_diff = false, paused = false;

void setup() {
  size(640, 360);
  old_img = createImage(width, height, RGB);
  diff_img = createImage(width, height, RGB);
  frameRate(30);
  m = new Movie(this, fname);
  m.loop();
  //Your code here to start the movie playing
}
void draw() {
  //Your code here to display the current frame or diff_img
  if (show_diff) {
    image(diff_img, 0, 0);
  }
  else {
    image(m, 0, 0);
  }
}
void movieEvent(Movie m) {
  m.read();

  if (show_diff) {
    diff(m, old_img);
  }

  //Now copy the new frame into old_img
  old_img = m.get();
}
void diff(PImage img1, PImage img2) {
  //Your code here to difference img1 and img2 and put the difference into
  //the global diff_img. For each pixel, difference the R, G, and B channels
  //separately, then create a new color from those differences and set the
  //corresponding pixel in diff_img to the new color.
  img1.loadPixels();
  img2.loadPixels();
  for(int i=0; i < img1.pixels.length; i++) {
      diff_img.pixels[i] = pixelDiff(img1.pixels[i], img2.pixels[i]);
  }
  diff_img.updatePixels();
}
color pixelDiff(color p1, color p2) {
    float r1 = red(p1), g1 = green(p1), b1 = blue(p1);
    float r2 = red(p2), g2 = green(p2), b2 = blue(p2);
    //println(diff);
    return color(abs(r1-r2), abs(g1-g2), abs(b1-b2));
}
void keyReleased() {
  if (key == 'd') {
    //toggle show difference frames
    show_diff = !show_diff;
  } else if (key == 'r') {
    // restart
    m.stop();
    m.jump(0.0);
    m.loop();
  } else if (key == 'p') {
    // pause
    if (paused) {
        m.play();
    } else {
        m.pause();
    }
    paused = !paused;
  }
}
