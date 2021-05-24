Game game;

void setup() {
  game = new Game();
}

void draw() {
  game.update();
  game.display();
}

void keyPressed() {
  game.keyPressed();
}
