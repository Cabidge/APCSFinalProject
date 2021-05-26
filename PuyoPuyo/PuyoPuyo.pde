Game game;

color none = color(255);
color RED = color(0);
color BLUE = color(0,0,255);
color GREEN = color(0,255,0);
color YELLOW = color(255,255,0);
color PURPLE = color(255,0,255);
int puyoSize = 68;

void setup() {
  game = new Game();
  frameRate(30);
  size(1920, 1080);
  
  
}
  

void draw() {
  background(200);
  text();
  stroke(0,0,0);
  rect(600, 50, 450, 900);
  
  rect(1200, 50, 200, 100);
  
  
  game.update();
  game.display();
}

void text(){
  textSize(32);
  text("SCORE", 1200, 40);
}

void keyPressed() {
  game.keyPressed();
}
