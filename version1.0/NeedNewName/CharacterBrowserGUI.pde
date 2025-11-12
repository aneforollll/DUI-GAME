// --- NEW: Import the sound library ---
import processing.sound.*;
// --- NEW: Import Java's File class to check for the "DLC" ---
import java.io.File;

// --- SCENE CONTROL --- //
String currentScene = "browser"; // can be "browser" or "battle"
CharacterBrowser characterBrowser;
BattleScene battleScene;

// --- NEW: Sound Variable (using SoundFile) ---
// This will remain 'null' if the DLC is not "installed"
SoundFile battleStartSfx;

void setup() {
  size(1280, 720);
  frameRate(10);
  
  // --- NEW "DLC" CHECKING LOGIC ---
  // We check if the file exists *before* trying to load it.
  // The "DLC" is the file itself.
  File dlcFile = new File(dataPath("battle_start.mp3"));

  if (dlcFile.exists()) {
    // "DLC" is installed! Load the sound.
    println("Battle transition 'DLC' found. Loading sound...");
    battleStartSfx = new SoundFile(this, "battle_start.mp3");
    
    if (battleStartSfx == null) {
      // This might happen if the file is corrupt
      println("  ...but it failed to load. Sound will be off.");
      battleStartSfx = null;
    }
  } else {
    // "DLC" is not installed. Do nothing.
    println("Battle transition 'DLC' not found. Sound will be off.");
    // battleStartSfx remains null, and no error is printed
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
        // --- Transition to next scene ---
        battleScene = new BattleScene(characterBrowser.mainCharacter, characterBrowser.partnerCharacter);
        currentScene = "battle";
        
        // --- THIS LOGIC IS NOW PERFECT ---
        // If battleStartSfx is null (because DLC is missing), this is skipped.
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

// --- UPDATED to handle battle clicks ---
void mousePressed() {
  if (currentScene.equals("browser")) {
    characterBrowser.handleMouseClick(mouseX, mouseY, mouseButton);
  } 
  else if (currentScene.equals("battle")) {
    // --- Pass click to battle scene ---
    battleScene.handleMouseClick(mouseX, mouseY);
  }
}

// --- Added for the slider ---
void mouseDragged() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseDrag(mouseX, mouseY);
  }
}

// --- Added for the slider ---
void mouseReleased() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseRelease();
  }
}

// Threaded image loader
void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}
