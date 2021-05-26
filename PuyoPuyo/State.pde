abstract class State {
  Game game;
  
  State(Game game) {
    this.game = game;
  }
  
  /**
   * @param delta the number of seconds since the last onUpdate call.
   */
  abstract void onUpdate(float delta);
  abstract void onDisplay();
  
  void onKeyPressed() {
  }
}
