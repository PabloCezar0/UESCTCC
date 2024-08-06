PImage img1, img2;
PVector[] points1, points2;
color[] pointColors;
float a = 0.0;
float scale;

void setup() {
  size(1280, 720);
  img1 = loadImage("frame_1x1.png");
  img2 = loadImage("frame_2x1.png");
  
  scale = min(width / float(img1.width), height / float(img1.height));
  
  pointColors = new color[] {
    color(240, 135, 132),
    color(235, 51, 36),
    color(119, 67, 66),
    color(142, 64, 58),
    color(58, 6, 3),
    color(159, 252, 253),
    color(115, 251, 253),
    color(50, 130, 246),
    color(0, 35, 245),
    color(0, 18, 154),
    color(22, 65, 124),
    color(0, 12, 123),
    color(255, 254, 145),
    color(255, 253, 85),
    color(240, 155, 89),
    color(240, 134, 80),
    color(120, 67, 21),
    color(129, 127, 38),
    color(126, 132, 247),
    color(115, 43, 245),
    color(53, 128, 187),
    color(0, 2, 61),
    color(88, 19, 94),
    color(58, 8, 62),
    color(161, 251, 142),
    color(161, 250, 79),
    color(117, 249, 77),
    color(117, 250, 97),
    color(117, 250, 141),
    color(129, 128, 73),
    color(239, 136, 190),
    color(238, 138, 248),
    color(234, 63, 247),
    color(234, 54, 128)
  };
  
  points1 = extractColoredPoints(img1, pointColors, "img1");
  points2 = extractColoredPoints(img2, pointColors, "img2");
}

void draw() {
  background(0);
  
  a = map(mouseX, 0, width, 0, 1);
  
  PVector[] interpolatedPoints = interpolatePoints(points1, points2, a);
  
  drawCatmullRom(interpolatedPoints);
}

PVector[] extractColoredPoints(PImage img, color[] colors, String imgName) {
  PVector[] points = new PVector[colors.length];
  img.loadPixels();
  
  for (int i = 0; i < colors.length; i++) {
    boolean found = false;
    for (int y = 0; y < img.height && !found; y++) {
      for (int x = 0; x < img.width && !found; x++) {
        if (img.pixels[x + y * img.width] == colors[i]) {
          points[i] = new PVector(x * scale, y * scale);
          found = true;
        }
      }
    }
    if (!found) {
      points[i] = new PVector(-1, -1); 
      println("Ponto " + (i + 1) + " nao encontrado em " + imgName);
    }
  }
  return points;
}

PVector[] interpolatePoints(PVector[] points1, PVector[] points2, float a) {
  PVector[] interpolatedPoints = new PVector[points1.length];
  for (int i = 0; i < points1.length; i++) {
    if (points1[i].x == -1 || points2[i].x == -1) {
      interpolatedPoints[i] = new PVector(-1, -1); 
    } else {
      float x = lerp(points1[i].x, points2[i].x, a);
      float y = lerp(points1[i].y, points2[i].y, a);
      interpolatedPoints[i] = new PVector(x, y);
    }
  }
  return interpolatedPoints;
}

void drawCatmullRom(PVector[] points) {
  stroke(255); 
  strokeWeight(2);
  noFill();
  
  beginShape();
  for (int i = 0; i < points.length; i++) {
    PVector p0 = points[(i - 1 + points.length) % points.length];
    PVector p1 = points[i];
    PVector p2 = points[(i + 1) % points.length];
    PVector p3 = points[(i + 2) % points.length];
    
    for (float t = 0; t < 1; t += 0.05) {
      PVector interpolatedPoint = catmullRom(p0, p1, p2, p3, t);
      vertex(interpolatedPoint.x, interpolatedPoint.y);
    }
  }
  endShape(CLOSE);
}

PVector catmullRom(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float t2 = t * t;
  float t3 = t2 * t;
  
  float x = 0.5 * ((2 * p1.x) + 
                   (-p0.x + p2.x) * t + 
                   (2*p0.x - 5*p1.x + 4*p2.x - p3.x) * t2 + 
                   (-p0.x + 3*p1.x - 3*p2.x + p3.x) * t3);
  
  float y = 0.5 * ((2 * p1.y) + 
                   (-p0.y + p2.y) * t + 
                   (2*p0.y - 5*p1.y + 4*p2.y - p3.y) * t2 + 
                   (-p0.y + 3*p1.y - 3*p2.y + p3.y) * t3);
  
  return new PVector(x, y);
}
