// blend images together by setting the alpha channel in tint
PImage image1, image2, image3;
float tintAlpha = 0.0;

void setup() {
    size(400, 400);
    surface.setResizable(true);

    image1 = loadImage("AmboiseCastle.jpg");
    image2 = loadImage("BlarneyCastle.jpg");
    image3 = loadImage("BodiamCastle.jpg");

    surface.setSize(image1.width, image1.height);
}

void draw() {
    tint(255, 255);
    image(image1, 0, 0);

    tintAlpha = map(mouseX, 0, width, 0, 255);
    tint(255, tintAlpha);
    image(image2, 0, 0);

    tint(255, tintAlpha/2);
    image(image3, 0, 0);
}
