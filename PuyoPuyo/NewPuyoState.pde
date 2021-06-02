class NewPuyoState extends State {
  static final float STEEPNESS = 0.1; // a magical constant in a formula
  static final float MIN_IDLE_FALL_SPEED = 0.1;
  static final float MAX_IDLE_FALL_SPEED = 2;
  static final float MAX_FALL_SPEED = 12;
  
  private float pivotSpriteX; // Used for smooth animation
  
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
   //<>//
  NewPuyoState(Game game) {
    super(game); //<>// //<>//
    
    pivotX = 2;
    pivotY = 1;
    pivotSpriteX = pivotX;
    
    minorX = 0;
    minorY = -1;
    
    pairTypes = game.nextPair();
    
    bufferTimer = 0.0;
    stallHeight = 0.0;
    stallCount = 0;
  }
  
  void onUpdate(float delta) {
    if (game.timeActive) {
      game.decreaseTime(delta);
      if (!game.hasTime()) {
        hardDrop();
        return;
      }
    }
    
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
    // Not perfectly linear, but at high enough fps's this should look fairly normal
    pivotSpriteX = lerp(pivotSpriteX, pivotX, 0.9);
    
    game.displayBack();
    displayHint();
    game.displayPuyo(pairTypes[1], pivotSpriteX+minorX, pivotY+minorY);
    game.displayPuyo(pairTypes[0], pivotSpriteX, pivotY, 3);
    game.displayOverlay();
  }
  
  void displayHint() {
    int[] finalHeights = getFinalHeights();
    displayHintAt(pairTypes[0], pivotX, finalHeights[0]);
    displayHintAt(pairTypes[1], pivotX+minorX, finalHeights[1]);
  }
  
  void displayHintAt(int type, int x, int y) {
    fill(colorOfPuyo(type));
    circle((x + 0.5) * Game.puyoSize + Game.BOARD_X,
           (y - 1.5) * Game.puyoSize + Game.BOARD_Y,
           Game.puyoSize / 3);
  }
  
  int[] getFinalHeights() {
    if (minorX == 0) { // vertical
      int top = topOfColumn(pivotX);
      if (minorY == -1) { // minor above
        return new int[]{top, top-1};
      } else { // pivot above
        return new int[]{top-1, top};
      }
    } else {
      return new int[]{topOfColumn(pivotX), topOfColumn(pivotX + minorX)};
    }
  }
  
  void hardDrop() {
    int[] finalHeights = getFinalHeights();
    game.getSound("land").play();
    game.board[finalHeights[0]][pivotX] = pairTypes[0];
    game.board[finalHeights[1]][pivotX+minorX] = pairTypes[1];
    game.addScore(2);
    game.changeState(new PoppingState(game, 0));
  }
  
  /**
   * Finds the index of the bottom empty tile of a column.
   */
  int topOfColumn(int col) {
    for (int i = Game.HEIGHT-1; i >= 0; i--) {
      if (game.board[i][col] == Puyo.NONE) {
        return i;
      }
    }
    return -1;
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
      case 'w':
      case 'W':
      case ' ':
        hardDrop();
        break;
      case CODED:
        switch (keyCode) {
          case LEFT:
            updatePivot(-1, 0);
            break;
          case RIGHT:
            updatePivot(1, 0);
            break;
          case UP:
            hardDrop();
            break;
        }
        break;
    }
  }
  
  float fallSpeed() {
    if (keyPressed && (keyCode == DOWN || key == 's' || key == 'S')) {
      return MAX_FALL_SPEED;
    } else {
      return (MIN_IDLE_FALL_SPEED - MAX_IDLE_FALL_SPEED)
             / (STEEPNESS * game.getLevel() + 1)
             + MAX_IDLE_FALL_SPEED;
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
      if (dy == 0) {
        game.getSound("move").play();
      }
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
      game.getSound("rotate").play();
      return true;
    }
    
    if (minorX == 0) { // was vertical
      if (isEmptyTile(pivotX - newMinorX, pivotY)) { // Wall nudge
        minorX = newMinorX;
        minorY = newMinorY;
        pivotX -= newMinorX;
      } else { // Column flip
        pivotY += minorY;
        minorY = -minorY;
      }
      stall();
      game.getSound("rotate").play();
      return true;
    } else if (newMinorY == 1 && isEmptyTile(pivotX, pivotY - 1)
               && stallCount < MAX_STALL_COUNT /* anti-stall */) { // Floor lifr
      minorX = newMinorX;
      minorY = newMinorY;
      pivotY = ceil(pivotY-1);
      stall();
      game.getSound("rotate").play();
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
    game.getSound("land").play();
    game.board[ceil(pivotY)][pivotX] = pairTypes[0];
    game.board[ceil(pivotY+minorY)][pivotX+minorX] = pairTypes[1];
    game.addScore(2);
    game.changeState(new FallingState(game));
  }
}
