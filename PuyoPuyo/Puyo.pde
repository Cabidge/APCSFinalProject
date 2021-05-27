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

color colorOfPuyo(int type) {
  switch (type) {
    case Puyo.RED: return color(255,0,0);
    case Puyo.BLUE: return color(0,0,255);
    case Puyo.GREEN: return color(0,255,0);
    case Puyo.YELLOW: return color(255,255,0);
    case Puyo.PURPLE: return color(255,0,255);
    default: return color(0);
  }
}
