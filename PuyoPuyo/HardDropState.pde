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
    boardGraphics.beginDraw();
    
    drawBlur(boardGraphics, pairTypes[0], pivotX, pivotY);
    drawBlur(boardGraphics, pairTypes[1], pivotX+minorX, pivotY+minorY);
    
    boardGraphics.endDraw();
    
    image(boardGraphics, Game.BOARD_X, Game.BOARD_Y);
    
    game.displayOverlay();
  }
  
  void drawBlur(PGraphics pg, int type, int x, float y) {
    PImage top = puyoSprites[1][21+type];
    PImage bot = puyoSprites[2][21+type];
    drawRelativeImage(pg, top, x, y - 0.5);
    drawRelativeImage(pg, bot, x, y + 0.5);
  }
  
  void drawRelativeImage(PGraphics pg, PImage img, float x, float y) {
    pg.image(img, x * Game.puyoSize, (y -2) * Game.puyoSize);
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
    int DIVISIONS = 5;
    float segment = amount / DIVISIONS;
    for (int i = 0; i < DIVISIONS; i++) {
      if (!updatePivot(0, segment)) {
        float constrainedY = ceil(pivotY + segment - 1);
        if (constrainedY > pivotY) {
          pivotY = constrainedY;
          return true;
        }
        return false;
      }
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
