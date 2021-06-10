class HardDropState extends State {
  static final float FALL_SPEED = 100;
  
  // Pivot location
  private int pivotX;
  private float pivotY; // Allows moving by half steps instead of only full tiles
  
  // The offset from pivot of the other Puyo
  private int minorX;
  private int minorY;
  
  //[0] = pivot, [1] = minor
  private int[] pairTypes;
  
  HardDropState(Game game, int[] pairTypes, int pivotX, float pivotY, int minorX, int minorY) {
    super(game);
    this.pairTypes = pairTypes;
    this.pivotX = pivotX;
    this.pivotY = pivotY;
    this.minorX = minorX;
    this.minorY = minorY;
  }
  
  void onUpdate(float delta) {
    if (!moveDown(FALL_SPEED * delta)) {
      finalizePair();
    }
  }
  
  void onDisplay() {
    // Not perfectly linear, but at high enough fps's this should look fairly normal
    game.displayBack();
    
    PGraphics boardGraphics = game.createBoardGraphics();
    
    drawBlur(boardGraphics, pairTypes[0], pivotX, pivotY);
    drawBlur(boardGraphics, pairTypes[1], pivotX+minorX, pivotY+minorY);
    
    boardGraphics.endDraw();
    
    game.displayBoard(boardGraphics);
    
    game.displayOverlay();
  }
  
  void drawBlur(PGraphics pg, int type, int x, float y) {
    PImage top = puyoSprites[1][21+type];
    PImage bot = puyoSprites[2][21+type];
    drawRelativeImage(pg, top, x, y - 1);
    drawRelativeImage(pg, bot, x, y);
  }
  
  void drawRelativeImage(PGraphics pg, PImage img, float x, float y) {
    pg.image(img, game.relativeX(x), game.relativeY(y));
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
    while (amount > 0) {
      float segment = min(1, amount);
      if (!updatePivot(0, segment)) {
        float constrainedY = ceil(pivotY +  - 1);
        if (constrainedY > pivotY) {
          pivotY = constrainedY;
          return true;
        }
        return false;
      }
      amount -= segment;
    }
    
    return true;
  }
  
  /**
   * Determines whether or not a tile is a free space,
   * and if a Puyo is allowed to be there.
   * Includes out of bounds check.
   * @returns if the given position is an empty tile
   */
  boolean isEmptyTile(int x, float y) {
    return game.isNoneAt(ceil(y), x);
  }

  /**
   * Adds the pivot and minor Puyo to the Game board,
   * and transitions to FallingState
   */
  void finalizePair() {
    game.getSound("land").play();
    game.setPuyoAt(ceil(pivotY), pivotX, pairTypes[0]);
    game.setPuyoAt(ceil(pivotY+minorY), pivotX+minorX, pairTypes[1]);
    game.addScore(2);
    game.changeState(new FallingState(game));
  }
}
