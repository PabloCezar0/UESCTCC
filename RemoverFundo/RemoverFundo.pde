PImage img, omg;

void setup() {
  size(400,400);
  //img = loadImage("Toyokawa.jpg");
  String s ="frame_2";
  img = loadImage(s+".png");
  omg = createImage(429,281,RGB);

  for (int i=0; i<429; i++) {
    for (int j=0; j<281; j++) {
      omg.set(i,j,color(255,255,255));
    }
  }

  
  color c;
  float a, r, g, b;
  println("   r   g    b   ");
  println("=============");
  for (int i=0; i<429; i++) {
    for (int j=0; j<281; j++) {
      c = img.get(i,j);
      r = red(c); g = green(c); b = blue(c); a = alpha(c);
      //println(r+"  "+g+"  "+b);
      //if ((i%10)==0) { println("\n r == "+ r+" g = "+g+" b == "+b); }
      if (a>0) { println(a); }
      //if (r<1.0) {omg.set(i,j,color(0,0,0)); }
      if (a==255.0) {
        if (r<1.0) {omg.set(i,j,color(0,0,0)); }
      }
    }
  }
  
  omg.save(s+"x.png");
  exit();
  
}
