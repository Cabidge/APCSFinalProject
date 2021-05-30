class PoppingState extends State {
  static final int MIN_POP_SIZE = 4;
  static final float POPPING_TIME = 0.1;
  
  List<List<int[]>> poppedGroups;
  int totalPuyoPopped;
  
  int currentChain;
  
  float timeElapsed;
  
  PoppingState(Game game, int currentChain) {
    super(game);
    this.currentChain = currentChain + 1;
    poppedGroups = new ArrayList<List<int[]>>();
  }
  
  void onEnter() {
    for (int row = 0; row < Game.HEIGHT; row++) {
      for (int col = 0; col < Game.WIDTH; col++) {
        tryFloodPop(col, row);
      }
    }
    if (poppedGroups.size() > 0) {
      game.addAnimation(new FadingText(currentChain + "-chain!",
                                       1050 + random(80), 620 + random(30),
                                       30 + currentChain * 5,
                                       color(230, 200, 0)));
    } else if (game.board[2][2] != Puyo.NONE || !game.hasTime()) {
      game.changeState(new FailState(game));
    } else {
      game.changeState(new NewPuyoState(game));
    }
  }
  
  void onUpdate(float delta) {
    if (timeElapsed >= POPPING_TIME) {
      game.changeState(new FallingState(game, currentChain));
      game.addScore(calculateScore(totalPuyoPopped, currentChain, poppedGroups.size()));
      game.groupsPopped += poppedGroups.size();
      return;
    }
    
    timeElapsed += delta;
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
    
    for (List<int[]> group : poppedGroups) {
      for (int[] pos : group) {
        float x = (pos[0]+0.5) * Game.puyoSize + Game.BOARD_X;
        float y = (pos[1]+0.5) * Game.puyoSize + Game.BOARD_Y;
        game.drawPuyo(color(255), x, y, Game.puyoSize, 1);
      }
    }
    
    game.displayOverlay();
  }
  
  /**
   * Tries to pop a group from the given coordinates.
   * Does not pop the group if the size is below MIN_POP_SIZE.
   * @returns if the pop succeeded or not.
   */
  boolean tryFloodPop(int x, int y) {
    int pType = game.board[y][x];
    
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
            && game.board[neighborY][neighborX] == pType) {
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
      totalPuyoPopped += group.size();
      poppedGroups.add(group);
      return true;
    }
  }
  
  void addPopped(Queue<int[]> frontier, List<int[]> group, int x, int y) {
    int[] pos = {x, y};
    frontier.add(pos);
    group.add(pos);
    game.board[y][x] = Puyo.NONE;
  }
}
