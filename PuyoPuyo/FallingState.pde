class FallingState extends State {
  static final float GRAVITY = 60;
  float dy;
  
  float timeSinceFinalized;
  
  Queue<PuyoColumn> fallingPuyo;
  
  int currentChain;
  
  FallingState(Game game) {
    this(game, 0);
  }
  
  FallingState(Game game, int currentChain) {
    super(game);
    this.currentChain = currentChain;
    
    // Initiate falling puyo lists and remove them from the game board**
    fallingPuyo = new ArrayDeque<PuyoColumn>();
    for (int col = 0; col < Game.WIDTH; col++) {
      for (int row = Game.HEIGHT-2; row >= 0; row--) {
        if (game.puyoAt(row+1, col) == Puyo.NONE &&
            game.puyoAt(row, col) != Puyo.NONE) {
          int bottom = row;
          List<Integer> types = new ArrayList<Integer>();
          while (game.puyoAt(row, col) != Puyo.NONE) {
            types.add(game.puyoAt(row,col));
            game.setPuyoAt(row, col, Puyo.NONE);
            row--;
          }
          fallingPuyo.add(new PuyoColumn(bottom, col, types));
        }
      }
    }
  }
  
  void onUpdate(float delta) {
    if (fallingPuyo.size() == 0) {
      timeSinceFinalized += delta;
      if (timeSinceFinalized*1000 >= Game.TIME_BEFORE_SETTLED+10) {
        game.changeState(new PoppingState(game, currentChain));
      }
    } else {
      dy += GRAVITY * delta;
      induceGravity(delta * dy);
    }
  }
  
  void onDisplay() {
    game.displayBack();
    
    PGraphics boardGraphics = game.createBoardGraphics();
    
    for (PuyoColumn column : fallingPuyo) {
      column.drawColumn(boardGraphics);
    }
    
    boardGraphics.endDraw();
    
    game.displayBoard(boardGraphics);
    
    game.displayOverlay();
  }
  
  /**
   * Moves Puyo down a tile if there is a free space under them.
   * @returns If any Puyo was moved.
   */
  boolean induceGravity(float amount) {
    boolean anyMoved = false;
    boolean anyLanded = false;
    for (int columnsLeft = fallingPuyo.size(); columnsLeft > 0; columnsLeft--) {
      PuyoColumn column = fallingPuyo.remove();
      if (column.moveDown(amount)) {
        anyMoved = true;
        fallingPuyo.add(column);
      } else {
        anyLanded = true;
      }
    }
    if (anyLanded) {
      game.getSound("land").play();
    }
    return anyMoved;
  }
  
  class PuyoColumn {
    float row;
    int col;
    List<Integer> types;
    
    PuyoColumn(float row, int col, List<Integer> types) {
      this.row = row;
      this.col = col;
      this.types = types;
    }
    
    void drawColumn(PGraphics pg) {
      int x = game.relativeX(col);
      float drawRow = row;
      for (int type : types) {
        pg.image(puyoImage(type), x, game.relativeY(drawRow));
        drawRow--;
      }
    }
    
    boolean moveDown(float amount) {
      while (amount > 0) {
        float segment = min(1, amount);
        if (!updateRow(segment)) {
          int constrainedRow = ceil(row + segment - 1);
          if (constrainedRow > row) {
            // Finalize column
            for (int type : types) {
              game.setPuyoAt(constrainedRow, col, type);
              constrainedRow--;
            }
            return false;
          }
          return false;
        }
        amount -= segment;
      }
      return true;
    }
    
    boolean updateRow(float amount) {
      float newRow = row + amount;
      
      if (isEmptyTile(col, newRow)) {
        row = newRow;
        return true;
      }
    
      return false;
    }
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
}
