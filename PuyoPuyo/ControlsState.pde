class ControlsState extends State {
  Button backButton;
  
  
  ControlsState(Game game) {
    super(game);
    
    backButton = new Button("back", width - 120, height - 70, 180, 40, 24);
  }
  
  void onDisplay() {
     
     clear();
     background(game.controlBackground);
     fill(255);
     textAlign(LEFT);
     text("CONTROLS", 100,100);
     text("Movement: ", 100,200);
     text("or", 400, 300);
     text("GAME: ", 100,500);
     text("Return to title",300,595);
     text("Pause",300,695);
     text("Rotate", 375,795);
     
     rectMode(CORNER);
     rect(200,250,70,70,8,8,8,8);
     rect(200,325,70,70,8,8,8,8);
     rect(125,325,70,70,8,8,8,8);
     rect(275,325,70,70,8,8,8,8);

     rect(550,250,70,70,8,8,8,8);
     rect(550,325,70,70,8,8,8,8);
     rect(475,325,70,70,8,8,8,8);
     rect(625,325,70,70,8,8,8,8);
     
     rect(200,550,70,70,8,8,8,8);
     rect(200,650,70,70,8,8,8,8);
     rect(200,750,70,70,8,8,8,8);
     rect(275,750,70,70,8,8,8,8);
     
     fill(0);
     text("W",225,295);
     text("A",150,370);
     text("S",225,370);
     text("D",300,370);
     text("^",225+350,295);
     text("<",150+350,370);
     text("v",225+350,370);
     text(">",300+350,370);
     text("R",225,595);
     text("P",225,695);
     text("Z",225,795);
     text("X",300,795);
     
     
     //text("A or <-- to move left", 300, 200);
     //text("D or --> to move right", 300, 250);
     //text("S or | to move right", 300, 300);
     backButton.display();
  }
  
  void onUpdate(float delta) {
    
  }
  
  void onMousePressed() {
    if (backButton.isSelected()) {
      game.getSound("button").play();
      game.changeState(new TitleState(game));
    }
  }
}
