import java.util.*;
import javax.swing.JOptionPane;
import java.util.Map;

Game game;
HashMap<String,SoundFile> soundMap = new HashMap<String,SoundFile>(); 

void setup() {
  fullScreen();
  soundMap.put("button", new SoundFile(this, "SELECT.wav"));
  soundMap.put("normalOpening", new SoundFile(this, "NormalOpening.wav"));
  soundMap.put("timerOpening", new SoundFile(this, "TimerOpening.wav"));
  game = new Game(soundMap);
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
