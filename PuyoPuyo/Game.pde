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
  
  private Queue<int[]> nextPairs;
  
  int[][] board;
  int score;
  int gamemode;
  
  int pmillis;
  
  Game() {
    nextPairs = new ArrayDeque<int[]>();
    addRandomPair();
    addRandomPair();
    
    paused = false;
    state = new NewPuyoState(this);
    state.onEnter();
    board = new int[HEIGHT][WIDTH];
    score = 0;
    gamemode = 0;
    pmillis = millis();
  }
  
  void update() {
    while (nextPairs.size() < 2) {
    }
    
    if (!paused) {
      state.onUpdate((millis()-pmillis)/1000.0);
    }
    pmillis = millis();
  }
  
  int[] nextPair() {
    addRandomPair();
    return nextPairs.remove();
  }
  
  private void addRandomPair() {
    nextPairs.add(new int[]{randomPuyo(), randomPuyo()});
  }
  
  void display() {
    startScreen();
    if(gamemode == 1){
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
      
      displayLevel();
      
      if (paused) {
        textSize(80);
        text("PAUSED" , 100, 200);
      }
      
      displayNextPairs();
    }
  }
  
  void displayNextPairs() {
    int i = 0;
    for (int[] pair : nextPairs) {
      if (i > 2) { // Only show the first two
        break;
      }
      
      displayPuyo(pair[0], WIDTH + 0.5 + i * 1.5, 2.5 + i * 0.8);
      displayPuyo(pair[1], WIDTH + 0.5 + i * 1.5, 1.5 + i * 0.8);
      
      i++;
    }
  }
  
  void keyPressed() {
    if ( key == 'p' ) {
      paused = !paused;
    } else {
      state.onKeyPressed();
    }
  }
  
  void startScreen(){
    background(0);
    int gray = 200;
    textSize(90);
    fill(0,255,255);
    text("GAME MODE", 570,280);
    fill(255);
    text("NORMAL", 660,480);
    text("TIMER", 700,680);
    if(mouseX>600 && mouseX<600+500 &&
       mouseY>400 && mouseY<400+100) {
      fill(gray);
      rect(600,400,500,100);
      fill(255);
      text("NORMAL", 660,480); // gray when mouse over
      if(mousePressed){
        gamemode=1;
      }
    }
    if(mouseX>600 && mouseX<600+500 &&
       mouseY>600 && mouseY<600+100) {
      fill(gray);
      rect(600,600,500,100);
      fill(255);
      text("TIMER", 700,680); // gray when mouse over
      if(mousePressed){
        gamemode=2;
      }
    }
  }
  
  void displayPuyo(int type, float x, float y) {
    displayPuyo(type, x, y, 1);
  }
  
  void displayPuyo(int type, float x, float y, float outlineThickness) {
    float centerX = (x+0.5) * puyoSize + BOARD_X;
    float centerY = (y+0.5) * puyoSize+BOARD_Y;
    
    fill(colorOfPuyo(type));
    stroke(0);
    strokeWeight(outlineThickness);
    circle(centerX, centerY, puyoSize);
    
    // Eyes
    strokeWeight(1);
    fill(255);
    float eyeHeight = centerY - puyoSize * 0.02;
    float eyeOffset = puyoSize * 0.22;
    circle(centerX - eyeOffset, eyeHeight, puyoSize * 0.42);
    circle(centerX + eyeOffset, eyeHeight, puyoSize * 0.42);
    // Pupil
    fill(lerpColor(colorOfPuyo(type), color(0), 0.24));
    circle(centerX - eyeOffset + 1, eyeHeight - 1, puyoSize * 0.24);
    circle(centerX + eyeOffset - 1, eyeHeight - 1, puyoSize * 0.24);
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
  
  void displayChain(int chain) {
    if (chain > 0) { 
      fill(230,200,0); // Orange
      textSize(30 + chain * 5);
      text(chain + "-chain!", 1100, 620);
    }
  }
  
  void changeState(State nextState) {
    state.onExit();
    
    state = nextState;
    state.onEnter();
  }
  
  int getLevel() {
    return score / 100 + 1;
  }
  
  void displayLevel() {
    fill(255);
    text("level: " + getLevel(), BOARD_X+BOARD_WIDTH+40, BOARD_Y+BOARD_HEIGHT-40);
    
    rectMode(CORNER);
    fill(20);
    stroke(255);
    strokeWeight(1);
    int progressLength = 400;
    int progressHeight = 20;
    rect(BOARD_X+BOARD_WIDTH+40, BOARD_Y+BOARD_HEIGHT-progressHeight,
         progressLength, progressHeight);
    
    fill(255);
    noStroke();
    rect(BOARD_X+BOARD_WIDTH+40, BOARD_Y+BOARD_HEIGHT-progressHeight,
         progressLength * ((score % 100) / 100.0), progressHeight);
  }
}
