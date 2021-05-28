import java.util.*;

class PoppingState extends State {
  static final int MIN_POP_SIZE = 4;
  Queue<int[]> frontier;
  List<int[]> poppedGroup;
  
  int currentChain;
  
  PoppingState(Game game, int currentChain) {
    super(game);
    this.currentChain = currentChain + 1;
    frontier = new ArrayDeque<int[]>();
    poppedGroup = new ArrayList<int[]>();
  }
  
  void onEnter() {
    boolean anyPopped = false;
    for (int row = 0; row < Game.HEIGHT; row++) {
      for (int col = 0; col < Game.WIDTH; col++) {
        anyPopped = tryFloodPop(col, row) || anyPopped;
      }
    }
    if (anyPopped) {
      game.changeState(new FallingState(game, currentChain));
    } else if (game.board[1][2] != Puyo.NONE) {
      game.changeState(new FailState(game));
    } else {
      game.changeState(new NewPuyoState(game));
    }
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onDisplay() {
    game.displayGame();
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
      game.score += poppedGroup.size() * currentChain;
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
