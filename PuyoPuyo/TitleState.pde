class TitleState extends State {
  Button normalButton;
  Button timerButton;
  Button controlsButton;
  
  TitleState(Game game) {
    super(game);
    
    normalButton = new Button("NORMAL", width/2, height/2 - 100, 500, 100, 90);
    timerButton = new Button("TIMER", width/2, height/2 + 90, 500, 100, 90);
    controlsButton = new Button("controls", width - 120, height - 120, 120, 40, 24);
  }
  
  void onDisplay() {
    game.titleBackground.resize(displayWidth, displayHeight);
    background(game.titleBackground); // main background (in title)
    //background(0);
    textSize(100);
    fill(202, 3, 252);
    textAlign(CENTER, CENTER);
    text("GAME MODE", width/2, 200);
    
    normalButton.display();
    timerButton.display();
    controlsButton.display();
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onMousePressed() {
    if (normalButton.isSelected()) {
      game.changeState(new NewPuyoState(game));
    } else if (timerButton.isSelected()) {
      game.timeActive = true;
      game.changeState(new NewPuyoState(game));
    } else if (controlsButton.isSelected()) {
      game.changeState(new ControlsState(game));
    }
  }
    
}
