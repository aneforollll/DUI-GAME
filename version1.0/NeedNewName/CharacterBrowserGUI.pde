// --- SCENE CONTROL --- //
String currentScene = "browser"; // can be "browser" or "battle"
CharacterBrowser characterBrowser;
BattleScene battleScene;

void setup() {
  size(1280, 720);
  frameRate(10);
  
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
    // --- NEW: Pass click to battle scene ---
    battleScene.handleMouseClick(mouseX, mouseY);
  }
}

// --- NEW: Added for the slider ---
void mouseDragged() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseDrag(mouseX, mouseY);
  }
}

// --- NEW: Added for the slider ---
void mouseReleased() {
  if (currentScene.equals("battle")) {
    battleScene.handleMouseRelease();
  }
}

// Threaded image loader
void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}
