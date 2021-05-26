class PoppingState extends State {
  PoppingState(Game game) {
    super(game);
    game.state = new NewPuyoState(game);
  }
  
  void onUpdate() {
    
  }
  
  void onDisplay() {
    
  }
}
