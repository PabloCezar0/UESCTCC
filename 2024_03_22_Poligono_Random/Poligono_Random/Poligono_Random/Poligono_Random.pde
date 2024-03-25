int n, iverb, inz;
float r, dw, cdw, sdw;
PVector[] p;

void setup() {
  size(800, 800);
}

void draw() {
  background(255);
  
  n = int(random(3, 10)); // Cria uma numero aleartorio de lados
  r = random(50, min(width, height) / 3); // Randomiza o raio, pega entre 50 e o menor valor h or w divido por 3
  

  iverb = int(random(0, 2)); // Conecta ou nao? Se iverb == 1 conecta
  
  // Calculando as vertices:
  p = new PVector[n]; //cria um vetor de n lados, n foi gerado aleartoriamente anteriormente
  dw = TWO_PI / n; //calcula o angulo de cada vertice
  cdw = cos(dw); //calcula cosseno, ta no codigo em pascal. Se utilizar esse valor em vez do dw abaixo o poligono fica deformado
  sdw = sin(dw); //calcula seno
  for (int i = 0; i < n; i++) { //comeca a criar os lados
    float x = r * cos(i * dw); //x eh esse calculo, cacula o raio do circulo pelo cosseno do angulo * i, o i faz com que os pontos sejam gerados uniformemente
    float y = r * sin(i * dw); //y eh esse calculo  cacula o raio do circulo pelo seno do angulo * i, o i faz com que os pontos sejam gerados uniformemente 
    p[i] = new PVector(x, y); //armazena o vetor (x,y) no vetor p
  }
  
  translate(width / 2, height / 2); //coloca a imagem no centro da tela
  stroke(0);
  noFill();
  
  // Exibindo o poligono:
  if (iverb == 1) { //se for ligar os lados
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        line(p[i].x, p[i].y, p[j].x, p[j].y); //faz uma linha com o atual e o proximo n vezes
      }
    }
  } else {
    beginShape();
    for (int i = 0; i < n; i++) {
      vertex(p[i].x, p[i].y); //o vertex fecha o poligono automaticamente, ligando somente as vertices adjacentes
    }
    endShape(CLOSE);
  }
  
  delay(1000); 
}
