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

void mousePressed() {
  if (currentScene.equals("browser")) {
    characterBrowser.handleMouseClick(mouseX, mouseY, mouseButton);
  }
}

// Threaded image loader
void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}
