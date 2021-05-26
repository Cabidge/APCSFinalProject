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
  background(200);
  text();
  rect(600, 50, 450, 900);
  
  rect(1200, 50, 200, 100);
  
  //Draw grid
  for (int x=0; x<6; x++) {
    for (int y=0; y<12; y++) {
      if (cells[x][y]==0) {
        fill(NONE); 
      }
      if (cells[x][y]==1) {
        fill(RED); 
      }
      if (cells[x][y]==2) {
        fill(BLUE); 
      }
      if (cells[x][y]==3) {
        fill(GREEN); 
      }
      if (cells[x][y]==4) {
        fill(YELLOW);
      }
      if (cells[x][y]==5) {
        fill(PURPLE);
      }
      rect (x*puyoSize+600, y*puyoSize+50, puyoSize, puyoSize);
    }
  }
  
  
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
