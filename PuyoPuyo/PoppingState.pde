class PoppingState extends State {
  PoppingState(Game game) {
    super(game);
  }
  
  void onUpdate(double delta) {
    game.state = new NewPuyoState(game);
  }
  
  void onDisplay() {
    
  }
}
