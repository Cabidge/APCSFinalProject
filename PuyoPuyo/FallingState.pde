class FallingState extends State {
  // Number of seconds before each induceGravity call
  static final float FALL_DELAY = 0.08;
  float timeSinceFalling;
  
  FallingState(Game game) {
    super(game);
    
    timeSinceFalling = 0.0;
  }
  
  void onUpdate(float delta) {
    timeSinceFalling += delta;
    
    while (timeSinceFalling >= FALL_DELAY) {
      if (!induceGravity()) {
        game.changeState(new PoppingState(game));
        return;
      }
      timeSinceFalling -= FALL_DELAY;
    }
  }
  
  void onDisplay() {
    
  }
  
  /**
   * Moves Puyo down a tile if there is a free space under them.
   * @returns If any Puyo was moved.
   */
  boolean induceGravity() {
    boolean anyMoved = false;
    for (int row = Game.HEIGHT - 2; row >= 0; row--) {
      for (int col = 0; col < Game.WIDTH; col++) {
        if (game.board[row][col] != Puyo.NONE
            && game.board[row+1][col] == Puyo.NONE) {
          game.board[row+1][col] = game.board[row][col];
          game.board[row][col] = Puyo.NONE;
          anyMoved = true;
        }
      }
    }
    return anyMoved;
  }
}
