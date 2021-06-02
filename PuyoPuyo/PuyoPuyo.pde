import java.util.*;
import javax.swing.JOptionPane;
import java.util.Map;

Game game;
HashMap<String,SoundFile> soundMap = new HashMap<String,SoundFile>(); 

void setup() {
  fullScreen();
  addSound("button", "SELECT.wav");
  addSound("normalOpening", "NormalOpening.wav");
  addSound("timerOpening", "TimerOpening.wav");
  addSound("fall", "Fall.wav");
  addSound("pop", "Pop.wav");
  addSound("levelUp", "LevelUp.wav");
  addSound("rotate", "Rotate.wav");
  addSound("move", "Move.wav");
  addSound("land", "Land.wav");
   
  game = new Game(soundMap);
  //frameRate(30);
  //size(1920, 1080);
}

void addSound(String name, String file) {
  soundMap.put(name, new SoundFile(this, file));
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
      game = new Game(soundMap);
    }
  } else {
    game.keyPressed();
    //System.out.println(keyCode);
  }
}

void mousePressed() {
  game.mousePressed();
}
