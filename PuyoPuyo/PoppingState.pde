class PoppingState extends State {
  static final int MIN_POP_SIZE = 4;
  static final float POPPING_TIME = 0.1;
  Queue<int[]> frontier;
  List<int[]> poppedGroup;
  
  List<int[]> allPopped;
  
  int currentChain;
  
  float timeElapsed;
  
  PoppingState(Game game, int currentChain) {
    super(game);
    this.currentChain = currentChain + 1;
    frontier = new ArrayDeque<int[]>();
    poppedGroup = new ArrayList<int[]>();
    allPopped = new ArrayList<int[]>();
  }
  
  void onEnter() {
    for (int row = 0; row < Game.HEIGHT; row++) {
      for (int col = 0; col < Game.WIDTH; col++) {
        tryFloodPop(col, row);
      }
    }
    if (allPopped.size() > 0) {
      game.addAnimation(new FadingText(currentChain + "-chain!",
                                       1050 + random(80), 620 + random(30),
                                       30 + currentChain * 5,
                                       color(230, 200, 0)));
    } else if (game.board[2][2] != Puyo.NONE) {
      game.changeState(new FailState(game));
    } else {
      game.changeState(new NewPuyoState(game));
    }
  }
  
  void onUpdate(float delta) {
    if (timeElapsed >= POPPING_TIME) {
      game.changeState(new FallingState(game, currentChain));
      game.addScore(allPopped.size() * currentChain);
      return;
    }
    
    timeElapsed += delta;
  }
  
  void onDisplay() {
    game.displayBack();
    
    for (int[] pos : allPopped) {
      float x = (pos[0]+0.5) * Game.puyoSize + Game.BOARD_X;
      float y = (pos[1]+0.5) * Game.puyoSize + Game.BOARD_Y;
      game.drawPuyo(color(255), x, y, Game.puyoSize, 1);
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
    
    frontier.clear();
    poppedGroup.clear();
    addPopped(x, y);
    
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
          addPopped(neighborX, neighborY);
        }
        int temp = xOff;
        xOff = yOff;
        yOff = -temp;
      }
    }
    
    if (poppedGroup.size() < MIN_POP_SIZE) {
      for (int[] pos : poppedGroup) {
        game.board[pos[1]][pos[0]] = pType;
      }
      return false;
    } else {
      for (int[] pos : poppedGroup) {
        allPopped.add(pos);
      }
      return true;
    }
  }
  
  void addPopped(int x, int y) {
    int[] pos = {x, y};
    frontier.add(pos);
    poppedGroup.add(pos);
    game.board[y][x] = Puyo.NONE;
  }
}
