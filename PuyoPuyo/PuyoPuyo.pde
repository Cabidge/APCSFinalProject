import java.util.*;
import javax.swing.JOptionPane;
import java.util.Map;

Game game;
HashMap<String,SoundFile> soundMap = new HashMap<String,SoundFile>();

PImage[][] puyoSprites;

void setup() {
  fullScreen();
  addSound("button", "SELECT.wav");
  addSound("normalOpening", "NormalOpening.wav");
  addSound("timerOpening", "TimerOpening.wav");
  addSound("pop", "Pop.wav");
  addSound("levelUp", "LevelUp.wav");
  addSound("rotate", "Rotate.wav");
  addSound("move", "Move.wav");
  addSound("land", "Land.wav");
  
  puyoSprites = divideImage(loadImage("puyo_aqua.png"), 72, 72);
   
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

PImage[][] divideImage(PImage source, int w, int h) {
  int cols = source.width / w;
  int rows = source.height / h;
  PImage[][] sheet = new PImage[rows][cols];
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r < rows; r++) {
      sheet[r][c] = source.get(c * w, r * h, w, h);
    }
  }
  return sheet;
}
