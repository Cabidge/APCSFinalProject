class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 14;
  boolean paused = false;
  
  // Display data
  static final int puyoSize = 75;
  static final int BOARD_X = 600;
  static final int BOARD_Y = -100;
  static final int BOARD_WIDTH = puyoSize * WIDTH;
  static final int BOARD_HEIGHT = puyoSize * HEIGHT;
  
  private State state;
  
  private Queue<int[]> nextPairs;
  
  private List<Animation> animations;
  
  int[][] board;
  private int score;
  
  int pmillis;
  
  Game() {
    nextPairs = new ArrayDeque<int[]>();
    addRandomPair();
    addRandomPair();
    
    paused = false;
    state = new TitleState(this);
    state.onEnter();
    board = new int[HEIGHT][WIDTH];
    score = 0;
    pmillis = millis();
    
    animations = new ArrayList<Animation>();
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
    state.onDisplay();
    
    // Handle animations
    for (int i = animations.size()-1; i >=0; i--) {
      if (animations.get(i).isDone()) {
        animations.remove(i);
      } else {
        animations.get(i).display();
      }
    }
  }
  
  void addAnimation(Animation anim) {
    animations.add(anim);
  }
  
  void displayBack() {
    background(0);
    rectMode(CORNER);
    fill(240);
    rect(BOARD_X, BOARD_Y+puyoSize*2, BOARD_WIDTH, BOARD_HEIGHT-puyoSize*2); // Main rectangle
  
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
  }
  
  void displayOverlay() {
    displayScore();
    strokeWeight(4);
    stroke(255,0,0);
    line(755,55,820,120);
    line(820,55,755,120);
    
    displayNextPairs();
    
    displayLevel();
    
    if (paused) {
      textSize(80);
      fill(255);
      text("PAUSED" , 100, 200);
    }
  }
  
  void displayNextPairs() {
    int i = 0;
    for (int[] pair : nextPairs) {
      if (i > 2) { // Only show the first two
        break;
      }
      
      displayPuyo(pair[0], WIDTH + 0.5 + i * 1.5, 4.5 + i * 0.8);
      displayPuyo(pair[1], WIDTH + 0.5 + i * 1.5, 3.5 + i * 0.8);
      
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
  
  void mousePressed() {
    state.onMousePressed();
  }
  
  /**
   * Draws a Puyo with respect to the board and with fill color based on the type.
   */
  void displayPuyo(int type, float x, float y) {
    displayPuyo(type, x, y, 1);
  }
  
  /**
   * Draws a Puyo with respect to the board and with fill color based on the type
   * and has option for stroke thickness
   */
  void displayPuyo(int type, float x, float y, float strokeWeight) {
    float centerX = (x+0.5) * puyoSize + BOARD_X;
    float centerY = (y+0.5) * puyoSize+BOARD_Y;
    
    drawPuyo(colorOfPuyo(type), centerX, centerY, puyoSize, strokeWeight);
  }
  
  /**
   * Draws a Puyo without any regards to the board or default Puyo size
   * Useful for when not drawing on the board.
   */
  void drawPuyo(color c, float x, float y, float size, float strokeWeight) {
    fill(c);
    stroke(0);
    strokeWeight(strokeWeight);
    circle(x, y, size);
    
    // Eyes
    strokeWeight(1);
    fill(255);
    float eyeHeight = y - size * 0.02;
    float eyeOffset = size * 0.22;
    circle(x - eyeOffset, eyeHeight, size * 0.42);
    circle(x + eyeOffset, eyeHeight, size * 0.42);
    // Pupil
    fill(lerpColor(c, color(0), 0.24));
    circle(x - eyeOffset + 1, eyeHeight - 1, size * 0.24);
    circle(x + eyeOffset - 1, eyeHeight - 1, size * 0.24);
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
    textAlign(LEFT);
    textSize(32);
    fill(0,255,255);
    text("SCORE", 1200, 80);
    fill(255);
    text(score, 1200, 130);
  }
  
  /**
   * Use this instead of directly adding to the score counter.
   */
  void addScore(int amount) {
    score += amount;
    addAnimation(new FadingText("+" + amount, 1200 + random(-30, 30), 100 + random(10), 24));
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
    textAlign(LEFT);
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
