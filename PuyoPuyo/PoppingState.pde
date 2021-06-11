class PoppingState extends State {
  static final int MIN_POP_SIZE = 4;
  static final float POPPING_TIME = 0.3;
  static final int FULL_CLEAR_SCORE = 5000;
  
  List<Animation> poppingAnimations;
  int groupsPopped;
  int totalPuyoPopped;
  
  int currentChain;
  
  float timeElapsed;
  
  PImage beforePop;
  PImage afterPop;
  
  PoppingState(Game game, int currentChain) {
    super(game);
    this.currentChain = currentChain + 1;
    poppingAnimations = new ArrayList<Animation>();
  }
  
  void onEnter() {
    beforePop = game.boardImage();
    
    for (int row = 0; row < Game.HEIGHT; row++) {
      for (int col = 0; col < Game.WIDTH; col++) {
        tryFloodPop(col, row);
      }
    }
    
    if (groupsPopped > 0) {
      afterPop = game.boardImage();
      
      Animation chainAnimation = new FadingText(currentChain + "-chain!")
        .withOrigin(1050 + random(80), 620 + random(30))
        .withSize(30 + currentChain * 5)
        .withColor(color(230, 200, 0));
      game.addAnimation(chainAnimation);
      game.getSound("pop").play();
    } else if (!game.isNoneAt(2, 2) || !game.hasTime()) {
      game.changeState(new FailState(game));
    } else {
      game.changeState(new NewPuyoState(game));
    }
  }
  
  void onUpdate(float delta) {
    if (timeElapsed >= POPPING_TIME) {
      game.changeState(new FallingState(game, currentChain));
    } else {
      timeElapsed += delta;
    }
  }
  
  void onExit() {
    if (totalPuyoPopped > 0) {
      if (isFullClear()) {
        Animation fullClearAnim = new FadingText("Full Clear!")
          .withOrigin(Game.BOARD_X + Game.BOARD_WIDTH/2,
                      Game.BOARD_Y + Game.BOARD_HEIGHT/2)
          .withSize(80)
          .withColor(color(255,255,0))
          .withAlign(CENTER, CENTER);
        game.addAnimation(fullClearAnim);
        game.addScore(FULL_CLEAR_SCORE);
      }
      
      int rawScore = calculateScore(totalPuyoPopped, currentChain, groupsPopped);
      game.addScore(game.getLevel() * rawScore);
      game.addGroupsPopped(groupsPopped);
      if (game.timeActive) {
        game.timeLeft += rawScore / 50.0;
      }
      
      for (Animation a : poppingAnimations) {
        game.addAnimation(a);
      }
    }
  }
  
  boolean isFullClear() {
    for (int row = 0; row < Game.HEIGHT; row++) {
      for (int col = 0; col < Game.WIDTH; col++) {
        if (!game.isNoneAt(row, col)) {
          return false;
        }
      }
    }
    return true;
  }
  
  /**
   * Really weird formula to calculate popping score
   * https://puyonexus.com/wiki/Scoring
   */
  int calculateScore(int puyoCount, int chainCount, int groupCount) {
    return (10 * puyoCount)
           * (chainPower(chainCount)
              + colorBonus(groupCount)
              + groupCount - MIN_POP_SIZE);
  }
  
  /**
   * Uses Puyo Puyo Tsu (singleplayer)'s attack power rules.
   * https://puyonexus.com/wiki/List_of_attack_powers#Classic_Rules
   */
  int chainPower(int chainCount) {
    switch (chainCount) {
      case 1: return 4;
      case 2: return 20;
      case 3: return 24;
      case 4: return 32;
      case 5: return 48;
      case 6: return 96;
      case 7: return 160;
      case 8: return 240;
      case 9: return 320;
      case 10: return 480;
      case 11: return 600;
      case 12: return 700;
      case 13: return 800;
      case 14: return 900;
      default: return 999;
    }
  }
  
  int colorBonus(int groupCount) {
    switch (groupCount) {
      case 1: return 0;
      case 2: return 2;
      case 3: return 4;
      case 4: return 8;
      default: return 16;
    }
  }
  
  void onDisplay() {
    game.displayBack();
    
    game.displayBoard((frameCount % 2 == 0)
                      ? beforePop
                      : afterPop);
    
    game.displayOverlay();
  }
  
  /**
   * Tries to pop a group from the given coordinates.
   * Does not pop the group if the size is below MIN_POP_SIZE.
   * @returns if the pop succeeded or not.
   */
  boolean tryFloodPop(int x, int y) {
    int pType = game.puyoAt(y, x);
    
    if (pType == Puyo.NONE) {
      return false;
    }
    
    Queue<int[]> frontier = new ArrayDeque<int[]>();
    List<int[]> group = new ArrayList<int[]>();
    addPopped(frontier, group, x, y);
    
    while (!frontier.isEmpty()) {
      int[] pos = frontier.remove();
      int xOff = -1;
      int yOff = 0;
      for (int i = 0; i < 4; i++) {
        int neighborX = pos[0] + xOff;
        int neighborY = pos[1] + yOff;
        if (neighborX >= 0 && neighborX < Game.WIDTH
            && neighborY >= 0 && neighborY < Game.HEIGHT
            && game.puyoAt(neighborY, neighborX) == pType) {
          addPopped(frontier, group, neighborX, neighborY);
        }
        int temp = xOff;
        xOff = yOff;
        yOff = -temp;
      }
    }
    
    if (group.size() < MIN_POP_SIZE) {
      for (int[] pos : group) {
        game.board[pos[1]][pos[0]] = pType;
      }
      return false;
    } else {
      for (int[] pos : group) {
        poppingAnimations.add(new PoppingAnimation(pos[1], pos[0], pType));
      }
      totalPuyoPopped += group.size();
      groupsPopped++;
      return true;
    }
  }
  
  void addPopped(Queue<int[]> frontier, List<int[]> group, int x, int y) {
    int[] pos = {x, y};
    frontier.add(pos);
    group.add(pos);
    game.board[y][x] = Puyo.NONE;
  }
  
  class PoppingAnimation extends Animation {
    PImage[] frames;
    int row;
    int col;
    PoppingAnimation(int row, int col, int type) {
      super(0.2);
      this.row = row;
      this.col = col;
      frames = new PImage[4];
      frames[0] = puyoSprites[12 + ((type-1) % 2)][((type-1) / 2) * 2];
      frames[1] = puyoSprites[11][type-1];
      frames[2] = puyoSprites[10][4+type*2];
      frames[3] = puyoSprites[10][5+type*2];
    }
    
    void display() {
      pushMatrix();
      translate(Game.BOARD_X + game.relativeX(col+0.5),
                Game.BOARD_Y + game.relativeY(row+0.5));
      scale(1+0.3*pow(timeElapsed(),3.5));
      imageMode(CENTER);
      image(currentFrame(),0,0);
      imageMode(CORNER);
      popMatrix();
    }
    
    PImage currentFrame() {
      return frames[max(0, 3-floor(timeRemaining() / 0.03))];
    }
  }
}
