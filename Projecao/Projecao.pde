int np = 8;
int nf = 6; //numero de faces
int[] ifp = new int[60]; 
float a, b, c;
PVector[] p = new PVector[8]; 
int npf; 

void setup() {
  size(400, 400, P3D); 
  np = 8;
  nf = 6;
  npf = 4; 
  
for (int i = 0; i < 60; i++) { //No pascal ele le de um arquivo chamado quader.dat, mas eu nao tenho acesso ao arquivo nem nada, entao preenchi de qualquer forma ai
    ifp[i] = i + 1; 
}

  a = 100;
  b = 80;
  c = 60;
  p[0] = new PVector(0, 0, 0);
  p[1] = new PVector(a, 0, 0);
  p[2] = new PVector(a, b, 0);
  p[3] = new PVector(0, b, 0);
  p[4] = new PVector(0, 0, c); //Tive que adicionar mais ps para funcionar
  p[5] = new PVector(a, 0, c);
  p[6] = new PVector(a, b, c);
  p[7] = new PVector(0, b, c);
  auxConvexPolyh(); //Nao tem essa funcao no livro, esta no arquivo proc_pkp.pas que eu nao tenho acesso
  draw();
}

void draw() {
  background(255);
  translate(width / 2, height / 2, 0); 
  initParallelProjection(); //Nao tem a implementacao da funcao no livro
  stroke(0);
  for (int i = 0; i < nf; i++) {//faces, 4
    beginShape();
    for (int j = 0; j < 4; j++) {//vertice por face, 4
        int vIndex = ifp[i * 4 + j] - 1; //calculo para acessar dados da ifp
        if (vIndex >= 0 && vIndex < np) {//verificar se e valido, sem isso da out of bounds
            PVector v = p[vIndex];
            vertex(v.x, v.y, v.z); //cria um vertice com x,y,z do p la em cima
        }
    }
    endShape(CLOSE);
}


  drawEnd(); //Nao tem a implementacao da funcao no livro
}

void auxConvexPolyh() {//Nao tem a implementacao da funcao no livro
}

void initParallelProjection() {//Nao tem a implementacao da funcao no livro
}

void drawEnd() {//Nao tem a implementacao da funcao no livro
}
