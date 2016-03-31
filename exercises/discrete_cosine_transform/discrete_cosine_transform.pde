/* Experiment with DCT compression. Zone mask and quantization tables
   are defined in a 2nd tab.
   '0': color image; '1': grayscale image; '2': DCT visualization image
   '3': Restored image; '4': Difference between the grayscale image and
   the restored image
*/
int M = 8, N = 8;             //Dimensions of dct block
PImage[] img = new PImage[5];
PImage currentImg;
String fname1 = "penny.jpg", fname2 = "Lizard.jpg";
String fname3 = "sunflower.jpg", fname4 = "parrot400.jpg";
String loadName = fname4;
int[][]   f8 = new int[M][N];  //Gets pixel values from idct()
int[][]   F =  new int[M][N];  //For intermediate & final results
int[][]   G =  new int[M][N];  //For intermediate & final results
int[][] coeffs; //Picture sized container for unscaled coeffs
int startX, startY, endX, endY; //Used for selection
boolean mouseDown = false;

void setup() {
  size(400, 400);
  surface.setResizable(true);
  noTint();
  img[0] = loadImage(loadName);
  setSize(img[0].width, img[0].height);
  img[1] = img[0].get();
  grayScale(img[1]);
  img[2] = dct(img[1]); //coeffs gets unscaled coeffs
  //showMat(coeffs);
  //recreate image from coeffs
  img[3] = idct(img[2].width, img[2].height, coeffs);
  img[4] = diff(img[1], img[3]);
  currentImg = img[0];
  noFill();
}
void draw() {
  background(200);
  image(currentImg, 0, 0);
  if (mouseDown) {
    int x1, x2, y1, y2;
    if (mouseX < startX) {
      x1 = mouseX; x2 = startX;
    } else {
      x1 = startX; x2 = mouseX;
    }
    if (mouseY < startY) {
      y1 = mouseY; y2 = startY;
    } else {
      y1 = startY; y2 = mouseY;
    }
    rect(x1, y1, x2, y2);
  }
}
//Transpose int array m1 into m2
void transpose(int[][] m1, int[][] m2) {
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < M; j++) {
      m2[j][i] = m1[i][j];
    }
  }
}
PImage dct(PImage pic) {
  color c;
  int w = pic.width;
  int rem = w % M;
  if (rem != 0) {
    w = w + (M - rem); //Make width a multiple of M pixels
  }
  int h = pic.height;
  rem = h % N;
  if (rem != 0) {
    h = h + (N - rem); //Make height a multiple of N pixels
  }
  coeffs = new int[w][h]; //This will hold unscaled coefficients
  PImage picCopy = pic.get(); //Make a copy - don't change the original
  PImage newPic = createImage(w, h, RGB); //Gets scaled coeffs
  for (int y = 0; y <= h-M; y += M) {
    for (int x = 0; x <= w-N; x += N) {
      for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
          f8[i][j] = int(red(picCopy.get(x+i, y+j)));
        }
      }
      dct8x8(f8, G, F); //F has unscaled coefficients
      scale(F, G, M, N);  //G has scaled coefficients for display
      for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
          c = color(G[i][j], G[i][j], G[i][j]);
          newPic.set(x+i, y+j, c);
          coeffs[x+i][y+j] = F[i][j] * zmask0[i][j];
          coeffs[x+i][y+j] = coeffs[x+i][y+j]/q50[i][j];
        }
      }
    }
  }
  return newPic;
}
void dct8x8(int[][] f, int[][] A, int[][] B) {
  for (int i = 0; i < N; i++) { //Do 1d dct on each row
    dct1d(f[i], A[i]); //int result in A, float in H
  }
  transpose(A, B); //Transpose A into B
  for (int i = 0; i < N; i++) { //Now do 1d dct on each row of B
    dct1d(B[i], A[i]);  //int result in A; float in H
  }
  transpose(A, B); //Transpose result back into B
}
void dct1d(int[] f, int[] F) {
  float cu, sum;
  for (int u = 0; u < M; u++) {
    if (u == 0) cu = 0.70710678; //sqrt(2)/2
    else cu = 1.0;
    sum = 0.0;
    for (int i = 0; i < M; i++) {
      sum = sum + cos(((2.0*i+1) * u * PI)/16.0) * f[i];
    }
    F[u] = int(round(sum * cu/2.0));
  }
}
PImage idct(int w, int h, int[][] coeffs) {
  int val;
  color c;
  PImage newPic = createImage(w, h, RGB);
  for (int y = 0; y <= h-M; y += M) {
    for (int x = 0; x <= w-N; x += N) {
      for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
          //Multiply coefficients by q table; use the same table as in dct()
          F[i][j] = coeffs[x+i][y+j] * q50[i][j];
        }
      }
      idct8x8(F, G, f8);
      for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
          val = abs(f8[i][j]);
          if (abs(val) > 255) val = 255;
          c = color(val, val, val);
          newPic.set(x+i, y+j, c);
        }
      }
    }
  }
  return newPic;
}
void idct8x8(int[][] A, int[][] B, int[][] f) {
  transpose(A, B); //Transpose A into B
  for (int i = 0; i < N; i++) { //Do 1d dct on each row of A
    idct1d(B[i], A[i]);
  }
  transpose(A, B);
  for (int i = 0; i < N; i++) {
    idct1d(B[i], f[i]);
  }
}
void idct1d(int[] F, int[] f) {
  float sum, cu;
  for (int i = 0; i < M; i++) {
    sum = 0.0;
    for (int u = 0; u < M; u++) {
      if (u == 0) cu = 0.70710678; //sqrt(2)/2
      else cu = 1.0;
      sum = sum + cu/2.0*cos(((2.0*i+1.0) * u * PI)/16.0) * F[u];
    }
    f[i] = int(round(sum));
  }
}
void showMat(int[][] f) {
  for (int y = 0; y < M; y++) {
    for (int x = 0; x < N; x++) {
      print (f[x][y]);
      print (", ");
    }
    println();
  }
}
//Scale m x n matrix so no element > 255
void scale(int[][] F, int[][] G, int m, int n) {
  int max = 0; //Start max at low value
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (i == 0 && j == 0) {  //Handle DC component
        if (F[i][j] > 255) G[i][j] = 255;
      }
      else if (abs(F[i][j]) > max) max = abs(F[i][j]);
    }
  }
  if (max < 255) return;
  float scaleFactor = 255.0/max;
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (i != 0 || j != 0) { //Don't scale DC component
        G[i][j] = int(F[i][j] * scaleFactor);
      }
    }
  }
}
void grayScale(PImage pic) {
  float r, g, b, val;
  for (int y = 0; y < pic.height; y++) {
    for (int x = 0; x < pic.width; x++) {
      color p = pic.get(x, y);
      val = red(p) * .299 + green(p) * .587 + blue(p) * .114;
      pic.set(x, y, color(val, val, val));
    }
  }
}
PImage diff(PImage img1, PImage img2) {
  PImage diffImg = createImage(img1.width, img1.height, RGB);
  //Your code here to create an image that is the difference between
  //img1 and img2; display absolute value differences and scale to
  //a max value of 255.
  img1.loadPixels();
  img2.loadPixels();

  int[] pixelDiffs = new int[img1.pixels.length];

  for(int i = 0; i < img1.pixels.length; i++) {
      int r1 = int(red(img1.pixels[i]));
      int r2 = int(red(img2.pixels[i]));
      pixelDiffs[i] = abs(r1-r2);
  }

  int maxDiff = max(pixelDiffs);

  for(int j = 0; j < pixelDiffs.length; j++) {
      diffImg.pixels[j] = color(map(pixelDiffs[j], 0, maxDiff, 0, 255));
  }

  diffImg.updatePixels();

  return diffImg;
}
void mousePressed() {
  startX = mouseX;
  startY = mouseY;
  mouseDown = true;
}
void mouseReleased() {
  endX = mouseX;
  endY = mouseY;
  mouseDown = false;
  if (endX < startX) {
    int temp = startX;
    startX = endX;
    endX = temp;
  }
  if (endY < startY) {
    int temp = startY;
    startY = endY;
    endY = temp;
  }
  for (int y = startY; y < endY; y++) {
    for (int x = startX; x < endX; x++) {
      print(coeffs[x][y] + "; ");
    }
    println();
  }
}
void keyPressed() {
  background(128);
  if (key == '0') currentImg = img[0];  //Original
  if (key == '1') currentImg = img[1];  //Grayscale
  if (key == '2') currentImg = img[2];  //dct
  if (key == '3') currentImg = img[3];  //Restored
  if (key == '4') currentImg = img[4];  //Difference
}
