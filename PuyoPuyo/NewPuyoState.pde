class NewPuyoState extends State {
  static final float IDLE_FALL_SPEED = 0.8;
  static final float MAX_FALL_SPEED = 10;
  
  // Pivot location
  private int pivotX;
  private float pivotY; // Allows moving by half steps instead of only full tiles
  
  // The offset from pivot of the other Puyo
  private int minorX;
  private int minorY;
  
  //[0] = pivot, [1] = minor
  private int[] pairTypes;
  
  // Time before pair is finalized
  static final float FINALIZE_BUFFER = 0.4;
  static final int MAX_STALL_COUNT = 15;
  float bufferTimer;
  float stallHeight;
  int stallCount;
  
  NewPuyoState(Game game) {
    super(game); //<>// //<>//
    
    pivotX = 2;
    pivotY = 1;
    
    minorX = 0;
    minorY = -1;
    
    pairTypes = game.nextPair();
    
    bufferTimer = 0.0;
    stallHeight = 0.0;
    stallCount = 0;
  }
  
  void onUpdate(float delta) {
    if (!moveDown(fallSpeed() * delta)) {
      if ((keyPressed && (keyCode == DOWN || key == 's' || key == 'S'))
          || bufferTimer >= FINALIZE_BUFFER) {
        finalizePair();
      } else {
        bufferTimer += delta;
      }
    } else {
      bufferTimer = 0.0;
    }
  }
  
  void onDisplay() {
    game.displayPuyo(pairTypes[1], pivotX+minorX, pivotY+minorY);
    game.displayPuyo(pairTypes[0], pivotX, pivotY, 3);
  }  
  
  void onKeyPressed() {
    switch (key) {
      case 'z':
      case 'Z':
        rotate(-1);
        break;
      case 'x':
      case 'X':
        rotate(1);
        break;
      case 'a':
      case 'A':
        updatePivot(-1, 0);
        break;
      case 'd':
      case 'D':
        updatePivot(1, 0);
        break;
      case CODED:
        switch (keyCode) {
          case LEFT:
            updatePivot(-1, 0);
            break;
          case RIGHT:
            updatePivot(1, 0);
            break;
        }
        break;
    }
  }
  
  float fallSpeed() {
    if (keyPressed && (keyCode == DOWN || key == 's' || key == 'S')) {
      System.out.println("down");
      return MAX_FALL_SPEED;
    } else {
      return IDLE_FALL_SPEED;
    }
  }

  /**
   * Resets the buffer timer.
   */
  void stall() {
    if (pivotY > stallHeight) { // reset stalling
      stallHeight = pivotY;
      stallCount = 0;
    }
    stallCount++;
    if (stallCount < MAX_STALL_COUNT) {
      bufferTimer = 0.0;
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
   * Rotates the minor Puyo around the pivot Puyo.
   * -1 is counter clockwise, 1 is clockwise.
   * @returns if the rotation was successful or not.
   */
  boolean rotate(int dir) {
    // 90 degree rotation transformation from geometry!
    int newMinorY = minorX * dir;
    int newMinorX = minorY * -dir;
    
    if (isEmptyTile(pivotX + newMinorX, pivotY + newMinorY)) {
      minorX = newMinorX;
      minorY = newMinorY;
      stall();
      return true;
    }
    
    if (minorX == 0) { // was vertical
      if (isEmptyTile(pivotX - newMinorX, pivotY)) { // Wall nudge
        minorX = newMinorX;
        minorY = newMinorY;
        pivotX -= newMinorX;
        stall();
        return true;
      } else { // Column flip
        pivotY += minorY;
        minorY = -minorY;
        stall();
        return true;
      }
    } else if (newMinorY == 1 && isEmptyTile(pivotX, pivotY - 1)
               && stallCount < MAX_STALL_COUNT /* anti-stall */) { // Floor lifr
      minorX = newMinorX;
      minorY = newMinorY;
      pivotY = ceil(pivotY-1);
      stall();
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
           && y >= 0 && ceil(y) < Game.HEIGHT
           && game.board[ceil(y)][x] == Puyo.NONE;
  }

  /**
   * Adds the pivot and minor Puyo to the Game board,
   * and transitions to FallingState
   */
  void finalizePair() {
    game.board[ceil(pivotY)][pivotX] = pairTypes[0];
    game.board[ceil(pivotY+minorY)][pivotX+minorX] = pairTypes[1];
    game.score += 2;
    game.changeState(new FallingState(game));
  }
}
