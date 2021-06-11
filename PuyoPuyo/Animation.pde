abstract class Animation {
  private float duration;
  private float timeInitial;
  
  Animation(float duration) {
    this.duration = duration;
  }
  
  void play() {
    timeInitial = millis() / 1000.0;
  }
  
  float timeElapsed() {
    return millis() / 1000.0 - timeInitial;
  }
  
  float timeRemaining() {
    return duration - timeElapsed();
  }
  
  boolean isDone() {
    return timeRemaining() <= 0;
  }
  
  abstract void display();
}

class FadingText extends Animation {
  private static final float FADE_TIME = 1.0;
  
  private String text;
  
  private float x, y;
  private float dx, dy;
  private float size;
  private color c;
  
  private float opaqueTime;
  
  private int alignX;
  private int alignY;
  
  FadingText(String text) {
    this(text, 0.2);
  }
  
  FadingText(String text, float opaqueTime) {
    super(FADE_TIME + opaqueTime);
    this.text = text;
    this.opaqueTime = opaqueTime;
    
    x = 0;
    y = 0;
    dx = 0;
    dy = -45;
    size = 24;
    c = color(255);
    alignX = LEFT;
    alignY = BASELINE;
  }
  
  FadingText withOrigin(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }
  
  FadingText withVelocity(float x, float y) {
    dx = x;
    dy = y;
    return this;
  }
  
  FadingText withSize(float size) {
    this.size = size;
    return this;
  }
  
  FadingText withColor(color c) {
    this.c = c;
    return this;
  }
  
  FadingText withAlign(int alignX, int alignY) {
    this.alignX = alignX;
    this.alignY = alignY;
    return this;
  }
  
  FadingText withAlign(int alignX) {
    return withAlign(alignX, BASELINE);
  }
  
  void display() {
    float t = timeElapsed();
    if (t <= opaqueTime) {
      fill(c);
    } else {
      fill(c, 255 * (timeRemaining() / FADE_TIME));
    }
    textSize(size);
    textAlign(alignX, alignY);
    text(text, x + dx * t, y + dy * t);
  }
}
