class TitleState extends State {
  Button normalButton;
  Button timerButton;
  Button controlsButton;
  Button skinButton;
  
  PImage logo;
  
  TitleState(Game game) {
    super(game);
    
    normalButton = new Button("NORMAL", width/2, height/2 - 10, 500, 100, 90);
    timerButton = new Button("TIMER", width/2, height/2 + 180, 500, 100, 90);
    controlsButton = new Button("controls", width - 120, height - 70, 180, 40, 24);
    skinButton = new Button("change skin", width - 120, height - 140, 180, 40, 24);
    
    logo = loadImage("Title.png");
  }
  
  void onDisplay() {
    background(game.titleBackground); // main background (in title)
    //background(0);
    
    imageMode(CENTER);
    image(logo, width/2, logo.height);
    imageMode(CORNER);
    
    normalButton.display();
    timerButton.display();
    controlsButton.display();
    skinButton.display();
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onMousePressed() {
    if (normalButton.isSelected()) {
      game.getSound("button").play();
      game.changeState(new NewPuyoState(game));
    } else if (timerButton.isSelected()) {
      game.getSound("button").play();
      game.timeActive = true;
      game.changeState(new NewPuyoState(game));
    } else if (controlsButton.isSelected()) {
      game.getSound("button").play();
      game.changeState(new ControlsState(game));
    } else if (skinButton.isSelected()) {
      game.getSound("button").play();
      game.changeState(new SkinState(game));
    }
  }
    
}
