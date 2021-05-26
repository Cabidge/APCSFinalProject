class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  State state;
  
  int[][] board;
  int score;
  
  Game() {
    state = new NewPuyoState(this);
    board = new int[HEIGHT][WIDTH];
    score = 0;
  }
  
  void update() {
    state.onUpdate();
  }
  
  void display() {
    state.onDisplay();
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
  }
  
  void keyPressed() {
    state.onKeyPressed();
  }
}
