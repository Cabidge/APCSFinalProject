class Game {
  State state;
  
  Game() {
    state = new NewPuyoState(this);
  }
  
  void update() {
    state.onUpdate();
  }
  
  void display() {
    state.onDisplay();
  }
  
  void keyPressed() {
    state.onKeyPressed();
  }
}
