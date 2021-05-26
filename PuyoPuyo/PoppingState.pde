class PoppingState extends State {
  PoppingState(Game game) {
    super(game);
  }
  
  void onUpdate() {
    game.state = new NewPuyoState(game);
  }
  
  void onDisplay() {
    
  }
}
