// Animating a lizard with arrow keys
PImage img;
String fname = "Lizard.jpg";
boolean drawn = false;

int xpos = 0, ypos = 0;
int xspeed = 0, yspeed = 0;

void setup() {
    fullScreen();
    img = loadImage(fname);
    background(0);
}

void draw() {
    translate(xpos, ypos);
    image(img, 0, 0);

    xpos += xspeed;
    ypos += yspeed;

    if (xpos > width - img.width || xpos < 0) {
        xspeed = -xspeed;
    }
    if (ypos > height - img.height || ypos < 0) {
        yspeed = -yspeed;
    }
}

void keyPressed() {
    if (key == CODED) {
        switch(keyCode) {
            case UP:
                yspeed -= 2;
                break;
            case DOWN:
                yspeed += 2;
                break;
            case LEFT:
                xspeed -= 2;
                break;
            case RIGHT:
                xspeed += 2;
                break;
        }
    }
    else if (key == ' ') {
        background(0);
    }
}
