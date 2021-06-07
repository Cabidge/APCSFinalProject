class FallingState extends State {
  static final float GRAVITY = 60;
  float dy;
  
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
        if (game.board[row+1][col] == Puyo.NONE &&
            game.board[row][col] != Puyo.NONE) {
          int bottom = row;
          List<Integer> types = new ArrayList<Integer>();
          while (game.puyoAt(row, col) != Puyo.NONE) {
            types.add(game.board[row][col]);
            game.board[row][col] = Puyo.NONE;
            row--;
          }
          fallingPuyo.add(new PuyoColumn(bottom, col, types));
        }
      }
    }
  }
  
  void onUpdate(float delta) {
    dy += GRAVITY * delta;
    if (!induceGravity(delta * dy)) {
      game.changeState(new PoppingState(game, currentChain));
    }
  }
  
  void onDisplay() {
    game.displayBack();
    
    PGraphics boardGraphics = game.createBoardGraphics();
    boardGraphics.beginDraw();
    
    for (PuyoColumn column : fallingPuyo) {
      column.drawColumn(boardGraphics);
    }
    
    boardGraphics.endDraw();
    
    image(boardGraphics, Game.BOARD_X, Game.BOARD_Y);
    
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
      int x = col * Game.puyoSize;
      float y = (row-2) * Game.puyoSize;
      for (int type : types) {
        pg.image(puyoImage(type), x, y);
        y -= Game.puyoSize;
      }
    }
    
    boolean moveDown(float amount) {
      int DIVISIONS = 10;
      float segment = amount / DIVISIONS;
      for (int i = 0; i < DIVISIONS; i++) {
        if (!updateRow(segment)) {
          int constrainedRow = ceil(row + segment - 1);
          if (constrainedRow > row) {
            // Finalize column
            for (int type : types) {
              game.board[constrainedRow][col] = type;
              constrainedRow--;
            }
            return false;
          }
          return false;
        }
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
    return x >= 0 && x < Game.WIDTH
           && y >= 0 && ceil(y) < Game.HEIGHT
           && game.board[ceil(y)][x] == Puyo.NONE;
  }
}
