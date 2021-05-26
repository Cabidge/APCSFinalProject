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

void keyPressed() {
  game.keyPressed();
}
