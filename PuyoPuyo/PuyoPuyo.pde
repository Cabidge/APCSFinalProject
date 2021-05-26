Game game;

color NONE = color(255);
color RED = color(255,0,0);
color BLUE = color(0,0,255);
color GREEN = color(0,255,0);
color YELLOW = color(255,255,0);
color PURPLE = color(255,0,255);
int puyoSize = 75;
int[][] cells;
int boardWidth;
int boardHeight;

void setup() {
  game = new Game();
  frameRate(30);
  size(1920, 1080);
  cells = new int[width/puyoSize][height/puyoSize];
  boardWidth = 450;
  boardHeight = 900;
  
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
