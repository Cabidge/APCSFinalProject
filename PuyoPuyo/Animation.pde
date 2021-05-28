abstract class Animation {
  private float duration;
  private float timeInitial;
  
  Animation(float duration) {
    this.duration = duration;
  }
  
  float timeElapsed() {
    return millis() - timeInitial;
  }
  
  float timeRemaining() {
    return duration - timeElapsed();
  }
  
  boolean isDone() {
    return timeRemaining() <= 0;
  }
  
  abstract void display();
}
