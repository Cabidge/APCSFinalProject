import javax.swing.JOptionPane;
Game game;

void setup() {
  game = new Game();
  //frameRate(30);
  size(1920, 1080);
}

void draw() {
  game.update();
  game.display();
}

void keyPressed() {
  if ((key == 'r' || key == 'R') && game.gamemode() != 0 && game.gamemode() != 3) {
    int response = JOptionPane.showConfirmDialog(null, "Are you sure you want to quit?");
    println(response);
    if(response ==0){
      game = new Game();
    }
  } else {
    game.keyPressed();
    //System.out.println(keyCode);
  }
}
