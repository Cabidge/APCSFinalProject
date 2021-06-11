class SkinState extends State {
  Button backButton;
  Button next;
  Button prev;
  
  PImage background;
  
  SkinState(Game game) {
    super(game);
    
    backButton = new Button("back", width - 120, height - 70, 180, 40, 24);
    next = new Button(">", width/2 + 300, height - 300, 100, 100, 60);
    prev = new Button("<", width/2 - 300, height - 300, 100, 100, 60);
    
    background = loadImage("TitleBackground.jpeg");
    background.resize(width,height);
  }
  
  void onDisplay() {
    background(background);
    backButton.display();
    
    rectMode(CENTER);
    fill(0, 100);
    rect(width/2, height/2, 900, 800);
    
    // Skin Display
    displayRing(width/2, height/2 - 100);
    
    // Skin Select
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(80);
    text(skinNames[currentSkin], width/2, height-300);
    next.display();
    prev.display();
  }
  
  void onUpdate(float delta) {
    
  }
  
  void displayRing(float x, float y) {
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    float angle = millis()/1000.0; 
    rotate(angle);
    scale(1.5);
    float offset = (2 * PI) / 5.0;
    for (int i = 1; i <= 5; i++) {
      pushMatrix();
      translate(0, -80);
      rotate(offset*(1-i) - angle);
      image(puyoImage(i), 0, 0);
      popMatrix();
      rotate(offset);
    }
    imageMode(CORNER);
    popMatrix();
  }
  
  void onMousePressed() {
    if (backButton.isSelected()) {
      game.getSound("button").play();
      game.changeState(new TitleState(game));
    } else if (next.isSelected()) {
      currentSkin = (currentSkin + 1) % skinNames.length;
      reloadSkin();
      game.getSound("button").play();
    } else if (prev.isSelected()) {
      currentSkin--;
      if (currentSkin < 0) {
        currentSkin += skinNames.length;
      }
      reloadSkin();
      game.getSound("button").play();
    }
  }
}
