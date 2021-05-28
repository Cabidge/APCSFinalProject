class TitleState extends State {
  TitleState(Game game) {
    super(game);
  }
  
  void onDisplay() {
    int gray = 200;
    
    background(0);
    textSize(90);
    fill(0,255,255);
    text("GAME MODE", 570,280);
    fill(255);
    text("NORMAL", 660,480);
    text("TIMER", 700,680);
    textSize(30);
    fill(255,0,0);
    text("controls", 1515,885);
    
    if (normalSelected()) {
      fill(gray);
      rect(600,400,500,100);
      fill(255);
      textSize(90);
      text("NORMAL", 660,480);
    } else if (timerSelected()) {
      fill(gray);
      rect(600,600,500,100);
      fill(255);
      textSize(90);
      text("TIMER", 700,680);
    } else if (controlsSelected()) {
      fill(gray);
      rect(1500,850,150,50);
      fill(255,0,0);
      textSize(30);
      text("controls", 1515,885);
    }
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onMousePressed() {
    if (normalSelected()) {
      game.changeState(new NewPuyoState(game));
    } else if (controlsSelected()) {
      game.changeState(new ControlsState(game));
    }
  }
  
  boolean normalSelected() {
    return mouseX>600 && mouseX<600+500
           && mouseY>400 && mouseY<400+100;
  }
  
  boolean timerSelected() {
    return mouseX>600 && mouseX<600+500
           && mouseY>600 && mouseY<600+100;
  }

  boolean controlsSelected() {
    return mouseX>1500 && mouseX<1500+150
           && mouseY>850 && mouseY<850+50;
  }
}
