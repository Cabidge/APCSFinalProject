class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  
  // Puyo display data
  color NONE = color(255);
  color RED = color(255,0,0);
  color BLUE = color(0,0,255);
  color GREEN = color(0,255,0);
  color YELLOW = color(255,255,0);
  color PURPLE = color(255,0,255);
  static final int puyoSize = 75;
  static final int boardWidth = puyoSize * WIDTH;
  static final int boardHeight = puyoSize * HEIGHT;
  
  State state;
  
  int[][] board;
  int score;
  
  int pmillis;
  
  Game() {
    reset();
  }
  
  void reset() {
    state = new NewPuyoState(this);
    board = new int[HEIGHT][WIDTH];
    score = 0;
    pmillis = millis();
  }
  
  void update() {
    state.onUpdate((millis()-pmillis)/1000.0);
    pmillis = millis();
  }
  
  void display() {
    background(200);
    displayScore();
    rect(600, 50, 450, 900);
  
    rect(1200, 50, 200, 100);
  
    //Draw grid
    for (int x=0; x<WIDTH; x++) {
      for (int y=0; y<HEIGHT; y++) {
        displayPuyo(board[y][x], x, y);
      }
    }
    state.onDisplay();
  }
  
  void displayPuyo(int type, float x, float y) {
    switch (type) {
      default:
        fill(NONE);
        break;
      case Puyo.RED:
        fill(RED);
        break;
      case Puyo.BLUE:
        fill(BLUE);
        break;
      case Puyo.GREEN:
        fill(GREEN);
        break;
      case Puyo.YELLOW:
        fill(YELLOW);
        break;
      case Puyo.PURPLE:
        fill(PURPLE);
        break;
    }
    rect (x*puyoSize+600, y*puyoSize+50, puyoSize, puyoSize);
  }
  
  void keyPressed() {
    state.onKeyPressed();
  }

  void displayScore(){
    fill(255);
    textSize(32);
    text("SCORE", 1200, 40);
  }
}
