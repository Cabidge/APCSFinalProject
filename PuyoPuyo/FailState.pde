class FailState extends State {
  FailState(Game game) {
    super(game);
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onDisplay() {
    text("Press 'R' to restart", 100, 100);
  }
  
  void keyPressed() {
    if (key == 'r' || key == 'R') {
      game.reset();
    }
  }
}
