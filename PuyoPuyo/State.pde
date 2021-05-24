abstract class State {
  Game game;
  
  State(Game game) {
    this.game = game;
  }
  
  abstract void onUpdate();
  abstract void onDisplay();
  
  void onKeyPressed() { }
}
