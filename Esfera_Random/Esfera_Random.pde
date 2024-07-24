int depth;
ArrayList<PVector> vertices;
ArrayList<PVector[]> faces;

void setup() {
  size(800, 800, P3D);
  
  depth = int(random(0, 6)); // Profundidade aleatória
  
  vertices = new ArrayList<PVector>();
  faces = new ArrayList<PVector[]>();
  
  // Triângulo inicial
  PVector v1 = new PVector(1.0, 0.0, 0.0);
  PVector v2 = new PVector(0.0, 1.0, 0.0);
  PVector v3 = new PVector(0.0, 0.0, 1.0);
  PVector v4 = new PVector(-1.0, 0.0, 0.0);
  PVector v5 = new PVector(0.0, -1.0, 0.0);
  PVector v6 = new PVector(0.0, 0.0, -1.0);
  
  vertices.add(v1);
  vertices.add(v2);
  vertices.add(v3);
  vertices.add(v4);
  vertices.add(v5);
  vertices.add(v6);
  
  // Subdivisões
  subdivide(0, 1, 2, depth, 0);
  subdivide(3, 1, 2, depth, 1);
  subdivide(3, 1, 5, depth, 0);
  subdivide(0, 1, 5, depth, 1);
  subdivide(3, 4, 5, depth, 1);
  subdivide(3, 4, 2, depth, 0);
  subdivide(0, 4, 2, depth, 1);
  subdivide(0, 4, 5, depth, 0);
}

void draw() {
  background(255);
  translate(width/2, height/2);
  rotateY(frameCount * 0.01);
  rotateX(frameCount * 0.01);
  
  stroke(0);
  noFill();
  
  for (PVector[] face : faces) {
    beginShape(TRIANGLE);
    for (PVector vertex : face) {
      vertex(vertex.x * 100, vertex.y * 100, vertex.z * 100);
    }
    endShape(CLOSE);
  }
}

void subdivide(int a, int b, int c, int depth, int face_inverse) {
  if (depth == 0) {
    if (face_inverse == 1) {
      addFace(c, b, a);
    } else {
      addFace(a, b, c);
    }
    return;
  }
  
  PVector ab = normalize(new PVector((vertices.get(a).x + vertices.get(b).x) / 2.0, 
                                     (vertices.get(a).y + vertices.get(b).y) / 2.0, 
                                     (vertices.get(a).z + vertices.get(b).z) / 2.0));
  PVector ac = normalize(new PVector((vertices.get(a).x + vertices.get(c).x) / 2.0, 
                                     (vertices.get(a).y + vertices.get(c).y) / 2.0, 
                                     (vertices.get(a).z + vertices.get(c).z) / 2.0));
  PVector bc = normalize(new PVector((vertices.get(b).x + vertices.get(c).x) / 2.0, 
                                     (vertices.get(b).y + vertices.get(c).y) / 2.0, 
                                     (vertices.get(b).z + vertices.get(c).z) / 2.0));
  
  int ab_idx = vertices.size();
  int ac_idx = vertices.size() + 1;
  int bc_idx = vertices.size() + 2;
  
  vertices.add(ab);
  vertices.add(ac);
  vertices.add(bc);
  
  subdivide(a, ab_idx, ac_idx, depth - 1, face_inverse);
  subdivide(ab_idx, b, bc_idx, depth - 1, face_inverse);
  subdivide(ac_idx, bc_idx, c, depth - 1, face_inverse);
  subdivide(ab_idx, bc_idx, ac_idx, depth - 1, face_inverse);
}

PVector normalize(PVector v) {
  float length = sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  return new PVector(v.x / length, v.y / length, v.z / length);
}

void addFace(int a, int b, int c) {
  PVector[] face = {vertices.get(a), vertices.get(b), vertices.get(c)};
  faces.add(face);
}
