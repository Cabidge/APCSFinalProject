class FallingState extends State {
  FallingState(Game game) {
    super(game);
  }
  
  void onUpdate() {
    if (!induceGravity()) {
      game.state = new PoppingState(game);
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
      for (int col = 0; col < Game.WIDTH; col ++) {
        if (game.board[col+1][row] == Puyo.NONE) {
          game.board[col+1][row] = game.board[col][row];
          game.board[col][row] = Puyo.NONE;
          anyMoved = true;
        }
      }
    }
    return anyMoved;
  }
}
