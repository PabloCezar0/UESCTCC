PImage img1, img2;
PImage edgeImg1, edgeImg2;
PImage interpolatedImg;
ArrayList<PVector> edges1, edges2;
ArrayList<PVector> uniqueEdges1, uniqueEdges2;
ArrayList<PVector> commonEdges;

void setup() {
  size(500, 500);

  img1 = loadImage("frame_1x1.png");
  img2 = loadImage("frame_1x2.png");

  img1.resize(500, 500);
  img2.resize(500, 500);

  edgeImg1 = createImage(img1.width, img1.height, RGB);
  edgeImg2 = createImage(img2.width, img2.height, RGB);
  interpolatedImg = createImage(img1.width, img1.height, RGB);

  edges1 = extractEdges(img1, edgeImg1);
  edges2 = extractEdges(img2, edgeImg2);

  findUniqueAndCommonEdges(edges1, edges2);
  equalizeEdgeCounts(uniqueEdges1, uniqueEdges2);
}

void draw() {
  background(255);

  float T = map(mouseX, 0, width, 0, 1);

  generateInterpolatedFrame(T);

  image(interpolatedImg, 0, 0); 
}

ArrayList<PVector> extractEdges(PImage img, PImage edgeImg) {
  ArrayList<PVector> edges = new ArrayList<PVector>();

  img.loadPixels();
  edgeImg.loadPixels();

  for (int x = 1; x < img.width - 1; x++) {
    for (int y = 1; y < img.height - 1; y++) {
      int current = img.pixels[y * img.width + x];

      boolean edge = false;
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx != 0 || dy != 0) {
            int neighbor = img.pixels[(y + dy) * img.width + (x + dx)];
            if (brightness(current) != brightness(neighbor)) {
              edge = true;
              break;
            }
          }
        }
        if (edge) break;
      }

      if (edge) {
        edgeImg.pixels[y * img.width + x] = color(0);
        edges.add(new PVector(x, y));
      } else {
        edgeImg.pixels[y * img.width + x] = color(255);
      }
    }
  }

  edgeImg.updatePixels();
  return edges;
}

void findUniqueAndCommonEdges(ArrayList<PVector> edges1, ArrayList<PVector> edges2) {
  uniqueEdges1 = new ArrayList<PVector>();
  uniqueEdges2 = new ArrayList<PVector>();
  commonEdges = new ArrayList<PVector>();

  for (PVector p1 : edges1) {
    boolean found = false;
    for (PVector p2 : edges2) {
      if (p1.equals(p2)) {
        found = true;
        commonEdges.add(p1);
        break;
      }
    }
    if (!found) {
      uniqueEdges1.add(p1);
    }
  }

  for (PVector p2 : edges2) {
    boolean found = false;
    for (PVector p1 : edges1) {
      if (p2.equals(p1)) {
        found = true;
        break;
      }
    }
    if (!found) {
      uniqueEdges2.add(p2);
    }
  }
}

void equalizeEdgeCounts(ArrayList<PVector> edges1, ArrayList<PVector> edges2) {
  while (edges1.size() != edges2.size()) {
    if (edges1.size() > edges2.size()) {
      edges1.remove(edges1.size() - 1);
    } else {
      edges2.remove(edges2.size() - 1);
    }
  }
}

void generateInterpolatedFrame(float T) {
  interpolatedImg.loadPixels();

  for (int i = 0; i < interpolatedImg.pixels.length; i++) {
    interpolatedImg.pixels[i] = color(255);
  }

  for (PVector p : commonEdges) {
    int index = (int)p.y * interpolatedImg.width + (int)p.x;
    if (index >= 0 && index < interpolatedImg.pixels.length) {
      interpolatedImg.pixels[index] = color(0);
    }
  }

  for (int i = 0; i < uniqueEdges1.size(); i++) {
    PVector p1 = uniqueEdges1.get(i);
    PVector p2 = uniqueEdges2.get(i);

    float x = lerp(p1.x, p2.x, T);
    float y = lerp(p1.y, p2.y, T);

    int index = (int)y * interpolatedImg.width + (int)x;
    if (index >= 0 && index < interpolatedImg.pixels.length) {
      interpolatedImg.pixels[index] = color(0);
    }
  }

  interpolatedImg.updatePixels();
}
