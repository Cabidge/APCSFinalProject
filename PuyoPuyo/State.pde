abstract class State {
  Game game;
  boolean paused = false;
  
  State(Game game) {
    this.game = game;
  }
  
  /**
   * @param delta the number of seconds since the last onUpdate call.
   */
  abstract void onUpdate(float delta);
  abstract void onDisplay();
  
  void keyPressed() {
  if ( key == 'p' ) {
      paused = !paused;
      if (paused) {
        noLoop();
        textSize(80);
        text("PAUSED" , 100, 200);
      } else {
        loop();
      }
    }
  }
}
