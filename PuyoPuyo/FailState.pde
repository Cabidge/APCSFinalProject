class FailState extends State {
  FailState(Game game) {
    super(game);
  }
  
  void onUpdate(float delta) { }
  
  void onDisplay() {
    game.displayBack();
    game.displayBoard();
    game.displayOverlay();
    
    textAlign(LEFT);
    fill(255,0,0);
    text("Press 'R' to restart", 100, 100);
    fill(255,0,0);
    
    textSize(32);
    text("FINAL SCORE", 1100,80);
  }
}
