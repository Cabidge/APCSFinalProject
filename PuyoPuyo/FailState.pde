class FailState extends State {
  FailState(Game game) {
    super(game);
  }
  
  void onUpdate(float delta) { }
  
  void onDisplay() {
    text("Press 'R' to restart", 100, 100);
  }
}
