class FailState extends State {
  FailState(Game game) {
    super(game);
  }
  
  void onUpdate(float delta) { }
  
  void onDisplay() {
    fill(255,255,0);
    text("Press 'R' to restart", 100, 100);
  }
}
