static class Puyo {
  static final int BARRIER = -1; // Out of bounds
  static final int NONE = 0;
  static final int RED = 1;
  static final int GREEN = 2;
  static final int BLUE = 3;
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

PImage puyoImage(int type) {
  return puyoImage(type, 0);
}

/**
 * @param neighbors A 4 bit binary number representing which neighbor the puyo has
 *        1st bit = down, 2nd bit = up, 3rd bit = right, 4th bit = left
 */
PImage puyoImage(int type, int neighbors) {
  return puyoSprites[type - 1][neighbors];
}

PImage puyoImageHighlight(int type) {
  return puyoSprites[9][type - 1];
}
