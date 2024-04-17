int depth = 0;
ArrayList<PVector> vertices;
ArrayList<PVector[]> faces;
ArrayList<int[]> depthColors; // 

float zSpiral = -1000; // Mete o Z la pra tras, para a esfera se aproximar da tela
float xSpiral = 0;
float ySpiral = 0;
float zSpeed = 0.05; // Velocidade com que a esfera se aproxima da tela
float spiralSpeed = 0.1; // Velocidade de rotação da espiral
float spiral = 0; // Parâmetro da espiral
float inverse = 0;
float zinverse = 0;

void setup() {
  size(800, 800, P3D);
  
  vertices = new ArrayList<PVector>();
  faces = new ArrayList<PVector[]>();
  
  // Definindo as cores para cada profundidade
  depthColors = new ArrayList<int[]>();
  depthColors.add(new int[] {0, 0, 0});  // Profundidade 0: preto
  depthColors.add(new int[] {0, 0, 255});  // Profundidade 1: azul
  depthColors.add(new int[] {0, 255, 0});  // Profundidade 2: verde
  depthColors.add(new int[] {0, 255, 255});  // Profundidade 3: ciano
  depthColors.add(new int[] {255, 0, 0});  // Profundidade 4: vermelho
  depthColors.add(new int[] {255, 0, 255});  // Profundidade 5: magenta
  depthColors.add(new int[] {255, 255, 0});  // Profundidade 6: amarelo
  
}


void draw() {

  background(255);

  
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

  

   background(255);
  
  // Atualiza o parâmetro da espiral
  if (inverse == 0){
    spiral += spiralSpeed;
  }
  else {
    spiral -= spiralSpeed;
  }
  xSpiral = spiral * cos(spiral); //Equação parametrica da espiral
  ySpiral = spiral * sin(spiral); // x = t * cos(t); y = t * sin(t)
  
  if (xSpiral >= width){
   inverse = 1;
  }
  if (xSpiral == 0){
    inverse = 0;
  }
  if (zSpiral >= 100){
    zinverse = 1;
  }
  if (zSpiral <= -1000){
    zinverse = 0;
  }
  translate(width / 2 +xSpiral, height / 2+ySpiral, zSpiral);
  
  if (zinverse == 1){
    zSpiral += zSpeed;
  }
  else {
    zSpiral -= zSpeed;
  }

  println(xSpiral);
  
  stroke(0);
  noFill();
  
  for (int i = 0; i < faces.size(); i++) {
    int[] currentColor = depthColors.get(depth); 
    fill(currentColor[0], currentColor[1], currentColor[2]);
    if (depth == 0) {
      stroke(255);
    } else {
      stroke(0);
    }
    beginShape(TRIANGLE);
    for (PVector vertex : faces.get(i)) {
      vertex(vertex.x * 100 , vertex.y * 100 , vertex.z * 100 );
    }
    endShape(CLOSE);
  }
  
  zSpiral += zSpeed;
  
  // Profundidade aleatória a cada 16 frames
  if ((frameCount % 16) == 0) {
    depth = int(random(0, 6));
  }
  vertices.clear();
  faces.clear();

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
