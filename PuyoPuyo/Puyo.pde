static class Puyo {
  static final int NONE = 0;
  static final int RED = 1;
  static final int BLUE = 2;
  static final int GREEN = 3;
  static final int YELLOW = 4;
  static final int PURPLE = 5;
  
}

int randomPuyo() {
  return (int)(random(1, 6));
}
