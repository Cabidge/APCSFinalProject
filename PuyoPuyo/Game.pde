class Game {
  static final int WIDTH = 6;
  static final int HEIGHT = 12;
  State state;
  
  int[][] board;
  int score;
  
  Game() {
    state = new NewPuyoState(this);
    board = new int[HEIGHT][WIDTH];
    score = 0;
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
