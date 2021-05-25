class NewPuyoState extends State {
  // Pivot location
  private int pivotX;
  private float pivotY; // Allows moving by half steps instead of only full tiles
  
  // The offset from pivot of the other Puyo
  private int minorX;
  private int minorY;
  
  // [0] = pivot, [1] = minor
  private int[] pairTypes;
  
  NewPuyoState(Game game) {
    super(game);
    
    pivotX = 2;
    pivotY = 1;
    
    minorX = 0;
    minorY = -1;
    
    pairTypes = new int[]{randomPuyo(), randomPuyo()};
  }
  
  void onUpdate() {
    handleLateralMovement();
    if (!moveDown(0.1)) {
      finalizePair();
    }
  }
  
  void onDisplay() {
    // drawPuyo pivotX, pivotY, pairTypes[0]
    // drawPuyo pivotX+minorX, pivotY+minorY, pairTypes[1]
  }
  
  void onKeyPressed() {
    switch (key) {
      case 'z':
      case 'Z':
        // CCW
        break;
      case 'x':
      case 'X':
        // CW
        break;
    }
  }
  
  void handleLateralMovement() {
    if (!keyPressed) {
      return;
    }
    
    switch (keyCode) {
        case LEFT:
          updatePivot(-1, 0);
          break;
        case RIGHT:
          updatePivot(1, 0);
          break;
        case DOWN:
          moveDown(1);
          break;
      }
  }

  /**
   * Trys to update pivotX and pivotY by dx and dy respectively.
   * If this causes either the pivot or minor Puyo to intersect with another Puyo
   * or go out of bounds, it won't update the position.
   * @returns if the pivot was updated successfully.
   */
  boolean updatePivot(int dx, float dy) {
    int newX = pivotX + dx;
    float newY = pivotY + dy;
    
    if (isEmptyTile(newX, newY)
        && isEmptyTile(newX+minorX, newY+minorY)) {
      pivotX = newX;
      pivotY = newY;
      return true;
    }
    
    return false;
  }
  
  boolean moveDown(float amount) {
    if (updatePivot(0, amount)) {
      return true;
    }
    
    float constrainedY = ceil(pivotY + amount - 1);
    if (constrainedY > pivotY) {
      pivotY = constrainedY;
      return true;
    }
    
    return false;
  }
  
  /**
   * Determines whether or not a tile is a free space,
   * and if a Puyo is allowed to be there.
   * Includes out of bounds check.
   * @returns if the given position is an empty tile
   */
  boolean isEmptyTile(int x, float y) {
    return x >= 0 && x < Game.WIDTH
           && y >= 0 && y < Game.HEIGHT
           && game.board[ceil(y)][x] == Puyo.NONE;
  }

  /**
   * Adds the pivot and minor Puyo to the Game board,
   * and transitions to FallingState
   */
  void finalizePair() {
    game.board[ceil(pivotY)][pivotX] = pairTypes[0];
    game.board[ceil(pivotY+minorY)][pivotX+minorX] = pairTypes[1];
    game.state = new FallingState(game);
  }
}
