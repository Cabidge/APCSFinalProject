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
      
      if (paused) {
        textSize(80);
        fill(255);
        text("PAUSED" , 100, 200);
      }
      
      displayNextPairs();
    }
    
    if(gamemode==3){
      controlPanel();
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
    int gray = 200;
    if(gamemode==0){
      background(0);
      textSize(90);
      fill(0,255,255);
      text("GAME MODE", 570,280);
      fill(255);
      text("NORMAL", 660,480);
      text("TIMER", 700,680);
      textSize(30);
      fill(255,0,0);
      text("controls", 1515,885);
    }
    
    if(gamemode==0 && mouseX>600 && mouseX<600+500 && 
       mouseY>400 && mouseY<400+100) { // GAMEMODE NORMAL
      fill(gray);
      rect(600,400,500,100);
      fill(255);
      textSize(90);
      text("NORMAL", 660,480);
      if(mousePressed){
        gamemode=1;
      }
    }
    if(gamemode==0 && mouseX>600 && mouseX<600+500 && 
       mouseY>600 && mouseY<600+100) { // GAMEMODE TIMER
      fill(gray);
      rect(600,600,500,100);
      fill(255);
      textSize(90);
      text("TIMER", 700,680);
      if(mousePressed){
        gamemode=2;
      }
    }
    if(gamemode==0 && mouseX>1500 && mouseX<1500+150 &&
       mouseY>850 && mouseY<850+50) { // CONTROLS PAGE
      fill(gray);
      rect(1500,850,150,50);
      fill(255,0,0);
      textSize(30);
      text("controls", 1515,885);
      if(mousePressed){
        gamemode=3;
      }
    }
  }
  
  void controlPanel(){
     clear();
     fill(255);
     text("CONTROLS", 100,100);
     text("Movement: ", 100,200);
     text("or", 400, 300);
     text("GAME: ", 100,500);
     text("Return to title",300,595);
     text("Pause",300,695);
     text("Rotate", 375,795);
     
     rect(200,250,70,70,8,8,8,8);
     rect(200,325,70,70,8,8,8,8);
     rect(125,325,70,70,8,8,8,8);
     rect(275,325,70,70,8,8,8,8);

     rect(550,250,70,70,8,8,8,8);
     rect(550,325,70,70,8,8,8,8);
     rect(475,325,70,70,8,8,8,8);
     rect(625,325,70,70,8,8,8,8);
     
     rect(200,550,70,70,8,8,8,8);
     rect(200,650,70,70,8,8,8,8);
     rect(200,750,70,70,8,8,8,8);
     rect(275,750,70,70,8,8,8,8);
     
     fill(0);
     text("W",225,295);
     text("A",150,370);
     text("S",225,370);
     text("D",300,370);
     text("^",225+350,295);
     text("<",150+350,370);
     text("v",225+350,370);
     text(">",300+350,370);
     text("R",225,595);
     text("P",225,695);
     text("Z",225,795);
     text("X",300,795);
     
     
     //text("A or <-- to move left", 300, 200);
     //text("D or --> to move right", 300, 250);
     //text("S or | to move right", 300, 300);
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
    fill(0,255,255);
    text("SCORE", 1200, 80);
    fill(255);
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
}
