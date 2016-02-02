// Display bar graph (histogram) of random values
int maxVal = 1000, minVal = 0;

int[] valsA = new int[256];
int[] valsB = new int[256];
int[] valsC = new int[256];

int posA = 10, posB = 275, posC = 541; // offsets for 3 graphs
int actualMax; // max of randomly generated numbers
PFont f;

color r = color(255, 0, 0);
color g = color(0, 255, 0);
color b = color(0, 0, 255);

void setup() {
    size(900, 500);
    background(0);

    fillArr(valsA);
    fillArr(valsB);
    fillArr(valsC);

    actualMax = max(max(valsA), max(valsB), max(valsC));

    f = createFont("Arial", 40);
    textFont(f);
    textAlign(LEFT, TOP);
}

void fillArr(int[] toFill) {
    for (int i = 0; i < toFill.length; i++) {
        toFill[i] = (int) random(minVal, maxVal);
    }
}

void drawGraph(color c, int[] vals, int offset) {
    stroke(c);
    for (int i = 0; i < vals.length; i++) {
        int yVal = (int) map(vals[i], minVal, actualMax, 0, height/2);
        int xVal = i + offset;
        line(xVal, height, xVal, height-yVal);
    }
    if (mouseX >= offset && mouseX < vals.length + offset) {
        int displayMouseX = mouseX - offset;
        int displayMouseY = vals[displayMouseX];
        String coords = "X: " + nf(displayMouseX) + "   Y: " + nf(displayMouseY);
        fill(c);
        text(coords, 10, 10);
    }
}

void draw() {
    background(0);
    drawGraph(r, valsA, posA);
    drawGraph(g, valsB, posB);
    drawGraph(b, valsC, posC);
}
