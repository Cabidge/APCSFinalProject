class Button {
  String text;
  
  float x, y;
  
  float w, h;
  float textSize;
  
  color nColor; // normal button
  color hColor; // hover button
  color tColor; // text
  
  /**
   * Button with default colors
   */
  Button(String text,
         float x, float y,
         float w, float h,
         float textSize) {
    this(text, x, y, w, h, textSize, color(0), color(200), color(255));
  }
  
  Button(String text,
         float x, float y,
         float w, float h,
         float textSize,
         color nColor, color hColor,
         color tColor) {
    this.text = text;
    
    this.x = x;
    this.y = y;
    
    this.w = w;
    this.h = h;
    this.textSize = textSize;
    
    this.nColor = nColor;
    this.hColor = hColor;
    this.tColor = tColor;
  }
  
  void display() {
    rectMode(CENTER);
    if (isSelected()) {
      fill(hColor);
    } else {
      fill(nColor);
    }
    rect(x,y,w,h);
    
    fill(tColor);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(text,x,y-textSize*0.1);
  }
  
  boolean isSelected() {
    return mouseX >= x-w/2 && mouseX <= x+w/2 &&
           mouseY >= y-h/2 && mouseY <= y+h/2;
  }
}
