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
  PImage boardOutline;
  PImage nextBackground;
  PImage titleBackground;
  PImage controlBackground;
  
  HashMap<String,SoundFile> soundMap;
  
  // Display data
  static final int PUYO_W = 64;
  static final int PUYO_H = 60;
  static final int BOARD_X = 800;
  static final int BOARD_Y = 150;
  static final int BOARD_WIDTH = 400;
  static final int BOARD_HEIGHT = 730;
  
  private State state;
  
  private Queue<int[]> nextPairs;
  
  private List<Animation> animations;
  
  static final int TIME_BEFORE_SETTLED = 80;
  private static final int WIGGLE_TIME = 40;
  private int[][] board;
  private int[][] timePlaced; // The time since a puyo has been placed at a square
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
    
    boardOutline = loadImage("FieldOutline.png");
    //boardOutline = loadImage("BoardOutline.png");
    //boardOutline.resize((int)(BOARD_WIDTH * 1.149),(int)(BOARD_HEIGHT * 1.07));
    
    nextBackground = loadImage("FieldNext.png");
    nextBackground.resize(165,0);
    
    this.soundMap = soundMap;
    
    nextPairs = new ArrayDeque<int[]>();
    addRandomPair();
    addRandomPair();
    
    paused = false;
    state = new TitleState(this);
    state.onEnter();
    board = new int[HEIGHT][WIDTH];
    timePlaced = new int[HEIGHT][WIDTH];
    score = 0;
    pmillis = millis();
    
    animations = new ArrayList<Animation>();
  }
  
  float relativeX(float col) {
    return col * PUYO_W + 8;
  }
  
  int relativeX(int col) {
    return col * PUYO_W + 8;
  }
  
  float relativeY(float row) {
    return (row-2) * PUYO_H + 10;
  }
  
  int relativeY(int row) {
    return (row-2) * PUYO_H + 10;
  }
  
  SoundFile getSound(String s){
    return this.soundMap.get(s);
  }
  
  void update() {
    if (!paused) {
      int delta = millis()-pmillis;
      for (int row = 0; row < HEIGHT; row++) {
        for (int col = 0; col < WIDTH; col++) {
          timePlaced[row][col] += delta;
        }
      }
      state.onUpdate(delta / 1000.0);
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
    image(boardOutline, x-17, y-52);
    image(img, x, y);
    displayX();
  }
  
  void displayX() {
    int frame = (int)(4.5 * (1 - cos(millis()/400.0 % PI)));
    PImage img = puyoSprites[11][5 + (4-abs(frame - 4))];
    
    pushMatrix();
    translate(BOARD_X + relativeX(2.5), BOARD_Y + relativeY(2.5));
    imageMode(CENTER);
    if (frame > 4) {
      scale(-1,1);
    }
    image(img,0,0);
    popMatrix();
    imageMode(CORNER);
  }
  
  PGraphics createBoardGraphics() {
    PGraphics pg = createGraphics(BOARD_WIDTH, BOARD_HEIGHT);
    pg.beginDraw();
    pg.image(boardBackground,0,0);
    for (int row = 2; row < HEIGHT; row++) {
      for (int col = 0; col < WIDTH; col++) {
        int type = board[row][col];
        if (type != Puyo.NONE) {
          PImage puyoImg;
          int lifeTime = timePlaced[row][col];
          if (lifeTime >= TIME_BEFORE_SETTLED) {
            puyoImg = puyoImage(type, neighborValueOf(row, col));
          } else {
            int offset = ((lifeTime / WIGGLE_TIME) % 2 == 0)
                         ? 0 : 1;
            puyoImg = puyoSprites[9 + (type / 3)][(10 + type * 2 + offset) % 16];
          }
          pg.image(puyoImg, relativeX(col), relativeY(row));
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
    val += (shouldBond(type, row + 1, col)) ? 1 : 0;
    val += (shouldBond(type, row - 1, col)) ? 2 : 0;
    val += (shouldBond(type, row, col + 1)) ? 4 : 0;
    val += (shouldBond(type, row, col - 1)) ? 8 : 0;
    return val;
  }
  
  boolean shouldBond(int type, int row, int col) {
    if (row < 0 || row >= HEIGHT ||
        col < 0 || col >= WIDTH) {
      return false;
    }
    
    return timePlaced[row][col] >= TIME_BEFORE_SETTLED && board[row][col] == type;
  }
  
  int puyoAt(int row, int col) {
    if (row < 0 || row >= HEIGHT ||
        col < 0 || col >= WIDTH) {
      return Puyo.BARRIER;
    }
    return board[row][col];
  }
  
  boolean setPuyoAt(int row, int col, int type) {
    if (row < 0 || row >= HEIGHT ||
        col < 0 || col >= WIDTH) {
      return false;
    }
    board[row][col] = type;
    timePlaced[row][col] = 0;
    return true;
  }
  
  boolean isNoneAt(int row, int col) {
    return puyoAt(row, col) == Puyo.NONE;
  }
  
  void displayOverlay() {
    displayScore();
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
    image(nextBackground, BOARD_X - 200, BOARD_Y + 100);
    int i = 0;
    float scale = 1.0;
    for (int[] pair : nextPairs) {
      PImage minor = puyoImage(pair[1]);
      PImage pivot = puyoImage(pair[0]);
      
      pushMatrix();
      translate(BOARD_X - 115 - (i * PUYO_W * 1.05),
                BOARD_Y + 124 + (i * PUYO_H * 1.12));
      scale(scale);
      image(minor, 0, 0);
      image(pivot, 0, PUYO_H);
      popMatrix();
      
      i++;
      scale *= 0.8;
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
    text("SCORE", BOARD_X-190, BOARD_Y+30);
    fill(255);
    text(score, BOARD_X-190, BOARD_Y+60);
  }
  
  void displayLevel() {
    fill(0,255,255);
    textAlign(LEFT);
    textSize(32);
    //text("LEVEL: " + getLevel(), BOARD_X+BOARD_WIDTH+40, BOARD_Y+BOARD_HEIGHT-16); original location
    text("LEVEL", BOARD_X-360, BOARD_Y+30);
    fill(255);
    text(getLevel(), BOARD_X-360, BOARD_Y+60);
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
                   .withOrigin(BOARD_X-190 + random(-30, 30),
                               BOARD_Y+60 + random(10))
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
}
