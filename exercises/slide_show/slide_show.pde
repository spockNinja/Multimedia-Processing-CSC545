// Pull out the white/yellow lines in an image
File[] fileList;
PImage[] images;
int currentIndex = 0;
int timer = 0;
int tintAlpha = 0;

void setup() {
    size(400, 400);
    surface.setResizable(true);

    fileList = dataFile("").listFiles();
    images = new PImage[fileList.length];

    for (int i = 0; i < fileList.length; i++) {
        File f = fileList[i];
        images[i] = loadImage(f.getName());
    }
}

void draw() {
    PImage currentImage = images[currentIndex];

    surface.setSize(currentImage.width, currentImage.height);


    if (tintAlpha < 255) {
        tint(tintAlpha);
        tintAlpha += 2;
    }

    image(currentImage, 0, 0);

    int ms = millis();
    if (ms - timer > 3000) {
        // Move to the next image every 3 seconds
        timer = ms;
        currentIndex++;
        tintAlpha = 0;
        if (currentIndex >= images.length) {
            currentIndex = 0;
        }
    }
}

void keyReleased() {
    int keyAsInt = Integer.parseInt(Character.toString(key));
    if (keyAsInt < images.length) {
        currentIndex = keyAsInt;
    }
}
