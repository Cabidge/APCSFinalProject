class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  boolean paused = false;
  
  // Display data
  static final int puyoSize = 75;
  
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
    rect(600, 50, 450, 900); // Main rectangle
  
    //rect(1200, 50, 200, 100);
    stroke(0,0,0);
    //Draw grid
    for (int x=0; x<WIDTH; x++) {
      for (int y=0; y<HEIGHT; y++) {
        if (board[y][x] != Puyo.NONE) {
          displayPuyo(board[y][x], x, y);
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
    circle((x+0.5)*puyoSize+600, (y+0.5)*puyoSize+50, puyoSize);
    
    // Eyes
    stroke(255);
    fill(255,255,255);
    circle(x*puyoSize+620, y*puyoSize+80, puyoSize/3);
    circle(x*puyoSize+655, y*puyoSize+80, puyoSize/3);
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
