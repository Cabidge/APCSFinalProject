class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  boolean paused = false;
  
  // Display data
  static final int puyoSize = 75;
  static final int BOARD_X = 600;
  static final int BOARD_Y = 50;
  static final int BOARD_WIDTH = puyoSize * WIDTH;
  static final int BOARD_HEIGHT = puyoSize * HEIGHT;
  
  private State state;
  
  int[][] board;
  int score;
  
  int pmillis;
  
  Game() {
    paused = false;
    state = new NewPuyoState(this);
    state.onEnter();
    board = new int[HEIGHT][WIDTH];
    score = 0;
    pmillis = millis();
  }
  
  void update() {
    if (!paused) {
      state.onUpdate((millis()-pmillis)/1000.0);
    }
    pmillis = millis();
  }
  
  void display() {
    background(200);
    displayScore();
    rectMode(CORNER);
    rect(BOARD_X, BOARD_Y, BOARD_WIDTH, BOARD_HEIGHT); // Main rectangle
  
    //rect(1200, 50, 200, 100);
    stroke(0,0,0);
    //Draw grid
    for (int x=0; x<WIDTH; x++) {
      for (int y=0; y<HEIGHT; y++) {
        int type = board[y][x];
        if (type != Puyo.NONE) {
          if (x < WIDTH - 1 && board[y][x+1] == type) {
            drawConnection(type, x, y, x + 1, y);
          }
          if (y < HEIGHT - 1 && board[y+1][x] == type) {
            drawConnection(type, x, y, x, y + 1);
          }
          displayPuyo(type, x, y);
        }
      }
    }
    state.onDisplay();
    strokeWeight(4);
    stroke(255,0,0);
    line(755,55,820,120);
    line(820,55,755,120);
    
    if (paused) {
      textSize(80);
      text("PAUSED" , 100, 200);
    }
  }
  
  void keyPressed() {
    if ( key == 'p' ) {
      paused = !paused;
    } else {
      state.onKeyPressed();
    }
  }
  
  void displayPuyo(int type, float x, float y) {
    displayPuyo(type, x, y, 1);
  }
  
  void displayPuyo(int type, float x, float y, float outlineThickness) {
    fill(colorOfPuyo(type));
    stroke(0);
    strokeWeight(outlineThickness);
    circle((x+0.5)*puyoSize+BOARD_X, (y+0.5)*puyoSize+BOARD_Y, puyoSize);
    
    // Eyes
    stroke(255);
    fill(255,255,255);
    circle(x*puyoSize+BOARD_X+20, y*puyoSize+BOARD_Y+30, puyoSize/3);
    circle(x*puyoSize+BOARD_X+55, y*puyoSize+BOARD_Y+30, puyoSize/3);
  }
  
  void drawConnection(int type, int fromX, int fromY, int toX, int toY) {
    float p = 0.15;
    
    strokeWeight(1);
    stroke(0);
    fill(colorOfPuyo(type));
    rectMode(CORNERS);
    rect(fromX * puyoSize + BOARD_X + puyoSize * p, fromY * puyoSize + BOARD_Y + puyoSize * p,
         toX * puyoSize + BOARD_X + puyoSize * (1 - p), toY * puyoSize + BOARD_Y + puyoSize * (1 - p));
  }

  void displayScore(){
    background(0);
    fill(255);
    textSize(32);
    text("SCORE", 1200, 80);
    text(score, 1200, 130);
  }
  
  void changeState(State nextState) {
    state.onExit();
    
    state = nextState;
    state.onEnter();
  }
}
