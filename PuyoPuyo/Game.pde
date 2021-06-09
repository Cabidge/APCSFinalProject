import processing.sound.*;

class Game {
  static final int GROUPS_POPPED_PER_LEVEL = 4;
  private int groupsPopped;
  
  static final float TIME_START = 120.0;
  boolean timeActive;
  private float timeLeft;
  
  static final int WIDTH = 6;
  static final int HEIGHT = 14;
  boolean paused = false;
  
  PImage background;
  PImage boardBackground;
  PImage titleBackground;
  PImage controlBackground;
  PImage boardOutline;
  
  HashMap<String,SoundFile> soundMap;

  
  // Display data
  static final int PUYO_W = 64;
  static final int PUYO_H = 60;
  static final int BOARD_X = 640;
  static final int BOARD_Y = 150;
  static final int BOARD_WIDTH = PUYO_W * WIDTH;
  static final int BOARD_HEIGHT = PUYO_H * (HEIGHT - 2);
  
  private State state;
  
  private Queue<int[]> nextPairs;
  
  private List<Animation> animations;
  
  int[][] board;
  private int score;
  
  int pmillis;
  
  Game(HashMap soundMap) {
    timeLeft = TIME_START;
    
    background = loadImage("PuyoPuyoBackground.jpeg");
    background.resize(width, height);
    
    boardBackground = loadImage("BoardBackground.jpeg");
    boardBackground.resize(BOARD_WIDTH, BOARD_HEIGHT);
    
    //titleBackground = loadImage("TitleBackground.jpeg");
    titleBackground = loadImage("TitleBackground2.jpeg");
    titleBackground.resize(width, height);
    
    controlBackground = loadImage("ControlBackground.jpeg");
    controlBackground.resize(width, height);
    
    boardOutline = loadImage("BoardOutline.png");
    boardOutline.resize((int)(BOARD_WIDTH * 1.149),(int)(BOARD_HEIGHT * 1.07));
    
    this.soundMap = soundMap;
    
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
  
  float relativeX(float col) {
    return col * PUYO_W;
  }
  
  int relativeX(int col) {
    return col * PUYO_W;
  }
  
  float relativeY(float row) {
    return (row-2) * PUYO_H;
  }
  
  int relativeY(int row) {
    return (row-2) * PUYO_H;
  }
  
  SoundFile getSound(String s){
    return this.soundMap.get(s);
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
    background(background); // main background (in game)
  }
  
  void displayBoard() {
    displayBoard(boardImage());
  }
  
  void displayBoard(PImage img) {
    displayBoard(img, BOARD_X, BOARD_Y);
  }
  
  void displayBoard(PImage img, float x, float y) {
    image(img, x, y);
    image(boardOutline, x-33, y-30);
  }
  
  PGraphics createBoardGraphics() {
    PGraphics pg = createGraphics(BOARD_WIDTH, BOARD_HEIGHT);
    pg.beginDraw();
    pg.image(boardBackground,0,0);
    for (int row = 2; row < HEIGHT; row++) {
      for (int col = 0; col < WIDTH; col++) {
        if (board[row][col] != Puyo.NONE) {
          pg.image(puyoImage(board[row][col], neighborValueOf(row, col)),
                   relativeX(col), relativeY(row));
        }
      }
    }
    return pg;
  }
  
  PImage boardImage() {
    PGraphics pg = createBoardGraphics();
    pg.endDraw();
    return pg;
  }
  
  int neighborValueOf(int row, int col) {
    int type = board[row][col];
    if (type == Puyo.NONE) {
      return 0;
    }
    int val = 0;
    val += (puyoAt(row + 1, col) == type) ? 1 : 0;
    val += (puyoAt(row - 1, col) == type) ? 2 : 0;
    val += (puyoAt(row, col + 1) == type) ? 4 : 0;
    val += (puyoAt(row, col - 1) == type) ? 8 : 0;
    return val;
  }
  
  int puyoAt(int row, int col) {
    if (row < 0 || row >= HEIGHT ||
        col < 0 || col >= WIDTH) {
      return Puyo.NONE;
    }
    return board[row][col];
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
      fill(255,0,0);
      text("PAUSED" , 100, 200);
    }
    
    if (timeActive) {
      displayTime();
    }
  }
  
  void displayNextPairs() {
    int i = 0;
    for (int[] pair : nextPairs) {
      PImage minor = puyoImage(pair[1]);
      PImage pivot = puyoImage(pair[0]);
      
      float centerX = BOARD_X + BOARD_WIDTH + 60 + (i * PUYO_W * 1.2);
      float centerY = BOARD_Y + 150 + (i * PUYO_H * 1.2);
      
      image(minor, centerX, centerY);
      image(pivot, centerX, centerY + PUYO_H);
      
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

  void displayScore(){
    textAlign(LEFT);
    textSize(32);
    fill(0,255,255);
    text("SCORE", 1200, 80);
    fill(255);
    text(score, 1200, 130);
  }
  
  void displayTime() {
    textAlign(CENTER);
    textSize(32);
    //rect(725, 960, 200, 50, 8,8,8,8);
    fill(0);
    text("TIME: " + floor(timeLeft * 10) / 10.0, BOARD_X + BOARD_WIDTH/2, BOARD_Y + BOARD_HEIGHT + 76);
  }
  
  void decreaseTime(float amount) {
    timeLeft = max(0, timeLeft - amount);
  }
  
  boolean hasTime() {
    return timeLeft > 0;
  }
  
  /**
   * Use this instead of directly adding to the score counter.
   */
  void addScore(int amount) {
    score += amount;
    addAnimation(new FadingText("+" + amount)
                   .withOrigin(1200 + random(-30, 30), 100 + random(10))
                   .withSize(24));
  }
  
  void changeState(State nextState) {
    state.onExit();
    
    state = nextState;
    state.onEnter();
  }
  
  int getLevel() {
    return groupsPopped / GROUPS_POPPED_PER_LEVEL + 1;
  }
  
  void addGroupsPopped(int amount) {
    int levelBefore = getLevel();
    groupsPopped += amount;
    if (getLevel() > levelBefore) {
      onLevelUp();
    }
  }
  
  void onLevelUp() {
    game.getSound("levelUp").play();
  }
  
  void displayLevel() {
    fill(0,255,255);
    textAlign(LEFT);
    textSize(32);
    //text("LEVEL: " + getLevel(), BOARD_X+BOARD_WIDTH+40, BOARD_Y+BOARD_HEIGHT-16); original location
    text("LEVEL", BOARD_X+800, BOARD_Y+30);
    fill(255);
    text(getLevel(), BOARD_X+800, BOARD_Y+80);
  }
}
