class FallingState extends State {
  FallingState(Game game) {
    super(game);
  }
  
  void onUpdate(double delta) {
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
