import processing.sound.*;
import java.io.File;


String currentScene = "browser";
CharacterBrowser characterBrowser;
BattleScene battleScene;


SoundFile battleStartSfx;

void setup() {
  size(1280, 720);
  frameRate(10);
  

  File dlcFile = new File(dataPath("battle_start.mp3"));

  if (dlcFile.exists()) {

    println("Battle transition 'DLC' found. Loading sound...");
    battleStartSfx = new SoundFile(this, "battle_start.mp3");
    
    if (battleStartSfx == null) {

      println("  ...but it failed to load. Sound will be off.");
      battleStartSfx = null;
    }
  } else {

    println("Battle transition 'DLC' not found. Sound will be off.");

  }
  
  characterBrowser = new CharacterBrowser();
  
  thread("loadAllSpriteImages_Threaded");
}

void draw() {
  if (currentScene.equals("browser")) {
    if (characterBrowser.isLoading) {
      background(50);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(32);
      text("Loading Sprites...", width/2, height/2);
    } else {
      characterBrowser.render();
      if (characterBrowser.readyForBattle) {
 
        battleScene = new BattleScene(characterBrowser.mainCharacter, characterBrowser.partnerCharacter);
        currentScene = "battle";
        
        if (battleStartSfx != null) {
          battleStartSfx.play();   
        }
      }
    }
  }
  else if (currentScene.equals("battle")) {
    battleScene.render();
  }
}

void mousePressed() {
  if (currentScene.equals("browser")) {
    characterBrowser.handleMouseClick(mouseX, mouseY, mouseButton);
  } 
  else if (currentScene.equals("battle")) {
   
    battleScene.handleMouseClick(mouseX, mouseY);
  }
}


void mouseDragged() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseDrag(mouseX, mouseY);
  }
}


void mouseReleased() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseRelease();
  }
}


void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}
