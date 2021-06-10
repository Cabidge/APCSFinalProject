import java.util.*;
import javax.swing.JOptionPane;
import java.util.Map;

Game game;
HashMap<String,SoundFile> soundMap = new HashMap<String,SoundFile>();

PImage[][] puyoSprites;
int currentSkin;
String[] skinNames = {
  "aqua",
  "beta",
  "block",
  "capsule",
  "classic",
  "degi",
  "fever",
  "gamegear",
  "human",
  "moji",
  "moro",
  "msx",
  "shiki",
  "sonic",
  "tetris"
};

void setup() {
  fullScreen();
  addSound("button", "SELECT.wav", true);
  addSound("normalOpening", "NormalOpening.wav", false, 0.25);
  addSound("timerOpening", "TimerOpening.wav", false, 0.25);
  addSound("pop", "Pop.wav", false, 0.9);
  addSound("levelUp", "LevelUp.wav", false, 0.75);
  addSound("rotate", "Rotate.wav", true, 0.7);
  addSound("move", "Move.wav");
  addSound("land", "Land.wav");
  
  reloadSkin();
  
  game = new Game(soundMap);
  
  SoundFile music = new SoundFile(this, "Music.wav");
  music.loop();
  music.amp(0.4);
  music.play();
  //frameRate(30);
  //size(1920, 1080);
}

void reloadSkin() {
  puyoSprites = divideImage(loadImage("puyo_"+skinNames[currentSkin]+".png"), 64, 60, 8, 12);
}

void addSound(String name, String file) {
  addSound(name, file, true);
}

void addSound(String name, String file, boolean cache) {
  addSound(name, file, cache, 1.0);
}

void addSound(String name, String file, boolean cache, float amp) {
  SoundFile s = new SoundFile(this, file, cache);
  s.amp(amp);
  soundMap.put(name, s);
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

PImage[][] divideImage(PImage source, int w, int h, int padX, int padY) {
  int dx = w+padX;
  int dy = h+padY;
  int cols = source.width / dx;
  int rows = source.height / dy;
  PImage[][] sheet = new PImage[rows][cols];
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r < rows; r++) {
      sheet[r][c] = source.get(c * dx, r * dy, w, h);
    }
  }
  return sheet;
}
