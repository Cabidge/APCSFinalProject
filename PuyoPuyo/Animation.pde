abstract class Animation {
  private float duration;
  private float timeInitial;
  
  Animation(float duration) {
    this.duration = duration;
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
  
  FadingText(String text, float x, float y, float size) {
    this(text, x, y, 0, -45, size, color(255), 0.2);
  }
  
  FadingText(String text, float x, float y, float dx, float dy, float size, color c, float opaqueTime) {
    super(FADE_TIME + opaqueTime);
    this.text = text;
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.size = size;
    this.c = c;
    this.opaqueTime = opaqueTime;
  }
  
  void display() {
    float t = timeElapsed();
    if (t <= opaqueTime) {
      fill(c);
    } else {
      fill(c, 255 * (timeRemaining() / FADE_TIME));
    }
    textSize(size);
    text(text, x + dx * t, y + dy * t);
  }
}
