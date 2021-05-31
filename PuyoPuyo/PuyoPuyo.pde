import java.util.*;
import javax.swing.JOptionPane;

Game game;

void setup() {
  fullScreen();
  game = new Game();
  game.background = loadImage("PuyoPuyoBackground.jpeg");
  game.boardBackground = loadImage("BoardBackground.jpeg");
  //frameRate(30);
  //size(1920, 1080);
}

void draw() {
  
  game.update();
  game.display();
}

void keyPressed() {
  if ((key == 'r' || key == 'R')) {
    int response = JOptionPane.showConfirmDialog(null, "Are you sure you want to quit?");
    game.pmillis = millis();
    if(response == 0){
      game = new Game();
    }
  } else {
    game.keyPressed();
    //System.out.println(keyCode);
  }
}

void mousePressed() {
  game.mousePressed();
}
