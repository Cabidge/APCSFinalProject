class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  static final int boardWidth = 450;
  static final int boardHeight = 900;
  State state;
  
  int[][] board;
  int score;
  
  Game() {
    state = new NewPuyoState(this);
    board = new int[width/puyoSize][height/puyoSize];
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
        if (board[x][y]==0) {
          fill(NONE); 
        }
        if (board[x][y]==1) {
          fill(RED); 
        }
        if (board[x][y]==2) {
          fill(BLUE); 
        }
        if (board[x][y]==3) {
          fill(GREEN); 
        }
        if (board[x][y]==4) {
          fill(YELLOW);
        }
        if (board[x][y]==5) {
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
