Game game;

void setup() {
  game = new Game();
  frameRate(30);
  size(1920, 1080);
}
  

void draw() {
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
